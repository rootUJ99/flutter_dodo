import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DodoApp());
}

class DodoApp extends StatelessWidget {
  const DodoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Dodo App",
            style: TextStyle(color: Color.fromARGB(255, 249, 255, 255)),
          ),
          backgroundColor: const Color.fromARGB(235, 108, 238, 238),
        ),
        body: const DodoPage(),
      ),
      debugShowCheckedModeBanner: false,
      title: "DodoApp",
    );
  }
}

class DodoPage extends StatefulWidget {
  const DodoPage({super.key});

  @override
  State<DodoPage> createState() => _DodoPage();
}

class _DodoPage extends State<DodoPage> {
  List<String> _text = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference _tasks =
        FirebaseFirestore.instance.collection('tasks_collection');
    Stream<QuerySnapshot> _tasks_snap = _tasks.snapshots();

    void addItem(value) {
      if (value != "") {
        //   setState(() {
        //     _text = [..._text, value];
        //   }),
        _tasks
            .add({'task': value})
            .then((value) => {print('adding value'), textController.clear()})
            .catchError((err) => print(err));
      }
    }

    void deleteItem(document) {
      // _text.removeAt(index),
      // setState(
      //   () {},
      // )

      print("document $document");

      _tasks
          .doc(document)
          .delete()
          .then((value) => print('deleted item'))
          .catchError((err) => print(err));
    }

    ;

    return StreamBuilder<QuerySnapshot>(
      stream: _tasks_snap,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final list = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return {...data, 'document': document.id};
        }).toList();

        // print(snapshot.data!.docs.toList());

        return (Container(
            // color: const Color.fromARGB(198, 39, 216, 216),
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "enter the task",
                  ),
                  onSubmitted: addItem,
                  textInputAction: TextInputAction.go,
                  controller: textController,
                ),
                ...list.map((entry) {
                  final key = UniqueKey();
                  return Card(
                    key: key,
                    child: Container(
                      color: const Color.fromARGB(255, 210, 243, 243),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry['task']),
                            IconButton(
                                onPressed: () => deleteItem(entry['document']),
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20.0,
                                ))
                          ]),
                    ),
                  );
                }),
              ],
            )));
      },
    );
  }
}
