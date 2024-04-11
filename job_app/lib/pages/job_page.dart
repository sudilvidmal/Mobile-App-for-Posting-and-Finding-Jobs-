import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobee/pages/home_page.dart';
import 'package:jobee/pages/job_detail.dart';
import '../pages/colors.dart' as color;

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  Color _containerColor =
      color.AppColor.gradientSecond; // Default color for the container

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
        _filterByCategory(
            _selectedCategory); // Keep the current category filter while searching
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
      if (category == 'all') {
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, bottom: 16.0, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: Color.fromARGB(255, 212, 212, 212), width: 2.0),
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
                              icon: Icon(
                                Icons.category,
                                color: color.AppColor.gradientSecond,
                              ), // Icon for category
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(
                                              Icons.category,
                                              color:
                                                  color.AppColor.gradientSecond,
                                            ),
                                            title: Text('All'),
                                            onTap: () {
                                              // Handle category selection
                                              _filterByCategory('all');
                                              Navigator.pop(context);
                                            },
                                          ),
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
                                                    snapshot.data!.docs
                                                        .map((doc) =>
                                                            doc['Category']
                                                                as String)
                                                        .toList()
                                                      ..sort(); // Get all categories
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: categories.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final category =
                                                        categories[index];
                                                    // Show category only once or if it's the only one available
                                                    if (index == 0 ||
                                                        category !=
                                                            categories[
                                                                index - 1]) {
                                                      return ListTile(
                                                        leading: Icon(
                                                          Icons.category,
                                                          color: color.AppColor
                                                              .gradientSecond,
                                                        ),
                                                        title: Text(category),
                                                        onTap: () {
                                                          // Handle category selection
                                                          _filterByCategory(
                                                              category);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    }
                                                    return SizedBox.shrink();
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "All Available Jobs", // Add the text "Job" here
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
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
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      _containerColor,
                      color.AppColor.gradientFirst,
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color:
                                color.AppColor.homePageTitle.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          jobTitle,
                          style: TextStyle(
                              color: color.AppColor.gradientFirst,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        subtitle: Text(
                          'Publisher: ' + jobName,
                          style: TextStyle(color: color.AppColor.homePageTitle),
                        ),
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
