import 'package:gd_http_client/src/interfaces/i_http_client_handler.dart';

abstract class IHttpClient {
  IHttpClientHandler get handler;
  Future<HttpResponse> get(String url,
      {Map<String, dynamic>? headers, Map<String, dynamic>? queryParameters});

  Future<HttpResponse> post(String url,
      {Map<String, dynamic>? headers, dynamic data});

  Future<HttpResponse> put(String url,
      {Map<String, dynamic>? headers, dynamic data});

  Future<HttpResponse> patch(String url,
      {Map<String, dynamic>? headers, dynamic data});

  Future<HttpResponse> delete(String url, {Map<String, dynamic>? headers});

  void close();
}
