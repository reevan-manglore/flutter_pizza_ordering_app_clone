import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import './order_view_screen.dart';

import '../../helpers/dashed_lined_divider.dart';

class OrderHistoryViewScreen extends StatelessWidget {
  static const String routeName = "/pastOrders";
  OrderHistoryViewScreen({super.key});

  final uid = FirebaseAuth.instance.currentUser?.uid;
  final firebaseInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your past orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: firebaseInstance
              .collection("orders")
              .where("uid", isEqualTo: uid)
              .where("isPaymentDone", isEqualTo: true)
              .get(),
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
            final data = snapshot.data!.docs;
            if (data.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.no_meals,
                    size: 54,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "You have not placed any orders yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return OrderViewScreen(data[index].id);
                      },
                    ),
                  ),
                  child: _buildOrderHistoryViewCard(
                    date: data[index]["orderdOn"],
                    amountPayed: data[index]["amountToPay"],
                    resturantAssigned: data[index]["resturantAddress"],
                    itemsOrderd: (data[index]["cartItems"] as List<dynamic>)
                        .map<String>(
                          (e) => e["itemName"],
                        )
                        .toList(),
                  ),
                );
              }),
              separatorBuilder: (context, _) =>
                  const DashedLinedDivider(height: 10.0),
              itemCount: data.length,
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderHistoryViewCard(
      {required String date,
      required int amountPayed,
      required String resturantAssigned,
      required List<String> itemsOrderd}) {
    final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
    final indianRupeesFormatter = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 0, // change it to get decimal places
      symbol: '₹ ',
    );
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("On ${formatter.format(DateTime.parse(date))}"),
            subtitle: Text("From $resturantAssigned"),
            isThreeLine: true,
            trailing: Text(indianRupeesFormatter.format(amountPayed)),
          ),
          const Divider(
            height: 15,
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: itemsOrderd
                  .map(
                    (e) => Text(
                      "$e , ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
