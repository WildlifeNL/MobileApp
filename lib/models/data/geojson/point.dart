import 'package:json_annotation/json_annotation.dart';

part "point.g.dart";

@JsonSerializable()
class Point {
  final String type;
  final List<double> coordinates;

  bool isValid() => type == "Point" && coordinates.length == 2;

  Point({this.type = "Point", required this.coordinates});

  factory Point.fromJson(Map<String, dynamic> json) {
    var point = _$PointFromJson(json);

    if(point.type == "Point") return point;

    return Point(coordinates: [], type: "");
  }

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic>? toJson() => _$PointToJson(this);
}
