import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/view_image/presentation/pages/view_card.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/add_medical_record/presentation/pages/add_medical_record.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class MedicalRecordsListItem extends StatefulWidget {
  final MedicalRecord medicalRecord;

  MedicalRecordsListItem(this.medicalRecord);

  @override
  _MedicalRecordsListItemState createState() => _MedicalRecordsListItemState();
}

class _MedicalRecordsListItemState extends State<MedicalRecordsListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.medicalRecord == null
        ? _getLoadView(context)
        : _getLoadedView(context);
  }

  Widget _getLoadView(context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
      padding: const EdgeInsets.all(10),
      // height: 80,
      color: Theme.of(context).accentColor,
      child: Column(
        children: [
          Row(
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
                      // Description
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
                    ],
                  );
                },
              )),
              SizedBox(
                width: 15,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.1),
                highlightColor: Colors.grey.withOpacity(0.2),
                child: CircleAvatar(
                  radius: 15,
                ),
                // Material(
                //   color: Theme.of(context).primaryColor,
                //   borderRadius: BorderRadius.circular(15),
                //   child: InkWell(
                //     onTap: () {},
                //     borderRadius: BorderRadius.circular(15),
                //     child: SizedBox(
                //       width: 30,
                //       height: 30,
                //       child: Icon(
                //         Icons.edit,
                //         color: Colors.white,
                //         size: 18,
                //       ),
                //     ),
                //   ),
                // ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.grey.withOpacity(0.2),
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 30,
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLoadedView(context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
      padding: const EdgeInsets.all(10),
      // height: 80,
      color: Theme.of(context).accentColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 15) * 0.20,
                  height: (MediaQuery.of(context).size.width - 15) * 0.20,
                  color: AppColor.DARK_GRAY,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        DateFormat("MMMM\ndd")
                            .format(widget.medicalRecord.date),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.GRAY,
                            fontFamily: Constant.DEFAULT_FONT),
                      ),
                    ),
                  ),
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
                      // Description
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: constraints.maxWidth,
                        child: Text(
                          widget.medicalRecord.desc,
                          style: TextStyle(
                              fontSize: 17, fontFamily: Constant.DEFAULT_FONT),
                        ),
                      ),

                      // // Doctor Name
                      // Container(
                      //   margin: const EdgeInsets.only(top: 20),
                      //   width: constraints.maxWidth,
                      //   child: RichText(
                      //     text: TextSpan(
                      //         text: "Doctor: ",
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             fontFamily: Constant.DEFAULT_FONT,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //         children: <TextSpan>[
                      //           TextSpan(
                      //               text:
                      //                   widget.medicalRecord.doctorName == null
                      //                       ? "N/A"
                      //                       : widget.medicalRecord.doctorName,
                      //               style: TextStyle(
                      //                   fontSize: 17,
                      //                   fontWeight: FontWeight.normal))
                      //         ]),
                      //   ),
                      // ),

                      // // Doctor Specialty
                      // Container(
                      //   margin: const EdgeInsets.only(top: 10),
                      //   width: constraints.maxWidth,
                      //   child: RichText(
                      //     text: TextSpan(
                      //         text: "Specialty: ",
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             fontFamily: Constant.DEFAULT_FONT,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //         children: <TextSpan>[
                      //           TextSpan(
                      //               text: widget.medicalRecord
                      //                           .doctorSpecialty ==
                      //                       null
                      //                   ? "N/A"
                      //                   : widget.medicalRecord.doctorSpecialty,
                      //               style: TextStyle(
                      //                   fontSize: 17,
                      //                   fontWeight: FontWeight.normal))
                      //         ]),
                      //   ),
                      // ),
                    ],
                  );
                },
              )),
              SizedBox(
                width: 15,
              ),
              Material(
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddMedicalRecord(
                                  medicalRecord: widget.medicalRecord,
                                )));
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.6),
                    radius: 15,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
          !_isExpanded
              ? SizedBox(
                  height: 30,
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width - 50,
                      child: RichText(
                        text: TextSpan(
                            text: "Doctor: ",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.medicalRecord.doctorName == null
                                      ? "N/A"
                                      : widget.medicalRecord.doctorName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal))
                            ]),
                      ),
                    ),

                    // Doctor Specialty
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 50,
                      child: RichText(
                        text: TextSpan(
                            text: "Specialty: ",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.medicalRecord.doctorSpecialty ==
                                          null
                                      ? "N/A"
                                      : widget.medicalRecord.doctorSpecialty,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.medicalRecord.images.values
                          .map((value) => _image(value))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
          Material(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width - 50,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewCard(
                        imageURL: image,
                      )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          child: LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewCard(
                              imageURL: image,
                            )));
              },
              child: FadeInImage(
                  image: NetworkImage(image),
                  placeholder: AssetImage("imgs/placeholder.png"),
                  fit: BoxFit.cover),
            );
          }),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.02),
            border: Border.all(
              color: Colors.black.withOpacity(0.8),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
