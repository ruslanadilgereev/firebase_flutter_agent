// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/activity.dart';
import '../theme.dart';
import 'checkbox.dart';

class ActivityEntry extends StatelessWidget {
  const ActivityEntry({
    super.key,
    required this.showCheckbox,
    required this.activity,
    this.selected = false,
    this.onChanged,
  });

  final bool showCheckbox;
  final Activity activity;
  final bool selected;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: activity.imageUrl,
                  height: 80,
                  width: 80,
                  fadeInDuration: Duration(milliseconds: 200),
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Container(
                      color: Colors.grey[300],
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    activity.timeOfDay.name.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    activity.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            if (showCheckbox)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomCheckbox(
                  key: ValueKey('${activity.ref}-checkbox'),
                  value: selected,
                  backgroundColor: AppColors.primary,
                  onChanged: onChanged ?? (b) {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
