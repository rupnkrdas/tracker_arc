import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:glassmorphism/glassmorphism.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;
  final Function()? onTap;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            const SizedBox(
              width: 5,
            ),
            // settings option
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.blueGrey.shade800,
              foregroundColor: Colors.white,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(
              width: 5,
            ),

            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 50,
            borderRadius: 10,
            blur: 50,
            alignment: Alignment.bottomCenter,
            border: 0.05,
            linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFffffff).withOpacity(0.1),
                  const Color(0xFFFFFFFF).withOpacity(0.05),
                ],
                stops: const [
                  0.1,
                  1,
                ]),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffffff).withOpacity(0.5),
                const Color((0xFFFFFFFF)).withOpacity(0.5),
              ],
            ),
            child: Row(
              children: [
                // checkbox
                Checkbox(
                  value: habitCompleted,
                  onChanged: onChanged,
                  checkColor: Colors.green,
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),

                // habit name
                Text(
                  habitName,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
