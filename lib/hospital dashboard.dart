import 'package:blood_donor/Hospitalcamps.dart';
import 'package:blood_donor/Hospitalrecords.dart';
import 'package:blood_donor/authentication.dart';
import 'package:flutter/material.dart';

class Hospitaldashboard extends StatefulWidget {
  const Hospitaldashboard({super.key});

  @override
  State<Hospitaldashboard> createState() => _HospitaldashboardState();
}

class _HospitaldashboardState extends State<Hospitaldashboard> {
  final Authentication _auth = Authentication();

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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          children: [
            _buildDashboardItem(
              context,
              "Donation Camps",
              "assets/blooddonationcamp.png",
              Hospitalcamps(),
            ),
            _buildDashboardItem(
              context,
              "Records",
              "assets/blood-type.png",
              Hospitalrecords(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _auth.signOut(context); // Call sign-out function from Authentication class
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Button color
            foregroundColor: Colors.white,    // Text color
            minimumSize: Size(double.infinity, 50), // Increase button width and height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title, String imagePath, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
