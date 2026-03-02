import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:gd_http_client/src/interfaces/i_certificate_pinner.dart';

class GDCertificatePinner implements ICertificatePinner {
  final Map<String, List<String>> _allowedDomainShas;

  /// Creates a secure HTTP client Certificate Pinner for certificate pinning
  ///
  /// [allowedDomainShas] maps hostnames to lists of base64-encoded SHA-256 pins.
  /// Example:
  /// ```dart
  /// GDSecureHttpClient({
  ///   'api.example.com': ['AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='],
  /// });
  /// ```
  GDCertificatePinner({required Map<String, List<String>> allowedDomainShas})
      : _allowedDomainShas = allowedDomainShas;
  @override
  Map<String, List<String>> get allowedDomainShas => _allowedDomainShas;

  @override
  bool verify(X509Certificate cert, String host, int port) {
    final pins = allowedDomainShas[host];
    if (pins == null || pins.isEmpty) return true;

    final certHash = sha256.convert(cert.der);
    final certPin = base64.encode(certHash.bytes);

    return pins.contains(certPin);
  }
}
