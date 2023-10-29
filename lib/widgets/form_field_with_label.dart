import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';

class FormFieldWithLabel extends StatelessWidget {
  const FormFieldWithLabel(
      {super.key, required this.child, required this.labelText});

  final String labelText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.6),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                labelText,
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
