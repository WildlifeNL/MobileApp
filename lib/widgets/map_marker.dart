import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

class MapMarker extends StatefulWidget {
  const MapMarker({super.key, required this.markerType});

  final String markerType;

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
            color: widget.markerType == "86a6b56a-89f0-11ee-919a-1e0034001676"  ? AppColors.primary : widget.markerType == "689a5571-8eb5-11ee-919a-1e0034001676"  ? AppColors.purple : widget.markerType == "86a838e1-89f0-11ee-919a-1e0034001676"  ? AppColors.incident : widget.markerType == "86a5736f-89f0-11ee-919a-1e0034001676" ? AppColors.red_600 : AppColors.brown,
            shape: BoxShape.circle,
          ),
          child:
          widget.markerType == "86a6b56a-89f0-11ee-919a-1e0034001676" ? Icon(AppIcons.paw, color: AppColors.neutral_50) : widget.markerType == "689a5571-8eb5-11ee-919a-1e0034001676"  ? Icon(AppIcons.traffic, color: AppColors.neutral_50) :  widget.markerType == "86a838e1-89f0-11ee-919a-1e0034001676"  ? Icon(AppIcons.incident, color: AppColors.neutral_50) : widget.markerType == "86a5736f-89f0-11ee-919a-1e0034001676" ? Icon(AppIcons.cancel, color: AppColors.neutral_50): Icon(AppIcons.maintenance, color: AppColors.neutral_50)
      )
    );

  }
}
