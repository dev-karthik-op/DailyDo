import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {

  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              // edit option
              SlidableAction(
                onPressed: editHabit,
                backgroundColor: Colors.grey.shade800, // color of edit button
                icon: Icons.edit,
                borderRadius: BorderRadius.circular(8),
              ),
              // delete option
              SlidableAction(
                onPressed: deleteHabit,
                backgroundColor: Colors.red, // color of delete button
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
        ),
        child: GestureDetector(
          onTap: (){
            if(onChanged != null) {
              // toggle completed status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.indigo  // Color of the Completed habits
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  color: isCompleted
                      ? Colors.white
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              leading: Checkbox(
                activeColor: Colors.indigo.shade700, // color of mark
                  value: isCompleted,
                  onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
