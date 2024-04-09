import 'package:flutter/material.dart';
import 'package:job_app/components/textfield.dart';
import 'package:job_app/pages/database_conn.dart';


class UpdateJobForm extends StatefulWidget {
  const UpdateJobForm ({super.key, required this.docid});

 final docid;

  @override
  State<UpdateJobForm > createState() => _UpdateJobFormState();


}

class _UpdateJobFormState extends State<UpdateJobForm > {

  late TextEditingController txtupdatenamecontroller;
  late TextEditingController txtupdatetitlecontroller;
   late TextEditingController txtdesccontroller ;

    List<String> fieldList = ['IT','Graphic Design','Health'];
 String ? SelectedItem = 'IT';


  @override
  void initState() {
    super.initState();
    txtupdatenamecontroller= TextEditingController();
    txtupdatetitlecontroller = TextEditingController();
    txtdesccontroller = TextEditingController();
  }

  @override
  void dispose() {
    txtupdatenamecontroller.dispose();
    txtupdatetitlecontroller.dispose();
    txtdesccontroller.dispose();
    super.dispose();
  }


  updateValues(){
    DatabaseConn dbc = new DatabaseConn();
   setState(() { // Update SelectedItem within setState
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Job"),),
      body: Column(
        children: [
           SizedBox(height: 20),
          DropdownButton<String>( value: SelectedItem,items: fieldList.map((item) => DropdownMenuItem(value: item,child: Text(item,style: TextStyle(fontSize: 24)))).toList(), 
          onChanged: (item) => setState(() => SelectedItem = item
          
          )
          ),
          
          MyTextField(
            hinttext: 'Name',
            maxline: null,
            obsectext: false,
            txtcontroller: txtupdatenamecontroller,
          ),
          SizedBox(height: 20),
          MyTextField(
            hinttext: 'Title',
            maxline: null,
            obsectext: false,
            txtcontroller: txtupdatetitlecontroller,
          ),
          MyTextField(
            hinttext: 'Description',
            maxline: 8,
            obsectext: false,
            txtcontroller: txtdesccontroller,
          ),
          ElevatedButton(
            onPressed: updateValues,
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}