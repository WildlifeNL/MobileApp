import 'package:flutter/cupertino.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

class MapPathModal extends StatelessWidget {
  const MapPathModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.neutral_100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )),
        height: MediaQuery.of(context).size.height * 0.625,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Text("Loop routes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: AppColors.primary)),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.primary),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 4, right: 4),
                        child: Text(
                          "Alles",
                          style: TextStyle(color: AppColors.neutral_50),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.neutral_200),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 4, right: 4),
                        child: Text(
                          "Bospaden",
                          style: TextStyle(color: AppColors.neutral_50),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.neutral_200),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 4, right: 4),
                        child: Text(
                          "Verharde wegen",
                          style: TextStyle(color: AppColors.neutral_50),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text("test"),
                    SizedBox(width: 5),
                    Text("test"),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.neutral_50,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/symbols/satellite.png', width: 100,),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pad 321",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Text("Wat je kan verwachten:"),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border:
                                          Border.all(color: AppColors.primary)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 2, left: 4, right: 4),
                                    child: Text(
                                      "bospaden",
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border:
                                          Border.all(color: AppColors.primary)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 2, left: 4, right: 4),
                                    child: Text(
                                      "Verharde wegen",
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 10),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Text("4km")
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
