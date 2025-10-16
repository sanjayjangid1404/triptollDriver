import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/color_extension.dart';

class LineTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? right;
  final int minLines;
  final int? count;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final bool readyOnly;

  const LineTextField(
      {super.key,
      required this.title,
      required this.hintText,
      this.controller,
      this.keyboardType,
      this.obscureText,
      this.textCapitalization = TextCapitalization.none,
      this.right,
      this.minLines = 1,
      this.count,
      this.readyOnly = false,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.tr,
          style: TextStyle(color: TColor.placeholder, fontSize: 14),
        ),
        TextField(
          readOnly: readyOnly,
          controller: controller,
          textCapitalization: textCapitalization!,
          keyboardType: keyboardType,
          maxLength: count,
          obscureText: obscureText ?? false,
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            counter: SizedBox(),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            suffixIcon: right,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,

            ),
          ),
        ),
        Container(
          color: TColor.lightGray,
          height: 0.5,
          width: double.maxFinite,
        ),
      ],
    );
  }
}
