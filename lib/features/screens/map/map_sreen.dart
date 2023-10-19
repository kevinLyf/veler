import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  late String name;
  late String address;
  late double lat;
  late double lng;

  MapScreen({
    super.key,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  bool isLoading = true;
  late Set<Marker> markers = {
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
  };

  @override
  void initState() {
    currentLocation();
    super.initState();
  }

  void currentLocation() async {
    setState(() => isLoading = true);

    Location location = Location();

    try {
      await location.getLocation().then(
            (value) => setState(
              () {
                _currentLocation = value;
                isLoading = false;
              },
            ),
          );
    } catch (err) {
      currentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address,
          style: TextStyle(
            fontFamily: "Nunito",
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              markers: markers,
              circles: {
                Circle(
                  circleId: CircleId(
                    _currentLocation.toString(),
                  ),
                  center: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                ),
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.lat,
                  widget.lng,
                ),
                zoom: 16,
              ),
            ),
    );
  }
}
