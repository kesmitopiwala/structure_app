import 'package:churchapp/Helpers/constant.dart';
import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:churchapp/Models/error_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'custom_exception.dart';

/// [ApiManager] containes the Post and get method of http with response and error handling
///
class APIManager {
  /// Used to call post API method, pass the url and param for api call
  ///
  /// `APIManager().postAPICall("https://.....",{});`
  Future<dynamic> postAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      /// Show progress loader
      showProgressIndicator();

      /// Set header for send request
      var headers = {
        "Content-Type": "application/json",
        'Authorization': auth_token,
      };

      /// call post api for given url and parameters
      final response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(param))
          // .timeout(Duration(seconds: 5))
          .onError((error, stackTrace) =>
              throw FetchDataException('No Internet connection'));

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'No Internet connection'));
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Used to call get API method, pass the url for api call
  ///
  /// `APIManager().getAPICall("https://.....");`
  Future<dynamic> getAPICall(String url, {bool isLoaderShow = true}) async {
    print("Calling API: $url");

    var responseJson;
    try {
      /// Show progress loader
      ///
      if (isLoaderShow) {
        showProgressIndicator();
      }

      print(auth_token);

      /// call post api for given url and parameters
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': auth_token,
      })
          // .timeout(Duration(seconds: 15))
          .onError((error, stackTrace) =>
              throw FetchDataException('No Internet Connection'));

      print(response.body);

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'No Internet connection'));
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      if (isLoaderShow) {
        EasyLoading.dismiss();
      }
    }
    return responseJson;
  }

  /// Used to call post API method, pass the url and param for api call
  ///
  /// `APIManager().postAPICall("https://.....",{});`
  Future<dynamic> putAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      /// Show progress loader
      showProgressIndicator();

      /// Set header for send request
      var headers = {
        "Content-Type": "application/json",
        'Authorization': auth_token,
      };

      /// call post api for given url and parameters
      final response = await http
          .put(Uri.parse(url), headers: headers, body: json.encode(param))
          // .timeout(Duration(seconds: 15))
          .onError((error, stackTrace) =>
              throw FetchDataException('No Internet connection'));

      /// Check api response and handle exception
      responseJson = _response(response);
    } on SocketException {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'No Internet connection'));
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {
      /// Hide progress loader
      EasyLoading.dismiss();
    }
    return responseJson;
  }

  /// Check response status and handle exception
  dynamic _response(http.Response response) {
    switch (response.statusCode) {

      /// Successfully get api response
      case 200:
        if (json.decode(response.body)['result'] == 'failed') {
          throw BadRequestException(
              ErrorModel.fromJson(json.decode(response.body.toString()))
                  .message);
        } else {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        }

      /// Bad request need to check url
      case 400:
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Authorisation token invalid
      case 403:
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Error occured while Communication with Server
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
