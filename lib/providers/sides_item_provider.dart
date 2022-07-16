import 'package:flutter/widgets.dart';

class SidesItemProvider extends ChangeNotifier {
  final String id;
  final String sidesName;
  final String sidesImageUrl;
  final String sidesDescription;
  final int price;
  bool isVegan;
  bool isFaviourite;
  final bool isBestSeller;
  final SidesCategory category;

  SidesItemProvider({
    required this.id,
    required this.category,
    required this.sidesName,
    required this.sidesImageUrl,
    required this.sidesDescription,
    required this.price,
    this.isVegan = false,
    this.isBestSeller = false,
    this.isFaviourite = false,
  });

  void toogleFaviourite() {
    isFaviourite = !isFaviourite;
    notifyListeners();
  }
}

enum SidesCategory {
  desserts,
  drinks,
  snacks,
}
