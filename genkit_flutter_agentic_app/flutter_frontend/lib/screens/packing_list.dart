import 'package:flutter/material.dart';
import 'package:flutter_app/settings/theme.dart';

import 'package:provider/provider.dart';
import '../models/packing_list_model.dart';
import 'package:google_fonts/google_fonts.dart';
import './components.dart';
import '../models/item_model.dart';
import '../settings/styles.dart';
import './order_confirmation.dart';

class PackingListScreen extends StatefulWidget {
  const PackingListScreen({super.key});

  @override
  State<PackingListScreen> createState() => _PackingListScreenState();
}

class _PackingListScreenState extends State<PackingListScreen> {
  @override
  Widget build(BuildContext context) {
    var packingList = context.watch<PackingListModel>();

    var location = '${packingList.locationCity}, ${packingList.locationState}';
    var lengthOfStay = '${packingList.lengthOfStay.toString()} days';
    var weather = packingList.weatherForecast;
    var items = packingList.items;
    var heroImageUrl = packingList.heroImageUrl;
    var itemsRemaining = packingList.totalQuantity - packingList.totalPacked;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, val) {
          return [
            HeroAppBar(title: MyPackingListTitle(), imageUrl: heroImageUrl!),
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(Spacing.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(textAlign: TextAlign.center, style: headerStyle, location),
              Text(style: subheaderStyle, lengthOfStay),
              SizedBox.square(dimension: Spacing.xs),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.m,
                  vertical: Spacing.s,
                ),
                child: Text(style: paragraphStyle, weather),
              ),
              SizedBox.square(dimension: Spacing.xs),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Item item = items[index];
                    return ItemTile(itemIndex: index, item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          itemsRemaining > 0
              ? BuyButton(itemQuantity: itemsRemaining)
              : AllPackedBanner(),
    );
  }
}

class HeroAppBar extends StatelessWidget {
  const HeroAppBar({required this.title, required this.imageUrl, super.key});

  final Widget title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actionsPadding: EdgeInsets.zero,
      pinned: true,
      expandedHeight: heroAppBarHeight,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: title,
        background: Stack(
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
                errorBuilder: (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return Center(child: Text('Failed to load image'));
                },
                fit: BoxFit.cover,
                imageUrl,
              ),
            ),
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withAlpha(0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllPackedBanner extends StatelessWidget {
  const AllPackedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(Spacing.m),
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

class BuyButton extends StatefulWidget {
  const BuyButton({required this.itemQuantity, super.key});

  final int itemQuantity;

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Spacing.m),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed:
              _loading
                  ? null
                  : () async {
                    setState(() {
                      _loading = true;
                    });
                    try {
                      var orderConfirmation = await context
                          .read<PackingListModel>()
                          .orderRemaining(context);
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
                  },
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
                    'Buying ${widget.itemQuantity} items...',
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

class ItemTile extends StatelessWidget {
  const ItemTile({required this.itemIndex, required this.item, super.key});

  final int itemIndex;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Text(
        style: GoogleFonts.caveat(fontSize: 36),
        item.quantity.toString(),
      ),
      title: Text(
        item.name,
        style: GoogleFonts.caveat(
          fontSize: 28,
          decoration: item.packed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: item.packed,
        onChanged:
            (_) => context.read<PackingListModel>().togglePacked(itemIndex),
      ),
      subtitle:
          item.optional
              ? Text(
                style: TextStyle(
                  fontSize: 20,
                  decoration: item.packed ? TextDecoration.lineThrough : null,
                ),
                'optional',
              )
              : null,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.l,
            vertical: Spacing.xs,
          ),
          child: Column(
            children: [
              if (item.notes.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: Spacing.m),
                  child: Text(style: paragraphStyle, item.notes),
                ),
              WrappedChips(values: item.dates),
            ],
          ),
        ),
      ],
    );
  }
}

class WrappedChips extends StatelessWidget {
  const WrappedChips({required this.values, super.key});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children:
          values
              .map(
                (e) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.s,
                    vertical: Spacing.xs,
                  ),
                  child: Chip(
                    color: WidgetStateProperty.all(offWhite),
                    label: Text(
                      style: TextStyle(fontSize: Spacing.m),
                      e.toString(),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
