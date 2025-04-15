import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/noha.dart';
import '../../models/announcement.dart';
import '../../models/adhan.dart';

class DataService {
  Future<List<Noha>> getNohas() async {
    final data = await _loadJson();
    return (data['nohas'] as List).map((e) => Noha.fromJson(e)).toList();
  }

  Future<Noha> getNohaById(int id) async {
    final nohas = await getNohas();
    try {
      return nohas.firstWhere((noha) => noha.id == id);
    } catch (e) {
      throw Exception('Noha with id $id not found');
    }
  }

  Future<Noha> getRandomNoha() async {
    final nohas = await getNohas();
    nohas.shuffle(); // تصادفی کردن لیست
    return nohas.first;
  }

  Future<List<Noha>> searchNohas(String query) async {
    final nohas = await getNohas();
    return nohas
        .where((noha) =>
            noha.title.toLowerCase().contains(query.toLowerCase()) ||
            noha.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Announcement>> getAnnouncements() async {
    final data = await _loadJson();
    return (data['announcements'] as List)
        .map((e) => Announcement.fromJson(e))
        .toList();
  }

  Future<Adhan> getNextAdhan() async {
    final data = await _loadJson();
    return Adhan.fromJson(data['next_adhan']);
  }

  Future<Map<String, dynamic>> _loadJson() async {
    final String response =
        await rootBundle.loadString('assets/data/mock_data.json');
    return json.decode(response);
  }
}
