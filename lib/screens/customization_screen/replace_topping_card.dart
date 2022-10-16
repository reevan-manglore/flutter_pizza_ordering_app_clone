import 'package:flutter/material.dart';
import '../../models/topping_item.dart';
import '../../providers/toppings_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReplaceToppingCard extends StatelessWidget {
  final List<ToppingItem> replaceableToppings;
  final String? toppingToBeReplaced;
  final String? replacementTopping;
  final void Function(String?) whenReplaceToppingPressed;
  final void Function(String?) whenReplacementToppingPressed;
  final void Function() whenResetPressed;
  late List<String>? toppingsToBeIgnored;

  List<ToppingItem> _veganToppings = [];
  List<ToppingItem> _nonVeganToppings = [];

  ReplaceToppingCard({
    required this.replaceableToppings,
    required this.toppingToBeReplaced,
    required this.whenReplaceToppingPressed,
    required this.whenResetPressed,
    required this.replacementTopping,
    required this.whenReplacementToppingPressed,
    this.toppingsToBeIgnored,
  });

  Widget _addSpacer([double? space]) {
    return SizedBox(
      height: space ?? 15.0,
    );
  }

  Widget _buildSideHeadding(BuildContext context, String title) {
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

  Widget _buildReplaceCard(BuildContext context, ToppingItem item) {
    return InkWell(
      onTap: (item.id != toppingToBeReplaced && toppingToBeReplaced != null)
          ? () => whenReplacementToppingPressed(item.id)
          : null,
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
          color: (toppingToBeReplaced != null && item.id != toppingToBeReplaced)
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey.shade400,
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
                          image: NetworkImage(item.toppingImageUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            (item.id != toppingToBeReplaced &&
                                    toppingToBeReplaced != null)
                                ? Colors.black26
                                : Colors.black38,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        item.id == replacementTopping
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: (item.id != toppingToBeReplaced &&
                                toppingToBeReplaced != null)
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Text(
                  item.toppingName,
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

  Widget _buildReplaceToppingsWidget(
      BuildContext context, List<ToppingItem> toppings) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: toppings.map((e) => _buildReplaceCard(context, e)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _veganToppings = Provider.of<ToppingsProvider>(context, listen: false)
        .veganToppings
        .where((ele) => !(toppingsToBeIgnored?.contains(ele.id) ?? false))
        .toList();

    _nonVeganToppings = Provider.of<ToppingsProvider>(context, listen: false)
        .nonVeganToppings
        .where((ele) => !(toppingsToBeIgnored?.contains(ele.id) ?? false))
        .toList();

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: whenResetPressed,
                child: const Text("Reset these selections"),
              ),
            ),
            _buildSideHeadding(context, "Replace Any One Of These"),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        chipTheme: ChipThemeData(
                          showCheckmark: true,
                          selectedColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(4.0),
                        ),
                      ),
                      child: InputChip(
                        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                        selected: toppingToBeReplaced ==
                            replaceableToppings[index].id,
                        onSelected: (choice) {
                          if (choice) {
                            whenReplaceToppingPressed(
                                replaceableToppings[index].id);
                          }
                        },
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          replaceableToppings[index].toppingName,
                          style: TextStyle(
                            color: toppingToBeReplaced ==
                                    replaceableToppings[index].id
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: replaceableToppings.length,
              ),
            ),
            _addSpacer(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(height: 20, color: Colors.black, thickness: 10),
                const Text(
                  "Replace  with one of these topings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const Divider(height: 20, color: Colors.black)
              ],
            ),
            _buildSideHeadding(context, "Vegan Toppings"),
            _buildReplaceToppingsWidget(context, _veganToppings),
            _buildSideHeadding(context, "Non Vegan Toppings"),
            _buildReplaceToppingsWidget(context, _nonVeganToppings),
          ],
        ),
      ),
    );
  }
}
