import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mh_app/pages/all_records.dart';

class Testform extends StatefulWidget {
  const Testform({super.key});

  @override
  State<Testform> createState() => _TestformState();
}

class _TestformState extends State<Testform> {
  TextEditingController prodectName = TextEditingController();
  TextEditingController prodectPrice = TextEditingController();
  String? lastDocment;
  Future<void> saveData() async {
    if (prodectName.text != "") {
      final docRef = await FirebaseFirestore.instance.collection('users').add({
        "product_name": prodectName.text,
        "price": prodectPrice.text,
      });
      lastDocment = docRef.id;
      prodectName.clear();
      prodectPrice.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data Submit Successfully!"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              undoData();
            }),
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Field is Empty")));
    }
  }

  Future<void> undoData() async {
    if (lastDocment != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(lastDocment)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully Undone!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong "),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test App"),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: prodectName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: prodectPrice,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: ElevatedButton(
                onPressed: () {
                  saveData();
                },
                child: Text("Submit")),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AllRecords()));
                },
                child: Text("veiw Data"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white)),
          )
        ],
      ),
    );
  }
}
