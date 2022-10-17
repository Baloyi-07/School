import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stock/models/todo.dart';
import 'package:stock/routes/routes.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.todo,
    required this.deleteAction,
    required this.todoToggleAction,
  }) : super(key: key);
  final Todo todo;
  final Function() deleteAction;
  final Function(bool? value) todoToggleAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: 'Delete',
              color: Colors.purple[600],
              icon: Icons.delete,
              onTap: deleteAction,
            ),
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Picture'),
                  Column(
                    children: [
                      Text(
                        'Warehouse name: ${todo.title}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Warehouse Location:',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Select a catagory:',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Number of Items:'),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Edit'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      child: Text('View Items'),
                      onPressed: () {
                          Navigator.of(context).pushNamed(RouteManager.itemPage);
                      },
                    ),
                  )
                ],
              )
            ],
          )

          //  CheckboxListTile(
          //   checkColor: Colors.purple,
          //   activeColor: Colors.purple[100],
          //   value: todo.done,
          //   onChanged: todoToggleAction,
          //   subtitle: Text(
          //     '${todo.created.day}/${todo.created.month}/${todo.created.year}',
          //     style: TextStyle(color: Colors.white, fontSize: 10),
          //   ),
          //   title: Text(
          //     todo.title,
          //     style: TextStyle(
          //       color: Colors.white,
          //       decoration:
          //           todo.done ? TextDecoration.lineThrough : TextDecoration.none,
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
