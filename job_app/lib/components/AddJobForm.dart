import 'package:flutter/material.dart';
import 'package:jobee/components/textfield.dart';
import 'package:jobee/pages/database_conn.dart';
import '../pages/colors.dart' as color;

class AddJobForm extends StatefulWidget {
  const AddJobForm({Key? key, required this.uemail, required this.uname});
  final uname;
  final uemail;

  @override
  State<AddJobForm> createState() => _AddJobFormState();
}

class _AddJobFormState extends State<AddJobForm> {
  List<String> fieldList = ['IT', 'Graphic Design', 'Health'];
  String? selectedItem = 'IT';

  final TextEditingController txtdesccontroller = TextEditingController();
  final TextEditingController txttitlecontroller = TextEditingController();
  final TextEditingController txtnamecontroller = TextEditingController();
  final DatabaseConn dbc = DatabaseConn();

  void passValues() {
    if (txtdesccontroller.text.isEmpty ||
        txttitlecontroller.text.isEmpty ||
        txtnamecontroller.text.isEmpty) {
      // Show a dialog if any of the fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all the fields."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // All fields are filled, proceed to insert
      dbc.InsertJobList(
        selectedItem,
        txtdesccontroller.text,
        txttitlecontroller.text,
        txtnamecontroller.text,
        widget.uname,
        widget.uemail,
      );
      Navigator.pop(context); // Close AddJobForm after submitting
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Job",
          style: TextStyle(
            fontSize: 20, // Adjust the font size as needed
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Selected Category: $selectedItem',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: color.AppColor.homePageTitle),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color:
                                color.AppColor.homePageTitle.withOpacity(0.2),
                          ),
                        ]), // Adjust the color and opacity as needed
                    child: IconButton(
                      icon: Icon(
                        Icons.category,
                        color: color.AppColor.gradientSecond,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200, // Adjust height as needed
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.category,
                                      color: color.AppColor.gradientSecond,
                                    ),
                                    title: Text('IT'),
                                    onTap: () {
                                      setState(() {
                                        selectedItem = 'IT';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.category,
                                      color: color.AppColor.gradientSecond,
                                    ),
                                    title: Text('Graphic Design'),
                                    onTap: () {
                                      setState(() {
                                        selectedItem = 'Graphic Design';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.category,
                                      color: color.AppColor.gradientSecond,
                                    ),
                                    title: Text('Health'),
                                    onTap: () {
                                      setState(() {
                                        selectedItem = 'Health';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: [
                  FormTextField(
                    hintText: 'Job Title',
                    obscureText: false,
                    maxLines: 1,
                    controller: txttitlecontroller,
                  ),
                  SizedBox(height: 20),
                  FormTextField(
                    hintText: 'Company/Your name',
                    obscureText: false,
                    maxLines: 1,
                    controller: txtnamecontroller,
                  ),
                  SizedBox(height: 20),
                  FormTextField(
                    hintText: 'Description',
                    obscureText: false,
                    maxLines: 7, // Increase the number of lines
                    controller: txtdesccontroller,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: passValues,
                    child: Text("Submit",
                        style: TextStyle(
                            color: color.AppColor.homePageBackground)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.AppColor
                          .gradientSecond, // Change the button color to blue
                      padding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24), // Increase padding
                      shape: RoundedRectangleBorder(
                        // Reduce the border radius
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
