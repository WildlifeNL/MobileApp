import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wildlife_nl_app/flavors.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';
import 'package:wildlife_nl_app/utilities/app_text_styles.dart';
import 'package:wildlife_nl_app/widgets/CustomStepper.dart';
import 'package:http/http.dart' as http;

class Animal {
  final String name;
  final String img;
  final String id;

  Animal({
    required this.name,
    required this.img,
    required this.id,
  });
}

class AnimalQuestion {
  final String inputType;
  final String question;
  final bool optional;
  final String hint;
  final List<dynamic> options;
  final int questionOrder;
  final List<dynamic> interactionTypes;
  List<dynamic> answers;

  AnimalQuestion({
    required this.inputType,
    required this.question,
    required this.optional,
    required this.hint,
    required this.options,
    required this.questionOrder,
    required this.interactionTypes,
    required this.answers,
  });
}

final String baseUrl = F.apiUrl;

List<Animal> animalsApi = [];
List<AnimalQuestion> questionsApi = [
  AnimalQuestion(inputType: 'dropdown', question: 'Hoeveel dieren?', optional: false, hint: '', options: ["0", "1", "2", "3", "4", "5+"], questionOrder: 0, interactionTypes: ['86a6b56a-89f0-11ee-919a-1e0034001676'], answers: ['1']),
  AnimalQuestion(inputType: 'dropdown', question: 'Hoeveel Jonge?', optional: false, hint: '', options: ["0", "1", "2", "3", "4", "5+"], questionOrder: 0, interactionTypes: ['86a6b56a-89f0-11ee-919a-1e0034001676'], answers: ['0'])
];

Future<void> fetchAnimalData() async {
  final animalsResponse =
      await http.get(Uri.parse('${baseUrl}api/controllers/animals.php'));

  if (animalsResponse.statusCode == 200) {
    final Map<String, dynamic> jsonData2 = jsonDecode(animalsResponse.body);

    // Access the 'results' field
    final List<dynamic> results2 = jsonData2['results'];

    // Map the raw JSON data into a list of AnimalType objects
    animalsApi = results2.map((json) {
      return Animal(
        name: json['name'] ?? '',
        img: json['image'] ?? '',
        id: json['id'] ?? '',
      );
    }).toList();
  } else {
    print('Response failed');
  }
}

Future<void> fetchQuestionsData(selectedType) async {
  print(selectedType);
  final questionsResponse =
  await http.get(Uri.parse('${baseUrl}api/controllers/questions.php'));

  if (questionsResponse.statusCode == 200) {
    final Map<String, dynamic> jsonData3 = jsonDecode(questionsResponse.body);

    // Access the 'results' field
    final List<dynamic> results3 = jsonData3['results'];

    // Map the raw JSON data into a list of AnimalType objects
    List<AnimalQuestion> newQuestions = results3
        .where((json) => json['interaction_types'] != null && json['interaction_types'].contains(selectedType))
        .map((json) {
      return AnimalQuestion(
        inputType: json['type'] ?? '',
        question: json['question'] ?? '',
        optional: json['is_optional'] ?? '',
        hint: json['placeholder'] ?? '',
        options: json['specifications'] ?? '',
        questionOrder: json['question_order'],
        interactionTypes: json['interaction_types'] ?? '',
        answers: [''],
      );
    }).toList();
    if(selectedType == '86a6b56a-89f0-11ee-919a-1e0034001676' || selectedType == '689a5571-8eb5-11ee-919a-1e0034001676') {
      questionsApi.addAll(newQuestions);
    } else {
      questionsApi = newQuestions;
    }
    // Filter questions by chosenType
    questionsApi.sort((a, b) => a.questionOrder.compareTo(b.questionOrder));
  } else {
    print('Response failed');
  }
}

class ReportPage extends StatefulWidget {
  final String selectedType;
  const ReportPage({super.key, required this.selectedType});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    fetchAnimalData();
    fetchQuestionsData(widget.selectedType);
  }

  int _currentStep = 0;
  String _chosenAnimal = '';
  double latitude = 0;
  double longitude = 0;
  File? image;

  Future _closeReport(forceClose) async {
    !forceClose
      ? {
          // Code for what to do when submitting a report
          await _getUserLocation(),
          pushReportToApi(),
        }
      : null;
    Navigator.of(context).pop();

    // Reset all to default
    questionsApi = [
      AnimalQuestion(inputType: 'dropdown', question: 'Hoeveel dieren?', optional: false, hint: '', options: ["0", "1", "2", "3", "4", "5+"], questionOrder: 0, interactionTypes: ['86a6b56a-89f0-11ee-919a-1e0034001676'], answers: ['1']),
      AnimalQuestion(inputType: 'dropdown', question: 'Hoeveel Jonge?', optional: false, hint: '', options: ["0", "1", "2", "3", "4", "5+"], questionOrder: 0, interactionTypes: ['86a6b56a-89f0-11ee-919a-1e0034001676'], answers: ['0'])
    ];
    _currentStep = 0;
    _chosenAnimal = '';
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;

      // Now you have the latitude and longitude, and you can use them as needed.
    } catch (e) {
      print('Error getting location: $e');
      // Handle error getting location
    }
  }

  Future<void> pushReportToApi() async {
  //   Push to interactions db
    final String apiUrl = '${baseUrl}api/controllers/interactions.php';

    Map<String, dynamic> report = {
      'user_id': "0e6df1f1-400f-4e8d-8e69-16b1a55b400a",
      'interaction_type': widget.selectedType,
      'lat': latitude,
      'lon': longitude,
      'animal_id': widget.selectedType == '86a6b56a-89f0-11ee-919a-1e0034001676' || widget.selectedType == '689a5571-8eb5-11ee-919a-1e0034001676' ? _chosenAnimal : null,
      'animal_count_upper': widget.selectedType == '86a6b56a-89f0-11ee-919a-1e0034001676' ?  questionsApi[0].answers[0] : null,
      'juvenil_animal_count_upper': widget.selectedType == '86a6b56a-89f0-11ee-919a-1e0034001676' ?  questionsApi[1].answers[0] : null,
    };

    String jsonData = jsonEncode(report);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonData,
      );

      // Check the response status
      if (response.statusCode == 200) {
        print('Data pushed successfully');
        print(response.body);
      } else {
        print('Failed to push data. Status code: ${response.statusCode}');
      }
    } catch (error) {

      print('Error: $error');
    }

    // Push to interaction questions db

    print(report);
  }

  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
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
                        onPressed: () {
                          _closeReport(true);
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
          Flexible(
            child: CustomStepper(
                elevation: 0,
                currentStep: _currentStep,
                controlsBuilder: (context, details) => Text(""),
                steps: [
                  CustomStep(
                      state: _currentStep < 0
                          ? CustomStepState.indexed
                          : (_currentStep > 0
                              ? CustomStepState.complete
                              : CustomStepState.editing),
                      content: Container(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wat is het dier?',
                              style: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .cardTitle
                                  .copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                            Container(
                              child: FutureBuilder(
                                  future: fetchAnimalData(),
                                  builder: (context, snapshot) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 4),
                                      width: double.maxFinite,
                                      child: Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: animalsApi.map((Animal) => GestureDetector(
                                          onTap: () {
                                            if (_chosenAnimal != Animal.id) {
                                              setState(() {
                                                _chosenAnimal = Animal.id;
                                              });
                                            } else {
                                              setState(() {
                                                _chosenAnimal = '';
                                              });
                                            }
                                          },
                                          child: FractionallySizedBox(
                                            widthFactor: 1 / 3.3,
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
                                                          color: _chosenAnimal == Animal.id
                                                              ? AppColors.primary
                                                              : Colors.white,
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
                                                            image: NetworkImage(Animal.img),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  Animal.name,
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles.of(context).data.textStyle.paragraph,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                            .toList(),
                                      ),
                                    );
                                  }),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        _chosenAnimal = value;
                                      });
                                    },
                                    style: AppStyles.of(context)
                                        .data
                                        .textStyle
                                        .paragraph,
                                    decoration: InputDecoration(
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 8),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Anders, namelijk:',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  CustomStep(
                      state: _currentStep >= 1
                          ? CustomStepState.editing
                          : CustomStepState.indexed,
                      content: Container(
                              padding: EdgeInsets.only(top: 4),
                              width: double.maxFinite,
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: questionsApi
                                    .asMap()
                                    .entries
                                    .map((Question) => Container(
                                  width: Question.value.questionOrder >= 1 ? MediaQuery.of(context).size.width - 32 : (MediaQuery.of(context).size.width / 2) - 24,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Question.value.question + (!Question.value.optional ? '*' : ''),
                                        style: AppStyles.of(context)
                                            .data
                                            .textStyle
                                            .cardTitle
                                            .copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      if(Question.value.inputType == 'dropdown' || Question.value.inputType == 'multiselect')
                                        DropdownMenu<String>(
                                          width: Question.key > 1 ? MediaQuery.of(context).size.width - 32 : (MediaQuery.of(context).size.width / 2) - 24,
                                          initialSelection:
                                            Question.key == 0 ? '1' : (Question.key == 1 ? '0' : null),
                                          trailingIcon: Transform.translate(
                                              offset: Offset(10, 0),
                                              child: const Icon(AppIcons.arrow_down, size: 16)),
                                          selectedTrailingIcon: Transform.translate(
                                              offset: Offset(10, 0),
                                              child: Transform.rotate(
                                                  angle: 180 * pi / 180,
                                                  child: const Icon(AppIcons.arrow_down, size: 16))),
                                          hintText: Question.value.hint,
                                          textStyle: AppStyles.of(context).data.textStyle.paragraph,
                                          menuStyle: const MenuStyle(
                                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          inputDecorationTheme: const InputDecorationTheme(
                                              constraints: BoxConstraints(maxHeight: 40),
                                              isDense: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  borderSide: BorderSide.none),
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                                          onSelected: (String? value) {
                                            setState(() {
                                              Question.value.answers[0] = value;
                                            });
                                          },
                                          dropdownMenuEntries:
                                          Question.value.options.map<DropdownMenuEntry<String>>((value) {
                                            return DropdownMenuEntry<String>(
                                              value: value,
                                              label: value,
                                            );
                                          }).toList(),
                                        ),
                                      if(Question.value.inputType == 'star')
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
                                            setState(() {
                                              Question.value.answers[0] = rating.toString();
                                            });
                                          }
                                        ),
                                      if(Question.value.inputType == 'text')
                                        TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              Question.value.answers[0] = value;
                                            });
                                          },
                                          minLines: 3,
                                          maxLines: 5,
                                          style: AppStyles.of(context)
                                              .data
                                              .textStyle
                                              .paragraph,
                                          decoration: InputDecoration(
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 8),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: Question.value.hint,
                                          ),
                                        ),
                                      if(Question.value.inputType == 'file')
                                        Row(
                                          children: [
                                            if(image != null)
                                              Row(
                                                children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          image = null;
                                                        });
                                                      },
                                                      child: Image(
                                                        image: FileImage(image!),
                                                        height: 45,
                                                        width: 45,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  SizedBox(width: 8),
                                                ]
                                              ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  _showPickerDialog();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppColors.neutral_50,
                                                  onPrimary: AppColors.primary,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16, vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                      side: BorderSide(
                                                          color: AppColors.primary, width: 2)),
                                                  elevation: 0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(AppIcons.add, size: 20),
                                                    SizedBox(width:4),
                                                    Text('Voeg foto toe'),
                                                  ]
                                                )
                                            ),
                                          ],
                                        )
                                      
                                    ],
                                  ),
                                )
                                ).toList()
                              ))),
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
                          child: Text('Vorige',
                              style: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .buttonText),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.neutral_50,
                            onPrimary: AppColors.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: AppColors.primary, width: 2)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _currentStep > 0,
                      child: SizedBox(
                          width:
                              16.0), // Space between buttons if 2nd button is visible
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (_chosenAnimal.isNotEmpty && _currentStep == 0)
                                ? () {
                                    setState(() {
                                      _currentStep++;
                                    });
                                  }
                                : ((_currentStep == 1)
                                    ? () {
                                        _closeReport(false);
                                      }
                                    : null),
                        // onPressed: null,
                        child: Text(_currentStep < 1 ? 'Volgende' : 'Opslaan',
                            style: AppStyles.of(context)
                                .data
                                .textStyle
                                .buttonText),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Future<void> _showPickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            padding: EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      const Icon(Icons.image_search, size: 28),
                      const SizedBox(height: 4),
                      Text('Galerij',
                          style: AppStyles.of(context)
                          .data
                          .textStyle
                          .buttonText),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt_outlined, size: 28),
                      const SizedBox(height: 4),
                      Text('Camera',
                          style: AppStyles.of(context)
                              .data
                              .textStyle
                              .buttonText),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}