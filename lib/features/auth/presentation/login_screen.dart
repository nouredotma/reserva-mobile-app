import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _saving = false;
  bool _isSignUp = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseText = Theme.of(context).textTheme;

    return AppScaffold(
      title: '',
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isSignUp ? 'Create an account' : 'Welcome back',
                    textAlign: TextAlign.center,
                    style: baseText.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isSignUp
                        ? 'Sign up to start booking your experiences.'
                        : 'Sign in to continue with bookings.',
                    textAlign: TextAlign.center,
                    style: baseText.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_isSignUp) ...<Widget>[
                    _FieldLabel(label: 'Full name'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: _authInputDecoration(hint: 'John Doe'),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    _FieldLabel(label: 'Phone'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: _authInputDecoration(hint: '+212 600 000 000'),
                      validator: (value) => (value == null || value.trim().length < 8)
                          ? 'Invalid phone'
                          : null,
                    ),
                    const SizedBox(height: 10),
                  ],
                  _FieldLabel(label: 'Email'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _authInputDecoration(hint: 'name@example.com'),
                    validator: (value) => (value == null || !value.contains('@'))
                        ? 'Invalid email'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  _FieldLabel(label: 'Password'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: _authInputDecoration(hint: '••••••••'),
                    validator: (value) => (value == null || value.trim().length < 6)
                        ? 'At least 6 characters'
                        : null,
                  ),
                  if (_isSignUp) ...<Widget>[
                    const SizedBox(height: 10),
                    _FieldLabel(label: 'Confirm password'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _confirmPasswordCtrl,
                      obscureText: true,
                      decoration: _authInputDecoration(hint: '••••••••'),
                      validator: (value) {
                        if (!_isSignUp) return null;
                        if (value == null || value.trim().isEmpty) return 'Required';
                        if (value != _passwordCtrl.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _saving
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            setState(() => _saving = true);
                            await ref
                                .read(authSessionProvider.notifier)
                                .login(
                                  fullName: _isSignUp
                                      ? _nameCtrl.text.trim()
                                      : 'Guest User',
                                  email: _emailCtrl.text.trim(),
                                  phone: _isSignUp
                                      ? _phoneCtrl.text.trim()
                                      : '+212 600 000 000',
                                );
                            if (!context.mounted) {
                              return;
                            }
                            context.pop();
                          },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text(
                      _saving
                          ? (_isSignUp ? 'Creating account...' : 'Signing in...')
                          : (_isSignUp ? 'Create account' : 'Sign in'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _OrDivider(),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google authentication coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const _GoogleSvgIcon(),
                    label: Text(_isSignUp ? 'Sign up with Google' : 'Continue with Google'),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          _isSignUp
                              ? 'Already have an account? '
                              : "Don't have an account? ",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSignUp = !_isSignUp;
                              _passwordCtrl.clear();
                              _confirmPasswordCtrl.clear();
                            });
                          },
                          child: Text(
                            _isSignUp ? 'Sign in' : 'Sign up',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
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

  InputDecoration _authInputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.1),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B7280),
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(child: Divider(color: Color(0xFFF0F0F0), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Or',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFF0F0F0), thickness: 1)),
      ],
    );
  }
}

class _GoogleSvgIcon extends StatelessWidget {
  const _GoogleSvgIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _googleSvg,
      width: 18,
      height: 18,
    );
  }
}

const String _googleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
</svg>
''';
