import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/widgets/ensure_visible.dart.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final Function validator;
  final isPassword;
  InputField(
      {@required this.focusNode,
      @required this.hint,
      @required this.validator,
      @required this.controller,
      @required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              borderSide: BorderSide(color: black),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              borderSide: BorderSide(color: black),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                borderSide: BorderSide(color: Colors.red),
                gapPadding: 100),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              borderSide: BorderSide(color: black),
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
