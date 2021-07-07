library substrate_codec.transaction;

import 'dart:convert';
import 'dart:io' show ContentType, HttpHeaders;
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:quiver/collection.dart';
import 'package:pointycastle/digests/blake2b.dart';
import 'package:sync_http/sync_http.dart';

String strip0x(String hex) {
  if (hex.startsWith('0x')) return hex.substring(2);
  return hex;
}

class PolkaTransaction extends DelegatingMap {
  final delegate = new Map<String, dynamic>();

  PolkaTransaction(String payload, dynamic decoded) {
    this.delegate['payload'] = payload;

    if (decoded['code'] != 0) {
      return;
    }

    final result = decoded['result'];
    this.delegate['method'] = result['method'];
    this.delegate['tip'] = result['tip'];
    // print(this.delegate);
  }

  factory PolkaTransaction.deserialize(String payload) {
    final request = SyncHttpClient.postUrl(Uri.http('localhost:3000', '/substrate/decode'));
    request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
    request.write(json.encode({
      'signingPayload': '0x' + strip0x(payload),
    }));
    request.headers.add(HttpHeaders.acceptHeader, 'application/json');
    request.headers.add(HttpHeaders.cacheControlHeader, 'no-cache');

    final response = request.close();
    // print(response.body);

    PolkaTransaction tx = new PolkaTransaction(strip0x(payload), json.decode(response.body));

    return tx;
  }

  Uint8List hashToSign() {
    final hash = Blake2bDigest(digestSize: 32).process(hex.decode(this.delegate['payload']));
    print('${hex.encode(hash)}');
    return hash;
  }
}
