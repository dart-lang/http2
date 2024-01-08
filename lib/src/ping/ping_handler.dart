// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../error_handler.dart';
import '../frames/frames.dart';
import '../sync_errors.dart';

/// Responsible for pinging the other end and for handling pings from the
/// other end.
// TODO: We currently write unconditionally to the [FrameWriter]: we might want
// to consider be more aware what [Framewriter.bufferIndicator.wouldBuffer]
// says.
int eventNumber = 0;

class PingHandler extends Object with TerminatableMixin {
  final FrameWriter _frameWriter;
  final Map<int, Completer> _remainingPings = {};
  final Function(int)? pingReceived;
  int _nextId = 1;
  late bool client;

  PingHandler(this._frameWriter, [this.pingReceived, this.client = false]);

  @override
  void onTerminated(Object? error) {
    print(
        '${eventNumber++}: Terminating ${client ? 'client' : 'server'} with remaining: ${_remainingPings.length}');
    var values = _remainingPings.values.toList();
    _remainingPings.clear();
    for (var value in values) {
      value.completeError(error ?? 'Unspecified error');
    }
  }

  void processPingFrame(PingFrame frame) {
    ensureNotTerminatedSync(() {
      if (frame.header.streamId != 0) {
        throw ProtocolException('Ping frames must have a stream id of 0.');
      }
      print(
          '${eventNumber++}: Received ${frame.hasAckFlag ? 'ack' : 'ping'} in ${client ? 'client' : 'server'}, id: ${frame.opaqueData}, remaining: ${_remainingPings.length}');
      if (!frame.hasAckFlag) {
        print('Sending ack ping from ${client ? 'client' : 'server'}');
        // print(
        //     'Call ping received on $pingReceived with data ${frame.opaqueData}');
        pingReceived?.call(frame.opaqueData);
        _frameWriter.writePingFrame(frame.opaqueData, ack: true);
      } else {
        var c = _remainingPings.remove(frame.opaqueData);
        if (c != null) {
          c.complete();
        } else {
          // NOTE: It is not specified what happens when one gets an ACK for a
          // ping we never sent. We be very strict and fail in this case.
          throw ProtocolException(
              'Received ping ack with unknown opaque data.');
        }
      }
    });
  }

  Future ping() {
    print('Client was terminated: $wasTerminated');
    return ensureNotTerminatedAsync(() {
      var c = Completer();
      var id = _nextId++;
      _remainingPings[id] = c;
      _frameWriter.writePingFrame(id);
      print(
          '${eventNumber++}: Added ping $id in ${client ? 'client' : 'server'} to list, remaining: ${_remainingPings.length}');
      return c.future;
    });
  }
}
