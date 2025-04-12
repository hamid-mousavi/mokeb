import 'package:flutter/material.dart';
import 'package:mokeb/models/noha.dart';
import 'package:mokeb/widgets/noha_card.dart';

class NoheSlider extends StatelessWidget {
  final List<Noha> noheList;

  const NoheSlider({super.key, required this.noheList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "نوحه‌های روز",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: noheList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final nohe = noheList[index];
              return NohaCard(noha: nohe,);
            },
          ),
        ),
      ],
    );
  }
}
