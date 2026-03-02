import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gd_http_client/src/dio_http_client_handler.dart';
import 'package:gd_http_client/src/gd_http_client.dart';
import 'package:gd_http_client/src/interfaces/i_certificate_pinner.dart';
import 'package:gd_http_client/src/interfaces/i_http_client_handler.dart';

final class TestGDOKCertificatePinner implements ICertificatePinner {
  @override
  Map<String, List<String>> get allowedDomainShas => {};

  @override
  bool verify(X509Certificate cert, String host, int port) {
    return true;
  }
}

final class TestGDKOCertificatePinner implements ICertificatePinner {
  @override
  Map<String, List<String>> get allowedDomainShas => {};

  @override
  bool verify(X509Certificate cert, String host, int port) {
    return false;
  }
}

IHttpClientHandler buildHandler(ICertificatePinner pinner) {
  return DioHttpClientHandler(adapter: IOHttpClientAdapter(
    createHttpClient: () {
      final client =
          HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = pinner.verify;
      return client;
    },
  ));
}

void main() {
  group('GDSecureHttpClient', () {
    test('creates instance with certificate pins', () {
      final client = GDHttpClient(buildHandler(TestGDOKCertificatePinner()));

      expect(client, isNotNull);
      expect(client, isA<GDHttpClient>());
    });

    test('accepts valid certificate with matching pin', () async {
      final client = GDHttpClient(buildHandler(TestGDOKCertificatePinner()));

      expect(client, isNotNull);
      final response =
          await client.get('https://jsonplaceholder.typicode.com/todos/1');
      expect(response, isA<HttpResponse>());
      client.close();
    });

    test('denied requests to unpinned domains', () async {
      final client = GDHttpClient(buildHandler(TestGDKOCertificatePinner()));

      expect(client, isNotNull);
      expect(
        () async => await client.get('https://jsonplaceholder.typicode.com/todos/1'),
        throwsA(isA<Exception>()),
      );
      client.close();
    });
  });
}
