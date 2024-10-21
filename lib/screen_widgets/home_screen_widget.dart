import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:todo_note/utils/api/api_address.dart';
import 'package:todo_note/utils/colors/kprime_colors.dart';
import 'package:todo_note/utils/widgets/snackbar_messeage.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<List?> getTodo() async {
    try {
      String geturl = getApiurl;
      Uri geturi = Uri.parse(geturl);
      Response getresponse = await http.get(geturi);
      if (getresponse.statusCode == 200) {
        dynamic decode = jsonDecode(getresponse.body)['items'];
        return decode;
      } else {
        print(getresponse.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<dynamic> postTodo() async {
    try {
      String posturl = apiurl;
      Uri posturi = Uri.parse(posturl);
      Response postresponse = await http.post(
        posturi,
        body: jsonEncode(
          {
            "title": titleController.text.trim(),
            "description": descriptionController.text.trim(),
            "is_completed": false
          },
        ),
        headers: {"Content-Type": "application/json"},
      );
      if (postresponse.statusCode == 201) {
        snackBarMesseage("Added successfully", Colors.green, context);
        setState(() {
          getFecth();
        });
      } else {
        snackBarMesseage("Adding Unsuccessfully", Colors.red, context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> updateTodo(String todoNoteUpdateId) async {
    try {
      String updateurl = '$apiurl$todoNoteUpdateId';
      Uri updateuri = Uri.parse(updateurl);
      Response updateresponse = await http.put(
        updateuri,
        body: jsonEncode(
          {
            "title": titleController.text.trim(),
            "description": descriptionController.text.trim(),
            "is_completed": false
          },
        ),
        headers: {"Content-Type": "application/json"},
      );
      if (updateresponse.statusCode == 200) {
        snackBarMesseage("Update successfully", Colors.green, context);
        setState(() {
          getFecth();
        });
      } else {
        snackBarMesseage("Update Unsuccessfully", Colors.red, context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> deleteTodo(String todoNoteDeleteId) async {
    try {
      String deleteurl = '$apiurl$todoNoteDeleteId';
      Uri deleteuri = Uri.parse(deleteurl);
      Response deleteresponse = await http.delete(
        deleteuri,
      );
      if (deleteresponse.statusCode == 200) {
        snackBarMesseage("Delete successfully", Colors.green, context);
        setState(() {
          getFecth();
        });
      } else {
        snackBarMesseage("Delete Unsuccessfully", Colors.red, context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List? getData;

  getFecth() {
    getTodo().then((value) {
      setState(() {
        getData = value;
      });
    });
  }

  Future<void> _refresh() async {
    getFecth();
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
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: getData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getData!.isEmpty
              ? const Center(
                  child: Text(
                    "Empty Todo Note",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin +
                          MediaQuery.of(context).size.height * 0.1,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: getData?.length,
                    itemBuilder: (context, index) {
                      DateTime dateValue = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                          .parseUTC("${getData![index]["updated_at"]}")
                          .toLocal();
                      String formattedDate =
                          DateFormat("hh:mm a dd MMM yyyy").format(dateValue);

                      return Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          right: 10,
                          left: 10,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 8.0, right: 8.0),
                          leading: CircleAvatar(
                            backgroundColor: kprimecolor,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            getData![index]['title'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff00CCB3),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textAlign: TextAlign.justify,
                                getData![index]['description'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Time :- ${formattedDate.substring(0, 8)}  •  Date :- ${formattedDate.substring(9, 20)}',
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Color.fromARGB(255, 177, 133, 0),
                                  fontSize: 10.0,
                                ),
                              )
                            ],
                          ),
                          trailing: PopupMenuButton(
                            iconColor: Colors.white,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: const Text("Edit"),
                                  onTap: () {
                                    titleController.text =
                                        getData![index]['title'];
                                    descriptionController.text =
                                        getData![index]['description'];
                                    showModelBottomSheet(
                                      true,
                                      getData![index]['_id'],
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text("Delete"),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        title: const Text('Are you sure?'),
                                        content: const Text(
                                          'This action will delete this data',
                                        ),
                                        actionsPadding: const EdgeInsets.only(
                                          bottom: 24,
                                          right: 24,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                          top: 18,
                                          bottom: 18,
                                          right: 24,
                                          left: 24,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              deleteTodo(
                                                getData![index]["_id"],
                                              );
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ];
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kprimecolor,
        onPressed: () {
          showModelBottomSheet(false, null);
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

  Future<void> showModelBottomSheet(bool isUpdate, String? todoNoteUpdateId) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: MediaQuery(
            data: MediaQueryData.fromView(WidgetsBinding.instance.window),
            child: SafeArea(
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
                      textCapitalization: TextCapitalization.words,
                      maxLength: 40,
                      style: const TextStyle(color: Colors.white),
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
                    const Text(
                      "Todo Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff00CCB3),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {},
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 8,
                          bottom: 8,
                        ),
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
                            onPressed: () {
                              Navigator.of(context).pop();
                              titleController.clear();
                              descriptionController.clear();
                            },
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
                            child: Text(
                              isUpdate ? "Update Todo" : "Add Todo",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (titleController.text.isNotEmpty) {
                                if (isUpdate == true) {
                                  updateTodo(todoNoteUpdateId!);
                                } else {
                                  postTodo();
                                }
                                Navigator.pop(context);
                                titleController.clear();
                                descriptionController.clear();
                              }
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
