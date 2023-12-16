import 'package:flutter/cupertino.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';

class MapSettingsToggle extends StatelessWidget {
  const MapSettingsToggle({
    super.key,
    required this.onChanged,
    required this.value,
    required this.label,
    required this.icon,
  });

  final void Function(bool) onChanged;
  final bool value;

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.neutral_50, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
            Transform.scale(
              scale: 1,
              child: CupertinoSwitch(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
