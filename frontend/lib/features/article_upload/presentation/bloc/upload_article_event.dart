import '../../domain/entities/upload_article.dart';

abstract class UploadArticleEvent {}

class SubmitArticle extends UploadArticleEvent {
  final UploadArticle article;
  final String? imagePath;

  SubmitArticle({required this.article, this.imagePath});
}