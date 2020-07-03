import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final bool isBack;

  const NavigationBarWidget({Key key, this.bloc, this.isBack = false})
      : super(key: key);

  @override
  _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  bool _isBackEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isBack ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        widget.isBack
            ? Container(
                height: 80,
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    if (_isBackEnabled)
                      widget.bloc.add(GoToPrevPageEvent());
                    else
                      setState(() {
                        _isBackEnabled = false;
                      });
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 32,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                        ),
                        child: Text("Go back",
                            style: TextStyle(
                                fontSize: Constant.TITLE_SIZE,
                                fontFamily: Constant.DEFAULT_FONT)),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: 80,
                alignment: Alignment.center,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    widget.bloc.add(FetchAllDataEvent());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Colors.black.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text("Next",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: Colors.black)),
                  ),
                ),
              )
      ],
    );
  }
}
