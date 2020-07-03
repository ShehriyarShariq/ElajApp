import 'dart:io';

import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/widgets/uploaded_image_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final String fieldName, type, parentType;
  final int pageNum;
  final double fieldTextSize;
  final bool isMultiple;
  final List<File> alreadyUploadedImgs;

  const UploadWidget(
      {Key key,
      this.fieldName,
      this.type,
      this.bloc,
      this.pageNum,
      this.fieldTextSize = 22,
      this.isMultiple = false,
      this.parentType,
      this.alreadyUploadedImgs})
      : super(key: key);

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  List<File> imgs = List();
  bool _isError = false;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    if (widget.alreadyUploadedImgs != null) {
      imgs = widget.alreadyUploadedImgs;
    }

    super.initState();
  }

  void openCamera() async {
    var image = await picker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);
    setState(() {
      if (widget.isMultiple) {
        imgs.add(image != null ? File(image.path) : null);
      } else {
        if (imgs.length == 1)
          imgs[0] = image != null ? File(image.path) : null;
        else
          imgs.add(image != null ? File(image.path) : null);
      }

      _isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      condition: (previousState, state) {
        return true;
      },
      listener: (context, state) {
        if (widget.parentType == null) {
          if (state is Fetching) {
            if (imgs.length > 0) {
              setState(() {
                _isError = false;
              });

              widget.bloc.add(SaveFetchedDataEvent(
                  pageNum: widget.pageNum,
                  type: widget.type,
                  property: widget.isMultiple ? imgs : imgs[0]));
            } else {
              widget.bloc.add(ResetEvent());
              setState(() {
                _isError = true;
              });
            }
          }
        } else if (state is FetchingChildFieldData) {
          if (imgs.length > 0) {
            setState(() {
              _isError = false;
            });

            widget.bloc.add(SaveFetchedDataToParentEvent(
                type: widget.type,
                parentType: widget.parentType,
                property: imgs));
          } else {
            widget.bloc.add(ResetEvent());
            setState(() {
              _isError = true;
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 30) * 0.6,
                  child: Text(
                    widget.fieldName,
                    style: TextStyle(
                        fontFamily: Constant.DEFAULT_FONT,
                        fontSize: widget.fieldTextSize),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: InkWell(
                      onTap: () async {
                        openCamera();
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                            color: !_isError
                                ? Colors.transparent
                                : Theme.of(context).errorColor.withOpacity(0.2),
                            border: Border.all(
                                color: !_isError
                                    ? Colors.black.withOpacity(0.5)
                                    : Theme.of(context).errorColor),
                            borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        child: Text("Upload",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: imgs
                        .asMap()
                        .entries
                        .map((img) => UploadedImageListItemWidget(
                              image: img.value,
                              deleteFun: () {
                                setState(() {
                                  imgs.removeAt(img.key);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
