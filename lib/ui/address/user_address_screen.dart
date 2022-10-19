import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/address/user_address_card.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/utils/responseMapping.util.dart';

class UserAddressScreen extends StatefulWidget {
  static const String routeName = '/user-address';

  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  late Future<List<Address>> futureAddressList;

  @override
  void initState() {
    futureAddressList = fetchUserAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        title: const Text("User Address"),
        centerTitle: true,
        titleTextStyle: themeData.textTheme.titleLarge,
        leading: buildBackIcon(context),
        iconTheme: themeData.iconTheme,
      ),
      body: FutureBuilder(
        future: futureAddressList,
        builder: (context, snapshot) {
          List<Address> addressesList = List.empty();
          if (snapshot.hasData) {
            addressesList = snapshot.data as List<Address>;
          }

          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ...List.castFrom<dynamic, Widget>(addressesList
                              .map((address) =>
                                  UserAddressCard(userAddress: address))
                              .toList())
                          .toList(),
                      buildUserAddAddress(
                          context: context, themeData: themeData)
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Widget buildUserAddAddress(
      {required BuildContext context, required ThemeData themeData}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.infinity,
        height: 125,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          color: themeData.shadowColor,
          dashPattern: const [6, 3],
          strokeWidth: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "+ Add Address",
              style: themeData.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
