import 'package:dio/dio.dart';
import 'package:gd_http_client/src/interfaces/i_http_client_handler.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

class DioHttpClientHandler implements IHttpClientHandler {
  final Dio _dio;

  DioHttpClientHandler({Dio? dio, HttpClientAdapter? adapter})
      : _dio = dio ?? Dio() {
    _dio.httpClientAdapter = adapter ?? NativeAdapter();
  }

  @override
  Future<HttpResponse> get(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(url,
        options: Options(headers: _buildHeaders(headers)), queryParameters: queryParameters);
    return _mapResponse(response);
  }

  @override
  Future<HttpResponse> post(String url,
      {Map<String, dynamic>? headers, dynamic data}) async {
    final response =
        await _dio.post(url, options: Options(headers: _buildHeaders(headers)), data: data);
    return _mapResponse(response);
  }

  @override
  Future<HttpResponse> put(String url,
      {Map<String, dynamic>? headers, dynamic data}) async {
    final response =
        await _dio.put(url, options: Options(headers: _buildHeaders(headers)), data: data);
    return _mapResponse(response);
  }

  @override
  Future<HttpResponse> patch(String url,
      {Map<String, dynamic>? headers, dynamic data}) async {
    final response =
        await _dio.patch(url, options: Options(headers: _buildHeaders(headers)), data: data);
    return _mapResponse(response);
  }

  @override
  Future<HttpResponse> delete(String url,
      {Map<String, dynamic>? headers}) async {
    final response = await _dio.delete(url, options: Options(headers: _buildHeaders(headers)));
    return _mapResponse(response);
  }

  @override
  void close() {
    _dio.close();
  }

  HttpResponse _mapResponse(Response response) {
    return HttpResponse(
      statusCode: response.statusCode,
      data: response.data,
      headers: response.headers.map,
    );
  }

  Map<String, dynamic> _buildHeaders(Map<String, dynamic>? headers) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
  }
}
