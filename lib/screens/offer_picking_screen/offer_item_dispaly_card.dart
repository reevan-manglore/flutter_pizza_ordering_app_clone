import 'package:flutter/material.dart';

import '../../helpers/offer_ticket_clipper.dart';

class OfferItemDisplayCard extends StatelessWidget {
  final String title;
  final String description;
  final String offerCode;
  final int discountAmt;
  final void Function() whenTapped;

  const OfferItemDisplayCard(
      {super.key,
      required this.title,
      required this.description,
      required this.offerCode,
      required this.discountAmt,
      required this.whenTapped});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        whenTapped();
        Navigator.of(context).pop();
      },
      child: ClipPath(
        clipper: OfferTicketClipper(
          holeRadius: 30,
        ),
        child: Card(
          borderOnForeground: true,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              constraints: const BoxConstraints(maxHeight: double.infinity),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow.shade300,
                    Colors.yellow.shade500,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2.0),
                          child: Text(
                            "Save ₹$discountAmt",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Apply Code \"$offerCode\"",
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade700,
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
      ),
    );
  }
}
