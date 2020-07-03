import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String id, name, iconURL;

  Category.empty();

  Category({this.id, this.name, this.iconURL});

  factory Category.fromJson(Map<String, String> json) =>
      Category(id: json['id'], name: json['name'], iconURL: json['iconURL']);

  @override
  List<Object> get props => [id, name, iconURL];
}
