import 'package:elaj/core/ui/loading_widget.dart';
import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/view_image/presentation/pages/view_card.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/bloc/bloc/home_doctor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorPublicProfile extends StatefulWidget {
  @override
  _DoctorPublicProfileState createState() => _DoctorPublicProfileState();
}

class _DoctorPublicProfileState extends State<DoctorPublicProfile> {
  HomeDoctorBloc _homeDoctorBloc;
  CompleteDoctor doctor;

  @override
  void initState() {
    _homeDoctorBloc = sl<HomeDoctorBloc>();

    _homeDoctorBloc.add(GetDoctorProfileEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 0,
        title: Text("Profile",
              style: TextStyle(
                  fontSize: Constant.TITLE_SIZE - 2,
                  fontFamily: Constant.DEFAULT_FONT)),
        
      ),
      body: BlocBuilder(
        bloc: _homeDoctorBloc,
        builder: (context, state) {
          print(state);
          if (state is LoadingProfile || state is Initial) {
            return LoadingWidget();
          } else if (state is Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Some error occurred! Try again",
                    style: TextStyle(
                        color: AppColor.DARK_GRAY,
                        fontSize: 22,
                        fontFamily: Constant.DEFAULT_FONT),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    onPressed: () {
                      _homeDoctorBloc.add(GetDoctorWalletEvent());
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
          } else if (state is LoadedProfile) {
            doctor = state.completeDoctor;
          }

          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
              margin: const EdgeInsets.only(bottom: 15),
              color: doctor.isVerified
                  ? Colors.green
                  : Theme.of(context).errorColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    doctor.isVerified ? "Verified" : "Unverified",
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    doctor.isVerified ? Icons.check : Icons.warning,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20 - 3,
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.4 - 3,
                    width: MediaQuery.of(context).size.width * 0.4 - 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewCard(
                                      imageURL: doctor.profileImg,
                                    )));
                      },
                      child: ClipOval(
                        child: FadeInImage(
                            image: NetworkImage(doctor.profileImg),
                            placeholder: AssetImage(doctor.gender == "M"
                                ? "imgs/doctor_male.png"
                                : "imgs/doctor_female.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontFamily: Constant.DEFAULT_FONT,
                    fontSize: 24,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  doctor.gender,
                  style: TextStyle(
                    fontFamily: Constant.DEFAULT_FONT,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "PMDC NO: ",
                  style: TextStyle(
                    fontFamily: Constant.DEFAULT_FONT,
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: doctor.pmdcNum,
                      style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 16,
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    doctor.overview,
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 17,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                  _imageFieldSection(
                      title: "Liscense",
                      images: {"liscense": doctor.liscenseImg}),
                  _imageFieldSection(
                      title: "Degree", images: {"degree": doctor.degreeImg}),
                  _imageFieldSection(
                      title: "Certification(s)",
                      fieldName: "Description: ",
                      fieldValue: doctor.certification.desc,
                      images: doctor.certification.proofImages),
                  _imageFieldSection(
                      title: "Experience(s)",
                      fieldName: "Year(s): ",
                      fieldValue: doctor.experience.years,
                      images: doctor.experience.proofImages),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Education",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  _educationOrEmployementHistWidget(
                      education: doctor.education),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Employment History",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  _educationOrEmployementHistWidget(
                      employmentHist: doctor.employmentHist)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _educationOrEmployementHistWidget(
      {List<Education> education, List<EmploymentHistory> employmentHist}) {
    List list = education != null ? education : employmentHist;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map((item) => (education != null
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: "Institute: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.institute,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Degree: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.degree,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "CGPA",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.cgpa,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Start Year: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.startYear,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Completion Year: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.completionYear,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: "Company: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.company,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Designation: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.designation,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Joining",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.joiningDate,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Leaving: ",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontSize: 15,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: item.leavingDate,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      fontSize: 17,
                                      color: Colors.black.withOpacity(0.5)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )))
            .toList());
  }

  Widget _imageFieldSection(
      {String title,
      String fieldName,
      String fieldValue,
      Map<String, String> images}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: Constant.DEFAULT_FONT,
              fontSize: 18,
              color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        fieldName != null
            ? Column(
                children: [
                  RichText(
                    text: TextSpan(
                        text: fieldName,
                        style: TextStyle(
                            fontFamily: Constant.DEFAULT_FONT,
                            fontSize: 15,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: fieldValue,
                            style: TextStyle(
                                fontFamily: Constant.DEFAULT_FONT,
                                fontSize: 17,
                                color: Colors.black.withOpacity(0.5)),
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: images.values.map((value) => _image(value)).toList(),
        )
      ],
    );
  }

  Widget _image(String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewCard(
                        imageURL: image,
                      )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          child: LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewCard(
                              imageURL: image,
                            )));
              },
              child: FadeInImage(
                  image: NetworkImage(image),
                  placeholder: AssetImage("imgs/placeholder.png"),
                  fit: BoxFit.cover),
            );
          }),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.02),
            border: Border.all(
              color: Colors.black.withOpacity(0.8),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
