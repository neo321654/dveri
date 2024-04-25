import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final List color;
  final String text;
  final Widget icon;

  const Button({
    this.color = const [255, 244, 67, 54],
    this.text = 'Подробнее',
    this.icon = const Icon(
      Icons.arrow_circle_right_outlined,
      color: Colors.white,
    ),
    super.key
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Color.fromARGB(
          widget.color[0],
          widget.color[1],
          widget.color[2],
          widget.color[3],
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon,
          const SizedBox(width: 6,),
          Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}