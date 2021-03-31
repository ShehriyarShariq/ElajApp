class Constant {
  static final int CATEGORICAL_DOCTOR_LOAD_LIMIT = 10;
  static final int DOCTOR_REVIEWS_LOAD_LIMIT = 5;
  static final int MAX_ALLOWED_PAY_TIME_IN_HOURS = 1;
  static final int APPOINTMENT_REMINDER_PRE_START_MINS = 15;
  static final int SESSION_LENGTH = 20;
  static final int MAX_CURRENT_APPOINTMENTS_LIMIT = 5;

  static final Map<String, int> RATING_MAP = {
    "five": 5,
    "four": 4,
    "three": 3,
    "two": 2,
    "one": 1
  };

  static const String DEFAULT_FONT = 'Roboto';
  static const double DEFAULT_INPUT_FONT_SIZE = 20;
  static const double INPUT_ICON_SIZE = 22;
  static const double TITLE_SIZE = 20;
}
