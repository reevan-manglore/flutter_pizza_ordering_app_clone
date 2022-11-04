import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/offer_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/pizza_item_provider.dart';
import '../../providers/sides_item_provider.dart';
import '../../providers/vegan_preferance_provider.dart';

import '../../models/offer_cupon.dart';

import './offer_item_display_card.dart';
import './pizza_item_display_card.dart';
import './sides_item_display_card.dart';

import '../../helpers/not_found.dart';

class ItemsByOfferDisplayScreen extends StatefulWidget {
  const ItemsByOfferDisplayScreen({Key? key}) : super(key: key);
  static const routeName = "/items_by_offer_screen";

  @override
  State<ItemsByOfferDisplayScreen> createState() =>
      _ItemsByOfferDisplayScreenState();
}

class _ItemsByOfferDisplayScreenState extends State<ItemsByOfferDisplayScreen> {
  bool didChangeDependencyRun = false;
  late final String offerId;
  late final ItemOffer offerData;
  late VeganPreferanceProvider veganPreferance;
  List<PizzaItemProvider> _pizzas = [];
  List<SidesItemProvider> _sides = [];
  @override
  void didChangeDependencies() {
    if (!didChangeDependencyRun) {
      offerId = ModalRoute.of(context)!.settings.arguments as String;
      offerData = Provider.of<OfferProvider>(context).getOfferById(offerId)
          as ItemOffer;
      veganPreferance = Provider.of<VeganPreferanceProvider>(context);
      didChangeDependencyRun = true;
      super.didChangeDependencies();
    }
  }

  Widget _buildHeroTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "You selected Offer",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        OfferItemDisplayCard(
          title: offerData.title,
          description: offerData.description,
          offerCode: offerData.offerCode,
        ),
        Row(
          children: [
            Text(
              "Items for this offer",
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: InkWell(
                onTap: veganPreferance.toggleVegan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch(
                      value: veganPreferance.isveganOnly,
                      onChanged: (_) => veganPreferance.toggleVegan(),
                      activeColor: Colors.green,
                    ),
                    Text(
                      "Veg Only",
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: veganPreferance.isveganOnly
                                ? Colors.green
                                : null,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void getAllOfferItems() {
    //reset both of these arrays to an empty array
    _pizzas = [];
    _sides = []; //
    for (String itemId in offerData.applicableItems) {
      final item = Provider.of<MenuProvider>(context).findItemById(itemId);
      if (item == null) {
        continue;
      }
      if (item.runtimeType == PizzaItemProvider) {
        if (veganPreferance.isveganOnly &&
            !((item as PizzaItemProvider).isVegan)) {
          //if veganOnly true PizzaItemProvider not vegan then return
          continue;
        }
        _pizzas.add(item);
      } else {
        if (veganPreferance.isveganOnly &&
            !((item as SidesItemProvider).isVegan)) {
          //if veganOnly true PizzaItemProvider not vegan then return
          continue;
        }
        _sides.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getAllOfferItems();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offer Items"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: (_pizzas.isEmpty && _sides.isEmpty)
            ? const NotFound(
                notFoundMessage:
                    "Sorry currently no item found for this category",
              )
            : ListView.builder(
                itemCount: _pizzas.length + _sides.length + 1,
                itemBuilder: (context, idx) {
                  if (idx == 0) {
                    return _buildHeroTitle();
                  } else if (idx - 1 < _pizzas.length) {
                    return ChangeNotifierProvider.value(
                      value: _pizzas[idx - 1],
                      builder: (context, _) {
                        return PizzaItemDisplayCard();
                      },
                    );
                  } else {
                    return ChangeNotifierProvider.value(
                      value: _sides[idx - 1 - _pizzas.length],
                      builder: (context, _) {
                        return const SidesItemDisplayCard();
                      },
                    );
                  }
                }),
      ),
    );
  }
}
