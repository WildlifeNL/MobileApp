import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:wildlife_nl_app/models/data/interaction.dart';
import 'package:wildlife_nl_app/pages/activity.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/widgets/base_modal.dart';
import 'package:wildlife_nl_app/widgets/form_field_with_label.dart';

var uuid = Uuid();

var random = Random();

class AddRegistrationModal extends ConsumerStatefulWidget {
  const AddRegistrationModal({super.key});

  @override
  ConsumerState<AddRegistrationModal> createState() =>
      _AddRegistrationModalState();
}

class _AddRegistrationModalState extends ConsumerState<AddRegistrationModal> {
  final _formKey = GlobalKey<FormState>();

  String animal = "";
  int amountAdult = 0;
  int amountJuvenile = 0;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 40, top: 30, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Add new animal",
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Required Information",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              FormFieldWithLabel(
                labelText: "Animal Type",
                child: DropdownButtonFormField(
                  hint: const Text("Select an animal"),
                  items: const [
                    DropdownMenuItem(
                      value: "Deer",
                      child: Text("Deer"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an animal';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      animal = value!;
                    });
                  },
                ),
              ),
              FormFieldWithLabel(
                labelText: "Amount of adult animals",
                child: TextFormField(
                  keyboardType: Platform.isIOS
                      ? const TextInputType.numberWithOptions(signed: true)
                      : TextInputType.number,
                  validator: (value) {
                    if (value == null || (int.tryParse(value) ?? 0) <= 0) {
                      return 'Please enter an amount above 0';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      amountAdult = int.parse(text);
                    });
                  },
                ),
              ),
              FormFieldWithLabel(
                labelText: "Amount of juvenile animals",
                child: TextFormField(
                  keyboardType: Platform.isIOS
                      ? const TextInputType.numberWithOptions(signed: true)
                      : TextInputType.number,
                  validator: (value) {
                    if (value == null || (int.tryParse(value) ?? -1) <= -1) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      amountJuvenile = int.parse(text);
                    });
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    var u = random.nextDouble();
                    var v = random.nextDouble();

                    var lowerLat = 51.246694388292696;
                    var higherLat = 52.167926821188;
                    var differenceLat = higherLat - lowerLat;

                    var lowerLon = 4.959291472267324;
                    var higherLon = 6.294014195306687;
                    var differenceLon = higherLon - lowerLon;

                    // Call API
                    var request = Interaction(
                      id: uuid.v4(),
                      interactionTime: DateTime.now(),
                      interactionLat: lowerLat + differenceLat * u,
                      interactionLon: lowerLon + differenceLon * u,
                      animalId: "a2f08215-7bb4-4ebb-9c6e-7c937cdfb906",
                      interactionDescription: "Description of the interaction",
                      interactionEncounter: "Encounter",
                      interactionDistance: 1,
                      interactionDuration: 1,
                      interactionRating: 10,
                      interactionType: "sighting",
                      animalCount: amountAdult,
                      animalJuvenileCount: amountJuvenile,
                      animalActivity: "None",
                      animalEmotion: "None",
                      humanActivity: "None",
                      humanEmotion: "None",
                    );

                    var response = await http
                        .post(
                      Uri.parse("http://35.178.117.91:81/interactions/submit"),
                      headers: {"Content-Type": "application/json"},
                      body: json.encode(request),
                    )
                        .then((response) {
                      if (response.statusCode < 300 &&
                          response.statusCode >= 200) {
                        ref.invalidate(activitiesProvider);
                        Navigator.pop(context);
                      } else {
                        dev.log(response.body);
                      }
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
