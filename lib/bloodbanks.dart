import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Bloodbanks extends StatefulWidget {
  const Bloodbanks({Key? key}) : super(key: key);

  @override
  State<Bloodbanks> createState() => _BloodbanksState();
}

class _BloodbanksState extends State<Bloodbanks> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Position? _userPosition; // Initialize as nullable
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) { // Check if the widget is still mounted before setting state
        setState(() {
          _userPosition = position;
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
      // Handle error getting user location
    }
  }

  // Function to calculate distance between two geo points (in kilometers)
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
    // Show a loading indicator while waiting for the user position
    if (_userPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Blood Banks',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Search blood banks...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('hospital')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No blood banks found.'));
                }

                // Filter blood banks based on search query
                var bloodbanks = snapshot.data!.docs.where((doc) {
                  var name = (doc.data()['name'] as String).toLowerCase();
                  return name.contains(searchQuery);
                }).toList();

                // Construct UI to display blood banks
                return ListView.builder(
                  itemCount: bloodbanks.length,
                  itemBuilder: (context, index) {
                    var bloodbankData = bloodbanks[index].data();

                    // Accessing fields assuming they are present in your Firestore document
                    var name = bloodbankData['name'] as String? ?? 'Name not available';
                    var location = bloodbankData['email'] as String? ?? 'Email not available';
                    var geoPoint = bloodbankData['currentPosition'] as GeoPoint?;
                    double hospitalLatitude = geoPoint?.latitude ?? 0.0;
                    double hospitalLongitude = geoPoint?.longitude ?? 0.0;

                    // Calculate distance between user and hospital
                    double distance = _calculateDistance(
                        _userPosition!.latitude,
                        _userPosition!.longitude,
                        hospitalLatitude,
                        hospitalLongitude
                    );

                    // Display blood bank details in ListTile with distance
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        tileColor: Colors.white, // Set ListTile background color to white
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.local_hospital, color: Colors.white),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4.0),
                            Text(
                              location,
                              style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Distance: ${distance.toStringAsFixed(2)} km',
                              style: TextStyle(color: Colors.grey[500], fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
