import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:photofilters/photofilters.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Album/album_bloc.dart';
import 'package:skoolfame/Data/Models/album_images_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> privacyList = ["Only me", "Friends", "Public"];
  String? privacyOptionSelect;
  String? fileName;
  List<Filter> filters = presetFiltersList;
  final picker = ImagePicker();
  File? imageFile;
  var albumBloc = AlbumBloc();
  final _formKey = GlobalKey<FormState>();
  String albumId = "";
  File? profileImage;
  var imageData = ImagesData();

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments is ImagesData) {
      imageData = ModalRoute.of(context)!.settings.arguments as ImagesData;
      albumId = imageData.albumId!;
    } else {
      albumId = ModalRoute.of(context)!.settings.arguments as String;
    }
    if (imageData.photoTitle != null) {
      titleController.text = imageData.photoTitle!;
      descriptionController.text = imageData.photoDescription!;
      privacyOptionSelect = imageData.privacy;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorPrimaryLight,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textWhiteColor,
          ),
        ),
        backgroundColor: AppColors.colorPrimaryLight,
        elevation: 0,
        centerTitle: true,
        title: CustomWidgets.text(AppStrings.addAPhoto,
            fontSize: 16, fontWeight: FontWeight.bold),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<AlbumBloc, AlbumState>(
            bloc: albumBloc,
            listener: (context, state) {
              if (state is AddImagesSuccessState ||
                  state is EditImagesSuccessState) {
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<AlbumBloc, AlbumState>(
              bloc: albumBloc,
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                fontSize: 14.5,
                                color: AppColors.textNotificationGreyColor),
                            hintText: AppStrings.photoTitle,
                          ),
                          validator: (photoTitle) {
                            if (photoTitle!.isEmpty) {
                              return "Please enter title";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintStyle: const TextStyle(
                                fontSize: 14.5,
                                color: AppColors.textNotificationGreyColor),
                            hintText: AppStrings.photoDescription,
                          ),
                          validator: (photoDescription) {
                            if (photoDescription!.isEmpty) {
                              return "Please enter description";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      InkWell(
                        onTap: () async {
                          final pickedFile = await picker.getImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            imageFile = File(pickedFile.path);
                            fileName = path.basename(imageFile!.path);
                            var image = imageLib
                                .decodeImage(await imageFile!.readAsBytes());
                            image = imageLib.copyResize(image!, width: 600);
                            Map imagefile = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoFilterSelector(
                                  title: const Text(
                                    "Photo Filter Example",
                                  ),
                                  appBarColor: AppColors.colorPrimaryLight,
                                  image: image!,
                                  filters: presetFiltersList,
                                  filename: fileName!,
                                  loader: Center(
                                      child: CircularProgressIndicator()),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );

                            if (imagefile != null &&
                                imagefile.containsKey('image_filtered')) {
                              setState(() {
                                imageFile = imagefile['image_filtered'];
                              });
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 6.0, right: 6.0, top: 18),
                          child: imageFile != null
                              ? Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 15.h,
                                      width: 100.w,
                                      // color: Colors.amber,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomWidgets().customIcon(
                                              icon: Assets.iconsEdit,
                                              size: 2.5,
                                              color:
                                                  AppColors.colorPrimaryLight),
                                        )),
                                  ],
                                )
                              : imageData.imagePath != null
                                  ? Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          height: 15.h,
                                          width: 100.w,
                                          // color: Colors.amber,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              imageData.imagePath!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustomWidgets().customIcon(
                                                  icon: Assets.iconsEdit,
                                                  size: 2.5,
                                                  color: AppColors
                                                      .colorPrimaryLight),
                                            )),
                                      ],
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.24.h,
                                              color: AppColors
                                                  .textNotificationGreyColor
                                                  .withOpacity(0.7)),
                                        ),
                                        color: AppColors.textWhiteColor,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomWidgets.text(
                                                AppStrings.uploadPhoto,
                                                color: AppColors
                                                    .textNotificationGreyColor),
                                            CustomWidgets().customIcon(
                                                icon: Assets.iconsCamera,
                                                size: 3)
                                          ],
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 6.0, right: 6.0, top: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.24.h,
                                  color: AppColors.textNotificationGreyColor
                                      .withOpacity(0.7)),
                            ),
                            color: AppColors.textWhiteColor,
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: CustomWidgets().customIcon(
                                icon: Assets.iconsDownArrow, size: 2.7),
                            dropdownColor: AppColors.textWhiteColor,
                            hint: CustomWidgets.text(
                              AppStrings.privacy,
                              color: AppColors.textNotificationGreyColor,
                              fontSize: 12,
                            ),
                            value: privacyOptionSelect,
                            items: privacyList.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: CustomWidgets.text(value,
                                      color: AppColors.textBlackColor));
                            }).toList(),
                            onChanged: (v) {
                              privacyOptionSelect = v;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      MyButton(
                        height: 6.9.h,
                        label: AppStrings.save.toUpperCase(),
                        labelTextColor: AppColors.textWhiteColor,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textWhiteColor,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print("AlbumID ${albumId}");
                            Map<String, dynamic> params = {
                              "album_id": albumId,
                              "photo_title": titleController.text,
                              "photo_description": descriptionController.text,
                              "privacy": privacyOptionSelect
                            };
                            if (imageFile != null) {
                              params['file'] = await d.MultipartFile.fromFile(
                                  imageFile!.path,
                                  filename: path.basename(imageFile!.path),
                                  contentType: MediaType("image", "jpg"));
                            }
                            imageData.sId != null
                                ? albumBloc.add(
                                    EditImagesApiEvent(params, imageData.sId!))
                                : albumBloc.add(AddImagesApiEvent(params));
                          }
                          // Navigator.of(context).pushNamed(Routes.IMAGES_SCREEN_DETAILS);
                        },
                        color: AppColors.colorPrimary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
