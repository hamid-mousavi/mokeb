import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mokeb/bloc/adhan/adhan_cubit.dart';
import 'package:mokeb/core/services/adhan_checker_service.dart';
import 'package:mokeb/core/services/adhan_service.dart';
import 'package:mokeb/core/services/audio_service.dart';
import 'package:mokeb/core/services/location_service.dart';
import 'package:mokeb/models/adhan.dart';
import 'package:mokeb/utils/next_azan_util.dart';

class AdhanBox extends StatelessWidget {
  final Adhan adhan;

  const AdhanBox({super.key, required this.adhan});

  @override
  Widget build(BuildContext context) {
    AdhanCheckerService? checker;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
              child: BlocProvider(
            create: (_) =>
                AdhanCubit(LocationService(), AdhanService())..loadAdhanTimes(),
            child: BlocBuilder<AdhanCubit, AdhanState>(
              builder: (context, state) {
                if (state is AdhanLoading) {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      CircularProgressIndicator(),
                    ],
                  );
                } else if (state is AdhanLoaded) {
                  final nextAzan = getNextAzan(state.times);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${nextAzan.name}: ${DateFormat.Hm().format(nextAzan.time)}",
                        style: const TextStyle(
                             fontSize: 14,fontFamily: 'VazirMatn'),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          AudioService().playAzan();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[400],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("پخش اذان"),
                      )
                    ],
                  );
                } else if (state is AdhanError) {
                  return Text("خطا: ${state.message}");
                }
                return const SizedBox();
              },
            ),
          )),
        ],
      ),
    );
  }
}
