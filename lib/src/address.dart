library substrate_codec.address;

import 'dart:typed_data';
import 'package:bs58/bs58.dart' show base58;
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/digests/blake2b.dart';
import 'package:substrate_codec/substrate_codec.dart';

class Defaults {
  static const allowedDecodedLengths = [1, 2, 4, 8, 32, 33];
  static const prefix = 42;
  static const ss58Prefix = "53533538505245";
}

Uint8List my_hexdecode(String hexStr) {
  return Uint8List.fromList(hex.decode((hexStr.length.isOdd ? '0' : '') + hexStr));
}

Future<Uint8List> sshash(Uint8List input) async{
  final sink = Blake2b().newHashSink();

  // Add any number of chunks
  sink.add(hex.decode(Defaults.ss58Prefix));
  sink.add(input);

  // Calculate the hash
  sink.close();
  final hash = await sink.hash();
  return Uint8List.fromList(hash.bytes);
}

Future<String> encodeAddress(Uint8List u8a, [int ss58Format = Defaults.prefix]) async{
  assert(ss58Format >= 0 && ss58Format <= 16383 && ![46, 47].contains(ss58Format), 'Out of range ss58Format specified');
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
  final r =  await sshash(input);
  bytesBuilder.add(r.sublist(0, [32, 33].contains(u8a.length) ? 2 : 1));
  final bytes = bytesBuilder.toBytes();

  return base58.encode(bytes);
}

Uint8List blake2AsU8a(Uint8List data, {int bitLength = 256}) {
  final digestSize = (bitLength / 8).ceil();
  return Blake2bDigest(digestSize: digestSize).process(data);
}

Future<String> publicKeyToAddress(String hexX, String hexY, [int ss58Format = Defaults.prefix]) async{
  final y = BigInt.parse(hexY, radix: 16);
  final compressedKey = (y.isEven ? [2] : [3]) + my_hexdecode(hexX);

  // print('compressedKey: ${hex.encode(compressedKey)}');

  final publicKeyU8A = blake2AsU8a(Uint8List.fromList(compressedKey));
  // print('publicKeyU8A: $publicKeyU8A');

  return await encodeAddress(publicKeyU8A, ss58Format);
}

Future<bool> verifyAddress(String pubkey, String address, [int ss58Format = Defaults.prefix]) async{
  pubkey = strip0x(pubkey);

  if (pubkey.length <= 64) {
    try {
      final publicKeyU8A = my_hexdecode(pubkey);
      final addr = await encodeAddress(publicKeyU8A, ss58Format);
      if (addr == address) return true;
    } catch (e) {
      //
    }

    try {
      final compressedKey = [2] + my_hexdecode(pubkey);
      final publicKeyU8A = blake2AsU8a(Uint8List.fromList(compressedKey));
      final addr = await encodeAddress(publicKeyU8A, ss58Format);
      if (addr == address) return true;
    } catch (e) {
      //
    }

    try {
      final compressedKey = [3] + my_hexdecode(pubkey);
      final publicKeyU8A = blake2AsU8a(Uint8List.fromList(compressedKey));
      final addr = await encodeAddress(publicKeyU8A, ss58Format);
      return addr == address;
    } catch (e) {
      //
    }
  } else {
    try {
      final pka = await publicKeyToAddress(pubkey.substring(0, 64), pubkey.substring(64), ss58Format);
      return pka == address;
    } catch (e) {
      //
    }
  }

  return false;
}
