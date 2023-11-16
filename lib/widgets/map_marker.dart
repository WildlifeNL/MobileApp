import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

class MapMarker extends StatefulWidget {
  const MapMarker({super.key, required this.markerType});

  final int markerType;

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker>  {

  @override
  Widget build(BuildContext context) {
    return
    GestureDetector(
      onTap: (){
        // set up the button
        Widget okButton = TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("My title"),
          content: Text("This is my message."),
          actions: [
            okButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
      child: Container(
          width: 300.0,
          height: 300.0,
          decoration: new BoxDecoration(
            color: widget.markerType == 1  ? AppColors.primary : widget.markerType == 2  ? AppColors.incident : AppColors.red_600,
            shape: BoxShape.circle,
          ),
          child:
          widget.markerType == 1  ? Icon(AppIcons.deer, color: AppColors.neutral_50) : widget.markerType == 2  ? Icon(AppIcons.incident, color: AppColors.neutral_50) : Icon(AppIcons.cancel, color: AppColors.neutral_50)
      )
    );

  }
}
