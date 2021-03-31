import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/app_feedback/presentation/pages/app_feedback.dart';
import 'package:elaj/features/common/credentials/presentation/pages/credentials.dart';
import 'package:elaj/features/common/splash/presentation/pages/splash.dart';
import 'package:elaj/features/customer/categorial_doctors/presentation/pages/categorical_doctors.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart'
    as CategoryEntity;
import 'package:elaj/features/customer/home_customer/presentation/bloc/bloc/home_customer_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:elaj/core/ui/overlay_loader.dart' as OverlayLoader;

import '../../../../../injection_container.dart';
import 'medical_records_tab.dart';

class BookAppointmentTab extends StatefulWidget {
  final HomeCustomerBloc bloc;
  final bool isCustomer;

  const BookAppointmentTab({Key key, this.isCustomer = false, this.bloc})
      : super(key: key);

  @override
  _BookAppointmentTabState createState() => _BookAppointmentTabState();
}

class _BookAppointmentTabState extends State<BookAppointmentTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeCustomerBloc _homeCustomerBloc;
  bool isLoaded = false;
  List<CategoryEntity.Category> allCategories = List(),
      currentCategoies = List(),
      dummyCategories = List<CategoryEntity.Category>.filled(
          10, CategoryEntity.Category.empty(),
          growable: false);
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _homeCustomerBloc = sl<HomeCustomerBloc>();

    _searchController.addListener(() {
      _homeCustomerBloc.add(SearchFromCategoriesEvent(
          _searchController.text.trim(), allCategories));
    });

    _homeCustomerBloc.add(GetAllCategoriesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  titleSpacing: 0,
                  centerTitle: true,
                  title: Text(
                    "Elaj",
                    style: TextStyle(
                        fontSize: Constant.TITLE_SIZE,
                        fontFamily: Constant.DEFAULT_FONT),
                  ),
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        child: Container(),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                      ),
                      !widget.isCustomer
                          ? ListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                          fontFamily: Constant.DEFAULT_FONT),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Credentials(
                                              isFromCustHome: true,
                                            )));
                              },
                            )
                          : Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.feedback,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "App Feedback",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constant.DEFAULT_FONT),
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AppFeedback()));
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColor.DARK_GRAY,
                                ),
                                ListTile(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.exit_to_app,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Log Out",
                                          style: TextStyle(
                                              fontFamily: Constant.DEFAULT_FONT,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    _homeCustomerBloc.add(LogOutEvent());
                                  },
                                )
                              ],
                            )
                    ],
                  ),
                ),
                body: BlocListener(
                  bloc: _homeCustomerBloc,
                  listener: (context, state) {
                    print(state);
                    if (state is LogOut) {
                      Navigator.of(context).pop();

                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => Splash()));
                    } else if (state is LogOutError) {
                      Navigator.of(context).pop();

                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text(
                          "Logout Failed!",
                          style: TextStyle(fontFamily: Constant.DEFAULT_FONT),
                        ),
                      ));
                    }
                  },
                  child: Container(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.072,
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
                                          hintText: "Search for 'Category'",
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)),
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
                        BlocBuilder<HomeCustomerBloc, HomeCustomerState>(
                          bloc: _homeCustomerBloc,
                          builder: (context, state) {
                            if (state is LoadingCategories) {
                              isLoaded = false;
                            } else if (state is ErrorCategories) {
                              return Expanded(
                                child: Column(
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
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8),
                                      onPressed: () {
                                        _homeCustomerBloc
                                            .add(GetAllCategoriesEvent());
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          "Try Again",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily:
                                                  Constant.DEFAULT_FONT),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else if (state is LoadedCategories) {
                              allCategories = state.categories;
                              currentCategoies = state.categories;
                              isLoaded = true;

                              if (currentCategoies.length == 0) {
                                return Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "0 Categories Found",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: Constant.DEFAULT_FONT,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                );
                              }
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
                                        "0 Categories Found",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: Constant.DEFAULT_FONT,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }

                            return _buildBody();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        BlocBuilder(
          bloc: _homeCustomerBloc,
          builder: (context, state) {
            if (state is LoggingOut) {
              return OverlayLoader.Overlay();
            }

            return Container();
          },
        )
      ],
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
                        (constraints.maxWidth * 0.4 / 2)),
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

  Widget _getCategoryItem(CategoryEntity.Category category, {bool shimmer}) {
    return category?.name == null
        ? Shimmer.fromColors(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.all(7.5),
              child: Container(),
            ),
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.grey.withOpacity(0.2))
        : Container(
            margin: const EdgeInsets.all(7.5),
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CategoricalDoctors(
                                category: category,
                              )));
                },
                child: LayoutBuilder(builder: (context, constraint) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: constraint.maxHeight * 0.125,
                            right: constraint.maxHeight * 0.25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: shimmer
                              ? Shimmer.fromColors(
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                  baseColor: Colors.grey.withOpacity(0.1),
                                  highlightColor: Colors.grey.withOpacity(0.2))
                              : SizedBox(
                                  width: constraint.maxHeight * 0.75,
                                  height: constraint.maxHeight * 0.75,
                                  child: FadeInImage(
                                      image: NetworkImage(category.iconURL),
                                      placeholder:
                                          AssetImage("imgs/placeholder.png"),
                                      fit: BoxFit.scaleDown),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: Constant.DEFAULT_FONT,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          );
  }
}
