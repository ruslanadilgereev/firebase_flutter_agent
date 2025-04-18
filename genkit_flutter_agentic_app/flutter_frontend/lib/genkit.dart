import 'dart:convert';
import 'package:flutter_app/models/order_confirmation_model.dart';
import 'package:http/http.dart' as http;
import './models/item_model.dart';
import './settings/config.dart';
import './models/packing_list_model.dart';

class Genkit {
  static const Map<String, String> _headers = {
    'content-type': 'application/json',
  };

  // Make call to PackingHelperFlow with traveler preferences and return a PackingList data model.
  static Future<PackingListModel> packingHelperFlow(
    String location,
    int lengthOfStay,
    String preferences,
  ) async {
    var url = Uri.http(genkitServerEndpoint, 'packingHelperFlow');

    var body = json.encode({
      'data': {
        "location": location,
        "numberOfDays": lengthOfStay,
        "preferences": preferences,
      },
    });

    http.Response response;

    try {
      response = await http.post(url, body: body, headers: _headers);
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('Failed to make network call: $e');
    }

    if (response.statusCode == 200) {
      return PackingListModel.fromJson(response.body);
    } else {
      // Handle non-200 status codes (e.g., 404, 500)
      throw Exception(
        'Server responded with a non-200 status code: ${response.statusCode}',
      );
    }
  }

  // Make call to PurchaseFlow with a list of items and return an OrderConfirmation data model.
  static Future<OrderConfirmationModel> purchaseFlow(List<Item> items) async {
    var url = Uri.http(genkitServerEndpoint, 'purchaseFlow');

    var body = json.encode({
      'data': {
        "items":
            items
                .map((item) => {'name': item.name, 'quantity': item.quantity})
                .toList(),
      },
    });

    try {
      http.Response response = await http.post(
        url,
        body: body,
        headers: _headers,
      );

      OrderConfirmationModel orderConfirmation =
          OrderConfirmationModel.fromJson(response.body);

      return orderConfirmation;
    } catch (e) {
      throw Exception('Failed to complete purchase. $e');
    }
  }
}
