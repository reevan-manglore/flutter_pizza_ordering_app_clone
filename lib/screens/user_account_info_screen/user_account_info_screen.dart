import "dart:developer" show log;
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../providers/user_account_provider.dart";

import './add_new_address_screen.dart';
import "../auth_screen/welcome_screen.dart";
import '../order_view_screen/order_history_view_screen.dart';

import '../../helpers/tag_symbol.dart';

class UserAccountInfoScreen extends StatelessWidget {
  static const routeName = "/user-account-info-screen";

  const UserAccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserAccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        actions: [
          IconButton(
            onPressed: () {
              userInfo.searchResturants(
                  latitude: 12.814573, longitude: 74.879871, radius: 8);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile("Name", userInfo.name),
              _buildInfoTile("Phone", userInfo.phoneNumber),
              const SizedBox(
                height: 15.0,
              ),
              _buildHeadding("Addresses"),
              const SizedBox(
                height: 8.0,
              ),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 250, minHeight: 90),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, idx) => ListTile(
                    leading: TagSymbol(tag: userInfo.savedAddresses[idx].tag),
                    title: Text(userInfo.savedAddresses[idx].tag),
                    subtitle: Text(userInfo.savedAddresses[idx].address),
                    isThreeLine: true,
                  ),
                  itemCount: userInfo.savedAddresses.length,
                ),
              ),
              ListTile(
                style: ListTileStyle.list,
                leading: const Icon(Icons.add_location),
                shape: const OutlineInputBorder(),
                onTap: () {
                  Navigator.of(context).pushNamed(AddNewAdressScreen.routeName);
                },
                title: const Text("Add addresses"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(
                height: 30,
              ),
              _buildHeadding("Your past orders"),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                style: ListTileStyle.list,
                leading: const Icon(Icons.history_sharp),
                shape: const OutlineInputBorder(),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(OrderHistoryViewScreen.routeName);
                },
                title: const Text("View your past orders"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(
                height: 30,
              ),
              _buildHeadding("Logout"),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                style: ListTileStyle.list,
                leading: const Icon(Icons.logout_outlined),
                shape: const OutlineInputBorder(),
                onTap: () async {
                  log("print logged out");
                  try {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Are you sure to Logout"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              "No",
                            ),
                          ),
                        ],
                      ),
                    );
                    if (shouldLogout == null || !shouldLogout) return;
                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        WelcomePage.routeName, (route) => false);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Some error occured while logging you out",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red.shade300,
                      ),
                    );
                  }
                },
                title: const Text("Logout"),
              ),
            ],
          ),
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
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              content.toUpperCase(),
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
