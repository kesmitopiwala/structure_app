import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Album/album_bloc.dart';
import 'package:skoolfame/Data/Models/album_model.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/my_button.dart';
import 'package:skoolfame/generated/assets.dart';

class AddAlbumScreen extends StatefulWidget {
  const AddAlbumScreen({Key? key}) : super(key: key);

  @override
  State<AddAlbumScreen> createState() => _AddAlbumScreenState();
}

class _AddAlbumScreenState extends State<AddAlbumScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? privacyOptionSelect;
  final ImagePicker _picker = ImagePicker();
  File? albumImage;
  var albumBloc = AlbumBloc();
  AlbumData albumData = AlbumData();

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      albumData = ModalRoute.of(context)!.settings.arguments as AlbumData;
      titleController.text = albumData.photoTitle!;
      descriptionController.text = albumData.photoDescription!;
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
        title: CustomWidgets.text(
            albumData != null ? AppStrings.updateAAlbum : AppStrings.addAAlbum,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: BlocListener<AlbumBloc, AlbumState>(
              bloc: albumBloc,
              listener: (context, state) {
                if (state is AddAlbumSuccessState ||
                    state is EditAlbumSuccessState) {
                  Navigator.pop(context);
                }
              },
              child: BlocBuilder<AlbumBloc, AlbumState>(
                bloc: albumBloc,
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14.5,
                                color: AppColors.textNotificationGreyColor),
                            hintText: AppStrings.albumTitle,
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
                        height: 7,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                fontSize: 14.5,
                                color: AppColors.textNotificationGreyColor),
                            hintText: AppStrings.albumDescription,
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
                        height: 2,
                      ),
                      InkWell(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          albumImage = File(image!.path);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 6.0, right: 6.0, top: 18),
                          child: albumImage != null
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
                                          albumImage!,
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
                              : albumData.sId != null
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
                                              albumData.imageUrl!,
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
                                                AppStrings.albumPhoto,
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
                            Map<String, dynamic> params = {
                              "photo_title": titleController.text,
                              "photo_description": descriptionController.text,
                            };
                            if (albumImage != null) {
                              params['file'] = await d.MultipartFile.fromFile(
                                  albumImage!.path,
                                  filename: path.basename(albumImage!.path),
                                  contentType: MediaType("image", "jpg"));
                            }
                            albumData.sId != null
                                ? albumBloc.add(
                                    EditAlbumApiEvent(params, albumData.sId!))
                                : albumBloc.add(AddAlbumApiEvent(params));
                          }
                        },
                        color: AppColors.colorPrimary,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
