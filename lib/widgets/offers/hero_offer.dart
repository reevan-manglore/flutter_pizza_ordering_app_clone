import 'package:flutter/material.dart';

class HeroOffer extends StatelessWidget {
  String title;
  String? description;
  String? subdescription;
  String? image;
  HeroOffer({
    required this.title,
    this.description,
    this.image,
  });
  @override
  Widget build(BuildContext context) {
    image = "shit";
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.all(15.0),
          constraints: BoxConstraints(maxHeight: double.infinity),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue.shade100,
                Colors.lightBlue.shade200,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "On any pizza's on first and second order and only for conumer who are staying long for more than 3monts and are only using hdfc bank credit card ",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 9,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: image == null
                          ? Alignment.center
                          : Alignment.bottomLeft,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "lib/assets/images/pizza-offer-avatar.png",
                alignment: Alignment.centerLeft,
                width: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
