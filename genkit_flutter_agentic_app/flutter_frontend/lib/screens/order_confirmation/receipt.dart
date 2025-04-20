import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/order_confirmation_model.dart';

import '../../settings/styles.dart';

class Receipt extends StatelessWidget {
  const Receipt({required this.items, required this.totalPrice, super.key});

  final List<OrderItem> items;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(textTheme: GoogleFonts.caveatTextTheme()),
      child: ListView(
        padding: EdgeInsets.all(Size.m),
        children: [
          ThankYouMessage(),
          ...items.map((item) => ReceiptItem(item: item)),
          TotalPrice(totalPrice: totalPrice),
        ],
      ),
    );
  }
}

class ThankYouMessage extends StatelessWidget {
  const ThankYouMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Size.m),
      child: Text(
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
        'Hey, thanks for shopping with us!\nHave a great trip!',
      ),
    );
  }
}

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({required this.item, super.key});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Size.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
            '${item.quantity.toString()}x',
          ),
          SizedBox.square(dimension: Size.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  item.name,
                ),
                if (item.quantity > 1)
                  Text(
                    style: TextStyle(fontSize: 24),
                    '\$${item.price.toString()} ea.',
                  ),
              ],
            ),
          ),
          SizedBox.square(dimension: Size.m),
          Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            '\$${item.totalPrice.toString()}',
          ),
        ],
      ),
    );
  }
}

class TotalPrice extends StatelessWidget {
  const TotalPrice({required this.totalPrice, super.key});

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Size.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            'Total: \$$totalPrice',
          ),
        ],
      ),
    );
  }
}
