import 'dart:convert';

Map<String, dynamic> decodeJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw Exception('Invalid JWT');

  final payload = parts[1];
  final normalized = base64.normalize(payload);
  final decoded = utf8.decode(base64Url.decode(normalized));
  return json.decode(decoded);
}
