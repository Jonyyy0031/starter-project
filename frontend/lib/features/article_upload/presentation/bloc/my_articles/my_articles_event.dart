import 'package:equatable/equatable.dart';

abstract class MyArticlesEvent extends Equatable {
  const MyArticlesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyArticles extends MyArticlesEvent {}

class DeleteMyArticle extends MyArticlesEvent {
  final String articleId;
  const DeleteMyArticle(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class RefreshMyArticles extends MyArticlesEvent {}
