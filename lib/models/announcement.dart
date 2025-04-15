class Announcement {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime date;

  Announcement(
      {required this.date,
      required this.title,
      required this.description,
      required this.id,
      this.imageUrl});

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      id: 'id',
      imageUrl: 'imageUrl');
}
