library substrate_codec.transaction;

import 'dart:async';
import 'dart:convert';
// import 'dart:io' show ContentType, HttpHeaders;
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:quiver/collection.dart';
import 'package:pointycastle/digests/blake2b.dart';
import 'package:http/http.dart' as http;
import 'package:substrate_codec/substrate_codec.dart';
// import 'package:sync_http/sync_http.dart';

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

  static Future<PolkaTransaction> deserialize(String payload, [String chain = 'Westend']) async {
    final response = await http.post(
      'http://localhost:3578/substrate/decode',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'signingPayload': '0x' + strip0x(payload),
        'metadata': 14,
        'chain': chain,
      }),
    );
    // final request = SyncHttpClient.postUrl(Uri.http('localhost:3578', '/substrate/decode'));
    // request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
    // request.write(json.encode({
    //   'signingPayload': '0x' + strip0x(payload),
    //   'metadata': 14,
    //   'chain': chain,
    // }));
    // request.headers.add(HttpHeaders.acceptHeader, 'application/json');
    // request.headers.add(HttpHeaders.cacheControlHeader, 'no-cache');

    // final response = request.close();
    // print(response.body);

    PolkaTransaction tx = new PolkaTransaction(strip0x(payload), json.decode(response.body));

    return tx;
  }

  Uint8List hashToSign() {
    final payloadU8a = hex.decode(strip0x(this['payload']).substring(2));
    final encodedPayload =
        payloadU8a.length > 256 ? Blake2bDigest(digestSize: 32).process(payloadU8a) : Uint8List.fromList(payloadU8a);
    return Blake2bDigest(digestSize: 32).process(encodedPayload);
  }
}
