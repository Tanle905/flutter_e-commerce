import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/address/user_address_card.dart';

class ShippingStep extends StatefulWidget {
  const ShippingStep({Key? key}) : super(key: key);

  @override
  State<ShippingStep> createState() => _ShippingStepState();
}

class _ShippingStepState extends State<ShippingStep> {
  late Future<List<Address>> futureAddressesList;
  int selectedIndex = -1;

  @override
  void initState() {
    futureAddressesList = fetchUserAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAddressesList,
      builder: (context, snapshot) {
        List<Address> addressesList = List.empty();
        if (snapshot.hasData) {
          addressesList = snapshot.data as List<Address>;
        }
        return snapshot.hasData
            ? Column(
                children: [
                  ...(addressesList
                      .asMap()
                      .entries
                      .map((entry) => InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() {
                              selectedIndex = entry.key;
                            }),
                            child: UserAddressCard(
                              userAddress: entry.value,
                              borderColor: selectedIndex == entry.key
                                  ? COLOR_BUTTON_AND_LINK_TEXT
                                  : null,
                            ),
                          ))
                      .toList()),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
