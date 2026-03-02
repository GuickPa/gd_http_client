import 'dart:io';
import 'package:dio/io.dart';
import 'package:gd_http_client/gd_http_client.dart';
import 'package:gd_http_client/src/dio_http_client_handler.dart';
import 'package:gd_http_client/src/gd_certificate_pinner.dart';
import 'package:gd_http_client/src/gd_http_client.dart';

final class GDHttp {
  /// Creates a standard HTTP client
  static IHttpClient create() => GDHttpClient(DioHttpClientHandler());

  /// Creates a secure HTTP client with certificate pinning.
  /// Any hosts not in [allowedDomainShas] list is not trusted by default
  ///
  /// [allowedDomainShas] maps hostnames to lists of base64-encoded SHA-256 pins.
  /// Example:
  /// ```dart
  /// GDSecureHttpClient({
  ///   'api.example.com': ['AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='],
  /// });
  /// `
  static IHttpClient createSecure(
          {required Map<String, List<String>> allowedDomainShas}) =>
      GDHttpClient(DioHttpClientHandler(adapter: IOHttpClientAdapter(
        createHttpClient: () {
          final client =
              HttpClient(context: SecurityContext(withTrustedRoots: false));
          final adapter =
              GDCertificatePinner(allowedDomainShas: allowedDomainShas);
          client.badCertificateCallback = adapter.verify;
          return client;
        },
      )));
}
