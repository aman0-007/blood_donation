import 'dart:math';
import 'package:blood_donor/blinkingdot.dart';
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
  Position _userPosition = Position(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
    altitude: 0.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0, altitudeAccuracy: 0.0, headingAccuracy: 0.0
  );

  late Future<List<Map<String, dynamic>>> _sessionsFuture;
  Set<String> _appliedSessions = Set<String>(); // To track applied sessions

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

      // Step 1: Fetch all hospitals
      final hospitalsSnapshot = await firestore.collection('hospital').get();

      List<Map<String, dynamic>> allSessions = [];

      // Fetch user donations
      final userDoc = firestore.collection('users').doc(currentUser.uid);
      final userSnap = await userDoc.get();
      final userData = userSnap.data();
      Map<String, dynamic> userDonations = userData != null && userData.containsKey('donations') ? userData['donations'] : {};

      // Step 2: Fetch sessions from each hospital
      for (var hospitalDoc in hospitalsSnapshot.docs) {
        final hospitalId = hospitalDoc.id;

        // Get sessions for this hospital
        final sessionsSnapshot = await firestore
            .collection('hospital')
            .doc(hospitalId)
            .collection('sessions')
            .where('status', isEqualTo: 'on') // Filter sessions with status 'on'
            .get();

        // Map sessions data
        final List<Future<Map<String, dynamic>>> sessionFutures = sessionsSnapshot.docs.map((doc) async {
          final data = doc.data();

          final geoPoint = data['currentPosition'] as GeoPoint;
          final sessionName = data['name'];
          final sessionKey = '${hospitalId}_${sessionName}';
          bool isApplied = false;
          String operation = 'apply'; // Default to apply

          // Check if session is applied
          if (userDonations.containsKey(sessionKey) && (userDonations[sessionKey]['donationStatus'] == 'pending' || userDonations[sessionKey]['donationStatus'] == 'donated'  )) {
            isApplied = true;
            operation = 'applied';
          }
          //
          // if (userDonations.containsKey(sessionKey) && userDonations[sessionKey]['donationStatus'] == 'donated' ) {
          //   isApplied = true;
          //   operation = 'applied';
          // }

          return {
            'name': sessionName,
            'selectedAddress': data['selectedAddress'],
            'startTime': (data['startTime'] as Timestamp).toDate(),
            'date': (data['date'] as Timestamp).toDate(),
            'landmark': data['landmark'],
            'currentPosition': geoPoint,
            'hosId': hospitalId, // Ensure this field exists in the document
            'isApplied': isApplied,
            'operation': operation,
          };
        }).toList();

        // Wait for all session futures to complete
        final sessions = await Future.wait(sessionFutures);

        // Add to allSessions list
        allSessions.addAll(sessions);
      }

      return allSessions;
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

  String _getSessionStatus(DateTime startTime, DateTime date) {
    final now = DateTime.now();

    // Check if the current date is the same as or after the session date
    bool isSameOrAfterDate = now.isAfter(DateTime(date.year, date.month, date.day)) ||
        (now.year == date.year && now.month == date.month && now.day == date.day);

    // Check if the current time is after the session start time
    bool isAfterStartTime = now.isAfter(startTime);

    if (isSameOrAfterDate && isAfterStartTime) {
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

      // Fetch current user details from the 'users' collection
      final userDoc = await firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      if (userData == null) {
        throw Exception('User data not found');
      }

      // Fetch hospital details from the 'hospital' collection
      final hospitalDoc = await firestore.collection('hospital').doc(session['hosId']).get();
      final hospitalData = hospitalDoc.data();
      if (hospitalData == null) {
        throw Exception('Hospital data not found');
      }

      // Save donation data in the 'hospital' collection
      await firestore
          .collection('hospital')
          .doc(session['hosId'])
          .collection('sessions')
          .doc(session['name'])
          .set({
        'donors': {
          currentUser.uid: {
            'status': 'pending', // Add donation status
            'dob': userData['dob'],
            'email': userData['email'],
            'gender': userData['gender'],
            'name': userData['name'],
            'phone': userData['phone'],
            'userId': currentUser.uid,
            'bloodGroup': userData['BloodGroup'],
          },
        },
      }, SetOptions(merge: true));

      // Save donation data in the 'users' collection
      await firestore.collection('users').doc(currentUser.uid).update({
        'donations.${session['hosId']}_${session['name']}': {
          'hosId': session['hosId'],
          'hospitalName': hospitalData['name'],
          'hospitalEmail': hospitalData['email'],
          'donationStatus': 'pending',
          'operation': 'applied',
        },
      });

      // Add the session to the applied sessions set
      setState(() {
        _appliedSessions.add(session['name']);
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
        backgroundColor: Colors.white, // Set the dialog body color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        title: Text(
          'Donate at this Camp',
          style: TextStyle(
            color: Colors.black, // Title color
          ),
        ),
        content: Text(
          'Do you want to donate at this camp?',
          style: TextStyle(
            color: Colors.black, // Content color
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'No',
              style: TextStyle(
                color: Colors.red, // No button text color
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _saveDonationData(session);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red color button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded button corners
              ),
            ),
            child: Text('Yes'),
          ),
        ],
      ),
    );
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
                  return _buildSessionCard(session);
                },
              );

            }
          },
        ),
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final sessionPosition = session['currentPosition'] as GeoPoint;
    final distance = _userPosition != null
        ? _calculateDistance(
      _userPosition.latitude,
      _userPosition.longitude,
      sessionPosition.latitude,
      sessionPosition.longitude,
    )
        : 0;
    final status = _getSessionStatus(session['startTime'],session['date']);
    final isApplied = session['isApplied'];
    final operation = session['operation'];

    return GestureDetector(
      onTap: isApplied
          ? null // Do nothing if already applied
          : () => _showDonationDialog(session),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 4), // Change shadow position for better effect
            ),
          ],
        ),
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    session['name'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (status == 'Live')
                      BlinkingDot(size: 10.0)
                    else
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    SizedBox(width: 6.0),
                    if (status == 'Live')
                      BlinkingText(
                        text: status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    else
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Address: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: session['selectedAddress'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Landmark: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: session['landmark'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Date: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat.yMMMd().format(session['date']),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Start Time: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat.jm().format(session['startTime']),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Distance: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${distance.toStringAsFixed(2)} km',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: operation == 'applied'
                  ? null // Applied, so no onPressed function
                  : () => _showDonationDialog(session),
              style: ElevatedButton.styleFrom(
                backgroundColor: operation == 'applied'
                    ? Colors.grey
                    : Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                operation == 'applied' ? 'Applied' : 'Apply',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

}