import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? colorForButton;
  final String text;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.colorForButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorForButton,
              textStyle: const TextStyle(color: Colors.white60),
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }
}
