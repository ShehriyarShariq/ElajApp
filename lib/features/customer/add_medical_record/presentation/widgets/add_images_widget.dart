import 'dart:io';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record_page.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/bloc/bloc/add_medical_records_bloc.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/pages/add_medical_record.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/widgets/recorded_images_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddImagesWidget extends StatefulWidget {
  final AddMedicalRecordsBloc bloc;
  final Map<String, String> alreadyAddedImages;
  final List<File> newlyAddedImages;

  const AddImagesWidget(
      {Key key, this.bloc, this.alreadyAddedImages, this.newlyAddedImages})
      : super(key: key);

  @override
  _AddImagesWidgetState createState() => _AddImagesWidgetState();
}

class _AddImagesWidgetState extends State<AddImagesWidget> {
  List<MedicalRecordPage> allImages = List();
  bool _isError = false;
  ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    if (widget.alreadyAddedImages != null) {
      widget.alreadyAddedImages.forEach((key, imageURL) {
        allImages.add(MedicalRecordPage(id: key, imageURL: imageURL));
      });
    }

    widget.newlyAddedImages.forEach((imageFile) {
      allImages.add(MedicalRecordPage(imageFile: imageFile));
    });

    allImages.add(MedicalRecordPage());

    super.initState();
  }

  void _openCamera() async {
    var image = await _imagePicker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);

    Navigator.pop(context);

    if (image != null) {
      setState(() {
        _isError = false;
        allImages.insert(
            allImages.length - 1,
            MedicalRecordPage(
                imageFile: image != null ? File(image.path) : null));
      });
    } else {
      setState(() {
        if (allImages.length == 0) _isError = true;
      });
    }
  }

  void _openGallery() async {
    var image = await _imagePicker.getImage(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);

    Navigator.pop(context);

    if (image != null) {
      setState(() {
        _isError = false;
        allImages.insert(
            allImages.length - 1,
            MedicalRecordPage(
                imageFile: image != null ? File(image.path) : null));
      });
    } else {
      setState(() {
        if (allImages.length == 0) _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is Fetching) {
          if (allImages.length > 0) {
            _isError = false;
            widget.bloc.add(SaveFetchedValueEvent(type: "images", property: {
              "pages": allImages.sublist(0, allImages.length - 1),
              "existingImages": widget.alreadyAddedImages
            }));
            widget.bloc.add(ResetEvent());
          } else {
            widget.bloc.add(ResetEvent());
            setState(() {
              _isError = true;
            });
          }
        }
      },
      child: Container(
        color: AppColor.GRAY,
        padding: const EdgeInsets.symmetric(horizontal: 7.5),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: allImages
                  .map((page) => RecordImagesListItemWidget(
                      recordPage: page,
                      deleteFun: () {
                        setState(() {
                          allImages.remove(page);
                        });
                      },
                      isError: !page.isNull() ? false : _isError,
                      addBtnFun: !page.isNull()
                          ? null
                          : _showAddMedicalRecordsBottomSheet))
                  .toList(),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  _showAddMedicalRecordsBottomSheet() {
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: AppColor.GRAY,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Add Medical Record",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: Constant.DEFAULT_FONT,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    _bottomSheetRowItem(
                      icon: Icons.camera_alt,
                      label: "Take a photo",
                      onTap: _openCamera,
                    ),
                    _bottomSheetRowItem(
                      icon: Icons.image,
                      label: "Upload from gallery",
                      onTap: _openGallery,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _bottomSheetRowItem(
      {IconData icon, String label, bool isBorder = true, Function onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.5),
      decoration: BoxDecoration(
        border: Border(
          bottom: isBorder
              ? BorderSide(color: AppColor.DARK_GRAY, width: 0.1)
              : BorderSide.none,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColor.DARK_GRAY,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              label,
              style: TextStyle(
                  fontFamily: Constant.DEFAULT_FONT,
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7)),
            )
          ],
        ),
      ),
    );
  }
}
