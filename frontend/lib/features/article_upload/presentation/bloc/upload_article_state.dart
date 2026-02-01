abstract class UploadArticleState {}

class UploadArticleInitial extends UploadArticleState {}

class UploadArticleLoading extends UploadArticleState {}

class UploadArticleSuccess extends UploadArticleState {
  final String articleId;

  UploadArticleSuccess(this.articleId);
}

class UploadArticleError extends UploadArticleState {
  final String message;

  UploadArticleError(this.message);
}