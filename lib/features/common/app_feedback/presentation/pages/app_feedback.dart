import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/ui/overlay_loader.dart' as OverlayLoader;
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/app_feedback/presentation/bloc/bloc/app_feedback_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../injection_container.dart';

class AppFeedback extends StatefulWidget {
  @override
  _AppFeedbackState createState() => _AppFeedbackState();
}

class _AppFeedbackState extends State<AppFeedback> {
  AppFeedbackBloc _appFeedbackBloc;

  TextEditingController title = TextEditingController(),
      desc = TextEditingController();

  @override
  void initState() {
    _appFeedbackBloc = sl<AppFeedbackBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            titleSpacing: 20,
            title: Text("Give Feedback",
                style: TextStyle(
                    fontSize: Constant.TITLE_SIZE,
                    fontFamily: Constant.DEFAULT_FONT)),
          ),
          body: BlocListener(
            bloc: _appFeedbackBloc,
            listener: (context, state) {
              if (state is Success) {
                Navigator.pop(context);
              } else if (state is Error) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text(
                    "Some Error Occurred!",
                    style: TextStyle(fontFamily: Constant.DEFAULT_FONT),
                  ),
                ));
              }
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "For any bugs or weird interactions you might have come across when using the app, let the developers know to help them better the app for a smoother experience.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: Colors.black.withOpacity(0.6),
                              height: 1.5),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _inputWidget(controller: title, hint: "Title"),
                        SizedBox(
                          height: 15,
                        ),
                        _inputWidget(
                            controller: desc,
                            hint: "Description (Min 15 characters)",
                            initHeight: 200),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          color: Theme.of(context).primaryColor,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (title.text.length > 0 &&
                                    desc.text.length >= 15) {
                                  _appFeedbackBloc.add(GiveFeedbackEvent(
                                      title: title.text, desc: desc.text));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Invalid Input!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.6),
                                      textColor: Colors.white,
                                      fontSize: 17);
                                }
                              },
                              child: Container(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Give Feedback",
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder(
          bloc: _appFeedbackBloc,
          builder: (context, state) {
            if (state is Processing) {
              return OverlayLoader.Overlay();
            }

            return Container();
          },
        )
      ],
    );
  }

  Widget _inputWidget(
      {TextEditingController controller, String hint, double initHeight}) {
    return Container(
      height: initHeight != null ? initHeight : null,
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.DARK_GRAY),
          borderRadius: BorderRadius.circular(3)),
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 17,
                fontFamily: Constant.DEFAULT_FONT,
                color: AppColor.DARK_GRAY),
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.all(0)),
        style: TextStyle(
            fontSize: 17, fontFamily: Constant.DEFAULT_FONT, height: 1.5),
      ),
    );
  }
}
