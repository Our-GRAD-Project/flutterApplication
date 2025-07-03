import 'package:flutter/material.dart';
import 'custom_app_ba.dart';
import 'custom_bottom_bar.dart';
import 'book_details_body.dart';
import 'package:baseera_app/core/models/summary_model.dart';

class BookDetailsScreen extends StatelessWidget {
  final Summary summary;

  const BookDetailsScreen({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            Divider(color: const Color(0xffC3B9B9)),
            Expanded(child: BookDetailsBody(summary: summary)),
            CustomBottomBar(summary: summary),
          ],
        ),
      ),
    );
  }
}
