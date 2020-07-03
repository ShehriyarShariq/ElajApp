import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';

import '../../../../../injection_container.dart';

class EducationOrEmploymentHistWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final bool isEdu;
  final dynamic eduOrEmp;

  const EducationOrEmploymentHistWidget(
      {Key key, this.bloc, this.isEdu = true, this.eduOrEmp})
      : super(key: key);

  @override
  _EducationOrEmploymentHistWidgetState createState() =>
      _EducationOrEmploymentHistWidgetState();
}

class _EducationOrEmploymentHistWidgetState
    extends State<EducationOrEmploymentHistWidget> {
  CompleteProfileBloc _bloc;
  List<Widget> items = List();
  List<dynamic> objects = List();

  @override
  void initState() {
    _bloc = sl<CompleteProfileBloc>();

    _bloc.add(ResetEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
      if (widget.eduOrEmp != null) {
        if (widget.isEdu) {
          (widget.eduOrEmp as List<Education>)
              .asMap()
              .forEach((index, education) {
            items.add(_itemWidget(index, data: education));
            objects.add(education);
          });
        } else {
          (widget.eduOrEmp as List<EmploymentHistory>)
              .asMap()
              .forEach((index, empHist) {
            items.add(_itemWidget(index, data: empHist));
            objects.add(empHist);
          });
        }
      } else {
        items.add(_itemWidget(0));
        objects.add(widget.isEdu
            ? Education(id: randomAlphaNumeric(9))
            : EmploymentHistory(id: randomAlphaNumeric(9)));
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<CompleteProfileBloc, CompleteProfileState>(
          bloc: widget.bloc,
          listener: (context, state) {
            if (state is Fetching) {
              _bloc.add(FetchAllChildFieldDataEvent(
                  parentType: widget.isEdu ? "education" : "employmentHist"));
              widget.bloc.add(ResetEvent());
            }
          },
        ),
        BlocListener<CompleteProfileBloc, CompleteProfileState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is FetchedChildFieldData) {
              String fieldType =
                  state.type.substring(state.type.indexOf("_") + 1);

              switch (fieldType) {
                case "institute":
                  objects[state.parentIndex].institute = state.property;
                  break;
                case "degree":
                  objects[state.parentIndex].degree = state.property;
                  break;
                case "cgpa":
                  objects[state.parentIndex].cgpa = state.property;
                  break;
                case "startYear":
                  objects[state.parentIndex].startYear = state.property;
                  break;
                case "completionYear":
                  objects[state.parentIndex].completionYear = state.property;
                  break;
                case "company":
                  objects[state.parentIndex].company = state.property;
                  break;
                case "designation":
                  objects[state.parentIndex].designation = state.property;
                  break;
                case "joiningDate":
                  objects[state.parentIndex].joiningDate = state.property;
                  break;
                case "leavingDate":
                  objects[state.parentIndex].leavingDate = state.property;
                  break;
              }

              bool areAllSet = true;
              objects.forEach((element) {
                if (!element.isAllSet()) {
                  areAllSet = false;
                }
              });

              if (areAllSet) {
                widget.bloc.add(SaveFetchedDataEvent(
                    pageNum: 2,
                    property: objects,
                    type: widget.isEdu ? "education" : "employmentHist"));
                widget.bloc.add(ResetEvent());
              }

              _bloc.add(ResetEvent());
            }
          },
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.isEdu ? "Education" : "Employment History",
                  style: TextStyle(
                    fontFamily: Constant.DEFAULT_FONT,
                    fontSize: 24,
                  )),
              GestureDetector(
                onTap: () {
                  setState(() {
                    items.add(_itemWidget(items.length));
                    objects
                        .add(widget.isEdu ? Education() : EmploymentHistory());
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          Text(
              "Click the plus icon to add more " +
                  (widget.isEdu ? "education degrees." : "employment history"),
              style: TextStyle(
                fontFamily: Constant.DEFAULT_FONT,
                fontSize: 16,
              )),
          SizedBox(
            height: 10,
          ),
          Column(
            children: items,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _itemWidget(int index, {dynamic data}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all()),
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          index > 0
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        items.removeAt(index);
                        objects.removeAt(index);
                      });
                    },
                    child: Icon(
                      Icons.remove_circle_outline,
                      size: 30,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                )
              : SizedBox(
                  height: 15,
                ),
          widget.isEdu
              ? Column(
                  children: [
                    _fieldWidget(
                      fieldText: "Institute",
                      type: "education_institute",
                      parentIndex: index,
                      text: data != null ? (data as Education).institute : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _fieldWidget(
                      fieldText: "Degree",
                      type: "education_degree",
                      parentIndex: index,
                      text: data != null ? (data as Education).degree : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _fieldWidget(
                      fieldText: "CGPA",
                      type: "education_cgpa",
                      parentIndex: index,
                      text: data != null ? (data as Education).cgpa : null,
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
              : Column(
                  children: [
                    _fieldWidget(
                      fieldText: "Company",
                      type: "employmentHist_company",
                      parentIndex: index,
                      text: data != null
                          ? (data as EmploymentHistory).company
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _fieldWidget(
                      fieldText: "Job",
                      type: "employmentHist_designation",
                      parentIndex: index,
                      text: data != null
                          ? (data as EmploymentHistory).designation
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
          _fieldWidget(
            fieldText: "Start Year",
            type: widget.isEdu
                ? "education_startYear"
                : "employmentHist_joiningDate",
            parentIndex: index,
            text: data != null
                ? widget.isEdu
                    ? (data as Education).startYear
                    : (data as EmploymentHistory).joiningDate
                : null,
          ),
          SizedBox(
            height: 10,
          ),
          _fieldWidget(
            fieldText: "End Year",
            type: widget.isEdu
                ? "education_completionYear"
                : "employmentHist_leavingDate",
            parentIndex: index,
            text: data != null
                ? widget.isEdu
                    ? (data as Education).completionYear
                    : (data as EmploymentHistory).leavingDate
                : null,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _fieldWidget(
      {String fieldText, String type, String text, int parentIndex}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          width: 100,
          child: Text(
            fieldText,
            style: TextStyle(fontFamily: Constant.DEFAULT_FONT, fontSize: 20),
          ),
        ),
        Expanded(
          child: InputWidget(
            bloc: _bloc,
            pageNum: 2,
            type: type,
            text: text,
            parentIndex: parentIndex,
            parentType: widget.isEdu ? "education" : "employmentHist",
          ),
        ),
      ],
    );
  }
}
