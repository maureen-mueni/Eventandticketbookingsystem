class EventModel {
  final String id;
  final String name;
  final String img;
  final String price;
  final String location;
  final String date;

  EventModel({
    required this.id,
    required this.name,
    required this.img,
    required this.price,
    required this.location,
    required this.date,
  });

  // Factory constructor converts internet data into real English events
  factory EventModel.fromJson(Map<String, dynamic> json) {
    int itemId = json['id'] ?? 1;

    // Lists of English names and realistic image placeholders to replace the boring text
    List<String> eventNames = [
      "Tech Expo 2026", "Afro Beats Concert", "Reggae Fest", "Food & Wine Festival",
      "Startup Pitch Night", "Gaming Tournament", "Jazz Under the Stars", "Art Exhibition"
    ];

    List<String> eventImages = [
      "https://images.unsplash.com/photo-1540575467063-178a50c2df87", // Tech
      "https://images.unsplash.com/photo-1514525253161-7a46d19cd819", // Concert
      "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3", // Party
      "https://images.unsplash.com/photo-1555939594-58d7cb561ad1", // Food
      "https://images.unsplash.com/photo-1475721027785-f74eccf877e2", // Tech 2
      "https://images.unsplash.com/photo-1511512578047-dfb367046420", // Gaming
      "https://images.unsplash.com/photo-1486591978090-58e619d37fe7", // Jazz
      "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b"  // Art
    ];

    // Pick an item from the list based on the ID safely
    String cleanName = eventNames[itemId % eventNames.length];
    String cleanImage = eventImages[itemId % eventImages.length];

    return EventModel(
      id: itemId.toString(),
      name: cleanName,
      img: cleanImage,
      price: '50',
      location: 'Main Arena',
      date: 'Next Saturday',
    );
  }
}