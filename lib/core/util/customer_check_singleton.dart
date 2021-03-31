class CustomerCheckSingleton {
  static final CustomerCheckSingleton _instance =
      CustomerCheckSingleton._internal();

  factory CustomerCheckSingleton() => _instance;

  CustomerCheckSingleton._internal() {
    isCustLoggedIn = false;
  }

  bool isCustLoggedIn;
}
