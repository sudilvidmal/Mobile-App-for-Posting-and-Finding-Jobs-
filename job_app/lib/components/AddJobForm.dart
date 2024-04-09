import 'package:flutter/material.dart';
import 'package:job_app/components/textfield.dart';
import 'package:job_app/pages/database_conn.dart';

class AddJobForm extends StatefulWidget {
  const AddJobForm({super.key, required this.uemail,required this.uname});
final uname;
final uemail;
  @override
  State<AddJobForm> createState() => _AddJobFormState();
}

class _AddJobFormState extends State<AddJobForm> {

 List<String> fieldList = ['IT','Graphic Design','Health'];
 String ? SelectedItem = 'IT';


   final TextEditingController txtdesccontroller = TextEditingController() ;
   final TextEditingController txttitlecontroller = TextEditingController();
   final TextEditingController txtnamecontroller = TextEditingController();
    final DatabaseConn dbc = new DatabaseConn();





  void passValues() {
    dbc.InsertJobList(SelectedItem,txtdesccontroller.text, txttitlecontroller.text,txtnamecontroller.text,widget.uname,widget.uemail);
    
    Navigator.pop(context); // Close AddJobForm after submitting

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Job"),),
      body: Column(
        children: [
          SizedBox(height: 20),
          DropdownButton<String>( value: SelectedItem,items: fieldList.map((item) => DropdownMenuItem(value: item,child: Text(item,style: TextStyle(fontSize: 24)))).toList(), 
          onChanged: (item) => setState(() => SelectedItem = item
            
          )),
          SizedBox(height: 20),
          MyTextField(
            hinttext: 'Title',
            maxline: null,
            obsectext: false,
            txtcontroller: txttitlecontroller,
          ),
          
          SizedBox(height: 20),
          MyTextField(
            hinttext: 'Name',
            obsectext: false,
            maxline: null,
            
            txtcontroller: txtnamecontroller,
          ),
          SizedBox(height: 20),
          MyTextField(
            hinttext: 'Description',
            obsectext: false,
            maxline: 8,
            
            txtcontroller: txtdesccontroller,
          ),
          ElevatedButton(
            onPressed: passValues,
            child: Text("Submit"),
          ),
          
        ],
      ),
    );
  }
}
