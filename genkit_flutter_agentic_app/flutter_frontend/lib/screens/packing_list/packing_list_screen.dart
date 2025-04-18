import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/packing_list_model.dart';
import '../../models/item_model.dart';
import '../components.dart';
import './cta_button.dart';
import './item_tile.dart';
import './hero_app_bar.dart';

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
            HeroAppBar(title: MyPackingListTitle(), imageUrl: heroImageUrl),
          ];
        },
        body: BodyWhitespace(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PageTitle(text: location),
              PageSubtitle(text: lengthOfStay),
              ParagraphText(text: weather),
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
      bottomNavigationBar: CTAButton(itemsRemaining: itemsRemaining),
    );
  }
}
