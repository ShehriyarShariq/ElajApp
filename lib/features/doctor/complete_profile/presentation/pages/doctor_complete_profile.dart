import 'package:elaj/core/ui/loading_widget.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/complete_profile_page_one.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/complete_profile_page_three.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/complete_profile_page_two.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/education_employmentHist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorCompleteProfile extends StatefulWidget {
  @override
  _DoctorCompleteProfileState createState() => _DoctorCompleteProfileState();
}

class _DoctorCompleteProfileState extends State<DoctorCompleteProfile> {
  CompleteProfileBloc _completeProfileBloc;

  Map<String, dynamic> initData = Map();

  int currentPageIndex = 0;

  Widget currentPage;

  @override
  void initState() {
    _completeProfileBloc = sl<CompleteProfileBloc>();

    _completeProfileBloc.add(LoadInitDataEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 20,
        title: Text("Complete Profile",
            style: TextStyle(
                fontSize: Constant.TITLE_SIZE,
                fontFamily: Constant.DEFAULT_FONT)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocListener(
          bloc: _completeProfileBloc,
          listener: (context, state) {
            if (state is GoToNextPage) {
              print(currentPageIndex);

              CompleteDoctorSingleton completeDoctorSingleton =
                  CompleteDoctorSingleton();

              bool isValid = false;

              switch (currentPageIndex) {
                case 0:
                  isValid = completeDoctorSingleton.completeDoctor
                      .isFirstFullyInitialized();
                  break;
                case 1:
                  isValid = completeDoctorSingleton.completeDoctor
                      .isSecondFullyInitialized();
                  break;
              }

              if (isValid) {
                print("NEXT");
                currentPageIndex += 1;
                setState(() {
                  if (currentPageIndex == 1) {
                    currentPage = CompleteProfilePageTwo(
                      bloc: _completeProfileBloc,
                      initData: initData,
                      alreadyFilledData: completeDoctorSingleton.completeDoctor
                              .isSecondFullyInitialized()
                          ? completeDoctorSingleton.completeDoctor
                          : null,
                    );
                  } else {
                    currentPage =
                        CompleteProfilePageThree(bloc: _completeProfileBloc);
                  }
                  _completeProfileBloc.add(ResetEvent());
                });
              }
              // _completeProfileBloc.add(ResetEvent());
            } else if (state is GoToPrevPage) {
              CompleteDoctorSingleton completeDoctorSingleton =
                  CompleteDoctorSingleton();

              print("LMAO" + currentPageIndex.toString());

              currentPageIndex -= 1;

              setState(() {
                if (currentPageIndex == 0) {
                  currentPage = CompleteProfilePageOne(
                    bloc: _completeProfileBloc,
                    initData: initData,
                    alreadyFilledData: completeDoctorSingleton.completeDoctor,
                  );
                } else {
                  currentPage = CompleteProfilePageTwo(
                    bloc: _completeProfileBloc,
                    initData: initData,
                    alreadyFilledData: completeDoctorSingleton.completeDoctor,
                  );
                }
              });
              _completeProfileBloc.add(ResetEvent());
            }
          },
          child: BlocBuilder(
            bloc: _completeProfileBloc,
            builder: (context, state) {
              if (state is Loading) {
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
                          _completeProfileBloc.add(LoadInitDataEvent());
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
                initData = state.initData;
              }

              return currentPage == null
                  ? CompleteProfilePageOne(
                      bloc: _completeProfileBloc, initData: initData)
                  : currentPage;
            },
          ),
        ),
      ),
    );
  }
}
