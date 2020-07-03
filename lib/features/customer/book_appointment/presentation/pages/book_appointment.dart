import 'package:elaj/core/ui/loading_widget.dart';
import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking_singleton.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/selected_slot.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:elaj/features/customer/book_appointment/presentation/pages/patient_details.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/header_widget.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../injection_container.dart';

class BookAppointment extends StatefulWidget {
  final BasicDoctor doctor;

  BookAppointment({this.doctor});

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  BookAppointmentBloc _bookAppointmentBloc;
  Availability availability;

  SelectedSlot currentSelectedSlot = SelectedSlot();

  @override
  void initState() {
    _bookAppointmentBloc = sl<BookAppointmentBloc>();

    _bookAppointmentBloc.add(GetDoctorTimingsEvent(doctorID: widget.doctor.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 0,
        title: Text("Book Appointment",
            style: TextStyle(
                fontSize: Constant.TITLE_SIZE,
                fontFamily: Constant.DEFAULT_FONT)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                HeaderWidget(doctor: widget.doctor),
                BlocBuilder(
                  bloc: _bookAppointmentBloc,
                  builder: (context, state) {
                    print(state);
                    if (state is Loading || state is Initial) {
                      return Expanded(
                        child: Container(
                            color: AppColor.GRAY, child: LoadingWidget()),
                      );
                    } else if (state is Error) {
                      return Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: AppColor.GRAY,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Some error occurred! Try again",
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
                                  _bookAppointmentBloc.add(
                                      GetDoctorTimingsEvent(
                                          doctorID: widget.doctor.id));
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
                        ),
                      );
                    } else if (state is Loaded) {
                      availability = state.availability;
                    }

                    if (availability != null) print("AAAAAAAAAAAAAA");

                    return _buildBody(context, availability);
                  },
                ),
              ],
            ),
          ),
          currentSelectedSlot.isSet()
              ? Container(
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  color: Theme.of(context).primaryColor,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        BookingSingleton bookingSingleton =
                            new BookingSingleton();
                        bookingSingleton.booking.doctorId = widget.doctor.id;
                        bookingSingleton.booking.categoryID =
                            widget.doctor.categoryId;
                        bookingSingleton.booking.date =
                            currentSelectedSlot.day.date;
                        bookingSingleton.booking.startTime =
                            currentSelectedSlot.daySlot.start;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PatientDetails(
                                  doctor: widget.doctor,
                                )));
                      },
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).accentColor,
                                fontFamily: Constant.DEFAULT_FONT),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildBody(context, Availability availability) {
    if (currentSelectedSlot.day == null)
      currentSelectedSlot.day = availability.availableDays[0];

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: availability.availableDays
                        .map((day) => _dateItemWidget(day))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    DateFormat('E, d MMMM')
                        .format(currentSelectedSlot.day.date.toLocal()),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: Constant.DEFAULT_FONT)),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Available Slots",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    fontFamily: Constant.DEFAULT_FONT),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: currentSelectedSlot.day.slots != null
                        ? currentSelectedSlot.day.slots
                            .map((slot) => _slotItemWidget(slot))
                            .toList()
                        : [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                "None",
                                style: TextStyle(
                                    fontFamily: Constant.DEFAULT_FONT,
                                    fontSize: 15,
                                    color: AppColor.DARK_GRAY),
                              ),
                            )
                          ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateItemWidget(AvailableDay day) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.4 * 0.3,
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          color: currentSelectedSlot.day != day
              ? Colors.transparent
              : Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(
              color: currentSelectedSlot.day != day
                  ? Colors.black.withOpacity(0.4)
                  : Theme.of(context).primaryColor,
              width: 1.5),
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          setState(() {
            currentSelectedSlot.day = day;
            currentSelectedSlot.daySlot = null;
          });
        },
        child: Center(
          child: Text(
            DateFormat('E, d MMMM').format(day.date.toLocal()),
            style: TextStyle(
              fontSize: 17,
              fontFamily: Constant.DEFAULT_FONT,
              color: currentSelectedSlot.day != day
                  ? Colors.black.withOpacity(0.7)
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _slotItemWidget(DaySlot slotTime) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.4 * 0.25,
      margin: const EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
          color: currentSelectedSlot.daySlot != slotTime
              ? Colors.transparent
              : Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(
              color: currentSelectedSlot.daySlot != slotTime
                  ? Colors.black.withOpacity(0.4)
                  : Theme.of(context).primaryColor,
              width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          setState(() {
            currentSelectedSlot.daySlot = slotTime;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Text(
              DateFormat('HH:mm').format(slotTime.start) +
                  (slotTime.start.hour >= 12 ? "PM" : "AM"),
              style: TextStyle(fontSize: 15, fontFamily: Constant.DEFAULT_FONT),
            ),
          ),
        ),
      ),
    );
  }
}
