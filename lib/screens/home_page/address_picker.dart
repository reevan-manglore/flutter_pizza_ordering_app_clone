import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import "package:provider/provider.dart";
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../providers/user_account_provider.dart';
import '../../models/user_address.dart';

import '../maps_display_screen/maps_display_screen.dart';

import '../../helpers/tag_symbol.dart';

class AddressPicker extends StatefulWidget {
  const AddressPicker({super.key});

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  bool didAdressPickedinAppStart = false;

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserAccountProvider>(context);
    if (!didAdressPickedinAppStart) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => _builtBottomSheet(userInfo),
          enableDrag: false,
          isDismissible: false,
          backgroundColor: Colors.transparent,
        );
      });

      didAdressPickedinAppStart = true;
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => _builtBottomSheet(userInfo),
          enableDrag: false,
          isDismissible: false,
          backgroundColor: Colors.transparent,
        );
      },
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.delivery_dining,
                  size: 28,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Delivery To"),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.expand_more),
              ],
            ),
            SizedBox(
              width: 250,
              child: Text(
                // "Santosh Nagar munnur post near anganwadi kendra manglore pandithouse",
                userInfo.addressToDeliver.address,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builtBottomSheet(UserAccountProvider userInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select delivery address",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ListTile(
            onTap: () async {
              final isLocationPicked = await _pickCurrentUserLocation(userInfo);
              if (isLocationPicked) {
                Navigator.of(context).pop();
              }
            },
            leading: const Icon(Icons.location_searching),
            title: const Text("Pick current location"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 3.0),
            enableFeedback: true,
          ),
          const SizedBox(
            height: 18.0,
          ),
          const Text(
            "Or pick saved locations",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250, minHeight: 90),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, idx) => ListTile(
                onTap: () {
                  userInfo.addressToDeliver = userInfo.savedAddresses[idx];
                  Navigator.of(context).pop();
                },
                leading: TagSymbol(tag: userInfo.savedAddresses[idx].tag),
                title: Text(userInfo.savedAddresses[idx].tag),
                subtitle: Text(userInfo.savedAddresses[idx].address),
                isThreeLine: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
              ),
              itemCount: userInfo.savedAddresses.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _pickCurrentUserLocation(UserAccountProvider userAccount) async {
    //loading indicator when location is being fetched
    showLoadingDialog();
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isGpsEnabled) {
      Navigator.of(context).pop(); //dismiss loading indicator
      _buildAlertDialog(
        title: "Please enable location",
        description: "You didnt enabled location please turn on location",
      );
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Navigator.of(context).pop(); //dismiss locading indiactor
      _buildAlertDialog(
        title: "You denied permision permenently",
        description:
            "Please turn on location permsion permission in your settings app",
        actionBtnText: "Open Settings Page",
        whenActionBtnPressed: () => Geolocator.openAppSettings(),
      );
      return false;
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        Navigator.of(context).pop();
        _buildAlertDialog(
          title: "You denied permision permenently",
          description:
              "Please turn on location permsion permission in your settings app",
          actionBtnText: "Open Settings Page",
          whenActionBtnPressed: () => Geolocator.openAppSettings(),
        );
        return false;
      }
    }
    final userLocation = await Geolocator.getCurrentPosition();

    Navigator.of(context).pop();
    final poppedData = await Navigator.of(context).push(
      MaterialPageRoute<Map<String, dynamic>?>(
        fullscreenDialog: true,
        builder: (context) => MapsDisplayPage(
          initialLatitude: userLocation.latitude,
          initialLongitude: userLocation.longitude,
        ),
      ),
    );
    if (poppedData == null) {
      _buildAlertDialog(title: "Please confirm location");
      return false;
    }
    if (poppedData["locationName"] == null) {
      _buildAlertDialog(title: "Please confirm location");
      return false;
    }

    userAccount.addressToDeliver = UserAddress(
      latitude: poppedData["latitude"],
      longitude: poppedData["longitude"],
      address: poppedData["locationName"],
    );

    // setState(() {
    //   // _locationName = poppedData["locationName"];
    //   // _latitude = poppedData["latitude"];
    //   // _longitude = poppedData["longitude"];

    //   _locationName = "Neighbourhood Of Nowhere Street";
    //   _latitude = 12.8709179;
    //   _longitude = 74.8267859;
    // });
    return true;
  }

  Future<void> _buildAlertDialog({
    required String title,
    String? description,
    String actionBtnText = "Ok",
    void Function()? whenActionBtnPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: description == null ? null : Text(description),
        actions: [
          TextButton(
            onPressed:
                whenActionBtnPressed ?? () => Navigator.of(context).pop(),
            child: Text(actionBtnText),
          )
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        title: Text("Fetching your location"),
        content: CupertinoActivityIndicator(
          radius: 20,
          color: Colors.blue,
        ),
      ),
    );
  }
}
