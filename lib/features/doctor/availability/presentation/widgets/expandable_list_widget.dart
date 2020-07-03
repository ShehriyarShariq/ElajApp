import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/availability/presentation/bloc/bloc/availability_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../injection_container.dart';

class ExpandableListWidget extends StatefulWidget {
  final AvailabilityBloc availabilityBloc;
  final bool isSelected;
  final AvailableDay day;

  const ExpandableListWidget(
      {Key key, this.isSelected = false, this.day, this.availabilityBloc})
      : super(key: key);

  @override
  _ExpandableListWidgetState createState() => _ExpandableListWidgetState();
}

class _ExpandableListWidgetState extends State<ExpandableListWidget> {
  bool _isSelected, _isExpanded, _isError;
  List<DaySlot> _slots;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    _isExpanded = false;
    _isError = false;

    _slots = widget.day.slots;
    if (_slots == null) _slots = List();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: _isSelected
          ? _isError
              ? Theme.of(context).errorColor.withOpacity(0.7)
              : Colors.white
          : Colors.black.withOpacity(0.05),
      child: BlocListener(
          bloc: widget.availabilityBloc,
          listener: (context, state) {
            if (state is Fetching) {
              if (_isSelected) {
                if (_slots.length == 0) {
                  widget.availabilityBloc.add(Reset());
                  setState(() {
                    _isError = true;
                  });
                } else {
                  setState(() {
                    _isError = false;
                  });
                  widget.availabilityBloc.add(SaveFetchedDataEvent(
                      index: widget.day.date.weekday % 7,
                      property:
                          AvailableDay(date: widget.day.date, slots: _slots)));
                }
              } else {
                widget.availabilityBloc.add(SaveFetchedDataEvent(
                    index: widget.day.date.weekday % 7,
                    property: AvailableDay()));
              }
            } else if (state is SlotError) {
              if (state.invalidDays.contains(widget.day.date.weekday % 7)) {
                _isError = true;
              }
            }
          },
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE').format(widget.day.date),
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: _isSelected
                                  ? _isError ? Colors.white : Colors.black
                                  : Colors.black.withOpacity(0.4)),
                        ),
                        Switch(
                          value: _isSelected,
                          onChanged: (value) {
                            setState(() {
                              _isSelected = value;
                            });
                          },
                          inactiveTrackColor: Colors.black.withOpacity(0.15),
                          activeTrackColor:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _isExpanded && _isSelected
                  ? Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Column(
                            children: _slots
                                .map((slot) => _slotItemWidget(context,
                                    slot: DaySlot(),
                                    index: _slots.indexOf(slot)))
                                .toList(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isError = false;

                                  widget.day.slots.add(DaySlot());
                                });
                              },
                              child: Text(
                                "Add Another Slot",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: Constant.DEFAULT_FONT,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }

  Widget _slotItemWidget(BuildContext context, {DaySlot slot, int index}) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Start Time",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constant.DEFAULT_FONT,
                            color:
                                _isError ? Colors.white : AppColor.DARK_GRAY),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.DARK_GRAY.withOpacity(0.5)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _showTimePicker(index: index);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                _slots[index].start == null
                                    ? "Select"
                                    : DateFormat.jm()
                                        .format(_slots[index].start),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: Constant.DEFAULT_FONT,
                                    color: Colors.black.withOpacity(0.8)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "End Time",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constant.DEFAULT_FONT,
                            color:
                                _isError ? Colors.white : AppColor.DARK_GRAY),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.DARK_GRAY.withOpacity(0.5)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (_slots[index].start != null) {
                                _showTimePicker(
                                    isStartTime: false, index: index);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                _slots[index].end == null
                                    ? "Select"
                                    : DateFormat.jm().format(_slots[index].end),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: Constant.DEFAULT_FONT,
                                    color: Colors.black.withOpacity(0.8)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Theme.of(context).errorColor,
                borderRadius: BorderRadius.circular(15)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                radius: 30,
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  setState(() {
                    _slots.removeAt(index);

                    if (_slots.length == 0) _isError = true;
                  });
                },
                child: Container(
                  child: Icon(
                    Icons.remove,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showTimePicker({bool isStartTime = true, int index}) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((selectedTime) {
      DateTime slotTime = DateTime(widget.day.date.year, widget.day.date.month,
          widget.day.date.day, selectedTime.hour, selectedTime.minute);

      setState(() {
        if (isStartTime) {
          _slots[index].start = slotTime;
        } else {
          if (slotTime.isAfter(_slots[index].start)) {
            _slots[index].end = slotTime;
            _isError = false;
          } else {
            _isError = true;
          }
        }
      });
    });
  }
}
