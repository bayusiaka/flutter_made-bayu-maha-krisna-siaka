import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter_taskrestapi/prioritas1/models/book.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_taskrestapi/prioritas1/utils/fetch.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BookModel> books = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Dio()
        .get("https://bookapi-1-v1905306.deta.app/api/v1/books/")
        .then((responses) {
      var data = responses.data;
      for (var i = 0; i < data.length; i++) {
        books.add(BookModel.fromJson(data[i]));
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    yearController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.mobile_friendly_rounded),
        title: Text("Prioritas 1"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Book"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextField(
                      controller: yearController,
                      decoration: const InputDecoration(
                        labelText: "Year",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      var data = {
                        "book_id": books.length + 1,
                        "title": titleController.text,
                        "year": int.parse(yearController.text),
                      };
                      Dio()
                          .post(
                              "https://bookapi-1-v1905306.deta.app/api/v1/books/",
                              data: jsonEncode(data))
                          .then((response) {
                        var response_detail = response.data["detail"];
                        Navigator.pop(context);
                        if (response_detail["status_code"] == 201) {
                          CherryToast(
                            icon: Icons.alarm_add,
                            themeColor: Colors.lightBlueAccent,
                            title: const Text(""),
                            displayTitle: false,
                            description: const Text("Data Added Successfully",
                                style: TextStyle(color: Colors.black)),
                            toastPosition: Position.bottom,
                            animationDuration:
                                const Duration(milliseconds: 1000),
                            autoDismiss: true,
                          ).show(context);
                          books.add(BookModel.fromJson(response.data["data"]));
                          setState(() {});
                        } else {
                          print("Data Failed to Add");
                        }
                        titleController.clear();
                        yearController.clear();
                      });
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(books[index].title),
              subtitle: Text(books[index].year.toString()),
              trailing: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("Delete Icon Successfully Pressed");

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Book"),
                            content: const Text(
                                "Are you sure to delete this book?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  var response =
                                      await deleteData(books[index].bookId);
                                  var responseDetail = response["detail"];
                                  if (responseDetail["status_code"] == 200) {
                                    CherryToast(
                                      icon: Icons.check,
                                      themeColor: Colors.lightBlueAccent,
                                      title: const Text(""),
                                      displayTitle: false,
                                      description: const Text(
                                          "Data Deleted Successfully",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      toastPosition: Position.bottom,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      autoDismiss: true,
                                    ).show(context);
                                    books.removeAt(index);
                                    setState(() {});
                                  } else {
                                    print("Data Failed to Delete");
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.delete),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          titleController.text = books[index].title;
                          yearController.text = books[index].year.toString();
                          return AlertDialog(
                            title: const Text("Edit Book"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    labelText: "Title",
                                  ),
                                ),
                                TextField(
                                  controller: yearController,
                                  decoration: const InputDecoration(
                                    labelText: "Year",
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  var data = {
                                    "book_id": books[index].bookId,
                                    "title": titleController.text,
                                    "year": int.parse(yearController.text),
                                  };
                                  var response = await updateData(
                                      books[index].bookId, data);
                                  var responseDetail = response["detail"];
                                  if (responseDetail["status_code"] == 200) {
                                    // ignore: use_build_context_synchronously
                                    CherryToast(
                                      icon: Icons.check,
                                      themeColor: Colors.lightBlueAccent,
                                      title: const Text(""),
                                      displayTitle: false,
                                      description: const Text(
                                          "Data Changed Successfully",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      toastPosition: Position.bottom,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      autoDismiss: true,
                                    ).show(context);
                                    books[index] = BookModel.fromJson(data);
                                    setState(() {});
                                  } else {
                                    print("Data Failed to Change");
                                  }
                                  Navigator.pop(context);
                                  titleController.clear();
                                  yearController.clear();
                                },
                                child: const Text("Update"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.edit),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}