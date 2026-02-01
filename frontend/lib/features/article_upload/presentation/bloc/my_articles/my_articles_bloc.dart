import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_articles_usecase.dart';
import '../../../domain/usecases/delete_article_usecase.dart';
import 'my_articles_event.dart';
import 'my_articles_state.dart';

class MyArticlesBloc extends Bloc<MyArticlesEvent, MyArticlesState> {
  final GetArticlesUseCase _getArticlesUseCase;
  final DeleteArticleUseCase _deleteArticleUseCase;

  MyArticlesBloc(this._getArticlesUseCase, this._deleteArticleUseCase)
      : super(MyArticlesInitial()) {
    on<LoadMyArticles>(_onLoadMyArticles);
    on<DeleteMyArticle>(_onDeleteMyArticle);
    on<RefreshMyArticles>(_onRefreshMyArticles);
  }

  Future<void> _onLoadMyArticles(
    LoadMyArticles event,
    Emitter<MyArticlesState> emit,
  ) async {
    emit(MyArticlesLoading());
    try {
      final articles = await _getArticlesUseCase.call();
      emit(MyArticlesLoaded(articles));
    } catch (e) {
      emit(MyArticlesError(e.toString()));
    }
  }

  Future<void> _onDeleteMyArticle(
    DeleteMyArticle event,
    Emitter<MyArticlesState> emit,
  ) async {
    try {
      await _deleteArticleUseCase.call(params: event.articleId);
      emit(MyArticleDeleted());
      // Reload articles after deletion
      add(LoadMyArticles());
    } catch (e) {
      emit(MyArticlesError(e.toString()));
    }
  }

  Future<void> _onRefreshMyArticles(
    RefreshMyArticles event,
    Emitter<MyArticlesState> emit,
  ) async {
    await _onLoadMyArticles(LoadMyArticles(), emit);
  }
}
