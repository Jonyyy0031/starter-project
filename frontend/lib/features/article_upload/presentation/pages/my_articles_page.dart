import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/upload_article.dart';
import '../bloc/my_articles/my_articles_bloc.dart';
import '../bloc/my_articles/my_articles_event.dart';
import '../bloc/my_articles/my_articles_state.dart';

const kPrimaryColor = Color(0xFF6C63FF);
const kBackgroundColor = Color(0xFFF8F9FA);

class MyArticlesPage extends StatefulWidget {
  const MyArticlesPage({super.key});

  @override
  State<MyArticlesPage> createState() => _MyArticlesPageState();
}

class _MyArticlesPageState extends State<MyArticlesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyArticlesBloc>().add(LoadMyArticles());
  }

  Future<void> _navigateToUpload() async {
    final result = await Navigator.pushNamed(context, '/UploadArticle');
    if (mounted) {
      context.read<MyArticlesBloc>().add(RefreshMyArticles());
    }
  }

  Future<void> _navigateToEdit(UploadArticle article) async {
    final result =
        await Navigator.pushNamed(context, '/EditArticle', arguments: article);
    if (mounted) {
      context.read<MyArticlesBloc>().add(RefreshMyArticles());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Articles',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<MyArticlesBloc, MyArticlesState>(
        listener: (context, state) {
          if (state is MyArticleDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Article deleted successfully'),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
          if (state is MyArticlesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MyArticlesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }

          if (state is MyArticlesLoaded) {
            if (state.articles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        size: 60,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No articles yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start writing your first article!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _navigateToUpload,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create Article'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async {
                context.read<MyArticlesBloc>().add(RefreshMyArticles());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return _ArticleCard(
                    article: article,
                    onDelete: () => _showDeleteDialog(context, article),
                    onEdit: () => _navigateToEdit(article),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToUpload,
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Article',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UploadArticle article) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red.shade600),
            ),
            const SizedBox(width: 12),
            const Text('Delete Article'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${article.title}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MyArticlesBloc>().add(DeleteMyArticle(article.id!));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final UploadArticle article;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ArticleCard({
    required this.article,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child:
                article.thumbnailURL != null && article.thumbnailURL!.isNotEmpty
                    ? Image.network(
                        article.thumbnailURL!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    article.category.isNotEmpty ? article.category : 'general',
                    style: const TextStyle(
                      fontSize: 11,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Content preview
                Text(
                  article.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Date and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          article.createdAt != null
                              ? '${article.createdAt!.day}/${article.createdAt!.month}/${article.createdAt!.year}'
                              : 'Just now',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Edit button
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_rounded,
                                color: kPrimaryColor, size: 20),
                            tooltip: 'Edit',
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: onDelete,
                            icon: Icon(Icons.delete_rounded,
                                color: Colors.red.shade400, size: 20),
                            tooltip: 'Delete',
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180,
      color: kPrimaryColor.withOpacity(0.1),
      child: const Center(
        child: Icon(Icons.article_rounded, size: 50, color: kPrimaryColor),
      ),
    );
  }
}
