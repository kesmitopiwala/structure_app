import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/place_picker.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Signup/signup_bloc.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/Widgets/my_text_field_widget.dart';
import 'package:skoolfame/generated/assets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var schoolController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var reEnterPasswordController = TextEditingController();
  var dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var signupBloc = SignupBloc();
  String dropdownValue = 'Female';
  var items = [
    'Male',
    'Female',
  ];
  DateTime selectedDate = DateTime(2001, 11, 30);
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Image.asset(
              Assets.imagesBg,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: BlocListener<SignupBloc, SignupState>(
                  bloc: signupBloc,
                  listener: (context, state) {
                    if (state is SignupSuccessState) {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.DASHBOARD_ROUTE);
                    }
                    if (state is SignupBlocFailure) {
                      print('Error occurred !');
                    }
                  },
                  child: BlocBuilder<SignupBloc, SignupState>(
                    bloc: signupBloc,
                    builder: (context, state) {
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                Assets.imagesSkoolfame,
                                height: 20.h,
                                width: 50.w,
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: fNameController,
                                  hint: "First Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: MyTextField(
                                  controller: lNameController,
                                  hint: "Last Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: dobController,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context);
                                    dobController.text =
                                        DateFormat("MM/dd/yyyy")
                                            .format(selectedDate);
                                  },
                                  hint: "Date of birth",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select date of birth';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: DropdownButton(
                                        style: GoogleFonts.lato(
                                          color: AppColors.textWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        isDense: true,
                                        dropdownColor:
                                            AppColors.colorPrimaryLight,
                                        value: dropdownValue,
                                        underline: Container(
                                            // padding: EdgeInsets.only(bottom: 50),
                                            // height: 2,
                                            // color: AppColors.colorPrimaryLight,
                                            ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.colorPrimaryLight,
                                          // size: 40,
                                        ),
                                        iconSize: 32,
                                        items: items.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(
                                      color: AppColors.colorPrimaryLight,
                                      thickness: 2,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: schoolController,
                            hint: "School",
                            readOnly: true,
                            onTap: () async {
                              LocationResult? result =
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  "AIzaSyBpOO_jzYTT8IY-yp5psd1phdiFcG-g5a8",
                                ),
                              ));
                              print("Result:  ${result!.formattedAddress}");
                              schoolController.text =
                                  result.formattedAddress.toString();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter school';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: emailController,
                            hint: "Email",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              } else if (value.length < 6) {
                                return 'Please enter min 6 character';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          MyTextField(
                            controller: reEnterPasswordController,
                            hint: "Password Again",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password again';
                              } else if (value != passwordController.text) {
                                return 'Password don\'t match';
                              }
                              return null;
                            },
                          ),
                          // SizedBox(height: 1.0.h),

                          SizedBox(height: 7.0.h),
                          MyButton(
                            height: 7.h,
                            width: 100.w,
                            label: 'SIGN UP',
                            labelTextColor: AppColors.colorPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signupBloc.add(SignUpApiEvent({
                                  "first_name": fNameController.text.trim(),
                                  "last_name": lNameController.text.trim(),
                                  "dob": DateFormat("yyyy-MM-dd")
                                      .format(selectedDate),
                                  "gender": dropdownValue,
                                  "school": schoolController.text.trim(),
                                  "email": emailController.text.trim(),
                                  "password": passwordController.text.trim(),
                                  "social_media": "email",
                                  "about": ""
                                }));
                              }
                            },
                            color: AppColors.textWhiteColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2001, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
