import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../../providers/menu_provider.dart';
import '../../providers/pizza_item_provider.dart';
import '../../providers/sides_item_provider.dart';
import "../../providers/cart_provider.dart";

import '../../widgets/offers/hero_offer.dart';
import '../../widgets/offers/sub_offers.dart';
import './varities.dart';
import './bestseller_pizza_card.dart';
import './bestseller_sides_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool veganOnly = false;

  Widget _buildHeader(String title) {
    return Text(
      title,
      // textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _pizzaProvider = Provider.of<MenuProvider>(context);
    final _cartData = Provider.of<CartProvider>(context);
    List bestSellers = [];
    if (veganOnly) {
      bestSellers = [
        ..._pizzaProvider.bestSellerPizzas.where((ele) => ele.isVegan),
        ..._pizzaProvider
            .findBestSellerSidesByCategory(SidesCategory.snacks)
            .where((ele) => ele.isVegan),
      ];
    } else {
      bestSellers = [
        ..._pizzaProvider.bestSellerPizzas,
        ..._pizzaProvider.findBestSellerSidesByCategory(SidesCategory.snacks)
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: _LocationPickerButton(),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            tooltip: "Your Cart",
            onPressed: () {},
            icon: Badge(
              badgeContent: Text(
                "${_cartData.cartCount}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 32,
              ),
              badgeColor: Theme.of(context).colorScheme.primary,
              animationType: BadgeAnimationType.slide,
            ),
          ),
          IconButton(
            tooltip: "Manage Your Account",
            onPressed: () {},
            icon: Icon(
              Icons.account_circle,
              size: 32,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroOffer(title: "Choose any 2 Pizzas and get upto 40% Offer"),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 8.0,
                  left:
                      10.0, //bascially i used this because in SubOffer i have given some extra margin
                ),
                child: _buildHeader("More Offers"),
              ),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: SubOffers(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 8.0,
                  left:
                      10.0, //bscially i used this because in SubOffer i have given  varites widget some extra margin
                ),
                child: _buildHeader("Explore Our Varities"),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                width: double.infinity,
                height: 330,
                child: Varites(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 8.0,
                  left:
                      10.0, //bascially i used this because in SubOffer i have given  varites widget some extra margin
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeader("Our BestSellers"),
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: veganOnly ? Colors.green : null,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: 400,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, idx) {
                    if (bestSellers[idx].runtimeType == PizzaItemProvider) {
                      return ChangeNotifierProvider<PizzaItemProvider>.value(
                        value: bestSellers[idx] as PizzaItemProvider,
                        child: BestSellerPizzaCard(),
                      );
                    } else {
                      return ChangeNotifierProvider<SidesItemProvider>.value(
                        value: bestSellers[idx] as SidesItemProvider,
                        child: BestSellerSidesCard(),
                      );
                    }
                  },
                  itemCount: bestSellers.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationPickerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 28,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Take Away From"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.expand_more),
              ],
            ),
            Container(
              width: 250,
              alignment: Alignment.center,
              child: Text(
                "Santosh Nagar munnur post near anganwadi kendra manglore pandithouse",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
