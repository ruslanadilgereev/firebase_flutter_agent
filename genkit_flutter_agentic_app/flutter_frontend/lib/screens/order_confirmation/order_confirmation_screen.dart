import 'package:flutter/material.dart';
import 'package:flutter_app/models/order_confirmation_model.dart';
import 'package:flutter_app/screens/components.dart';
import 'package:flutter_app/settings/styles.dart';
import 'package:flutter_app/settings/theme.dart';
import './receipt.dart';
import './go_home_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({required this.orderConfirmation, super.key});

  final OrderConfirmationModel orderConfirmation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Confirmation',
          style: subheaderStyle.copyWith(color: orange),
        ),
      ),
      body: BodyWhitespace(
        child: Receipt(
          items: orderConfirmation.items,
          totalPrice: orderConfirmation.totalPrice,
        ),
      ),
      bottomNavigationBar: GoHomeButton(),
    );
  }
}
