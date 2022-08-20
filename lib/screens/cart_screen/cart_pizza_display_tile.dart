import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import '../../models/pizza_cart_item.dart';
import '../../models/topping_item.dart';

class CartPizzaDisplayTile extends StatelessWidget {
  const CartPizzaDisplayTile(
      {required this.elementKey,
      required this.pizzaItem,
      required this.pizzaCount,
      required this.whenDismissed});

  final PizzaCartItem pizzaItem;
  final int pizzaCount;
  final String elementKey;
  final Function whenDismissed;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(elementKey),
      onDismissed: (_) {
        whenDismissed();
      },
      background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.delete, size: 30),
              const Icon(Icons.delete, size: 30)
            ],
          )),
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListTile(context),
              if (pizzaItem.extraToppings != null ||
                  pizzaItem.toppingReplacement != null)
                ExpansionTile(
                  title: const Text("Pizza Customization"),
                  expandedAlignment: Alignment.topLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding: const EdgeInsets.all(8.0),
                  children: [
                    if (pizzaItem.extraToppings != null)
                      _buildExtraToppingsView(pizzaItem.extraToppings!),
                    const SizedBox(
                      height: 8.0,
                    ),
                    if (pizzaItem.toppingReplacement != null)
                      _buildReplacementToppingsView(
                          pizzaItem.toppingReplacement!),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text("$pizzaCount x"),
      ),
      title: Text(pizzaItem.pizza.pizzaName),
      isThreeLine: true,
      subtitle: Text(pizzaItem.selectedSize.getDisplayName),
      trailing: Text(
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        NumberFormat.currency(
          symbol: '₹ ',
          locale: "HI",
          decimalDigits: 0,
        ).format(pizzaItem.itemPrice * pizzaCount),
      ),
    );
  }

  Widget _buildExtraToppingsView(List<ToppingItem> toppingItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Extra Toppings:",
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
          Wrap(
            children: toppingItems
                .map(
                  (item) => Text(
                    "${item.toppingName}, ",
                    style: const TextStyle(fontSize: 14),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReplacementToppingsView(Map<String, ToppingItem> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Replacement Toppings:",
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
          Wrap(children: [
            Text(
              item["toppingToBeReplaced"]!.toppingName,
            ),
            const SizedBox(
              width: 8.0,
            ),
            const Text(
              "With",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              item["replacementTopping"]!.toppingName,
            ),
          ])
        ],
      ),
    );
  }
}
