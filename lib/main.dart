import 'package:flutter/material.dart';

void main() {
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

  void addItem(value) => {
        // print("hola gamasta $value");
        if (value != "")
          {
            setState(() {
              _text = [..._text, value];
            }),
            textController.clear()
          },
        // print(_text)
      };

  void deleteItem(val, index) => {
        _text.removeAt(index),
        setState(
          () {},
        )
      };

  @override
  Widget build(BuildContext context) {
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
            ..._text.asMap().entries.map((entry) {
              int index = entry.key;
              String val = entry.value;
              return Card(
                key: UniqueKey(),
                child: Container(
                  color: const Color.fromARGB(255, 210, 243, 243),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(val),
                        IconButton(
                            onPressed: () => deleteItem(val, index),
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
  }
}
