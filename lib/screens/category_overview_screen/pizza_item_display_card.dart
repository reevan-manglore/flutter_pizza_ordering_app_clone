import 'package:flutter/material.dart';
import 'package:pizza_app/screens/customization_screen/customization_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/pizza_item_provider.dart';

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
        margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
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
                    Image.network(
                      data.pizzaImageUrl,
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
                          label: Text("BestSeller"),
                        ),
                      ),
                    Positioned(
                      top: -2,
                      right: 5,
                      child: IconButton(
                        onPressed: () => data.toogleFaviourite(),
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        data.description,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          data.price.keys.length == 1
                              ? Text(
                                  data.price.keys.first.getDisplayName,
                                  style: TextStyle(
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
                          Spacer(),
                          NumberdButton(10,
                              label: "Add To Cart",
                              onIncrementPressed: () {},
                              onDecrementPressed: () {}),
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
