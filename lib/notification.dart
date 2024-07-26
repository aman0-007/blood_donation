import 'package:blood_donor/blinkingdot.dart';
import 'package:blood_donor/bottomnavigationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

class ReceivedRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Received Requests'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests found.'));
          }

          final notifications = snapshot.data!.docs;

          // Print main collection documents
          print('Number of notifications: ${notifications.length}');
          for (var doc in notifications) {
            print('Notification Document ID: ${doc.id}');
            print('Notification Document Data: ${doc.data()}');

            // Fetch and print details from subcollection
            FirebaseFirestore.instance
                .collection('notifications')
                .doc(doc.id)
                .collection('notifications')
                .snapshots()
                .listen((subSnapshot) {
              if (subSnapshot.docs.isEmpty) {
                print('No details found for notification ID: ${doc.id}');
              } else {
                final details = subSnapshot.docs;
                print('Number of details for notification ID ${doc.id}: ${details.length}');
                for (var detailDoc in details) {
                  print('Detail Document ID: ${detailDoc.id}');
                  print('Detail Document Data: ${detailDoc.data()}');
                }
              }
            });

            // To avoid UI blocking, you may want to use a future that completes in this builder.
          }

          // Returning an empty container as we are only interested in console output
          return Container();
        },
      ),
    );
  }
}

class MyRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user ID from Firebase Auth
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
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
            .doc(userId)
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

          // List of documents
          final documents = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                var accepted = data['accepted'] ?? 'No'; // Get request status

                // Determine the status text and icon
                String statusText;
                Widget statusIcon;
                if (accepted == 'No') {
                  statusText = 'Request Pending';
                  statusIcon = Icon(Icons.cancel, color: Colors.grey);
                } else {
                  statusText = 'Request Accepted';
                  statusIcon = Icon(Icons.person, color: Colors.grey);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
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
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender: ${data['gender'] ?? 'N/A'}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Patient Name: ${data['patientName'] ?? 'N/A'}",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Number of Units: ${data['numberOfUnits'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if (accepted == 'No')
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

                            if (accepted == 'No')
                              BlinkingText(
                                text: statusText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              )
                            else
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            SizedBox(width: 16),
                            statusIcon,
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
}