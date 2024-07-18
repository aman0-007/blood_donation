import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Function(LatLng, String, String) onSelectLocation;

  MapScreen({required this.onSelectLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLatLng;
  String _placeName = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_selectedLatLng != null && _placeName.isNotEmpty && _address.isNotEmpty) {
                widget.onSelectLocation(_selectedLatLng!, _placeName, _address);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select a location first.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // Initial center of the map (San Francisco)
              zoom: 12.0,
            ),
            onTap: (LatLng latLng) {
              _selectedLatLng = latLng;
              _updateLocationDetails(latLng);
            },
          ),
          if (_selectedLatLng != null)
            Center(
              child: Icon(
                Icons.location_pin,
                size: 40.0,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  void _updateLocationDetails(LatLng latLng) {
    // Mock implementation for demo purposes
    _placeName = 'Selected Place';
    _address = '123 Street, Area, City, Pincode';
  }
}
