import 'package:flutter/material.dart';
import 'package:flutter_fix_warehouse/pages/home_page/home_page.dart';

import '../../styles.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/gt_button.dart';
import '../../widgets/sparkle_leaf.dart';
import '../wizard_page/wizard_page.dart';

class HomePageBodyMobile extends StatelessWidget {
  const HomePageBodyMobile({super.key, required this.projects});

  final List<ProjectIdea> projects;

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[
      _ProjectIdeaMobile(
        image: 'assets/woman-gardening.png',
        title: 'Grow a beautiful Spring flower garden.',
      ),
      _GreenThumbCardMobile(),
      _ProjectIdeaMobile(
        image: 'assets/tomato_trellis.jpeg',
        title: 'Smart ways to start a vegetable garden.',
      ),

      _ProjectIdeaMobile(
        image: 'assets/patio_garden.jpeg',
        title: 'Build your garden oasis.',
      ),
      _ProjectIdeaMobile(
        image: 'assets/wildflowers.jpeg',
        title: 'Plant wild flowers with seeds.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.defaultPadding,
            vertical: 8,
          ),
          child: Text(
            'Home / DIY Projects & Ideas / Outdoor Living',
            style: AppTextStyles.breadcrumb,
          ),
        ),
        SizedBox(height: AppLayout.defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.defaultPadding,
          ),
          child: Text('Garden project ideas', style: AppTextStyles.heading),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: projects.length + 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: AppLayout.defaultPadding,
                  right: AppLayout.defaultPadding,
                  bottom: AppLayout.defaultPadding,
                ),
                child: listItems[index],
              );
            },
          ),
        ),
        const AppNavigationBar(),
      ],
    );
  }
}

class _GreenThumbCardMobile extends StatelessWidget {
  const _GreenThumbCardMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Looking for gardening help?', style: AppTextStyles.subheading),
          Padding(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              top: 8,
              bottom: 16,
            ),
            child: Text(
              'Use GreenThumb to get personalized insights about your plants.',
            ),
          ),
          SizedBox(height: AppLayout.defaultPadding),
          GtButton(
            style: GtButtonStyle.elevated,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WizardPage()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SparkleLeaf(size: 24, leafSize: 20, sparkleSize: 10),
                SizedBox(width: 8),
                Text('Try GreenThumb', style: AppTextStyles.button),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectIdeaMobile extends StatelessWidget {
  const _ProjectIdeaMobile({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.asset(
              image,
              width: double.infinity,
              fit: BoxFit.cover,
              height: 200,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppLayout.defaultPadding / 2),
                decoration: BoxDecoration(color: Colors.white60),
                child: Text(title, style: AppTextStyles.subheading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
