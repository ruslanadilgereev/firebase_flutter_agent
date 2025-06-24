import 'package:cupertino_compass/router.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../adaptive/widgets.dart' as adaptive;
import '../model/model.dart';
import '../theme.dart';
import '../utils.dart';

class Search {
  final Continent? continent;
  final Location? location;
  final DateTimeRange? dateTimeRange;
  final int? guests;

  Search({this.continent, this.dateTimeRange, this.guests, this.location});

  @override
  String toString() {
    return 'Search(continent: $continent, location: $location, dateTimeRange: $dateTimeRange, guests: $guests)';
  }
}

class SearchScreen extends StatefulWidget {
  final ValueChanged<Search> onSearch;
  const SearchScreen({super.key, required this.onSearch});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTimeRange? dateTimeRange;
  int guests = 1;
  Continent? continent;
  Location? location;

  bool get isValid => dateTimeRange != null && guests > 0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If no location is selected, use the continent's location
      Location? finalLocation = location;
      if (finalLocation == null && continent != null) {
        finalLocation = continent!.location;
      }

      widget.onSearch(
        Search(
          continent: continent,
          location: finalLocation,
          dateTimeRange: dateTimeRange,
          guests: guests,
        ),
      );
      navigatorKey.currentState?.pop();
    } else {
      // Handle invalid form
    }
  }

  void _clearSearch() {
    widget.onSearch(Search());
    navigatorKey.currentState?.pop();
  }

  Continent? findClosestContinent(
    Location location,
    List<Continent> continents,
  ) {
    if (continents.isEmpty) {
      return null;
    }

    return continents.reduce((a, b) {
      final distanceA = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        a.location.latitude,
        a.location.longitude,
      );
      final distanceB = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        b.location.latitude,
        b.location.longitude,
      );
      return distanceA < distanceB ? a : b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              navigatorKey.currentState?.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 64),
                child: Text(
                  "Search for activities across the world",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SearchFormDate(
                onDateRangeChanged: (DateTimeRange? value) {
                  setState(() {
                    dateTimeRange = value;
                  });
                },
              ),
              SearchFormGuests(
                guests: guests,
                onGuestsChanged: (guests) {
                  setState(() {
                    this.guests = guests;
                  });
                },
              ),
              SearchFormLocation(
                continent: continent,
                location: location,
                onLocationChanged: (location) {
                  setState(() {
                    this.location = location;
                    if (location != null) {
                      final closestContinent = findClosestContinent(
                        location,
                        context.read<CompassAppData>().continents,
                      );
                      if (closestContinent != null) {
                        continent = closestContinent;
                      }
                    }
                  });
                },
              ),
              SearchFormSubmit(valid: isValid, onPressed: _submitForm),
              TextButton(
                onPressed: _clearSearch,
                child: const Text(
                  'Clear Search',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchFormDate extends FormField<DateTimeRange> {
  SearchFormDate({
    super.key,
    required ValueChanged<DateTimeRange?> onDateRangeChanged,
  }) : super(
         initialValue: null,
         builder: (FormFieldState<DateTimeRange> state) {
           return _SearchFormDateInner(
             onDateRangeChanged: (DateTimeRange? value) {
               state.didChange(value);
               onDateRangeChanged(value);
             },
             dateRange: state.value,
           );
         },
       );
}

class _SearchFormDateInner extends StatefulWidget {
  const _SearchFormDateInner({
    required this.onDateRangeChanged,
    required this.dateRange,
  });

  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final DateTimeRange? dateRange;

  @override
  State<_SearchFormDateInner> createState() => _SearchFormDateInnerState();
}

class _SearchFormDateInnerState extends State<_SearchFormDateInner> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _dateRange = widget.dateRange;
  }

  @override
  Widget build(BuildContext ontext) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: _GrayscaleTapEffect(
        onTap: () async {
          final dateRange = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (dateRange != null) {
            setState(() {
              _dateRange = dateRange;
            });
            widget.onDateRangeChanged(dateRange);
          }
        },
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('When', style: Theme.of(context).textTheme.titleMedium),
                if (_dateRange != null)
                  Text(
                    dateFormatStartEnd(_dateRange!),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                else
                  Text(
                    "Add Dates",
                    style: Theme.of(context).inputDecorationTheme.hintStyle,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const String removeGuestsKey = 'remove-guests';
const String addGuestsKey = 'add-guests';

class SearchFormGuests extends FormField<int> {
  SearchFormGuests({
    super.key,
    required int guests,
    required ValueChanged<int> onGuestsChanged,
  }) : super(
         initialValue: guests,
         builder: (FormFieldState<int> state) {
           return _SearchFormGuestsInner(
             guests: state.value!,
             onGuestsChanged: (guests) {
               state.didChange(guests);
               onGuestsChanged(guests);
             },
           );
         },
       );
}

class _SearchFormGuestsInner extends StatelessWidget {
  const _SearchFormGuestsInner({
    required this.guests,
    required this.onGuestsChanged,
  });

  final int guests;
  final ValueChanged<int> onGuestsChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Number of guests',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _QuantitySelector(
                guests: guests,
                onGuestsChanged: onGuestsChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.guests,
    required this.onGuestsChanged,
  });

  final int guests;
  final ValueChanged<int> onGuestsChanged;

  @override
  Widget build(BuildContext context) {
    const Color grey = Colors.grey;
    const double buttonSize = 48;
    const double borderRadius = 16;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: InkWell(
              // Keeping InkWell for the +/- buttons' feedback
              key: const ValueKey(removeGuestsKey),
              borderRadius: BorderRadius.circular(borderRadius),
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                if (guests > 0) {
                  onGuestsChanged(guests - 1);
                }
              },
              child: const Icon(Icons.remove_circle_outline, color: grey),
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Center(
            child: Text(
              guests.toString(),
              style:
                  guests == 0
                      ? Theme.of(context).inputDecorationTheme.hintStyle
                      : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: InkWell(
              // Keeping InkWell for the +/- buttons' feedback
              key: const ValueKey(addGuestsKey),
              borderRadius: BorderRadius.circular(borderRadius),
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                onGuestsChanged(guests + 1);
              },
              child: const Icon(Icons.add_circle_outline, color: grey),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchFormSubmit extends StatelessWidget {
  const SearchFormSubmit({
    super.key,
    required this.valid,
    required this.onPressed,
  });

  final bool valid;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
      child: SizedBox(
        height: 52,
        child: adaptive.Button(
          color: AppColors.primary,
          onPressed: valid ? onPressed : null,
          child: const Center(
            child: Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class SearchFormLocation extends FormField<Location> {
  SearchFormLocation({
    super.key,
    final Location? location,
    required ValueChanged<Location?> onLocationChanged,
    required Continent? continent,
  }) : super(
         initialValue: location,
         builder: (FormFieldState<Location> state) {
           return _SearchFormLocationInner(
             onLocationChanged: (location) {
               state.didChange(location);
               onLocationChanged(location);
             },
             currentLocation: state.value,
             continent: continent,
           );
         },
       );
}

class _SearchFormLocationInner extends StatefulWidget {
  const _SearchFormLocationInner({
    required this.onLocationChanged,
    this.currentLocation,
    required this.continent,
  });

  final ValueChanged<Location?> onLocationChanged;
  final Location? currentLocation;
  final Continent? continent;

  @override
  State<_SearchFormLocationInner> createState() =>
      _SearchFormLocationInnerState();
}

class _SearchFormLocationInnerState extends State<_SearchFormLocationInner> {
  Location? _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.currentLocation;
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    _setLocation(position);
  }

  void _setLocation(Position position) {
    setState(() {
      _currentLocation = Location(position.latitude, position.longitude);
      widget.onLocationChanged(_currentLocation);
    });
  }

  Future<bool> _checkLocationPermission() async {
    final hasPermission = await Geolocator.isLocationServiceEnabled();
    if (!hasPermission) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    if (!hasPermission) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: _GrayscaleTapEffect(
        onTap: _getCurrentLocation,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Where',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _currentLocation == null
                    ? const Icon(Icons.location_on)
                    : const Icon(Icons.check_circle_outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GrayscaleTapEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const _GrayscaleTapEffect({
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  State<_GrayscaleTapEffect> createState() => _GrayscaleTapEffectState();
}

class _GrayscaleTapEffectState extends State<_GrayscaleTapEffect> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: widget.onTap,
        splashFactory: NoSplash.splashFactory,
        child: widget.child,
      ),
    );
  }
}
