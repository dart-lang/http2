// Mocks generated by Mockito 5.0.15 from annotations
// in http2/test/src/flowcontrol/mocks.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:http2/src/async_utils/async_utils.dart' as _i2;
import 'package:http2/src/flowcontrol/connection_queues.dart' as _i7;
import 'package:http2/src/flowcontrol/queue_messages.dart' as _i8;
import 'package:http2/src/flowcontrol/stream_queues.dart' as _i10;
import 'package:http2/src/flowcontrol/window_handler.dart' as _i3;
import 'package:http2/src/frames/frames.dart' as _i4;
import 'package:http2/src/hpack/hpack.dart' as _i6;
import 'package:http2/transport.dart' as _i11;
import 'package:mockito/mockito.dart' as _i1;

import 'mocks.dart' as _i9;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeBufferIndicator_0 extends _i1.Fake implements _i2.BufferIndicator {}

class _FakeIncomingWindowHandler_1 extends _i1.Fake
    implements _i3.IncomingWindowHandler {}

/// A class which mocks [FrameWriter].
///
/// See the documentation for Mockito's code generation for more information.
class MockFrameWriter extends _i1.Mock implements _i4.FrameWriter {
  MockFrameWriter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.BufferIndicator get bufferIndicator =>
      (super.noSuchMethod(Invocation.getter(#bufferIndicator),
          returnValue: _FakeBufferIndicator_0()) as _i2.BufferIndicator);
  @override
  int get highestWrittenStreamId =>
      (super.noSuchMethod(Invocation.getter(#highestWrittenStreamId),
          returnValue: 0) as int);
  @override
  _i5.Future<dynamic> get doneFuture =>
      (super.noSuchMethod(Invocation.getter(#doneFuture),
          returnValue: Future<dynamic>.value()) as _i5.Future<dynamic>);
  @override
  void writeDataFrame(int? streamId, List<int>? data,
          {bool? endStream = false}) =>
      super.noSuchMethod(
          Invocation.method(
              #writeDataFrame, [streamId, data], {#endStream: endStream}),
          returnValueForMissingStub: null);
  @override
  void writeHeadersFrame(int? streamId, List<_i6.Header>? headers,
          {bool? endStream = true}) =>
      super.noSuchMethod(
          Invocation.method(
              #writeHeadersFrame, [streamId, headers], {#endStream: endStream}),
          returnValueForMissingStub: null);
  @override
  void writePriorityFrame(int? streamId, int? streamDependency, int? weight,
          {bool? exclusive = false}) =>
      super.noSuchMethod(
          Invocation.method(#writePriorityFrame,
              [streamId, streamDependency, weight], {#exclusive: exclusive}),
          returnValueForMissingStub: null);
  @override
  void writeRstStreamFrame(int? streamId, int? errorCode) => super.noSuchMethod(
      Invocation.method(#writeRstStreamFrame, [streamId, errorCode]),
      returnValueForMissingStub: null);
  @override
  void writeSettingsFrame(List<_i4.Setting>? settings) =>
      super.noSuchMethod(Invocation.method(#writeSettingsFrame, [settings]),
          returnValueForMissingStub: null);
  @override
  void writeSettingsAckFrame() =>
      super.noSuchMethod(Invocation.method(#writeSettingsAckFrame, []),
          returnValueForMissingStub: null);
  @override
  void writePushPromiseFrame(
          int? streamId, int? promisedStreamId, List<_i6.Header>? headers) =>
      super.noSuchMethod(
          Invocation.method(
              #writePushPromiseFrame, [streamId, promisedStreamId, headers]),
          returnValueForMissingStub: null);
  @override
  void writePingFrame(int? opaqueData, {bool? ack = false}) =>
      super.noSuchMethod(
          Invocation.method(#writePingFrame, [opaqueData], {#ack: ack}),
          returnValueForMissingStub: null);
  @override
  void writeGoawayFrame(
          int? lastStreamId, int? errorCode, List<int>? debugData) =>
      super.noSuchMethod(
          Invocation.method(
              #writeGoawayFrame, [lastStreamId, errorCode, debugData]),
          returnValueForMissingStub: null);
  @override
  void writeWindowUpdate(int? sizeIncrement, {int? streamId = 0}) =>
      super.noSuchMethod(
          Invocation.method(
              #writeWindowUpdate, [sizeIncrement], {#streamId: streamId}),
          returnValueForMissingStub: null);
  @override
  _i5.Future<dynamic> close() =>
      (super.noSuchMethod(Invocation.method(#close, []),
          returnValue: Future<dynamic>.value()) as _i5.Future<dynamic>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [IncomingWindowHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockIncomingWindowHandler extends _i1.Mock
    implements _i3.IncomingWindowHandler {
  MockIncomingWindowHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get localWindowSize =>
      (super.noSuchMethod(Invocation.getter(#localWindowSize), returnValue: 0)
          as int);
  @override
  void gotData(int? numberOfBytes) =>
      super.noSuchMethod(Invocation.method(#gotData, [numberOfBytes]),
          returnValueForMissingStub: null);
  @override
  void dataProcessed(int? numberOfBytes) =>
      super.noSuchMethod(Invocation.method(#dataProcessed, [numberOfBytes]),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [OutgoingStreamWindowHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockOutgoingStreamWindowHandler extends _i1.Mock
    implements _i3.OutgoingStreamWindowHandler {
  MockOutgoingStreamWindowHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.BufferIndicator get positiveWindow =>
      (super.noSuchMethod(Invocation.getter(#positiveWindow),
          returnValue: _FakeBufferIndicator_0()) as _i2.BufferIndicator);
  @override
  int get peerWindowSize =>
      (super.noSuchMethod(Invocation.getter(#peerWindowSize), returnValue: 0)
          as int);
  @override
  void processInitialWindowSizeSettingChange(int? difference) =>
      super.noSuchMethod(
          Invocation.method(
              #processInitialWindowSizeSettingChange, [difference]),
          returnValueForMissingStub: null);
  @override
  void processWindowUpdate(_i4.WindowUpdateFrame? frame) =>
      super.noSuchMethod(Invocation.method(#processWindowUpdate, [frame]),
          returnValueForMissingStub: null);
  @override
  void decreaseWindow(int? numberOfBytes) =>
      super.noSuchMethod(Invocation.method(#decreaseWindow, [numberOfBytes]),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [ConnectionMessageQueueOut].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectionMessageQueueOut extends _i1.Mock
    implements _i7.ConnectionMessageQueueOut {
  MockConnectionMessageQueueOut() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get pendingMessages =>
      (super.noSuchMethod(Invocation.getter(#pendingMessages), returnValue: 0)
          as int);
  @override
  bool get wasTerminated =>
      (super.noSuchMethod(Invocation.getter(#wasTerminated), returnValue: false)
          as bool);
  @override
  _i5.Future<dynamic> get done => (super.noSuchMethod(Invocation.getter(#done),
      returnValue: Future<dynamic>.value()) as _i5.Future<dynamic>);
  @override
  bool get isClosing =>
      (super.noSuchMethod(Invocation.getter(#isClosing), returnValue: false)
          as bool);
  @override
  bool get wasClosed =>
      (super.noSuchMethod(Invocation.getter(#wasClosed), returnValue: false)
          as bool);
  @override
  void enqueueMessage(_i8.Message? message) =>
      super.noSuchMethod(Invocation.method(#enqueueMessage, [message]),
          returnValueForMissingStub: null);
  @override
  void onTerminated(Object? error) =>
      super.noSuchMethod(Invocation.method(#onTerminated, [error]),
          returnValueForMissingStub: null);
  @override
  void onCheckForClose() =>
      super.noSuchMethod(Invocation.method(#onCheckForClose, []),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
  @override
  void terminate([dynamic error]) =>
      super.noSuchMethod(Invocation.method(#terminate, [error]),
          returnValueForMissingStub: null);
  @override
  T ensureNotTerminatedSync<T>(T Function()? f) =>
      (super.noSuchMethod(Invocation.method(#ensureNotTerminatedSync, [f]),
          returnValue: _i9.ensureNotTerminatedSyncFallback<T>(f)) as T);
  @override
  _i5.Future<dynamic> ensureNotTerminatedAsync(
          _i5.Future<dynamic> Function()? f) =>
      (super.noSuchMethod(Invocation.method(#ensureNotTerminatedAsync, [f]),
          returnValue: Future<dynamic>.value()) as _i5.Future<dynamic>);
  @override
  void startClosing() =>
      super.noSuchMethod(Invocation.method(#startClosing, []),
          returnValueForMissingStub: null);
  @override
  void onClosing() => super.noSuchMethod(Invocation.method(#onClosing, []),
      returnValueForMissingStub: null);
  @override
  dynamic ensureNotClosingSync(dynamic Function()? f) =>
      super.noSuchMethod(Invocation.method(#ensureNotClosingSync, [f]));
  @override
  void closeWithValue([dynamic value]) =>
      super.noSuchMethod(Invocation.method(#closeWithValue, [value]),
          returnValueForMissingStub: null);
  @override
  void closeWithError(dynamic error) =>
      super.noSuchMethod(Invocation.method(#closeWithError, [error]),
          returnValueForMissingStub: null);
}

/// A class which mocks [StreamMessageQueueIn].
///
/// See the documentation for Mockito's code generation for more information.
class MockStreamMessageQueueIn extends _i1.Mock
    implements _i10.StreamMessageQueueIn {
  MockStreamMessageQueueIn() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.IncomingWindowHandler get windowHandler =>
      (super.noSuchMethod(Invocation.getter(#windowHandler),
              returnValue: _FakeIncomingWindowHandler_1())
          as _i3.IncomingWindowHandler);
  @override
  _i2.BufferIndicator get bufferIndicator =>
      (super.noSuchMethod(Invocation.getter(#bufferIndicator),
          returnValue: _FakeBufferIndicator_0()) as _i2.BufferIndicator);
  @override
  int get pendingMessages =>
      (super.noSuchMethod(Invocation.getter(#pendingMessages), returnValue: 0)
          as int);
  @override
  _i5.Stream<_i11.StreamMessage> get messages =>
      (super.noSuchMethod(Invocation.getter(#messages),
              returnValue: Stream<_i11.StreamMessage>.empty())
          as _i5.Stream<_i11.StreamMessage>);
  @override
  _i5.Stream<_i11.TransportStreamPush> get serverPushes =>
      (super.noSuchMethod(Invocation.getter(#serverPushes),
              returnValue: Stream<_i11.TransportStreamPush>.empty())
          as _i5.Stream<_i11.TransportStreamPush>);
  @override
  bool get wasTerminated =>
      (super.noSuchMethod(Invocation.getter(#wasTerminated), returnValue: false)
          as bool);
  @override
  _i5.Future<dynamic> get done => (super.noSuchMethod(Invocation.getter(#done),
      returnValue: Future<dynamic>.value()) as _i5.Future<dynamic>);
  @override
  bool get isClosing =>
      (super.noSuchMethod(Invocation.getter(#isClosing), returnValue: false)
          as bool);
  @override
  bool get wasClosed =>
      (super.noSuchMethod(Invocation.getter(#wasClosed), returnValue: false)
          as bool);
  @override
  _i5.Future<void> get onCancel =>
      (super.noSuchMethod(Invocation.getter(#onCancel),
          returnValue: Future<void>.value()) as _i5.Future<void>);
  @override
  bool get wasCancelled =>
      (super.noSuchMethod(Invocation.getter(#wasCancelled), returnValue: false)
          as bool);
  @override
  void enqueueMessage(_i8.Message? message) =>
      super.noSuchMethod(Invocation.method(#enqueueMessage, [message]),
          returnValueForMissingStub: null);
  @override
  void onTerminated(Object? exception) =>
      super.noSuchMethod(Invocation.method(#onTerminated, [exception]),
          returnValueForMissingStub: null);
  @override
  void onCloseCheck() =>
      super.noSuchMethod(Invocation.method(#onCloseCheck, []),
          returnValueForMissingStub: null);
  @override
  void forceDispatchIncomingMessages() =>
      super.noSuchMethod(Invocation.method(#forceDispatchIncomingMessages, []),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
  @override
  void terminate([dynamic error]) =>
      super.noSuchMethod(Invocation.method(#terminate, [error]),
          returnValueForMissingStub: null);
  @override
  T ensureNotTerminatedSync<T>(T Function()? f) =>
      (super.noSuchMethod(Invocation.method(#ensureNotTerminatedSync, [f]),
          returnValue: _i9.ensureNotTerminatedSyncFallback<T>(f)) as T);
  @override
  _i5.Future<dynamic> ensureNotTerminatedAsync(
          _i5.Future<dynamic> Function()? f) =>
      (super.noSuchMethod(Invocation.method(#ensureNotTerminatedAsync, [f]),
          returnValue: Future<dynamic>.value()) as _i5.Future<dynamic>);
  @override
  void startClosing() =>
      super.noSuchMethod(Invocation.method(#startClosing, []),
          returnValueForMissingStub: null);
  @override
  void onCheckForClose() =>
      super.noSuchMethod(Invocation.method(#onCheckForClose, []),
          returnValueForMissingStub: null);
  @override
  void onClosing() => super.noSuchMethod(Invocation.method(#onClosing, []),
      returnValueForMissingStub: null);
  @override
  dynamic ensureNotClosingSync(dynamic Function()? f) =>
      super.noSuchMethod(Invocation.method(#ensureNotClosingSync, [f]));
  @override
  void closeWithValue([dynamic value]) =>
      super.noSuchMethod(Invocation.method(#closeWithValue, [value]),
          returnValueForMissingStub: null);
  @override
  void closeWithError(dynamic error) =>
      super.noSuchMethod(Invocation.method(#closeWithError, [error]),
          returnValueForMissingStub: null);
  @override
  void cancel() => super.noSuchMethod(Invocation.method(#cancel, []),
      returnValueForMissingStub: null);
}
