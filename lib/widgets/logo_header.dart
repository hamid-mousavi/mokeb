import 'package:flutter/material.dart';
import 'package:mokeb/models/adhan.dart';
import 'package:mokeb/models/announcement.dart';
import 'package:mokeb/models/noha.dart';
import 'package:mokeb/widgets/noha_card.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // لوگوی دایره‌ای
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white12,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.jpg', // مسیر لوگوی شما
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // عنوان دلخواه (اختیاری)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "موکب صاحب‌الزمان",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "اهلاً و سهلاً",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        )
      ],
    );
  }
}
