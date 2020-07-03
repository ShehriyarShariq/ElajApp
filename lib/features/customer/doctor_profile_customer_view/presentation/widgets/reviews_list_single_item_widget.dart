import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsListSingleItemWidget extends StatelessWidget {
  final Review review;

  const ReviewsListSingleItemWidget({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.GRAY,
                radius: 22,
                child: Text(
                  review.customerName[0].toUpperCase(),
                  style: TextStyle(
                      color: AppColor.DARK_GRAY,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: Constant.DEFAULT_FONT),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getHiddenName(),
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.DARK_GRAY),
                  ),
                  SizedBox(
                    height: 7.5,
                  ),
                  Text(
                    _getTimeStamp(),
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: 14,
                        color: AppColor.DARK_GRAY),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 59),
            child: SmoothStarRating(
              isReadOnly: true,
              color: Color.fromRGBO(237, 220, 24, 1),
              borderColor: Colors.black.withOpacity(0.4),
              rating: review.star.toDouble(),
              size: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  review.message,
                  style: TextStyle(
                      fontFamily: Constant.DEFAULT_FONT,
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black.withOpacity(0.6)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String _getHiddenName() {
    String name = review.customerName;
    if (name.length - 2 > 0) {
      String subStr = name.substring(1, name.length - 1);

      return name[0] +
          subStr.replaceAll(RegExp('[^ ]'), '*') +
          name[name.length - 1];
    }

    return name;
  }

  String _getTimeStamp() {
    Duration diff = DateTime.now().difference(review.timeStamp);

    String durationStr;

    if (diff.inDays > 0) {
      if (diff.inDays > 365) {
        int val = diff.inDays ~/ 365;
        durationStr = val.toString() + " year" + (val > 1 ? "s" : "");
      } else if (diff.inDays > 30) {
        int val = diff.inDays ~/ 30.42;
        durationStr = val.toString() + " month" + (val > 1 ? "s" : "");
      } else {
        durationStr =
            diff.inDays.toString() + " day" + (diff.inDays > 1 ? "s" : "");
      }
    } else if (diff.inHours > 0) {
      durationStr =
          diff.inHours.toString() + " hour" + (diff.inHours > 1 ? "s" : "");
    } else if (diff.inMinutes > 0) {
      durationStr =
          diff.inMinutes.toString() + " min" + (diff.inMinutes > 1 ? "s" : "");
    } else if (diff.inSeconds > 0) {
      durationStr =
          diff.inSeconds.toString() + " sec" + (diff.inSeconds > 1 ? "s" : "");
    }

    return durationStr + " ago";
  }
}
