import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:app/setting.dart';
import 'api_exception.dart';
import 'package:app/setting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiProvider {
  final String _baseUrl = environment['baseUrl'];
  final _storage = FlutterSecureStorage();
  String _token;
  var headers;

  Future<Null> getToken() async {
    _token = await _storage.read(key: "token");
  }

  Future<dynamic> get({String url, String customBase}) async {
    if (_token == null) {
      await getToken();
    }
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (_token != null) {
      headers["Authorization"] = "Bearer " + _token;
    }
    var responseJson;
    try {
      final response = await http.get(
        customBase == null ? _baseUrl + url : customBase + url,
        headers: headers,
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('Không có kết nối Internet');
    }
    return responseJson;
  }

  Future<dynamic> post(
      {String url, Map<String, dynamic> data, String customBase}) async {
    if (_token == null) {
      await getToken();
    }
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (_token != null) {
      headers["Authorization"] = "Bearer " + _token;
    }
    var responseJson;

    try {
      final response = await http.post(
        customBase == null ? _baseUrl + url : customBase + url,
        headers: headers,
        body: jsonEncode(data),
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet');
    }
    return responseJson;
  }

  Future<dynamic> put(
      {String url, Map<String, dynamic> data, String customBase}) async {
    if (_token == null) {
      await getToken();
    }
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (_token != null) {
      headers["Authorization"] = "Bearer " + _token;
    }
    var responseJson;

    try {
      final response = await http.put(
        customBase == null ? _baseUrl + url : customBase + url,
        headers: headers,
        body: jsonEncode(data),
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        print('code 403');
        // no permission
        break;
      case 500:
        print('code 500');
        break;
      default:
        print("code " + response.statusCode.toString());
        break;
    }
    return;
  }
}
