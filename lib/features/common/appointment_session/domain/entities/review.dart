class Review {
  String id, appointmentID, customerName, message;
  DateTime timeStamp;
  num star;

  Review(
      {this.id,
      this.appointmentID,
      this.customerName,
      this.star,
      this.message,
      this.timeStamp});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
      id: json['id'],
      appointmentID: json['appointmentID'],
      customerName: json['customerName'],
      star: json['star'],
      message: json['message'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(json['timeStamp']));

  Map<String, dynamic> toJson() {
    return {
      'appointmentID': appointmentID,
      'star': star,
      'message': message,
      'timeStamp': timeStamp.millisecondsSinceEpoch
    };
  }
}
