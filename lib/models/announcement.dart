class Announcement {
  final String title;
  final String description;

  Announcement({required this.title, required this.description});

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        title: json['title'],
        description: json['description'],
      );
}
