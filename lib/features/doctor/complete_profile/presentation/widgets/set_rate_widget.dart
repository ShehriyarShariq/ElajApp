import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetRateWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final double serviceChargesVal;
  final String rate;

  const SetRateWidget({Key key, this.bloc, this.serviceChargesVal, this.rate})
      : super(key: key);

  @override
  _SetRateWidgetState createState() => _SetRateWidgetState();
}

class _SetRateWidgetState extends State<SetRateWidget> {
  TextEditingController rate = TextEditingController(),
      serviceCharges = TextEditingController(),
      actualAmount = TextEditingController();
  bool _isError = false;

  @override
  void initState() {
    rate.text = "0";
    serviceCharges.text = "-";
    actualAmount.text = "-";

    rate.addListener(() {
      if (rate.text.length == 0 ||
          rate.text == "0" ||
          !RegExp(r"^\d+$").hasMatch(rate.text)) {
        rate.text = "0";
        serviceCharges.text = "-";
        actualAmount.text = "-";

        _isError = false;
      } else {
        int rateAmount = int.parse(rate.text);

        int serviceChargesAmount =
            (rateAmount * widget.serviceChargesVal).floor();
        int actualAmountValue = rateAmount - serviceChargesAmount;

        serviceCharges.text = serviceChargesAmount.toString();
        actualAmount.text = actualAmountValue.toString();
      }
    });

    if (widget.rate != null) rate.text = widget.rate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is Fetching) {
          if (rate.text == "0") {
            widget.bloc.add(ResetEvent());
            setState(() {
              _isError = true;
            });
          } else {
            widget.bloc.add(SaveFetchedDataEvent(
                pageNum: 2, property: rate.text, type: "rate"));
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Set Your Fees/Rate",
              style: TextStyle(
                fontFamily: Constant.DEFAULT_FONT,
                fontSize: 24,
              )),
          row(label: "Rate", controller: rate),
          row(
              label: "20% Service Fee",
              controller: serviceCharges,
              isEnabled: false),
          row(
              label: "You'll be paid",
              controller: actualAmount,
              isEnabled: false)
        ],
      ),
    );
  }

  Widget row(
      {String label, TextEditingController controller, bool isEnabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 20, fontFamily: Constant.DEFAULT_FONT),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "PKR",
              style: TextStyle(fontSize: 16, fontFamily: Constant.DEFAULT_FONT),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3 * 0.4,
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                border: Border.all(
                    color: _isError && isEnabled
                        ? Theme.of(context).errorColor
                        : Colors.black),
                color: isEnabled
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.2)),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: TextField(
                readOnly: !isEnabled,
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(0)),
                style:
                    TextStyle(fontSize: 22, fontFamily: Constant.DEFAULT_FONT),
              ),
            ),
          )
        ],
      ),
    );
  }
}
