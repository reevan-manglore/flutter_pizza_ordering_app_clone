import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

class NotFound extends StatelessWidget {
  final String notFoundMessage;
  const NotFound({super.key, required this.notFoundMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          "lib/assets/lotties/not_found.json",
          alignment: Alignment.center,
          height: 270,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          notFoundMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
