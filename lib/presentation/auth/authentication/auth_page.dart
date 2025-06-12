import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/modern_button.dart';
import '../../../core/widgets/modern_card.dart';
import 'auth_provider/auth_provider.dart';
import 'auth_provider/auth_notifier.dart' as auth;

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoginPasswordVisible = false;
  bool _isSignupPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Timer? _authCheckTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _authCheckTimer?.cancel();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startAuthCheck() {
    _authCheckTimer?.cancel();
    _authCheckTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        print('[AUTH PAGE] Session detected, navigating to home');
        timer.cancel();
        if (mounted) {
          context.router.replace(const TabsRoute());
        }
      }
    });

    // Stop checking after 10 seconds
    Timer(const Duration(seconds: 10), () {
      _authCheckTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for auth state changes
    ref.listen<auth.AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showErrorSnackBar(next.error!);
          ref.read(authProvider.notifier).clearError();
        });
      }

      if (next.isAuthenticated && next.user != null) {
        print('[AUTH PAGE] User authenticated, starting auth check');
        _startAuthCheck();
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacing3xl,
                      AppTheme.spacing4xl,
                      AppTheme.spacing3xl,
                      AppTheme.spacing3xl,
                    ),
                    child: Column(
                      children: [
                        // App Icon
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing2xl),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radius2xl),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing2xl),

                        // App Title
                        Text(
                          'I Wish',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),

                        // Subtitle
                        Text(
                          'Make your dreams come true',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // Modern Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing3xl),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (_) {
                        // Clear error when switching tabs
                        ref.read(authProvider.notifier).clearError();
                      },
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding:
                          const EdgeInsets.all(AppTheme.spacingXs),
                      dividerColor: Colors.transparent,
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacing2xl),

                  // Content Area
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingLg),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radius2xl),
                          topRight: Radius.circular(AppTheme.radius2xl),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, -10),
                          ),
                        ],
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLoginTab(authState),
                          _buildSignUpTab(authState),
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

  Widget _buildLoginTab(auth.AuthState authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing3xl),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Sign in to continue your wishlist journey',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing3xl),

            // Email Field
            _buildFieldLabel('Email'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildEmailField(_loginEmailController, 'Enter your email'),
            const SizedBox(height: AppTheme.spacing2xl),

            // Password Field
            _buildFieldLabel('Password'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildPasswordField(
              _loginPasswordController,
              'Enter your password',
              _isLoginPasswordVisible,
              () => setState(
                  () => _isLoginPasswordVisible = !_isLoginPasswordVisible),
            ),
            const SizedBox(height: AppTheme.spacing3xl),

            // Login Button
            ModernButton.primary(
              onPressed: authState.isLoading ? null : _handleLogin,
              fullWidth: true,
              gradient: AppTheme.primaryGradient,
              isLoading: authState.isLoading,
              child: Text(authState.isLoading ? 'Signing in...' : 'Login'),
            ),

            const SizedBox(height: AppTheme.spacing2xl),

            // Forgot Password
            Center(
              child: ModernButton.ghost(
                onPressed: authState.isLoading
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Forgot password feature coming soon!'),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                          ),
                        );
                      },
                child: const Text('Forgot Password?'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpTab(auth.AuthState authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing3xl),
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create Account Header
            Text(
              'Create Account',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Join us and start building your wishlist',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing3xl),

            // Email Field
            _buildFieldLabel('Email'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildEmailField(_signupEmailController, 'Enter your email'),
            const SizedBox(height: AppTheme.spacing2xl),

            // Password Field
            _buildFieldLabel('Password'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildPasswordField(
              _signupPasswordController,
              'Create a password',
              _isSignupPasswordVisible,
              () => setState(
                  () => _isSignupPasswordVisible = !_isSignupPasswordVisible),
            ),
            const SizedBox(height: AppTheme.spacing2xl),

            // Confirm Password Field
            _buildFieldLabel('Confirm Password'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildConfirmPasswordField(),
            const SizedBox(height: AppTheme.spacing3xl),

            // Sign Up Button
            ModernButton.primary(
              onPressed: authState.isLoading ? null : _handleSignUp,
              fullWidth: true,
              gradient: AppTheme.primaryGradient,
              isLoading: authState.isLoading,
              child:
                  Text(authState.isLoading ? 'Creating account...' : 'Sign Up'),
            ),

            const SizedBox(height: AppTheme.spacing2xl),

            // Terms and Privacy
            Center(
              child: Text(
                'By signing up, you agree to our Terms of Service and Privacy Policy',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  Widget _buildEmailField(TextEditingController controller, String hint) {
    return ModernCard(
      padding: EdgeInsets.zero,
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!value.contains('@')) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool isVisible,
    VoidCallback onToggle,
  ) {
    return ModernCard(
      padding: EdgeInsets.zero,
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return ModernCard(
      padding: EdgeInsets.zero,
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: !_isConfirmPasswordVisible,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Confirm your password',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _signupPasswordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      ref.read(authProvider.notifier).loginUser(
            email: _loginEmailController.text.trim(),
            password: _loginPasswordController.text,
          );
    }
  }

  void _handleSignUp() {
    if (_signupFormKey.currentState!.validate()) {
      ref.read(authProvider.notifier).signUpUser(
            email: _signupEmailController.text.trim(),
            password: _signupPasswordController.text,
          );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        margin: const EdgeInsets.all(AppTheme.spacingLg),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
