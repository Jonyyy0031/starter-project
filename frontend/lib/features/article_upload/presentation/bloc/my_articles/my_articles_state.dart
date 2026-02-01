import 'package:equatable/equatable.dart';
import '../../../domain/entities/upload_article.dart';

abstract class MyArticlesState extends Equatable {
  const MyArticlesState();

  @override
  List<Object?> get props => [];
}

class MyArticlesInitial extends MyArticlesState {}

class MyArticlesLoading extends MyArticlesState {}

class MyArticlesLoaded extends MyArticlesState {
  final List<UploadArticle> articles;
  const MyArticlesLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class MyArticlesError extends MyArticlesState {
  final String message;
  const MyArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}

class MyArticleDeleted extends MyArticlesState {}
