import '../entities/upload_article.dart';

abstract class UploadArticleRepository {
  Future<String> uploadArticle(UploadArticle article);
  Future<String> uploadThumbnail(String articleId, String filePath);
}