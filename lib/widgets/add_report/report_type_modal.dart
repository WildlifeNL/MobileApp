import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/pages/report.dart';
import 'package:wildlife_nl_app/state/interaction_types.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';

class ReportTypeModal extends ConsumerStatefulWidget {
  const ReportTypeModal({super.key});

  @override
  ConsumerState<ReportTypeModal> createState() => _ReportModalState();
}

class _ReportModalState extends ConsumerState<ReportTypeModal> {
  String _selectedType = '';

  @override
  Widget build(BuildContext context) {
    var interactionTypes = ref.watch(interactionTypesProvider);

    if (interactionTypes.isLoading || interactionTypes.hasError || !interactionTypes.hasValue) {
      return Container(
        decoration: ShapeDecoration(
          color: AppColors.neutral_50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide.none,
          ),
        ),
        width: double.maxFinite,
        child: const CircularProgressIndicator(),
      );
    }

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
                _selectedType = '';
              },
              icon: const Icon(AppIcons.cross),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wat wil je melden?',
                style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      getReportTypeSelection(interactionTypes.requireValue),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                                    builder: (context) =>
                                        ReportPage(selectedType: interactionTypes.value!.firstWhere((element) => element.id == _selectedType)),
                                  ),
                                );
                              }
                            : null,
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
                        child: Text('Volgende',
                            style: AppStyles.of(context)
                                .data
                                .textStyle
                                .buttonText),
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

  getReportTypeSelection(List<InteractionType> interactionTypes) {
    return interactionTypes.map((interactionType) {
      return GestureDetector(
        onTap: () {
          if (_selectedType != interactionType.id) {
            setState(() {
              _selectedType = interactionType.id;
            });
          } else {
            setState(() {
              _selectedType = '';
            });
          }
        },
        child: FractionallySizedBox(
          widthFactor: 1 / 3.2,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: _selectedType == interactionType.id
                    ? BorderSide(
                        color: HexColor(interactionType.color),
                        width: 2,
                      )
                    : BorderSide.none,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Icon(
                    switch (interactionType.typeKey) {
                      InteractionTypeKey.sighting => AppIcons.paw,
                      InteractionTypeKey.damage => AppIcons.incident,
                      InteractionTypeKey.inappropriateBehaviour =>
                        AppIcons.cancel,
                      InteractionTypeKey.traffic => AppIcons.traffic,
                      InteractionTypeKey.maintenance => AppIcons.maintenance,
                    },
                    size: 30,
                    color: HexColor(interactionType.color)),
                Text(
                  textAlign: TextAlign.center,
                  interactionType.label,
                  style: AppStyles.of(context).data.textStyle.paragraph,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
