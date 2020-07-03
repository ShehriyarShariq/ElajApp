import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/all_appointments/presentation/bloc/bloc/all_appointments_bloc.dart';
import 'package:elaj/features/common/all_appointments/presentation/widgets/appointments_list_item.dart';
import 'package:elaj/features/common/all_appointments/presentation/widgets/appointments_tab.dart';
import 'package:elaj/features/common/credentials/presentation/pages/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class AllAppointments extends StatefulWidget {
  @override
  _AllAppointmentsState createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments>
    with SingleTickerProviderStateMixin {
  AllAppointmentsBloc _allAppointmentsBloc;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _allAppointmentsBloc = sl<AllAppointmentsBloc>();

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
        title: Text("Appointments",
            style: TextStyle(
                fontSize: Constant.TITLE_SIZE,
                fontFamily: Constant.DEFAULT_FONT)),
        bottom: TabBar(
          unselectedLabelColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          tabs: [
            Tab(
              text: "Current",
            ),
            Tab(
              text: "Past",
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: BlocListener(
        bloc: _allAppointmentsBloc,
        listener: (context, state) {
          if (state is ErrorUserNotLoggedIn) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Credentials(
                          isFromCustHome: true,
                        )));
          }
        },
        child: TabBarView(
          children: [
            AppointmentsTab(
              allAppointmentsBloc: _allAppointmentsBloc,
              isCurrent: true,
            ),
            AppointmentsTab(
              allAppointmentsBloc: _allAppointmentsBloc,
              isCurrent: false,
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
