import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking_singleton.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/selected_slot.dart';
import 'package:elaj/features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/header_widget.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/input_widget.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/other_widget.dart';
import 'package:elaj/features/customer/book_appointment/presentation/widgets/toggle_widget.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/home_customer/presentation/pages/home_customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import 'package:intl/intl.dart';

import '../../../../../injection_container.dart';

class PatientDetails extends StatefulWidget {
  final BasicDoctor doctor;
  final SelectedSlot selectedSlot;

  PatientDetails({this.doctor, this.selectedSlot});

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  bool _isSelf, _isProcessing = false;
  BookAppointmentBloc _bookAppointmentBloc;

  @override
  void initState() {
    _bookAppointmentBloc = sl<BookAppointmentBloc>();

    _isSelf = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isProcessing) {
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                titleSpacing: 0,
                title: Text("Patient Details",
                    style: TextStyle(
                        fontSize: Constant.TITLE_SIZE,
                        fontFamily: Constant.DEFAULT_FONT)),
              ),
              body: Builder(builder: (context) {
                return BlocListener(
                  bloc: _bookAppointmentBloc,
                  listener: (context, state) {
                    if (state is ShowSelf) {
                      setState(() {
                        _isSelf = true;
                      });
                    } else if (state is ShowOther) {
                      setState(() {
                        _isSelf = false;
                      });
                    } else if (state is Error) {
                      _bookAppointmentBloc.add(DummyEvent());
                      Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text(
                            state.msg,
                            style: TextStyle(fontFamily: Constant.DEFAULT_FONT),
                          )));
                    } else if (state is PaymentStatusChecked) {
                      // if (state.isPayNow) {
                      // } else {
                      //   BookingSingleton bookingSingleton = BookingSingleton();

                      //   _bookAppointmentBloc.add(BookCustomerAppointmentEvent(
                      //       booking: bookingSingleton.booking));
                      // }
                    } else if (state is Booked) {
                      Navigator.of(context).popUntil((route) => route.isFirst);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => CustomerHome(startFromTab: 1)));
                    }
                  },
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HeaderWidget(
                            doctor: widget.doctor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: Text(
                                            (DateFormat("dd MMM yyyy")).format(
                                                widget.selectedSlot.day.date),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: Text(
                                            DateFormat('h:mm ').format(widget
                                                    .selectedSlot
                                                    .daySlot
                                                    .start) +
                                                (widget.selectedSlot.daySlot
                                                            .start.hour >=
                                                        12
                                                    ? "PM"
                                                    : "AM"),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                ToggleWidget(
                                  type: "isSelf",
                                  options: ["Myself", "Other"],
                                  bookAppointmentBloc: _bookAppointmentBloc,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                _isSelf
                                    ? Container()
                                    : OtherWidget(
                                        bookAppointmentBloc:
                                            _bookAppointmentBloc,
                                      ),
                                Container(
                                  height: 50,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  color: Theme.of(context).primaryColor,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        _bookAppointmentBloc
                                            .add(FetchAllValuesEvent());
                                      },
                                      child: Container(
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            "Book Appointment",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    Constant.DEFAULT_FONT,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            BlocBuilder(
              bloc: _bookAppointmentBloc,
              builder: (context, state) {
                if (state is FetchingData) {
                  _isProcessing = true;
                  return OverlayLoader.Overlay();
                } else if (state is PaymentStatusChecked) {
                  if (!state.isPayNow) {
                    _isProcessing = true;
                    return OverlayLoader.Overlay();
                  }
                }

                _isProcessing = false;

                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  _showPaymentStatusDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Payment Status"),
            content: Text(
              "Since the booking is within a time frame of an hour from the current time, you are required to Pay first in order to complete the booking. Press OK to be redirected to the payment gateway or press CANCEL to go back.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("NO"),
              ),
              FlatButton(
                onPressed: () {
                  // Payment shizz here
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }
}
