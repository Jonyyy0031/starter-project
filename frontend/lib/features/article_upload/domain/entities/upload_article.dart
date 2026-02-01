class UploadArticle {
  final String? id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String? thumbnailURL;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isPublished;
  final List<String> tags;
  final String category;

  UploadArticle({
    this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    this.thumbnailURL,
    this.createdAt,
    this.updatedAt,
    required this.isPublished,
    required this.tags,
    required this.category,
  });
}