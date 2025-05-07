import 'package:flutter/material.dart';
import '../../../../../core/ui/styles.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/text_form_field.dart';
import 'google_apple_auth_buttons.dart';

class SignUpTabPage extends StatelessWidget {
  const SignUpTabPage({
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
        const Text('WELCOME'),
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
        IwishTextFormFieldWidget(
          labelText: 'Confirm password',
          validationFunc: (value) {
            if (value != passwController.text) {
              return 'The password you entered is different';
            }
            return null;
          },
        ),
        const Text('or'),
        const GoogeAppleAuthButtons(),
        MainButton(
          color: Colors.grey,
          title: 'Sign up',
          onPressed: () {
            if (_formKey.currentState!.validate()) {}
          },
        ),
      ],
    );
  }
}
