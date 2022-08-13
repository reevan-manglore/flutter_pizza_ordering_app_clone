import 'package:flutter/material.dart';
import 'package:pizza_app/models/offer_cupon.dart';

class HeroOfferCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? image;
  final String offerCode;
  final OfferType type;
  final Function whenTapped;
  const HeroOfferCard({
    required this.title,
    this.description,
    required this.offerCode,
    this.image,
    required this.type,
    required this.whenTapped,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => whenTapped(),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(15.0),
            constraints: const BoxConstraints(maxHeight: double.infinity),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, //max charcaters that can be fitted is 36
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        //max cahracters that can be fitted is 144 chracters
                        description ??
                            "On any pizza's on first and second order and only for conumer who are staying long for more than 3monts and are only using hdfc bank credit card ",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      ),
                      const SizedBox(height: 10),
                      type == OfferType.offerOnItem
                          ? const Icon(
                              Icons.arrow_forward,
                              size: 32,
                            )
                          : Text(
                              "Copy Code \"$offerCode\"",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
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
      ),
    );
  }
}
