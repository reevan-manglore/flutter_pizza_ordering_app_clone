import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import './sides_item_display_card.dart';
import './pizza_item_display_card.dart';

import '../../providers/pizza_item_provider.dart';
import '../../providers/sides_item_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';

class ItemsByCategoryDisplayScreen extends StatefulWidget {
  static const String routeName = "/category-screen";

  const ItemsByCategoryDisplayScreen({Key? key}) : super(key: key);

  @override
  State<ItemsByCategoryDisplayScreen> createState() =>
      _ItemsByCategoryDisplayScreenState();
}

class _ItemsByCategoryDisplayScreenState
    extends State<ItemsByCategoryDisplayScreen> {
  bool veganOnly = false;
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
    switch (argument.toLowerCase()) {
      case "veg pizza":
        _pizzas = Provider.of<MenuProvider>(context).veganPizzas
          ..sort((_, second) =>
              second.isBestSeller ? 1 : -1); //hack to sort by bestseller
        break;
      case "non veg pizza":
        _pizzas = Provider.of<MenuProvider>(context).nonVeganPizzas;
        break;
      case "snacks":
        _sides = Provider.of<MenuProvider>(context)
            .findSidesByCategory(SidesCategory.snacks)
            .where((element) {
          if (veganOnly == true) {
            return element.isVegan == true;
          } else {
            return true;
          }
        }).toList()
          ..sort((_, second) =>
              second.isBestSeller ? 1 : -1); //hack to sort by bestseller

        break;
      default:
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(argument),
        actions: [
          IconButton(
            tooltip: "Your Cart",
            onPressed: () {},
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
      body: Padding(
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
                    onTap: () => setState(() {
                      veganOnly = !veganOnly;
                    }),
                    child: Row(
                      children: [
                        Switch(
                          value: veganOnly,
                          onChanged: (val) => setState(() {
                            veganOnly = val;
                          }),
                          activeColor: Colors.green,
                        ),
                        Text(
                          "Veg Only",
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: veganOnly ? Colors.green : null,
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
