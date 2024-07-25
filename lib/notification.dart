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
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text("User not logged in."),
        ),
      );
    }

    return Scaffold(
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

          // List of documents from the main collection
          final documents = snapshot.data!.docs;

          // Filter out documents where the document ID matches the current user's ID
          final filteredDocuments = documents.where((doc) => doc.id != userId).toList();

          // If no documents match the filter
          if (filteredDocuments.isEmpty) {
            return Center(
              child: Text("No requests found."),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredDocuments.length,
              itemBuilder: (context, index) {
                // Fetch subcollection documents for each filtered document
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(filteredDocuments[index].id)
                      .collection('notifications')
                      .get(),
                  builder: (context, subSnapshot) {
                    if (subSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!subSnapshot.hasData || subSnapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("No subcollection requests found."),
                      );
                    }

                    // List of documents from the subcollection
                    final subDocuments = subSnapshot.data!.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subDocuments.map((subDoc) {
                        var data = subDoc.data() as Map<String, dynamic>;

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
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          );
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