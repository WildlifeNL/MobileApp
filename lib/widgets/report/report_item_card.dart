import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_symbols_icons/symbols.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';
import 'package:wildlife_nl_app/utilities/hex_color.dart';

class ActivityItemCard extends ConsumerWidget {
  const ActivityItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.color,
    this.description,
  }) : assert(title.length <= 21);

  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime date;
  final Color color;
  final String? description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = intl.DateFormat.yMd().add_jm();

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 8)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppStyles.of(context).data.textStyle.cardTitle.copyWith(color: HexColor("#737373")),
                        ),
                        Text(
                          formatter.format(date),
                          style: AppStyles.of(context).data.textStyle.paragraph.copyWith(color: AppColors.neutral_400),
                        ),
                        Text(
                          subtitle,
                          softWrap: true,
                          style: AppStyles.of(context).data.textStyle.paragraph.copyWith(color: AppColors.neutral_400),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                //TODO: Re-enable when working
                //IconButton(onPressed: () {}, icon: const Icon(AppIcons.arrow_right)),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityItemDescription extends StatefulWidget {
  const ActivityItemDescription({
    super.key,
    required this.description,
  });

  final String description;

  @override
  State<ActivityItemDescription> createState() =>
      _ActivityItemDescriptionState();
}

class _ActivityItemDescriptionState extends State<ActivityItemDescription> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final style = GoogleFonts.inter(
            color: AppColors.neutral_500,
            fontWeight: FontWeight.w300,
            height: 1,
            fontSize: 13,
          );
          final span = TextSpan(text: widget.description, style: style);
          final tp = TextPainter(
              text: span,
              textDirection: TextDirection.ltr,
              textScaler: MediaQuery.of(context).textScaler);
          tp.layout(maxWidth: constraints.maxWidth);
          final numLines = tp.computeLineMetrics().length;

          if (numLines > 2) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedCrossFade(
                  firstCurve: Easing.standard,
                  secondCurve: Easing.standard,
                  sizeCurve: Easing.standard,
                  secondChild: GestureDetector(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.start,
                      style: style,
                      maxLines: null,
                    ),
                  ),
                  firstChild: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.2)],
                        stops: const [0.0, 1.0],
                      ).createShader(bounds);
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.start,
                        style: style,
                        maxLines: 4,
                      ),
                    ),
                  ),
                  crossFadeState: !expanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(
                      milliseconds:
                          MediaQuery.of(context).disableAnimations ? 0 : 175),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: GestureDetector(
                    onTap: () {
                      var wasExpanded = expanded;
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Icon(
                        expanded
                            ? Symbols.keyboard_arrow_up
                            : Symbols.keyboard_arrow_down,
                        weight: 300,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.description,
              textAlign: TextAlign.start,
              style: style,
            ),
          );
        },
      ),
    );
  }
}
