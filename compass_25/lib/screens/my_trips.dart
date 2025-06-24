// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cupertino_compass/model/app_data.dart';
import 'package:cupertino_compass/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../adaptive/widgets.dart' as adaptive;
import '../model/booking.dart';
import '../router.dart';
import '../widgets/title_text.dart';
import 'booking.dart';

class MyTripsScreen extends StatefulWidget {
  final CompassAppData appData;
  const MyTripsScreen({required this.appData, super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  List<Booking>? _bookings;
  StreamSubscription<List<Booking>>? _bookingsSubscription;

  @override
  void initState() {
    super.initState();
    widget.appData.getDestinations().then((_) {
      _streamBookings();
    });
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    super.dispose();
  }

  void _streamBookings() {
    _bookingsSubscription = widget.appData.bookingStream.listen((newBookings) {
      setState(() {
        _bookings = newBookings;
      });
    });
    _fetchInitialBookings();
  }

  Future<void> _fetchInitialBookings() async {
    var initialBookings = await widget.appData.getBookings();
    await widget.appData.getDestinations();
    setState(() {
      _bookings = initialBookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppBar(
              title: const TitleText(text: "Sofie's Activities", size: 32),
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
          ),
          if (_bookings == null)
            SliverFixedExtentList.list(
              itemExtent: 400,
              children: [],
            )
          else ...[
            SliverLayoutBuilder(
              builder: (context, sliverConstraints) {
                final viewPortSize = sliverConstraints.viewportMainAxisExtent;
                final remainingPaintExtent =
                    viewPortSize - sliverConstraints.remainingPaintExtent;
                double profileSize = 128.0;
                if (remainingPaintExtent < 400) {
                  profileSize = remainingPaintExtent / 2;
                  if (profileSize < 96) {
                    profileSize = 96;
                  }
                }

                return SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment:
                        Platform.isIOS
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: profileSize,
                          height: profileSize,
                          child: const _ProfilePicture(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (_bookings!.isEmpty)
              SliverFixedExtentList.list(
                itemExtent: 64,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment:
                          Platform.isIOS
                              ? Alignment.center
                              : Alignment.centerLeft,
                      child: Text(
                        'No activities yet',
                        style: TextTheme.of(
                          context,
                        ).bodyLarge?.copyWith(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ],
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  var booking = _bookings![index];
                  return ListTile(
                    title: Text(
                      widget.appData
                          .getDestination(booking.destinationRef)
                          .name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      dateFormatStartEnd(
                        DateTimeRange(
                          start: booking.startDate,
                          end: booking.endDate,
                        ),
                      ),
                    ),
                    onTap: () {
                      adaptive.showBottomSheetAdaptive(
                        context: context,
                        navigatorState: navigatorKey.currentState,
                        child: BookingScreen(
                          booking: booking,
                          appData: context.read<CompassAppData>(),
                          showBookingButton: false,
                        ),
                      );
                    },
                  );
                }, childCount: _bookings!.length),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        "assets/user.jpg",
        fit: BoxFit.cover,
        semanticLabel: "Profile picture",
      ),
    );
  }
}
