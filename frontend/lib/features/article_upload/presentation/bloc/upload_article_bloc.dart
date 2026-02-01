import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/upload_article.dart';
import '../../domain/repository/upload_article_repository.dart';
import 'upload_article_event.dart';
import 'upload_article_state.dart';

class UploadArticleBloc extends Bloc<UploadArticleEvent, UploadArticleState> {
  final UploadArticleRepository _repository;

  UploadArticleBloc(this._repository) : super(UploadArticleInitial()) {
    on<SubmitArticle>(_onSubmitArticle);
    on<UpdateArticle>(_onUpdateArticle);
  }

  Future<void> _onSubmitArticle(
    SubmitArticle event,
    Emitter<UploadArticleState> emit,
  ) async {
    emit(UploadArticleLoading());

    try {
      // 1. Subir el artículo
      final articleId = await _repository.uploadArticle(event.article);

      // 2. Si hay imagen, subirla y actualizar el documento
      if (event.imagePath != null) {
        final imageUrl =
            await _repository.uploadThumbnail(articleId, event.imagePath!);
        await _repository.updateThumbnailUrl(articleId, imageUrl);
      }

      emit(UploadArticleSuccess(articleId));
    } catch (e) {
      emit(UploadArticleError(e.toString()));
    }
  }

  Future<void> _onUpdateArticle(
    UpdateArticle event,
    Emitter<UploadArticleState> emit,
  ) async {
    emit(UploadArticleLoading());

    try {
      // 1. Actualizar el artículo
      await _repository.updateArticle(event.article);

      // 2. Si hay nueva imagen, subirla y actualizar el documento
      if (event.imagePath != null && event.article.id != null) {
        final imageUrl = await _repository.uploadThumbnail(
            event.article.id!, event.imagePath!);
        await _repository.updateThumbnailUrl(event.article.id!, imageUrl);
      }

      emit(UploadArticleSuccess(event.article.id ?? ''));
    } catch (e) {
      emit(UploadArticleError(e.toString()));
    }
  }
}
