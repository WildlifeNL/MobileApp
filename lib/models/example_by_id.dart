import 'package:json_annotation/json_annotation.dart';

part "example_by_id.g.dart";

@JsonSerializable()
class GetExampleByIdResponse {
  final int id;
  final String title;
  final String description;
  final int price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory GetExampleByIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetExampleByIdResponseFromJson(json);

  GetExampleByIdResponse(
      this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GetExampleByIdResponseToJson(this);
}
