import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/my_articles/my_articles_bloc.dart';
import 'package:news_app_clean_architecture/features/article_upload/presentation/bloc/my_articles/my_articles_state.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/upload_article.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

// Theme colors
const kPrimaryColor = Color(0xFF6C63FF);
const kBackgroundColor = Color(0xFFF8F9FA);

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPage();
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Daily News',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _onShowSavedArticlesViewTapped(context),
          icon: const Icon(Icons.bookmark_rounded, color: Colors.black54),
          tooltip: 'Saved Articles',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPage() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, remoteState) {
        if (remoteState is RemoteArticlesLoading) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: _buildAppbar(context),
            body: _buildSkeletonLoading(),
          );
        }
        if (remoteState is RemoteArticlesError) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: _buildAppbar(context),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load news',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        if (remoteState is RemoteArticlesDone) {
          return _buildArticlesPage(context, remoteState.articles!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSkeletonBox(width: 120, height: 24),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildSkeletonBox(width: 100, height: 24),
        const SizedBox(height: 16),
        ...List.generate(5, (_) => _buildArticleSkeleton()),
      ],
    );
  }

  Widget _buildSkeletonBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildArticleSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                Container(height: 12, width: 150, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, color: Colors.grey.shade200),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesPage(BuildContext context, List<ArticleEntity> apiArticles) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppbar(context),
      body: BlocBuilder<MyArticlesBloc, MyArticlesState>(
        builder: (context, myArticlesState) {
          List<UploadArticle> myArticles = [];
          if (myArticlesState is MyArticlesLoaded) {
            myArticles = myArticlesState.articles;
          }

          return RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () async {},
            child: ListView(
              children: [
                // My Articles Section
                if (myArticles.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.edit_note_rounded, color: kPrimaryColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'My Articles',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => _onShowMyArticlesTapped(context),
                          style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
                          child: const Row(
                            children: [
                              Text('See all'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: myArticles.length,
                      itemBuilder: (context, index) {
                        return _buildMyArticleCard(context, myArticles[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Latest News Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.newspaper_rounded, color: Colors.orange, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Latest News',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // API Articles
                ...apiArticles.map((article) => ArticleWidget(
                      article: article,
                      onArticlePressed: (a) => _onArticlePressed(context, a),
                    )),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/UploadArticle'),
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Article',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildMyArticleCard(BuildContext context, UploadArticle article) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/MyArticles'),
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: article.thumbnailURL != null && article.thumbnailURL!.isNotEmpty
                    ? Image.network(
                        article.thumbnailURL!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.content,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category.isNotEmpty ? article.category : 'general',
                        style: const TextStyle(
                          fontSize: 10,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 100,
      color: kPrimaryColor.withOpacity(0.1),
      child: const Center(
        child: Icon(Icons.article_rounded, size: 40, color: kPrimaryColor),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }

  void _onShowMyArticlesTapped(BuildContext context) {
    Navigator.pushNamed(context, '/MyArticles');
  }
}
