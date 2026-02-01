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
}