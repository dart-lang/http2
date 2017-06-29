// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library http2.test.end2end_test;

import 'dart:async';

import 'package:test/test.dart';

import 'package:http2/transport.dart';
import 'package:http2/src/frames/frames.dart';
import 'package:http2/src/settings/settings.dart';

expectHeadersEqual(List<Header> headers, List<Header> expectedHeaders) {
  expect(headers, hasLength(expectedHeaders.length));
  for (int i = 0; i < expectedHeaders.length; i++) {
    expect(headers[i].name, expectedHeaders[i].name);
    expect(headers[i].value, expectedHeaders[i].value);
  }
}

expectEmptyStream(Stream s) {
  s.listen(expectAsync1((_) {}, count: 0), onDone: expectAsync0(() {}));
}

streamTest(String name, func(client, server), {ClientSettings settings}) {
  return test(name, () {
    var bidirect = new BidirectionalConnection();
    bidirect.settings = settings;
    var client = bidirect.clientConnection;
    var server = bidirect.serverConnection;
    return func(client, server);
  });
}

framesTest(String name, func(frameWriter, frameStream)) {
  return test(name, () {
    var c = new StreamController();
    var fw = new FrameWriter(null, c, new ActiveSettings());
    var frameStream = new FrameReader(c.stream, new ActiveSettings());

    return func(fw, frameStream);
  });
}

class BidirectionalConnection {
  ClientSettings settings;
  final StreamController<List<int>> writeA = new StreamController();
  final StreamController<List<int>> writeB = new StreamController();
  Stream<List<int>> get readA => writeA.stream;
  Stream<List<int>> get readB => writeB.stream;

  ClientTransportConnection get clientConnection
      => new ClientTransportConnection.viaStreams(
          readA, writeB, settings: settings);

  ServerTransportConnection get serverConnection
      => new ServerTransportConnection.viaStreams(readB, writeA);
}
