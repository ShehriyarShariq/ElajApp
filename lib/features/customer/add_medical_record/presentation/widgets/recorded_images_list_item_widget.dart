import 'dart:io';

import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecordImagesListItemWidget extends StatefulWidget {
  final MedicalRecordPage recordPage;
  final Function deleteFun, addBtnFun;
  final bool isError;

  const RecordImagesListItemWidget(
      {Key key, this.deleteFun, this.addBtnFun, this.recordPage, this.isError})
      : super(key: key);

  @override
  _RecordImagesListItemWidgetState createState() =>
      _RecordImagesListItemWidgetState();
}

class _RecordImagesListItemWidgetState
    extends State<RecordImagesListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.recordPage.isNull()
        ? _addMoreBtn()
        : Container(
            margin: const EdgeInsets.fromLTRB(7.5, 10, 7.5, 0),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: !widget.recordPage.isPickedImage()
                        ? FadeInImage(
                            image: NetworkImage(widget.recordPage.imageURL),
                            placeholder: AssetImage("imgs/placeholder.png"),
                            fit: BoxFit.cover)
                        : Image.file(
                            widget.recordPage.imageFile,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4 * 0.2,
                    height: MediaQuery.of(context).size.width * 0.4 * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.4 * 0.1),
                        color: Colors.white),
                    child: GestureDetector(
                      onTap: widget.deleteFun,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                        size: MediaQuery.of(context).size.width * 0.4 * 0.15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Widget _addMoreBtn() {
    return Container(
      margin: const EdgeInsets.fromLTRB(7.5, 10, 7.5, 0),
      child: Material(
        color: !widget.isError
            ? Theme.of(context).primaryColor.withOpacity(0.7)
            : Theme.of(context).errorColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          hoverColor: !widget.isError
              ? Theme.of(context).primaryColor.withOpacity(0.85)
              : Theme.of(context).errorColor,
          focusColor: !widget.isError
              ? Theme.of(context).primaryColor.withOpacity(0.85)
              : Theme.of(context).errorColor,
          splashColor: !widget.isError
              ? Theme.of(context).primaryColor.withOpacity(0.85)
              : Theme.of(context).errorColor,
          highlightColor: !widget.isError
              ? Theme.of(context).primaryColor.withOpacity(0.85)
              : Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            widget.addBtnFun();
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Add more\npages",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.5,
                    color: Colors.white,
                    fontFamily: Constant.DEFAULT_FONT),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
