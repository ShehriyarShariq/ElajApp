import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class ToggleWidget extends StatefulWidget {
  CredentialsBloc bloc;
  List<String> options;
  String type;

  ToggleWidget({this.type, this.options, this.bloc});

  @override
  _ToggleWidgetState createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  bool isFirst;

  @override
  void initState() {
    if (widget.bloc == null) widget.bloc = sl<CredentialsBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst == null) isFirst = true;

    return BlocListener(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is Fetching) {
          widget.bloc
              .add(SaveFetchedValueEvent(type: widget.type, property: isFirst));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (!isFirst) {
                        setState(() {
                          isFirst = true;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isFirst
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                              color: isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          widget.options[0],
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (isFirst) {
                        setState(() {
                          isFirst = false;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: !isFirst
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                              color: !isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          widget.options[1],
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: !isFirst
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
