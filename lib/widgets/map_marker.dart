import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

import '../flavors.dart';

class MapMarker extends StatefulWidget {
  const MapMarker(
      {super.key,
      required this.markerType,
      required this.color,
      required this.label,
      required this.time,
      required this.image,
      required this.description,
      required this.animal_count_upper,
      required this.animalName,
      required this.juvenil_animal_count_upper,
      required this.traffic_event,
        required this.lat,
        required this.lon,
      });

  final String markerType;
  final String color;
  final String label;
  final String time;
  final String image;
  final String description;
  final String animal_count_upper;
  final String animalName;
  final String juvenil_animal_count_upper;
  final String traffic_event;
  final String lat;
  final String lon;

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Wrap(children: [MarkerModal()]);
            },
          );
        },
        child: Container(
            width: 300.0,
            height: 300.0,
            decoration: new BoxDecoration(
              color: HexColor(widget.color),
              shape: BoxShape.circle,
            ),
            child: widget.markerType == "86a6b56a-89f0-11ee-919a-1e0034001676"
                ? Icon(AppIcons.paw, color: AppColors.neutral_50)
                : widget.markerType == "689a5571-8eb5-11ee-919a-1e0034001676"
                    ? Icon(AppIcons.traffic, color: AppColors.neutral_50)
                    : widget.markerType ==
                            "86a838e1-89f0-11ee-919a-1e0034001676"
                        ? Icon(AppIcons.incident, color: AppColors.neutral_50)
                        : widget.markerType ==
                                "86a5736f-89f0-11ee-919a-1e0034001676"
                            ? Icon(AppIcons.cancel, color: AppColors.neutral_50)
                            : Icon(AppIcons.maintenance,
                                color: AppColors.neutral_50)));
  }

  @override
  Widget MarkerModal() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      decoration: BoxDecoration(
          color: AppColors.neutral_100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                      color: HexColor(widget.color),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: new BoxDecoration(
                      color: HexColor(widget.color),
                      shape: BoxShape.circle,
                    ),
                    child: widget.markerType ==
                            "86a6b56a-89f0-11ee-919a-1e0034001676"
                        ? Icon(
                            AppIcons.paw,
                            color: AppColors.neutral_50,
                            size: 50,
                          )
                        : widget.markerType ==
                                "689a5571-8eb5-11ee-919a-1e0034001676"
                            ? Icon(
                                AppIcons.traffic,
                                color: AppColors.neutral_50,
                                size: 50,
                              )
                            : widget.markerType ==
                                    "86a838e1-89f0-11ee-919a-1e0034001676"
                                ? Icon(
                                    AppIcons.incident,
                                    color: AppColors.neutral_50,
                                    size: 50,
                                  )
                                : widget.markerType ==
                                        "86a5736f-89f0-11ee-919a-1e0034001676"
                                    ? Icon(
                                        AppIcons.cancel,
                                        color: AppColors.neutral_50,
                                        size: 50,
                                      )
                                    : Icon(
                                        AppIcons.maintenance,
                                        color: AppColors.neutral_50,
                                        size: 50,
                                      )),
              ],
            ),
          ),
          SizedBox(height: 40),
          if (widget.animalName != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Diersoort: ",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(widget.animalName),
                ],
              ),
            ),
          if (widget.time != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Datum: ",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(widget.time),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  "Locatie: ",
                  style: TextStyle(
                      color: HexColor(widget.color), fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text("[" + widget.lat + ", " + widget.lon + "]"),
              ],
            ),
          ),
          if (widget.animal_count_upper != "0" && widget.animal_count_upper != '')
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Volwassen: ",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(widget.animal_count_upper),
                ],
              ),
            ),
          if (widget.juvenil_animal_count_upper != "0" && widget.juvenil_animal_count_upper != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Jonge: ",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(widget.juvenil_animal_count_upper),
                ],
              ),
            ),
          if (widget.traffic_event != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gebeurtenis",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(widget.traffic_event)
                ],
              ),
            ),
          if (widget.description != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Omschrijving",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(widget.description)
                ],
              ),
            ),
          if (widget.image != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Afbeelding",
                    style: TextStyle(
                        color: HexColor(widget.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                      width: 100, height: 100, child: Image.network(widget.image)),
                ],
              ),
            )
        ]),
      ),
    );
  }
}

// widget.markerType == "86a6b56a-89f0-11ee-919a-1e0034001676"
// ? Text("Waarneming")
// : widget.markerType == "689a5571-8eb5-11ee-919a-1e0034001676"
// ? Text("Verkeer")
//     : widget.markerType == "86a838e1-89f0-11ee-919a-1e0034001676"
// ? Text("Incident")
//     : widget.markerType == "86a5736f-89f0-11ee-919a-1e0034001676"
// ? Text("Ongepast gedrag")
//     : Text("Onderhoud"),
