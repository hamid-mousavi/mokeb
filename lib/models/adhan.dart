class Adhan {
  final String time;
  final String city;

  Adhan({required this.time, required this.city});

  factory Adhan.fromJson(Map<String, dynamic> json) => Adhan(
        time: json['time'],
        city: json['city'],
      );
}
