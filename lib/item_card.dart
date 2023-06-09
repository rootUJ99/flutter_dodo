import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    this.entry,
    this.deleteItem,
    this.updateItem,
    this.markDone,
  });

  final Map<String, dynamic>? entry;
  final Function? deleteItem;
  final Function? updateItem;
  final Function? markDone;

  @override
  Widget build(BuildContext context) {
    if (entry?['task'] == null || entry?['task'] == "") {
      return const SizedBox();
    }
    return Card(
      key: key,
      child: Container(
        color: (entry!.containsKey('done') && entry!.containsValue(true))
            ? const Color.fromARGB(255, 221, 243, 210)
            : const Color.fromARGB(255, 210, 243, 243),
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () => markDone!(entry, !entry!['done']),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(
                entry?['task'] ?? "",
                style: TextStyle(
                    fontSize: 18.0,
                    decoration: (entry!.containsKey('done') &&
                            entry!.containsValue(true))
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
            // Row
          ]),
        ),
      ),
    );
  }
}
