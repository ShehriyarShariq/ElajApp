import 'package:elaj/core/ui/overlay_loader.dart' as OverlayLoader;
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/app_feedback/presentation/pages/app_feedback.dart';
import 'package:elaj/features/common/splash/presentation/pages/splash.dart';
import 'package:elaj/features/doctor/availability/presentation/pages/doctor_availability.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/bloc/bloc/home_doctor_bloc.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/widgets/doctor_appointments.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/widgets/doctor_public_profile.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/widgets/doctor_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorHome extends StatefulWidget {
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  HomeDoctorBloc _homeDoctorBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentTabIndex = 0;
  List<Widget> tabs = [
    DoctorAppointments(),
    DoctorAvailability(),
    DoctorWallet()
  ];

  @override
  void initState() {
    _homeDoctorBloc = sl<HomeDoctorBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: tabs.length,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Scaffold(
                    key: _scaffoldKey,
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      titleSpacing: 0,
                      title: LayoutBuilder(builder: (context, constraint) {
                        return SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: MediaQuery.of(context).size.width * 0.46,
                                child: Text("Elaj",
                                    style: TextStyle(
                                        fontSize: Constant.TITLE_SIZE,
                                        fontFamily: Constant.DEFAULT_FONT)),
                              ),
                            ],
                          ),
                        );
                      }),
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
                          ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "My Profile",
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
                                      builder: (_) => DoctorPublicProfile()));
                            },
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.feedback,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "App Feedback",
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
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(
                                        fontFamily: Constant.DEFAULT_FONT,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              _homeDoctorBloc.add(LogOutEvent());
                            },
                          )
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                    body: BlocListener(
                        bloc: _homeDoctorBloc,
                        listener: (context, state) {
                          if (state is LogOut) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => Splash()));
                          } else if (state is LogOutError) {
                            _scaffoldKey.currentState.openEndDrawer();

                            Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text(
                                "Logout Failed!",
                                style: TextStyle(
                                    fontFamily: Constant.DEFAULT_FONT),
                              ),
                            ));
                          }
                        },
                        child: tabs[currentTabIndex]),
                    bottomNavigationBar: _getNavBar(),
                  ),
                ),
              ),
            ),
          ],
        ),
        BlocBuilder(
          bloc: _homeDoctorBloc,
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

  Widget _getNavBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.3, color: Colors.black)),
          color: Theme.of(context).accentColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem("Appointment", Icons.book, 0),
          _navItem("Availability", Icons.access_time, 1),
          _navItem("Wallet", Icons.monetization_on, 2),
        ],
      ),
    );
  }

  Widget _navItem(String tabName, IconData tabIcon, int tabIndex) {
    return InkWell(
      onTap: () {
        setState(() {
          currentTabIndex = tabIndex;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / tabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tabIcon,
              size: 22,
              color: currentTabIndex == tabIndex
                  ? Theme.of(context).primaryColor
                  : AppColor.DARK_GRAY,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              tabName,
              style: TextStyle(
                  color: currentTabIndex == tabIndex
                      ? Theme.of(context).primaryColor
                      : AppColor.DARK_GRAY,
                  fontFamily: Constant.DEFAULT_FONT),
            )
          ],
        ),
      ),
    );
  }
}
