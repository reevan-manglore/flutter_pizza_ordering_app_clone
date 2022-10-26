import 'package:flutter/material.dart';
import 'package:pizza_app/providers/cart_provider.dart';
import 'package:pizza_app/screens/customization_screen/customization_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/pizza_item_provider.dart';

import '../../models/pizza_cart_item.dart';

import '../../widgets/numberd_button.dart';
import '../../widgets/vegan_indicator.dart';

class PizzaItemDisplayCard extends StatefulWidget {
  @override
  State<PizzaItemDisplayCard> createState() => _PizzaItemDisplayCardState();
}

class _PizzaItemDisplayCardState extends State<PizzaItemDisplayCard> {
  PizzaSizes _choosenSize = PizzaSizes.small;
  late PizzaItemProvider data;
  bool didChangeDependencyRun = false;
  @override
  void didChangeDependencies() {
    if (!didChangeDependencyRun) {
      data = Provider.of<PizzaItemProvider>(context);
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
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: data.pizzaImageUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
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
                    if (data.isBestSeller)
                      Positioned(
                        top: 0,
                        left: 40,
                        child: Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black26,
                          label: const Text("BestSeller"),
                        ),
                      ),
                    Positioned(
                      top: -2,
                      right: 5,
                      child: IconButton(
                        onPressed: () => data.toogleFaviourite(),
                        icon: Icon(
                          data.isFavourite
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.pizzaName,
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        data.description,
                        maxLines: 5,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          data.price.keys.length == 1
                              ? Text(
                                  data.price.keys.first.getDisplayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                )
                              : DropdownButton<PizzaSizes>(
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
                                ),
                          const Spacer(),
                          Consumer<CartProvider>(
                            builder: (context, cartData, _) => NumberdButton(
                              cartData.countOfPizzaItem(data),
                              label: "Add To Cart",
                              onIncrementPressed: () async {
                                final previouslyAddedItem =
                                    cartData.getLastAddedPizzaById(data.id);

                                //by defualt add current selected pizza
                                int? option = 1;
                                if (previouslyAddedItem != null &&
                                    (previouslyAddedItem.selectedSize !=
                                            _choosenSize ||
                                        previouslyAddedItem.extraToppings !=
                                            null ||
                                        previouslyAddedItem
                                                .toppingReplacement !=
                                            null)) {
                                  option = await showModalBottomSheet<int>(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    builder: (context) => BottomSheetStructure(
                                      previouslySelectedItem:
                                          previouslyAddedItem,
                                      currentlySelectedPizzaSize: _choosenSize,
                                    ),
                                  );
                                }
                                switch (option) {
                                  case 1:
                                    cartData.addPizza(
                                      PizzaCartItem(
                                          pizza: data,
                                          selectedSize: _choosenSize,
                                          itemPrice: data.price[_choosenSize]!),
                                    );
                                    break;
                                  case 2:
                                    cartData.addPizza(previouslyAddedItem!);
                                    break;
                                  default:
                                }
                              },
                              onDecrementPressed: () {
                                cartData.reducePizzaFromCart(data);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetStructure extends StatelessWidget {
  final PizzaCartItem previouslySelectedItem;
  final PizzaSizes currentlySelectedPizzaSize;

  const BottomSheetStructure({
    required this.previouslySelectedItem,
    required this.currentlySelectedPizzaSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width / 2 - 30, -70),
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.close,
              ),
            ),
          ),
          const Center(
            child: Text(
              "Choose Your Customization",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Text(
            "Do You Want To Continue With",
            textAlign: TextAlign.left,
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop<int>(1);
              },
              title: Text(
                previouslySelectedItem.pizza.pizzaName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Size: ",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(currentlySelectedPizzaSize.getDisplayName)
                ],
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.currency_rupee),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  "${previouslySelectedItem.pizza.price[currentlySelectedPizzaSize]}",
                )
              ]),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text(
            "Or Repeat Previous Customization",
            textAlign: TextAlign.left,
          ),
          _customSelectionTile(context),
        ],
      ),
    );
  }

  Widget _customSelectionTile(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop<int>(2);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 13.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      previouslySelectedItem.pizza.pizzaName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          "Size:",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          previouslySelectedItem.selectedSize.getDisplayName,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (previouslySelectedItem.extraToppings != null)
                      Row(
                        children: [
                          Text(
                            "Extra Toppings: ",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Expanded(
                            child: Text(
                              previouslySelectedItem.extraToppings!.fold(
                                "",
                                (previousValue, element) =>
                                    previousValue + " ${element.toppingName},",
                              ),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          )
                        ],
                      ),
                    if (previouslySelectedItem.toppingReplacement != null)
                      Column(
                        children: [
                          const Divider(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  previouslySelectedItem
                                      .toppingReplacement![
                                          "toppingToBeReplaced"]!
                                      .toppingName,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              Text(
                                " Replaced With ",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Flexible(
                                child: Text(
                                  previouslySelectedItem
                                      .toppingReplacement![
                                          "replacementTopping"]!
                                      .toppingName,
                                  style: Theme.of(context).textTheme.caption,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Icon(Icons.currency_rupee),
              const SizedBox(
                width: 5.0,
              ),
              Text("${previouslySelectedItem.itemPrice}")
            ],
          ),
        ),
      ),
    );
  }
}
