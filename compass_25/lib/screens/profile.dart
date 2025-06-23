import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../auth.dart';
import '../theme.dart';
import '../widgets/title_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  final int _trips = 25;
  final int _countriesVisited = 8;
  DateTime? _selectedBirthdate;

  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoTheme(
            data: _defaultCupertinoThemeData,
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.25,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (picked) {
                  setState(() {
                    _selectedBirthdate = picked;
                  });
                },
                initialDateTime: _selectedBirthdate ?? DateTime.now(),
                minimumDate: DateTime(1900),
                maximumDate: DateTime.now(),
              ),
            ),
          );
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedBirthdate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != _selectedBirthdate) {
        setState(() {
          _selectedBirthdate = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverLayoutBuilder(
            builder: (context, sliverConstraints) {
              final viewPortSize = sliverConstraints.viewportMainAxisExtent;
              final remainingPaintExtent =
                  viewPortSize - sliverConstraints.remainingPaintExtent;
              double profileSize = 200.0;
              if (remainingPaintExtent < 200) {
                profileSize = remainingPaintExtent;
                if (profileSize < 128) {
                  profileSize = 128;
                }
                if (profileSize > 200) {
                  profileSize = 200;
                }
              }

              return SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 64),
                      const TitleText(text: 'Sofie Doe'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: profileSize,
                        height: profileSize,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/user.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Trips',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGrey,
                                ),
                              ),
                              Text(
                                '$_trips',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          Column(
                            children: [
                              const Text(
                                'Countries',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGrey,
                                ),
                              ),
                              Text(
                                '$_countriesVisited',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                _SectionTile(
                  title: 'Settings',
                  subtitle: 'Notifications',
                  trailing: NotificationSwitch(
                    notificationsEnabled: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
                Link(
                  uri: Uri.parse('https://flutter.dev'),
                  builder: (BuildContext context, FollowLink? followLink) {
                    return _SectionTile(
                      title: 'Support',
                      subtitle: 'Flutter.dev',
                      onTap: followLink,
                    );
                  },
                ),
                _SectionTile(
                  title: 'Birthdate',
                  subtitle:
                      _selectedBirthdate == null
                          ? 'Not set'
                          : DateFormat.yMMMd().format(_selectedBirthdate!),
                  onTap: () => _selectDate(context),
                ),
                _SectionTile(
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  onTap: () {
                    context.read<CompassAppAuth>().logout();
                  },
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? child;
  final VoidCallback? onTap;

  const _SectionTile({
    required this.title,
    this.subtitle,
    this.trailing,
    // ignore: unused_element_parameter
    this.child,
    this.onTap,
  });

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle _subtitleStyle = TextStyle(
    color: AppColors.textGrey,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 2.0),
                    child: Text(title, style: _titleStyle),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(subtitle!, style: _subtitleStyle),
                    ),
                  if (child != null) child!,
                ],
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationSwitch extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onChanged;

  const NotificationSwitch({
    super.key,
    required this.notificationsEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(value: notificationsEnabled, onChanged: onChanged);
    } else {
      return Switch(value: notificationsEnabled, onChanged: onChanged);
    }
  }
}

final CupertinoThemeData _defaultCupertinoThemeData = CupertinoThemeData.raw(
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
);
