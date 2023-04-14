import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    this.entry,
    this.deleteItem,
    this.updateItem,
  });

  final Map<String, dynamic>? entry;
  final Function? deleteItem;
  final Function? updateItem;

  @override
  Widget build(BuildContext context) {
    if (entry?['task'] == null || entry?['task'] == "") {
      return const SizedBox();
    }
    return Card(
      key: key,
      child: Container(
        color: const Color.fromARGB(255, 210, 243, 243),
        padding: const EdgeInsets.all(12.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(child: Text(entry?['task'] ?? "")),
          Row(
            children: [
              IconButton(
                  onPressed: () => updateItem!(entry as Map<String, dynamic>),
                  icon: const Icon(
                    Icons.edit,
                    size: 20.0,
                    color: Color.fromARGB(235, 3, 10, 63),
                  )),
              IconButton(
                  onPressed: () => deleteItem!(entry?['document']),
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(235, 3, 10, 63),
                    size: 20.0,
                  ))
            ],
          )
        ]),
      ),
    );
  }
}