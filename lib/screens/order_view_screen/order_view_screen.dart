import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './order_pizza_tile.dart';
import './order_side_tile.dart';

class OrderViewScreen extends StatelessWidget {
  final String orderDocId;
  final firebaseInstance = FirebaseFirestore.instance;
  OrderViewScreen(this.orderDocId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Order Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: firebaseInstance.collection("orders").doc(orderDocId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(
                  "Oh snap there was some error from our side",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              );
            }
            final data = snapshot.data!.data();
            return ListView(
              children: [
                _buildInfoTile("Your order id", data?["razorPayOrderId"] ?? ""),
                _buildInfoTile(
                  "Resturant assigned",
                  '${data?["resturantAddress"]}',
                ),
                _buildInfoTile(
                  "Total items orderd",
                  '${data?["cartCount"]}',
                ),
                _buildInfoTile(
                  "Actual cart cost",
                  '${data?["cartCost"]}',
                ),
                _buildInfoTile(
                  "Delivery charge",
                  '${data?["deliveryCharge"]}',
                ),
                if (data?["offerApplied"] != null)
                  _buildInfoTile(
                    "Discount code applied",
                    '${data?["offerApplied"]}',
                  ),
                if (data?["offerApplied"] != null)
                  _buildInfoTile(
                    "Discount amount",
                    ' -${data?["discountAmount"]}',
                  ),
                _buildInfoTile(
                  "Amount payed",
                  '${data?["amountToPay"]}',
                ),
                _buildHeadding("Items you orderd"),
                const SizedBox(
                  height: 7,
                ),
                ...(data!["cartItems"] as List<dynamic>).map<Widget>((item) {
                  if (item["itemType"] == "pizza") {
                    return OrderPizzaDisplayTile(
                      pizzaName: item["itemName"],
                      pizzaSize: item["choosenSize"],
                      quantityOrderd: item["quantity"],
                      cost: item["itemPrice"],
                      extraToppings: item["extraToppings"] ?? [],
                      toppingReplacement: item["toppingReplacement"],
                    );
                  } else {
                    //else its an side item
                    return OrderSideDisplayTile(
                      sidesName: item["itemName"],
                      quantityOrderd: item["itemQuantity"],
                      cost: item["itemPrice"],
                    );
                  }
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadding(title),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(
              content.toUpperCase(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadding(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade800,
      ),
    );
  }
}
