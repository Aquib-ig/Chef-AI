import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:chef_ai/core/themes/theme_cubit.dart';
import 'package:chef_ai/features/models/user_model.dart';
import 'package:chef_ai/features/models/user_service.dart';
import 'package:chef_ai/features/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:chef_ai/features/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool notificationsEnabled = true;
  bool emailNotifications = false;
  bool pushNotifications = true;

  final UserService _userService = UserService();
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _userService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _currentUser = userData;
        _isLoading = false;
      });
    }
  }

  void _onSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text('Signing out...'),
                    ],
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.errorColor,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final themeCubit = context.read<ThemeCubit>();
          final isDark = themeCubit.isDarkModeActive(context);

          return Scaffold(
            body: GradientContainer(
              isDark: isDark,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(isDark),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Account Section
                            _buildSectionTitle('Account', isDark),
                            const SizedBox(height: 16),
                            _buildSettingsCard(isDark, [
                              _buildSettingsTile(
                                icon: Icons.person_outline,
                                title: 'Edit Profile',
                                subtitle: 'Change your personal information',
                                onTap: () {},
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSettingsTile(
                                icon: Icons.lock_outline,
                                title: 'Change Password',
                                subtitle: 'Update your account password',
                                onTap: () {},
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSettingsTile(
                                icon: Icons.email_outlined,
                                title: 'Email Settings',
                                subtitle: 'Manage email preferences',
                                onTap: () {},
                                isDark: isDark,
                              ),
                            ]),
                            const SizedBox(height: 24),

                            // Preferences Section
                            _buildSectionTitle('Preferences', isDark),
                            const SizedBox(height: 16),
                            _buildSettingsCard(isDark, [
                              _buildSwitchTile(
                                icon: Icons.dark_mode_outlined,
                                title: 'Dark Mode',
                                subtitle: 'Switch between light and dark theme',
                                value: isDark,
                                onChanged: (value) {
                                  themeCubit.toggleTheme();
                                },
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSwitchTile(
                                icon: Icons.notifications_outlined,
                                title: 'Push Notifications',
                                subtitle: 'Receive recipe updates and alerts',
                                value: pushNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    pushNotifications = value;
                                  });
                                },
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSwitchTile(
                                icon: Icons.mail_outline,
                                title: 'Email Notifications',
                                subtitle: 'Get recipe newsletters',
                                value: emailNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    emailNotifications = value;
                                  });
                                },
                                isDark: isDark,
                              ),
                            ]),
                            const SizedBox(height: 24),

                            // App Settings Section
                            _buildSectionTitle('App Settings', isDark),
                            const SizedBox(height: 16),
                            _buildSettingsCard(isDark, [
                              _buildSettingsTile(
                                icon: Icons.language_outlined,
                                title: 'Language',
                                subtitle: 'English (US)',
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                                onTap: () {},
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSettingsTile(
                                icon: Icons.storage_outlined,
                                title: 'Clear Cache',
                                subtitle: 'Free up storage space',
                                onTap: () {},
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSettingsTile(
                                icon: Icons.backup_outlined,
                                title: 'Backup & Sync',
                                subtitle: 'Sync your saved recipes',
                                onTap: () {},
                                isDark: isDark,
                              ),
                            ]),
                            const SizedBox(height: 24),

                            // Support Section
                            _buildSectionTitle('Support', isDark),
                            const SizedBox(height: 16),
                            _buildSettingsCard(isDark, [
                              _buildSettingsTile(
                                icon: Icons.help_outline,
                                title: 'Help Center',
                                subtitle: 'Get help and support',
                                onTap: () {},
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSettingsTile(
                                icon: Icons.feedback_outlined,
                                title: 'Send Feedback',
                                subtitle: 'Share your thoughts with us',
                                onTap: () {},
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildSettingsTile(
                                icon: Icons.info_outline,
                                title: 'About',
                                subtitle: 'App version 1.0.0',
                                onTap: () {},
                                isDark: isDark,
                              ),
                            ]),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? AppColors.darkWarmGradient
              : AppColors.lightWarmGradient,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Profile & Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: _onSignOut,
                icon: Icon(
                  Icons.logout,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                tooltip: 'Sign Out',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // User Profile Information
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Row(
              children: [
                Stack(
                  children: [
                    // Profile Picture or Initial
                    _currentUser?.profilePicUrl != null &&
                            _currentUser!.profilePicUrl!.isNotEmpty
                        ? CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              _currentUser!.profilePicUrl!,
                            ),
                            backgroundColor: isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceLight,
                          )
                        : CircleAvatar(
                            radius: 45,
                            backgroundColor: isDark
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                            child: Text(
                              _currentUser?.name.isNotEmpty == true
                                  ? _currentUser!.name
                                        .substring(0, 1)
                                        .toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                    // Camera Icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceLight,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser?.name ?? 'User Name',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser?.email ?? 'user@example.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member since ${_formatDate(_currentUser?.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Recently';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // All your existing helper methods remain the same...
  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                .withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDark
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isDark
                ? AppColors.primaryDark
                : AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: (isDark ? AppColors.borderDark : AppColors.borderLight)
          .withOpacity(0.3),
    );
  }
}
