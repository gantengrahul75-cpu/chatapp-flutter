import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Custom Text Field Widget
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
