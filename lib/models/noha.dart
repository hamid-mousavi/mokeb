class Noha {
  final String title;
  final String reciter;
  final String image;

  Noha({required this.title, required this.reciter, required this.image});

  factory Noha.fromJson(Map<String, dynamic> json) => Noha(
        title: json['title'],
        reciter: json['reciter'],
        image: json['image'],
      );
}
