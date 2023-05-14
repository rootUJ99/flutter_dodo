import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo/item_card.dart';
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
            "🔫 Dodo App",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
  final _currentSelectedItem = {};
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference _tasks =
        FirebaseFirestore.instance.collection('tasks_collection');
    Stream<QuerySnapshot> _tasks_snap = _tasks.snapshots();

    void addItem() {
      if (_currentSelectedItem.isEmpty == false) {
        _tasks.doc(_currentSelectedItem['document']).set({
          'task': textController.text,
          'done': _currentSelectedItem['done'],
        }).then((value) {
          print('updating value');
          textController.clear();
          setState(() {
            _currentSelectedItem.clear();
          });
        }).catchError((err) => print(err));
      } else if (textController.text != "") {
        _tasks.add({
          'task': textController.text,
          'done': false,
        }).then((value) {
          print('adding value');
          textController.clear();
        }).catchError((err) => print(err));
      }
    }

    void updateItem(entry) {
      textController.value = TextEditingValue(text: entry['task'] as String);
      setState(() {
        _currentSelectedItem.addAll(entry);
      });
    }

    void deleteItem(document) {
      _tasks
          .doc(document)
          .delete()
          .then((value) => print('deleted item'))
          .catchError((err) => print(err));
    }

    void markDone(entry, done) {
      _tasks.doc(entry['document']).set({
        'task': entry['task'],
        'done': done,
      });
    }

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
        return ListView.builder(
          itemCount: list.isEmpty ? 1 : list.length + 1,
          itemBuilder: (context, index) {
            // print(index);
            int calcIndex(int ind) => ind == 0 ? 0 : ind - 1;
            Map<String, dynamic>? item =
                list.isEmpty ? null : list[calcIndex(index)];

            if (index == 0) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "enter the task",
                  ),
                  onSubmitted: (_) => addItem(),
                  textInputAction: TextInputAction.go,
                  controller: textController,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Dismissible(
                key: UniqueKey(),
                // confirmDismiss: ,
                background: const ColoredBox(
                  color: Color.fromARGB(220, 121, 158, 201),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
                secondaryBackground: const ColoredBox(
                  color: Color.fromARGB(255, 236, 103, 103),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  switch (direction) {
                    case DismissDirection.endToStart:
                      print('delete item');
                      deleteItem(item!['document']);
                      break;
                    case DismissDirection.startToEnd:
                      print('edit item');
                      updateItem(item);
                      break;
                    default:
                      print('nothing just chill');
                  }
                },
                child: ItemCard(
                  entry: item,
                  deleteItem: deleteItem,
                  updateItem: updateItem,
                  markDone: markDone,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
