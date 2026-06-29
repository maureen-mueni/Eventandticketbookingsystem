class TicketBooking {
  final int? id; // Primary Key (Auto-incrementing)
  final String attendeeName;
  final int ticketCount;
  final String eventTitle;

  TicketBooking({
    this.id,
    required this.attendeeName,
    required this.ticketCount,
    required this.eventTitle,
  });

  // Convert a TicketBooking object into a Map structure to store in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attendeeName': attendeeName,
      'ticketCount': ticketCount,
      'eventTitle': eventTitle,
    };
  }

  // Convert a Map structure from SQLite back into a readable TicketBooking object
  factory TicketBooking.fromMap(Map<String, dynamic> map) {
    return TicketBooking(
      id: map['id'] as int?,
      attendeeName: map['attendeeName'] as String,
      ticketCount: map['ticketCount'] as int,
      eventTitle: map['eventTitle'] as String,
    );
  }
}