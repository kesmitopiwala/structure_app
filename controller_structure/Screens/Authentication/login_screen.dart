import 'dart:ui';

import 'package:churchapp/Controllers/auth_controller.dart';
import 'package:churchapp/Controllers/church_controller.dart';
import 'package:churchapp/Helpers/constant.dart';
import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:churchapp/Screens/Authentication/forgot_password_screen.dart';
import 'package:churchapp/Screens/Authentication/request_account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Container(
        height: 90.0.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(height: 1.0.h),
            Image.asset(line),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 19,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(4.0.h),
              child: Column(
                children: [
                  text('Please Login', fontSize: 18.0),
                  SizedBox(height: 2.0.h),
                  text(
                      'This feature requires that you log in to access the information.'),
                  SizedBox(height: 2.0.h),
                  Container(
                    decoration: customBoxDecoration(isBoxShadow: false),
                    child: TextField(
                      controller: emailController,
                      cursorColor: primaryColor,
                      decoration: customInputDecoration(hintText: 'User Name'),
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  Container(
                    decoration: customBoxDecoration(isBoxShadow: false),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s"))
                      ],
                      cursorColor: primaryColor,
                      decoration: customInputDecoration(hintText: 'Password'),
                    ),
                  ),
                  SizedBox(height: 1.0.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        showCupertinoModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: false,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ForgotPasswordScreen());
                      },
                      child: text('Forgot your password?',
                          color: secondaryColor, fontSize: 10.0),
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  customTextButton(
                      onTap: _login, btnText: 'Login', width: 100.0.w),
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: false,
                          backgroundColor: Colors.transparent,
                          builder: (context) => RequestAccountScreen());
                    },
                    child: text(
                        "Don’t have an account? Click here to request one.",
                        color: secondaryColor,
                        fontSize: 8.0,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    ));
  }

  /// Submit register account form data here
  ///
  _login() async {
    FocusScope.of(context).unfocus();

    if (_validateField()) {
      var authController = Get.put(AuthController());
      ChurchController churchController = Get.find();

      var response = await authController.loginApiCall(userInfo: {
        "churchID": churchController.selectedChurch.value.churchid,
        "username": emailController.text,
        "pass": passwordController.text
      });
      if (response.result! == "success") {
        Navigator.of(context).pop();
        Get.showSnackbar(
            successSnackBar(title: 'Success', message: response.message!));
      } else {
        Get.showSnackbar(
            errorSnackBar(title: 'Error!', message: response.message!));
      }
    }
  }

  /// Check validation of form fields, if method return true then every field is valide or else show error
  ///
  bool _validateField() {
    if (emailController.text.isEmpty) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Email'));
      return false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Valid Email'));
      return false;
    } else if (passwordController.text.length == 0) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Password'));
      return false;
    } else if (passwordController.text.length < 6) {
      Get.showSnackbar(errorSnackBar(
          title: 'Error!',
          message: 'password should contain at least 6 characters'));
      return false;
    }
    return true;
  }
}
