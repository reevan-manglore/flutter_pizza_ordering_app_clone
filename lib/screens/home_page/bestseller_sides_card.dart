import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/sides_item_provider.dart';
import '../../providers/cart_provider.dart';

import '../../models/sides_cart_item.dart';

import '../../screens/cart_screen/cart_screen.dart';

import '../../widgets/vegan_indicator.dart';

class BestSellerSidesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<SidesItemProvider>(context);
    final cartData = Provider.of<CartProvider>(context, listen: false);
    return Card(
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
                  imageUrl: data.sidesImageUrl,
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
                        Text("${data.price}"),
                      ],
                    ),
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
                      data.sidesName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Text(
                        data.sidesDescription,
                        maxLines: 5,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart_checkout_rounded),
                        label: const Text("Quick Checkout"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          cartData.addSide(SidesCartItem(data, data.price));
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
