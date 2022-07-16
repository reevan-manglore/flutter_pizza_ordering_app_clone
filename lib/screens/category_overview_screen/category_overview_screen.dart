import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './sides_item_display_card.dart';
import 'pizza_item_display_card.dart';
import '../../providers/pizza_item_provider.dart';
import '../../providers/sides_item_provider.dart';
import '../../providers/menu_provider.dart';

class CategoryOverviewScreen extends StatefulWidget {
  static const String routeName = "/category-screen";

  const CategoryOverviewScreen({Key? key}) : super(key: key);

  @override
  State<CategoryOverviewScreen> createState() => _CategoryOverviewScreenState();
}

class _CategoryOverviewScreenState extends State<CategoryOverviewScreen> {
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
          builder: (context, _) => SidesItemDisplayCard(),
        );
      },
      itemCount: _sides.length,
    );
  }
}
