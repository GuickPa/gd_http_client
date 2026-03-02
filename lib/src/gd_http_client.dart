import 'package:gd_http_client/gd_http_client.dart';
import 'package:gd_http_client/src/interfaces/i_http_client_handler.dart';

final class GDHttpClient implements IHttpClient {
  final IHttpClientHandler _handler;

  GDHttpClient(IHttpClientHandler handler) : _handler = handler;

  @override
  IHttpClientHandler get handler => _handler;

  @override
  void close() => _handler.close();

  @override
  Future<HttpResponse> delete(String url, {Map<String, dynamic>? headers}) =>
      _execute('DELETE', url, headers: headers);

  @override
  Future<HttpResponse> get(String url,
          {Map<String, dynamic>? headers,
          Map<String, dynamic>? queryParameters}) =>
      _execute('GET', url, headers: headers, queryParameters: queryParameters);

  @override
  Future<HttpResponse> patch(String url,
          {Map<String, dynamic>? headers, data}) =>
      _execute('PATCH', url, headers: headers, data: data);

  @override
  Future<HttpResponse> post(String url,
          {Map<String, dynamic>? headers, data}) =>
      _execute('POST', url, headers: headers, data: data);

  @override
  Future<HttpResponse> put(String url, {Map<String, dynamic>? headers, data}) =>
      _execute('PUT', url, headers: headers, data: data);

  Future<HttpResponse> _execute(String method, String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await _handler.get(url,
              headers: headers, queryParameters: queryParameters);
        case 'POST':
          return await _handler.post(url, headers: headers, data: data);
        case 'PUT':
          return await _handler.put(url, headers: headers, data: data);
        case 'PATCH':
          return await _handler.patch(url, headers: headers, data: data);
        case 'DELETE':
          return await _handler.delete(url, headers: headers);
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}
