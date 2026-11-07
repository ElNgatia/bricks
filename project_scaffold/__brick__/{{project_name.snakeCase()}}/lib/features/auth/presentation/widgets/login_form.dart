import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/constants/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/core/extensions/context_extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/core/widgets/app_card.dart';
import 'package:{{project_name.snakeCase()}}/app/core/widgets/text_input.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/providers/login_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(loginProvider.notifier);
      notifier.setEmail(_emailController.text.trim());
      notifier.setPassword(_passwordController.text);
      notifier.signIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextInput(
              controller: _emailController,
              labelText: context.t.auth.fields.email,
              hintText: context.t.auth.fields.emailHint,
              prefixIcon: const Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return context.t.auth.validation.emailRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextInput(
              controller: _passwordController,
              labelText: context.t.auth.fields.password,
              obscureText: !state.isPasswordVisible,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => ref
                    .read(loginProvider.notifier)
                    .togglePasswordVisibility(),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return context.t.auth.validation.passwordRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: state.isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.t.auth.signIn),
            ),
          ],
        ),
      ),
    );
  }
}

