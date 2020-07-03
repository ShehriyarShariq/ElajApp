import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/education_employmentHist_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/navigation_bar_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/set_rate_widget.dart';
import 'package:flutter/material.dart';

class CompleteProfilePageTwo extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final Map<String, dynamic> initData;
  final CompleteDoctor alreadyFilledData;

  const CompleteProfilePageTwo(
      {Key key, this.bloc, this.initData, this.alreadyFilledData})
      : super(key: key);

  @override
  _CompleteProfilePageTwoState createState() => _CompleteProfilePageTwoState();
}

class _CompleteProfilePageTwoState extends State<CompleteProfilePageTwo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationBarWidget(
              bloc: widget.bloc,
              isBack: true,
            ),
            EducationOrEmploymentHistWidget(
                bloc: widget.bloc,
                eduOrEmp: widget.alreadyFilledData != null
                    ? widget.alreadyFilledData.education
                    : null),
            EducationOrEmploymentHistWidget(
                bloc: widget.bloc,
                isEdu: false,
                eduOrEmp: widget.alreadyFilledData != null
                    ? widget.alreadyFilledData.employmentHist
                    : null),
            SizedBox(
              height: 10,
            ),
            SetRateWidget(
                bloc: widget.bloc,
                serviceChargesVal: widget.initData["serviceCharges"],
                rate: widget.alreadyFilledData != null
                    ? widget.alreadyFilledData.rate.toString()
                    : null),
            SizedBox(
              height: 30,
            ),
            NavigationBarWidget(
              bloc: widget.bloc,
            )
          ],
        )),
      ),
    );
  }
}
