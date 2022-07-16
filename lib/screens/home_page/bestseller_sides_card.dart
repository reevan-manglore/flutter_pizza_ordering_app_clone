import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sides_item_provider.dart';
import '../../widgets/numberd_button.dart';
import '../../widgets/vegan_indicator.dart';

class BestSellerSidesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<SidesItemProvider>(context);
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
                Image.network(
                  data.sidesImageUrl,
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
                        Text("${data.price}"),
                      ],
                    ),
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
                      data.sidesName,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Text(
                        data.sidesDescription,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: NumberdButton(
                        0,
                        label: "Add to cart",
                        onIncrementPressed: () {},
                        onDecrementPressed: () {},
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
