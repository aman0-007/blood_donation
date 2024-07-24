import 'package:flutter/material.dart';
import 'package:blood_donor/homepage.dart';
import 'package:blood_donor/bottomnavigationpage.dart';

class Requestspage extends StatefulWidget {
  const Requestspage({Key? key}) : super(key: key);

  @override
  _RequestspageState createState() => _RequestspageState();
}

class _RequestspageState extends State<Requestspage> {
  String selectedBloodGroup = '';
  int numberOfUnits = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Post a Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    buildInputLabel("Select Patient Name"),
                    SizedBox(height: 6),
                    buildInputFieldWithIcon("Patient Name", Icons.person),
                    SizedBox(height: 20),
                    buildInputLabel("Select Blood Group"),
                    SizedBox(height: 10),
                    buildBloodGroupSelector(),
                    SizedBox(height: 20),
                    buildInputLabel("Number of Units"),
                    SizedBox(height: 10),
                    buildUnitSlider(),
                    SizedBox(height: 10),
                    buildSelectedUnitsDisplay(),
                    SizedBox(height: 20),
                    buildInputLabel("Enter Mobile Number"),
                    SizedBox(height: 20),
                    buildMobileFieldWithIcon("Mobile Number", Icons.phone),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildInputField(String label, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          keyboardType: inputType,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget buildInputFieldWithIcon(String hintText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1), // Grey with less opacity
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade700,
            ),
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildBloodGroupSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildBloodGroupOption("A+"),
            buildBloodGroupOption("B+"),
            buildBloodGroupOption("O+"),
            buildBloodGroupOption("AB+"),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildBloodGroupOption("A-"),
            buildBloodGroupOption("B-"),
            buildBloodGroupOption("O-"),
            buildBloodGroupOption("AB-"),
          ],
        ),
      ],
    );
  }

  Widget buildBloodGroupOption(String bloodGroup) {
    bool isSelected = selectedBloodGroup == bloodGroup;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBloodGroup = bloodGroup;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : null,
          border: Border.all(color: isSelected ? Colors.redAccent : Colors.grey),
        ),
        child: Center(
          child: Text(
            bloodGroup,
            style: TextStyle(
              color: isSelected ? Colors.redAccent : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUnitSlider() {
    return Slider(
      value: numberOfUnits.toDouble(),
      min: 1,
      max: 7,
      divisions: 6,
      activeColor: Colors.redAccent,
      inactiveColor: Colors.grey.withOpacity(0.3), // Adjust opacity for a softer look
      onChanged: (double value) {
        setState(() {
          numberOfUnits = value.round();
        });
      },
      onChangeStart: (double value) {
        // Optional: Add any actions when slider interaction starts
      },
      onChangeEnd: (double value) {
        // Optional: Add any actions when slider interaction ends
      },
      label: '$numberOfUnits unit${numberOfUnits != 1 ? 's' : ''}', // Display current value label
      // Optional: Customize slider appearance
      // thumbColor: Colors.redAccent,
      // overlayColor: Colors.red.withAlpha(32),
      // activeTrackHeight: 8.0,
      // inactiveTrackHeight: 4.0,
    );
  }

  Widget buildSelectedUnitsDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Text(
        '$numberOfUnits unit${numberOfUnits > 1 ? 's' : ''} ',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildMobileFieldWithIcon(String hintText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          keyboardType: TextInputType.phone, // Use TextInputType.phone for number keypad
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade700,
            ),
            icon: Icon(
              Icons.phone, // Use Icons.phone for mobile number icon
              color: Colors.black,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

}

