import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_evdekimi_app/common/di/service_locator.dart';
import 'package:flutter_evdekimi_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/register_bloc.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/register_event.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/register_state.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/register_ui_cubit.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RegisterBloc(authRepository: getIt<IAuthRepository>()),
        ),
        BlocProvider(create: (_) => RegisterUiCubit()),
      ],
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
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
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state case RegisterSuccess()) {
              _showSnackBar(
                'Registration success! Please login.',
                AppColor.greenSnackBar,
              );
              Navigator.of(context).pop();
            } else if (state case RegisterFailure()) {
              _showSnackBar(
                state.error.message ?? 'Registration failed',
                AppColor.error,
              );
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing20,
                  AppSpacing.spacing36,
                  AppSpacing.spacing20,
                  AppSpacing.spacing20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 52,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeader(
                          title: 'Create account',
                          subtitle: 'Fill in your details to get started',
                        ),
                        const SizedBox(height: AppSpacing.spacing30),
                        AuthTextField(
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: AppColor.neutralAltOf(context),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Full name is required'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.spacing20),
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
                        AuthTextField(
                          label: 'Phone Number',
                          hint: 'Enter your phone number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: AppColor.neutralAltOf(context),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!RegExp(r'^[0-9+()\- ]+$').hasMatch(value)) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.spacing20),
                        BlocBuilder<RegisterUiCubit, bool>(
                          builder: (context, isObscured) => AuthTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            obscureText: isObscured,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.neutralAltOf(context),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => context
                                  .read<RegisterUiCubit>()
                                  .togglePasswordVisibility(),
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColor.neutralOf(context),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing20),
                        BlocBuilder<RegisterUiCubit, bool>(
                          builder: (context, isObscured) => AuthTextField(
                            label: 'Confirm Password',
                            hint: 'Re-enter your password',
                            controller: _confirmPasswordController,
                            obscureText: isObscured,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.neutralAltOf(context),
                            ),
                            onFieldSubmitted: (_) => _onRegisterPressed(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing30),
                        _buildRegisterButton(state),
                        const SizedBox(height: AppSpacing.spacing16),
                        _buildLoginText(),
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

  Widget _buildRegisterButton(RegisterState state) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: state is RegisterLoading ? null : _onRegisterPressed,
        child: state is RegisterLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: AppSpacing.spacing8),
                  Text('Register'),
                  Icon(Icons.arrow_forward_rounded, size: 22),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyle.bodyMedium.apply(
            color: AppColor.textSecondaryOf(context),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text(
            'Login now',
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
