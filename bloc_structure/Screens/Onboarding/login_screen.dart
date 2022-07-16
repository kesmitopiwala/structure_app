import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Login/login_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool checkedValue = true;
  var newValue;
  var userNameController = TextEditingController(text: "test4@gmail.com");
  var passwordController = TextEditingController(text: "123456789");
  final _formKey = GlobalKey<FormState>();
  var loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(children: [
          Image.asset(
            Assets.imagesBg,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: BlocListener<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  listener: (context, state) {
                    if (state is LoginSuccessState) {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
                    }
                    if (state is FacebookSuccessState) {
                      if (state.facebookResponse.data!.school == null ||
                          state.facebookResponse.data!.school == "") {
                        Navigator.of(context).pushReplacementNamed(
                            Routes.REMAINING_DEATAILS_SCREEN);
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
                      }
                    }

                    if (state is LoginBlocFailure) {
                      print('Error occurred !');
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(
                    bloc: loginBloc,
                    builder: (context, state) {
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                Assets.imagesSkoolfame,
                                height: 25.h,
                                width: 50.w,
                              )),
                          MyTextField(
                            controller: userNameController,
                            hint: "Email",
                            prefixIcon: Assets.iconsUsername,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: passwordController,
                            hint: "Password",
                            obscureText: true,
                            prefixIcon: Assets.iconsPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.0.h),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      checkedValue = !checkedValue;
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration:
                                        CustomWidgets.customBoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: 3,
                                      borderColor: AppColors.textWhiteColor,
                                      isBorderEnable: true,
                                    ),
                                    child: !checkedValue
                                        ? Container()
                                        : const Icon(
                                            Icons.check,
                                            size: 15,
                                            color: AppColors.textWhiteColor,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                CustomWidgets.text("Remember Me")
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0.h),
                          MyButton(
                            height: 7.h,
                            width: 100.w,
                            label: 'LOG IN',
                            labelTextColor: AppColors.colorPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginBloc.add(LoginApiEvent({
                                  "email": userNameController.text.trim(),
                                  "password": passwordController.text.trim()
                                }));
                                // Navigator.of(context)
                                //     .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
                              }
                            },
                            color: AppColors.textWhiteColor,
                          ),
                          SizedBox(height: 1.0.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.FORGOT_PASSWORD_SCREEN);
                                },
                                child: CustomWidgets.text(
                                  "Forgot your password?",
                                  color: AppColors.textWhiteColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0.h),
                          GestureDetector(
                            onTap: () {
                              loginBloc.add(FacebookApiEvent());
                            },
                            child: Container(
                              height: 7.h,
                              width: 65.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff3682F8),
                                        Color(0xff21BBD7),
                                      ],
                                      stops: [
                                        0.0,
                                        1.0
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.topRight,
                                      tileMode: TileMode.repeated)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Assets.iconsFacebook,
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: CustomWidgets.text(
                                          "Connect With Facebook",
                                          color: AppColors.textWhiteColor,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 14.0.h),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(Routes.SIGNUP_SCREEN_ROUTE),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidgets.text(
                                  "Don’t have an account? ",
                                  color: AppColors.textWhiteColor,
                                ),
                                CustomWidgets.text("Sign Up",
                                    color: AppColors.textYellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )),
            // MyTextField(),
          ),
        ]),
      ),
    );
  }
}
