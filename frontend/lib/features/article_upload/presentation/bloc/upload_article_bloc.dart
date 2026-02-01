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
      // Validar que hay imagen
      if (event.imagePath == null) {
        emit(UploadArticleError('Image is required'));
        return;
      }

      // 1. Primero subir la imagen (con ID temporal)
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final imageUrl =
          await _repository.uploadThumbnail(tempId, event.imagePath!);

      // 2. Crear artículo con la URL de imagen incluida
      final articleWithImage = UploadArticle(
        title: event.article.title,
        description: event.article.description,
        content: event.article.content,
        author: event.article.author,
        thumbnailURL: imageUrl,
        isPublished: event.article.isPublished,
        tags: event.article.tags,
        category: event.article.category,
      );

      final articleId = await _repository.uploadArticle(articleWithImage);

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
