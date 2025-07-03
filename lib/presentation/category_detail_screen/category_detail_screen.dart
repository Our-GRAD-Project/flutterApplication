import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/models/summary_model.dart';
import '../../core/services/summary_service.dart';
import '../shared/VerticalBookCard.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryIcon;
  final String categoryId;

  const CategoryDetailScreen({
    Key? key,
    required this.categoryTitle,
    required this.categoryIcon,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final SummaryService _summaryService = SummaryService();
  List<Summary> _summaries = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSummaries();
  }

  Future<void> _fetchSummaries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final summaries =
      await _summaryService.getSummariesByCategoryId(widget.categoryId);
      setState(() {
        _summaries = summaries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.blue.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 40.h, left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back,
                      size: 35.sp, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${widget.categoryIcon} ${widget.categoryTitle}',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Failed to load summaries.\nTry again later.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.red,
          ),
        ),
      );
    }

    if (_summaries.isEmpty) {
      return Center(
        child: Text(
          'No summaries available in this category.',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: _summaries.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 25.h,
        childAspectRatio: 0.63,
      ),
      itemBuilder: (context, index) {
        final summary = _summaries[index];
        return VerticalBookCard(
          imagePath: summary.coverImagePath, summary: summary,

        );
      },
    );
  }

  void _navigateToSummaryDetail(Summary summary) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${summary.title}'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
