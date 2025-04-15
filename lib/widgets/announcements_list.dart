import 'package:flutter/material.dart';
import 'package:mokeb/models/announcement.dart';
import 'package:mokeb/screens/all_announcements_page.dart';

class AnnouncementsList extends StatelessWidget {
  final List<Announcement> announcements;

  const AnnouncementsList({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "اطلاعیه‌ها",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                // TODO: رفتن به صفحه اطلاعیه‌ها
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllAnnouncementsPage(),));
              },
              child: const Text("مشاهده همه", style: TextStyle(color: Colors.white70)),
            )
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: announcements.map((announcement) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                announcement.title,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
