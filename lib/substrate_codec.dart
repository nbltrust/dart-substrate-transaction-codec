export 'src/address.dart';
export 'src/transaction.dart';

String strip0x(String hex) {
  if (hex.startsWith('0x')) return hex.substring(2);
  return hex;
}
