import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../category_detail_screen/category_detail_screen.dart';

class AnimatedCategoryCard extends StatefulWidget {
  final String icon;
  final String title;
  final String categoryId; // Added categoryId parameter
  final Duration delay;

  const AnimatedCategoryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.categoryId, // Required categoryId
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<AnimatedCategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _colorController;

  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeIn),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: Colors.redAccent.shade200.withOpacity(0.6),
      end: Colors.blue.shade100,
    ).animate(_colorController);

    _color2 = ColorTween(
      begin: Colors.deepPurple.shade300,
      end: Colors.indigoAccent.shade200,
    ).animate(_colorController);

    Future.delayed(widget.delay, () {
      if (mounted) _mainController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _colorController]),
      builder: (_, __) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailScreen(
                      categoryTitle: widget.title,
                      categoryIcon: widget.icon,
                      categoryId: widget.categoryId, // Pass categoryId
                    ),
                  ),
                );
              },
              child: Container(
                width: 250.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: [
                      _color1.value ?? Colors.pink.shade100,
                      _color2.value ?? Colors.deepPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.black12, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.icon, style: TextStyle(fontSize: 26.sp)),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0.5, 1),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}