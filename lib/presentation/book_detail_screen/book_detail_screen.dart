import 'package:flutter/material.dart';
import 'custom_app_ba.dart';
import 'custom_bottom_bar.dart';
import 'book_details_body.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            Divider(
              color: const Color(0xffC3B9B9),
             // Optional: reduce spacing
            ),
            Expanded(child: BookDetailsBody()),
            CustomBottomBar(
              onRead: () {
                // Handle Read action
              },
              onListen: () {
                // Handle Listen action
              },
            ),
          ],
        ),
      ),
    );
  }
}

