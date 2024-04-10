import 'package:flutter/material.dart';
import 'package:job_app/components/textfield.dart';
import 'package:job_app/pages/database_conn.dart';
import 'package:job_app/pages/colorsjobpage.dart' as color;

class AppColor {
  static const Color gradientFirst = Color(0xFF00FF00); // Example color
  static const Color gradientSecond = Color(0xFF0000FF); // Example color
}

class AddJobForm extends StatefulWidget {
  const AddJobForm({Key? key, required this.uemail, required this.uname})
      : super(key: key);
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
    dbc.InsertJobList(
        selectedItem,
        txtdesccontroller.text,
        txttitlecontroller.text,
        txtnamecontroller.text,
        widget.uname,
        widget.uemail);
    Navigator.pop(context); // Close AddJobForm after submitting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Job"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: DropdownButton<String>(
                value: selectedItem,
                items: fieldList.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              hint: 'Title',
              controller: txttitlecontroller,
            ),
            SizedBox(height: 20),
            _buildTextField(
              hint: 'Name',
              controller: txtnamecontroller,
            ),
            SizedBox(height: 20),
            _buildTextField(
              hint: 'Description',
              controller: txtdesccontroller,
              maxLines: 8,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: passValues,
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white), // Change text color to white
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Change the button color to green
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    int? maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.AppColor.jobaddPageGradientFirst.withOpacity(0.8),
            color.AppColor.jobaddPageGradientSecond.withOpacity(1),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
