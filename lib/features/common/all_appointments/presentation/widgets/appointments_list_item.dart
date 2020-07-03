import 'package:elaj/core/util/colors.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentsListItem extends StatelessWidget {
  BasicAppointment appointment;
  bool shimmer;

  AppointmentsListItem(this.appointment, {this.shimmer = false});

  @override
  Widget build(BuildContext context) {
    return appointment == null
        ? _getLoadView(context)
        : GestureDetector(
            onTap: () {},
            child: Container(
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
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 15) * 0.20,
                      height: (MediaQuery.of(context).size.width - 15) * 0.20,
                      padding: EdgeInsets.all(
                          (MediaQuery.of(context).size.width - 15) * 0.025),
                      child: FadeInImage(
                          image: AssetImage(appointment?.gender != null
                              ? appointment.gender == "M"
                                  ? "imgs/doctor_male.png"
                                  : "imgs/doctor_female.png"
                              : "imgs/patient.png"), //NetworkImage(appointment.photoURL),
                          placeholder: AssetImage(appointment?.gender != null
                              ? appointment.gender == "M"
                                  ? "imgs/doctor_male.png"
                                  : "imgs/doctor_female.png"
                              : "imgs/patient.png"),
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
                            children: [
                              Flexible(
                                child: Text(
                                  "Dr. Hamza Iqbal",
                                  style: TextStyle(
                                      fontFamily: "Robotto",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                          // For
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: RichText(
                              overflow: TextOverflow.clip,
                              softWrap: false,
                              text: TextSpan(
                                  text: "For: ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Robotto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: appointment?.other == null
                                            ? "Self"
                                            : "Other",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal))
                                  ]),
                            ),
                          ),

                          // For Details
                          appointment?.other == null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: (constraints.maxWidth / 2) - 7.5,
                                        child: RichText(
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          text: TextSpan(
                                              text: "Name: ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Robotto",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: appointment
                                                                ?.other?.name ==
                                                            null
                                                        ? "N/A"
                                                        : appointment
                                                            .other.name,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ]),
                                        ),
                                      ),
                                      Container(
                                        width: (constraints.maxWidth / 2) - 7.5,
                                        child: RichText(
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          text: TextSpan(
                                              text: "Relation: ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Robotto",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: appointment?.other
                                                                ?.relationShip ==
                                                            null
                                                        ? "N/A"
                                                        : appointment
                                                            .other.relationShip,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),

                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                Container(
                                  width: (constraints.maxWidth / 2) - 7.5,
                                  child: RichText(
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                    text: TextSpan(
                                        text: "Start: ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Robotto",
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: appointment?.start == null
                                                  ? "N/A"
                                                  : appointment.start,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ]),
                                  ),
                                ),
                                Container(
                                  width: (constraints.maxWidth / 2) - 7.5,
                                  child: RichText(
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                    text: TextSpan(
                                        text: "End: ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Robotto",
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: appointment?.end == null
                                                  ? "N/A"
                                                  : appointment.end,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ]),
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
}
