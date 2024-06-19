import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigate;
  final Function(String) deleteById;
  const ToDoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigate,
      required this.deleteById});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        //
        title: Text(item['title']),
        subtitle: Text(item['description']),
        //les trois petit points pour le menu
        trailing: PopupMenuButton(
          //la variable se refere à la valeur de la propriete value dans les PopupMenuItem
          onSelected: (value) {
            switch (value) {
              case 'edit':
                navigate(item);
                break;
              case 'delete':
                deleteById(id);
                break;
              default:
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
