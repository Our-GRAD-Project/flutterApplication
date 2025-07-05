import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/models/summary_model.dart';
import '../AudioPlayer/AudioPlayer.dart';
import '../shared/buttons.dart';
import '../summary_screen/summary_screen.dart';

class CustomBottomBar extends StatelessWidget {
  final Summary summary;

  const CustomBottomBar({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 109.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Button(
              text: "📖 Read",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookSummaryWidget(summary: summary),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Button(
              text: "🎧 Listen",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AudioPlayerSheet(audioUrl: summary.audioPath, image: summary.coverImagePath),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
