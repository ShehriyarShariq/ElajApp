import 'package:elaj/core/util/colors.dart';
import 'package:flutter/material.dart';

class Overlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Material(
        elevation: 10,
        color: AppColor.DARK_GRAY,
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  strokeWidth: 5,
                ),
              ),
            )),
      ),
    );
  }
}
