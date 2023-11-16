import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

class MapSettingModal extends StatefulWidget {
  const MapSettingModal({super.key});

  @override
  State<MapSettingModal> createState() => _MapSettingState();
}

bool _switchValue1 = true;
bool _switchValue2 = true;
bool _switchValue3 = true;
bool _switchValue4 = true;

class _MapSettingState extends State<MapSettingModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.625,
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
                              Text("Wilde dieren"),
                            ],
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: _switchValue1,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValue1 = value;
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
                              Icon(AppIcons.paw),
                              SizedBox(width: 8),
                              Text("Wilde dieren"),
                            ],
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: _switchValue2,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValue2 = value;
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
                              Icon(AppIcons.paw),
                              SizedBox(width: 8),
                              Text("Wilde dieren"),
                            ],
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: _switchValue3,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValue3 = value;
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
                              Icon(AppIcons.paw),
                              SizedBox(width: 8),
                              Text("Wilde dieren"),
                            ],
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: _switchValue4,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValue4 = value;
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
          Text("Mode", style: TextStyle(color: AppColors.primary),),
              SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => {},
                child: Image.asset('assets/symbols/standard.png'),
              ),
              GestureDetector(
                onTap: () => {},
                child: Image.asset('assets/symbols/satellite.png'),
              ),
              GestureDetector(
                onTap: () => {},
                child: Image.asset('assets/symbols/terrain.png'),
              )
            ],
          ),
              SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8)),
            width: double.infinity,
            child: TextButton(onPressed: (){}, child: Text("Toepassen"), style: TextButton.styleFrom(foregroundColor: AppColors.neutral_50),),
          ),
          Center(
            child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Annuleren")),
          )

        ]),
      ),
    );
  }
}
