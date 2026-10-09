import 'package:flutter/material.dart';

void main() => runApp(const RegistrationApp());

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // The key gives access to FormState, so every field can be validated at once.
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const List<String> _roles = ['Student', 'Teacher', 'Developer'];

  String _role = _roles.first;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------- Validators (return null when the value is valid) ----------

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return "Email must contain '@' and '.' (e.g. name@narxoz.kz)";
    }
    // Slightly stricter shape check: something@something.something
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email (e.g. name@narxoz.kz)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ---------- Submission ----------

  void _submit() {
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    // validate() runs every validator in the Form and shows the error texts.
    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors in the form'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    // Print the form data in the terminal (password is masked on purpose).
    debugPrint('===== Registration data =====');
    debugPrint('Full name      : $name');
    debugPrint('Email          : $email');
    debugPrint('Password       : ${'*' * _passwordController.text.length}');
    debugPrint('Role           : $_role');
    debugPrint('Accepted terms : $_acceptedTerms');
    debugPrint('=============================');

    messenger.showSnackBar(
      SnackBar(
        content: Text('Welcome, $name! Registered as $_role.'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------- UI ----------

  InputDecoration _decoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    const gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full name
                    TextFormField(
                      controller: _nameController,
                      decoration: _decoration('Full Name', Icons.person_outline),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateName,
                    ),
                    gap,

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: _decoration('Email', Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateEmail,
                    ),
                    gap,

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _decoration(
                        'Password',
                        Icons.lock_outline,
                        suffix: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validatePassword,
                    ),
                    gap,

                    // Confirm password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: _decoration(
                        'Confirm Password',
                        Icons.lock_reset_outlined,
                      ),
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateConfirmPassword,
                    ),
                    gap,

                    // Role dropdown
                    InputDecorator(
                      decoration: _decoration('Role', Icons.badge_outlined),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _role,
                          isExpanded: true,
                          isDense: true,
                          items: _roles
                              .map(
                                (role) => DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _role = value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Terms checkbox, wrapped in a FormField so the same
                    // _formKey.validate() call checks it and shows its error.
                    FormField<bool>(
                      initialValue: _acceptedTerms,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value == true
                          ? null
                          : 'You must accept the Terms and Conditions',
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              value: state.value ?? false,
                              onChanged: (value) {
                                state.didChange(value);
                                setState(() => _acceptedTerms = value ?? false);
                              },
                              title: const Text(
                                'I accept the Terms and Conditions',
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: errorColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Submit
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.how_to_reg),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}