import 'package:flutter/material.dart';
import 'package:tmdt/models/address.dart';

class UserAddressCard extends StatelessWidget {
  final Address userAddress;
  final Color? borderColor;
  const UserAddressCard({Key? key, required this.userAddress, this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 125,
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: borderColor ?? themeData.shadowColor, width: 2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userAddress.fullName,
                      style: themeData.textTheme.titleLarge,
                    ),
                    Text(
                      userAddress.phoneNumber.toString(),
                      style: themeData.textTheme.titleMedium,
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Text(
                  '${userAddress.address}, ${userAddress.city}, ${userAddress.country}',
                  style: themeData.textTheme.bodyMedium,
                )
              ]),
        ),
      ),
    );
  }
}
