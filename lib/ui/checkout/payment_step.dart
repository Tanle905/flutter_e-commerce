import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tmdt/constants/constants.dart';

class PaymentStep extends StatefulWidget {
  final Future<dynamic> Function() onStepContinue;

  const PaymentStep({Key? key, required this.onStepContinue}) : super(key: key);

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  CardFieldInputDetails? _card = const CardFieldInputDetails(complete: false);
  final CardFormEditController _cardController = CardFormEditController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: COLOR_BUTTON_AND_LINK_TEXT)),
          child: CardFormField(
            onCardChanged: (details) => setState(() {
              _card = details;
            }),
            controller: _cardController,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              onPressed: _card?.complete ?? false ? handlePayment : null,
              child: const Text('Complete Payment')),
        )
      ],
    );
  }

  Future<dynamic> handlePayment() async {
    print(_card?.number);
    widget.onStepContinue();
  }
}
