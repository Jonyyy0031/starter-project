import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';
import '../../features/article_upload/presentation/pages/upload_article_page.dart';
import '../../features/article_upload/presentation/pages/my_articles_page.dart';
import '../../features/article_upload/presentation/pages/edit_article_page.dart';
import '../../features/article_upload/presentation/bloc/upload_article_bloc.dart';
import '../../features/article_upload/presentation/bloc/my_articles/my_articles_bloc.dart';
import '../../features/article_upload/presentation/bloc/my_articles/my_articles_event.dart';
import '../../features/article_upload/domain/entities/upload_article.dart';
import '../../injection_container.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        return _materialRoute(
            ArticleDetailsView(article: settings.arguments as ArticleEntity));

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());

      case '/UploadArticle':
        return _materialRoute(BlocProvider<UploadArticleBloc>(
          create: (_) => sl<UploadArticleBloc>(),
          child: const UploadArticlePage(),
        ));

      case '/MyArticles':
        return _materialRoute(
          BlocProvider<MyArticlesBloc>(
            create: (_) => sl<MyArticlesBloc>()..add(LoadMyArticles()),
            child: const MyArticlesPage(),
          ),
        );

      case '/EditArticle':
        return _materialRoute(
          BlocProvider<UploadArticleBloc>(
            create: (_) => sl<UploadArticleBloc>(),
            child:
                EditArticlePage(article: settings.arguments as UploadArticle),
          ),
        );

      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
