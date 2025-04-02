import 'package:flutter/material.dart';
import 'package:flutter_fix_warehouse/main.dart';
import 'package:flutter_fix_warehouse/pages/home_page/home_page_body_mobile.dart';
import 'package:flutter_fix_warehouse/pages/home_page/home_page_body_web.dart';

import '../../styles.dart';

typedef ProjectIdea = ({String image, String title});

final List<ProjectIdea> _projects = [
  (
    image: 'assets/woman-gardening.png',
    title: 'Grow a beautiful Spring flower garden.',
  ),
  (
    image: 'assets/tomato_trellis.jpeg',
    title: 'Smart ways to start a vegetable garden.',
  ),
  (image: 'assets/patio_garden.jpeg', title: 'Build your garden oasis.'),
  (image: 'assets/wildflowers.jpeg', title: 'Plant wild flowers with seeds.'),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.appBackground,
    appBar: AppBar(
      backgroundColor: AppColors.primary,
      toolbarHeight: AppLayout.appBarHeight,
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text('DIY Warehouse', style: AppTextStyles.title),
                const Spacer(),
                Icon(Icons.search, color: AppColors.appBackground),
                SizedBox(width: AppLayout.defaultPadding),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: AppColors.appBackground,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(32),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppLayout.defaultPadding,
            right: AppLayout.defaultPadding,
            bottom: 8,
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.appBackground,
                size: AppLayout.smallIconSize,
              ),
              SizedBox(width: 4),
              Text('Valley Stream - 10pm', style: AppTextStyles.subtitle),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: AppColors.appBackground,
                    size: AppLayout.smallIconSize,
                  ),
                  SizedBox(width: 4),
                  Text('11581', style: AppTextStyles.subtitle),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    body: Builder(
      builder: (context) {
        var width = MediaQuery.of(context).size.width;

        // Creating two wholly different widgets isn't
        // the best way to handling screen size.
        // It's narrow and fragile. But time is of the essence :)
        if (width >= breakpoint) {
          return HomePageBodyWeb(projects: _projects);
        }

        return HomePageBodyMobile(projects: _projects);
      },
    ),
  );
}
