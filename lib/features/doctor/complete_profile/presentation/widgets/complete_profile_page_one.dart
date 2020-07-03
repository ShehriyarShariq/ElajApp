import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/pages/select_specialties.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/certification_experience_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/input_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/navigation_bar_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/specialty_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/upload_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/uploaded_image_list_item_widget.dart';
import 'package:flutter/material.dart';

class CompleteProfilePageOne extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final Map<String, dynamic> initData;
  final CompleteDoctor alreadyFilledData;

  const CompleteProfilePageOne(
      {Key key, this.bloc, this.initData, this.alreadyFilledData})
      : super(key: key);

  @override
  _CompleteProfilePageOneState createState() => _CompleteProfilePageOneState();
}

class _CompleteProfilePageOneState extends State<CompleteProfilePageOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpecialtyWidget(
                    bloc: widget.bloc,
                    allCategories: widget.initData['categories'],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _fieldWidget(
                      labelText: "PMDC no",
                      type: "pmdc",
                      text: widget.alreadyFilledData != null
                          ? widget.alreadyFilledData.pmdcNum
                          : null),
                  UploadWidget(
                    fieldName: "Upload your picture",
                    type: "profileImg",
                    bloc: widget.bloc,
                    pageNum: 1,
                    alreadyUploadedImgs: widget.alreadyFilledData != null
                        ? [widget.alreadyFilledData.profileImgFile]
                        : null,
                  ),
                  UploadWidget(
                    fieldName: "Upload your liscense proof",
                    type: "liscenseImg",
                    bloc: widget.bloc,
                    pageNum: 1,
                    alreadyUploadedImgs: widget.alreadyFilledData != null
                        ? [widget.alreadyFilledData.liscenseImgFile]
                        : null,
                  ),
                  UploadWidget(
                    fieldName: "Upload your degree",
                    type: "degreeImg",
                    bloc: widget.bloc,
                    pageNum: 1,
                    alreadyUploadedImgs: widget.alreadyFilledData != null
                        ? [widget.alreadyFilledData.degreeImgFile]
                        : null,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CertificationOrExperienceWidget(
                    bloc: widget.bloc,
                    type: "certification",
                    title: "Certification(s)",
                    pageNum: 1,
                    certOrExp: widget.alreadyFilledData != null
                        ? widget.alreadyFilledData.certification
                        : null,
                  ),
                  CertificationOrExperienceWidget(
                    bloc: widget.bloc,
                    type: "experience",
                    title: "Experience(s)",
                    pageNum: 1,
                    certOrExp: widget.alreadyFilledData != null
                        ? widget.alreadyFilledData.experience
                        : null,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Write a professional overview",
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT, fontSize: 24),
                  ),
                  Text(
                    "highlight your top skills, experienmce, and interest.",
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT, fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputWidget(
                    bloc: widget.bloc,
                    type: "overview",
                    pageNum: 1,
                    text: widget.alreadyFilledData != null
                        ? widget.alreadyFilledData.overview
                        : null,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  NavigationBarWidget(
                    bloc: widget.bloc,
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _fieldWidget({String labelText, String type, String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              labelText,
              style: TextStyle(fontFamily: Constant.DEFAULT_FONT, fontSize: 20),
            ),
          ),
          Expanded(
            child: InputWidget(
              bloc: widget.bloc,
              pageNum: 1,
              type: type,
              text: text,
            ),
          ),
        ],
      ),
    );
  }
}
