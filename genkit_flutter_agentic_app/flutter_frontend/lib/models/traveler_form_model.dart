import 'package:flutter/material.dart';

class TravelerFormModel extends ChangeNotifier {
  String location;
  int lengthOfStay;
  String preferences;

  TravelerFormModel({
    this.location = '',
    this.lengthOfStay = 0,
    this.preferences = '',
  });

  List<String> validate() {
    List<String> errors = [];

    if (location.isEmpty) {
      errors.add('Where are you going? The location field can\'t be empty!');
    }

    if (lengthOfStay <= 0) {
      errors.add(
        'How long are you staying? The length of your stay has to be greater than 0!',
      );
    }

    return errors;
  }
}
