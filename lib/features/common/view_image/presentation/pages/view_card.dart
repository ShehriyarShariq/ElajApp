import 'package:elaj/core/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewCard extends StatelessWidget {
  String imageURL;

  ViewCard({this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          iconSize: 32,
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("View Image",
            style: TextStyle(
                fontSize: Constant.TITLE_SIZE,
                fontFamily: Constant.DEFAULT_FONT,
                color: Colors.black)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: PhotoView(
          imageProvider: NetworkImage(imageURL),
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }
}
