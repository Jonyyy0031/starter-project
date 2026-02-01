import '../../domain/entities/upload_article.dart';
import '../../domain/repository/upload_article_repository.dart';
import '../data_sources/firestore_article_service.dart';
import '../models/upload_article_model.dart';

class UploadArticleRepositoryImpl implements UploadArticleRepository {
  final FirestoreArticleService _service;

  UploadArticleRepositoryImpl(this._service);

  @override
  Future<String> uploadArticle(UploadArticle article) {
    final model = UploadArticleModel.fromEntity(article);
    return _service.saveArticle(model);
  }

  @override
  Future<String> uploadThumbnail(String articleId, String filePath) {
    return _service.uploadImage(articleId, filePath);
  }

  @override
  Future<void> updateThumbnailUrl(String articleId, String thumbnailUrl) {
    return _service.updateThumbnailUrl(articleId, thumbnailUrl);
  }

  @override
  Future<List<UploadArticle>> getArticles() {
    return _service.getArticles();
  }

  @override
  Future<void> deleteArticle(String articleId) {
    return _service.deleteArticle(articleId);
  }

  @override
  Future<void> updateArticle(UploadArticle article) {
    if (article.id == null) throw ArgumentError('Article must have an ID');
    final model = UploadArticleModel.fromEntity(article);
    return _service.updateArticle(article.id!, model);
  }
}
