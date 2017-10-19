// Copyright (c) 2016 the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library http2.artificial_server_socket;

import 'dart:async';
import 'dart:io';

/// Custom implementation of the [ServerSocket] interface.
///
/// This class can be used to create a [ServerSocket] using [Stream<Socket>] and
/// a [InternetAddress] and `port` (an example use case is to filter [Socket]s
/// and keep the [ServerSocket] interface for APIs that expect it,
/// e.g. `new HttpServer.listenOn()`).
class ArtificialServerSocket extends Object
    with StreamMethodsMixin<Socket>
    implements ServerSocket {
  final Stream<Socket> _stream;

  ArtificialServerSocket(this.address, this.port, this._stream);

  // ########################################################################
  // These are the methods of [ServerSocket] in addition to [Stream<Socket>].
  // ########################################################################

  final InternetAddress address;

  final int port;

  /// Closing of an [ArtificialServerSocket] is not possible and an exception
  /// will be thrown when calling this method.
  Future<ServerSocket> close() async {
    throw new Exception("Did not expect close() to be called.");
  }
}

/// A mixin used to implement the [Stream] interface.
///
/// This class can be used as a mixin and will delegate all methods on [Stream]
/// to another [_stream] instance.
abstract class StreamMethodsMixin<T> implements Stream<T> {
  Stream<T> get _stream;

  Future<bool> any(bool test(T element)) => _stream.any(test);

  Stream<T> asBroadcastStream(
      {void onListen(StreamSubscription<T> subscription),
      void onCancel(StreamSubscription<T> subscription)}) {
    return _stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  Stream<E> asyncExpand<E>(Stream<E> convert(T value)) =>
      _stream.asyncExpand(convert);

  Stream<E> asyncMap<E>(FutureOr<E> convert(T event)) =>
      _stream.asyncMap(convert);

  Future<bool> contains(Object needle) => _stream.contains(needle);

  Stream<T> distinct([bool equals(T previous, T next)]) {
    return _stream.distinct(equals);
  }

  Future<T> drain<T>([T futureValue]) => _stream.drain();

  Future<T> elementAt(int index) => _stream.elementAt(index);

  Future<bool> every(bool test(T item)) => _stream.every(test);

  Stream<S> expand<S>(Iterable<S> convert(T item)) => _stream.expand(convert);

  Future<T> get first => _stream.first;

  Future firstWhere(bool test(T element), {Object defaultValue()}) {
    return _stream.firstWhere(test);
  }

  Future<S> fold<S>(S initialValue, S combine(S previous, T element)) {
    return _stream.fold<S>(initialValue, combine);
  }

  Future forEach(void action(T element)) => _stream.forEach(action);

  Stream<T> handleError(Function onError, {bool test(error)}) {
    return _stream.handleError(onError, test: test);
  }

  bool get isBroadcast => _stream.isBroadcast;

  Future<bool> get isEmpty => _stream.isEmpty;

  Future<String> join([String separator = ""]) => _stream.join(separator);

  Future<T> get last => _stream.last;

  Future lastWhere(bool test(T element), {Object defaultValue()}) {
    return _stream.lastWhere(test, defaultValue: defaultValue);
  }

  Future<int> get length => _stream.length;

  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Stream<S> map<S>(S convert(T event)) => _stream.map(convert);

  Future pipe(StreamConsumer<T> consumer) => _stream.pipe(consumer);

  Future<T> reduce(T combine(T previous, T element)) => _stream.reduce(combine);

  Future<T> get single => _stream.single;

  Future<T> singleWhere(bool test(T item)) => _stream.singleWhere(test);

  Stream<T> skip(int count) => _stream.skip(count);

  Stream<T> skipWhile(bool test(T item)) => _stream.skipWhile(test);

  Stream<T> take(int count) => _stream.take(count);

  Stream<T> takeWhile(bool test(T item)) => _stream.takeWhile(test);

  Stream<T> timeout(Duration timeLimit, {void onTimeout(EventSink<T> sink)}) =>
      _stream.timeout(timeLimit, onTimeout: onTimeout);

  Future<List<T>> toList() => _stream.toList();

  Future<Set<T>> toSet() => _stream.toSet();

  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _stream.transform(streamTransformer);

  Stream<T> where(bool test(T value)) => _stream.where(test);
}
