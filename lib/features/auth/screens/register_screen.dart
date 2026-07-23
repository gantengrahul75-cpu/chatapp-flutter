import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/string_util.dart';
import '../../core/utils/snackbar_util.dart';
import '../../core/providers/repository_providers.dart';
import '../../features/widgets/custom_text_field.dart';
import '../../features/widgets/custom_button.dart';

/// Register Screen
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _usernameAvailable = false;
  bool _checkingUsername = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkUsername(String username) async {
    if (username.isEmpty || !StringUtil.isValidUsername(username)) {
      setState(() => _usernameAvailable = false);
      return;
    }

    setState(() => _checkingUsername = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final available = await authRepo.checkUsernameAvailable(username);
      setState(() {
        _usernameAvailable = available;
        _checkingUsername = false;
      });
    } catch (e) {
      setState(() => _checkingUsername = false);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_usernameAvailable) {
      showErrorSnackbar(context, 'Username is not available');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.register(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
      );

      if (mounted) {
        showSuccessSnackbar(context, 'Registration successful!');
        context.go('/chats');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  AppStrings.registerTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.registerSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: AppStrings.usernameLabel,
                  hint: 'username123',
                  controller: _usernameController,
                  prefixIcon: const Icon(Icons.person),
                  onChanged: _checkUsername,
                  suffixIcon: _checkingUsername
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(
                          _usernameAvailable
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _usernameAvailable
                              ? AppColors.success
                              : AppColors.error,
                        ),
                  validator: (value) {
                    if (StringUtil.isEmpty(value)) {
                      return 'Username is required';
                    }
                    if (!StringUtil.isValidUsername(value!)) {
                      return 'Username must be 3-20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.emailLabel,
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    if (StringUtil.isEmpty(value)) {
                      return 'Email is required';
                    }
                    if (!StringUtil.isValidEmail(value!)) {
                      return 'Email is not valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.passwordLabel,
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    if (StringUtil.isEmpty(value)) {
                      return 'Password is required';
                    }
                    if (!StringUtil.isValidPassword(value!)) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.confirmPasswordLabel,
                  hint: '••••••••',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    if (StringUtil.isEmpty(value)) {
                      return 'Confirm password is required';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppStrings.registerButton,
                  onPressed: _register,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(AppStrings.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
