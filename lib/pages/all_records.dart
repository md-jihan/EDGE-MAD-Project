import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllRecords extends StatefulWidget {
  const AllRecords({super.key});

  @override
  State<AllRecords> createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {
  bool isSortedByPrice = false; // Tracks sorting state
  final streamContent =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MH App"),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isSortedByPrice = !isSortedByPrice; // Toggle sorting
                });
              },
              child: Icon(Icons.sort),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: streamContent,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No Data available"),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  if (isSortedByPrice) {
                    docs.sort((a, b) {
                      final priceA = num.tryParse(a['price'].toString()) ?? 0;
                      final priceB = num.tryParse(b['price'].toString()) ?? 0;

                      // Reverse comparison if sorting is descending (high to low)
                      return isSortedByPrice
                          ? priceA.compareTo(priceB)
                          : priceB.compareTo(priceA);
                    });
                  }
                  return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final content = doc.data() as Map;
                        final id = doc.id;
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: Offset(0, 3))
                              ]),
                          child: ListTile(
                            title: Text(content['product_name']),
                            subtitle: Text(content['price']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      deleteData(context, id, content);
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      editData(
                                          context,
                                          index,
                                          id,
                                          content['product_name'],
                                          content['price']);
                                    },
                                    icon: Icon(Icons.edit))
                              ],
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  void editData(context, index, id, prevcontent, pricecontent) {
    TextEditingController editData = TextEditingController(text: prevcontent);
    TextEditingController editPrice = TextEditingController(text: pricecontent);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Data"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editData,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: editPrice,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(id)
                        .update({
                      'product_name': editData.text,
                      'price': editPrice.text
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Save")),
            ],
          );
        });
  }

  void deleteData(context, id, productName) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Confirmation"),
            content: Text(
                "Are you sure you went to delete '${productName['product_name']}'"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(id)
                        .delete();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Product '${productName['product_name']}' deleted successfully!"),
                      action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(id)
                                .set(productName);
                          }),
                      duration: Duration(seconds: 3),
                    ));
                  },
                  child: Text("Delete"))
            ],
          );
        });
  }
}
