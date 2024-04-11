import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jobee/components/UpdateJobForm.dart';
import '../pages/colors.dart' as color;
import 'package:jobee/pages/database_conn.dart';

class MyJobContainer extends StatefulWidget {
  const MyJobContainer(
      {super.key,
      required this.title,
      required this.name,
      required this.id,
      required this.uname,
      required this.uemail});

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
        padding:
            EdgeInsets.only(top: 10.0, right: 30.0, bottom: 10.0, left: 30.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 10,
                color: color.AppColor.homePageTitle.withOpacity(0.15),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: color.AppColor.gradientFirst,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
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
                        icon: Icon(
                          Icons.delete,
                          color: Colors.grey[600],
                        )),
                    IconButton(
                        onPressed: () => clickupdate(context),
                        icon: Icon(
                          Icons.update,
                          color: color.AppColor.gradientSecond,
                        )),
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
