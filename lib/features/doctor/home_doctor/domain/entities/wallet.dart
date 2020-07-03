class Wallet {
  String wallet;
  Map<String, Map<String, dynamic>> appointment;

  Wallet({this.wallet, this.appointment});

  factory Wallet.fromJson(Map<String, dynamic> json) =>
      Wallet(wallet: json["wallet"], appointment: json["appointment"]);

  Map<String, dynamic> getStats() {
    num totalEarning = 0;
    Map<DateTime, num> monthlyEarning = Map(), dailyEarning = Map();

    appointment.forEach((key, value) {
      totalEarning += double.parse(value['amount'].toString());
      DateTime thisDay = DateTime.fromMillisecondsSinceEpoch(value['date']);
      thisDay = DateTime(thisDay.year, thisDay.month, thisDay.day);
      DateTime thisMonth = DateTime(thisDay.year, thisDay.month, thisDay.day);

      dailyEarning[thisDay] += value['amount'];
      monthlyEarning[thisMonth] += value['amount'];
    });

    return {
      'total': totalEarning.toString(),
      'withdrawn': (totalEarning - num.parse(wallet)).toString(),
      'monthly': monthlyEarning,
      'daily': dailyEarning
    };
  }
}
