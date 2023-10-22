import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veler/features/screens/booking/booking_screen.dart';
import 'package:veler/features/screens/map/map_sreen.dart';

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookingScreen(hotel_id: widget.id),
            ),
          ),
          child: Center(
            child: Text(
              "Book now - \$${widget.price}",
              style: const TextStyle(
                  fontFamily: "Nunito",
                  color: Color(0xffEFEFEF),
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.image,
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 15,
                        left: 10,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back_rounded,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 22,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      widget.address,
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 12,
                        color: Color(
                          0xffC7C7C7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: GoogleMap(
                                      markers: {
                                        Marker(
                                          markerId: MarkerId(
                                            "${widget.lat},${widget.lng}",
                                          ),
                                          position: LatLng(
                                            widget.lat,
                                            widget.lng,
                                          ),
                                          infoWindow: InfoWindow(
                                            title: widget.name,
                                            snippet: widget.address,
                                          ),
                                        ),
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(widget.lat, widget.lng),
                                        zoom: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                            name: widget.name,
                                            address: widget.address,
                                            lat: widget.lat,
                                            lng: widget.lng,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.fullscreen_rounded,
                                        color: Color(0xffEFEFEF),
                                        size: 30,
                                      ),
                                      label: const Text(
                                        "See more details",
                                        style: TextStyle(
                                          fontFamily: "Nunito",
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xffEFEFEF),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                      child: Text(
                        "See on map",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 16,
                          color: Color(0xffC7C7C7),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
