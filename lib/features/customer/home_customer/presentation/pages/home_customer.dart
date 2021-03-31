import 'package:elaj/core/util/customer_check_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/constants.dart';
import '../../../../../injection_container.dart';
import '../../../../common/all_appointments/presentation/pages/all_appointments.dart';
import '../bloc/bloc/home_customer_bloc.dart';
import '../widgets/book_appointment_tab.dart';
import '../widgets/medical_records_tab.dart';

class CustomerHome extends StatefulWidget {
  final int startFromTab;

  const CustomerHome({Key key, this.startFromTab = 0}) : super(key: key);

  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  HomeCustomerBloc _homeCustomerBloc;
  int currentTabIndex;
  List<Widget> tabs;

  CustomerCheckSingleton customerCheckSingleton = new CustomerCheckSingleton();

  @override
  void initState() {
    _homeCustomerBloc = sl<HomeCustomerBloc>();

    tabs = [
      BookAppointmentTab(
        bloc: _homeCustomerBloc,
        isCustomer: customerCheckSingleton.isCustLoggedIn,
      ),
      AllAppointments(),
      MedicalRecordsTab()
    ];

    currentTabIndex = widget.startFromTab;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: tabs.length,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: tabs[currentTabIndex],
              bottomNavigationBar: _getNavBar(),
            ),
          ),
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

  Widget _getNavBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.3, color: Colors.black)),
          color: Theme.of(context).accentColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem("Book\nAppointment", Icons.home, 0),
          _navItem("My\nAppointments", Icons.date_range, 1),
          _navItem("Medical\nRecords", Icons.description, 2),
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
        width: MediaQuery.of(context).size.width / tabs.length,
        padding: const EdgeInsets.symmetric(vertical: 2),
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
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  tabName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: currentTabIndex == tabIndex
                          ? Theme.of(context).primaryColor
                          : AppColor.DARK_GRAY,
                      fontFamily: Constant.DEFAULT_FONT),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
