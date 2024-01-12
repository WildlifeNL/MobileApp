import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';

import '../../state/animal_types.dart';

class ReportOtherModal extends ConsumerStatefulWidget {
  const ReportOtherModal({super.key});

  @override
  ConsumerState<ReportOtherModal> createState() => _ReportModalState();
}

class _ReportModalState extends ConsumerState<ReportOtherModal> {
  String textinput = '';
  String animal = '';

  String animalId = '';

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
            element.name.toLowerCase() == animal.toLowerCase())
        .map(
          (currentAnimal) => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                setState(() {
                  animal = currentAnimal.name;
                  animalId = currentAnimal.id;
                });

                // Add to AddReport
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: animalId == currentAnimal.id
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: Colors.transparent)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(currentAnimal.image!),
                    ),
                    const SizedBox(width: 16),
                    Text(currentAnimal.name)
                  ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: 16 + MediaQuery.of(context).viewInsets.bottom),
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context, null);
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
            TextField(
              onChanged: (value) {
                setState(() {
                  textinput = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zoek een dier',
              ),
            ),
            const SizedBox(height: 32),
            if (textinput != '' || animal != '')
              Container(
                  width: double.maxFinite,
                  constraints: BoxConstraints(
                      maxHeight:
                          (stuff.length * 75).clamp(75, 200).toDouble()),
                  child: PrimaryScrollController(
                    controller: myScrollWorks,
                    child: CupertinoScrollbar(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return stuff[index];
                        },
                        itemCount: stuff.length,
                      ),
                    ),
                  )),
            if (textinput != '' || animal != '') const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, animalId);
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
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
