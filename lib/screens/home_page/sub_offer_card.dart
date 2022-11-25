import 'package:flutter/material.dart';

import '../../models/offer_cupon.dart';

class SubOfferCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? image;
  final String offerCode;
  final OfferType type;
  final Function whenTapped;

  const SubOfferCard({
    super.key,
    required this.title,
    this.description,
    this.image,
    required this.offerCode,
    required this.type,
    required this.whenTapped,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => whenTapped(),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Container(
          width: 300,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade200,
                Colors.orange.shade300,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(children: [
            Hero(
              tag: offerCode,
              child: Image.asset(
                "lib/assets/images/offer-percentage-avatar.png",
                alignment: Alignment.centerLeft,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      // 'M' * 32,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Expanded(
                      child:
                          Text(description ?? "", overflow: TextOverflow.clip),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    type == OfferType.offerOnItem
                        ? const Icon(
                            Icons.arrow_forward_sharp,
                            size: 22,
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
            ),
          ]),
        ),
      ),
    );
  }
}
