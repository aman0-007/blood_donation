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
  late Position _userPosition;

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
    if (_userPosition == null) {
      // If _userPosition is null, display a loading indicator or handle the absence of position data
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey.withOpacity(0.7)),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ),
              ],
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

                // Access all documents in the subcollection
                var bloodbanks = snapshot.data!.docs;

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
                    double distance = _calculateDistance(_userPosition.latitude, _userPosition.longitude, hospitalLatitude, hospitalLongitude);

                    // Display blood bank details in ListTile with distance
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[250],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.local_hospital, color: Colors.white),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              'Distance: ${distance.toStringAsFixed(2)} km', // Display distance here
                              style: TextStyle(color: Colors.grey[700]),
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
