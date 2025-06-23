// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_compass/auth.dart';
import 'package:flutter/services.dart';

import 'activity.dart';
import 'booking.dart';
import 'continent.dart';
import 'destination.dart';

class CompassAppData {
  final CompassAppAuth _auth;
  List<Destination>? _destinations;
  List<Activity>? _activities;

  final _bookingsController = StreamController<List<Booking>>.broadcast();
  StreamSubscription<QuerySnapshot>? _bookingsSubscription;

  CompassAppData({required CompassAppAuth auth}) : _auth = auth {
    // Listen for auth state changes, and subscribe to bookings
    // if the user is logged in.
    _auth.addListener(() {
      if (_auth.isLoggedIn) {
        _listenForBookingChanges();
      } else {
        _bookingsSubscription?.cancel();
      }
    });
    getDestinations();
  }

  Stream<List<Booking>> get bookingStream => _bookingsController.stream;

  CollectionReference<Map<String, dynamic>> _bookingsRef(String? userId) {
    if (userId == null) {
      throw Exception('Null User ID while accessing Firestore');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookings');
  }

  Future<void> saveBooking(Booking booking) async {
    final bookingsCollection = _bookingsRef(_auth.userId);
    await bookingsCollection.add(booking.toJson());
  }

  Future<List<Booking>> getBookings() async {
    final bookingsCollection = _bookingsRef(_auth.userId);
    final snapshot = await bookingsCollection.get();
    return snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList();
  }

  void _listenForBookingChanges() {
    final bookingsCollection = _bookingsRef(_auth.userId);
    _bookingsSubscription = bookingsCollection.snapshots().listen((snapshot) {
      final bookings =
          snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList();
      _bookingsController.add(bookings);
    });
  }

  Future<List<Destination>> getDestinations() async {
    if (_destinations == null) {
      final destinationData = await _loadStringAsset(
        'assets/destinations.json',
      );
      _destinations =
          destinationData.map((e) => Destination.fromJson(e)).toList();
    }
    return _destinations!;
  }

  Destination getDestination(String ref) {
    if (_destinations == null) {
      throw (StateError('Destinations not initialized'));
    }
    return _destinations!.firstWhere((d) => d.ref == ref);
  }

  Future<List<Activity>> getActivities(String destinationRef) async {
    if (_activities == null) {
      final activityData = await _loadStringAsset('assets/activities.json');
      _activities = activityData.map((e) => Activity.fromJson(e)).toList();
    }

    return _activities!
        .where((a) => a.destinationRef == destinationRef)
        .toList();
  }

  List<Activity> getActivitiesFromRefs(List<String> refs) {
    if (_activities == null) throw (StateError('Activities not initialized'));
    return _activities!.where((a) => refs.contains(a.ref)).toList();
  }

  List<Continent> get continents {
    return const [
      Continent(
        name: 'Europe',
        imageUrl: 'https://rstr.in/google/tripedia/TmR12QdlVTT',
        location: Location(54.5260, 15.2551),
      ),
      Continent(
        name: 'Asia',
        imageUrl: 'https://rstr.in/google/tripedia/VJ8BXlQg8O1',
        location: Location(34.0479, 100.6197),
      ),
      Continent(
        name: 'South America',
        imageUrl: 'https://rstr.in/google/tripedia/flm_-o1aI8e',
        location: Location(-8.7832, -55.4915),
      ),
      Continent(
        name: 'Africa',
        imageUrl: 'https://rstr.in/google/tripedia/-nzi8yFOBpF',
        location: Location(7.1881, 21.0936),
      ),
      Continent(
        name: 'North America',
        imageUrl: 'https://rstr.in/google/tripedia/jlbgFDrSUVE',
        location: Location(37.0902, -95.7129),
      ),
      Continent(
        name: 'Oceania',
        imageUrl: 'https://rstr.in/google/tripedia/vxyrDE-fZVL',
        location: Location(-22.7832, 140.4915),
      ),
      Continent(
        name: 'Australia',
        imageUrl: 'https://rstr.in/google/tripedia/z6vy6HeRyvZ',
        location: Location(-25.2744, 133.7751),
      ),
    ];
  }

  void dispose() {
    _bookingsController.close();
    _bookingsSubscription?.cancel();
  }
}

Future<List<dynamic>> _loadStringAsset(String asset) async {
  final localData = await rootBundle.loadString(asset);
  return jsonDecode(localData);
}
