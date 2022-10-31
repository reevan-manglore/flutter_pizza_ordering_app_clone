import 'package:flutter/material.dart';

import "package:provider/provider.dart";
import "../../providers/user_account_provider.dart";

import './add_new_address_screen.dart';

class UserAccountInfoScreen extends StatelessWidget {
  static const routeName = "/user-account-info-screen";

  const UserAccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserAccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
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
                    leading:
                        _determineTagSymbol(userInfo.savedAddresses[idx].tag),
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
              _buildHeadding("Logout"),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                style: ListTileStyle.list,
                leading: const Icon(Icons.logout_outlined),
                shape: const OutlineInputBorder(),
                onTap: () {},
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

  Widget _determineTagSymbol(String text) {
    if (text == "Home") {
      return const Icon(Icons.home);
    }
    if (text == "Work") {
      return const Icon(Icons.work);
    }
    if (text == "Family") {
      return const Icon(Icons.family_restroom);
    }
    if (text == "Friends") {
      return const Icon(Icons.emoji_people);
    }
    return const Icon(Icons.location_history_rounded);
  }
}
