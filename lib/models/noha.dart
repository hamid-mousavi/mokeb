class Noha {
  final String id;
  final String title;
  final String reciter;
  final String image;
  final String description;
  final String url;
  final double duration;

  Noha(
      {required this.id,
      required this.duration,
      required this.title,
      required this.reciter,
      required this.image,
      required this.description,
      required this.url});

  factory Noha.fromJson(Map<String, dynamic> json) => Noha(
        id: json['id'],
        title: json['title'],
        duration: json['duration'],
        reciter: json['reciter'],
        image: json['image'],
        description: json['description'],
        url: json['url'],
      );
}
