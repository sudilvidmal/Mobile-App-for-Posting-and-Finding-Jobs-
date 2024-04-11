import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobee/components/AddJobForm.dart';
import 'package:jobee/components/jobcontainer.dart';
import 'package:jobee/services/auth/auth_service.dart';
import '../pages/colors.dart' as color;

class Job_Page extends StatefulWidget {
  const Job_Page({Key? key});

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
        });
      }
    }
  }

  List<String> fieldList = ['All', 'IT', 'Graphic Design', 'Health'];
  String? selectedItem = 'All'; // Initial selected item

  void redirectForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddJobForm(
          uemail: email,
          uname: username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference getJobList =
        FirebaseFirestore.instance.collection('job_list');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Jobs",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: color.AppColor.homePageTitle,
                          ),
                          children: [
                            TextSpan(text: "Your "),
                            TextSpan(
                              text: "Active ",
                              style: TextStyle(
                                  color: color.AppColor
                                      .gradientSecond // Change to your desired color
                                  ),
                            ),
                            TextSpan(text: "Tasks!"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Edit and delete jobs",
                          style: TextStyle(
                              fontSize: 13,
                              color: color.AppColor.homePageTitle,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: fieldList.map((item) {
                                      return ListTile(
                                        leading: Icon(
                                          Icons.category,
                                          color: color.AppColor.gradientSecond,
                                        ),
                                        title: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: color.AppColor.homePageTitle,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedItem = item;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Container(
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
                            ), // Adjust the color and opacity as needed
                          ],
                        ),
                        child: Icon(
                          Icons.category,
                          color: color.AppColor.gradientSecond,
                          // Adjust the icon properties as needed
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            StreamBuilder<QuerySnapshot>(
              stream: selectedItem == 'All'
                  ? getJobList.where('user_email', isEqualTo: email).snapshots()
                  : getJobList
                      .where('Category', isEqualTo: selectedItem)
                      .where('user_email', isEqualTo: email)
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
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: getJobListDocs.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data = getJobListDocs[index]
                            .data()
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
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: FloatingActionButton(
          tooltip: 'Add',
          onPressed: redirectForm,
          backgroundColor: color.AppColor.gradientSecond,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
