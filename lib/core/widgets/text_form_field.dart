import 'package:flutter/material.dart';

import '../ui/styles.dart';

class IwishTextFormFieldWidget extends StatelessWidget {
  const IwishTextFormFieldWidget({
    super.key,
    TextEditingController? controller,
    required String labelText,
    FormFieldValidator? validationFunc,
  })  : _controller = controller,
        _labelText = labelText,
        _validationFunc = validationFunc;

  final TextEditingController? _controller;
  final String _labelText;
  final FormFieldValidator? _validationFunc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: _validationFunc,
      cursorColor: AppStyles.secondaryColor,
      decoration: InputDecoration(
        labelText: _labelText,
        labelStyle: AppStyles.textStyleSoFoSans,
        fillColor: AppStyles.primaryColor,
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
      ),
    );
  }
}
