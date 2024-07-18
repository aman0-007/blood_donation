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
  TimeOfDay? _startTime;
  DateTime? _selectedDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  String _selectedAddress = 'Select Location';
  Position? _currentPosition;
  final Authentication _authentication = Authentication();


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
    String startTime = _startTime != null ? _startTime!.format(context) : '';
    String date = _selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : '';

    // Validate all fields before proceeding
    if (name.isNotEmpty && email.isNotEmpty && contact.isNotEmpty && _currentPosition != null && _selectedAddress.isNotEmpty) {
      try {
        // Call Firebase function to save session details
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
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.redAccent),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NAME'),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 10.0),
              Text('EMAIL AND CONTACT'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  hintText: 'Enter your contact number',
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOCATION'),
                        TextField(
                          // Display location fetched from previous method
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: _selectedAddress,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LANDMARK'),
                        TextField(
                          controller: _landmarkController,
                          decoration: InputDecoration(
                            hintText: 'Enter landmark',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('START TIME'),
                        ElevatedButton(
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Text(_startTime != null ? _startTime!.format(context) : 'Select Time'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DATE'),
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Select Date'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _startDonationSession();
                  },
                  child: Text('Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
