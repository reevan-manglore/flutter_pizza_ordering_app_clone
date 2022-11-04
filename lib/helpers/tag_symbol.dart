import 'package:flutter/material.dart';

class TagSymbol extends StatelessWidget {
  final String tag;
  const TagSymbol({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    if (tag == "Home") {
      return const Icon(Icons.home);
    }
    if (tag == "Work") {
      return const Icon(Icons.work);
    }
    if (tag == "Family") {
      return const Icon(Icons.family_restroom);
    }
    if (tag == "Friends") {
      return const Icon(Icons.emoji_people);
    }
    return const Icon(Icons.location_history_rounded);
  }
}
