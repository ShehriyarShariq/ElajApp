import 'package:equatable/equatable.dart';

class Feedback extends Equatable {
  String user, title, desc;

  Feedback({this.user, this.title, this.desc});

  @override
  List<Object> get props => [user, title, desc];

  Map<String, String> toJson() {
    return {
      'user': user,
      'title': title,
      'desc': desc,
    };
  }
}
