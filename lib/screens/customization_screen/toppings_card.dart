import 'package:flutter/material.dart';

class ToppingsCard extends StatelessWidget {
  final bool isChecked;
  final void Function() onChange;
  final String toppingName;
  final String toppingImageUrl;
  final int toppingPrice;
  const ToppingsCard({
    required this.isChecked,
    required this.onChange,
    required this.toppingName,
    required this.toppingImageUrl,
    required this.toppingPrice,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChange,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Container(
          width: 150,
          height: 250,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 4,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        backgroundBlendMode: BlendMode.darken,
                        image: DecorationImage(
                          image: NetworkImage(toppingImageUrl),
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.black26,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        isChecked
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      left: 2,
                      child: Chip(
                        labelPadding: const EdgeInsets.all(0),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.add,
                              size: 24,
                            ),
                            const Icon(
                              Icons.currency_rupee,
                              size: 24,
                            ),
                            Text(
                              toppingPrice.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Text(
                  toppingName,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
