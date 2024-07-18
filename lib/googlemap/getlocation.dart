import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(45.521563, -122.677433); // Default center
  LatLng _lastMapPosition = const LatLng(45.521563, -122.677433); // Default position
  String _address = ""; // Variable to store address

  Set<Marker> _markers = {}; // Set of markers for Google Maps

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          _lastMapPosition = LatLng(position.latitude, position.longitude);
          _address =
          "${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;

    // Update marker position to be centered on screen
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          draggable: true,
          infoWindow: InfoWindow(
            title: "Selected Location",
            snippet: "Lat: ${_lastMapPosition.latitude}, Lng: ${_lastMapPosition.longitude}",
          ),
          onDragEnd: _onMarkerDragEnd,
        ),
      );
    });

    // Optional: Reverse geocode to update address based on new marker position
    _getAddressFromLatLng(_lastMapPosition);
  }

  void _onMarkerDragEnd(LatLng position) {
    _onCameraMove(CameraPosition(target: position, zoom: 15.0));
  }

  void _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];

        String placeName = placemark.name ?? "Unknown Place";
        String thoroughfare = placemark.thoroughfare ?? "";
        String subThoroughfare = placemark.subThoroughfare ?? "";
        String locality = placemark.locality ?? "";
        String administrativeArea = placemark.administrativeArea ?? "";
        String postalCode = placemark.postalCode ?? "";
        String country = placemark.country ?? "";

        String title = placeName.isNotEmpty
            ? placeName
            : '${thoroughfare.isNotEmpty ? thoroughfare : ''} ${subThoroughfare.isNotEmpty ? subThoroughfare : ''}';

        String address = '';
        if (placeName.isNotEmpty) {
          address += '$placeName, ';
        }
        address +=
        '$thoroughfare $subThoroughfare, $locality, $administrativeArea $postalCode, $country';

        setState(() {
          _address = address;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _saveLocation() {
    print('Saved location: $_lastMapPosition');
    print('Address: $_address');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
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
        markers: _markers,
        onTap: (LatLng position) {
          _onMarkerDragEnd(position);
        },
      ),
    );
  }
}
