import 'package:blood_donor/activesessions.dart';
import 'package:blood_donor/authentication.dart';
import 'package:blood_donor/bloodbanks.dart';
import 'package:blood_donor/bloodinfo.dart';
import 'package:blood_donor/checkeligibility.dart';
import 'package:blood_donor/getinfo.dart';
import 'package:blood_donor/hospitallist.dart';
import 'package:blood_donor/nearbydonors.dart';
import 'package:blood_donor/notification.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> images = [
    'assets/imageforslider2.png',
    'assets/imgforsliderview.png',
  ];

  final List<String> texts = [
    '"The measure of life is not its DURATION but its DONATION"',
    '"A bottle of blood saved my life.\nWas it yours?"',
  ];



  late Future<String> _eligibilityStatusFuture;

  @override
  void initState() {
    super.initState();
    _eligibilityStatusFuture = getUserEligibilityStatus();
  }

  Future<String> getUserEligibilityStatus() async {
    // Replace with your actual logic to get the user's eligibility status from Firestore
    final String userId = await Authentication().getCurrentUser()?.uid ?? '';
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['eligibilityToDonate'] ?? 'unknown';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Image.asset(
          "assets/blooddrop.png",
          width: 26,
          height: 26,
        ),
        title: const Text(
          "Blood Donor",
          style: TextStyle(
            color: Color(0xFF7E0202),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationPage()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                "assets/nonotification.png",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Container(
              height: 200, // Adjusted height
              decoration: BoxDecoration(
                color: Color(0xFFF5EFED), // Background color of the container
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: CarouselSlider.builder(
                itemCount: images.length,
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  onPageChanged: (index, _) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (BuildContext context, int index, _) {
                  // Text Style for each page
                  List<TextStyle> textStyles = [
                    const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  ];
                  return Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.contain,
                              height: 150,
                              width: 80,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.transparent, // Text background color with opacity
                            child: Text(
                              texts[index],
                              style: textStyles[index % textStyles.length],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.yellowAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FutureBuilder<String>(
                        future: _eligibilityStatusFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error fetching data'));
                          } else if (snapshot.hasData) {
                            String status = snapshot.data!;
                            if (status == 'eligible') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                      child: const Text(
                                        "You are eligible to donate blood",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              );
                            } else if (status == 'notEligible') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                      child: const Text(
                                        "Not eligible to donate blood",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Check your eligibility to Donate",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Checkeligibility(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Center(child: Text('No data available'));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NearbyDonors(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 45, bottom: 45, left: 20, right: 40),
                              child: Image.asset(
                                "assets/blooddonationlocation.png",
                                width: 70,
                                height: 70,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              "Nearby donors",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 30, right: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Activesessions()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(10), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 2), // Offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/blooddonationcamp.png"),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "Donation Camps",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Bloodbanks()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(10), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 2), // Offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/blood-bank.png"),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "Blood Banks",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Hospitallist()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(10), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 2), // Offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/bloodhospital.png"),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "Hospital",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => bloodInfo()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(10), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 2), // Offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/blood-type.png"),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "Blood Groups",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Getinfo()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(10), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 2), // Offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/bloodinfo.png"),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "Get Info",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<String> getUserEligibilityStatus() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return 'pending'; // Handle user not signed in
  }

  final DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  if (userDoc.exists) {
    final eligibilityStatus = userDoc.get('eligibilityToDonate') as String;
    return eligibilityStatus;
  } else {
    return 'pending'; // Default to pending if no document is found
  }
  }