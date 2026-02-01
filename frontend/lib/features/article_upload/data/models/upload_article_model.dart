import '../../domain/entities/upload_article.dart';

class UploadArticleModel extends UploadArticle {
  UploadArticleModel({
    super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.author,
    super.thumbnailURL,
    super.createdAt,
    super.updatedAt,
    required super.isPublished,
    required super.tags,
    required super.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'thumbnailURL': thumbnailURL,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isPublished': isPublished,
      'tags': tags,
      'category': category,
    };
  }

  factory UploadArticleModel.fromEntity(UploadArticle entity) {
    return UploadArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      author: entity.author,
      thumbnailURL: entity.thumbnailURL,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPublished: entity.isPublished,
      tags: entity.tags,
      category: entity.category,
    );
  }
}