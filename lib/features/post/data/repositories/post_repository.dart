import 'dart:io';

import '../models/post_model.dart';
import '../services/post_service.dart';

class PostRepository {
  final PostService _service;

  PostRepository(this._service);

  Future<List<Post>> getAllPosts() {
    return _service.getAllPosts();
  }

  Future<Post> createPost({
    required String title,
    required String content,
    required String imageUrl,
    required String imageUrlType,
  }) {
    return _service.createPost(
      title: title,
      content: content,
      imageUrl: imageUrl,
      imageUrlType: imageUrlType,
    );
  }

  Future<String> uploadImage(File imageFile) {
    return _service.uploadImage(imageFile);
  }

  Future<void> deletePost(int postId) {
    return _service.deletePost(postId);
  }
}
