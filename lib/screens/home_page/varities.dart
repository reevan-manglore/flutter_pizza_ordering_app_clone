import 'package:flutter/material.dart';

import '../item_display_screen/items_by_category_display_screen.dart';

class Varites extends StatelessWidget {
  const Varites({Key? key}) : super(key: key);

  Widget buildAvatar(BuildContext context, String name, String imageLocation) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ItemsByCategoryDisplayScreen.routeName, arguments: name);
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageLocation),
              radius: 45,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 15,
      ),
      children: [
        buildAvatar(
          context,
          "Veg Pizza",
          "lib/assets/images/veg-pizza-avatar.png",
        ),
        buildAvatar(
          context,
          "Non Veg Pizza",
          "lib/assets/images/non_veg-pizza-avatar.jpg",
        ),
        buildAvatar(
          context,
          "Snacks",
          "lib/assets/images/sides-avatar.jpg",
        ),
        buildAvatar(
          context,
          "Desserts",
          "lib/assets/images/dessert-avatar.jpg",
        ),
        buildAvatar(
          context,
          "Drinks",
          "lib/assets/images/drinks-avatar.jpg",
        ),
      ],
    );
  }
}
