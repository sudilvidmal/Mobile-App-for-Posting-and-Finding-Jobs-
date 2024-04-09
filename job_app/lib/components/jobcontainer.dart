import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_app/components/UpdateJobForm.dart';

import 'package:job_app/pages/database_conn.dart';

class MyJobContainer extends StatefulWidget {
  const MyJobContainer(
      {super.key, required this.title, required this.name, required this.id, required this.uname,required this.uemail });

  final title;
  final name;
  final id;
  final uname;
  final uemail;

  @override
  State<MyJobContainer> createState() => _MyJobContainerState();
}

class _MyJobContainerState extends State<MyJobContainer> {
  Future<void> clickdelete() async {
    DatabaseConn dbc = new DatabaseConn();
    dbc.deleteJob(widget.id);
  }

  void clickupdate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateJobForm(docid: widget.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.brown[400],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title),
                  (widget.name),
                ],
              )),
        
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Alert"),
                              content:
                                  const Text("Do you want to delete this job?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    clickdelete();
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("Yes"),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("No"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.close)),
                    IconButton(
                        onPressed: () => clickupdate(context),
                        icon: Icon(Icons.update)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

