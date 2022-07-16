import 'package:churchapp/Controllers/auth_controller.dart';
import 'package:churchapp/Controllers/church_controller.dart';
import 'package:churchapp/Helpers/constant.dart';
import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RequestAccountScreen extends StatefulWidget {
  @override
  _RequestAccountScreenState createState() => _RequestAccountScreenState();
}

class _RequestAccountScreenState extends State<RequestAccountScreen> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Container(
          height: 90.0.h,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
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
                // Spacer(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.0.h),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          text('Request An Account', fontSize: 18.0),
                          SizedBox(height: 2.0.h),
                          text(
                              'An account will allow you to view the church directory as well as manager your profile.'),
                          SizedBox(height: 2.0.h),
                          Container(
                            decoration: customBoxDecoration(isBoxShadow: false),
                            child: TextField(
                              controller: firstNameController,
                              cursorColor: primaryColor,
                              decoration:
                                  customInputDecoration(hintText: 'First Name'),
                            ),
                          ),
                          SizedBox(height: 2.0.h),
                          Container(
                            decoration: customBoxDecoration(isBoxShadow: false),
                            child: TextField(
                              controller: lastNameController,
                              cursorColor: primaryColor,
                              decoration:
                                  customInputDecoration(hintText: 'Last Name'),
                            ),
                          ),
                          SizedBox(height: 2.0.h),
                          Container(
                            decoration: customBoxDecoration(isBoxShadow: false),
                            child: TextField(
                              controller: emailController,
                              cursorColor: primaryColor,
                              decoration: customInputDecoration(
                                  hintText: 'Email Address'),
                            ),
                          ),
                          SizedBox(height: 2.0.h),
                          Container(
                            decoration: customBoxDecoration(isBoxShadow: false),
                            child: TextField(
                              controller: passwordController,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s"))
                              ],
                              cursorColor: primaryColor,
                              obscureText: true,
                              decoration:
                                  customInputDecoration(hintText: 'Password'),
                            ),
                          ),
                          SizedBox(height: 1.0.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customTextButton(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  btnText: 'Cancel',
                                  width: 3.0.w,
                                  color: Colors.blueGrey.withOpacity(0.1)),
                              SizedBox(width: 3.0.w),
                              customTextButton(
                                  onTap: _requestAccount,
                                  btnText: 'Request An Account',
                                  fontSize: 11.0,
                                  width: 5.0.w),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Submit register account form data here
  ///
  _requestAccount() async {
    FocusScope.of(context).unfocus();
    if (_validateField()) {
      var authController = Get.put(AuthController());
      ChurchController churchController = Get.find();

      var response = await authController.requestAnAccountApiCall(userInfo: {
        "churchID": churchController.selectedChurch.value.churchid,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text
      });
      if (response.result! == "success") {
        Navigator.of(context).pop();
        showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Request Sent!'),
            content: Text(response.message!),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } else {
        Get.showSnackbar(
            errorSnackBar(title: 'Error!', message: response.message!));
      }
    }
  }

  /// Check validation of form fields, if method return true then every field is valide or else show error
  ///
  bool _validateField() {
    if (firstNameController.text.isEmpty) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter First Name'));
      return false;
    } else if (lastNameController.text.isEmpty) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Last Name'));
      return false;
    } else if (emailController.text.isEmpty) {
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
