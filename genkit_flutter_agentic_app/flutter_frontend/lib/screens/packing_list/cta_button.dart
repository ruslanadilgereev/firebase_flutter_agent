import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/packing_list_model.dart';
import '../../settings/styles.dart';
import '../order_confirmation/order_confirmation_screen.dart';

class CTAButton extends StatelessWidget {
  const CTAButton({required this.itemsRemaining, super.key});

  final int itemsRemaining;

  @override
  Widget build(BuildContext context) {
    return itemsRemaining > 0
        ? BuyButton(itemQuantity: itemsRemaining)
        : AllPackedBanner();
  }
}

class BuyButton extends StatefulWidget {
  const BuyButton({required this.itemQuantity, super.key});

  final int itemQuantity;

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool _loading = false;

  void purchaseRemainingItems(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      var orderConfirmation =
          await context.read<PackingListModel>().orderRemaining();
      if (!context.mounted || orderConfirmation == null) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return OrderConfirmationScreen(
              orderConfirmation: orderConfirmation,
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Size.m),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: _loading ? null : () => purchaseRemainingItems(context),
          icon:
              _loading
                  ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                  : Icon(size: 32, Icons.shopping_bag_outlined),
          label:
              _loading
                  ? Text(
                    style: TextStyle(fontSize: 24),
                    'Ordering ${widget.itemQuantity} items...',
                  )
                  : Text(
                    style: TextStyle(fontSize: 24),
                    'Buy ${widget.itemQuantity} remaining items',
                  ),
        ),
      ),
    );
  }
}

// Banner that says "all packed!"
class AllPackedBanner extends StatelessWidget {
  const AllPackedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(Size.m),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              '🥳 All packed and ready to go! 🛫',
            ),
          ],
        ),
      ),
    );
  }
}
