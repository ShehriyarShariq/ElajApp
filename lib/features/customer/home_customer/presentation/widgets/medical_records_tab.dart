import 'dart:io';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/credentials/presentation/pages/credentials.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/pages/add_medical_record.dart';
import 'package:elaj/features/customer/home_customer/presentation/bloc/bloc/home_customer_bloc.dart';
import 'package:elaj/features/customer/home_customer/presentation/widgets/medical_records_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../injection_container.dart';

class MedicalRecordsTab extends StatefulWidget {
  @override
  _MedicalRecordsTabState createState() => _MedicalRecordsTabState();
}

class _MedicalRecordsTabState extends State<MedicalRecordsTab> {
  HomeCustomerBloc _homeCustomerBloc;
  List<MedicalRecord> medicalRecords,
      placeholderList = List.filled(5, null, growable: false);
  ImagePicker _imagePicker = ImagePicker();
  bool _showFAB;

  @override
  void initState() {
    _homeCustomerBloc = sl<HomeCustomerBloc>();

    _homeCustomerBloc.add(GetAllMedicalRecordsEvent());

    _showFAB = false;

    super.initState();
  }

  void _openCamera() async {
    var image = await _imagePicker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);

    Navigator.pop(context);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddMedicalRecord(
            alreadyPickedImage: image != null ? File(image.path) : null)));
  }

  void _openGallery() async {
    var image = await _imagePicker.getImage(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);

    Navigator.pop(context);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddMedicalRecord(
            alreadyPickedImage: image != null ? File(image.path) : null)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          titleSpacing: 20,
          title: Text("Medical Records",
              style: TextStyle(
                  fontSize: Constant.TITLE_SIZE,
                  fontFamily: Constant.DEFAULT_FONT)),
        ),
        body: BlocListener(
          bloc: _homeCustomerBloc,
          listener: (context, state) {
            if (state is ErrorUserNotLoggedIn) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Credentials(
                            isFromCustHome: true,
                          )));
            } else if (state is LoadedRecords) {
              setState(() {
                _showFAB = true;
              });
            }
          },
          child: Container(
            color: AppColor.GRAY,
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder(
              bloc: _homeCustomerBloc,
              builder: (context, state) {
                if (state is Error) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Some error occurred!",
                          style: TextStyle(
                              color: AppColor.DARK_GRAY,
                              fontSize: 22,
                              fontFamily: Constant.DEFAULT_FONT),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          onPressed: () {
                            _homeCustomerBloc.add(GetAllMedicalRecordsEvent());
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Try Again",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: Constant.DEFAULT_FONT),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (state is LoadedRecords) {
                  medicalRecords = state.medicalRecords;

                  if (medicalRecords.length == 0)
                    return Center(
                      child: Text(
                        "No Medical Records Added. \nClick on the add button to add some.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.3,
                            fontSize: 18,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    );
                }

                return ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                      child: Column(
                          children: medicalRecords != null
                              ? medicalRecords
                                  .map((record) => MedicalRecordsListItem(
                                        record,
                                      ))
                                  .toList()
                              : placeholderList
                                  .map((record) => MedicalRecordsListItem(
                                        record,
                                      ))
                                  .toList()),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: _showFAB
            ? FloatingActionButton(
                onPressed: () {
                  _showAddMedicalRecordsBottomSheet();
                },
                child: Icon(
                  Icons.description,
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).primaryColor,
              )
            : null);
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

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
