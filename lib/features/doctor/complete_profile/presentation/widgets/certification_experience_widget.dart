import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/input_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class CertificationOrExperienceWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final String type, title;
  final int pageNum;
  final CertificationOrExperience certOrExp;

  const CertificationOrExperienceWidget(
      {Key key, this.bloc, this.type, this.pageNum, this.title, this.certOrExp})
      : super(key: key);

  @override
  _CertificationOrExperienceWidgetState createState() =>
      _CertificationOrExperienceWidgetState();
}

class _CertificationOrExperienceWidgetState
    extends State<CertificationOrExperienceWidget> {
  CertificationOrExperience certificationOrExperience =
      CertificationOrExperience();
  CompleteProfileBloc _bloc;

  @override
  void initState() {
    _bloc = sl<CompleteProfileBloc>();

    _bloc.add(ResetEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CompleteProfileBloc, CompleteProfileState>(
          bloc: widget.bloc,
          listener: (context, state) {
            if (state is Fetching) {
              _bloc.add(FetchAllChildFieldDataEvent(parentType: widget.type));
            }
          },
        ),
        BlocListener<CompleteProfileBloc, CompleteProfileState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is FetchedChildFieldData) {
              if (state.parentType == widget.type) {
                switch (state.type) {
                  case "certification_desc":
                    certificationOrExperience.desc = state.property;
                    break;
                  case "experience_years":
                    certificationOrExperience.years = state.property;
                    break;
                  default:
                    certificationOrExperience.imageFiles = state.property;
                    break;
                }
                if (certificationOrExperience.isAllSet()) {
                  widget.bloc.add(SaveFetchedDataEvent(
                      pageNum: 1,
                      property: certificationOrExperience,
                      type: widget.type));
                  widget.bloc.add(ResetEvent());
                }
                _bloc.add(ResetEvent());
              }
            }
          },
        )
      ],
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontFamily: Constant.DEFAULT_FONT, fontSize: 22),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    widget.type == "certification" ? "Desc:" : "Years:",
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: InputWidget(
                    bloc: _bloc,
                    type: widget.type == "certification"
                        ? "certification_desc"
                        : "experience_years",
                    pageNum: 1,
                    parentType: widget.type,
                    text: widget.certOrExp != null
                        ? widget.type == "certification"
                            ? widget.certOrExp.desc
                            : widget.certOrExp.years
                        : null,
                  ),
                ),
              ],
            ),
            UploadWidget(
              bloc: _bloc,
              fieldName: "Add Proof: ",
              pageNum: widget.pageNum,
              fieldTextSize: 20,
              type: widget.type + "_imageFiles",
              parentType: widget.type,
              isMultiple: true,
              alreadyUploadedImgs:
                  widget.certOrExp != null ? widget.certOrExp.imageFiles : null,
            ),
          ],
        ),
      ),
    );
  }
}
