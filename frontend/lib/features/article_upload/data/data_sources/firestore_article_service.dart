import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/upload_article_model.dart';

class FirestoreArticleService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreArticleService(this._firestore, this._storage);

  Future<String> saveArticle(UploadArticleModel article) async {
    final docRef =
        await _firestore.collection('articles').add(article.toJson());
    return docRef.id;
  }

  Future<String> uploadImage(String articleId, String filePath) async {
    final file = File(filePath);
    final ref = _storage.ref().child('media/articles/$articleId/thumbnail');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> updateThumbnailUrl(String articleId, String thumbnailUrl) async {
    await _firestore.collection('articles').doc(articleId).update({
      'thumbnailURL': thumbnailUrl,
    });
  }

  Future<List<UploadArticleModel>> getArticles() async {
    final snapshot = await _firestore
        .collection('articles')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return UploadArticleModel.fromFirestore(doc.id, doc.data());
    }).toList();
  }

  Future<void> deleteArticle(String articleId) async {
    // Delete thumbnail from storage
    try {
      final ref = _storage.ref().child('media/articles/$articleId/thumbnail');
      await ref.delete();
    } catch (_) {
      // Image might not exist, continue
    }
    // Delete document from Firestore
    await _firestore.collection('articles').doc(articleId).delete();
  }

  Future<void> updateArticle(
      String articleId, UploadArticleModel article) async {
    await _firestore.collection('articles').doc(articleId).update(
          article.toJsonForUpdate(),
        );
  }
}
