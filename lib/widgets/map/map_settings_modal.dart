import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/pages/map.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/widgets/map/map_settings_toggle.dart';

class MapSettingModal extends ConsumerWidget {
  const MapSettingModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markers = ref.watch(settingsProvider);
    final markerProvider = ref.read(settingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24).copyWith(bottom: 64),
      decoration: const BoxDecoration(
        color: AppColors.neutral_100,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(
          child: Text("Kaart instellingen",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.primary)),
        ),
        const SizedBox(height: 8),
        const Text("Filter", style: TextStyle(color: AppColors.primary)),
        const SizedBox(height: 8),
        Column(
          children: [
            MapSettingsToggle(
              onChanged: markerProvider.setSightings,
              value: markers.toggleSightings,
              label: "Waarnemingen",
              icon: AppIcons.paw,
            ),
            const SizedBox(height: 8),
            MapSettingsToggle(
              onChanged: markerProvider.setTraffic,
              value: markers.toggleTraffic,
              label: "Verkeer",
              icon: AppIcons.traffic,
            ),
            const SizedBox(height: 8),
            MapSettingsToggle(
              onChanged: markerProvider.setIncidents,
              value: markers.toggleIncidents,
              label: "Incidenten",
              icon: AppIcons.incident,
            ),
            const SizedBox(height: 8),
            MapSettingsToggle(
              onChanged: markerProvider.setInappropriateBehaviour,
              value: markers.toggleInappropriateBehaviour,
              label: "Ongepast gedrag",
              icon: AppIcons.cancel,
            ),
            const SizedBox(height: 8),
            MapSettingsToggle(
              onChanged: markerProvider.setMaintenance,
              value: markers.toggleMaintenance,
              label: "Onderhoud",
              icon: AppIcons.maintenance,
            ),
          ],
        ),
        //   Text("Mode", style: TextStyle(color: AppColors.primary),),
        //   SizedBox(height: 8),
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       GestureDetector(
        //         onTap: () => {markerProvider.mapToggle1()},
        //         child: Container(
        //             width: 100,
        //             height: 100,
        //             decoration: ShapeDecoration(
        //               color: Colors.white,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(16),
        //                 side: BorderSide(
        //                   color: markers.value!.mapTypeToggle1
        //                       ? AppColors.primary
        //                       : Colors.white,
        //                   width: 2,
        //                 ),
        //               ),
        //                 image: DecorationImage(
        //                   fit: BoxFit.fill,
        //                   image: AssetImage('assets/symbols/standard.png'),
        //                 )
        //
        //         )),
        //       ),
        //       GestureDetector(
        //         onTap: () => {markerProvider.mapToggle2()},
        //         child: Container(
        //             width: 100,
        //             height: 100,
        //             decoration: ShapeDecoration(
        //               color: Colors.white,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(16),
        //                 side: BorderSide(
        //                   color: markers.value!.mapTypeToggle2
        //                       ? AppColors.primary
        //                       : Colors.white,
        //                   width: 2,
        //                 ),
        //               ),
        //
        //                 image: DecorationImage(
        //                   fit: BoxFit.fill,
        //                   image: AssetImage('assets/symbols/satellite.png'),
        //                 )
        //             )),
        //       ),
        //       GestureDetector(
        //         onTap: () => {markerProvider.mapToggle3()},
        //         child: Container(
        //             width: 100,
        //             height: 100,
        //             decoration: ShapeDecoration(
        //               color: Colors.white,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(16),
        //                 side: BorderSide(
        //                   color: markers.value!.mapTypeToggle3
        //                       ? AppColors.primary
        //                       : Colors.white,
        //                   width: 2,
        //                 ),
        //               ),
        //
        //               image: DecorationImage(
        //                 fit: BoxFit.fill,
        //                 image: AssetImage('assets/symbols/terrain.png'),
        //               )
        //
        //             )),
        //       )
        //     ],
        //   ),
        //   SizedBox(height: 24),
        //   Container(
        //     decoration: BoxDecoration(
        //         color: AppColors.primary,
        //         borderRadius: BorderRadius.circular(8)),
        //     width: double.infinity,
        //     child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Toepassen"), style: TextButton.styleFrom(foregroundColor: AppColors.neutral_50),),
        //   ),
      ]),
    );
  }
}
