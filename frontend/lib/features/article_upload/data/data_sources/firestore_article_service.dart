import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/upload_article_model.dart';

class FirestoreArticleService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreArticleService(this._firestore, this._storage);

  Future<String> saveArticle(UploadArticleModel article) async {
    final docRef = await _firestore.collection('articles').add(article.toJson());
    return docRef.id;
  }

  Future<String> uploadImage(String articleId, String filePath) async {
    final file = File(filePath);
    final ref = _storage.ref().child('media/articles/$articleId/thumbnail');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}