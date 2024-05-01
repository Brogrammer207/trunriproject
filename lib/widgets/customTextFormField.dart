import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'appTheme.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool? obSecure;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onEditingCompleted;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isMulti;
  final bool autofocus;
  final bool enabled;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefix;
  // final int? minLines;
  // final int? maxLines;

  final List<TextInputFormatter>? inputFormatters;

  const CommonTextField({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obSecure,
    this.onTap,
    this.isMulti = false,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    required this.hintText,
    this.suffixIcon,
    this.prefix,
    this.enabled = true,
    this.onEditingCompleted,
    this.onChanged,
    this.onSaved,
    this.labelText,
    this.inputFormatters,
    this.onFieldSubmitted,
    // this.maxLines,
    // this.minLines
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
      ),
      child: TextFormField(
          style: GoogleFonts.poppins(),
          autofocus: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingCompleted,
          obscureText: widget.obSecure ?? false,
          // minLines: minLines,
          // maxLines: maxLines,
          onTap: widget.onTap,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          controller: widget.controller,

          decoration: InputDecoration(
            counterStyle: GoogleFonts.poppins(
              color: AppTheme.primaryColor,
              fontSize: 25,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 15,
            ),
            counter: const Offstage(),
            fillColor: Colors.white,
            filled: true,
            errorMaxLines: 2,
            enabled: widget.enabled,
            hintText: widget.hintText,
            errorText: widget.errorText,
            labelText: widget.labelText,
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffixIcon,
            hintStyle: const TextStyle(
              color: Colors.black45,
              fontSize: 19,
            ),


            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppTheme.secondaryColor)),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppTheme.secondaryColor)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppTheme.secondaryColor)),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),

          ),
          validator: widget.validator),
    );
  }
}
