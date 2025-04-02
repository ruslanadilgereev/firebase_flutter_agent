import 'package:flutter/material.dart';
import 'package:flutter_fix_warehouse/pages/home_page/home_page.dart';
import 'package:flutter_fix_warehouse/widgets/app_navigation_bar.dart';

import '../../styles.dart';
import '../../widgets/gt_button.dart';
import '../../widgets/sparkle_leaf.dart';
import '../wizard_page/wizard_page.dart';

class HomePageBodyWeb extends StatelessWidget {
  const HomePageBodyWeb({super.key, required this.projects});

  final List<ProjectIdea> projects;

  @override
  Widget build(BuildContext context) {
    var listItems = [
      _ProjectIdeaWeb(
        image: 'assets/woman-gardening.png',
        title: 'Grow a beautiful Spring flower garden.',
      ),
      _ProjectIdeaWeb(
        image: 'assets/tomato_trellis.jpeg',
        title: 'Smart ways to start a vegetable garden.',
      ),

      _ProjectIdeaWeb(
        image: 'assets/patio_garden.jpeg',
        title: 'Build your garden oasis.',
      ),
      _ProjectIdeaWeb(
        image: 'assets/wildflowers.jpeg',
        title: 'Plant wild flowers with seeds.',
      ),
    ];

    // .33 of the width, minus the padding and spacing between items
    final itemWidth = (MediaQuery.of(context).size.width - 100 - (8 * 5)) / 3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavigationRail(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                    child: Text(
                      'Garden project ideas',
                      style: AppTextStyles.heading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              SizedBox(
                                width: itemWidth * 2 + 8,
                                height: 300,
                                child: _GreenThumbCardWeb(),
                              ),
                              ...List.generate(4, (index) {
                                return SizedBox(
                                  width: itemWidth,

                                  child: listItems[index],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GreenThumbCardWeb extends StatelessWidget {
  const _GreenThumbCardWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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

class _ProjectIdeaWeb extends StatelessWidget {
  const _ProjectIdeaWeb({super.key, required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: (screenWidth / 3) - (8 * 5),
      child: Container(
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
                height: 300,
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
      ),
    );
  }
}
