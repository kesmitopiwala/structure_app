import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'Helpers/constant.dart';
import 'Helpers/routes.dart';


void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, builder) {
        return GetMaterialApp(
          navigatorKey: mainNavigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Demo App',
          getPages: AppPages.routes,
          initialRoute: AppPages.INITIAL,
          theme: ThemeData(
            primaryColor: primaryColor,
            fontFamily: 'SFPro',
            scaffoldBackgroundColor: Color(0xffF5F5F5),
            highlightColor: Colors.transparent,
            dividerTheme: const DividerThemeData(
              thickness: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
