import 'package:flutter/material.dart';

class bloodInfo extends StatefulWidget {
  const bloodInfo({super.key});

  @override
  State<bloodInfo> createState() => _bloodInfoState();
}

class _bloodInfoState extends State<bloodInfo> {

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/ap.png',
                        width: 50, // Adjust width and height for better fitting
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'A+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('A Positive (A+)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('A antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Anti-B antibodies in plasma.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to A+ and AB+ recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from A+, A-, O+, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Common in European and Asian populations.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close', style: TextStyle(color: Colors.redAccent)), // Close button with red accent color
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'A-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('A Negative (A-)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('A antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Anti-B antibodies in plasma.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to A+/-, AB+/- recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from A-, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Less common compared to A+.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'B+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('B Positive (B+)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('B antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Anti-A antibodies in plasma.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to B+ and AB+ recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from B+, B-, O+, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('More common in Asian populations.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'B-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text(' Negative (B-)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('B antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Anti-A antibodies in plasma.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to B+/-, AB+/- recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from B-, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Less common compared to B+.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'AB+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('AB Positive (AB+)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('A and B antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('No anti-A or anti-B antibodies in plasma (universal recipient).'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to AB+ recipients only.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from A+, A-, B+, B-, AB+, AB-, O+, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Relatively rare compared to A and B groups.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'AB-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('AB Negative (AB-)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('A and B antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('No anti-A or anti-B antibodies in plasma (universal recipient).'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to AB+/- recipients only.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from AB-, A-, B-, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Very rare.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'O+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('O Positive (O+)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('No A and B antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Anti-A or anti-B antibodies in plasma.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to A+, B+, AB+, O+ recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from O+, O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Most common blood group worldwide.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color with less opacity
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'O-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('O Negative (O+)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('No A and B antigens on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Antibodies:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Anti-A or anti-B antibodies in plasma.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to A+, A-, B+, B-, AB+, AB-, O+, O- recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive from O- donors.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Less common compared to O+.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Rh+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('Rh Positive (Rh+)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Rh antigen present on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to Rh+ recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive Rh+ or Rh- blood.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('About 85% of the population is Rh+.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:7),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Circular shape with radius 10
                  color: Colors.white, // Background color
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // Ensure the image container has a white background
                        child: Image.asset(
                          'assets/am.png',
                          width: 50, // Adjust width and height for better fitting
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Rh-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white, // Set background color of the AlertDialog
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent, width: 1), // Set border color and width
                        ),
                        title: Column(
                          children: [
                            Text('Rh Negative (Rh-)', style: TextStyle(color: Colors.redAccent)), // Title with red accent color
                            Divider(
                              color: Colors.redAccent, // Divider color
                              thickness: 2, // Divider thickness
                            ),
                          ],
                        ),
                        content: Container(
                          width: double.maxFinite, // Make the container fill the AlertDialog
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Antigens:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('No Rh antigen present on red blood cells.'),
                              SizedBox(height: 8),
                              Text(
                                'Compatibility:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can donate to Rh+ or Rh- recipients.'),
                              SizedBox(height: 8),
                              Text(
                                'Receiving:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Can receive Rh- blood only.'),
                              SizedBox(height: 8),
                              Text(
                                'Population Distribution:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('About 15% of the population is Rh-.'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height:17),

          ],
        ),
      ),
    );
  }
}
