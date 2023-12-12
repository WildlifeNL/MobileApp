import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/pages/report.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';

import '../flavors.dart';
import '../utilities/app_icons.dart';
import '../utilities/app_styles.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

final String baseUrl = F.apiUrl;

class InteractionType {
  final String label;
  final String typekey;
  final String color;
  final String id;

  InteractionType(
      {required this.label,
      required this.typekey,
      required this.color,
      required this.id});
}

List<InteractionType> interactionTypesApi = [];

Future<void> fetchData() async {
  final typesResponse = await http
      .get(Uri.parse(baseUrl + 'api/controllers/interactions.php/types'));

  if (typesResponse.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(typesResponse.body);
    // Map the raw JSON data into a list of AnimalType objects
    interactionTypesApi = jsonData.map((json) {
      return InteractionType(
          label: json['label'] ?? '',
          typekey: json['type_key'] ?? '',
          color: json['color'] ?? '',
          id: json['id'] ?? '');
    }).toList();
  } else {
    print('Response failed');
  }
}

class ReportTypeModal extends StatefulWidget {
  const ReportTypeModal({super.key});

  @override
  State<ReportTypeModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportTypeModal> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String _selectedType = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: AppColors.neutral_50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide.none,
        ),
      ),
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _selectedType = '';
                          },
                          icon: Icon(AppIcons.cross)),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Nieuwe melding',
                      textAlign: TextAlign.center,
                      style: AppStyles.of(context)
                          .data
                          .textStyle
                          .headerMedium
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wat wil je melden?',
                      style: AppStyles.of(context)
                          .data
                          .textStyle
                          .cardTitle
                          .copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        return Container(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8,
                            children: interactionTypesApi
                                .map((interactionType) => GestureDetector(
                                      onTap: () {
                                        if (_selectedType !=
                                            interactionType.typekey) {
                                          setState(() {
                                            _selectedType =
                                                interactionType.typekey;
                                          });
                                        } else {
                                          setState(() {
                                            _selectedType = '';
                                          });
                                        }
                                      },
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                    decoration: ShapeDecoration(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(8),
                                                        side: BorderSide(
                                                          color: _selectedType ==
                                                              interactionType.typekey
                                                              ? HexColor(
                                                              interactionType.color)
                                                              : Colors.white,
                                                          width: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Icon(
                                                        (interactionType.typekey ==
                                                                'sighting'
                                                            ? AppIcons.paw
                                                            : (interactionType
                                                                        .typekey ==
                                                                    'damage'
                                                                ? AppIcons.paw
                                                                : (interactionType
                                                                            .typekey ==
                                                                        'inappropriate_behaviour'
                                                                    ? AppIcons.cancel
                                                                    : (interactionType
                                                                                .typekey ==
                                                                            'traffic'
                                                                        ? AppIcons.paw
                                                                        : (interactionType
                                                                                    .typekey ==
                                                                                'maintenance'
                                                                            ? AppIcons
                                                                                .paw
                                                                            : null))))),
                                                        size: 30,
                                                        color: HexColor(
                                                            interactionType.color)),
                                                padding: EdgeInsets.all(16),
                                                  ),
                                              SizedBox(height: 4),
                                              Text(
                                                interactionType.label,
                                                style: AppStyles.of(context)
                                                    .data
                                                    .textStyle
                                                    .paragraph,
                                              )
                                            ],
                                          ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedType != ''
                              ? () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReportPage(),
                                    ),
                                  );
                                }
                              : null,
                          child: Text('Volgende',
                              style: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .buttonText),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
