import 'package:eshopee/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:eshopee/views/screens/nav_screens/widgets/category_item.dart';
import 'package:eshopee/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:eshopee/views/screens/nav_screens/widgets/recommended_product_widget.dart';
import 'package:eshopee/views/screens/nav_screens/widgets/reuseable_text_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: true,
      child: Scaffold(
          body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            HeaderWidget(),
            BannerWidget(),
            CategoryItem(),
            ReuseableTextWidget(
              title: 'Recommended For You',
              subtitle: 'View All',
            ),
            RecommenedProductWidget(),
            ReuseableTextWidget(
              title: 'Recommended For You',
              subtitle: 'View All',
            )
          ],
        ),
      )),
    );
  }
}
