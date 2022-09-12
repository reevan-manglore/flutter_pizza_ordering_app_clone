import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/pizza_item_provider.dart';
import '../../providers/cart_provider.dart';

import '../../models/pizza_cart_item.dart';

import '../customization_screen/customization_screen.dart';
import '../../screens/cart_screen/cart_screen.dart';

import '../../widgets/vegan_indicator.dart';

class BestSellerPizzaCard extends StatefulWidget {
  @override
  State<BestSellerPizzaCard> createState() => _BestSellerPizzaCardState();
}

class _BestSellerPizzaCardState extends State<BestSellerPizzaCard> {
  PizzaSizes _choosenSize = PizzaSizes.small;
  late PizzaItemProvider data;
  late CartProvider cartData;
  bool didChangeDependencyRun = false;
  @override
  void didChangeDependencies() {
    if (!didChangeDependencyRun) {
      data = Provider.of<PizzaItemProvider>(context);
      cartData = Provider.of<CartProvider>(context, listen: false);
      _choosenSize = data.price.keys.contains(PizzaSizes.medium)
          ? PizzaSizes.medium
          : data.price.keys.first;
      didChangeDependencyRun = true;
    }
    super.didChangeDependencies();
  }

  DropdownMenuItem<PizzaSizes> _buildDropDownMenuItem(PizzaSizes value) {
    return DropdownMenuItem<PizzaSizes>(
      child: Text(value.label),
      value: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.isCustomizable
          ? () => Navigator.of(context)
              .pushNamed(CustomizationScreen.routeName, arguments: data.id)
          : null,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: data.pizzaImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                    color: Colors.black38,
                    colorBlendMode: BlendMode.multiply,
                  ),
                  Positioned(
                    top: 8,
                    left: 5,
                    child: VeganIndicator(
                      isVegan: data.isVegan,
                    ),
                  ),
                  Positioned(
                    top: 3,
                    right: 5,
                    child: IconButton(
                      onPressed: data.toogleFaviourite,
                      icon: Icon(
                        data.isFaviourite
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red.shade300,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    left: 5,
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.black26,
                      label: Row(
                        children: [
                          const Icon(Icons.currency_rupee),
                          Text("${data.price[_choosenSize]}"),
                        ],
                      ),
                    ),
                  ),
                  if (data.isCustomizable)
                    Positioned(
                      bottom: 3,
                      right: 5,
                      child: Chip(
                        label: Row(
                          children: [
                            const Text(
                              "Customize",
                            ),
                            const Icon(Icons.arrow_forward)
                          ],
                        ),
                        backgroundColor: Colors.black26,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.pizzaName, //max charcters supported is 24
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Text(
                          data.description,
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          data.price.length >
                                  1 //if there is more than one pizza size
                              ? DropdownButton<PizzaSizes>(
                                  value: _choosenSize,
                                  elevation: 0,
                                  items: data.price.keys.map((arg) {
                                    return _buildDropDownMenuItem(
                                      arg,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _choosenSize =
                                        value ?? PizzaSizes.medium);
                                  },
                                )
                              : Text(
                                  data.price.keys.first.getDisplayName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          ElevatedButton.icon(
                            icon: const Icon(
                                Icons.shopping_cart_checkout_rounded),
                            label: const Text("Quick Checkout"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              cartData.addPizza(
                                PizzaCartItem(
                                    pizza: data,
                                    selectedSize: _choosenSize,
                                    itemPrice: data.price[_choosenSize]!),
                              );
                              Navigator.of(context)
                                  .pushNamed(CartScreen.routeName);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
