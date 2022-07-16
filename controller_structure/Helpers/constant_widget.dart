import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/Controllers/church_controller.dart';
import 'package:churchapp/Screens/event_screen.dart';
import 'package:churchapp/Screens/home_screen.dart';
import 'package:churchapp/Screens/summary_screen.dart';
import 'package:churchapp/Screens/sermons_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

Text text(
  String content, {
  Color? color = primaryColor,
  double? fontSize = 11,
  FontWeight? fontWeight = FontWeight.normal,
  int? maxLine,
  double? letterSpacing = 0.0,
  TextAlign textAlign = TextAlign.center,
  double? height = 1.7,
}) {
  return Text(content,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
          height: height!,
          letterSpacing: letterSpacing,
          color: color,
          fontSize: fontSize!.sp,
          fontWeight: fontWeight));
}

/// Custom [InputDecoration]
///
/// Hint text must not be null, fontWeight default value id Normal and letterSpacing default value 0.0
///
customInputDecoration({
  required String hintText,
  FontWeight? fontWeight = FontWeight.normal,
  double? letterSpacing = 0.0,
  bool? suffixEnable = false,
  Function? onSuffixTap,
}) {
  return InputDecoration(
      border: InputBorder.none,
      // contentPadding: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 1.5.h),
      // isDense: true,
      filled: true,
      hintStyle: TextStyle(
          color: Colors.grey[800],
          fontWeight: fontWeight,
          fontSize: 11.0.sp,
          letterSpacing: letterSpacing!),
      hintText: hintText,
      // suffix: ,
      suffixIcon: suffixEnable!
          ? Padding(
              padding: EdgeInsets.all(2.0.h),
              child: GestureDetector(
                // iconSize: 14.0.sp,
                child: customIcon(icon: search_icon, size: 1.0
                    // CupertinoIcons.search,
                    // color: Colors.black,
                    ),
                onTap: () => onSuffixTap!(),
              ),
            )
          : Text(''),
      fillColor: Colors.white);
}

/// Custom textButton
///
/// onTap is required
/// width, height, fontsize of button text and button color is predefined value variable you can customize according requirement
///
customTextButton(
    {required Function onTap,
    required String btnText,
    double width = 30.0,
    double fontSize = 12.0,
    double height = 10.0,
    Color color = primaryColor}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 1.6.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          border:
              Border.all(color: color == whiteColor ? primaryColor : color)),
      height: height.w,
      width: width.h,
      child: text(btnText,
          color: color == primaryColor ? whiteColor : primaryColor,
          letterSpacing: 0.5,
          height: 1.2,
          fontSize: fontSize,
          fontWeight: FontWeight.w500),
    ),
  );
}

/// Container custom box decoration with some default style and also customizable
///
BoxDecoration customBoxDecoration(
    {Color color = whiteColor,
    bool isBoxShadow = true,
    bool isBorderEnable = false,
    double borderRadius = 20}) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: isBorderEnable
          ? Border.all(color: blackColor.withOpacity(0.8), width: 0.8)
          : null,
      boxShadow: isBoxShadow
          ? [
              BoxShadow(
                  spreadRadius: 5,
                  offset: Offset(4, 4),
                  blurRadius: 13,
                  color: Colors.grey.withOpacity(0.2))
            ]
          : []);
}

/// Show progress indicator when API call Or any other async method call
///
showProgressIndicator() {
  return EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
      status: 'Loading');
}

/// Custom [TextField] with [textFieldHeading]
///
Column customTitleTextField(
    {required String hintText, required TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 0.5.h),
      TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: controller,
        style: TextStyle(fontSize: 6.0.sp),
        decoration: customInputDecoration(hintText: hintText),
      ),
    ],
  );
}

/// Custom error ErrorSnackBar design for show error
///
/// Call `Get.showSnackbar(ErrorSnackBar(title: 'Error!', message: response.body.toString()));` for show ErrorSnackBar
GetBar errorSnackBar({String title = 'Error', String? message}) {
  Get.log("[$title] $message", isError: true);
  return GetBar(
    titleText: text(title.tr,
        textAlign: TextAlign.left,
        color: whiteColor,
        fontSize: 12.0,
        height: 1.0,
        fontWeight: FontWeight.bold),
    messageText: text(
      message!,
      color: whiteColor,
      fontSize: 10.0,
      height: 1.0,
      textAlign: TextAlign.left,
    ),
    snackPosition: SnackPosition.BOTTOM,
    shouldIconPulse: true,
    margin: EdgeInsets.all(20),
    backgroundColor: Colors.redAccent,
    icon: Icon(Icons.remove_circle_outline, size: 25.0, color: whiteColor),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    borderRadius: 8,
    duration: Duration(seconds: 3),
  );
}

GetBar successSnackBar({String title = 'Success', String? message}) {
  Get.log("[$title] $message", isError: true);
  return GetBar(
    titleText: text(title.tr,
        textAlign: TextAlign.left,
        color: blackColor,
        fontSize: 12.0,
        height: 1.0,
        fontWeight: FontWeight.bold),
    messageText: text(
      message!,
      color: blackColor,
      fontSize: 10.0,
      height: 1.0,
      textAlign: TextAlign.left,
    ),
    isDismissible: false,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(20),
    backgroundColor: Colors.greenAccent,
    icon: Icon(Icons.check, size: 25.0, color: blackColor),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    borderRadius: 8,
    duration: Duration(seconds: 3),
  );
}

/// Create the 4.0.h * 4.0.h size icon you can adjust size according requirement, pass the asset image path as named parameter
///
Container customIcon({required String? icon, double size = 4.0}) {
  return Container(
    height: size.h,
    width: size.h,
    child: Image.asset(icon!),
  );
}

/// Sermons heading that contain Church name, church logo with church type
///
Widget customPageHeader({String? title, bool? isScroll = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: isScroll! ? 0 : 70.0.w,
        child: GetBuilder<ChurchController>(
            builder: (controller) =>
                controller.selectedChurch.value.logoUse! == "logo"
                    ? CachedNetworkImage(
                        imageUrl: controller.selectedChurch.value.logo!,
                        placeholder: (context, url) =>
                            Container(color: Colors.black),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : text(controller.selectedChurch.value.logoText!,
                        color: whiteColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500)),
      ),
      title == null || isScroll ? Container() : SizedBox(height: 4.0.h),
      title == null
          ? Container()
          : text(title,
              color: whiteColor, fontSize: 24.0, fontWeight: FontWeight.w500),
    ],
  );
}

Future<void> openMap(String address) async {
  String googleUrl = 'https://www.google.com/maps/place/$address';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}

/// Used when navigate to other screen with the custom navigator
///
openDetailsPage({required BuildContext context, required Widget child}) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => child));

/// Header background image
///
class CustomHeadorBackground extends StatelessWidget {
  CustomHeadorBackground(
      {Key? key,
      this.child,
      this.isScroll = false,
      this.bgImg,
      this.imageAlignment = Alignment.bottomCenter})
      : super(key: key);
  final String? bgImg;
  final bool? isScroll;
  final Widget? child;
  final Alignment? imageAlignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: isScroll! ? 10.0.h : 30.0.h,
        width: 100.0.w,
        duration: Duration(milliseconds: 500),
        // color: Colors.black,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: NetworkImage(bgImg == header_sermon_img
                  ? "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg"
                  : bgImg!),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.matrix(matrix),
              alignment: imageAlignment!),
        ),
        child: child);
  }
}

/// This widget used when you get empty list form the api then show this no data found widget
///
class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: text('No Data', color: Colors.black, fontSize: 9.0),
      ),
    );
  }
}

/// Card that used into [SummaryScreen] to show Summary of app
///
class CustomSummaryCardForListView extends StatelessWidget {
  const CustomSummaryCardForListView({
    Key? key,
    required this.image,
    required this.title,
    this.subtitle,
    this.isAsset = false,
    this.titleFontSize = 12.0,
    this.icon,
  }) : super(key: key);

  final String? image, title, subtitle, icon;
  final double titleFontSize;
  final bool? isAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 37.0.w,
        margin: EdgeInsets.symmetric(vertical: 15.0),
        decoration: customBoxDecoration(),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: isAsset!
                          ? Image.asset(
                              image!,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: image!,
                              fit: BoxFit.cover,
                            )),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 1.5.h),
                        text(
                          '$title',
                          height: 1.0,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: subtitle == null ? 0 : 0.2.h),
                        subtitle == null
                            ? Container()
                            : text(
                                '$subtitle',
                                fontSize: 7.0,
                                height: 1.0,
                                color: primaryColor.withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(bottom: 4.5.h),
                    child: PhysicalModel(
                      elevation: 3,
                      color: Colors.white,
                      shape: BoxShape.circle,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: customIcon(icon: icon, size: 3.0),
                      ),
                    ))),
          ],
        ));
  }
}

/// Card that used into [HomeSceen] to show latest sermons and upcoming events also in [IntroScreen]
///
class CustomEventCardForListView extends StatelessWidget {
  const CustomEventCardForListView(
      {Key? key,
      required this.image,
      required this.title,
      this.subtitle,
      this.isAsset = false,
      this.titleFontSize = 12.0,
      this.icon,
      this.day,
      this.onTap,
      this.month})
      : super(key: key);

  final String? image, title, subtitle, icon, month, day;
  final double titleFontSize;
  final Function? onTap;
  final bool? isAsset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(20.0),
          color: whiteColor,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
          elevation: 5,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: isAsset!
                            ? Image.asset(
                                image!,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: image!,
                                fit: BoxFit.cover,
                              )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 0.8.h),
                          text(
                            '$title',
                            fontSize: titleFontSize,
                            maxLine: 1,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: subtitle == null ? 0 : 0.2.h),
                          subtitle == null
                              ? Container()
                              : text(
                                  '$subtitle',
                                  fontSize: 8.5,
                                  color: primaryColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 52),
                      // decoration: customBoxDecoration(),
                      child: PhysicalModel(
                        color: whiteColor,
                        shadowColor: Color.fromRGBO(0, 0, 0, 0.40),
                        elevation: 5,
                        shape: BoxShape.circle,
                        child: CircleAvatar(
                            backgroundColor: whiteColor,
                            child: icon == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      text(day!,
                                          height: 1.0,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                      text(month!.toUpperCase(),
                                          height: 1.0,
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.w300),
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child:
                                        customIcon(icon: play_icon, size: 2.5),
                                  )),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card that used into [SermonsScreen] to show sermons and [EventScreen] for Events
///
class CustomSermonAndEventCard extends StatelessWidget {
  const CustomSermonAndEventCard({
    Key? key,
    required this.image,
    required this.title,
    this.subtitle,
    this.titleFontSize = 18.0,
    this.month,
    this.day,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String? image, title, subtitle, icon, day, month;
  final double titleFontSize;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
          height: 45.0.h,
          margin: EdgeInsets.symmetric(vertical: 15.0),
          decoration: customBoxDecoration(),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 100.0.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: CachedNetworkImage(
                              imageUrl: image!, fit: BoxFit.cover)),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 100.0.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0.h, vertical: 1.0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.5.h),
                          text(
                            '$title',
                            fontSize: titleFontSize,
                            textAlign: TextAlign.left,
                            maxLine: 1,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                          // SizedBox(height: subtitle == null ? 0 : 0.2.h),
                          text(
                            '$subtitle',
                            fontSize: 8.0,
                            color: primaryColor.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      // height: 80,
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.5.w, vertical: 0.8.h),
                      margin: EdgeInsets.all(1.5.h),
                      decoration: customBoxDecoration(
                          isBoxShadow: false,
                          borderRadius: 10.0,
                          color: whiteColor.withOpacity(0.7)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          text(day!,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              height: 1.0),
                          text(month!,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              height: 1.0)
                        ],
                      ))),
            ],
          )),
    );
  }
}

/// Card that used into [SermonsScreen] to show sermons and [EventScreen] for Events
///
class CustomStaffCard extends StatelessWidget {
  const CustomStaffCard({
    Key? key,
    required this.image,
    required this.title,
    this.subtitle,
    this.titleFontSize = 18.0,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String? image, title, subtitle, icon;
  final double titleFontSize;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
          height: 46.0.h,
          margin: EdgeInsets.symmetric(vertical: 15.0),
          decoration: customBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: 100.0.w,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: CachedNetworkImage(
                    imageUrl: image!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  )),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 100.0.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 1.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.5.h),
                      Text(
                        '$title',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: titleFontSize.sp,
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: 0.0,
                            height: 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.0.h),
                      Text(
                        '$subtitle',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 8.0.sp,
                            color: primaryColor.withOpacity(0.5),
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: 0.0,
                            height: 1.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

/// Custom SliverAppBar with church logo and page name
///
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.bgImg,
  }) : super(key: key);

  final String? title, bgImg;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: false,
      brightness: Brightness.dark,
      backgroundColor: Color(0xffF5F5F5),
      leading: Container(),
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(bottom: 6.5.h),
          title: text(title!,
              color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w500),
          background: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.0.w,
                height: 100.0.h,
                child: CachedNetworkImage(
                  imageUrl: bgImg! == ''
                      ? 'https://upload.wikimedia.org/wikipedia/commons/6/68/Solid_black.png'
                      : bgImg!,
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: GetBuilder<ChurchController>(
                    builder: (controller) =>
                        controller.selectedChurch.value.logoUse! == "logo"
                            ? Container(
                                width: 50.0.w,
                                padding: EdgeInsets.only(bottom: 8.5.h),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        controller.selectedChurch.value.logo!),
                              )
                            : Padding(
                                padding: EdgeInsets.only(bottom: 8.5.h),
                                child: text(
                                    controller.selectedChurch.value.logoText!,
                                    color: whiteColor,
                                    height: 1.0,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              )),
              ),
            ],
          )),
    );
  }
}

/// Custom delegate for searchfield
///
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 46 + 40;

  @override
  double get maxExtent => 46 + 40;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      padding: EdgeInsets.only(top: 15),
      margin: EdgeInsets.symmetric(horizontal: 3.0.h),
      color: Color(0xffF5F5F5),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

///  Back button used  in sermon, event, staff, and other details screen
///
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        height: 10.0.h,
        padding: EdgeInsets.only(top: 5.0.h),
        child: Row(
          children: [
            customIcon(icon: back_icon, size: 2.0),
            SizedBox(width: 0.5.w),
            text('back', fontSize: 13.0, height: 1.2)
          ],
        ),
      ),
    );
  }
}
