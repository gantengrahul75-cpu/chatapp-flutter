import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/repository_providers.dart';
import '../../core/utils/snackbar_util.dart';
import '../../features/widgets/custom_button.dart';
import '../../features/widgets/custom_text_field.dart';
import '../../features/widgets/user_avatar.dart';

/// Profile Screen
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() => _isUpdating = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateUserProfile(
        currentUser.userId,
        {
          'username': _usernameController.text,
          'email': _emailController.text,
        },
      );

      if (mounted) {
        showSuccessSnackbar(context, 'Profile updated successfully');
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _logout() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.logout();

      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              if (!_isEditing) {
                // Load user data into controllers
                if (currentUserAsync != null) {
                  _usernameController.text = currentUserAsync.username;
                  _emailController.text = currentUserAsync.email;
                }
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: currentUserAsync == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  Center(
                    child: UserAvatar(
                      username: currentUserAsync.username,
                      photoUrl: currentUserAsync.photoUrl,
                      isOnline: currentUserAsync.isOnline,
                      size: 120,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Info Card
                  Card(
                    elevation: 0,
                    color: AppColors.greyLight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User ID',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.grey),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            currentUserAsync.userId,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Joined Date',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${currentUserAsync.createdAt.day}/${currentUserAsync.createdAt.month}/${currentUserAsync.createdAt.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Editable Fields
                  if (_isEditing) ...[]
                  CustomTextField(
                    label: 'Username',
                    controller: _usernameController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  if (_isEditing) ...[]
                  CustomButton(
                    text: 'Update Profile',
                    onPressed: _updateProfile,
                    isLoading: _isUpdating,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: AppStrings.logoutButton,
                    onPressed: _logout,
                    backgroundColor: AppColors.error,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
    );
  }
}

extension on TextEditingController {
  set enabled(bool value) {}
}
