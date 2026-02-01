import '../../../../core/usecase/usecase.dart';
import '../entities/upload_article.dart';
import '../repository/upload_article_repository.dart';

class GetArticlesUseCase implements UseCase<List<UploadArticle>, void> {
  final UploadArticleRepository _repository;

  GetArticlesUseCase(this._repository);

  @override
  Future<List<UploadArticle>> call({void params}) async {
    return await _repository.getArticles();
  }
}
