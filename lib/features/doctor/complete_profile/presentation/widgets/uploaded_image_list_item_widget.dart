import 'dart:io';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadedImageListItemWidget extends StatefulWidget {
  final File image;
  final Function deleteFun;

  const UploadedImageListItemWidget({Key key, this.image, this.deleteFun})
      : super(key: key);

  @override
  _UploadedImageListItemWidgetState createState() =>
      _UploadedImageListItemWidgetState();
}

class _UploadedImageListItemWidgetState
    extends State<UploadedImageListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.image == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Image.file(
                      widget.image,
                      fit: BoxFit.cover,
                    );
                  }),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.02),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.8),
                      width: 1,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: widget.image == null
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.4 * 0.2,
                          height: MediaQuery.of(context).size.width * 0.4 * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width *
                                      0.4 *
                                      0.1),
                              color: Colors.white),
                          child: GestureDetector(
                            onTap: widget.deleteFun,
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                              size: MediaQuery.of(context).size.width *
                                  0.4 *
                                  0.15,
                            ),
                          ),
                        ),
                )
              ],
            ),
          );
  }
}
