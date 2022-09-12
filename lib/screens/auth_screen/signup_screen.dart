import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../home_page/home_page.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "/signup-screen";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEmail(String value) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 10.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Lottie.asset(
                "lib/assets/lotties/signup_animation.json",
                alignment: Alignment.center,
                height: 270,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 35.0,
                        horizontal: 25.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.7),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9.0, vertical: 4.0),
                                  child: Text(
                                    "Email Address",
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => _isEmail(value ?? "")
                                      ? null
                                      : "Please enter valid email",
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9.0, vertical: 4.0),
                                  child: Text(
                                    "Password",
                                  ),
                                ),
                                TextFormField(
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 4) {
                                      return "Please enter password of atleast four charcaters";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                        () => _isPasswordVisible =
                                            !_isPasswordVisible,
                                      ),
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
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
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                          HomePage.routeName,
                                          (_) =>
                                              false); //remove all previous routes
                                    }
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    minimumSize: const Size.fromHeight(32),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
