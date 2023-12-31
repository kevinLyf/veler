import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:veler/features/screens/menu/menu_screen.dart';

class EditHotelScreen extends StatefulWidget {
  late String id;
  late String image;
  late String name;
  late String description;
  late double price;
  late double lat;
  late double lng;
  late String address;

  EditHotelScreen({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  State<EditHotelScreen> createState() => _EditHotelScreenScreenState();
}

class _EditHotelScreenScreenState extends State<EditHotelScreen> {
  Set<Marker> markers = {};
  late LatLng location;
  final _formKey = GlobalKey<FormState>();
  final _imageController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  Future<void> handleUpdate() async {
    Map<String, dynamic> body = {
      "image": _imageController.text,
      "name": _nameController.text,
      "description": _descriptionController.text,
      "address": _addressController.text,
      "price": double.tryParse(_priceController.text),
      "lat": location.latitude,
      "lng": location.longitude,
    };

    try {
      var response = await http.put(
          Uri.parse("http://10.0.2.2:3000/hotel/${widget.id}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSnackBar(
          "Hotel sucessfully updated",
          Icons.done_rounded,
          Colors.green,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MenuScreen(),
          ),
        );
      }
    } catch (err) {
      showSnackBar("Something went wrong", Icons.router_outlined, Colors.red);
    }
  }

  @override
  void initState() {
    Marker marker = Marker(
      markerId: MarkerId(_nameController.text),
      position: LatLng(
        widget.lat,
        widget.lng,
      ),
    );

    setState(() {
      _imageController.text = widget.image;
      _nameController.text = widget.name;
      _descriptionController.text = widget.description;
      _priceController.text = widget.price.toString();
      _addressController.text = widget.address;
      location = LatLng(widget.lat, widget.lng);
      markers.add(marker);
    });
    super.initState();
  }

  void showSnackBar(String title, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              handleUpdate();
            }
          },
          child: Center(
            child: Text(
              "Update",
              style: const TextStyle(
                fontFamily: "Nunito",
                color: Color(0xffEFEFEF),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 18,
            right: 18,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update hotel",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xffEFEFEF),
                ),
              ),
              const Text(
                "Renew hotel information",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xffC7C7C7),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: GoogleMap(
                                markers: markers,
                                onTap: (LatLng position) {
                                  markers.clear();
                                  Marker marker = Marker(
                                    markerId: MarkerId(
                                      position.toString(),
                                    ),
                                    position: position,
                                  );

                                  setState(() {
                                    markers.add(marker);
                                    location = LatLng(marker.position.latitude,
                                        marker.position.longitude);
                                  });
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(-20, -40),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity:
                                  VisualDensity(vertical: -4, horizontal: -4),
                              leading: Icon(
                                Icons.image_rounded,
                                size: 26,
                                color: Color(0xffC7C7C7),
                              ),
                              title: Text(
                                "Image",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffC7C7C7)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _imageController,
                              decoration: InputDecoration(
                                hintText: "Image (URL)",
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC7C7C7),
                                  ),
                                ),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty)
                                  return "This field is required";

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity(
                                            vertical: -4, horizontal: -4),
                                        leading: Icon(
                                          Icons.subtitles_rounded,
                                          size: 26,
                                          color: Color(0xffC7C7C7),
                                        ),
                                        title: Text(
                                          "Name",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffC7C7C7)),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          hintText: "Name",
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xffC7C7C7),
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty)
                                            return "This field is required";

                                          return null;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity(
                                            vertical: -4, horizontal: -4),
                                        leading: Icon(
                                          Icons.attach_money_rounded,
                                          size: 26,
                                          color: Color(0xffC7C7C7),
                                        ),
                                        title: Text(
                                          "Price",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffC7C7C7)),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _priceController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: "Price",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xffC7C7C7),
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty)
                                            return "This field is required";

                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity:
                                  VisualDensity(vertical: -4, horizontal: -4),
                              leading: Icon(
                                Icons.location_city_rounded,
                                size: 26,
                                color: Color(0xffC7C7C7),
                              ),
                              title: Text(
                                "Address",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffC7C7C7)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                hintText: "Address",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC7C7C7),
                                  ),
                                ),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty)
                                  return "This field is required";

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity:
                                  VisualDensity(vertical: -4, horizontal: -4),
                              leading: Icon(
                                Icons.description,
                                size: 26,
                                color: Color(0xffC7C7C7),
                              ),
                              title: Text(
                                "Description",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffC7C7C7)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty)
                                  return "This field is required";

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
