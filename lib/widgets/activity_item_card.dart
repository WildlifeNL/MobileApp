import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_symbols_icons/symbols.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';

class ActivityItemCard extends ConsumerWidget {
  const ActivityItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.color,
    this.description,
    required this.animation,
  }) : assert(title.length <= 21);

  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime date;
  final Color color;
  final String? description;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: Easing.standard, reverseCurve: Easing.standardAccelerate);
    final formatter = intl.DateFormat.yMd().add_jm();
    
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(curvedAnimation),
      child: SizeTransition(
        sizeFactor: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(curvedAnimation),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.4,
            end: 1,
          ).animate(curvedAnimation),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                  bottom: description == null ? 8 : 0),
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
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: color),
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
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                subtitle,
                                softWrap: true,
                                style: const TextStyle(
                                  color: AppColors.neutral_400,
                                  fontWeight: FontWeight.w300,
                                  height: 1.3,
                                  fontSize: 12,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          formatter.format(date),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.neutral_400,
                            fontWeight: FontWeight.w300,
                            height: 1,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description != null)
                    ActivityItemDescription(
                      description: description!,
                    ),
                ],
              ),
            ),
          ),
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
          const style = TextStyle(
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
