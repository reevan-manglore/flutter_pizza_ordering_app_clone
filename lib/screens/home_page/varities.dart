import 'package:flutter/material.dart';

import '../category_overview_screen/category_overview_screen.dart';

class Varites extends StatelessWidget {
  const Varites({Key? key}) : super(key: key);

  Widget buildAvatar(BuildContext context, String name, String imageLocation) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CategoryOverviewScreen.routeName, arguments: name);
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
            SizedBox(
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
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 15,
      ),
      children: [
        buildAvatar(
          context,
          "Veg Pizza",
          "lib/assets/images/veg-pizza-avatar.jpg",
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
        // buildAvatar(
        //   context,
        //   "Dessert",
        //   "lib/assets/images/dessert-avatar.jpg",
        // ),
      ],
    );
  }
}
