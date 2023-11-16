import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';
import 'package:wildlife_nl_app/utilities/app_text_styles.dart';
import 'package:wildlife_nl_app/widgets/CustomStepper.dart';

class Animals {
  final String name;
  final String img;

  Animals({required this.name, required this.img});
}

class AnimalType {
  final String name;
  final String img;
  final List<Animals> animals;

  AnimalType({required this.name, required this.img, required this.animals});
}

class ReportPage extends StatefulWidget {
  ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _currentStep = 0;
  String _chosenType = '';
  String _chosenName = '';

  final List<AnimalType> diersoorten = [
    AnimalType(
      name: "Evenhoevigen",
      img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      animals: [
        Animals(name: "Damhert", img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png"),
      ],
    ),
    AnimalType(
      name: "Roofdieren",
      img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      animals: [
        Animals(name: "Wild zwijn", img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png"),
      ],
    ),
    AnimalType(
      name: "Exoten",
      img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      animals: [
        Animals(name: "Ree", img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png"),
      ],
    ),
    AnimalType(
      name: "Insecteneters",
      img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      animals: [
        Animals(name: "Edelhert", img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png"),
      ],
    ),
    AnimalType(
      name: "Knaag- & haasachtigen",
      img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      animals: [
        Animals(name: "Wisent", img: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png"),
      ],
    ),
  ];

  List<Widget> getFilteredAnimals() {
    // Filter animals based on the selected type (_chosenType)
    AnimalType selectedType = diersoorten.firstWhere((type) => type.name == _chosenType,
      orElse: () => AnimalType(name: '', img: '', animals: []),);
    List<Animals> filteredAnimals = selectedType.animals;

    // Create widgets for filtered animals
    return filteredAnimals.map((dier) => GestureDetector(
      onTap: (){
        setState(() {
          if(_chosenName != dier.name) {
            setState(() {
              _chosenName = dier.name;
            });
          } else {
            setState(() {
              _chosenName = '';
            });
          }
        });
      },
      child: FractionallySizedBox(
        widthFactor: 1/3.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: _chosenName == dier.name ? AppColors.primary : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image(
                          image: NetworkImage(dier.img)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dier.name,
              textAlign: TextAlign.center,
              style: AppStyles.of(context).data.textStyle.paragraph,
            ),
          ],
        ),
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, excludeHeaderSemantics: true,),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 4,
            ),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(AppIcons.cross)),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Nieuwe melding',
                    textAlign: TextAlign.center,
                    style: AppStyles.of(context).data.textStyle.headerMedium.copyWith(
                      color: AppColors.primary
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: CustomStepper(
                elevation: 0,
                currentStep: _currentStep,
                controlsBuilder: (context, details) => Text(""),
                steps: [
                  CustomStep(
                      state: _currentStep == 0 ? CustomStepState.editing : CustomStepState.complete,
                      content: Container(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wat is de diersoort?',
                              style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 4),
                                width: double.maxFinite,
                                child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: diersoorten.map((diersoort) => GestureDetector(
                                      onTap: (){
                                        if(_chosenType != diersoort.name) {
                                          setState(() {
                                            _chosenType = diersoort.name;
                                          });
                                        } else {
                                          setState(() {
                                            _chosenType = '';
                                          });
                                        }
                                      },
                                      child: FractionallySizedBox(
                                        widthFactor: 1/3.3,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            AspectRatio(
                                                  aspectRatio: 1.0,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: ShapeDecoration(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        side: BorderSide(
                                                          color: _chosenType == diersoort.name ? AppColors.primary : Colors.white,
                                                          width: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Image(
                                                            image: NetworkImage(diersoort.img)
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            const SizedBox(height: 4),
                                            Text(
                                                diersoort.name,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.of(context).data.textStyle.paragraph,
                                              ),
                                          ],
                                        ),
                                      ),
                                    )).toList())
                            ),
                          ],
                        ),
                      )
                  ),
                  CustomStep(
                    state: _currentStep < 1 ? CustomStepState.indexed : (_currentStep > 1 ? CustomStepState.complete : CustomStepState.editing),
                      content: Container(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wat is het dier?',
                              style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 4),
                                width: double.maxFinite,
                                child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children:  getFilteredAnimals(),
                                ),
                            ),
                          ],
                        ),
                      )
                  ),
                  CustomStep(
                      state: _currentStep >= 2 ? CustomStepState.editing : CustomStepState.indexed,
                      content: Container(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hier komen evalutie vragen',
                              style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: _currentStep > 0,
                      child: Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                              setState(() {
                                _currentStep--; // Verhoog de huidige stap
                              });
                          },
                          child: Text(
                              'Vorige',
                              style: AppStyles.of(context).data.textStyle.buttonText
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Achtergrondkleur van de knop
                            onPrimary: AppColors.primary, // Tekstkleur van de knop
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding van de knop
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Afgeronde hoeken
                              side: BorderSide(color: AppColors.primary, width: 2)
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _currentStep > 0,
                      child: SizedBox(width: 16.0), // Ruimte toevoegen tussen de knoppen als de eerste knop zichtbaar is
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (_chosenType.isNotEmpty && _currentStep == 0) ? () {
                          setState(() {
                            _currentStep++;
                          });
                        } : ((_chosenName.isNotEmpty && _currentStep == 1) ? () {
                          setState(() {
                            _currentStep++;
                          });
                        } : null),
                        child: Text(
                          _currentStep < 2 ? 'Volgende' : 'Opslaan',
                          style: AppStyles.of(context).data.textStyle.buttonText
                        ),
                        style: ElevatedButton.styleFrom(
                          primary:AppColors.primary,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }
}
