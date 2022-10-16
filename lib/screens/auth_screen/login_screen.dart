import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lottie/lottie.dart';
import '../../screens/home_page/home_page.dart';
import './authentication_form.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
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
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          AuthenticationForm(
                            onFormSaved: (email, password) async {
                              try {
                                log("$email  $password");

                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomePage.routeName,
                                  (_) => false,
                                ); //remove all previous routes
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _buildSnackbar(e.message, context),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _buildSnackbar(
                                      "some error occured while authenticating",
                                      context),
                                );
                              }
                            },
                            label: "Login",
                          ),
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

  SnackBar _buildSnackbar(String? message, BuildContext context) {
    return SnackBar(
      content: Text(
        message ?? "Some error has occured while authenticating",
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
}
