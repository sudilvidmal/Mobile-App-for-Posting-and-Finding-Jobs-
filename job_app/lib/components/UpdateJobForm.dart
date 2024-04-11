import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobee/components/textfield.dart';
import '../pages/colors.dart' as color;
import 'package:jobee/pages/database_conn.dart';

class UpdateJobForm extends StatefulWidget {
  const UpdateJobForm({Key? key, required this.docid}) : super(key: key);

  final docid;

  @override
  State<UpdateJobForm> createState() => _UpdateJobFormState();
}

class _UpdateJobFormState extends State<UpdateJobForm> {
  late TextEditingController txtupdatenamecontroller;
  late TextEditingController txtupdatetitlecontroller;
  late TextEditingController txtdesccontroller;

  List<String> fieldList = ['IT', 'Graphic Design', 'Health'];
  String? SelectedItem = 'IT';

  @override
  void initState() {
    super.initState();
    txtupdatenamecontroller = TextEditingController();
    txtupdatetitlecontroller = TextEditingController();
    txtdesccontroller = TextEditingController();

    fetchExistingData();
  }

  @override
  void dispose() {
    txtupdatenamecontroller.dispose();
    txtupdatetitlecontroller.dispose();
    txtdesccontroller.dispose();
    super.dispose();
  }

  Future<void> fetchExistingData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('job_list')
          .doc(widget.docid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          var jobSnapshot = documentSnapshot;

          txtupdatenamecontroller.text = jobSnapshot['name'];
          txtupdatetitlecontroller.text = jobSnapshot['title'];
          txtdesccontroller.text = jobSnapshot['description'];
          SelectedItem = jobSnapshot['Category'];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void updateValues() {
    if (txtupdatenamecontroller.text.isEmpty ||
        txtupdatetitlecontroller.text.isEmpty ||
        txtdesccontroller.text.isEmpty) {
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
      DatabaseConn dbc = DatabaseConn();
      setState(() {
        // Update SelectedItem within setState
        dbc.updateJobList(
          txtupdatenamecontroller.text,
          txtdesccontroller.text,
          txtupdatetitlecontroller.text,
          widget.docid,
          SelectedItem,
        );
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Job",
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
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 0, bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Selected Category: $SelectedItem',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: color.AppColor.homePageTitle,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          color: color.AppColor.homePageTitle.withOpacity(0.2),
                        ),
                      ],
                    ),
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
                              height: 200,
                              child: Column(
                                children: fieldList.map((item) {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.category,
                                      color: color.AppColor.gradientSecond,
                                    ),
                                    title: Text(item),
                                    onTap: () {
                                      setState(() {
                                        SelectedItem = item;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              FormTextField(
                hintText: 'Job Title',
                obscureText: false,
                maxLines: 1,
                controller: txtupdatetitlecontroller,
              ),
              SizedBox(height: 20),
              FormTextField(
                hintText: 'Company/Your name',
                obscureText: false,
                maxLines: 1,
                controller: txtupdatenamecontroller,
              ),
              SizedBox(height: 20),
              FormTextField(
                hintText: 'Description',
                obscureText: false,
                maxLines: 7,
                controller: txtdesccontroller,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateValues,
                child: Text("Update",
                    style: TextStyle(color: color.AppColor.homePageBackground)),
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
      ),
    );
  }
}
