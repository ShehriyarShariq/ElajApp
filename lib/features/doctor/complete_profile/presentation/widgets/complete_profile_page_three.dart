import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/input_widget.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';

class CompleteProfilePageThree extends StatefulWidget {
  final CompleteProfileBloc bloc;

  const CompleteProfilePageThree({Key key, this.bloc}) : super(key: key);

  @override
  _CompleteProfilePageThreeState createState() =>
      _CompleteProfilePageThreeState();
}

class _CompleteProfilePageThreeState extends State<CompleteProfilePageThree> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationBarWidget(
              bloc: widget.bloc,
              isBack: true,
            ),
            Text(
              "Add Your Location",
              style: TextStyle(fontFamily: Constant.DEFAULT_FONT, fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            _fieldWidget(labelText: "Address", type: "address"),
            _fieldWidget(labelText: "City", type: "city"),
            _fieldWidget(labelText: "Province", type: "province"),
            _fieldWidget(labelText: "Zip", type: "zip"),
            _fieldWidget(labelText: "Country", type: "country"),
            Container(
              height: 50,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              color: Theme.of(context).primaryColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.bloc.add(FetchAllDataEvent());
                  },
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Book Appointment",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _fieldWidget({String labelText, String type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              labelText,
              style: TextStyle(fontFamily: Constant.DEFAULT_FONT, fontSize: 20),
            ),
          ),
          Expanded(
            child: InputWidget(bloc: widget.bloc, pageNum: 3, type: type),
          ),
        ],
      ),
    );
  }
}
