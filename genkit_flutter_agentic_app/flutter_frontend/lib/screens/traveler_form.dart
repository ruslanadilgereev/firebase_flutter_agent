import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/packing_list_model.dart';
import '../models/traveler_form_model.dart';
import './components.dart';
import './packing_list.dart';
import '../settings/styles.dart';

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
    _locationController.text = context.read<TravelerFormModel>().location;

    if (context.read<TravelerFormModel>().lengthOfStay != 0) {
      _lengthOfStayController.text =
          context.read<TravelerFormModel>().lengthOfStay.toString();
    }

    _preferencesController.text = context.read<TravelerFormModel>().preferences;
  }

  void getPackingList(BuildContext context) async {
    TravelerFormModel form = context.read<TravelerFormModel>();

    // Validate form has all necessary fields
    var errors = form.validate();

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

    // Load packing list from server
    try {
      var packingList = await PackingListModel.load(
        form.location,
        form.lengthOfStay,
        form.preferences,
      );

      if (!context.mounted) {
        return;
      }

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
    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: MyPackingListTitle(), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(Spacing.l),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(Spacing.l),
                child: Form(
                  child: Column(
                    children: [
                      LocationInput(controller: _locationController),
                      SizedBox.square(dimension: Spacing.xl),
                      TripLengthInput(controller: _lengthOfStayController),
                      SizedBox.square(dimension: Spacing.xl),
                      PreferencesInput(controller: _preferencesController),
                    ],
                  ),
                ),
              ),
              SizedBox.square(dimension: Spacing.l),
              GetPackingListButton(onPressed: () => getPackingList(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class GetPackingListButton extends StatelessWidget {
  const GetPackingListButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: Spacing.s, horizontal: Spacing.l),
        ),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18),
        ),
        foregroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
      ),
      label: Text(style: TextStyle(fontSize: 24), 'Get my packing list'),
      onPressed: onPressed,
      icon: const Icon(Icons.luggage, size: 32),
    );
  }
}

class PreferencesInput extends StatelessWidget {
  const PreferencesInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          style: inter16Bold,
          textAlign: TextAlign.center,
          'Requirements or preferences?',
        ),
        Text(
          style: inter16,
          textAlign: TextAlign.center,
          'Let us know if you need to pack for formal events, activities, etc.',
        ),
        TextFormField(
          controller: controller,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: userInputStyle28,
          onChanged:
              (preferences) =>
                  context.read<TravelerFormModel>().preferences = preferences,
        ),
      ],
    );
  }
}

class TripLengthInput extends StatelessWidget {
  const TripLengthInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('How long is your trip?', style: inter16Bold),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.center,
                style: userInputStyle48,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: '3',
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged:
                    (days) =>
                        context.read<TravelerFormModel>().lengthOfStay =
                            int.tryParse(days) ?? 0,
              ),
            ),
            Text('days', style: TextStyle(fontSize: 32)),
          ],
        ),
      ],
    );
  }
}

class LocationInput extends StatelessWidget {
  const LocationInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Where are you going?', style: inter16Bold),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(hintText: 'Honolulu, Hawaii'),
          onChanged:
              (location) =>
                  context.read<TravelerFormModel>().location = location,
          style: userInputStyle28,
        ),
      ],
    );
  }
}
