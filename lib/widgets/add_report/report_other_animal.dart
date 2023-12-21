import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/pages/report.dart';
import 'package:wildlife_nl_app/state/interaction_types.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';
import 'package:wildlife_nl_app/widgets/custom_infinite_grouped_list.dart';

import '../../state/animal_types.dart';

class ReportOtherModal extends ConsumerStatefulWidget {
  const ReportOtherModal({super.key});

  @override
  ConsumerState<ReportOtherModal> createState() => _ReportModalState();
}

class _ReportModalState extends ConsumerState<ReportOtherModal> {
  String textinput = '';
  String Animal = '';

  @override
  Widget build(BuildContext context) {
    var animals = ref.watch(animalTypesProvider);
    final ScrollController myScrollWorks = ScrollController();
    if (animals.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var stuff = animals.value!
        .where((element) =>
            (textinput != '' &&
                element.name.toLowerCase().contains(textinput.toLowerCase())) ||
            element.name.toLowerCase() == Animal.toLowerCase())
        .map(
          (animal) => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                setState(() {
                  Animal = animal.name;
                });

                // Add to AddReport
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                    border: Animal == animal.name
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: Colors.transparent)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.network(animal.image!),
                      ),
                      SizedBox(width: 16),
                      Text(animal.name)
                    ],
                  ),
                ),
              )),
        )
        .toList();

    return Container(
      decoration: ShapeDecoration(
        color: AppColors.neutral_50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
                textinput = '';
              },
              icon: const Icon(AppIcons.cross),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Anders, namelijk:',
              textAlign: TextAlign.center,
              style: AppStyles.of(context)
                  .data
                  .textStyle
                  .headerMedium
                  .copyWith(color: AppColors.primary),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    textinput = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Zoek een dier',
                ),
              ),
              const SizedBox(height: 32),
              if (textinput != '' || Animal != '')
                Container(
                    width: double.maxFinite,
                    constraints: BoxConstraints(maxHeight: 250),
                    child: PrimaryScrollController(
                      controller: myScrollWorks,
                      child: CupertinoScrollbar(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: stuff,
                          ),
                        ),
                      ),
                    )),
              if (textinput != '' || Animal != '')
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  // onPressed: null,
                  child: Text('Volgende',
                      style: AppStyles.of(context).data.textStyle.buttonText),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
