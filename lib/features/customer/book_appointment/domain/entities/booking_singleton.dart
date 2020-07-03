import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';

class BookingSingleton {
  static final BookingSingleton _instance = BookingSingleton._internal();

  factory BookingSingleton() => _instance;

  BookingSingleton._internal() {
    booking = Booking();
  }

  Booking booking;
}
