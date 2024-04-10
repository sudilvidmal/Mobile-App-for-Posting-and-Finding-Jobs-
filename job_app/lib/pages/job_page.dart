import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobee/pages/job_detail.dart';

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  Color _containerColor =
      Color.fromARGB(255, 33, 243, 33); // Default color for the container

  late TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _jobsStream;
  String _selectedCategory = ''; // Added to keep track of selected category

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
            begin: Color.fromARGB(255, 33, 243, 33),
            end: Color.fromARGB(255, 211, 221, 12))
        .animate(_controller);
    _jobsStream = FirebaseFirestore.instance.collection('job_list').snapshots();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearch(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _jobsStream =
            FirebaseFirestore.instance.collection('job_list').snapshots();
      } else {
        _jobsStream = FirebaseFirestore.instance
            .collection('job_list')
            .where('title', isGreaterThanOrEqualTo: searchTerm)
            .where('title', isLessThan: searchTerm + 'z')
            .snapshots();
      }
    });
  }

  // Method to filter jobs by category
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category.isEmpty) {
        _jobsStream =
            FirebaseFirestore.instance.collection('job_list').snapshots();
      } else {
        _jobsStream = FirebaseFirestore.instance
            .collection('job_list')
            .where('Category', isEqualTo: category)
            .snapshots();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _containerColor = _colorAnimation.value!;
        });
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            "Jobs",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border:
                      Border.all(color: const Color.fromARGB(255, 10, 10, 10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: _updateSearch,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              // Add a suffix icon button
                              icon: Icon(Icons.category), // Icon for category
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('job_list')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasData) {
                                                final List<String> categories =
                                                    []; // To store unique categories
                                                snapshot.data!.docs
                                                    .forEach((doc) {
                                                  final category =
                                                      doc['Category'] as String;
                                                  if (!categories
                                                      .contains(category)) {
                                                    categories.add(category);
                                                  }
                                                });
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: categories.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final category =
                                                        categories[index];
                                                    return ListTile(
                                                      leading:
                                                          Icon(Icons.category),
                                                      title: Text(category),
                                                      onTap: () {
                                                        // Handle category selection
                                                        _filterByCategory(
                                                            category);
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                              return SizedBox(); // Return empty widget if no data
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                "All Available Jobs", // Add the text "Job" here
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              AnimatedContainer(
                duration: Duration(seconds: 2),
                height: 7,
                width: double.infinity,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      _containerColor,
                      Color.fromARGB(126, 0, 0, 0),
                    ],
                    stops: [0.3, 1],
                  ),
                ),
              ),
              SizedBox(height: 7),
              Expanded(
                child: JobListScreen(
                  searchController: _searchController,
                  jobsStream: _jobsStream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobListScreen extends StatefulWidget {
  final TextEditingController searchController;
  final Stream<QuerySnapshot> jobsStream;

  JobListScreen({
    required this.searchController,
    required this.jobsStream,
  });

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        Expanded(
          child: StreamBuilder(
            stream: widget.jobsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> data =
                      documents[index].data() as Map<String, dynamic>;
                  String jobTitle = data['title'];
                  String jobName = data['name'];
                  String jobDescription = data['description'];
                  String jobPosterEmail = data['user_email'];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Text(jobTitle),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsScreen(
                              jobTitle: jobTitle,
                              jobName: jobName,
                              jobDescription: jobDescription,
                              jobPosterEmail: jobPosterEmail,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
