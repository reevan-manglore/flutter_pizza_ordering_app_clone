// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:pizza_app/models/offer_cupon.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../../providers/menu_provider.dart';
import '../../providers/pizza_item_provider.dart';
import '../../providers/sides_item_provider.dart';
import "../../providers/cart_provider.dart";
import '../../providers/offer_provider.dart';
import "../../providers/vegan_preferance_provider.dart";
import '../../helpers/custom_toast.dart';

import 'hero_offer_card.dart';
import 'sub_offer_card.dart';
import './varities.dart';
import './bestseller_pizza_card.dart';
import './bestseller_sides_card.dart';

import '../cart_screen/cart_screen.dart';
import '../item_display_screen/items_by_offer_display_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final _offerData = Provider.of<OfferProvider>(context);
    final veganPreferance = Provider.of<VeganPreferanceProvider>(context);
    List bestSellers = [];
    if (veganPreferance.isveganOnly) {
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
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: Badge(
              badgeContent: Text(
                "${_cartData.cartCount}",
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
          IconButton(
            tooltip: "Manage Your Account",
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
              size: 32,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_offerData.heroOffer != null)
                HeroOfferCard(
                  title: _offerData.heroOffer!.title,
                  description: _offerData.heroOffer!.description,
                  type: _offerData.heroOffer!.type,
                  offerCode: _offerData.heroOffer!.offerCode,
                  whenTapped: () {
                    _cartData.copyOffer(_offerData.heroOffer!);
                    if (_offerData.heroOffer!.type == OfferType.offerOnCart) {
                      CustomToast(context).hideCurrentToast();
                      CustomToast(context).showToast(
                          "Offer Code \"${_offerData.heroOffer!.offerCode}\" Copied");
                    } else {
                      Navigator.of(context).pushNamed(
                        ItemsByOfferDisplayScreen.routeName,
                        arguments: _offerData.heroOffer!.id,
                      );
                    }
                  },
                ),
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
                height: 165,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _offerData.subOffers.map((val) {
                    return SubOfferCard(
                      title: val.title,
                      description: val.description,
                      offerCode: val.offerCode,
                      type: val.type,
                      whenTapped: () {
                        _cartData.copyOffer(val);
                        if (val.type == OfferType.offerOnCart) {
                          CustomToast(context).hideCurrentToast();
                          CustomToast(context).showToast(
                              "Offer Code \"${val.offerCode}\" Copied");
                        } else {
                          Navigator.of(context).pushNamed(
                            ItemsByOfferDisplayScreen.routeName,
                            arguments: val.id,
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 8.0,
                  left:
                      10.0, //bascially i used this because in SubOffer i have given  varites widget some extra margin
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
                child: const Varites(),
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
                            onTap: veganPreferance.toggleVegan,
                            child: Row(
                              children: [
                                Switch(
                                  value: veganPreferance.isveganOnly,
                                  onChanged: (_) =>
                                      veganPreferance.toggleVegan(),
                                  activeColor: Colors.green,
                                ),
                                Text(
                                  "Veg Only",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: veganPreferance.isveganOnly
                                            ? Colors.green
                                            : null,
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
                constraints: const BoxConstraints(
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
                const Icon(
                  Icons.delivery_dining,
                  size: 28,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Take Away From"),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.expand_more),
              ],
            ),
            Container(
              width: 250,
              alignment: Alignment.center,
              child: const Text(
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
