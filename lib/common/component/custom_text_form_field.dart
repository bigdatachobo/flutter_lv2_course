import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool AUTOFOCUS;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.AUTOFOCUS = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: inputBorderColor,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: primaryColor,
      // 비밀번호 입력할때
      obscureText: obscureText,
      autofocus: AUTOFOCUS,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: bodyTextColor,
          fontSize: 14.0,
        ),
        fillColor: inputBGColor,
        // false - 배경색 없음
        // true - 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
