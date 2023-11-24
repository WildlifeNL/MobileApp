import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
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

class AnimalQuestion {
  final String inputType;
  final String question;
  final bool required;
  final bool fullWidth;
  final String hint;
  final List<String> options;

  AnimalQuestion({required this.inputType, required this.question,required this.required, required this.fullWidth, required this.hint, required this.options});
}

final List<AnimalQuestion> animalQuestions = [
  AnimalQuestion(
    inputType: 'dropdown',
    question: "Aantal dieren:",
    required: true,
    fullWidth: false,
    hint: "Selecteer aantal",
    options: ['0','1','2','3','4','5+'],
  ),
  AnimalQuestion(
    inputType: 'dropdown',
    question: "Aantal jonge:",
    required: true,
    fullWidth: false,
    hint: "Selecteer aantal",
    options: ['0','1','2','3','4','5+'],
  ),
  AnimalQuestion(
    inputType: 'dropdown',
    question: "Wat was je aan het doen toen je het dier zag?",
    required: false,
    fullWidth: true,
    hint: "Selecteer handeling",
    options: [
      'Er op af rennen',
      'Luide geluiden maken',
      'Langzaam er naar toe lopen',
      'Een selfie maken',
      'Wegrennen',
      'Een foto maken',
      'Langs het dier lopen',
      'Stil blijven staan',
      'Naar het dier kijken',
      'Langzaam weglopen',
    ],
  ),
  AnimalQuestion(
      inputType: 'horizontalOptions',
      question: 'Hoe voelde je je toen je het dier zag?',
      required: false,
      fullWidth: true,
      hint: '',
      options: ['angstig', 'neutraal', 'enthousiast']
  ),
  AnimalQuestion(
    inputType: 'dropdown',
    question: "Wat deed het dier?",
    required: false,
    fullWidth: true,
    hint: "Selecteer handeling",
    options: [
      'Het deed zijn eigen ding',
      'Het toonde interesse in mij',
      'Het rende weg van mij',
      'Het toonde agressief gedrag',
    ],
  ),
  AnimalQuestion(
      inputType: 'horizontalOptions',
      question: 'Hoe denk je dat het dier zich voelde?',
      required: false,
      fullWidth: true,
      hint: '',
      options: ['angstig', 'neutraal', 'enthousiast']
  ),
  AnimalQuestion(
    inputType: 'stars',
    question: 'Hoe zou je de interactie beoordelen?',
    required: false,
    fullWidth: true,
    hint: '',
    options: [],
  ),
  AnimalQuestion(
    inputType: 'photo',
    question: "Heb je foto's van de waarneming?",
    required: false,
    fullWidth: true,
    hint: '',
    options: [],
  ),
];

final animalQuestionsMap = animalQuestions.asMap();

List<String> _evaluationAnswers = ['1', '0'] + List.filled((animalQuestions.length - 2), "");
String _chosenType = '';
String _chosenName = '';

class ReportPage extends StatefulWidget {
  ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _currentStep = 0;

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

  Future<void> _pickImage(ImageSource source, i) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        // Do something with the picked image file
        // print("Image picked: ${pickedFile.path}");
        _evaluationAnswers[i] = pickedFile.path;
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future _cancelReport() async {
    print(_evaluationAnswers);
    Navigator.of(context).pop();
    _currentStep = 0;
    _chosenName = '';
    _chosenType= '';
    _evaluationAnswers = ['1', '0'] + List.filled((animalQuestions.length - 2), "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 4,
                top: 35,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: (){
                              _cancelReport();
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
                          padding: EdgeInsets.only(top: 4),
                          width: double.maxFinite,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: animalQuestionsMap.map((i, question) {
                              if (question.inputType == "dropdown") {
                                return MapEntry(i,
                                    MyDropdown(
                                      options: question.options,
                                      title: question.question,
                                      placeholder: question.hint,
                                      fullWidth: question.fullWidth,
                                      required: question.required,
                                      index: i,
                                    )
                                );
                              } else if (question.inputType == 'horizontalOptions') {
                                return MapEntry(i, Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        question.question,
                                        style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height:8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: question.options.map((option) => GestureDetector(
                                          onTap: (){
                                            if(_evaluationAnswers[i] != option) {
                                              setState(() {
                                                _evaluationAnswers[i] = option;
                                              });
                                            } else {
                                                setState(() {
                                                  _evaluationAnswers[i] = '';
                                                });
                                            }
                                          },
                                          child: Container(
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  side: BorderSide(
                                                    color: _evaluationAnswers[i] == option ? AppColors.primary : Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                              child: Text(option, style: AppStyles.of(context).data.textStyle.paragraph,)
                                          ),
                                        )).toList(),
                                      )
                                    ],
                                  ),
                                ));
                              }
                              else if (question.inputType == 'stars'){
                                return MapEntry(i, Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        question.question,
                                        style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      RatingBar.builder(
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: AppColors.primary,
                                        ),
                                        onRatingUpdate: (rating) {
                                          if(_evaluationAnswers[i] != rating) {
                                              _evaluationAnswers[i] = rating.toString();
                                          }
                                        },
                                      ),
                                    ]
                                )
                                ));
                              }
                              else if (question.inputType == 'photo') {
                                return MapEntry(i, Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        question.question,
                                        style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height:8),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _pickImage(ImageSource.gallery, i); // Open gallery
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(AppIcons.add, size: 20),
                                                SizedBox(width: 4),
                                                Text("Voeg foto toe"),
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors.neutral_50,
                                              onPrimary: AppColors.primary,
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  side: BorderSide(color: AppColors.primary, width: 2)
                                              ),
                                              elevation: 0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ]
                                  )
                                ));
                              }
                              else {
                                return MapEntry(i, Container());
                              }
                            }).values.toList(),
                          )
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
                              primary: AppColors.neutral_50,
                              onPrimary: AppColors.primary,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: AppColors.primary, width: 2)
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _currentStep > 0,
                        child: SizedBox(width: 16.0), // Space between buttons if 2nd button is visible
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
                            } : ((_currentStep == 2) ? () {
                            _cancelReport();
                          }  : null)),
                          // onPressed: null,
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

class MyDropdown extends StatefulWidget {
  final List<String> options;
  final String title;
  final String placeholder;
  final bool required;
  final bool fullWidth;
  final int index;

  MyDropdown({required this.options, required this.title, required this.placeholder, required this.required, required this.fullWidth, required this.index});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (widget.title + (widget.required ? '*' : '')),
          style: AppStyles
              .of(context)
              .data
              .textStyle
              .cardTitle
              .copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownMenu<String>(
          initialSelection: widget.index == 0 ? '1' : (widget.index == 1 ? '0' : null),
          trailingIcon: Transform.translate(offset: Offset(10, 0),child: const Icon(AppIcons.arrow_down, size: 16)),
          selectedTrailingIcon: Transform.translate(offset: Offset(10, 0),child: Transform.rotate(angle: 180 * pi / 180, child: const Icon(AppIcons.arrow_down, size: 16))),
          width: widget.fullWidth ? MediaQuery.of(context).size.width - 32 : (MediaQuery.of(context).size.width / 2) - 24,
          hintText: widget.placeholder,
          textStyle: AppStyles
              .of(context)
              .data
              .textStyle
              .paragraph,
          menuStyle: const MenuStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            visualDensity: VisualDensity.compact,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            constraints: BoxConstraints(maxHeight: 40),
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide.none),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8)
          ),
          onSelected: (String? value) {
              setState(() {
                _evaluationAnswers[widget.index] = value!;
              });
          },
          dropdownMenuEntries: widget.options.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(
              value: value,
              label: value,
            );
          }).toList(),
        ),
      ],
    );
  }
}