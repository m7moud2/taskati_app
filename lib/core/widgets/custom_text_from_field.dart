import 'package:flutter/material.dart';
import 'package:taskati_app/core/utils/text_style.dart';

// ignore: must_be_immutable
class CustomTextFromField extends StatelessWidget {
   CustomTextFromField({
    super.key,
    required this.text,
    this.controller,
    this.readOnly,
    this.widget,
    this.maxLines,
    this.onTap,
    this.width,
    this.hint,
     this.validator
  });
  final TextEditingController? controller;
  final String text;
  final String? hint;
  final bool? readOnly;
  final Widget? widget;
  final int? maxLines;
  final double? width;
  final Function()? onTap;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: getBodyStyle(context,fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: width ?? double.infinity,
          child: TextFormField(
            validator: validator ,
            maxLines: maxLines ?? 1,
            readOnly: readOnly ?? false,
            controller: controller,
            decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: onTap,
                  child: widget ?? const SizedBox(),
                ),
                hintText:
                    (hint == null) ? 'Enter ${text.toLowerCase()} here' : hint),
          ),
        )
      ],
    );
  }
}