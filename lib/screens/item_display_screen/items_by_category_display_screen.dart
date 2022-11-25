import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../../providers/pizza_item_provider.dart';
import '../../providers/sides_item_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/vegan_preferance_provider.dart';
import '../../providers/cart_provider.dart';

import './sides_item_display_card.dart';
import './pizza_item_display_card.dart';
import "../cart_screen/cart_screen.dart";

import '../../widgets/not_found.dart';

class ItemsByCategoryDisplayScreen extends StatefulWidget {
  static const String routeName = "/category-screen";

  const ItemsByCategoryDisplayScreen({Key? key}) : super(key: key);

  @override
  State<ItemsByCategoryDisplayScreen> createState() =>
      _ItemsByCategoryDisplayScreenState();
}

class _ItemsByCategoryDisplayScreenState
    extends State<ItemsByCategoryDisplayScreen> {
  bool isPizzaCategory = false;
  String argument = "";
  bool didChangeDependenciesRun = false;
  List<PizzaItemProvider> _pizzas = [];
  List<SidesItemProvider> _sides = [];
  @override
  void didChangeDependencies() {
    if (!didChangeDependenciesRun) {
      argument = ModalRoute.of(context)?.settings.arguments as String;
      isPizzaCategory =
          argument.contains(RegExp(r"pizza", caseSensitive: false))
              ? true
              : false; //if its either  veg or non veg pizza then this is true

    }

    didChangeDependenciesRun = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final veganPreferance = Provider.of<VeganPreferanceProvider>(context);
    switch (argument.toLowerCase()) {
      case "veg pizza":
        _pizzas = Provider.of<MenuProvider>(context).findPizzas(
          veganOnly: true,
          sortByBestSeller: true,
        );
        break;
      case "non veg pizza":
        _pizzas = Provider.of<MenuProvider>(context)
            .findPizzas(nonVeganOnly: true, sortByBestSeller: true);
        break;
      case "snacks":
        _sides = Provider.of<MenuProvider>(context).findSides(
          category: SidesCategory.snacks,
          veganOnly: veganPreferance.isveganOnly,
          sortByBestSeller: true,
        );
        break;
      case "desserts":
        _sides = Provider.of<MenuProvider>(context).findSides(
          category: SidesCategory.desserts,
          veganOnly: veganPreferance.isveganOnly,
          sortByBestSeller: true,
        );
        break;
      case "drinks":
        _sides = Provider.of<MenuProvider>(context).findSides(
          category: SidesCategory.drinks,
          veganOnly: veganPreferance.isveganOnly,
          sortByBestSeller: true,
        );
        break;
      default:
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(argument),
        actions: [
          IconButton(
            tooltip: "Your Cart",
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: Consumer<CartProvider>(
              builder: (context, cartData, _) => Badge(
                alignment: Alignment.topLeft,
                position: BadgePosition.topEnd(top: -13, end: 2),
                badgeContent: Text(
                  "${cartData.cartCount}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 32,
                ),
                badgeColor: Theme.of(context).colorScheme.primary,
                animationType: BadgeAnimationType.slide,
              ),
            ),
          ),
        ],
      ),
      body: (_pizzas.isEmpty && _sides.isEmpty)
          ? const NotFound(
              notFoundMessage:
                  "Sorry currently no item found for this category",
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Explore our $argument's",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      if (!isPizzaCategory)
                        InkWell(
                          onTap: veganPreferance.toggleVegan,
                          child: Row(
                            children: [
                              Switch(
                                value: veganPreferance.isveganOnly,
                                onChanged: (_) => veganPreferance.toggleVegan(),
                                activeColor: Colors.green,
                              ),
                              Text(
                                "Veg Only",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      color: veganPreferance.isveganOnly
                                          ? Colors.green
                                          : null,
                                    ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: _buildListView(),
                  ),
                ],
              ),
            ),
    );
  }

  ListView _buildListView() {
    if (isPizzaCategory) {
      return ListView.builder(
        itemBuilder: (context, idx) {
          return ChangeNotifierProvider.value(
            value: _pizzas[idx],
            builder: (context, _) => PizzaItemDisplayCard(),
          );
        },
        itemCount: _pizzas.length,
      );
    }
    return ListView.builder(
      itemBuilder: (context, idx) {
        return ChangeNotifierProvider.value(
          value: _sides[idx],
          builder: (context, _) => const SidesItemDisplayCard(),
        );
      },
      itemCount: _sides.length,
    );
  }
}
