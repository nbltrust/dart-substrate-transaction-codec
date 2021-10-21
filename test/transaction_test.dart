library substrate_codec_test.address_test;

import 'package:convert/convert.dart';
import 'package:substrate_codec/substrate_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test deserialize tx", () {
    final rawPayload =
        "0xa00503da04de6cd781c98acf0693dfb97c11011938ad22fcc476ed0089ac5aec3fe243070088526a74e5000800fb03000001000000e3777fa922cafbff200cadeaea1a76bd7898ad5b89f7848999058b50e715f6361fc7493f3c1e9ac758a183839906475f8363aafb1b1d3e910fe16fab4ae1b582";
    PolkaTransaction tx = PolkaTransaction.deserialize(rawPayload);

    expect(tx['method']['pallet'], 'balances');
    expect(tx['method']['name'], 'transferKeepAlive');
    expect(tx['method']['args']['dest'], '15vrtLsCQFG3qRYUcaEeeEih4JwepocNJHkpsrqojqnZPc2y');
    expect(tx['method']['args']['value'], '500000000000');
  });
}
