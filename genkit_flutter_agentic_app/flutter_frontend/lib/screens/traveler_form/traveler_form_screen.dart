import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../models/packing_list_model.dart';
import '../../models/traveler_form_model.dart';
import '../packing_list/packing_list_screen.dart';
import '../components.dart';
import './get_packing_list_button.dart';
import './input_widgets.dart';

class TravelerFormScreen extends StatefulWidget {
  const TravelerFormScreen({super.key});

  @override
  State<TravelerFormScreen> createState() => _TravelerFormScreenState();
}

class _TravelerFormScreenState extends State<TravelerFormScreen> {
  bool _loading = false;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _lengthOfStayController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If the user hits "back" from the packing list page, restore existing query
    _locationController.text = context.read<TravelerFormModel>().location;
    if (context.read<TravelerFormModel>().lengthOfStay != 0) {
      _lengthOfStayController.text =
          context.read<TravelerFormModel>().lengthOfStay.toString();
    }
    _preferencesController.text = context.read<TravelerFormModel>().preferences;
  }

  void getPackingList(BuildContext context) async {
    TravelerFormModel form = context.read<TravelerFormModel>();

    // Validate that user's form has all necessary fields filled out
    var errors = form.validate();

    // If there's errors in the form, alert the user and do not proceed.
    if (errors.isNotEmpty) {
      String errorMessage = errors.join('\n');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // Load packing list data from Genkit PackingListHelper Flow
      var packingList = await PackingListModel.load(
        form.location,
        form.lengthOfStay,
        form.preferences,
      );

      if (!context.mounted) {
        return;
      }

      // Push a Packing List Screen with the packing list data.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ChangeNotifierProvider.value(
                value: packingList,
                child: PackingListScreen(),
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: ${e.toString()}')),
      );
      return;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyPackingListTitle(), centerTitle: true),
      body: BodyWhitespace(
        child:
            _loading // If loading show the Progress indicator, otherwise show the form
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    LocationInput(controller: _locationController),
                    TripLengthInput(controller: _lengthOfStayController),
                    PreferencesInput(controller: _preferencesController),
                    GetPackingListButton(
                      onPressed: () => getPackingList(context),
                    ),
                  ],
                ),
      ),
    );
  }
}
