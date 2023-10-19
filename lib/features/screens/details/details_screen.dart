import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  late String id;
  late String image;
  late String name;
  late String description;
  late String address;
  late double price;
  late double rating;
  late double lat;
  late double lng;
  late String created_at;

  DetailsScreen({
    super.key,
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

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
