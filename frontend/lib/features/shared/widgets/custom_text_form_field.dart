import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? icon;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(30);

    return Container(
      height: 50.rh(context),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(borderRadius),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.rw(context)),
            child: icon ??
                SizedBox(
                  width: 0,
                ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: onChanged,
              validator: validator,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: TextStyle(fontSize: 14.rf(context), color: Colors.black54),
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.rf(context)),
                enabledBorder: border,
                focusedBorder: border,
                errorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
                focusedErrorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
                isDense: true,
                label: label != null
                    ? Text(
                        label!,
                        style: TextStyle(fontSize: 14.rf(context)),
                      )
                    : null,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: 12.rf(context),
                    color: Colors.black54,
                    fontWeight: FontWeight.w300),
                errorText: errorMessage,
                focusColor: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
