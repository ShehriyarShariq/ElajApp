import 'package:elaj/core/util/constants.dart';
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  String categoryID, doctorId;
  DateTime date, startTime, createdAt;
  num amount;
  bool isSelf;
  Other other;
  bool isPaid;

  Booking();

  Map<String, dynamic> toJson() {
    return {
      'basic': {
        'start': startTime.millisecondsSinceEpoch,
        'end': startTime.millisecondsSinceEpoch +
            (Constant.SESSION_LENGTH * 60 * 1000),
        'createdAt': createdAt.millisecondsSinceEpoch,
        'status': 'assigning',
        'other': other != null ? other.toJson() : null,
        'isPaid': isPaid,
        'amount': amount
      },
      'sessionInfo': {
        'earlyEndAck': {
          'doctor': false,
          'customer': false,
        }
      }
    };
  }

  @override
  List<Object> get props =>
      [categoryID, doctorId, date, startTime, other, isPaid, amount, isSelf];

  bool isFullyInitialized() {
    if (isSelf != null) {
      return isSelf
          ? true
          : (other != null ? other.isFullyInitialized() : false);
    } else {
      return false;
    }
  }

  void reset() {
    isSelf = null;
    other = null;
  }
}

class Other extends Equatable {
  String name, relationShip, gender;

  Other({this.name, this.relationShip, this.gender});

  factory Other.fromJson(Map<String, String> json) => Other(
      name: json['name'],
      relationShip: json['relationShip'],
      gender: json['gender']);

  Map<String, String> toJson() {
    return {'name': name, 'relationShip': relationShip, 'gender': gender};
  }

  bool isFullyInitialized() {
    return (name != null) && (relationShip != null) && (gender != null);
  }

  @override
  List<Object> get props => [name, relationShip, gender];
}
