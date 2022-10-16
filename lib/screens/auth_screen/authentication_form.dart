import 'package:flutter/material.dart';

class AuthenticationForm extends StatefulWidget {
  final Future<void> Function(String email, String password) onFormSaved;
  final String label;
  const AuthenticationForm({
    required this.onFormSaved,
    required this.label,
  });

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmail(String value) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  bool _isPasswordVisible = false;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
            child: Text(
              "Email Address",
            ),
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) =>
                _isEmail(value ?? "") ? null : "Please enter valid email",
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 15.0,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
            child: Text(
              "Password",
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 4) {
                return "Please enter password of atleast four charcaters";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () => setState(
                  () => _isPasswordVisible = !_isPasswordVisible,
                ),
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 15.0,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          ElevatedButton(
            onPressed: _isAuthenticating
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isAuthenticating = true;
                      });
                      await widget.onFormSaved(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (!mounted) return;
                      setState(() {
                        _isAuthenticating = false;
                      });
                    }
                  },
            child: _isAuthenticating
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              minimumSize: const Size.fromHeight(32),
              disabledBackgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
