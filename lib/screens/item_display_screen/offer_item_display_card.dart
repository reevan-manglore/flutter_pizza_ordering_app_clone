import 'package:flutter/material.dart';

class OfferItemDisplayCard extends StatelessWidget {
  final String title;
  final String description;
  final String offerCode;

  const OfferItemDisplayCard({
    super.key,
    required this.title,
    required this.description,
    required this.offerCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
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
                  mainAxisSize: MainAxisSize.min,
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
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "You applied offer code \"$offerCode\"",
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
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
    );
  }
}
