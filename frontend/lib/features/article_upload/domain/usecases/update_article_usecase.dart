import '../../../../core/usecase/usecase.dart';
import '../entities/upload_article.dart';
import '../repository/upload_article_repository.dart';

class UpdateArticleUseCase implements UseCase<void, UploadArticle> {
  final UploadArticleRepository _repository;

  UpdateArticleUseCase(this._repository);

  @override
  Future<void> call({UploadArticle? params}) async {
    if (params == null) throw ArgumentError('Article is required');
    return await _repository.updateArticle(params);
  }
}
