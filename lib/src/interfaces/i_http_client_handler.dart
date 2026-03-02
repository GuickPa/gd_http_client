abstract class IHttpClientHandler {
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

class HttpResponse {
  final int? statusCode;
  final dynamic data;
  final Map<String, dynamic>? headers;

  HttpResponse({
    required this.statusCode,
    required this.data,
    this.headers,
  });
}
