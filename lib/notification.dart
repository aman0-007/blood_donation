import 'dart:math';

import 'package:blood_donor/blinkingdot.dart';
import 'package:blood_donor/bottomnavigationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13, top: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0, top: 16, right: 12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const Bottomnavigationpage()), // Make sure BottomNavigationPage is defined
                            );
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 22.0, top: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Notification",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 22.0, bottom: 11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "See received blood requests and request status",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.redAccent,
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              const Tab(text: "Received Requests"),
              const Tab(text: "My Requests"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ReceivedRequestsPage(),
                MyRequestsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedRequestsPage extends StatefulWidget {
  @override
  _ReceivedRequestsPageState createState() => _ReceivedRequestsPageState();
}

class _ReceivedRequestsPageState extends State<ReceivedRequestsPage> {
  Position _userPosition = Position(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
    altitude: 0.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );

  Future<void> _acceptRequest(Map<String, dynamic> data) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle case where user is not logged in
      return;
    }

    final patientName = data['patientName'] ?? '';
    final mobile = data['mobile'] ?? '';
    final selectedBloodGroup = data['selectedBloodGroup'] ?? '';

    // Fetch current user details from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) {
      // Handle case where user details are not found
      print('User details not found.');
      return;
    }

    final userData = userDoc.data() as Map<String, dynamic>;

    // User details to save
    final donorDetails = {
      'bloodGroup': userData['BloodGroup'] ?? '',
      'dob': userData['dob'] ?? '',
      'email': userData['email'] ?? '',
      'gender': userData['gender'] ?? '',
      'name': userData['name'] ?? '',
      'phone': userData['phone'] ?? '',
      'donorId': userId ?? '',
    };

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: data['userId'])
          .where('patientName', isEqualTo: patientName)
          .where('mobile', isEqualTo: mobile)
          .where('selectedBloodGroup', isEqualTo: selectedBloodGroup)
          .get();

      for (var doc in querySnapshot.docs) {
        var docRef = doc.reference;
        var docData = doc.data() as Map<String, dynamic>;

        // Retrieve the existing donors map or create a new one if it doesn't exist
        Map<String, dynamic> donors = docData['donors'] != null
            ? Map<String, dynamic>.from(docData['donors'])
            : {};

        // Add or update the donor details in the map
        donors[userId] = donorDetails;

        // Update the document with the new donors map
        await docRef.update({
          'accepted': 'Yes',
          'donors': donors,
        });
      }
    } catch (e) {
      print(e);
      // Handle errors (e.g., show a message to the user)
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      print(e);
      // Handle location permission denied
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

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Received Requests"),
        ),
        body: Center(
          child: Text("User not logged in."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No requests found."),
            );
          }

          final documents = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['userId'] != userId; // Exclude documents with matching userId
          }).toList();

          if (documents.isEmpty) {
            return Center(
              child: Text("No requests found."),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;

                // Extracting location data from the document
                double currentLatitude = data['currentPosition']?['latitude']?.toDouble() ?? 0.0;
                double currentLongitude = data['currentPosition']?['longitude']?.toDouble() ?? 0.0;
                double distance = _calculateDistance(
                  _userPosition.latitude,
                  _userPosition.longitude,
                  currentLatitude,
                  currentLongitude,
                );

                // Check if current user ID is in the 'donors' map
                Map<String, dynamic>? donors = data['donors'] != null ? Map<String, dynamic>.from(data['donors']) : {};
                bool isAccepted = donors.containsKey(FirebaseAuth.instance.currentUser?.uid);

                String statusText = isAccepted ? 'Request Accepted' : 'Request Pending';
                Widget statusIcon = isAccepted
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.cancel, color: Colors.grey);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['patientName'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${data['gender'] ?? 'N/A'}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${data['selectedBloodGroup'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${data['address'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Number of Units: ${data['numberOfUnits'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Distance: ${distance.toStringAsFixed(2)} km",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Time limit: ",
                              style: TextStyle(fontSize: 16),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${data['date'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (!isAccepted) ...[
                              InkWell(
                                onTap: () {
                                  // Implement share functionality here
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.share, color: Colors.blue),
                                    SizedBox(width: 6.0),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: () {
                                  _acceptRequest(data);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.grey[200]),
                                    SizedBox(width: 6.0),
                                    Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              InkWell(
                                onTap: () {
                                  _showDonorInfo(
                                    context,
                                    data['userId'] ?? '',
                                    data['patientName'] ?? '',
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.grey[700]),
                                    SizedBox(width: 6.0),
                                    Text(
                                      'Info',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'Accepted',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );

        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchRequestDetails(String userId, String patientName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('patientName', isEqualTo: patientName)
          .limit(1) // Assuming there's only one matching document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching request details: $e");
    }
    return null;
  }

  void _showDonorInfo(BuildContext context, String userId, String patientName) async {
    final requestDetails = await _fetchRequestDetails(userId, patientName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            requestDetails != null ? "Request Information" : "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: requestDetails != null ? Colors.black : Colors.red,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite, // Makes the dialog use full width
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (requestDetails != null) ...[
                    _buildDetailRow("Name", requestDetails['patientName']),
                    _buildDetailRow("Phone", requestDetails['mobile']),
                    _buildDetailRow("Address", requestDetails['address']),
                  ] else ...[
                    Text(
                      "Could not fetch request details.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              softWrap: true, // Ensure text wraps properly
            ),
          ),
        ],
      ),
    );
  }

}

class MyRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("My Requests"),
        ),
        body: Center(
          child: Text("User not logged in."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No requests found."),
            );
          }

          final documents = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['userId'] == userId;
          }).toList();

          if (documents.isEmpty) {
            return Center(
              child: Text("No requests found."),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                var accepted = data['accepted'] ?? 'No';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['patientName'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${data['gender'] ?? 'N/A'}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${data['selectedBloodGroup'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${data['address'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Number of Units: ${data['numberOfUnits'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Time limit: ",
                              style: TextStyle(fontSize: 16),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${data['date'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (accepted == 'No') ...[
                              Row(
                                children: [
                                  BlinkingDot(size: 10.0),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'Requested Pending',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: () {
                                  _cancelRequest(
                                    context,
                                    data['userId'],
                                    data['patientName'],
                                    data['mobile'],
                                    data['selectedBloodGroup'],
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.cancel, color: Colors.red),
                                  ],
                                ),
                              ),
                            ] else ...[
                              Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'Request Accepted',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: () {
                                  final donors = data['donors'] as Map<String, dynamic>?;

                                  if (donors != null && donors.isNotEmpty) {
                                    _showDonorInfo(context, donors, data);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text("No donors found."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Close"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.black54),
                                    SizedBox(width: 8),
                                    Text(
                                      'Donor Info',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDonorInfo(BuildContext context, Map<String, dynamic> donors, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Donor Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: donors.entries.map((entry) {
                final donorDetails = entry.value as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Name", donorDetails['name']),
                      _buildDetailRow("Phone", donorDetails['phone']),
                      _buildDetailRow("Email", donorDetails['email']),
                      _buildDetailRow("Gender", donorDetails['gender']),
                      _buildDetailRow("DOB", donorDetails['dob']),
                      _buildDetailRow("Blood Group", donorDetails['bloodGroup']),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          final donorId = donorDetails['donorId'];
                          if (donorId != null && donorId.isNotEmpty && data != null) {
                            _handleBloodTaken(context, donorId, data);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Donor ID or data is missing."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text("Blood Taken"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(thickness: 1, color: Colors.grey[300]),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _handleBloodTaken(BuildContext context, String? donorId, Map<String, dynamic>? data) {
    if (donorId == null || donorId.isEmpty || data == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Invalid data provided. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Blood taken from this user successfully. Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                try {
                  await _updateBloodStatus(donorId, FirebaseAuth.instance.currentUser?.uid ?? '', data);

                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Blood taken from this user has been successfully updated."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  // Show error dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("An error occurred: $e"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateBloodStatus(String donorId, String currentUserId, Map<String, dynamic> data) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final notificationsCollection = FirebaseFirestore.instance.collection('notifications');

      final userDocRef = usersCollection.doc(donorId);

      // Update user document
      await userDocRef.update({
        'lifeSaved': FieldValue.increment(1),
        'donations.${currentUserId}_${data['patientName']}_${data['mobile']}': {
          'donationStatus': 'donated',
          'accepterId': currentUserId,
          'patientName': data['patientName'],
          'mobile': data['mobile'],
          'selectedBloodGroup': data['selectedBloodGroup'],
        },
      });

      // Update the notification document
      final notificationsSnapshot = await notificationsCollection
          .where('userId', isEqualTo: currentUserId)
          .where('patientName', isEqualTo: data['patientName'])
          .where('mobile', isEqualTo: data['mobile'])
          .where('selectedBloodGroup', isEqualTo: data['selectedBloodGroup'])
          .get();

      for (final doc in notificationsSnapshot.docs) {
        await doc.reference.update({'solved': 'Yes'});
        await doc.reference.update({'solvedBy': donorId});
      }

      print("Blood status updated successfully.");
    } catch (e) {
      print("Error updating blood status: $e");
      rethrow; // To handle in the calling method
    }
  }

  Future<void> _cancelRequest(BuildContext context, String? userId, String? patientName, String? mobile, String? selectedBloodGroup) async {
    if (userId == null || patientName == null || mobile == null || selectedBloodGroup == null) {
      return;
    }

    final collection = FirebaseFirestore.instance.collection('notifications');
    final snapshot = await collection.get();

    for (final doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['userId'] == userId &&
          data['patientName'] == patientName &&
          data['mobile'] == mobile &&
          data['selectedBloodGroup'] == selectedBloodGroup) {
        await doc.reference.delete();
        break; // Exit after deleting the first matching document
      }
    }
  }
}
