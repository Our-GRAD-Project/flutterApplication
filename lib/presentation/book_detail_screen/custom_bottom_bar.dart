import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../AudioPlayer/AudioPlayer.dart';
import '../shared/buttons.dart';
import '../summary_screen/summary_screen.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onRead;
  final VoidCallback onListen;

  const CustomBottomBar({required this.onRead, required this.onListen, super.key});

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
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const BookSummaryWidget();
                }));
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Button(
              text: "🎧 Listen",
              onPressed:() {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AudioPlayerSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
