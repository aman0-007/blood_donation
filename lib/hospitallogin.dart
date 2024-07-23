import 'package:blood_donor/googlemap/getlocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood_donor/authentication.dart';
import 'package:blood_donor/loginscreen.dart';

class Hospitallogin extends StatefulWidget {
  const Hospitallogin({Key? key}) : super(key: key);

  @override
  State<Hospitallogin> createState() => _HospitalloginState();
}

class _HospitalloginState extends State<Hospitallogin> {
  final Authentication _authentication = Authentication();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();


  Position? _currentPosition;
  String _selectedAddress = '';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _validateEmail(String email) {
    RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com|ves\.ac\.in)$');
    return emailRegExp.hasMatch(email);
  }

  bool _validatePassword(String password) {
    RegExp passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*])(.{8,})$');
    return passwordRegExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Join Us!",
                    style: TextStyle(
                      color: Color(0xFF7E0202),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 40),
                  child: Text(
                    "Hospital Name",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, top: 20.0, right: 40),
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
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.redAccent), // Background color
                  foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white), // Text color
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  minimumSize: WidgetStateProperty.all<Size>(
                    const Size(double.infinity, 0), // full width available
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 30),
                  child: Text(
                    "Address ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _address1Controller,
              ),
            ),
            const SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 20),
                  child: Text(
                    "E-mail",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 30),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 30),
                  child: Text(
                    "Confirm password",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 70.0, right: 70, top: 35, bottom: 15),
                    child: ElevatedButton(
                      onPressed: () async {
                        String name = nameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;
                        if (_validateEmail(email) &&
                            _validatePassword(password) &&
                            password == confirmPassword &&
                            _currentPosition != null &&
                            _selectedAddress.isNotEmpty) {
                          try {
                            _authentication.registerHospitalWithEmailAndPassword(
                                context,
                                name,
                                email,
                                password,
                                _currentPosition!,
                                _selectedAddress);
                          } catch (e) {
                            print('Error: $e');
                          }
                        } else {
                          String errorMessage = 'Please correct the following:\n';
                          if (!_validateEmail(email)) {
                            errorMessage +=
                            '- Email should be a valid Gmail, Outlook, or VES domain address.\n';
                          }
                          if (!_validatePassword(password)) {
                            errorMessage +=
                            '- Password must contain at least 8 characters including at least one uppercase letter, one lowercase letter, one number, and one special character.\n';
                          }
                          if (_currentPosition == null || _selectedAddress.isEmpty) {
                            errorMessage +=
                            '- Please select a valid location from the map.\n';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "----------------------------------------------------------   OR   ----------------------------------------------------------",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?  ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xFF7E0202),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
