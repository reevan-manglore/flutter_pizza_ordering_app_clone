import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './sides_item_provider.dart';
import './pizza_item_provider.dart';

class MenuProvider extends ChangeNotifier {
  final pizzaImageUrls = [
    "https://media.istockphoto.com/photos/cheesy-pepperoni-pizza-picture-id938742222?b=1&k=20&m=938742222&s=170667a&w=0&h=HyfY78AeiQM8vZbIea-iiGmNxHHuHD-PVVuHRvrCIj4=",
    "https://media.istockphoto.com/photos/slice-of-pizza-isolated-on-white-background-picture-id1295596568?b=1&k=20&m=1295596568&s=170667a&w=0&h=iYtQ3yZhbJ7Qo_qFpZDN3KIJ5zkhiJGqo2OjL6aHyzE=",
    "https://media.istockphoto.com/photos/hand-takes-pizza-picture-id1218105733?b=1&k=20&m=1218105733&s=170667a&w=0&h=p4OpHL3nL2f1spQkrHhxLDcOpyFGQhqzM_htCj2nifo=",
  ];
  final sidesImageUrls = [
    "https://media.istockphoto.com/photos/tachos-al-pastore-picture-id1366126429?b=1&k=20&m=1366126429&s=170667a&w=0&h=ffhGlTx_Jiv_TdPzZpYqEhJACl6MZFo0q2hkhUAJxcE=",
    "https://media.istockphoto.com/photos/sausage-roll-puff-pastry-snack-with-meat-picture-id1369528107?b=1&k=20&m=1369528107&s=170667a&w=0&h=N0QBPMPTepphyuqvxpJWHXBacNQr0gEdycqWN9GDt_Y=",
    "https://media.istockphoto.com/photos/closeup-of-fresh-homebaked-choco-lava-cake-with-melted-chocolate-on-picture-id1323881683?b=1&k=20&m=1323881683&s=170667a&w=0&h=jvqLVm6gpCNr9fFfoALpGjdnl7QWuEESjhdJnt2dDKE=",
  ];
  List<PizzaItemProvider> _pizzas = [];
  List<SidesItemProvider> _sides = [];

  MenuProvider() {
    _pizzas = [
      PizzaItemProvider(
        id: "123",
        pizzaName: "Veggie Extravaganza",
        pizzaImageUrl: pizzaImageUrls[0],
        description:
            "Indulge in an vegetable heaven created with our unique vegie extravagenza",
        price: {
          PizzaSizes.small: 150,
          PizzaSizes.medium: 300,
          PizzaSizes.large: 500,
        },
        isBestSeller: true,
        isVegan: true,
        isCustomizable: true,
      ),
      PizzaItemProvider(
        id: "456",
        pizzaName: "Veggie Paradise",
        pizzaImageUrl: pizzaImageUrls[1],
        description:
            "Indulge in an vegetable world created with our unique veggie extravagenza",
        price: {
          // PizzaSizes.small: 150,
          PizzaSizes.medium: 300,
          // PizzaSizes.large: 500,
        },
        isVegan: true,
      ),
      PizzaItemProvider(
        id: "567",
        pizzaName: "Non Vegans Paradise",
        pizzaImageUrl: pizzaImageUrls[2],
        // description:
        //     "Indulge in an vegetable world created with our unique veggie extravagenza",
        description: _dummyText,
        price: {
          PizzaSizes.small: 150,
          PizzaSizes.medium: 300,
          PizzaSizes.large: 500,
        },
        isBestSeller: true,
        isCustomizable: true,
      ),
    ];
    _sides = [
      SidesItemProvider(
        id: "abc124",
        category: SidesCategory.snacks,
        sidesName: "Choco Lava Cake",
        sidesImageUrl: sidesImageUrls[2],
        sidesDescription: _dummyText,
        price: 80,
        isVegan: true,
      ),
      SidesItemProvider(
        id: "bcd538",
        category: SidesCategory.snacks,
        sidesName: "Vegetable Puffs",
        sidesImageUrl: sidesImageUrls[1],
        sidesDescription: _dummyText,
        price: 60,
        isBestSeller: true,
        isVegan: true,
      ),
      SidesItemProvider(
        id: "gad625",
        category: SidesCategory.snacks,
        sidesName: "Non Veg Tachos",
        sidesImageUrl: sidesImageUrls[0],
        sidesDescription: _dummyText,
        price: 140,
        isBestSeller: true,
      ),
    ];
  }

  List<PizzaItemProvider> get pizzas {
    return _pizzas;
  }

  List<PizzaItemProvider> get veganPizzas {
    return _pizzas.where((element) => element.isVegan == true).toList();
  }

  List<PizzaItemProvider> get nonVeganPizzas {
    return _pizzas.where((element) => element.isVegan == false).toList();
  }

  List<SidesItemProvider> get sides {
    return _sides;
  }

  List<SidesItemProvider> get veganSides {
    return _sides.where((element) => element.isVegan == true).toList();
  }

  List<SidesItemProvider> get nonVegansides {
    return _sides.where((element) => element.isVegan == false).toList();
  }

  int get itemCount {
    return pizzas.length + sides.length;
  }

  PizzaItemProvider findPizzaById(String id) {
    return _pizzas.firstWhere((element) => element.id == id);
  }

  SidesItemProvider findSidesById(String id) {
    return _sides.firstWhere((element) => element.id == id);
  }

  List<PizzaItemProvider> get bestSellerPizzas {
    return _pizzas.where((element) => element.isBestSeller).toList();
  }

  List<SidesItemProvider> get bestSellerSides {
    return _sides.where((element) => element.isBestSeller == true).toList();
  }

  List<SidesItemProvider> findBestSellerSidesByCategory(SidesCategory cat) {
    return _sides
        .where((element) => element.isBestSeller && element.category == cat)
        .toList();
  }

  List<SidesItemProvider> findSidesByCategory(SidesCategory cat) {
    return _sides.where((element) => element.category == cat).toList();
  }

  dynamic findItemById(String id) {
    if (_pizzas.any((element) => element.id == id)) {
      return _pizzas.singleWhere((element) => element.id == id);
    }
    if (_sides.any((element) => element.id == id)) {
      return _sides.singleWhere((element) => element.id == id);
    }
    return null;
  }
}

const _dummyText =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet vehicula purus, in viverra risus. Sed a sodales arcu. Proin luctus faucibus tortor ac venenatis. Curabitur sed sapien augue. Vestibulum consequat malesuada orci quis volutpat. Vivamus fringilla ligula a leo suscipit, a lacinia augue pharetra. Duis tellus diam, tincidunt in mi et, gravida sodales libero. Aliquam erat volutpat.";
