import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/pizza_item_provider.dart';

import '../customization_screen/customization_screen.dart';

import '../../widgets/numberd_button.dart';
import '../../widgets/vegan_indicator.dart';

class BestSellerPizzaCard extends StatefulWidget {
  @override
  State<BestSellerPizzaCard> createState() => _BestSellerPizzaCardState();
}

class _BestSellerPizzaCardState extends State<BestSellerPizzaCard> {
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
                  Image.network(
                    data.pizzaImageUrl,
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
                          Icon(Icons.currency_rupee),
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
                            Text(
                              "Customize",
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                        backgroundColor: Colors.black26,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.pizzaName,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Text(
                          data.description,
                          maxLines: 5,
                          style: TextStyle(
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          NumberdButton(
                            2,
                            label: "Add To Cart",
                            onIncrementPressed: () {},
                            onDecrementPressed: () {},
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
