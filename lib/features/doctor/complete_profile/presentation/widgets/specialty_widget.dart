import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/presentation/pages/select_specialties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialtyWidget extends StatefulWidget {
  final CompleteProfileBloc bloc;
  final List<Category> allCategories;

  const SpecialtyWidget({Key key, this.bloc, this.allCategories})
      : super(key: key);

  @override
  _SpecialtyWidgetState createState() => _SpecialtyWidgetState();
}

class _SpecialtyWidgetState extends State<SpecialtyWidget> {
  bool _isError = false;
  CompleteDoctorSingleton completeDoctorSingleton = CompleteDoctorSingleton();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is Fetching) {
          if (completeDoctorSingleton.completeDoctor.specialties == null ||
              completeDoctorSingleton.completeDoctor.specialties.length == 0) {
            widget.bloc.add(ResetEvent());
            setState(() {
              _isError = true;
            });
          } else {
            setState(() {
              _isError = false;
            });
          }
        }
      },
      child: Column(
        children: [
          Text(
            "What is your specialty?",
            style: TextStyle(fontFamily: Constant.DEFAULT_FONT, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              List<Category> alreadySelected = List();
              if (completeDoctorSingleton.completeDoctor.specialties != null) {
                Map<String, String> specialties =
                    completeDoctorSingleton.completeDoctor.specialties;
                specialties.forEach((id, name) {
                  alreadySelected.add(Category(id: id, name: name));
                });
              }

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SelectSpecialties(
                        categories: widget.allCategories,
                        alreadySelected: alreadySelected,
                      )));
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                  color: !_isError
                      ? Colors.black.withOpacity(0.3)
                      : Theme.of(context).errorColor.withOpacity(0.2),
                  border: Border.all(
                      color: !_isError
                          ? Colors.black.withOpacity(0.5)
                          : Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "Select From Available Specialties",
                style: TextStyle(
                    fontSize: 19,
                    color: !_isError ? Colors.white : Colors.black,
                    fontFamily: Constant.DEFAULT_FONT),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
