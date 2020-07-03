import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:flutter/material.dart';

class ExpandableListWidget extends StatefulWidget {
  final String title;
  final List<String> items;

  const ExpandableListWidget({Key key, this.title, this.items})
      : super(key: key);

  @override
  _ExpandableListWidgetState createState() => _ExpandableListWidgetState();
}

class _ExpandableListWidgetState extends State<ExpandableListWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Constant.DEFAULT_FONT,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 44,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  child: Icon(
                    _isExpanded ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          _isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.items.map((item) => _rowItem(item)).toList(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _rowItem(String rowStr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _bullet(),
          Text(
            rowStr,
            style: TextStyle(
                fontFamily: Constant.DEFAULT_FONT,
                fontSize: 16,
                color: AppColor.DARK_GRAY),
          ),
        ],
      ),
    );
  }

  Widget _bullet() {
    return Container(
      height: 5,
      width: 5,
      margin: const EdgeInsets.only(right: 7.5),
      decoration: BoxDecoration(
        color: AppColor.DARK_GRAY,
        shape: BoxShape.circle,
      ),
    );
  }
}
