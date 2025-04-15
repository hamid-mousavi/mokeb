import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mokeb/models/announcement.dart';

class AnnouncementService {
  Future<List<Announcement>> fetchAnnouncements() async {
    final response = await rootBundle.loadString('assets/data/announcements.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Announcement.fromJson(json)).toList();
  }
}