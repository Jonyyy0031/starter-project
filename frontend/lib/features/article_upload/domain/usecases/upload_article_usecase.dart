import '../../../../core/usecase/usecase.dart';
import '../entities/upload_article.dart';
import '../repository/upload_article_repository.dart';

class UploadArticleUseCase implements UseCase<String, UploadArticle> {
  final UploadArticleRepository repository;

  UploadArticleUseCase(this.repository);

  @override
  Future<String> call({UploadArticle? params}) {
    return repository.uploadArticle(params!);
  }
}