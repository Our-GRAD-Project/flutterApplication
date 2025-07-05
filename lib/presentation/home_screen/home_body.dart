import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/models/category_model.dart';
import '../../core/models/summary_model.dart';
import '../../core/services/category_service.dart';
import '../../core/services/summary_service.dart';
import '../../core/services/search_service.dart';

import '../search_screen/search_results_screen.dart';
import '../shared/AnimatedCategoryCard.dart';
import '../shared/book_card.dart';
import 'animation.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final CategoryService _categoryService = CategoryService();
  final SummaryService _summaryService = SummaryService();
  final SearchService _searchService = SearchService();

  final TextEditingController _searchController = TextEditingController();

  List<Category> _categories = [];
  List<Summary> _summaries_for_you = [];
  List<Summary> _summaries_top_rate = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final categories = await _categoryService.getCategories();
      final summaries_for_you = await _summaryService.getSummaries(page: 1);
      final summaries_top_rated = await _summaryService.getSummaries(page: 2);

      setState(() {
        _categories = categories;
        _summaries_for_you = summaries_for_you;
        _summaries_top_rate = summaries_top_rated;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(
          keyword: query.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearchBar(),
        SizedBox(height: 16.h),
        buildFeaturedCard(_summaries_for_you),
        SizedBox(height: 24.h),

        BookListSection(
          title: 'Today for you',
          subtitle: 'Similar summaries to the ones you like',
          summaries: _summaries_for_you,
        ),

        SizedBox(height: 24.h),
        buildFeaturedCard(_summaries_top_rate),
        SizedBox(height: 24.h),

        buildCategorySection(),

        SizedBox(height: 24.h),
        BookListSection(
          title: 'Top Rated',
          subtitle: 'Most loved books by our clients',
          summaries: _summaries_top_rate,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'Type title, author, keyword',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
          prefixIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: Colors.grey.shade600,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget buildCategorySection() {
    final Map<String, String> categoryIcons = {
      'Business': '📈',
      'Productivity': '🧠',
      'Science': '🔬',
      'Health': '💪',
      'Fiction': '📖',
      'Leadership': '👑',
      'Technology': '💻',
      'Emotional Intelligence': '🌟',
      'History': '📚',
      'Biography': '👤',
      'Critical Thinking': '🧠',
      'Psychology': '🧭',
      'Finance and Investment': '📊',
      'Time Management': '🧭',
      'Management': '⚡',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 32.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Text('Pick a category to explore',
            style: TextStyle(
                fontSize: 18.sp, fontFamily: "roboto", color: Colors.black)),
        SizedBox(height: 16.h),
        SizedBox(
          height: 80.h,
          child: _buildCategoryList(categoryIcons),
        ),
      ],
    );
  }

  Widget _buildCategoryList(Map<String, String> categoryIcons) {
    if (_categories.isEmpty) {
      return Center(child: Text('No categories available'));
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      separatorBuilder: (_, __) => SizedBox(width: 16.w),
      itemBuilder: (context, index) {
        final category = _categories[index];
        final icon = categoryIcons[category.name] ?? '📚';

        return AnimatedCategoryCard(
          title: category.name,
          icon: icon,
          delay: Duration(milliseconds: index * 150),
          categoryId: category.id,
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
