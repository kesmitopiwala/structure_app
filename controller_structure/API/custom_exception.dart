import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:get/get.dart';

/// Exception model class
///
class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    Get.showSnackbar(errorSnackBar(title: 'Error!', message: _message));
    return "$_prefix $_message";
  }
}

/// throw exception when failed to communication with server
///
class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication:");
}

/// throw exception when called invalid request
///
class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

/// throw exception when pass unauthorised user token
///
class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
