import 'package:flutter/material.dart';

class Hospitalcamps extends StatefulWidget {
  const Hospitalcamps({Key? key}) : super(key: key);

  @override
  State<Hospitalcamps> createState() => _HospitalcampsState();
}

class _HospitalcampsState extends State<Hospitalcamps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set page color as white
      appBar: AppBar(
        title: Text("Hospital Camps"), // App bar title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent, width: 2),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "Start Session",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent, width: 2),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "Live Session",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
