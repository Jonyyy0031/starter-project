import 'package:cloud_firestore/cloud_firestore.dart';
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
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null,
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

  factory UploadArticleModel.fromFirestore(
      String id, Map<String, dynamic> data) {
    return UploadArticleModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      author: data['author'] ?? '',
      thumbnailURL: data['thumbnailURL'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isPublished: data['isPublished'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'thumbnailURL': thumbnailURL ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
      'isPublished': isPublished,
      'tags': tags,
      'category': category,
    };
  }
}
