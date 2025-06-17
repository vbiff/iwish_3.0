import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/presentation/auth/authentication/auth_provider/auth_provider.dart';

import '../../../../core/theme/app_theme.dart';

import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/text_form_field.dart';
import 'google_apple_auth_buttons.dart';

class LogInTabPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);
    return Column(
      spacing: AppTheme.paddingMain,
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
          color: AppTheme.yellow,
          title: 'Log in',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              auth.loginUser(
                email: emailController.text,
                password: passwController.text,
              );
            }
          },
        )
      ],
    );
  }
}
