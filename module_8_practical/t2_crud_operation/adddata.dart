import 'package:flutter/material.dart';
import 'package:sqflitedemo/practice_sqlite/dbhelper.dart';

class MyAddScreen extends StatefulWidget {
  const MyAddScreen({super.key});

  @override
  State<MyAddScreen> createState() => _MyAddScreenState();
}

class _MyAddScreenState extends State<MyAddScreen> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _desccontroller = TextEditingController();

  List<Map<String, dynamic>> allnotes = [];
  dbhelper dbref = dbhelper.getinstance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnotes();
  }

  void getnotes() async {
    var notes = await dbref.getallnotes();
    setState(() {
      allnotes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:allnotes.isNotEmpty? ListView.builder(
        itemCount: allnotes.length,
        itemBuilder: (context, index) {
          var note = allnotes[index];
          var sno = allnotes[index]["s_no"];
          return ListTile(
            title: Text(note["title"]),
            subtitle: Text(note["description"]),
            trailing: SizedBox(
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        _titlecontroller.text = note["title"];
                        _desccontroller.text = note["description"];
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(12.0),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(
                                      "update note",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 21,
                                    ),
                                    TextField(
                                      controller: _titlecontroller,
                                      decoration: InputDecoration(
                                          hintText: ("enter title here"),
                                          label: Text("title"),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11))),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    TextField(
                                      controller: _desccontroller,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          hintText: "enter the description",
                                          label: Text("description"),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11))),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11)),
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Colors.black)),
                                              onPressed: () async {
                                                var title =
                                                    _titlecontroller.text;
                                                var desc = _desccontroller.text;
                                                if (title.isNotEmpty &&
                                                    desc.isNotEmpty) {
                                                  bool
                                                      check =
                                                      await dbref.updatenote(
                                                          mtitle:
                                                              _titlecontroller
                                                                  .text,
                                                          mdesc: _desccontroller
                                                              .text,
                                                          sid: sno);
                                                  if (check) {
                                                    getnotes();
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "updated successfully")));
                                                    _titlecontroller.clear();
                                                    _desccontroller.clear();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content:
                                                                Text("fail")));
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "please fill the all blank")));
                                                }
                                              },
                                              child: Text(
                                                "update note",
                                                style: TextStyle(fontSize: 15),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 11,
                                        ),
                                        Expanded(
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11)),
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Colors.black)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "cancel",
                                                style: TextStyle(fontSize: 15),
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: Icon(Icons.edit)),
                  InkWell(
                      onTap: () {
                        dbref.delete(sno: allnotes[index]["s_no"]);
                        getnotes();
                      },
                      child: Icon(Icons.delete))
                ],
              ),
            ),
          );
        },
      ):Center(child: Text("no data",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "add note",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      TextField(
                        controller: _titlecontroller,
                        decoration: InputDecoration(
                            hintText: ("enter title here"),
                            label: Text("title"),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11))),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                        controller: _desccontroller,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: "enter the description",
                            label: Text("description"),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11))),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    side: BorderSide(
                                        width: 1, color: Colors.black)),
                                onPressed: () async {
                                  var title = _titlecontroller.text;
                                  var sdesc = _desccontroller.text;
                                  if (title.isNotEmpty && sdesc.isNotEmpty) {
                                    bool check = await dbref.addnotes(
                                        mtitle: title, mdesc: sdesc);
                                    if (check) {
                                      getnotes();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("added successfully")));
                                      _titlecontroller.clear();
                                      _desccontroller.clear();
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "please fill the all blank")));
                                  }
                                },
                                child: Text(
                                  "add note",
                                  style: TextStyle(fontSize: 15),
                                )),
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          Expanded(
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    side: BorderSide(
                                        width: 1, color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "cancel",
                                  style: TextStyle(fontSize: 15),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
