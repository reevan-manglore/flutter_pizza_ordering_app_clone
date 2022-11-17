import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

class OrderPizzaDisplayTile extends StatelessWidget {
  const OrderPizzaDisplayTile({
    required this.pizzaName,
    required this.pizzaSize,
    required this.cost,
    required this.quantityOrderd,
    required this.extraToppings,
    this.toppingReplacement,
  });

  final String pizzaName;
  final String pizzaSize;
  final int cost;
  final int quantityOrderd;
  final List<dynamic> extraToppings;
  final Map<String, dynamic>? toppingReplacement;
  // final PizzaCartItem pizzaItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListTile(context),
            if (extraToppings.isNotEmpty || toppingReplacement != null)
              ExpansionTile(
                title: const Text("Pizza Customization"),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                childrenPadding: const EdgeInsets.all(8.0),
                children: [
                  if (extraToppings.isNotEmpty)
                    _buildExtraToppingsView(extraToppings),
                  const SizedBox(
                    height: 8.0,
                  ),
                  if (toppingReplacement != null)
                    _buildReplacementToppingsView(toppingReplacement!),
                ],
              ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text("$quantityOrderd x"),
      ),
      title: Text(pizzaName),
      isThreeLine: true,
      subtitle: Text(pizzaSize),
      trailing: Text(
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        NumberFormat.currency(
          symbol: '₹ ',
          locale: "HI",
          decimalDigits: 0,
        ).format(cost * quantityOrderd),
      ),
    );
  }

  Widget _buildExtraToppingsView(List<dynamic> toppingItems) {
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
                    "$item, ",
                    style: const TextStyle(fontSize: 14),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReplacementToppingsView(
      Map<String, dynamic> toppingReplacement) {
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
              toppingReplacement["toppingToBeReplaced"],
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
              toppingReplacement["replacementTopping"],
            ),
          ])
        ],
      ),
    );
  }
}
