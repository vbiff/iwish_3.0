import 'package:flutter/material.dart';

import '../../../../../core/ui/styles.dart';

import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/text_form_field.dart';
import 'google_apple_auth_buttons.dart';

class LogInTabPage extends StatelessWidget {
  const LogInTabPage({
    super.key,
    required this.emailController,
    required this.passwController,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final TextEditingController emailController;
  final TextEditingController passwController;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppStyles.paddingMain,
      children: [
        const Text('WELCOME BACK!'),
        const SizedBox(
          height: 16.0,
        ),
        IwishTextFormFieldWidget(
          controller: emailController,
          labelText: 'email',
          validationFunc: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        IwishTextFormFieldWidget(
          controller: passwController,
          labelText: 'Password',
          validationFunc: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 16,
        ),
        const Text('or'),
        const SizedBox(
          height: 16,
        ),
        const GoogeAppleAuthButtons(),
        MainButton(
          color: AppStyles.yellow,
          title: 'Log in',
          onPressed: () {
            if (_formKey.currentState!.validate()) {}
          },
        )
      ],
    );
  }
}
