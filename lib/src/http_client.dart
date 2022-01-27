import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient {
  Future<http.Response> doGet(Uri uri, {Map<String, String>? headers}) async {
    return await _doCall(_HttpMethod.get, uri, headers: headers);
  }

  Future<http.Response> doPut(Uri uri,
      {Map<String, String>? headers, Map<String, Object>? payload}) async {
    return await _doCall(_HttpMethod.put, uri, headers: headers, body: payload);
  }

  Future<http.Response> doPost(Uri uri,
      {Map<String, String>? headers, Map<String, Object>? payload}) async {
    return await _doCall(_HttpMethod.post, uri,
        headers: headers, body: payload);
  }

  void _putDefaultHeaders(Map<String, String>? headers) {
    headers ??= {};
    headers['Accept'] = 'application/json';
    headers['Content-Type'] = 'application/json';
  }

  Future<http.Response> _doCall(_HttpMethod method, Uri uri,
      {Map<String, String>? headers, Map<String, Object>? body}) async {
    _putDefaultHeaders(headers);
    final response =
        await _doRequest(method, uri, headers: headers, body: body);
    return response;
  }

  Future<http.Response> _doRequest(_HttpMethod method, Uri uri,
      {Map<String, String>? headers, Map<String, Object>? body}) async {
    switch (method) {
      case _HttpMethod.get:
        return await http.get(uri, headers: headers);
      case _HttpMethod.post:
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case _HttpMethod.put:
        return await http.put(uri, headers: headers, body: jsonEncode(body));
    }
  }
}

enum _HttpMethod { get, post, put }
