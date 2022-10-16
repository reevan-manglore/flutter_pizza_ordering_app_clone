import 'package:flutter/material.dart';

import './login_screen.dart';
import './signup_screen.dart';
import "../home_page/home_page.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String routeName = "/auth-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/images/login-page-pizza-avatar.png",
                    fit: BoxFit.cover,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Hey Welcome",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "We Deliver You The Most Delecious Pizzas At Your Doorsteps",
                    maxLines: 3,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(SignupScreen.routeName),
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                minimumSize: const Size.fromHeight(32),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    color: Colors.grey,
                    height: 2,
                    width: double.infinity,
                  ),
                ),
                const Text(
                  "Aleredy Have Account",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    color: Colors.grey,
                    height: 2,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                minimumSize: const Size.fromHeight(32),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
