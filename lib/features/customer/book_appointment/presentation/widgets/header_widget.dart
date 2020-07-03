import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  BasicDoctor doctor;

  HeaderWidget({this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.GRAY,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: (MediaQuery.of(context).size.width - 15) * 0.105,
              backgroundColor: Theme.of(context).primaryColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    (MediaQuery.of(context).size.width - 15) * 0.10),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 15) * 0.20,
                  height: (MediaQuery.of(context).size.width - 15) * 0.20,
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
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Dr. " + doctor.name,
                          style: TextStyle(
                              fontFamily: Constant.DEFAULT_FONT,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    text: TextSpan(
                        text: "For: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constant.DEFAULT_FONT,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Rs." + doctor.rate.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
