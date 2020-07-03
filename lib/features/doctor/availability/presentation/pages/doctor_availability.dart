import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/home_customer/presentation/widgets/medical_records_tab.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/availability/presentation/bloc/bloc/availability_bloc.dart';
import 'package:elaj/features/doctor/availability/presentation/widgets/expandable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            automaticallyImplyLeading: true,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: <Widget>[
                Text("Schedule",
                    style: TextStyle(
                        fontSize: Constant.TITLE_SIZE,
                        fontFamily: Constant.DEFAULT_FONT)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (availability != null)
                            _availabilityBloc.add(FetchAllDataEvent());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text("Save",
                              style: TextStyle(
                                  fontSize: Constant.TITLE_SIZE - 2,
                                  fontFamily: Constant.DEFAULT_FONT)),
                        ),
                      )
                    ],
                  ),
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
                    } else if (state is SlotError) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text(
                            "Some days have invalid slots due to already present appointments.",
                            style: TextStyle(fontFamily: Constant.DEFAULT_FONT),
                          )));
                    } else if (state is Saved) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: BlocBuilder<AvailabilityBloc, AvailabilityState>(
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
          children: availability.availableDays
              .map((day) => ExpandableListWidget(
                    availabilityBloc: _availabilityBloc,
                    day: day,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
