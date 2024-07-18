import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Activesessions extends StatefulWidget {
  const Activesessions({super.key});

  @override
  State<Activesessions> createState() => _ActivesessionsState();
}

class _ActivesessionsState extends State<Activesessions> {
  late Position _userPosition;
  late Future<List<Map<String, dynamic>>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _sessionsFuture = _fetchSessions();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _userPosition = position;
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSessions() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final sessionsSnapshot = await firestore
          .collection('sessions')
          .doc(currentUser.uid)
          .collection('active_sessions')
          .get();

      return sessionsSnapshot.docs.map((doc) {
        final data = doc.data();
        final geoPoint = data['currentPosition'] as GeoPoint;
        return {
          'name': data['name'],
          'selectedAddress': data['selectedAddress'],
          'startTime': data['startTime'].toDate(),
          'date': data['date'].toDate(),
          'landmark': data['landmark'],
          'currentPosition': geoPoint,
        };
      }).toList();
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
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

  String _getSessionStatus(DateTime startTime) {
    final now = DateTime.now();
    if (now.isAfter(startTime)) {
      return 'Live';
    } else {
      return 'Inactive';
    }
  }

  Future<void> _saveDonationData(Map<String, dynamic> session) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final donorCollection = firestore.collection('donor');
      final docRef = donorCollection.doc(); // Create a new document reference

      await docRef.set({
        'userId': currentUser.uid,
        'sessionName': session['name'],
        'selectedAddress': session['selectedAddress'],
        'startTime': session['startTime'],
        'date': session['date'],
        'landmark': session['landmark'],
        'currentPosition': GeoPoint(
          session['currentPosition'].latitude,
          session['currentPosition'].longitude,
        ),
      });

      print('Donation data saved successfully');
    } catch (e) {
      print('Error saving donation data: $e');
    }
  }

  void _showDonationDialog(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Donate at this Camp'),
        content: Text('Do you want to donate at this camp?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _saveDonationData(session);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red color button
            ),
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Active Camps',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _sessionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching sessions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No active sessions found'));
            } else {
              final sessions = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  final sessionPosition = session['currentPosition'] as GeoPoint;
                  final distance = _userPosition != null
                      ? _calculateDistance(
                    _userPosition.latitude,
                    _userPosition.longitude,
                    sessionPosition.latitude,
                    sessionPosition.longitude,
                  )
                      : 0;
                  final status = _getSessionStatus(session['startTime']);

                  return GestureDetector(
                    onTap: () => _showDonationDialog(session),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              session['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: status == 'Live' ? Colors.red : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: status == 'Live' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ${session['selectedAddress']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Date: ${DateFormat('dd-MM-yyyy').format(session['date'])}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Start Time: ${DateFormat('HH:mm').format(session['startTime'])}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Landmark: ${session['landmark']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Distance: ${distance.toStringAsFixed(2)} km',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
