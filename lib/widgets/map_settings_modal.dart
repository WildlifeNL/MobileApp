import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/pages/map.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

import '../models/example_by_id.dart';

class MapSettingModal extends ConsumerStatefulWidget {
  const MapSettingModal({super.key});

  @override
  ConsumerState<MapSettingModal> createState() => _MapSettingState();
}



class _MapSettingState extends ConsumerState<MapSettingModal> {
  @override
  Widget build(BuildContext context) {

    final markers = ref.watch(markersProvider);
    final markerProvider = ref.read(markersProvider.notifier);




    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
          color: AppColors.neutral_100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Center(child:Text("Kaart instellingen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primary)),),
              SizedBox(height: 8),
              Text("Filter", style: TextStyle(color: AppColors.primary)),
              SizedBox(height: 8),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.neutral_50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(AppIcons.paw),
                            SizedBox(width: 8),
                            Text("Waarnemingen"),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: markers.value!.toggle1,
                                onChanged: (value) {
                                  setState(() {
                                    markerProvider.toggle1();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.neutral_50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(AppIcons.traffic),
                            SizedBox(width: 8),
                            Text("Verkeer"),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: markers.value!.toggle2,
                                onChanged: (value) {
                                  setState(() {
                                    markerProvider.toggle2();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.neutral_50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(AppIcons.incident),
                            SizedBox(width: 8),
                            Text("Incidenten"),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: markers.value!.toggle3,
                                onChanged: (value) {
                                  setState(() {
                                    markerProvider.toggle3();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.neutral_50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(AppIcons.cancel),
                            SizedBox(width: 8),
                            Text("Ongepast gedrag"),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: markers.value!.toggle4,
                                onChanged: (value) {
                                  setState(() {
                                    markerProvider.toggle4();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.neutral_50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(AppIcons.maintenance),
                            SizedBox(width: 8),
                            Text("Onderhoud"),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: markers.value!.toggle5,
                                onChanged: (value) {
                                  setState(() {
                                    markerProvider.toggle5();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Text("Mode", style: TextStyle(color: AppColors.primary),),
              // SizedBox(height: 8),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     GestureDetector(
              //       onTap: () => {markerProvider.mapToggle1()},
              //       child: Container(
              //           width: 100,
              //           height: 100,
              //           decoration: ShapeDecoration(
              //             color: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(16),
              //               side: BorderSide(
              //                 color: markers.value!.mapTypeToggle1
              //                     ? AppColors.primary
              //                     : Colors.white,
              //                 width: 2,
              //               ),
              //             ),
              //               image: DecorationImage(
              //                 fit: BoxFit.fill,
              //                 image: AssetImage('assets/symbols/standard.png'),
              //               )
              //
              //       )),
              //     ),
              //     GestureDetector(
              //       onTap: () => {markerProvider.mapToggle2()},
              //       child: Container(
              //           width: 100,
              //           height: 100,
              //           decoration: ShapeDecoration(
              //             color: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(16),
              //               side: BorderSide(
              //                 color: markers.value!.mapTypeToggle2
              //                     ? AppColors.primary
              //                     : Colors.white,
              //                 width: 2,
              //               ),
              //             ),
              //
              //               image: DecorationImage(
              //                 fit: BoxFit.fill,
              //                 image: AssetImage('assets/symbols/satellite.png'),
              //               )
              //           )),
              //     ),
              //     GestureDetector(
              //       onTap: () => {markerProvider.mapToggle3()},
              //       child: Container(
              //           width: 100,
              //           height: 100,
              //           decoration: ShapeDecoration(
              //             color: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(16),
              //               side: BorderSide(
              //                 color: markers.value!.mapTypeToggle3
              //                     ? AppColors.primary
              //                     : Colors.white,
              //                 width: 2,
              //               ),
              //             ),
              //
              //             image: DecorationImage(
              //               fit: BoxFit.fill,
              //               image: AssetImage('assets/symbols/terrain.png'),
              //             )
              //
              //           )),
              //     )
              //   ],
              // ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Toepassen"), style: TextButton.styleFrom(foregroundColor: AppColors.neutral_50),),
              ),
            ]),
      ),
    );
  }
}

