import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:jobee/pages/Setting_page.dart';
import 'package:jobee/pages/UserProfile_page.dart';

import 'package:jobee/pages/job_page.dart';

import '../services/auth/auth_service.dart';
import 'colors.dart' as color;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  late String username = '';
  late String email = '';
  late String profileImageUrl = '';

  final List<String> images = [
    'assets/image1.jpeg',
    'assets/image2.jpeg',
    'assets/image3.jpeg',
  ]; // List of image paths

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
          profileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          color: color.AppColor.homePageTitle,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 20,
                          color: color.AppColor.homePageSubtitle,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons
                            .logout), // Change this icon to the logout icon you want
                        onPressed: logout,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('assets/imagejob2.png')
                                as ImageProvider,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 220,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      color.AppColor.gradientFirst.withOpacity(0.9),
                      color.AppColor.gradientSecond.withOpacity(0.9),
                    ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(80)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(5, 10),
                          blurRadius: 10,
                          color: color.AppColor.gradientSecond.withOpacity(0.3))
                    ]),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 25,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "some thing add",
                        style: TextStyle(
                            fontSize: 16,
                            color: color.AppColor.homePageContainerTextSmall),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Find Your",
                        style: TextStyle(
                            fontSize: 25,
                            color: color.AppColor.homePageContainerTextSmall),
                      ),
                      Text(
                        "Dream Job With Us",
                        style: TextStyle(
                            fontSize: 25,
                            color: color.AppColor.homePageContainerTextSmall),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star,
                              size: 20,
                              color: color.AppColor.homePageContainerTextSmall),
                          Icon(Icons.star,
                              size: 20,
                              color: color.AppColor.homePageContainerTextSmall),
                          Icon(Icons.star,
                              size: 20,
                              color: color.AppColor.homePageContainerTextSmall),
                          Icon(Icons.star,
                              size: 20,
                              color: color.AppColor.homePageContainerTextSmall),
                          Icon(Icons.star,
                              size: 20,
                              color: color.AppColor.homePageContainerTextSmall),
                          Expanded(child: Container()),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: color.AppColor.gradientFirst,
                                  blurRadius: 10,
                                  offset: Offset(3, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JobPage()),
                                );
                              },
                              child: Text('Lets Go'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(5, 10),
                      blurRadius: 10,
                      color: color.AppColor.homePageTitle.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 25,
                        right:
                            60, // Adjusted right padding to accommodate the IconButton
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Looking for skilled workers?",
                            style: TextStyle(
                              fontSize: 15,
                              color: color.AppColor.homePageTitle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              "Post your JOB now!",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: color.AppColor.gradientFirst,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 25,
                      right: 20,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: color.AppColor
                            .gradientFirst, // Replace with your desired icon
                        onPressed: () {
                          // Add your onPressed functionality here
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "Quick Access",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: color.AppColor.homePageTitle),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 130,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.AppColor.gradientFirst.withOpacity(0.7),
                              color.AppColor.gradientSecond.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                      width:
                          20), // Adjust the width according to your preference

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the setting page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(5, 10),
                                blurRadius: 10,
                                color: color.AppColor.homePageTitle
                                    .withOpacity(0.2),
                              ),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.green,
                              size: 40,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 19,
              ),
              CarouselSlider(
                items: images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 155,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
