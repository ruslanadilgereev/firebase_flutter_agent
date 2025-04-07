class Item {
  final List<String> dates;
  final String name;
  final bool optional;
  final int quantity;
  final String notes;
  bool packed;

  Item({
    required this.dates,
    required this.name,
    required this.optional,
    required this.quantity,
    this.notes = '',
    this.packed = false,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? datesJson = json['dates'] as List<dynamic>?;
    final List<String> dates =
        datesJson?.map((date) => date.toString()).toList() ?? [];
    var name = json['name'] ?? '';
    var optional = json['optional'] as bool? ?? false;
    var quantity = json['quantity'] as int? ?? 0;
    var notes = json['notes'] as String? ?? '';

    return Item(
      dates: dates,
      name: name,
      optional: optional,
      quantity: quantity,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dates': dates,
      'name': name,
      'optional': optional,
      'quantity': quantity,
      'notes': notes,
    };
  }

  num togglePacked() {
    packed = !packed;
    // Return the quantity if packed, otherwise return the negative quantity.
    // This is useful for tracking the change in the number of packed items.
    return packed ? quantity : -quantity;
  }
}
