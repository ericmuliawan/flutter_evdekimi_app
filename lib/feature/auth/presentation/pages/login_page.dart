import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_evdekimi_app/common/di/service_locator.dart';
import 'package:flutter_evdekimi_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/login_event.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/login_state.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/login_ui_cubit.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/pages/register_page.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_evdekimi_app/feature/home/presentation/pages/home_page.dart';
import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(authRepository: getIt<IAuthRepository>()),
        ),
        BlocProvider(create: (_) => LoginUiCubit()),
      ],
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showSnackBar(String message, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state case LoginSuccess()) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            } else if (state case LoginFailure()) {
              _showSnackBar(
                state.error.message ?? 'Login gagal',
                AppColor.error,
              );
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing20,
                  AppSpacing.spacing40,
                  AppSpacing.spacing20,
                  AppSpacing.spacing20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 60,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeader(
                          title: 'Welcome back!',
                          subtitle: 'Login to continue using EVDEKimi',
                        ),
                        const SizedBox(height: AppSpacing.spacing36),
                        AuthTextField(
                          label: 'Email',
                          hint: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: AppColor.neutralAltOf(context),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.spacing20),
                        BlocBuilder<LoginUiCubit, bool>(
                          builder: (context, isObscured) => AuthTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            obscureText: isObscured,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            trailing: GestureDetector(
                              onTap: () {
                                _showSnackBar(
                                  'Forgot password feature coming soon',
                                  AppColor.textSecondary,
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: AppTextStyle.bodySmall.apply(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeightDelta: 2,
                                ),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.neutralAltOf(context),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => context
                                  .read<LoginUiCubit>()
                                  .togglePasswordVisibility(),
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColor.neutralOf(context),
                              ),
                            ),
                            onFieldSubmitted: (_) => _onLoginPressed(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing30),
                        _buildLoginButton(state),
                        const SizedBox(height: AppSpacing.spacing16),
                        _buildRegisterText(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginState state) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: state is LoginLoading ? null : _onLoginPressed,
        child: state is LoginLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: AppSpacing.spacing8),
                  Text('Login'),
                  Icon(Icons.arrow_forward_rounded, size: 22),
                ],
              ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyle.bodyMedium.apply(
            color: AppColor.textSecondaryOf(context),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const RegisterPage())),
          child: Text(
            'Register now',
            style: AppTextStyle.bodyMedium.apply(
              color: Theme.of(context).colorScheme.primary,
              fontWeightDelta: 3,
            ),
          ),
        ),
      ],
    );
  }
}
