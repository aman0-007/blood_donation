import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class Getlocation extends StatefulWidget {
  const Getlocation({Key? key}) : super(key: key);

  @override
  State<Getlocation> createState() => _GetlocationState();
}

class _GetlocationState extends State<Getlocation> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(45.521563, -122.677433); // Default center
  LatLng _lastMapPosition = const LatLng(45.521563, -122.677433); // Default position
  String _address = ""; // Variable to store address

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark placemark = placemarks[0];
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _lastMapPosition = LatLng(position.latitude, position.longitude);
      _address = "${placemark.name}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _saveLocation() {
    print('Saved location: $_lastMapPosition');
    print('Address: $_address'); // Print the address when saved
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Location'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveLocation,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
