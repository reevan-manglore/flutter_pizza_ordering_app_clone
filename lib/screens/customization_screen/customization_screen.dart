import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/pizza_item_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/toppings_provider.dart';
import '../../providers/cart_provider.dart';

import '../../models/pizza_cart_item.dart';
import '../../models/topping_item.dart';

import './replace_topping_card.dart';
import '../../widgets/numberd_button.dart';
import './toppings_card.dart';

class CustomizationScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  const CustomizationScreen({Key? key}) : super(key: key);

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  bool didChangeDependencyRan = false;
  PizzaSizes _selectedSize = PizzaSizes.small;
  late String id;
  late PizzaItemProvider pizzaItemdata;
  late List<Map<String, dynamic>> _veganToppings;
  late List<Map<String, dynamic>> _nonVeganToppings;
  String? _toppingToBeReplaced;
  String? _replacementTopping;

  @override
  void didChangeDependencies() {
    if (!didChangeDependencyRan) {
      id = ModalRoute.of(context)!.settings.arguments as String;
      pizzaItemdata = Provider.of<MenuProvider>(context).findPizzaById(id);
      _veganToppings = Provider.of<ToppingsProvider>(context)
          .veganToppings
          .map((val) => {"didSelect": false, "toppingItem": val})
          .toList();
      _nonVeganToppings = Provider.of<ToppingsProvider>(context)
          .nonVeganToppings
          .map((val) => {"didSelect": false, "toppingItem": val})
          .toList();
      if (pizzaItemdata.price.keys.length == 1) {
        _selectedSize =
            pizzaItemdata.price.keys.first; //if there is only one pizza size
      }

      PizzaCartItem? lastAddedPizza =
          Provider.of<CartProvider>(context, listen: false)
              .getLastAddedPizzaById(id);
      /*
        if there exits last added pizza in cart with this id then
        configure pizzaSize and toppings with previously added configuration
       */
      if (lastAddedPizza != null) {
        _selectedSize = lastAddedPizza.selectedSize;
        lastAddedPizza.extraToppings?.forEach((element) {
          if (element.isVegan) {
            _veganToppings.firstWhere(
                (e) => e["toppingItem"] == element)["didSelect"] = true;
          } else {
            _nonVeganToppings.firstWhere(
                (e) => e["toppingItem"] == element)["didSelect"] = true;
          }
        });
        _toppingToBeReplaced =
            lastAddedPizza.toppingReplacement?["toppingToBeReplaced"]?.id;
        _replacementTopping =
            lastAddedPizza.toppingReplacement?["replacementTopping"]?.id;
      }
      didChangeDependencyRan = true;
    }
    super.didChangeDependencies();
  }

  int get totalPrice {
    int price = 0;
    price = _veganToppings.where((element) => element["didSelect"]).fold(
        price,
        (previousValue, element) =>
            previousValue +
            (element['toppingItem'] as ToppingItem).toppingPrice);
    price = _nonVeganToppings.where((element) => element["didSelect"]).fold(
        price,
        (previousValue, element) =>
            previousValue +
            (element['toppingItem'] as ToppingItem).toppingPrice);
    price += pizzaItemdata.price[_selectedSize] ?? 0;
    return price;
  }

  Widget _buildSegmentedControl() {
    Widget _segmentControlItem(PizzaSizes size) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.local_pizza),
            const SizedBox(
              width: 18,
            ),
            Text(size.getDisplayName),
          ],
        ),
      );
    }

    return CupertinoSegmentedControl<PizzaSizes>(
      //here tis maps like this{PizzaSizes.small:_segmentedControl(),...}
      children: pizzaItemdata.price.map(
        (key, value) => MapEntry(
          key,
          _segmentControlItem(key),
        ),
      ),
      onValueChanged: (val) => setState(() => _selectedSize = val),
      groupValue: _selectedSize,
    );
  }

  Widget _buildSideHeadding(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _addSpacer(),
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        _addSpacer(5),
      ],
    );
  }

  Widget _addSpacer([double? space]) {
    return SizedBox(
      height: space ?? 15.0,
    );
  }

  Widget _buildAddToppingsWidget(List<Map<String, dynamic>> toppings) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: toppings
            .map(
              (e) => ToppingsCard(
                isChecked: e['didSelect'],
                toppingName: e['toppingItem'].toppingName,
                toppingImageUrl: e['toppingItem'].toppingImageUrl,
                toppingPrice: e['toppingItem'].toppingPrice,
                onChange: () {
                  setState(
                    () {
                      e['didSelect'] = !e['didSelect'];
                    },
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pizzaItemdata,
      builder: (context, _) {
        final data = Provider.of<PizzaItemProvider>(context);
        final cartData = Provider.of<CartProvider>(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Veg Extreveganaza"),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                expandedHeight: 250,
                actions: [
                  IconButton(
                    onPressed: () {
                      data.toogleFaviourite();
                    },
                    icon: Icon(
                      data.isFaviourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: Colors.red.shade300,
                      size: 28,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: data.pizzaImageUrl,
                    fit: BoxFit.cover,
                    color: Colors.black38,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 8,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(
                        data.pizzaName,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      _addSpacer(5),
                      Text(
                        data.description,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      _buildSideHeadding("Choose Size"),
                      data.price.keys.length >
                              1 //if there is only one size of pizza
                          ? _buildSegmentedControl()
                          : Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.8),
                              ),
                              child: Text(
                                data.price.keys.first.getDisplayName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                      _buildSideHeadding("Add Vegan Toppings"),
                      _buildAddToppingsWidget(_veganToppings),
                      _buildSideHeadding("Add Non Vegan Toppings"),
                      _buildAddToppingsWidget(_nonVeganToppings),
                      _buildSideHeadding("Replace Toppings"),
                      ReplaceToppingCard(
                        replaceableToppings:
                            Provider.of<ToppingsProvider>(context)
                                .veganToppings,
                        toppingToBeReplaced: _toppingToBeReplaced,
                        replacementTopping: _replacementTopping,
                        whenReplaceToppingPressed: (val) => setState(
                          () {
                            _toppingToBeReplaced = val;
                            if (_toppingToBeReplaced == _replacementTopping) {
                              _replacementTopping = null;
                            }
                          },
                        ),
                        whenResetPressed: () => setState(
                          () {
                            _toppingToBeReplaced = null;
                            _replacementTopping = null;
                          },
                        ),
                        whenReplacementToppingPressed: (val) =>
                            setState(() => _replacementTopping = val),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: _buildBottomAppBar(
            context,
            itemCount: cartData.countOfPizzaItem(data),
            whenIncrementPressed: () async {
              List<ToppingItem>? addedToppings = [
                ..._veganToppings
                    .where((element) => element["didSelect"])
                    .map((e) => e["toppingItem"] as ToppingItem)
                    .toList(),
                ..._nonVeganToppings
                    .where((element) => element["didSelect"])
                    .map((e) => e["toppingItem"] as ToppingItem)
                    .toList(),
              ];
              addedToppings = addedToppings.isEmpty ? null : addedToppings;
              if (_toppingToBeReplaced != null && _replacementTopping == null) {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Choose Replacement Topping"),
                    content: const Text(
                      "You choosed topping to be replaced but didnt replaced it with any of topping",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Ok"),
                      ),
                    ],
                  ),
                );
                return;
              }
              Map<String, ToppingItem>? toppingReplacement;

              if (_toppingToBeReplaced != null) {
                toppingReplacement = {
                  "toppingToBeReplaced":
                      Provider.of<ToppingsProvider>(context, listen: false)
                          .findToppingById(_toppingToBeReplaced!),
                  "replacementTopping":
                      Provider.of<ToppingsProvider>(context, listen: false)
                          .findToppingById(_replacementTopping!)
                };
              }

              cartData.addPizza(
                PizzaCartItem(
                  pizza: data,
                  selectedSize: _selectedSize,
                  itemPrice: totalPrice,
                  extraToppings: addedToppings,
                  toppingReplacement: toppingReplacement,
                ),
              );
            },
            whenDecrementPressed: () {
              cartData.reducePizzaFromCart(data);
              PizzaCartItem? lastAddedPizza =
                  Provider.of<CartProvider>(context, listen: false)
                      .getLastAddedPizzaById(id);
              /*
        if there exits last added pizza in cart with this id then
        configure pizzaSize and toppings with previously added configuration

       */
              if (lastAddedPizza == null) {
                //if there dosent exist previously added items
                for (var element in _veganToppings) {
                  element["didSelect"] = false;
                }
                for (var element in _nonVeganToppings) {
                  element["didSelect"] = false;
                }
                _toppingToBeReplaced = null;
                _replacementTopping = null;
                return;
              }
              _selectedSize = lastAddedPizza.selectedSize;
              for (var element in _veganToppings) {
                if (lastAddedPizza.extraToppings != null &&
                    lastAddedPizza.extraToppings!
                        .contains(element["toppingItem"] as ToppingItem)) {
                  element["didSelect"] = true;
                } else {
                  element["didSelect"] = false;
                }
              }
              for (var element in _nonVeganToppings) {
                if (lastAddedPizza.extraToppings != null &&
                    lastAddedPizza.extraToppings!
                        .contains(element["toppingItem"] as ToppingItem)) {
                  element["didSelect"] = true;
                } else {
                  element["didSelect"] = false;
                }
              }

              _toppingToBeReplaced =
                  lastAddedPizza.toppingReplacement?["toppingToBeReplaced"]?.id;
              _replacementTopping =
                  lastAddedPizza.toppingReplacement?["replacementTopping"]?.id;
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomAppBar(
    BuildContext context, {
    required int itemCount,
    required void Function() whenIncrementPressed,
    required void Function() whenDecrementPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomAppBar(
          elevation: 2,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Cost Of This Pizza:",
                        style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee),
                        Text(
                          totalPrice.toString()..padRight(3),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
                NumberdButton(itemCount,
                    label: "Add To Cart",
                    onIncrementPressed: whenIncrementPressed,
                    onDecrementPressed: whenDecrementPressed)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
