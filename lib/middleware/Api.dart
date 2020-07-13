import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';


const String url = 'https://core-api-dev.nutsforgrowth.net/v1/client';
const String baseUrl = 'core-api-dev.nutsforgrowth.net';
const basePath = '/v1/client/';

class Api {
  Future<http.Response> filter(String path, Map<String, dynamic> queryParameters) async {
    // var uri = url + '/$path';
    // var uri = Uri.https(baseUrl, basePath + path, queryParameters);
    var uri = Uri.parse(url + '/$path')
        .resolveUri(Uri(queryParameters: queryParameters));

    print(uri);
    return http.get(
      uri,
      headers: getClientHeaders(),

    );
  }

  Future<http.Response> findOne(String resource, int id, Map<String, String> queryParameters) {
    var uri = Uri.http(url, '/$resource/$id', queryParameters);
    var userToken = getUserToken();
    return http.get(
      uri,
      headers: {HttpHeaders.authorizationHeader: userToken}
    );
  }

  Future<http.Response> login(String phone, String password) {
    var uri = url + '/users/login';
    print(uri);
    print(phone);
    print(password);
    var userToken = getUserToken();
    return http.post(
        uri,
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password
        }),
        headers: getClientHeaders()
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

  getClientHeaders() {

    return <String, String>{
      HttpHeaders.authorizationHeader: getUserToken(),
      'X-N4G-Client': 'n4g.field.officer.android',
      'X-N4G-Hash': 'dkjfnjh43847829dfjhwdfbn343',
      'Content-Type': 'application/json; charset=UTF-8'
    };
  }
}