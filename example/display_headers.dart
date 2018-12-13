import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http2/transport.dart';

main(List<String> args) async {
  String uriArg;
  if (args.length != 1) {
    print('Usage: dart display_headers.dart <HTTPS_URI>');
  }
  if (args.length == 0) {
    uriArg = 'https://www.google.com/';
    print("Assuming URI: '$uriArg'");
  } else if (args.length > 1) {
    exit(1);
  } else {
    uriArg = args[0];
  }

  if (!uriArg.startsWith('https://')) {
    print('URI must start with https://');
    exit(1);
  }

  var uri = Uri.parse(uriArg);

  Socket socket = await connect(uri);

  // The default client settings will disable server pushes. We
  // therefore do not need to deal with [stream.peerPushes].
  var transport = new ClientTransportConnection.viaSocket(socket);

  var headers = <Header>[
    Header.ascii(':method', 'GET'),
    Header.ascii(':path', uri.path),
    Header.ascii(':scheme', uri.scheme),
    Header.ascii(':authority', uri.host),
  ];

  ClientTransportStream stream =
      transport.makeRequest(headers, endStream: true);
  await for (var message in stream.incomingMessages) {
    if (message is HeadersStreamMessage) {
      for (var header in message.headers) {
        var name = utf8.decode(header.name);
        var value = utf8.decode(header.value);
        print('Header: $name: $value');
      }
    } else if (message is DataStreamMessage) {
      print('DatastreamMessage: ${message.bytes.length} bytes');
    }
  }
  await transport.finish();
}

Future<Socket> connect(Uri uri) async {
  bool useSSL = uri.scheme == 'https';
  if (useSSL) {
    var secureSocket = await SecureSocket.connect(uri.host, uri.port,
        supportedProtocols: ['h2']);
    if (secureSocket.selectedProtocol != 'h2') {
      throw new Exception("Failed to negogiate http/2 via alpn. Maybe server "
          "doesn't support http/2.");
    }
    return secureSocket;
  } else {
    return await Socket.connect(uri.host, uri.port);
  }
}
