import 'package:app_ui/app_ui.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/login/bloc/login_bloc.dart';

/// Sign-in screen. Provides [LoginBloc] and delegates rendering to [LoginView].
class LoginPage extends StatelessWidget {
  /// Creates the [LoginPage].
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(authRepository: context.read<AuthRepository>()),
      child: const LoginView(),
    );
  }
}

/// Sign-in form. Public so widget tests can inject a scripted [LoginBloc].
class LoginView extends StatefulWidget {
  /// Creates the [LoginView].
  const LoginView({super.key});

  /// Key on the screen heading.
  ///
  /// The heading and the submit button carry the same English copy, so a text
  /// finder cannot tell them apart — tests match the heading by this key.
  static const headingKey = Key('loginView_heading');

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() => context.read<LoginBloc>().add(
    LoginEvent.submitted(
      email: _emailController.text,
      password: _passwordController.text,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(context.spacing.large),
            child: BlocConsumer<LoginBloc, LoginState>(
              listenWhen: (_, current) =>
                  current is LoginStateFailure ||
                  current is LoginStateUnexpectedFailure,
              listener: (context, state) => ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      state is LoginStateUnexpectedFailure
                          ? context.l10n.loginUnexpectedError
                          : context.l10n.loginFailed,
                    ),
                  ),
                ),
              builder: (context, state) {
                final isLoading = state is LoginStateLoading;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.loginTitle,
                      key: LoginView.headingKey,
                      style: context.text.headlineMedium,
                    ),
                    SizedBox(height: context.spacing.xlarge),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: context.l10n.loginEmailLabel,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: context.spacing.medium),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: context.l10n.loginPasswordLabel,
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: context.spacing.xlarge),
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? SizedBox.square(
                              dimension: context.sizes.inlineProgressIndicator,
                              child: CircularProgressIndicator(
                                strokeWidth: context.sizes.inlineProgressStroke,
                              ),
                            )
                          : Text(context.l10n.loginButton),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
