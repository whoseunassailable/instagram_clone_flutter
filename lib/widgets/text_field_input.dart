import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  late String inputtedValue;
  final String errorTextMessage;
  bool obscureText = false;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? trailingImage;

  TextFieldWidget(
      {Key? key,
      required this.errorTextMessage,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.keyboardType,
      this.trailingImage})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    Logger logger = Logger(printer: PrettyPrinter(colors: true));

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    );

    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.errorTextMessage;
        }
        return null;
      },
      // onChanged: widget.onChanged,
      // onSaved: widget.onSaved,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white60),
        border: outlineInputBorder,
        filled: true,
        fillColor: const Color(0XFF353535),
        enabledBorder: outlineInputBorder,
        focusColor: Colors.grey,
        focusedErrorBorder: outlineInputBorder,
        hoverColor: Colors.grey,
        suffixIcon: widget.trailingImage,
      ),
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
    );
  }
}
