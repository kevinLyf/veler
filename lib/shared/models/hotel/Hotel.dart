class Hotel{
  late String id;
  late String? image;
  late String name;
  late String? description;
  late String address;
  late double price;
  late double rating;
  late double lat;
  late double lng;
  late String created_at;

  Hotel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.address,
    required this.price,
    required this.rating,
    required this.lat,
    required this.lng,
    required this.created_at,
  });
}
