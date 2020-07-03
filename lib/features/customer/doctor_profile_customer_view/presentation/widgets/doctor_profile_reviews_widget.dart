import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/bloc/bloc/doctor_profile_customer_view_bloc.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/presentation/widgets/reviews_list_single_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorProfileReviewsWidget extends StatefulWidget {
  final BasicDoctor doctor;

  const DoctorProfileReviewsWidget({Key key, this.doctor}) : super(key: key);

  @override
  _DoctorProfileReviewsWidgetState createState() =>
      _DoctorProfileReviewsWidgetState();
}

class _DoctorProfileReviewsWidgetState
    extends State<DoctorProfileReviewsWidget> {
  DoctorProfileCustomerViewBloc _doctorProfileCustomerViewBloc;
  List<Review> reviews;
  bool _isLoadError = false, _isMaxReviews = false;

  @override
  void initState() {
    _doctorProfileCustomerViewBloc = sl<DoctorProfileCustomerViewBloc>();

    _doctorProfileCustomerViewBloc.add(LoadDoctorReviewsEvent(
        categoryID: widget.doctor.categoryId, doctorID: widget.doctor.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _doctorProfileCustomerViewBloc,
      listener: (context, state) {
        if (state is LoadedReviews) {
          setState(() {
            _isLoadError = false;
            if (reviews == null) {
              reviews = state.reviews;
            } else {
              reviews.addAll(state.reviews);
            }

            if (state.reviews.length < Constant.DOCTOR_REVIEWS_LOAD_LIMIT) {
              _isMaxReviews = true;
            }
          });
        } else if (state is ReviewsLoadError) {
          setState(() {
            _isLoadError = true;
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Patient Reviews",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constant.DEFAULT_FONT,
                  ),
                ),
              ],
            ),
          ),
          Column(
              children: reviews != null && reviews.length > 0
                  ? reviews.map((review) {
                      return ReviewsListSingleItemWidget(
                        review: review,
                      );
                    }).toList()
                  : [Container()]),
          BlocBuilder(
            bloc: _doctorProfileCustomerViewBloc,
            builder: (context, state) {
              if (state is LoadingReviews || state is Initial) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ReviewsLoadError) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: Text(
                    "Some error occurred",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.DARK_GRAY,
                      fontFamily: Constant.DEFAULT_FONT,
                    ),
                  ),
                );
              }

              return Container();
            },
          ),
          !_isMaxReviews
              ? InkWell(
                  onTap: () {
                    _doctorProfileCustomerViewBloc.add(LoadDoctorReviewsEvent(
                        lastFetchedReviewID: reviews?.last?.id,
                        categoryID: widget.doctor.categoryId,
                        doctorID: widget.doctor.id));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      _isLoadError ? "Reload reviews" : "Read more reviews",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          fontFamily: Constant.DEFAULT_FONT,
                          fontSize: 16),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: Text(
                    "No more reviews",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.DARK_GRAY,
                      fontFamily: Constant.DEFAULT_FONT,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
