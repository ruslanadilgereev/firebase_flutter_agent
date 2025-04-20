import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../settings/styles.dart';
import '../../settings/theme.dart';
import '../../models/packing_list_model.dart';
import '../../models/item_model.dart';

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
          padding: EdgeInsets.symmetric(horizontal: Size.l, vertical: Size.xs),
          child: Column(
            children: [
              if (item.notes.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: Size.m),
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
                    horizontal: Size.s,
                    vertical: Size.xs,
                  ),
                  child: Chip(
                    color: WidgetStateProperty.all(offWhite),
                    label: Text(
                      style: TextStyle(fontSize: Size.m),
                      e.toString(),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
