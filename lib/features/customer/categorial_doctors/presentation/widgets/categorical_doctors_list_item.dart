import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/presentation/pages/book_appointment.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/pages/doctor_profile_customer_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CategoricalDoctorListItem extends StatelessWidget {
  BasicDoctor doctor;
  bool shimmer;

  CategoricalDoctorListItem(this.doctor, {this.shimmer = false});

  @override
  Widget build(BuildContext context) {
    return doctor == null ? _getLoadView(context) : _getLoadedView(context);
    // GestureDetector(
    //     onTap: () {},
    //     child: Container(
    //       margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
    //       padding: const EdgeInsets.all(10),
    //       // height: 80,
    //       color: Theme.of(context).accentColor,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           ClipRRect(
    //             borderRadius: BorderRadius.circular(10),
    //             child: Container(
    //               width: (MediaQuery.of(context).size.width - 15) * 0.20,
    //               height: (MediaQuery.of(context).size.width - 15) * 0.20,
    //               padding: EdgeInsets.all(
    //                   (MediaQuery.of(context).size.width - 15) * 0.025),
    //               child: FadeInImage(
    //                   image: AssetImage(appointment?.gender != null
    //                       ? appointment.gender == "M"
    //                           ? "imgs/doctor_male.png"
    //                           : "imgs/doctor_female.png"
    //                       : "imgs/patient.png"), //NetworkImage(appointment.photoURL),
    //                   placeholder: AssetImage(appointment?.gender != null
    //                       ? appointment.gender == "M"
    //                           ? "imgs/doctor_male.png"
    //                           : "imgs/doctor_female.png"
    //                       : "imgs/patient.png"),
    //                   fit: BoxFit.cover),
    //             ),
    //           ),
    //           SizedBox(
    //             width: 15,
    //           ),
    //           Expanded(child: LayoutBuilder(
    //             builder: (context, constraints) {
    //               return Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 mainAxisSize: MainAxisSize.max,
    //                 children: [
    //                   // Name
    //                   Row(
    //                     children: [
    //                       Flexible(
    //                         child: Text(
    //                           "Dr. Hamza Iqbal",
    //                           style: TextStyle(
    //                               fontFamily: "Roboto",
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 17),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   // For
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 15),
    //                     child: RichText(
    //                       overflow: TextOverflow.clip,
    //                       softWrap: false,
    //                       text: TextSpan(
    //                           text: "For: ",
    //                           style: TextStyle(
    //                               fontSize: 14,
    //                               fontFamily: "Roboto",
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.bold),
    //                           children: <TextSpan>[
    //                             TextSpan(
    //                                 text: appointment?.other == null
    //                                     ? "Self"
    //                                     : "Other",
    //                                 style: TextStyle(
    //                                     fontSize: 16,
    //                                     fontWeight: FontWeight.normal))
    //                           ]),
    //                     ),
    //                   ),

    //                   // For Details
    //                   appointment?.other == null
    //                       ? Padding(
    //                           padding: const EdgeInsets.only(top: 5),
    //                           child: Row(
    //                             children: [
    //                               Container(
    //                                 width: (constraints.maxWidth / 2) - 7.5,
    //                                 child: RichText(
    //                                   overflow: TextOverflow.clip,
    //                                   softWrap: false,
    //                                   text: TextSpan(
    //                                       text: "Name: ",
    //                                       style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: "Roboto",
    //                                           color: Colors.black,
    //                                           fontWeight: FontWeight.bold),
    //                                       children: <TextSpan>[
    //                                         TextSpan(
    //                                             text: appointment
    //                                                         ?.other?.name ==
    //                                                     null
    //                                                 ? "N/A"
    //                                                 : appointment
    //                                                     .other.name,
    //                                             style: TextStyle(
    //                                                 fontSize: 16,
    //                                                 fontWeight:
    //                                                     FontWeight.normal))
    //                                       ]),
    //                                 ),
    //                               ),
    //                               Container(
    //                                 width: (constraints.maxWidth / 2) - 7.5,
    //                                 child: RichText(
    //                                   overflow: TextOverflow.clip,
    //                                   softWrap: false,
    //                                   text: TextSpan(
    //                                       text: "Relation: ",
    //                                       style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: "Roboto",
    //                                           color: Colors.black,
    //                                           fontWeight: FontWeight.bold),
    //                                       children: <TextSpan>[
    //                                         TextSpan(
    //                                             text: appointment?.other
    //                                                         ?.relationShip ==
    //                                                     null
    //                                                 ? "N/A"
    //                                                 : appointment
    //                                                     .other.relationShip,
    //                                             style: TextStyle(
    //                                                 fontSize: 16,
    //                                                 fontWeight:
    //                                                     FontWeight.normal))
    //                                       ]),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         )
    //                       : Container(),

    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 30),
    //                     child: Row(
    //                       children: [
    //                         Container(
    //                           width: (constraints.maxWidth / 2) - 7.5,
    //                           child: RichText(
    //                             overflow: TextOverflow.clip,
    //                             softWrap: false,
    //                             text: TextSpan(
    //                                 text: "Start: ",
    //                                 style: TextStyle(
    //                                     fontSize: 14,
    //                                     fontFamily: "Roboto",
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.bold),
    //                                 children: <TextSpan>[
    //                                   TextSpan(
    //                                       text: appointment?.start == null
    //                                           ? "N/A"
    //                                           : appointment.start,
    //                                       style: TextStyle(
    //                                           fontSize: 16,
    //                                           fontWeight:
    //                                               FontWeight.normal))
    //                                 ]),
    //                           ),
    //                         ),
    //                         Container(
    //                           width: (constraints.maxWidth / 2) - 7.5,
    //                           child: RichText(
    //                             overflow: TextOverflow.clip,
    //                             softWrap: false,
    //                             text: TextSpan(
    //                                 text: "End: ",
    //                                 style: TextStyle(
    //                                     fontSize: 14,
    //                                     fontFamily: "Roboto",
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.bold),
    //                                 children: <TextSpan>[
    //                                   TextSpan(
    //                                       text: appointment?.end == null
    //                                           ? "N/A"
    //                                           : appointment.end,
    //                                       style: TextStyle(
    //                                           fontSize: 16,
    //                                           fontWeight:
    //                                               FontWeight.normal))
    //                                 ]),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               );
    //             },
    //           ))
    //         ],
    //       ),
    //     ),
    //   );
  }

  Widget _getLoadView(context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
      padding: const EdgeInsets.all(10),
      // height: 80,
      color: Theme.of(context).accentColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.5, color: AppColor.DARK_GRAY))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          (MediaQuery.of(context).size.width - 15) * 0.10),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.1),
                        highlightColor: Colors.grey.withOpacity(0.2),
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width - 15) * 0.20,
                          height:
                              (MediaQuery.of(context).size.width - 15) * 0.20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.2),
                      child: SmoothStarRating(
                        // isReadOnly: true,
                        color: Color.fromRGBO(237, 220, 24, 1),
                        borderColor: Colors.black.withOpacity(0.4),
                        rating: 5,
                        size:
                            ((MediaQuery.of(context).size.width - 15) * 0.20) *
                                0.17,
                      ),
                    )
                  ],
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

                        // Specialty
                        Shimmer.fromColors(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 30,
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            baseColor: Colors.grey.withOpacity(0.1),
                            highlightColor: Colors.grey.withOpacity(0.2)),

                        // For Experience
                        Shimmer.fromColors(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, right: 7.5),
                              height: 10,
                              width: (constraints.maxWidth * 0.75) - 7.5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            baseColor: Colors.grey.withOpacity(0.1),
                            highlightColor: Colors.grey.withOpacity(0.2)),
                      ],
                    );
                  },
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Expanded(
                  child: Shimmer.fromColors(
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      baseColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.2)),
                ),
                Expanded(
                  child: Shimmer.fromColors(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      baseColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.2)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getLoadedView(context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
        padding: const EdgeInsets.all(10),
        // height: 80,
        color: Theme.of(context).accentColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(width: 0.5, color: AppColor.DARK_GRAY))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius:
                            (MediaQuery.of(context).size.width - 15) * 0.105,
                        backgroundColor: AppColor.DARK_GRAY,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.width - 15) * 0.10),
                          child: Container(
                            width:
                                (MediaQuery.of(context).size.width - 15) * 0.20,
                            height:
                                (MediaQuery.of(context).size.width - 15) * 0.20,
                            color: Colors.white,
                            child: FadeInImage(
                                image: NetworkImage(doctor.photoURL),
                                placeholder: AssetImage(doctor.gender == "M"
                                    ? "imgs/doctor_male.png"
                                    : "imgs/doctor_female.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      doctor.rating >= 0
                          ? SmoothStarRating(
                              isReadOnly: true,
                              color: Color.fromRGBO(237, 220, 24, 1),
                              borderColor: Colors.black.withOpacity(0.4),
                              rating: doctor.rating,
                              size: ((MediaQuery.of(context).size.width - 15) *
                                      0.20) *
                                  0.17,
                            )
                          : Text(
                              "unrated",
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColor.DARK_GRAY),
                            ),
                    ],
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
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Dr. " + doctor.name,
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),

                          // Specialty
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              doctor.specialty,
                              style: TextStyle(
                                  fontFamily: Constant.DEFAULT_FONT,
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 15),
                            ),
                          ),

                          // For Experience
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: RichText(
                              text: TextSpan(
                                text: doctor.expYears.toString() + " Year(s) ",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Roboto",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "experience",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(0.5),
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => DoctorProfileCustomerView(
                                    basicDoctor: doctor,
                                  )));
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              "View Profile",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BookAppointment(
                                    doctor: doctor,
                                  )));
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 50,
                          child: Center(
                            child: Text(
                              "Book Appointment",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: Constant.DEFAULT_FONT,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
