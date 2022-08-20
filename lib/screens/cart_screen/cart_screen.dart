import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

import './cart_pizza_display_tile.dart';
import './cart_side_display_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    final similarPizza = cartData.getGroupedPizzas();
    final similarSides = cartData.getGroupedSidesItem();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Your Cart Has Total Of ${cartData.cartCount} Items",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            cartData.cartCount < 1
                ? Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                      ),
                      const Text(
                        "Your Cart Is Empty",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ))
                : Expanded(
                    child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...similarPizza.keys
                                .map((pizzaItem) => CartPizzaDisplayTile(
                                      elementKey: pizzaItem.hashCode.toString(),
                                      pizzaItem: pizzaItem,
                                      pizzaCount: similarPizza[pizzaItem]!,
                                      whenDismissed: () =>
                                          cartData.removePizzasWhichAreSimilar(
                                              pizzaItem),
                                    ))
                                .toList(),
                            ...similarSides.keys
                                .map(
                                  (sideItem) => CartSidesDisplayTile(
                                    itemKey: sideItem.hashCode.toString(),
                                    sideItem: sideItem,
                                    quantity: similarSides[sideItem]!,
                                    whenDismissed: () {
                                      cartData
                                          .removeSidesWhichAreSimilar(sideItem);
                                    },
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      )
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
