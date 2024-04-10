import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCategoryModal(context);
          },
          child: Text('Show Categories'),
        ),
      ),
    );
  }

  void showCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('job_list').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return ListTile(
                          leading: Icon(Icons.category),
                          title: Text(category['Category']),
                          onTap: () {
                            // Handle category selection
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
  }
}
