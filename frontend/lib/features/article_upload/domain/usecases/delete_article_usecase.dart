import '../../../../core/usecase/usecase.dart';
import '../repository/upload_article_repository.dart';

class DeleteArticleUseCase implements UseCase<void, String> {
  final UploadArticleRepository _repository;

  DeleteArticleUseCase(this._repository);

  @override
  Future<void> call({String? params}) async {
    if (params == null) throw ArgumentError('Article ID is required');
    return await _repository.deleteArticle(params);
  }
}
