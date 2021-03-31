import 'package:elaj/features/common/appointment_details/presentation/pages/appointment_details.dart';
import 'package:intl/intl.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DoctorAppointmentsListItem extends StatelessWidget {
  BasicAppointment appointment;
  bool shimmer, _isCurrent;

  DoctorAppointmentsListItem(this.appointment, {this.shimmer = false});

  @override
  Widget build(BuildContext context) {
    if (appointment != null) {
      DateTime now = DateTime.now();
      if (!now.isBefore(appointment.start) && !now.isAfter(appointment.end)) {
        _isCurrent = true;
      } else {
        _isCurrent = false;
      }
    }

    return appointment == null
        ? _getLoadView(context)
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      AppointmentDetails(appointmentID: appointment.id)));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              padding: const EdgeInsets.fromLTRB(10, 2, 5, 10),
              // height: 80,
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border.all(
                      color: Colors.black.withOpacity(0.1), width: 2),
                  borderRadius: BorderRadius.circular(3)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width - 15) * 0.20,
                          height:
                              (MediaQuery.of(context).size.width - 15) * 0.20,
                          padding: EdgeInsets.all(
                              (MediaQuery.of(context).size.width - 15) * 0.025),
                          child: FadeInImage(
                              image: AssetImage(
                                  "imgs/patient.png"), //NetworkImage(appointment.photoURL),
                              placeholder: AssetImage("imgs/patient.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Name
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Hamza Iqbal",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  // CircleAvatar(
                                  //     radius: 13,
                                  //     backgroundColor: appointment.isPaid
                                  //         ? Colors.green
                                  //         : Colors.redAccent,
                                  //     foregroundColor: Colors.white,
                                  //     child: Icon(
                                  //       appointment.isPaid
                                  //           ? Icons.check
                                  //           : Icons.money_off,
                                  //       size: 16,
                                  //     )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(_formatTime(appointment.start),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ))
                    ],
                  ),
                  _isCurrent != null && _isCurrent
                      ? Container(
                          height: 40,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          color: Colors.orange,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (_) => BookAppointment()));
                              },
                              child: Container(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    "Join Session",
                                    style: TextStyle(
                                        fontFamily: Constant.DEFAULT_FONT,
                                        fontSize: 18,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
  }

  Widget _getLoadView(context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
      padding: const EdgeInsets.all(10),
      // height: 80,
      color: Theme.of(context).accentColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Shimmer.fromColors(
                child: Container(
                  width: (MediaQuery.of(context).size.width - 15) * 0.20,
                  height: (MediaQuery.of(context).size.width - 15) * 0.20,
                  color: Colors.white,
                ),
                baseColor: Colors.grey.withOpacity(0.1),
                highlightColor: Colors.grey.withOpacity(0.2)),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Name
                  Shimmer.fromColors(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 10,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      baseColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.2)),

                  // For
                  Shimmer.fromColors(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 10,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      baseColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.2)),

                  // For Details
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(children: [
                      Shimmer.fromColors(
                          child: Container(
                            margin: const EdgeInsets.only(right: 7.5),
                            height: 10,
                            width: (constraints.maxWidth / 2) - 7.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          baseColor: Colors.grey.withOpacity(0.1),
                          highlightColor: Colors.grey.withOpacity(0.2)),
                      Shimmer.fromColors(
                          child: Container(
                            margin: const EdgeInsets.only(left: 7.5),
                            height: 10,
                            width: (constraints.maxWidth / 2) - 7.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          baseColor: Colors.grey.withOpacity(0.1),
                          highlightColor: Colors.grey.withOpacity(0.2)),
                    ]),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(children: [
                      Shimmer.fromColors(
                          child: Container(
                            margin: const EdgeInsets.only(right: 7.5),
                            height: 30,
                            width: (constraints.maxWidth / 2) - 7.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          baseColor: Colors.grey.withOpacity(0.1),
                          highlightColor: Colors.grey.withOpacity(0.2)),
                      Shimmer.fromColors(
                          child: Container(
                            margin: const EdgeInsets.only(left: 7.5),
                            height: 30,
                            width: (constraints.maxWidth / 2) - 7.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          baseColor: Colors.grey.withOpacity(0.1),
                          highlightColor: Colors.grey.withOpacity(0.2)),
                    ]),
                  ),
                ],
              );
            },
          ))
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return (DateFormat.jm()).format(time.toLocal());
  }
}
