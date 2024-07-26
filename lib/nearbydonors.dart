import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NearbyDonors extends StatefulWidget {
  const NearbyDonors({super.key});

  @override
  State<NearbyDonors> createState() => _NearbyDonorsState();
}

class _NearbyDonorsState extends State<NearbyDonors> {
  String searchQuery = '';
  Position? _userPosition;
  List<Map<String, dynamic>> _donors = [];
  List<Map<String, dynamic>> _filteredDonors = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _userPosition = position;
        });
        await _fetchDonors(); // Fetch donors once user location is obtained
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  Future<void> _fetchDonors() async {
    if (_userPosition == null) return; // Ensure user position is available

    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').get();
      final docs = snapshot.docs;

      List<Map<String, dynamic>> donors = [];
      for (var doc in docs) {
        var data = doc.data() as Map<String, dynamic>;
        GeoPoint? geoPoint = data['currentPosition'] as GeoPoint?;

        if (geoPoint != null) {
          double distance = _calculateDistance(
            _userPosition!.latitude,
            _userPosition!.longitude,
            geoPoint.latitude,
            geoPoint.longitude,
          );

          donors.add({
            'data': data,
            'distance': distance,
          });
        }
      }

      donors.sort((a, b) => a['distance'].compareTo(b['distance'])); // Sort by distance

      setState(() {
        _donors = donors;
        _filteredDonors = donors; // Initialize filtered donors
      });
    } catch (e) {
      print('Error fetching donors: $e');
    }
  }

  void _filterDonors(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredDonors = _donors.where((donor) {
        final data = donor['data'] as Map<String, dynamic>;
        final name = data['name']?.toLowerCase() ?? '';
        final bloodGroup = data['BloodGroup']?.toLowerCase() ?? '';
        return name.contains(lowerQuery) || bloodGroup.contains(lowerQuery);
      }).toList();
    });
  }

  double _calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const int earthRadius = 6371; // Radius of the earth in km
    double latDistance = _toRadians(endLatitude - startLatitude);
    double lonDistance = _toRadians(endLongitude - startLongitude);
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(_toRadians(startLatitude)) * cos(_toRadians(endLatitude)) *
            sin(lonDistance / 2) * sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; // Distance in km
    return distance;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Nearby Donors',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0), // Reduced padding for a smaller search box
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterDonors(searchQuery);
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Search by name or blood group...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Reduced border radius
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: _userPosition == null
                ? Center(child: CircularProgressIndicator())
                : _filteredDonors.isEmpty
                ? Center(child: Text('No donors found.'))
                : ListView.separated(
              itemCount: _filteredDonors.length,
              separatorBuilder: (context, index) => Divider(height: 1.0),
              itemBuilder: (context, index) {
                var donor = _filteredDonors[index];
                var data = donor['data'] as Map<String, dynamic>;
                double distance = donor['distance'] as double;

                return Container(
                  padding: EdgeInsets.all(8.0), // Reduced padding for a smaller container
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0), // Reduced margin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0), // Reduced border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16.0, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0), // Reduced spacing
                      Text(
                        'Email: ${data['email'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14.0, // Reduced font size
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 2.0), // Reduced spacing
                      Text(
                        'Phone: ${data['phone'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14.0, // Reduced font size
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 2.0), // Reduced spacing
                      Text(
                        'Blood Group: ${data['BloodGroup'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14.0, // Reduced font size
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 6.0), // Reduced spacing
                      Text(
                        'Distance: ${distance.toStringAsFixed(2)} km',
                        style: TextStyle(
                          fontSize: 14.0, // Reduced font size
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
