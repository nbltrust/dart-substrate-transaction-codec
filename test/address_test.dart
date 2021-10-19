library substrate_codec_test.address_test;

import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:substrate_codec/substrate_codec.dart';

const SUBKEY = [
  {
    // substrate default
    "address": '5DA4D4GL5iakrn22h5uKoevgvo18Pqj5BcdEUv8etEDPdijA',
    "publicKey": '3050f8456519829fe03302da802d22d3233a5f4037b9a3e2bcc403ccfcb2d735',
    "ss58Format": 42
  },
  {
    // aventus
    "address": 'cLtA6nCDyvwKcEHH4QkZDSHMhS9s78BvUJUsKUbUAn1Jc2SCF',
    "publicKey": '08e8969768fc14399930d4b8d693f68a2ff6c6a597325d6946095e5e9d9d1b0e',
    "ss58Format": 65
  },
  {
    // crust
    "address": 'cTGShekJ1L1UKFZR9xmv9UTJod7vqjFAPo4sDhXih2c3y1yLS',
    "publicKey": '04a047d52fe542484c69bc528990cfeaf3a663dded0638ee1b51cf78bacd1072',
    "ss58Format": 66
  },
  {
    // sora
    "address": 'cnVRwXfAnz3RSVQyBUC8f8McrK3YBX2QYd4WoctpeSC6VTJYm',
    "publicKey": 'ae640d53cfa815f4a6a50ae70235cd7d9d134d0f1c3a4ccd118e321dfb6ab51f',
    "ss58Format": 69
  },
  {
    // ecdsa
    "address": '4pbsSkWcBaYoFHrKJZp5fDVUKbqSYD9dhZZGvpp3vQ5ysVs5ybV',
    "publicKey": '035676109c54b9a16d271abeb4954316a40a32bcce023ac14c8e26e958aa68fba9',
    "ss58Format": 200
  },
  {
    // social-network
    "address": 'xw5g1Eec8LT99pZLZMaTWwrwvNtfM6vrSuZeVbtEszCDUwByg',
    "publicKey": '5c64f1151f0ce4358c27238fb20c88e7c899825436f565410724c8c2c5add869',
    "ss58Format": 252
  },
  {
    "address": 'yGF4JP7q5AK46d1FPCEm9sYQ4KooSjHMpyVAjLnsCSWVafPnf',
    "publicKey": '66cd6cf085627d6c85af1aaf2bd10cf843033e929b4e3b1c2ba8e4aa46fe111b',
    "ss58Format": 255
  },
  {
    "address": 'yGDYxQatQwuxqT39Zs4LtcTnpzE12vXb7ZJ6xpdiHv6gTu1hF',
    "publicKey": '242fd5a078ac6b7c3c2531e9bcf1314343782aeb58e7bc6880794589e701db55',
    "ss58Format": 255
  },
  {
    "address": 'mHm8k9Emsvyfp3piCauSH684iA6NakctF8dySQcX94GDdrJrE',
    "publicKey": '44d5a3ac156335ea99d33a83c57c7146c40c8e2260a8a4adf4e7a86256454651',
    "ss58Format": 4242
  },
  {
    "address": 'r6Gr4gaMP8TsjhFbqvZhv3YvnasugLiRJpzpRHifsqqG18UXa',
    "publicKey": '88f01441682a17b52d6ae12d1a5670cf675fd254897efabaa5069eb3a701ab73',
    "ss58Format": 14269
  }
];

void main() {
  SUBKEY.asMap().forEach((index, value) {
    test("encodes with Subkey equality (${index} - ${value["ss58Format"]})", () {
      final addr = encodeAddress(hex.decode(value["publicKey"]), value["ss58Format"]);
      print(addr);

      expect(addr, value["address"]);
    });
  });

  test("publicKeyToAddress", () {
    final addr = encodeAddress(hex.decode('4de38cd2ece2d02237534c8498610e78a4dc0db1a2c61abf1d642009636e6fbe'), 42);
    print(addr);

    // print(Blake2bHash.hashWithDigestSize(512, Uint8List.fromList(utf8.encode('abc'))));
    // // final Blake2b blake2b = Blake2b(digestLength: 64);
    // // blake2b.update(Uint8List.fromList([10, 188]));
    // // print(blake2b.digest());
    // final digest = Blake2bDigest(digestSize: 64).process(Uint8List.fromList(utf8.encode('abc')));
    // print(digest);
    // new Digest("Blake2b")

    final addr1 = publicKeyToAddress('5ed6d1440bb1c8c79ccfe315e511b8cb4c2af011169b34fa8205bb8d5af9c426',
        '0d222860186356b67f194570b45af6e1e2de7842d9edbd061c4c78d76b360f49', 42);
    print(addr1);

    assert(addr1 == addr);
  });
}
