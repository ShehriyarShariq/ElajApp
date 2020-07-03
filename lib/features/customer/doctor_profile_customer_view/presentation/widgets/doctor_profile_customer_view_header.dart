import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DoctorProfileCustomerViewHeader extends StatelessWidget {
  final BasicDoctor doctor;

  const DoctorProfileCustomerViewHeader({Key key, this.doctor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: AppColor.DARK_GRAY))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
                height: 5,
              ),
              doctor.rating >= 0
                  ? SmoothStarRating(
                      isReadOnly: true,
                      color: Color.fromRGBO(237, 220, 24, 1),
                      borderColor: Colors.black.withOpacity(0.4),
                      rating: doctor.rating,
                      size: ((MediaQuery.of(context).size.width - 15) * 0.20) *
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
                            fontFamily: "Robotto",
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
    );
  }
}
