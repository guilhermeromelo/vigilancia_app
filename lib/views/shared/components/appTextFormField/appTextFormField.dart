import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class AppTextFormField extends StatelessWidget {
  var _defaultMask = new MaskTextInputFormatter(mask: null, filter: null);

  String initialValue;
  Function onChangedFunction;
  Function validatorFunction;
  TextInputType keyboardInputType;
  String labelText;
  MaskTextInputFormatter inputFormatterField;
  IconData suffixIcon;
  Color suffixIconColor;
  Function suffixIconOnPressed;
  EdgeInsets externalPadding;
  bool autoFocus;
  bool obscureText;
  bool readOnly;
  int minLines;
  int maxLines;
  TextStyle textStyle;
  TextCapitalization textCapitalization;

  TextEditingController _controller = TextEditingController();

  AppTextFormField({Key key,
    this.initialValue,
    this.onChangedFunction,
    this.validatorFunction,
    this.keyboardInputType,
    this.labelText,
    this.inputFormatterField,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixIconOnPressed,
    this.externalPadding,
    this.autoFocus,
    this.obscureText,
    this.readOnly,
    this.minLines,
    this.maxLines,
    this.textStyle,
    this.textCapitalization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return Padding(
      padding: externalPadding ?? EdgeInsets.zero,
      child: TextFormField(
        textCapitalization: textCapitalization ?? TextCapitalization.words,
        minLines: obscureText == null ? minLines ?? 1 : 1,
        maxLines: obscureText == null ? maxLines ?? 2 : 1,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        autofocus: autoFocus ?? false,
        onChanged: onChangedFunction,
        validator: validatorFunction,
        controller: _controller,
        keyboardType: keyboardInputType ?? TextInputType.text,
        style: textStyle ?? TextStyle(fontSize: 18),
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: AppColors.mainBlue,
              fontSize: 20,
            ),
            suffixIcon: (suffixIcon != null) ? IconButton(
              icon: Icon(
                suffixIcon,
                color: suffixIconColor,
                size: 20,
              ),
              onPressed: suffixIconOnPressed,
            ) : null,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.fromLTRB(25, 10, 25, 10),
            errorStyle: TextStyle(
              fontSize: 16,
            )),
        inputFormatters: [inputFormatterField ?? _defaultMask],
      ),
    );
  }
}
