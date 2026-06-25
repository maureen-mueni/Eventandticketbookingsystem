class BookingReportService {
  static List<Map<String, String>> bookedTickets = [];

  // Define 4 arguments here
  static void addBooking(String user, String event, String count, String price) {
    bookedTickets.add({
      'user': user,
      'event': event,
      'count': count,
      'price': price,
    });
  }
}