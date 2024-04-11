import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseConn {
  FirebaseFirestore db = FirebaseFirestore.instance;

  void InsertJobList(var category, var Description, var title, var name,
      var uname, var uemail) {
    final jobList = <String, dynamic>{
      "Category": category,
      "description": Description,
      "name": name,
      "title": title,
      "username": uname,
      "user_email": uemail
    };
    db
        .collection("job_list")
        .doc()
        .set(jobList)
        .then((value) => print("Job added successfully"))
        .onError((e, _) => print("Error adding job: $e"));
  }

  Future<void> deleteJob(var docid) async {
    db.collection("job_list").doc(docid).delete().then(
          (doc) => print("Document deleted with id:" + docid),
          onError: (e) => print("Error updating document $e"),
        );
  }

  void updateJobList(
      var name, var Description, var title, var docid, var categ) {
    db
        .collection("job_list")
        .doc(docid)
        .update({
          'description': Description,
          'title': title,
          'name': name,
          'Category': categ
        })
        .then((value) =>
            print("Document id:" + docid + " Job updated Successfully"))
        .onError((e, _) => print("Error adding job: $e"));
  }
}
