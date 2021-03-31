import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/home_customer/presentation/widgets/medical_records_tab.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/availability/presentation/bloc/bloc/availability_bloc.dart';
import 'package:elaj/features/doctor/availability/presentation/widgets/expandable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../../core/ui/loading_widget.dart';

import '../../../../../injection_container.dart';

class DoctorAvailability extends StatefulWidget {
  @override
  _DoctorAvailabilityState createState() => _DoctorAvailabilityState();
}

class _DoctorAvailabilityState extends State<DoctorAvailability> {
  AvailabilityBloc _availabilityBloc;
  Availability availability;

  bool _isEditMode = false, _isLoaded = false;

  @override
  void initState() {
    _availabilityBloc = sl<AvailabilityBloc>();

    _availabilityBloc.add(LoadAvailableDaysEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            titleSpacing: 0,
            title: Stack(
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text("Schedule",
                        style: TextStyle(
                            fontSize: Constant.TITLE_SIZE - 2,
                            fontFamily: Constant.DEFAULT_FONT)),
                  ),
                ),
                _isEditMode
                    ? Positioned(
                        top: 0,
                        bottom: 0,
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditMode = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("CANCEL",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Constant.DEFAULT_FONT)),
                          ),
                        ),
                      )
                    : Container(),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 20,
                  child: BlocBuilder(
                      bloc: _availabilityBloc,
                      builder: (context, state) {
                        if (state is Loaded && !_isLoaded) {
                          _isLoaded = true;
                        }

                        return _isLoaded
                            ? GestureDetector(
                                onTap: () {
                                  if (_isEditMode) {
                                    if (availability != null)
                                      _availabilityBloc
                                          .add(FetchAllDataEvent());
                                  } else {
                                    setState(() {
                                      _isEditMode = true;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    !_isEditMode ? Icons.edit : Icons.save,
                                  ),
                                ),
                              )
                            : Container();
                      }),
                )
              ],
            ),
          ),
          body: Container(
            color: AppColor.GRAY,
            height: MediaQuery.of(context).size.height,
            child: Builder(builder: (context) {
              return BlocListener(
                  bloc: _availabilityBloc,
                  listener: (context, state) {
                    if (state is SnackBarError) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text(
                            state.msg,
                            style: TextStyle(fontFamily: Constant.DEFAULT_FONT),
                          )));
                    }
                    // else if (state is SlotError) {
                    //   if (state.invalidDays.length > 0) {
                    //     Scaffold.of(context).showSnackBar(SnackBar(
                    //         duration: Duration(milliseconds: 500),
                    //         content: Text(
                    //           "Some days have invalid slots due to already present appointments.",
                    //           style:
                    //               TextStyle(fontFamily: Constant.DEFAULT_FONT),
                    //         )));
                    //   }
                    // }
                    else if (state is Saved) {
                      Fluttertoast.showToast(
                          msg: "Saved Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.black.withOpacity(0.6),
                          textColor: Colors.white,
                          fontSize: 17);

                      setState(() {
                        _isEditMode = false;
                      });
                    }
                  },
                  child: BlocBuilder(
                    bloc: _availabilityBloc,
                    builder: (context, state) {
                      if (state is Initial && availability == null) {
                        return Container();
                      } else if (state is Loading) {
                        return Container(
                          child: LoadingWidget(),
                        );
                      } else if (state is Loaded) {
                        availability = state.availability;

                        // availability.availableDays.forEach((element) {
                        //   print(element.date);
                        //   element.slots.forEach((element) {
                        //     print(element.toJson());
                        //   });
                        // });
                      } else if (state is Error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.msg,
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
                                  _availabilityBloc
                                      .add(LoadAvailableDaysEvent());
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
                      }

                      return _buildBody(context);
                    },
                  ));
            }),
          ),
        ),
        BlocBuilder<AvailabilityBloc, AvailabilityState>(
          bloc: _availabilityBloc,
          builder: (context, state) {
            if (state is Processing) {
              return OverlayLoader.Overlay();
            }

            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildBody(context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: availability.availableDays.map((day) {
            // print(day.date);
            return ExpandableListWidget(
                availabilityBloc: _availabilityBloc,
                day: day,
                isEditable: _isEditMode);
          }).toList(),
        ),
      ),
    );
  }
}
