import 'package:blood_donor/googlemap/getlocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood_donor/authentication.dart';
import 'package:intl/intl.dart';

class Startsessionpage extends StatefulWidget {
  const Startsessionpage({super.key});

  @override
  State<Startsessionpage> createState() => _StartsessionpageState();
}

class _StartsessionpageState extends State<Startsessionpage> {
  final Authentication _authentication = Authentication();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();

  String _selectedAddress = '';
  TimeOfDay? _startTime;
  DateTime? _selectedDate;
  Position? _currentPosition;

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _startTime) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _startDonationSession() {
    String name = _nameController.text;
    String email = _emailController.text;
    String contact = _contactController.text;
    String landmark = _landmarkController.text;

    DateTime? startTime;
    if (_startTime != null) {
      TimeOfDay timeOfDay = _startTime!;
      DateTime now = DateTime.now();
      startTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    }

    DateTime? date = _selectedDate;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        contact.isNotEmpty &&
        _currentPosition != null &&
        _selectedAddress.isNotEmpty &&
        startTime != null &&
        date != null) {
      try {
        _authentication.startDonationSession(
          context,
          name,
          email,
          contact,
          _currentPosition!,
          _selectedAddress,
          landmark,
          startTime,
          date,
        );
      } catch (e) {
        print('Error starting session: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Session Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Name'),
              _buildTextField(
                controller: _nameController,
                hintText: 'Enter your name',
              ),
              SizedBox(height: 16.0),
              _buildSectionTitle('Email and Contact'),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _contactController,
                hintText: 'Enter your contact number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Location'),
                        _buildTextField(
                          controller: _address1Controller,
                          hintText: 'Enter address',
                          readOnly: true,
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton.icon(
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
                                  accuracy: 0.0,
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
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: const Icon(Icons.location_on),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: const Text('Select Location'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Landmark'),
                        _buildTextField(
                          controller: _landmarkController,
                          hintText: 'Enter landmark',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Start Time'),
                        ElevatedButton(
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              _startTime != null ? _startTime!.format(context) : 'Select Time',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Date'),
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              _selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Select Date',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _startDonationSession();
                  },
                  child: Text('Start Session', style: TextStyle(fontSize: 18.0)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
      ),
      readOnly: readOnly,
      keyboardType: keyboardType,
    );
  }
}
