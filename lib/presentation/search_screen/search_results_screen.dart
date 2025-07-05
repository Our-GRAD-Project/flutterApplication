import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/models/summary_model.dart';
import '../../core/services/search_service.dart';
import '../shared/VerticalBookCard.dart';

class SearchResultsScreen extends StatefulWidget {
  final String keyword;

  const SearchResultsScreen({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final SearchService _searchService = SearchService();

  List<Summary> _summaries = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchByKeyword();
  }

  Future<void> _searchByKeyword() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _searchService.searchSummaries(widget.keyword);
      setState(() {
        _summaries = results;
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
        child: Padding(
          padding: EdgeInsets.only(top: 40.h, left: 15.w, right: 15.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, size: 30.sp, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Search: "${widget.keyword}"',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
          'Something went wrong.\nPlease try again later.',
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
          'No results found for "${widget.keyword}".',
          textAlign: TextAlign.center,
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
          imagePath: summary.coverImagePath,
          summary: summary,
        );
      },
    );
  }
}
