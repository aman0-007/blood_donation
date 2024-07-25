import 'package:blood_donor/googlemap/getlocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Requestspage extends StatefulWidget {
  const Requestspage({Key? key}) : super(key: key);

  @override
  _RequestspageState createState() => _RequestspageState();
}

class _RequestspageState extends State<Requestspage> {
  String selectedBloodGroup = '';
  int numberOfUnits = 1;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  Position? _currentPosition;
  String _selectedAddress = '';

  @override
  void dispose() {
    _dateController.dispose();
    _genderController.dispose();
    _patientNameController.dispose();
    _mobileController.dispose();
    _address1Controller.dispose();
    super.dispose();
  }

  void _saveDataToFirestore() async {
    // Get the current user ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Check if userId is null (though in your logic, you should ensure user is logged in before accessing this page)
    if (userId == null) {
      print('User is not authenticated.');
      return;
    }

    // Create a map with all the data to be saved
    Map<String, dynamic> data = {
      'date': _dateController.text,
      'gender': _genderController.text,
      'address': _address1Controller.text,
      'patientName': _patientNameController.text,
      'mobile': _mobileController.text,
      'currentPosition': _currentPosition != null ? {
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
      } : null,
      'selectedBloodGroup': selectedBloodGroup,
      'numberOfUnits': numberOfUnits,
      'userId': userId,
      'solved':'No',
      'accepted':'No'
    };

    try {

      // Save data to Firestore in the specified structure
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('notifications')
          .add(data);

      // Clear all the controller values
      _dateController.clear();
      _genderController.clear();
      _address1Controller.clear();
      _patientNameController.clear();
      _mobileController.clear();

      // Clear other variables if necessary
      _currentPosition = null;


      // Optionally, navigate to Home Page after successful submission
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      print('Error saving data: $e');
      // Handle error saving data
    }
  }


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
                    buildInputFieldWithIcon("Patient Name", Icons.person, _patientNameController),
                    SizedBox(height: 20),
                    buildInputLabel("Select Blood Group"),
                    SizedBox(height: 10),
                    buildBloodGroupSelector(),
                    SizedBox(height: 20),
                    buildInputLabel("Number of Units"),
                    SizedBox(height: 10),
                    buildUnitSlider(),
                    buildSelectedUnitsDisplay(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetLocation(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _currentPosition = Position(
                                latitude: result['position'].latitude,
                                longitude: result['position'].longitude,
                                accuracy: 0.0, // provide an appropriate accuracy value
                                altitude: 0.0,
                                heading: 0.0,
                                speed: 0.0,
                                speedAccuracy: 0.0,
                                timestamp: DateTime.now(),
                                altitudeAccuracy: 0.0,
                                headingAccuracy: 0.0,
                              );
                              _selectedAddress = result['selectedAddress'];
                              _address1Controller.text = result['selectedAddress'];
                            });
                          }
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Select Location'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          ),
                          minimumSize: WidgetStateProperty.all<Size>(
                            const Size(double.infinity, 0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    buildInputLabel("Enter Address"),
                    SizedBox(height: 6),
                    buildInputFieldWithIcon("Address", Icons.location_on, _address1Controller),
                    SizedBox(height: 20),
                    buildInputLabel("Enter Mobile Number"),
                    SizedBox(height: 10),
                    buildMobileFieldWithIcon("Mobile Number", Icons.phone, _mobileController),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildInputLabel("Gender"),
                              SizedBox(height: 10),
                              buildGenderDropdown(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildInputLabel("Date"),
                              SizedBox(height: 10),
                              buildDateField(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveDataToFirestore();
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

  Widget buildInputFieldWithIcon(String hintText, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
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
      inactiveColor: Colors.grey.withOpacity(0.3),
      onChanged: (double value) {
        setState(() {
          numberOfUnits = value.round();
        });
      },
      label: '$numberOfUnits unit${numberOfUnits != 1 ? 's' : ''}',
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

  Widget buildMobileFieldWithIcon(String hintText, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
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

  Widget buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: _dateController,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            hintStyle: TextStyle(color: Colors.grey.shade700),
            icon: Icon(Icons.calendar_today, color: Colors.black),
            border: InputBorder.none,
          ),
          readOnly: true,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());

            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((selectedDate) {
              if (selectedDate != null) {
                _dateController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
              }
            });
          },
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Gender',
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  border: InputBorder.none,
                ),
                value: _genderController.text.isNotEmpty ? _genderController.text : null,
                onChanged: (value) {
                  setState(() {
                    _genderController.text = value!;
                  });
                },
                items: ['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
