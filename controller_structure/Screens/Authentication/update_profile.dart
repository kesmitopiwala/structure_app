import 'package:churchapp/Controllers/auth_controller.dart';
import 'package:churchapp/Controllers/church_controller.dart';
import 'package:churchapp/Helpers/constant.dart';
import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sizer/sizer.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key, this.callBack}) : super(key: key);
  final Function? callBack;

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  var authController = Get.put(AuthController());

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var mobileController = TextEditingController();

  initState() {
    super.initState();

    if (authController.currentUser.value.usrid != null) {
      firstNameController.text = authController.currentUser.value.firstname!;
      lastNameController.text = authController.currentUser.value.lastname!;
      emailController.text = authController.currentUser.value.email!;

      mobileController.text = authController.currentUser.value.phone!;
      passwordController.text = '';
    }
  }

  dispose() {
    super.dispose();

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.0.h),
        Container(
          decoration: customBoxDecoration(isBoxShadow: false),
          child: TextField(
            onTap: () => widget.callBack!(true),
            controller: firstNameController,
            cursorColor: primaryColor,
            decoration: customInputDecoration(hintText: 'First Name'),
          ),
        ),
        SizedBox(height: 2.0.h),
        Container(
          decoration: customBoxDecoration(isBoxShadow: false),
          child: TextField(
            onTap: () => widget.callBack!(true),
            controller: lastNameController,
            cursorColor: primaryColor,
            decoration: customInputDecoration(hintText: 'Last Name'),
          ),
        ),
        SizedBox(height: 2.0.h),
        Container(
          decoration: customBoxDecoration(isBoxShadow: false),
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            onTap: () => widget.callBack!(true),
            cursorColor: primaryColor,
            decoration: customInputDecoration(hintText: 'Email'),
          ),
        ),
        SizedBox(height: 2.0.h),
        Container(
          decoration: customBoxDecoration(isBoxShadow: false),
          child: TextField(
            controller: mobileController,
            onTap: () => widget.callBack!(true),
            // keyboardType: TextInputType.number,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')})
            ],
            cursorColor: primaryColor,
            decoration: customInputDecoration(hintText: 'Phone Number'),
          ),
        ),
        SizedBox(height: 2.0.h),
        Container(
          decoration: customBoxDecoration(isBoxShadow: false),
          child: TextField(
            controller: passwordController,
            onTap: () => widget.callBack!(true),
            enabled: true,
            obscureText: true,
            cursorColor: primaryColor,
            decoration: customInputDecoration(hintText: 'Password'),
          ),
        ),
        SizedBox(height: 2.0.h),
        customTextButton(
            onTap: () {
              _updateProfile();
            },
            btnText: 'SAVE',
            width: 100.0.w),
        SizedBox(height: 2.0.h),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            authController.logout();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customIcon(icon: back_icon_profile, size: 1.5),
              SizedBox(width: 2.0.w),
              text('Sign out', color: secondaryColor, height: 1.2),
            ],
          ),
        ),
      ],
    );
  }

  _updateProfile() async {
    FocusScope.of(context).unfocus();
    if (_validateProfileField()) {
      var authController = Get.put(AuthController());
      ChurchController churchController = Get.find();
      print(mobileController.text);
      var response = await authController.updateProfileApiCall(userInfo: {
        "churchID": churchController.selectedChurch.value.churchid,
        "peopleID": authController.currentUser.value.usrid,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "email": emailController.text,
        "phone": mobileController.text,
        "password":
            passwordController.text.isNotEmpty ? passwordController.text : ""
      });
      if (response.result! == "success") {
        Get.showSnackbar(
            successSnackBar(title: 'Success', message: response.message!));
      }
    }
  }

  /// Check validation of profile form fields, if method return true then every field is valide or else show error
  ///
  bool _validateProfileField() {
    if (firstNameController.text.isEmpty) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Firstname'));
      return false;
    } else if (lastNameController.text.length == 0) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Lastname'));
      return false;
    } else if (mobileController.text.length == 0) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Lastname'));
      return false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Valid Email'));
      return false;
    }
    return true;
  }
}
