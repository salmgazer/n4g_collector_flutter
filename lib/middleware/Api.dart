import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

const String url = '192.168.100.2:4500';

class Api {
  Future<http.Response> filter(String resource, Map<String, String> queryParameters) async {
    var uri = Uri.http(url, '/$resource', queryParameters);
    return http.get(uri);
  }

  Future<http.Response> findOne(String resource, int id, Map<String, String> queryParameters) {
    var uri = Uri.http(url, '/$resource/$id', queryParameters);
    var userToken = getUserToken();
    return http.get(
      uri,
      headers: {HttpHeaders.authorizationHeader: userToken}
    );
  }

  Future<http.Response> createOne(String resource, Map body) {
    var uri = Uri.http(url, resource);
    var userToken =getUserToken();
    return http.post(
      uri,
      body: body,
      headers: {HttpHeaders.authorizationHeader: userToken}
    );
  }

  Future<http.Response> updateOne(String resource, int id, Map body) {
    var uri = Uri.http(url, '$resource/$id');
    var userToken = getUserToken();
    return http.put(
      uri,
      body: body,
      headers: {HttpHeaders.authorizationHeader: userToken}
    );
  }

  Future<http.Response> deleteOne(String resource, int id) {
    var uri = Uri.http(url, '$resource/$id');
    var userToken = getUserToken();
    return http.delete(
      uri,
      headers: {HttpHeaders.authorizationHeader: userToken}
    );
  }

  getUserToken() {
    return "Basic your_api_token_here";
  }
}