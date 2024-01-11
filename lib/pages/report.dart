import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:wildlife_nl_app/flavors.dart';
import 'package:wildlife_nl_app/models/animal.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/models/question.dart';
import 'package:wildlife_nl_app/state/animal_types.dart';
import 'package:wildlife_nl_app/state/interaction_types.dart';
import 'package:wildlife_nl_app/state/interactions.dart';
import 'package:wildlife_nl_app/state/questions.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';
import 'package:wildlife_nl_app/widgets/custom_stepper.dart';

class ReportPage extends ConsumerStatefulWidget {
  final InteractionType selectedType;

  const ReportPage({super.key, required this.selectedType});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  int _currentStep = 0;
  String _chosenAnimal = '';
  double latitude = 0;
  double longitude = 0;
  File? image;

  List<Map<String, dynamic>> answers = [];

  Future _closeReport(forceClose) async {
    if (!forceClose) {
      pushReportToApi().then((value) {
        Navigator.of(context).pop();
      });
    } else {
      Navigator.of(context).pop();
    }
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
      developer.log('Error getting location: $e');
      // Handle error getting location
    }
  }

  Future<void> pushReportToApi() async {
    await _getUserLocation();
    //   Push to interactions db
    final String apiUrl = '${F.apiUrl}api/controllers/interactions.php';

    Map<String, Object?> report = {
      'user_id': "0e6df1f1-400f-4e8d-8e69-16b1a55b400a",
      'interaction_type': widget.selectedType.id,
      'lat': latitude,
      'lon': longitude,
      'animal_id': widget.selectedType.typeKey == InteractionTypeKey.sighting ||
              widget.selectedType.typeKey == InteractionTypeKey.traffic
          ? _chosenAnimal
          : null,
      'animal_count_upper':
          widget.selectedType.typeKey == InteractionTypeKey.sighting
              ? answers[0]["answers"][0]
              : null,
      'juvenil_animal_count_upper':
          widget.selectedType.typeKey == InteractionTypeKey.sighting
              ? answers[1]["answers"][0]
              : null,
      "questions": answers
          .skip(widget.selectedType.typeKey == InteractionTypeKey.sighting ? 2 : 0)
          .map((answer) => {
                "question_id": answer["id"],
                "answer": jsonEncode(answer["answers"]),
              })
          .toList()
    };

    String jsonData = jsonEncode(report);
    developer.log(jsonData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonData,
      );

      // Check the response status
      if (response.statusCode == 200) {
        ref.invalidate(interactionsProvider);
        ref.invalidate(mapInteractionsProvider);
        developer.log('Data pushed successfully');
        developer.log(response.body);
      } else {
        developer
            .log('Failed to push data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      developer.log('Error: $error');
    }

    developer.log(report.toString());
  }

  Future<void> pickImage(ImageSource source, key) async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      developer.log('Error picking image: $e');
    }

    imageToUrl(image!, key);
  }

  Future<String?> imageToUrl(File image, key) async {
    // Replace this key with your own API key
    String apiKey = "795da2c1f5780b930d83ae17bf965afe";

    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgbb.com/1/upload'),
    );

    // Add the API key to the request
    request.fields['key'] = apiKey;

    // Add the image file to the request
    var fileStream = http.ByteStream(image.openRead());
    var length = await image.length();
    request.files.add(http.MultipartFile(
      'image',
      fileStream,
      length,
      filename: Random().nextInt(1000).toString() + '.jpg',
    ));

    // Send the request
    var response = await request.send();

    // Read and decode the response
    if (response.statusCode == 200) {
      // Successful upload
      var responseData = await response.stream.bytesToString();
      // Parse the JSON response and get the display URL
      var parsedData = json.decode(responseData);
      var displayUrl = parsedData['data']['display_url'];
      answers[key]["answers"] = displayUrl;
    } else {
      // Handle the error (e.g., print an error message)
      print('Error uploading image: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animals = ref.watch(animalTypesProvider);
    final interactionTypes = ref.watch(interactionTypesProvider);
    final questions = ref.watch(questionsProvider(widget.selectedType));

    if (animals.isLoading ||
        animals.hasError ||
        interactionTypes.isLoading ||
        interactionTypes.hasError ||
        questions.isLoading ||
        questions.hasError) {
      return Scaffold(
        body: Column(children: [
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
                SizedBox(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          _closeReport(true);
                        },
                        icon: const Icon(AppIcons.cross)),
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ]),
      );
    }

    var index = 0;

    while (answers.length < questions.value!.length) {
      if (widget.selectedType.typeKey == InteractionTypeKey.sighting) {
        if (index == 0) {
          answers.add({
            'answers': ["1"],
            'id': null
          });
        } else if (index == 1) {
          answers.add({
            'answers': ["0"],
            'id': null
          });
        } else {
          answers.add({'answers': [], 'id': questions.value![index].id});
        }
      } else {
        answers.add({'answers': [], 'id': questions.value![index].id});
      }
      index++;
    }

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
                SizedBox(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          _closeReport(true);
                        },
                        icon: const Icon(AppIcons.cross)),
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
            child: switch (widget.selectedType.typeKey) {
              InteractionTypeKey.sighting => CustomStepper(
                    elevation: 0,
                    currentStep: _currentStep,
                    controlsBuilder: (context, details) => const Text(""),
                    steps: [
                      CustomStep(
                        state: _currentStep < 0
                            ? CustomStepState.indexed
                            : (_currentStep > 0
                                ? CustomStepState.complete
                                : CustomStepState.editing),
                        content: pickAnimalStep(animals, 'Welk dier heb je gezien?'),
                      ),
                      CustomStep(
                          state: _currentStep >= 1
                              ? CustomStepState.editing
                              : CustomStepState.indexed,
                          content: evaluationQuestions(questions)),
                    ]),
              InteractionTypeKey.damage => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: evaluationQuestions(questions)),
              InteractionTypeKey.inappropriateBehaviour => CustomStepper(
                  elevation: 0,
                  currentStep: _currentStep,
                  controlsBuilder: (context, details) => const Text(""),
                  steps: [
                    CustomStep(
                      state: _currentStep < 0
                          ? CustomStepState.indexed
                          : (_currentStep > 0
                          ? CustomStepState.complete
                          : CustomStepState.editing),
                      content: pickAnimalStep(animals, 'Bij welk dier is er iets gebeurd?'),
                    ),
                    CustomStep(
                        state: _currentStep >= 1
                            ? CustomStepState.editing
                            : CustomStepState.indexed,
                        content: evaluationQuestions(questions)),
                  ]),
              InteractionTypeKey.traffic => CustomStepper(
                    elevation: 0,
                    currentStep: _currentStep,
                    controlsBuilder: (context, details) => const Text(""),
                    steps: [
                      CustomStep(
                        state: _currentStep < 0
                            ? CustomStepState.indexed
                            : (_currentStep > 0
                                ? CustomStepState.complete
                                : CustomStepState.editing),
                        content: pickAnimalStep(animals, 'Welk dier heb je gezien?'),
                      ),
                      CustomStep(
                          state: _currentStep >= 1
                              ? CustomStepState.editing
                              : CustomStepState.indexed,
                          content: evaluationQuestions(questions)),
                    ]),
              InteractionTypeKey.maintenance => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: evaluationQuestions(questions)),
            },
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neutral_50,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                                color: AppColors.primary, width: 2)),
                        elevation: 0,
                      ),
                      child: Text('Vorige',
                          style:
                              AppStyles.of(context).data.textStyle.buttonText),
                    ),
                  ),
                ),
                Visibility(
                  visible: _currentStep > 0,
                  child: const SizedBox(
                      width:
                          16.0), // Space between buttons if 2nd button is visible
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: switch (widget.selectedType.typeKey) {
                      InteractionTypeKey.sighting =>
                        (_chosenAnimal.isNotEmpty && _currentStep == 0)
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
                      InteractionTypeKey.damage => () {
                          _closeReport(false);
                        },
                      InteractionTypeKey.inappropriateBehaviour =>
                      (_chosenAnimal.isNotEmpty && _currentStep == 0)
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
                      InteractionTypeKey.traffic =>
                        (_chosenAnimal.isNotEmpty && _currentStep == 0)
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
                      InteractionTypeKey.maintenance => () {
                          _closeReport(false);
                        },
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    // onPressed: null,
                    child: Text(
                        switch (widget.selectedType.typeKey) {
                          InteractionTypeKey.sighting =>
                            _currentStep < 1 ? 'Volgende' : 'Opslaan',
                          InteractionTypeKey.damage => "Opslaan",
                          InteractionTypeKey.inappropriateBehaviour =>
                            _currentStep < 1 ? 'Volgende' : 'Opslaan',
                          InteractionTypeKey.traffic =>
                            _currentStep < 1 ? 'Volgende' : 'Opslaan',
                          InteractionTypeKey.maintenance => "Opslaan",
                        },
                        style: AppStyles.of(context).data.textStyle.buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pickAnimalStep(animals, animalQuestion) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            animalQuestion,
            style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                  color: AppColors.primary,
                ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4),
            width: double.maxFinite,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: (animals.value! as List<Animal>)
                  .map(
                    (animal) => GestureDetector(
                      onTap: () {
                        if (_chosenAnimal != animal.id) {
                          setState(() {
                            _chosenAnimal = animal.id;
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
                                      color: _chosenAnimal == animal.id
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
                                        image: NetworkImage(animal.image ??
                                            "https://placehold.co/600x400/EEE/31343C"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              animal.name,
                              textAlign: TextAlign.center,
                              style: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .paragraph,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _chosenAnimal = value;
                    });
                  },
                  style: AppStyles.of(context).data.textStyle.paragraph,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
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
    );
  }

  Widget evaluationQuestions(AsyncValue<List<Question>> questions) {
    return Container(
        padding: const EdgeInsets.only(top: 4),
        width: double.maxFinite,
        child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: questions.value!
                .asMap()
                .entries
                .map((question) => SizedBox(
                      width: question.value.questionOrder >= 1
                          ? MediaQuery.of(context).size.width - 32
                          : (MediaQuery.of(context).size.width / 2) - 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.value.question +
                                (!question.value.isOptional ? '*' : ''),
                            style: AppStyles.of(context)
                                .data
                                .textStyle
                                .cardTitle
                                .copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          if (question.value.type == 'dropdown')
                            DropdownMenu<String>(
                              width: question.value.questionOrder >= 1
                                  ? MediaQuery.of(context).size.width - 32
                                  : (MediaQuery.of(context).size.width / 2) -
                                      24,
                              initialSelection: question.key == 0
                                  ? '1'
                                  : (question.key == 1 ? '0' : null),
                              trailingIcon: Transform.translate(
                                  offset: const Offset(10, 0),
                                  child: const Icon(AppIcons.arrow_down,
                                      size: 16)),
                              selectedTrailingIcon: Transform.translate(
                                  offset: const Offset(10, 0),
                                  child: Transform.rotate(
                                      angle: 180 * pi / 180,
                                      child: const Icon(AppIcons.arrow_down,
                                          size: 16))),
                              hintText: question.value.placeholder,
                              textStyle: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .paragraph,
                              menuStyle: const MenuStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                visualDensity: VisualDensity.compact,
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                  constraints: BoxConstraints(maxHeight: 40),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide.none),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16)),
                              onSelected: (String? value) {
                                setState(() {
                                  answers[question.key]["answers"] = value;
                                });
                              },
                              dropdownMenuEntries: question.value.specifications
                                  .map<DropdownMenuEntry<String>>((value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                );
                              }).toList(),
                            ),
                          if (question.value.type == 'multiselect')
                            MultiSelectDropDown(
                              dropdownHeight: 300,
                              suffixIcon: Icon(AppIcons.arrow_down, size: 16),
                              hint: question.value.placeholder ?? "",
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              selectedOptionBackgroundColor: AppColors.primary,
                              selectedOptionTextColor: Colors.white,
                              borderRadius: 8,
                              onOptionSelected: (selectedOptions) {
                                setState(() {
                                  answers[question.key]["answers"] = [];

                                  if (selectedOptions.isNotEmpty) {
                                    for (var option in selectedOptions) {
                                      int index =
                                          selectedOptions.indexOf(option);
                                      // Ensure the list has enough elements before accessing the index
                                      while (answers[question.key]["answers"]
                                              .length <=
                                          index) {
                                        answers[question.key]["answers"]
                                            .add(null);
                                      }
                                      answers[question.key]["answers"][index] =
                                          option.value.toString();
                                    }
                                  }
                                });
                              },
                              options: question.value.specifications
                                  .map<ValueItem<String>>((value) {
                                return ValueItem(
                                  value: value,
                                  label: value,
                                );
                              }).toList(),
                              selectionType: SelectionType.multi,
                              chipConfig:
                                  const ChipConfig(wrapType: WrapType.scroll),
                              optionTextStyle: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .paragraph,
                              hintStyle: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .paragraph,
                              selectedOptionIcon:
                                  const Icon(Icons.check_circle),
                              borderColor: AppColors.neutral_50,
                            ),
                          if (question.value.type == 'star')
                            RatingBar.builder(
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: AppColors.primary,
                                    ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    if (answers[question.key]["answers"]
                                        .isEmpty) {
                                      answers[question.key]["answers"]
                                          .add(null);
                                    }

                                    answers[question.key]["answers"] =
                                        rating.toString();
                                  });
                                }),
                          if (question.value.type == 'text')
                            TextFormField(
                              onChanged: (String? value) {
                                setState(() {
                                  if (answers[question.key]["answers"]
                                      .isEmpty) {
                                    answers[question.key]["answers"].add(null);
                                  }

                                  answers[question.key]["answers"] = value;
                                });
                              },
                              minLines: 3,
                              maxLines: 5,
                              style: AppStyles.of(context)
                                  .data
                                  .textStyle
                                  .paragraph,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: question.value.placeholder,
                              ),
                            ),
                          if (question.value.type == 'file')
                            Row(
                              children: [
                                if (image != null)
                                  Row(children: [
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
                                    const SizedBox(width: 8),
                                  ]),
                                ElevatedButton(
                                    onPressed: () {
                                      _showPickerDialog(question.key);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.neutral_50,
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                              color: AppColors.primary,
                                              width: 2)),
                                      elevation: 0,
                                    ),
                                    child: const Row(children: [
                                      Icon(AppIcons.add, size: 20),
                                      SizedBox(width: 4),
                                      Text('Voeg foto toe'),
                                    ])),
                              ],
                            ),
                        ],
                      ),
                    ))
                .toList()));
  }

  Future<void> _showPickerDialog(key) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      const Icon(Icons.image_search, size: 28),
                      const SizedBox(height: 4),
                      Text('Galerij',
                          style:
                              AppStyles.of(context).data.textStyle.buttonText),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery, key);
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt_outlined, size: 28),
                      const SizedBox(height: 4),
                      Text('Camera',
                          style:
                              AppStyles.of(context).data.textStyle.buttonText),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera, key);
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
