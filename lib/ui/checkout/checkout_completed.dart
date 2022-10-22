import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/ui/overview_screen.dart';

class CheckoutCompleted extends StatelessWidget {
  const CheckoutCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 200,
            height: 200,
            child: Image(image: IMAGE_CHECKOUT_COMPLETE),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            "Order Completed!",
            style: themeData.textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Your payment has been received and you'll get notification for your order's state",
              style: themeData.textTheme.bodyMedium,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 40)),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(OverviewScreen.routeName),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FluentIcons.chevron_left_16_regular),
                    Text(
                      'Go Back to Home',
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
