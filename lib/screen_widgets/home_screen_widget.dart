import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:todo_note/utils/colors/kprime_colors.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List? getData;

  Future<dynamic> getTodo() async {
    String geturl = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    Uri geturi = Uri.parse(geturl);
    Response getresponse = await http.get(geturi);
    if (getresponse.statusCode == 200) {
      var decode = jsonDecode(getresponse.body)['items'];
      return decode;
    } else {
      print(getresponse.statusCode);
    }
  }

  getFecth() {
    getTodo().then((value) {
      setState(() {
        getData = value;
      });
    });
  }

  Future<dynamic> postTodo() async {
    String posturl = "https://api.nstack.in/v1/todos";
    Uri posturi = Uri.parse(posturl);
    Response postresponse = await http.post(
      posturi,
      body: jsonEncode({
        "title": titleController.text,
        "description": descriptionController.text,
        "is_completed": false
      }),
      headers: {"Content-Type": "application/json"},
    );
    print(postresponse.statusCode);
  }

  @override
  void initState() {
    getFecth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: kprimecolor,
        title: const Text(
          "Todo Note",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: getData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: getData?.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kprimecolor,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    getData![index]['title'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00CCB3),
                    ),
                  ),
                  subtitle: Text(
                    getData![index]['description'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kprimecolor,
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          showModelBottomSheet(context);
        },
        shape: const StadiumBorder(),
        label: const Row(
          children: [
            Icon(Icons.add, size: 20),
            SizedBox(width: 5),
            Text("Add Note"),
          ],
        ),
      ),
    );
  }

  Future<void> showModelBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 600,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Todo Title",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff00CCB3),
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 8,
                          bottom: 8,
                        ),
                        hintText: "Enter title",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Todo Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff00CCB3),
                      ),
                    ),
                    TextField(
                      maxLines: 4,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            right: 10, left: 10, top: 8, bottom: 8),
                        hintText: "Enter description",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.redAccent),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.green),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Add Note',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                postTodo();
                                getFecth();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
