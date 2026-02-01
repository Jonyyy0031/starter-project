import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/upload_article.dart';
import '../../domain/repository/upload_article_repository.dart';
import 'upload_article_event.dart';
import 'upload_article_state.dart';

class UploadArticleBloc extends Bloc<UploadArticleEvent, UploadArticleState> {
  final UploadArticleRepository _repository;

  UploadArticleBloc(this._repository) : super(UploadArticleInitial()) {
    on<SubmitArticle>(_onSubmitArticle);
  }

  Future<void> _onSubmitArticle(
    SubmitArticle event,
    Emitter<UploadArticleState> emit,
  ) async {
    emit(UploadArticleLoading());

    try {
      final articleId = await _repository.uploadArticle(event.article);

      if (event.imagePath != null) {
        final imageUrl = await _repository.uploadThumbnail(articleId, event.imagePath!);
      }

      emit(UploadArticleSuccess(articleId));
    } catch (e) {
      emit(UploadArticleError(e.toString()));
    }
  }
}