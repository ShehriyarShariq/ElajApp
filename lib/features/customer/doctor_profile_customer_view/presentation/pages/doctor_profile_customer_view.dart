import 'package:elaj/core/ui/loading_widget.dart';
import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/pages/book_appointment.dart';
import 'package:elaj/features/customer/book_appointment/presentation/pages/patient_details.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/bloc/bloc/doctor_profile_customer_view_bloc.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/widgets/doctor_profile_customer_view_header.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/widgets/doctor_profile_reviews_widget.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/widgets/expandable_list_widget.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorProfileCustomerView extends StatefulWidget {
  final BasicDoctor basicDoctor;

  const DoctorProfileCustomerView({Key key, this.basicDoctor})
      : super(key: key);

  @override
  _DoctorProfileCustomerViewState createState() =>
      _DoctorProfileCustomerViewState();
}

class _DoctorProfileCustomerViewState extends State<DoctorProfileCustomerView> {
  DoctorProfileCustomerViewBloc _doctorProfileCustomerViewBloc;
  CompleteDoctor _completeDoctor;

  @override
  void initState() {
    super.initState();
    _doctorProfileCustomerViewBloc = sl<DoctorProfileCustomerViewBloc>();

    _doctorProfileCustomerViewBloc
        .add(LoadDoctorProfileEvent(doctorID: widget.basicDoctor.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 0,
        title: Text("Dr. " + widget.basicDoctor.name,
            style: TextStyle(
                fontSize: Constant.TITLE_SIZE,
                fontFamily: Constant.DEFAULT_FONT)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DoctorProfileCustomerViewHeader(
                          doctor: widget.basicDoctor,
                        ),
                      ),
                      BlocBuilder(
                        bloc: _doctorProfileCustomerViewBloc,
                        builder: (context, state) {
                          if (state is Loading || state is Initial) {
                            return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: LoadingWidget());
                          } else if (state is Error) {
                            return Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
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
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8),
                                    onPressed: () {
                                      _doctorProfileCustomerViewBloc.add(
                                          LoadDoctorProfileEvent(
                                              doctorID: widget.basicDoctor.id));
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
                          } else if (state is Loaded) {
                            _completeDoctor = state.completeDoctor;
                          }

                          return Column(
                            children: [
                              _divider(),
                              DoctorProfileReviewsWidget(
                                doctor: widget.basicDoctor,
                              ),
                              _divider(),
                              _getExpandableListsSection(),
                              _divider(),
                              _getAboutSection()
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder(
              bloc: _doctorProfileCustomerViewBloc,
              builder: (context, state) {
                if (state is Loading) {
                  return Container();
                } else {
                  return _bookAppointmentBtn(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _bookAppointmentBtn(context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      color: Theme.of(context).primaryColor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BookAppointment(
                      doctor: widget.basicDoctor,
                    )));
          },
          child: Container(
            height: 50,
            child: Center(
              child: Text(
                "Book Appointment",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: Constant.DEFAULT_FONT,
                    color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 12.5,
      width: MediaQuery.of(context).size.width,
      color: AppColor.GRAY,
    );
  }

  Widget _getExpandableListsSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).primaryColor,
                size: 26,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Other Information",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constant.DEFAULT_FONT,
                ),
              ),
            ],
          ),
        ),
        ExpandableListWidget(
          title: "Education",
          items: _completeDoctor.education
              .map((education) =>
                  education.degree + ", " + education.completionYear)
              .toList(),
        ),
        ExpandableListWidget(
          title: "Specialization",
          items: _completeDoctor.specialties.values.map((e) => e).toList(),
        )
      ],
    );
  }

  Widget _getAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.5),
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "About",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constant.DEFAULT_FONT,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              _completeDoctor.overview,
              style: TextStyle(
                  fontFamily: Constant.DEFAULT_FONT,
                  fontSize: 16,
                  color: AppColor.DARK_GRAY),
            ),
          )
        ],
      ),
    );
  }
}
