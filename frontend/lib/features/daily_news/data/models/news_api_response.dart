import 'article.dart';

class NewsApiResponse {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  NewsApiResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    return NewsApiResponse(
      status: json['status'] ?? '',
      totalResults: json['totalResults'] ?? 0,
      articles: (json['articles'] as List<dynamic>?)
              ?.map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
