import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../injection_container.dart';

class SelectSpecialties extends StatefulWidget {
  final List<Category> categories;
  final List<Category> alreadySelected;

  const SelectSpecialties({Key key, this.categories, this.alreadySelected})
      : super(key: key);

  @override
  _SelectSpecialtiesState createState() => _SelectSpecialtiesState();
}

class _SelectSpecialtiesState extends State<SelectSpecialties> {
  CompleteProfileBloc _completeProfileBloc;
  TextEditingController _searchController = TextEditingController();
  CompleteDoctor completeDoctor = CompleteDoctorSingleton().completeDoctor;
  List<Category> currentCategoies = List(),
      selectedCategories = List(),
      dummyCategories =
          List<Category>.filled(10, Category.empty(), growable: false);
  bool isLoaded = true;

  @override
  void initState() {
    _completeProfileBloc = sl<CompleteProfileBloc>();

    _searchController.addListener(() {
      _completeProfileBloc.add(SearchFromCategoriesEvent(
          _searchController.text.trim(), widget.categories));
    });

    if (widget.alreadySelected != null && widget.alreadySelected.length > 0) {
      selectedCategories = widget.alreadySelected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 32,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text("Select Specialties",
                  style: TextStyle(
                      fontSize: Constant.TITLE_SIZE,
                      fontFamily: Constant.DEFAULT_FONT)),
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColor.GRAY,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
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
                              hintText: "Search for Specialty",
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
            SizedBox(
              height: 10,
            ),
            BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
              bloc: _completeProfileBloc,
              builder: (context, state) {
                if (state is LoadingCategories) {
                  isLoaded = false;
                } else if (state is SearchedCategories) {
                  currentCategoies = state.queriedCategories;
                  isLoaded = true;

                  if (currentCategoies.length == 0) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "0 Results Found",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  currentCategoies = widget.categories;
                  isLoaded = true;

                  if (currentCategoies.length == 0) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "0 Results Found",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: Constant.DEFAULT_FONT,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    );
                  }
                }

                return _buildBody();
              },
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
              color: Theme.of(context).primaryColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (selectedCategories.length == 0) {
                      Fluttertoast.showToast(
                          msg: "Select atleast 1 specialty",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.black.withOpacity(0.6),
                          textColor: Colors.white,
                          fontSize: 17);
                    } else {
                      Map<String, String> specialties = Map();
                      selectedCategories.forEach((category) {
                        specialties[category.id] = category.name;
                      });

                      _completeProfileBloc.add(SaveFetchedDataEvent(
                          pageNum: 1,
                          type: "specialty",
                          property: specialties));

                      Navigator.of(context).pop();
                    }
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
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(7.5),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: ((constraints.maxWidth / 2) /
                        (constraints.maxWidth * 0.33 / 2)),
                    physics: NeverScrollableScrollPhysics(),
                    children: isLoaded
                        ? currentCategoies
                            .map((category) =>
                                _getCategoryItem(category, shimmer: false))
                            .toList()
                        : dummyCategories
                            .map((category) =>
                                _getCategoryItem(category, shimmer: true))
                            .toList(),
                  );
                },
              )),
        ),
      ),
    );
  }

  Widget _getCategoryItem(Category category, {bool shimmer}) {
    return category?.name == null
        ? Shimmer.fromColors(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.all(7.5),
              child: Container(),
            ),
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.grey.withOpacity(0.2))
        : GestureDetector(
            onTap: () {
              setState(() {
                selectedCategories.contains(category)
                    ? selectedCategories.remove(category)
                    : selectedCategories.add(category);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedCategories.contains(category)
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: selectedCategories.contains(category)
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
              ),
              margin: const EdgeInsets.all(7.5),
              child: LayoutBuilder(builder: (context, constraint) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    )
                  ],
                );
              }),
            ),
          );
  }
}
