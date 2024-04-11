import 'package:flutter/material.dart';
import 'package:jobee/pages/Chat_page.dart';
import 'package:jobee/pages/job_page.dart';
import 'package:jobee/services/auth/auth_service.dart';
import '../pages/colors.dart' as color;

void main() {
  runApp(MaterialApp(
    home: JobDetailsScreen(
      jobTitle: '',
      jobName: '',
      jobDescription: '',
      jobPosterEmail: '', // Pass the job poster's email to JobDetailsScreen
    ),
  ));
}

class JobDetailsScreen extends StatelessWidget {
  final String jobTitle;
  final String jobName;
  final String jobDescription;
  final String jobPosterEmail; // Add jobPosterEmail parameter

  JobDetailsScreen({
    required this.jobTitle,
    required this.jobName,
    required this.jobDescription,
    required this.jobPosterEmail, // Update constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Colors.grey,
        title: Text(
          'Job Details',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => JobPage(),
              ),
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Text(
                  'Title: $jobTitle',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.gradientFirst),
                ),
                SizedBox(height: 10.0),
                Text('Provider: $jobName',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10.0),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Text(
                    jobDescription,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 18,
                        color: color.AppColor.homePageTitle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String senderID = AuthService().getCurrentUser()!.uid;
                      String receiverEmail = jobPosterEmail;
                      AuthService()
                          .getUserByEmail(receiverEmail)
                          .then((receiverUser) {
                        if (receiverUser != null) {
                          String receiverID = receiverUser['uid'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverUsername: receiverUser['username'],
                                receiverID: receiverID,
                                senderID: senderID,
                                chatHistory: [],
                              ),
                            ),
                          );
                        } else {
                          // Handle case when the receiver user is not found
                          // For example, display an error message or take appropriate action
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.AppColor.gradientSecond,
                    ),
                    child: Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
