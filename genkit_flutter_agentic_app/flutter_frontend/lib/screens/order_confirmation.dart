import 'package:flutter/material.dart';
import 'package:flutter_app/models/order_confirmation_model.dart';
import 'package:flutter_app/settings/styles.dart';
import 'package:flutter_app/settings/theme.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Spacing.l),
          child: ListView(
            children: [
              Text(
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
                'Hey, thanks for shopping with us!\nHave a great trip!',
              ),
              SizedBox.square(dimension: Spacing.l),
              ...orderConfirmation.items.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: Spacing.s),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        style: GoogleFonts.caveat(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                        '${item.quantity.toString()}x',
                      ),
                      SizedBox.square(dimension: Spacing.l),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.caveat(
                                height: 0,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              item.name,
                            ),
                            if (item.quantity > 1)
                              Text(
                                style: GoogleFonts.caveat(fontSize: 20),
                                '\$${item.price.toString()} ea.',
                              ),
                          ],
                        ),
                      ),
                      SizedBox.square(dimension: Spacing.m),
                      Text(
                        style: GoogleFonts.caveat(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        '\$${item.totalPrice.toString()}',
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox.square(dimension: Spacing.m),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    style: GoogleFonts.caveat(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    'Total: \$${orderConfirmation.totalPrice}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GoHomeButton(),
    );
  }
}

class GoHomeButton extends StatelessWidget {
  const GoHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Spacing.m),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed:
              () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: Icon(Icons.home),
          label: Text(
            style: TextStyle(fontSize: 24),
            'Great! Go back to main menu.',
          ),
        ),
      ),
    );
  }
}
