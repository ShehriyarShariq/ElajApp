import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/categorial_doctors/presentation/bloc/bloc/categorical_doctors_bloc.dart';
import 'package:elaj/features/customer/categorial_doctors/presentation/widgets/categorical_doctors_list_item.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class CategoricalDoctors extends StatefulWidget {
  final Category category;

  const CategoricalDoctors({Key key, this.category}) : super(key: key);

  @override
  _CategoricalDoctorsState createState() => _CategoricalDoctorsState();
}

class _CategoricalDoctorsState extends State<CategoricalDoctors> {
  CategoricalDoctorsBloc _categoricalDoctorsBloc;
  TextEditingController _searchController = TextEditingController();

  List<BasicDoctor> allDoctors,
      currentDoctors,
      placeholder = List<BasicDoctor>.filled(5, null, growable: false);

  @override
  void initState() {
    _categoricalDoctorsBloc = sl<CategoricalDoctorsBloc>();

    _categoricalDoctorsBloc
        .add(GetAllCategoricalDoctorsEvent(categoryID: widget.category.id));

    _searchController.addListener(() {
      _categoricalDoctorsBloc.add(SearchFromCategoricalDoctorsEvent(
          _searchController.text.trim(), allDoctors));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 0,
        title: Text(widget.category.name + "s",
            style: TextStyle(
                fontSize: Constant.TITLE_SIZE,
                fontFamily: Constant.DEFAULT_FONT)),
      ),
      body: Container(
        color: AppColor.GRAY,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.072,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.search,
                          color: AppColor.DARK_GRAY,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search for 'Doctor'",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0)),
                            ),
                            style: TextStyle(
                                fontFamily: Constant.DEFAULT_FONT,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder(
                bloc: _categoricalDoctorsBloc,
                builder: (context, state) {
                  if (state is Error) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Some error occurred!",
                          style: TextStyle(
                              color: AppColor.DARK_GRAY,
                              fontSize: 22,
                              fontFamily: Constant.DEFAULT_FONT),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          onPressed: () {
                            _categoricalDoctorsBloc.add(
                                GetAllCategoricalDoctorsEvent(
                                    categoryID: widget.category.id));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Try Again",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: Constant.DEFAULT_FONT),
                            ),
                          ),
                        )
                      ],
                    );
                  } else if (state is Loaded) {
                    allDoctors = state.doctors;
                    currentDoctors = state.doctors;
                  } else if (state is SearchedDoctors) {
                    currentDoctors = state.doctors;
                  }

                  if (state is Loaded || state is SearchedDoctors) {
                    if (currentDoctors.length == 0)
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "No doctors found",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                        ],
                      );
                  }

                  return ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        child: Column(
                            children: currentDoctors != null
                                ? currentDoctors
                                    .map((doctor) =>
                                        CategoricalDoctorListItem(doctor))
                                    .toList()
                                : placeholder
                                    .map((doctor) => CategoricalDoctorListItem(
                                          null,
                                          shimmer: false,
                                        ))
                                    .toList()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
