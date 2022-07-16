import 'package:churchapp/Controllers/auth_controller.dart';
import 'package:churchapp/Controllers/church_controller.dart';
import 'package:churchapp/Helpers/constant.dart';
import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Container(
        height: 90.0.h,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 1.0.h),
            Image.asset(line),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text('Forgot your password?', fontSize: 18.0),
                    SizedBox(height: 2.0.h),
                    text(
                        'Enter your email below and a new password will be sent to you. After you login with this new password you can change it in the settings area.',
                        fontSize: 10.0),
                    SizedBox(height: 3.0.h),
                    Container(
                      decoration: customBoxDecoration(isBoxShadow: false),
                      child: TextField(
                        controller: emailController,
                        cursorColor: primaryColor,
                        decoration: customInputDecoration(
                            hintText: 'Enter your email address'),
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customTextButton(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            btnText: 'Cancel',
                            width: 3.5.w,
                            color: Colors.blueGrey.withOpacity(0.1)),
                        SizedBox(width: 3.0.w),
                        customTextButton(
                            onTap: _resetPassword,
                            btnText: 'Reset Password',
                            fontSize: 10.0,
                            width: 5.0.w),
                      ],
                    ),
                  ],
                ),
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
  _resetPassword() async {
    FocusScope.of(context).unfocus();
    if (_validateField()) {
      var authController = Get.put(AuthController());
      ChurchController churchController = Get.find();

      var response = await authController.resetPassword(userInfo: {
        "churchID": churchController.selectedChurch.value.churchid,
        "email": emailController.text,
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
    }
    return true;
  }
}
