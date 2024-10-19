import 'dart:async';
import 'dart:convert';

// import 'dart:js';
// import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:todo_note/utils/colors/kprime_colors.dart';

// final view = View.of(context as BuildContext);
// final viewPadding = view.padding;
// final mediaPadding = MediaQuery.paddingOf(context as BuildContext);

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //
  TextEditingController updatetitleController = TextEditingController();
  TextEditingController updatedescriptionController = TextEditingController();

  update(var oneone, var twotwo) {
    updatetitleController.text = oneone;
    updatedescriptionController.text = twotwo;
  }

  List? getData;

  Future<dynamic> getTodo() async {
    String geturl = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    Uri geturi = Uri.parse(geturl);
    Response getresponse = await http.get(geturi);
    if (getresponse.statusCode == 200) {
      var decode = jsonDecode(getresponse.body)['items'];
      print(getresponse.statusCode);
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
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "is_completed": false
      }),
      headers: {"Content-Type": "application/json"},
    );
    if (postresponse.statusCode == 201) {
      var snackBar = const SnackBar(
        content: Text('Adding successfully'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        getFecth();
      });
    }
    print(postresponse.statusCode);
  }

  Future<dynamic> updateTodo(var todoNoteUpdateId) async {
    String updateurl = 'https://api.nstack.in/v1/todos/$todoNoteUpdateId';
    Uri updateuri = Uri.parse(updateurl);
    var updatebody = {
      "title": updatetitleController.text,
      "description": updatedescriptionController.text,
      "is_completed": false
    };
    Response updateresponse = await http.put(
      updateuri,
      body: jsonEncode(updatebody),
      headers: {"Content-Type": "application/json"},
    );
    if (updateresponse.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text('Update successfully'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        getFecth();
      });
    } else {
      print(updateresponse.statusCode);
    }
  }

  Future<dynamic> deleteTodo(var todoNoteDeleteId) async {
    String deleteurl = 'https://api.nstack.in/v1/todos/$todoNoteDeleteId';
    Uri deleteuri = Uri.parse(deleteurl);
    Response deleteresponse = await http.delete(
      deleteuri,
    );
    if (deleteresponse.statusCode == 200) {
      print(deleteresponse.statusCode);
      var snackBar = const SnackBar(
        content: Text('Deleted successfully!!'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        getFecth();
      });
    } else {
      var snackBar = const SnackBar(
        content: Text('Deleted Unsuccessfully!'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(deleteresponse.statusCode);
    }
  }

  @override
  void initState() {
    getFecth();
    super.initState();
  }

  Future<void> refresh() async {
    getFecth();
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
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: getData == null
            ? const Center(child: CircularProgressIndicator())
            : getData!.isEmpty
                ? const Center(
                    child: Text(
                    "Empty Todo Note",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.only(
                        bottom: kFloatingActionButtonMargin + 65),
                    // physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: getData?.length,
                    itemBuilder: (context, index) {
                      var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                          .parseUTC("${getData![index]["updated_at"]}")
                          .toLocal();
                      String formattedDate =
                          DateFormat("hh:mm a dd MMM yyyy").format(dateValue);

                      return Container(
                        margin:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 14.0, right: 8.0),
                          leading: CircleAvatar(
                            backgroundColor: kprimecolor,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            getData![index]['title'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontSize: 20,
                              color: Color(0xff00CCB3),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getData![index]['description'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  // fontSize: 16
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Time :- ${formattedDate.substring(0, 8)}  •  Date :- ${formattedDate.substring(9, 20)}',
                                style: const TextStyle(
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
                                    showModalBottomSheet<void>(
                                      shape: const RoundedRectangleBorder(),
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.grey.shade900,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: MediaQuery(
                                            data: MediaQueryData.fromView(
                                                WidgetsBinding.instance.window),
                                            child: SafeArea(
                                              child: SizedBox(
                                                // padding: const EdgeInsets.only(
                                                //   top: 10,
                                                // ),
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                                                      const Text(
                                                        "Todo Title",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xff00CCB3),
                                                        ),
                                                      ),
                                                      TextField(
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .sentences,
                                                        maxLength: 40,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        controller:
                                                            updatetitleController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 10,
                                                            left: 10,
                                                            top: 8,
                                                            bottom: 8,
                                                          ),
                                                          hintText:
                                                              "Enter title",
                                                          hintStyle:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        "Todo Description",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xff00CCB3),
                                                        ),
                                                      ),
                                                      TextField(
                                                        onChanged: (value) {},
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .sentences,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        maxLines: 5,
                                                        controller:
                                                            updatedescriptionController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10,
                                                                  left: 10,
                                                                  top: 8,
                                                                  bottom: 8),
                                                          hintText:
                                                              "Enter description",
                                                          hintStyle:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 14),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    const MaterialStatePropertyAll(
                                                                        Colors
                                                                            .redAccent),
                                                                shape:
                                                                    MaterialStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                // titleController
                                                                //     .clear();
                                                                // descriptionController
                                                                //     .clear();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    const MaterialStatePropertyAll(
                                                                        Colors
                                                                            .green),
                                                                shape:
                                                                    MaterialStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                'Update Note',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  updateTodo(getData![
                                                                          index]
                                                                      ['_id']);
                                                                  getFecth();
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                                // titleController
                                                                //     .clear();
                                                                // descriptionController
                                                                //     .clear();
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
                                          ),
                                        );
                                      },
                                    );

                                    setState(() {
                                      update(
                                        getData![index]['title'],
                                        getData![index]['description'],
                                      );
                                    });
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text("Delete"),
                                  onTap: () {
                                    deleteTodo(getData![index]["_id"]);
                                  },
                                ),
                              ];
                            },
                          ),
                        ),
                      );
                    }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kprimecolor,
        onPressed: () {
          addTodoshowModelBottomSheet(context);
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

  Future<void> addTodoshowModelBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: MediaQuery(
            data: MediaQueryData.fromView(WidgetsBinding.instance.window),
            child: SafeArea(
              child: SizedBox(
                // padding: const EdgeInsets.only(
                //   top: 10,
                // ),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      const Text(
                        "Todo Title",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00CCB3),
                        ),
                      ),
                      TextField(
                        textCapitalization: TextCapitalization.sentences,
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
                              onPressed: () {
                                titleController.clear();
                                descriptionController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Colors.green),
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
                                if (titleController.text.isEmpty) {
                                } else {
                                  setState(() {
                                    postTodo();
                                  });

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
          ),
        );
      },
    );
  }

  Future<void> updateoneshowModelBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: MediaQuery(
            data: MediaQueryData.fromView(WidgetsBinding.instance.window),
            child: SafeArea(
              child: SizedBox(
                // padding: const EdgeInsets.only(
                //   top: 10,
                // ),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      const Text(
                        "Todo Title",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00CCB3),
                        ),
                      ),
                      TextField(
                        textCapitalization: TextCapitalization.sentences,
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
                              onPressed: () {
                                titleController.clear();
                                descriptionController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Colors.green),
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
                                if (titleController.text.isEmpty) {
                                } else {
                                  setState(() {
                                    postTodo();
                                    getFecth();
                                  });

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
          ),
        );
      },
    );
  }
}
