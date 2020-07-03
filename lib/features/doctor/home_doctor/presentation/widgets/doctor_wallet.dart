import 'package:elaj/core/ui/no_glow_scroll_behavior.dart';
import 'package:elaj/core/util/colors.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/doctor/home_doctor/domain/entities/wallet.dart';
import 'package:elaj/features/doctor/home_doctor/presentation/bloc/bloc/home_doctor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class DoctorWallet extends StatefulWidget {
  @override
  _DoctorWalletState createState() => _DoctorWalletState();
}

class _DoctorWalletState extends State<DoctorWallet> {
  HomeDoctorBloc _homeDoctorBloc;
  Wallet wallet;
  Map<String, dynamic> stats;

  @override
  void initState() {
    _homeDoctorBloc = sl<HomeDoctorBloc>();

    _homeDoctorBloc.add(GetDoctorWalletEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (wallet != null && stats == null) {
      stats = wallet.getStats();
    }

    return BlocListener(
      bloc: _homeDoctorBloc,
      listener: (context, state) {
        if (state is LoadedWallet) {
          setState(() {
            wallet = state.wallet;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          titleSpacing: 20,
          title: Center(
            child: Text("Wallet",
                style: TextStyle(
                    fontSize: Constant.TITLE_SIZE - 2,
                    fontFamily: Constant.DEFAULT_FONT)),
          ),
        ),
        body: BlocBuilder(
            bloc: _homeDoctorBloc,
            builder: (context, state) {
              if (state is Error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Some error occurred! Try again",
                        style: TextStyle(
                            color: AppColor.DARK_GRAY,
                            fontSize: 22,
                            fontFamily: Constant.DEFAULT_FONT),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        onPressed: () {
                          _homeDoctorBloc.add(GetDoctorWalletEvent());
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
                  ),
                );
              } else if (state is LoadedWallet) {
                wallet = state.wallet;
                stats = wallet.getStats();
              }

              return Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: _getCircle("Wallet", wallet?.wallet),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.07),
                            child: Container(
                              alignment: Alignment.center,
                              child: _getCircle(
                                "Total",
                                stats != null ? stats['total'] : null,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.07),
                            child: Container(
                              alignment: Alignment.center,
                              child: _getCircle("Withdrawn",
                                  stats != null ? stats["withdrawn"] : null),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  Widget _getCircle(String title, amount) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontFamily: Constant.DEFAULT_FONT,
                color: AppColor.DARK_GRAY),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraint) {
            return CircleAvatar(
              radius: constraint.maxHeight * 0.45,
              backgroundColor: AppColor.DARK_GRAY,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: constraint.maxHeight * 0.45 - 3,
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  CircleAvatar(
                    radius: constraint.maxHeight * 0.45 - 3,
                    backgroundColor: Theme.of(context).accentColor,
                    child: wallet == null
                        ? SizedBox(
                            height: constraint.maxHeight * 0.2,
                            width: constraint.maxHeight * 0.2,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                              strokeWidth: 3,
                            ),
                          )
                        : SizedBox(
                            width: constraint.maxHeight * 0.5,
                            height: constraint.maxHeight * 0.5,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "Rs.\n" + amount,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Constant.DEFAULT_FONT,
                                      color: Colors.black.withOpacity(0.7)),
                                )),
                          ),
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
