import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wildlife_nl_app/models/animal.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/state/questions.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/hex_color.dart';
import 'dart:developer' as developer;

class ReportItemModal extends ConsumerWidget {
  final Interaction interaction;
  final InteractionType type;
  final Animal? animal;

  const ReportItemModal({
    super.key,
    required this.interaction,
    required this.type,
    this.animal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dateFormatter = intl.DateFormat.yMd().add_jm();

    var questions = ref.watch(questionsProvider(type));

    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      decoration: const BoxDecoration(
        color: AppColors.neutral_100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(
                  type.label,
                  style: TextStyle(
                      color: HexColor(type.color),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 75.0,
                  height: 75.0,
                  decoration: BoxDecoration(
                    color: HexColor(type.color),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    switch (type.typeKey) {
                      InteractionTypeKey.sighting => AppIcons.paw,
                      InteractionTypeKey.damage => AppIcons.incident,
                      InteractionTypeKey.inappropriateBehaviour =>
                        AppIcons.cancel,
                      InteractionTypeKey.traffic => AppIcons.traffic,
                      InteractionTypeKey.maintenance => AppIcons.maintenance,
                    },
                    color: AppColors.neutral_50,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (animal != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Diersoort: ",
                    style: TextStyle(
                        color: HexColor(type.color),
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(animal!.name),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  "Datum: ",
                  style: TextStyle(
                      color: HexColor(type.color), fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(dateFormatter.format(interaction.time)),
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
                      color: HexColor(type.color), fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text("[${interaction.lat}, ${interaction.lon}]"),
              ],
            ),
          ),
          if (interaction.animalCountUpper != null &&
              interaction.animalCountUpper != "0" &&
              interaction.animalCountUpper != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Volwassen: ",
                    style: TextStyle(
                        color: HexColor(type.color),
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(interaction.animalCountUpper!),
                ],
              ),
            ),
          if (interaction.juvenileAnimalCountUpper != null &&
              interaction.juvenileAnimalCountUpper != "0" &&
              interaction.juvenileAnimalCountUpper != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    "Jonge: ",
                    style: TextStyle(
                        color: HexColor(type.color),
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(interaction.juvenileAnimalCountUpper!),
                ],
              ),
            ),
          if (interaction.trafficEvent != null &&
              interaction.trafficEvent != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gebeurtenis",
                    style: TextStyle(
                        color: HexColor(type.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(interaction.trafficEvent!)
                ],
              ),
            ),
          if (interaction.description != null && interaction.description != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Omschrijving",
                    style: TextStyle(
                        color: HexColor(type.color),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(interaction.description!)
                ],
              ),
            ),
          if (interaction.image != null && interaction.image != "")
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Afbeelding",
                    style: TextStyle(
                        color: HexColor(type.color),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(interaction.image!)),
                ],
              ),
            ),
          if(!questions.hasError && questions.hasValue)
            for(var item in interaction.questions.where((x) => !questions.value!.any((y) => y.type == "file" && y.id == x.questionId)))
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions.value?.where((element) => element.id == item.questionId).firstOrNull?.question??"",
                      style: TextStyle(
                          color: HexColor(type.color),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(interaction.questions.where((x) => x.id == item.id).firstOrNull?.getAnswers<String>().join(", ")??"Geen antwoord gegeven"),
                  ],
                ),
              ),
        ]),
      ),
    );
  }
}
