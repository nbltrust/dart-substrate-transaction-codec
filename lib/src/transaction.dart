library substrate_codec.transaction;

import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:quiver/collection.dart';
import 'package:pointycastle/digests/blake2b.dart';

class PolkaTransaction extends DelegatingMap {
  final delegate = new Map<String, dynamic>();

  PolkaTransaction(String payload) {
    this.delegate['payload'] = payload;
    // this.delegate['era'] = extrinsics.era.toJson();
    // this.delegate['nonce'] = extrinsics.nonce.toJson();
    // this.delegate['tip'] = extrinsics.tip.toJson();
    // this.delegate['callIndex'] = [extrinsics.call.module_index, extrinsics.call.function_index];
    // this.delegate['args'] = extrinsics.call.argValues.map((k, v) => MapEntry(k, v.toJson()));
    // print(this.delegate);
  }

  factory PolkaTransaction.deserialize(String payload) {
    PolkaTransaction tx = new PolkaTransaction(payload);

    return tx;
  }

  Uint8List hashToSign() {
    final hash = Blake2bDigest(digestSize: 32).process(hex.decode(this.delegate['payload']));
    print('${hex.encode(hash)}');
    return hash;
  }
}
