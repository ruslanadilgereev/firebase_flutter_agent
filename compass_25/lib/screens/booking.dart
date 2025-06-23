// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../adaptive/widgets.dart' as adaptive;
import '../model/model.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/back_button.dart';
import '../widgets/tag_chip.dart';

class BookingScreen extends StatefulWidget {
  final CompassAppData appData;
  final Booking booking;
  final bool showBookingButton;

  const BookingScreen({
    required this.booking,
    required this.appData,
    this.showBookingButton = true,
    super.key,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final Destination destination;
  List<Activity>? activities;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    var appData = widget.appData;

    // Fetch the Destination for this booking
    destination = appData.getDestination(widget.booking.destinationRef);

    // Fetch the activities associated with this booking
    appData.getActivities(destination.ref).then((_) {
      setState(() {
        activities = appData.getActivitiesFromRefs(
          widget.booking.activitiesRefs,
        );
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  _HeaderImage(destination: destination),
                  const Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: _Gradient(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _Headline(
                      booking: widget.booking,
                      destination: destination,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 280),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      destination.knownFor,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: _Tags(destination: destination),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 30.0,
                    ),
                    child: Text(
                      'Your Chosen Activities',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(fontSize: 18),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities?.length ?? 0,
                    itemBuilder: (context, index) {
                      final activity = activities![index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: activity.imageUrl,
                                height: 80,
                                width: 80,
                                fadeInDuration: Duration(milliseconds: 200),
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      color: Colors.grey[300],
                                      width: 80,
                                      height: 80,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    activity.timeOfDay.toString().toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    activity.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    activity.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: AdaptiveBackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          if (widget.showBookingButton)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BookButton(
                onPressed: () {
                  context.read<CompassAppData>().saveBooking(widget.booking);

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.go('/my_trips');
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BookButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final button = adaptive.Button(
      onPressed: onPressed,
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(10.0),
      child: Text(
        'Book',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    return ClipRect(
      child:
          Platform.isIOS
              ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: 0.6),
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 48,
                    left: 16,
                    right: 16,
                  ),
                  child: SizedBox(width: double.infinity, child: button),
                ),
              )
              : Container(
                color: Theme.of(
                  context,
                ).scaffoldBackgroundColor.withValues(alpha: 0.6),
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 24,
                  left: 16,
                  right: 16,
                ),
                child: SizedBox(width: double.infinity, child: button),
              ),
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...destination.tags.map(
          (tag) => TagChip(
            tag: tag,
            fontSize: 16,
            height: 32,
            chipColor: Colors.grey.shade200,
            onChipColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.booking, required this.destination});

  final Booking booking;
  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            Text(
              dateFormatStartEnd(
                DateTimeRange(start: booking.startDate, end: booking.endDate),
              ),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: destination.imageUrl,
      fadeInDuration: Duration(milliseconds: 200),
      fit: BoxFit.fitWidth,
      width: MediaQuery.of(context).size.width,
      placeholder: (context, url) {
        return Container(
          color: Colors.grey[300],
          width: MediaQuery.of(context).size.width,
        );
      },
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.3, 1.0],
          colors: const [Colors.white10, Colors.white],
        ),
      ),
    );
  }
}
