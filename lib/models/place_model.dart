class PlaceModel {
  final String id;
  final String name;
  final String address;
  final String description;
  final String postcode;
  final int stars;
  final List images;
  final bool showPublic;

  PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.postcode,
    required this.stars,
    required this.images,
    required this.showPublic,
  });
}