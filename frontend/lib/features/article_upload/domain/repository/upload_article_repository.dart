import '../entities/upload_article.dart';

abstract class UploadArticleRepository {
  Future<String> uploadArticle(UploadArticle article);
  Future<String> uploadThumbnail(String articleId, String filePath);
  Future<void> updateThumbnailUrl(String articleId, String thumbnailUrl);
  Future<List<UploadArticle>> getArticles();
  Future<void> deleteArticle(String articleId);
  Future<void> updateArticle(UploadArticle article);
}
