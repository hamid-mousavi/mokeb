import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokeb/core/services/data_services.dart';
import 'package:mokeb/widgets/adhan_box.dart';
import 'package:mokeb/widgets/announcements_list.dart';
import 'package:mokeb/widgets/logo_header.dart';
import 'package:mokeb/widgets/nohe_slider.dart';
import '../bloc/home/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(DataService())..add(LoadHomeData()), // لود اولیه دیتا
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // Color(0xff06A0B5),
                Color(0xff102B2D),
                Color(0xff0E0E0E),
                Color(0xff0E0E0E),
                Color(0xff0E0E0E),
                Color(0xff000000),
              ],
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(child: Text("خطا: ${state.error}"));
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LogoHeader(),
                      const SizedBox(height: 24),
                      NoheSlider(noheList: state.noheList),
                      const SizedBox(height: 24),
                      AdhanBox(adhan: state.nextAdhan!),
                      const SizedBox(height: 24),
                      AnnouncementsList(announcements: state.announcements),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
