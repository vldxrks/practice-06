import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_model.dart';
import '../services/fake_api.dart';
import '../widgets/build_probe.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    BuildProbe.hit('LoginScreen');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person_outline, size: 32),
                    ),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Особистий\nпростір',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Увійдіть, щоб переглянути й оновити свій профіль.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 28),
                  LoginForm(),
                  SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'НАВЧАЛЬНИЙ АКАУНТ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          SelectableText(
                            '${FakeApi.demoEmail}\n${FakeApi.demoPassword}',
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Дані діють лише в цьому демонстраційному застосунку.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _visible = false;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthModel>();
    await auth.signIn(_email.text, _password.text);
    // Keep credentials only in this ephemeral form for an explicit retry.
    // Controllers are disposed as soon as AuthGate removes the login page.
  }

  @override
  Widget build(BuildContext context) {
    BuildProbe.hit('LoginForm');
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            validator: AuthModel.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('password'),
            controller: _password,
            obscureText: !_visible,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Пароль',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                key: const Key('show-password'),
                tooltip: _visible ? 'Приховати пароль' : 'Показати пароль',
                onPressed: () => setState(() => _visible = !_visible),
                icon: Icon(
                  _visible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            validator: AuthModel.validatePassword,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          const AuthFeedback(),
          LoginAction(onSubmit: _submit),
        ],
      ),
    );
  }
}

class AuthFeedback extends StatelessWidget {
  const AuthFeedback({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthModel>();
    BuildProbe.hit('AuthFeedback');
    if (auth.error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        auth.error!,
        key: const Key('auth-error'),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        semanticsLabel: 'Помилка входу: ${auth.error}',
      ),
    );
  }
}

class LoginAction extends StatelessWidget {
  const LoginAction({super.key, required this.onSubmit});
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) => Consumer<AuthModel>(
    child: const Icon(Icons.arrow_forward, size: 20),
    builder: (context, auth, child) {
      BuildProbe.hit('LoginAction');
      return FilledButton(
        key: const Key('login'),
        onPressed: auth.isLoading ? null : onSubmit,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 17),
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(auth.error == null ? 'Увійти' : 'Повторити'),
                  const SizedBox(width: 12),
                  child!,
                ],
              ),
      );
    },
  );
}
