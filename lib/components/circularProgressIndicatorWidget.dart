import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double? value;

  const CircularProgressIndicatorWidget({
    this.value,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        color: Colors.red,
        value: value
      ),
    );
  }
}