library substrate_codec_test.address_test;

import 'package:substrate_codec/substrate_codec.dart';
import 'package:test/test.dart';

void main() {
  test("test", () {
    // final rawPayload =
    //     "0x0500913d5f22d531d1ab7f7ec337f50a5e856e83d2c145f009f0b23514c088f86a270700e40b5402001800160000000400000097094e6fb7fb6066cacbf47074a16ce8d4f38a9d02493635f543e2da6d20d57597094e6fb7fb6066cacbf47074a16ce8d4f38a9d02493635f543e2da6d20d575";
    // final rawPayload =
    //     "0x5d028400fcc4910cb536b4333db4bccb40e2cf6427b4766518e754b91e70c97e4a87dbb300d99ffe3e610ad234e1414bda5831395a6df9098bf80b01561ce89a5065ae89d5c10e1619c6c99131b0bea4fb73ef04d07c07770e2ae9df5c325c331769ccb300a90b11010700ac23fc06060000495e1e506f266418af07fa0c5c108dd436f2faa59fe7d9e54403779f5bbd77180bc01eb1fc185f";
    final rawPayload =
        "a4040000e9cd2a1848079a5d34669b15fa3e3d969562814719981f6aee26b29288915e360700e40b5402750204006e23000005000000e143f23803ac50e8f6f8e62695d1ce9e4e1d68aa36c1cd2cfd15340213f3423ee5eb8c9f857d9cdb10c1c86a80d18cefea40d7c1586e3cb64bf7a1af6f206f23";
    final tx = PolkaTransaction.deserialize(rawPayload);
    tx.hashToSign();
    expect(1, 1);
  });
}
