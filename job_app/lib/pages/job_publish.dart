import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobee/components/AddJobForm.dart';
import 'package:jobee/components/jobcontainer.dart';
import 'package:jobee/services/auth/auth_service.dart';





class Job_Page extends StatefulWidget {
  const Job_Page({super.key});



  @override
  State<Job_Page> createState() => _JobPage_State();
}

class _JobPage_State extends State<Job_Page> {
  late String username = '';
  late String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final userData = await AuthService().getUserData(user.uid);
      if (userData != null) {
        setState(() {
          username = userData['username'];
          email = userData['email'];
          // Optionally, you can also retrieve the profile image URL here
          // profileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }




  List<String> fieldList = ['All','IT', 'Graphic Design', 'Health'];
  String? selectedItem = 'All'; // Initial selected item

  void redirectForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddJobForm(uemail: email, uname: username,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference getJobList =
        FirebaseFirestore.instance.collection('job_list');

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Page'),
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Username:"+username),
          Text("Email"+email),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedItem,
            items: fieldList.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 24),
                ),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                selectedItem = item; // Update selected item
              });
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedItem == 'All' ?getJobList.where('user_email',isEqualTo: email).snapshots():
              getJobList.where('Category',isEqualTo: selectedItem).where('user_email',isEqualTo: email)
              .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                // Extracting documents from QuerySnapshot
                final List<QueryDocumentSnapshot> getJobListDocs =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: getJobListDocs.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data =
                        getJobListDocs[index].data()
                            as Map<String, dynamic>; // Extract data from document
                    var docid = getJobListDocs[index].id;
                    return MyJobContainer(
                      title: data['title'].toString(),
                      name: Text(data['name'].toString()),
                      id: docid.toString(),
                      uname: username,
                      uemail: email,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        onPressed: redirectForm,
        child: Icon(Icons.add),
      ),
    );
  }
}

