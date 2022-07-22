import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sides_item_provider.dart';

import '../../widgets/numberd_button.dart';
import '../../widgets/vegan_indicator.dart';

class SidesItemDisplayCard extends StatelessWidget {
  const SidesItemDisplayCard({Key? key}) : super(key: key);

  final tempTitle = "An choco chip cokkies filled with goeey caramel";
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<SidesItemProvider>(context);
    return Card(
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
                  Image.network(
                    data.sidesImageUrl,
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
                      onPressed: () {
                        data.toogleFaviourite();
                      },
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
                          Text(data.price.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.sidesName,
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "  ${data.sidesDescription}",
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: NumberdButton(
                        10,
                        label: "Add To Cart",
                        onIncrementPressed: () {},
                        onDecrementPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
