library substrate_codec.address;

import 'dart:typed_data';
import 'package:bs58/bs58.dart' show base58;
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

class Defaults {
  static const allowedDecodedLengths = [1, 2, 4, 8, 32, 33];
  static const prefix = 42;
  static const ss58Prefix = "53533538505245";
}

Uint8List my_hexdecode(String hexStr) {
  return hex.decode((hexStr.length.isOdd ? '0' : '') + hexStr);
}

Uint8List sshash(Uint8List input) {
  final sink = blake2b.newSink();

  // Add any number of chunks
  sink.add(hex.decode(Defaults.ss58Prefix));
  sink.add(input);

  // Calculate the hash
  sink.close();

  return Uint8List.fromList(sink.hash.bytes);
}

String encodeAddress(Uint8List u8a, [int ss58Format = Defaults.prefix]) {
  assert(ss58Format >= 0 && ss58Format <= 16383 && ![46, 47].contains(ss58Format),
      'Out of range ss58Format specified');
  assert(Defaults.allowedDecodedLengths.contains(u8a.length),
      "Expected a valid key to convert, with length ${Defaults.allowedDecodedLengths}");

  // final input = u8aConcat(
  //   ss58Format < 64
  //     ? [ss58Format]
  //     : [
  //       ((ss58Format & 0b0000_0000_1111_1100) >> 2) | 0b0100_0000,
  //       (ss58Format >> 8) | ((ss58Format & 0b0000_0000_0000_0011) << 6)
  //     ],
  //   u8a
  // );
  var bytesBuilder = BytesBuilder();
  if (ss58Format < 64) {
    bytesBuilder.addByte(ss58Format);
  } else {
    bytesBuilder.add([
      ((ss58Format & 252 /*0b0000_0000_1111_1100*/) >> 2) | 64 /*0b0100_0000*/,
      (ss58Format >> 8) | ((ss58Format & 3 /*0b0000_0000_0000_0011*/) << 6)
    ]);
  }
  bytesBuilder.add(u8a);
  final input = bytesBuilder.toBytes();

  // return base58Encode(
  //   u8aConcat(
  //     input,
  //     sshash(input).subarray(0, [32, 33].includes(u8a.length) ? 2 : 1)
  //   )
  // );
  bytesBuilder = BytesBuilder();
  bytesBuilder.add(input);
  bytesBuilder.add(sshash(input).sublist(0, [32, 33].contains(u8a.length) ? 2 : 1));
  final bytes = bytesBuilder.toBytes();

  return base58.encode(bytes);
}

String publicKeyToAddress(String hexX, String hexY, [int ss58Format = Defaults.prefix]) {
  final plainKey = my_hexdecode(hexX) + my_hexdecode(hexY);

  return encodeAddress(plainKey, ss58Format);
}
