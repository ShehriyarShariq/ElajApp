import 'dart:io';

import 'package:elaj/features/customer/home_customer/presentation/pages/home_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../../core/ui/no_glow_scroll_behavior.dart';
import '../../../../../core/util/constants.dart';
import '../../../../../injection_container.dart';
import '../../domain/entities/medical_record.dart';
import '../bloc/bloc/add_medical_records_bloc.dart';
import '../widgets/add_images_widget.dart';
import '../widgets/date_picker_field_widget.dart';
import '../widgets/input_widget.dart';

class AddMedicalRecord extends StatefulWidget {
  final MedicalRecord medicalRecord;
  final File alreadyPickedImage;

  const AddMedicalRecord({Key key, this.medicalRecord, this.alreadyPickedImage})
      : super(key: key);

  @override
  _AddMedicalRecordState createState() => _AddMedicalRecordState();
}

class _AddMedicalRecordState extends State<AddMedicalRecord> {
  AddMedicalRecordsBloc _addMedicalRecordsBloc;

  @override
  void initState() {
    _addMedicalRecordsBloc = sl<AddMedicalRecordsBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              titleSpacing: 0,
              title: Row(
                children: <Widget>[
                  Text("Add Record",
                      style: TextStyle(
                          fontSize: Constant.TITLE_SIZE,
                          fontFamily: Constant.DEFAULT_FONT)),
                ],
              ),
            ),
            body: BlocListener(
              bloc: _addMedicalRecordsBloc,
              listener: (context, state) {
                if (state is Saved) {
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => CustomerHome(
                            startFromTab: 2,
                          )));
                } else if (state is Error) {
                  _addMedicalRecordsBloc.add(ResetEvent());

                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 500),
                    content: Text("Failed to add record.",
                        style: TextStyle(fontFamily: Constant.DEFAULT_FONT)),
                  ));
                }
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                        child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AddImagesWidget(
                              bloc: _addMedicalRecordsBloc,
                              alreadyAddedImages: widget.medicalRecord == null
                                  ? new Map()
                                  : widget.medicalRecord.images,
                              newlyAddedImages:
                                  widget.alreadyPickedImage == null
                                      ? []
                                      : [widget.alreadyPickedImage],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 50),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InputWidget(
                                    addMedicalRecordsBloc:
                                        _addMedicalRecordsBloc,
                                    hintText: "Description",
                                    labelText: "Description",
                                    type: "desc",
                                    prefill: widget.medicalRecord?.desc,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  DatePickerFieldWidget(
                                    addMedicalRecordsBloc:
                                        _addMedicalRecordsBloc,
                                    hintText: "eg: " +
                                        DateFormat("dd / MM / yyyy")
                                            .format(DateTime.now()),
                                    labelText: "Date",
                                    type: "date",
                                    prefill: widget.medicalRecord?.date,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InputWidget(
                                    addMedicalRecordsBloc:
                                        _addMedicalRecordsBloc,
                                    hintText: "Doctor Name",
                                    labelText: "Doctor Name (Optional)",
                                    type: "doctorName",
                                    isOptional: true,
                                    prefill: widget.medicalRecord?.doctorName,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InputWidget(
                                    addMedicalRecordsBloc:
                                        _addMedicalRecordsBloc,
                                    hintText: "Doctor Specialty",
                                    labelText: "Doctor Specialty (Optional)",
                                    type: "doctorSpecialty",
                                    isOptional: true,
                                    prefill:
                                        widget.medicalRecord?.doctorSpecialty,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(15, 8, 15, 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        // borderRadius: BorderRadius.circular(5),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _addMedicalRecordsBloc.add(FetchAllValuesEvent());
                          },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "Save",
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
        BlocBuilder(
          bloc: _addMedicalRecordsBloc,
          builder: (context, state) {
            if (state is Fetching) {
              return OverlayLoader.Overlay();
            }

            return Container();
          },
        )
      ],
    );
  }
}
