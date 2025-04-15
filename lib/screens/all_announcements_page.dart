// lib/screens/all_announcements_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokeb/bloc/Announcement/Announcement_bloc.dart';
import 'package:mokeb/core/services/announcement_service.dart';

class AllAnnouncementsPage extends StatelessWidget {
  const AllAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("همه اطلاعیه‌ها")),
      body: BlocProvider(
        create: (context) => AnnouncementBloc(AnnouncementService())..add(LoadAnnouncements()),
        child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
          builder: (context, state) {
            if (state is AnnouncementLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnnouncementLoaded) {
              return ListView.builder(
                itemCount: state.announcements.length,
                itemBuilder: (context, index) {
                  final ann = state.announcements[index];
                  return ListTile(
                    leading: const Icon(Icons.campaign),
                    title: Text(ann.title),
                    subtitle: Text(
                      "${ann.date.year}/${ann.date.month}/${ann.date.day} - ${ann.date.hour}:${ann.date.minute.toString().padLeft(2, '0')}",
                    ),
                  );
                },
              );
            } else if (state is AnnouncementError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
