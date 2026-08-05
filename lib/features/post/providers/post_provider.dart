import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import '../data/models/post_model.dart';
import '../data/repositories/post_repository.dart';
import '../data/services/post_service.dart';

final postServiceProvider = Provider<PostService>((ref) {
  return PostService();
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(ref.read(postServiceProvider));
});

final postNotifierProvider = AsyncNotifierProvider<PostNotifier, List<Post>>(
  PostNotifier.new,
);

final currentUserIdProvider = FutureProvider<int?>((ref) {
  return SecureStorage.getUserId();
});

class PostNotifier extends AsyncNotifier<List<Post>> {
  late final PostRepository _repository;

  @override
  Future<List<Post>> build() async {
    _repository = ref.read(postRepositoryProvider);
    return _repository.getAllPosts();
  }

  Future<void> refreshPosts() async {
    state = await AsyncValue.guard(() async {
      return _repository.getAllPosts();
    });
  }

  Future<void> createPost({
    required String title,
    required String content,
    required String imageUrl,
    required String imageUrlType,
  }) async {
    state = await AsyncValue.guard(() async {
      await _repository.createPost(
        title: title,
        content: content,
        imageUrl: imageUrl,
        imageUrlType: imageUrlType,
      );
      return _repository.getAllPosts();
    });
  }

  Future<void> deletePost(int postId) async {
    state = await AsyncValue.guard(() async {
      await _repository.deletePost(postId);
      return _repository.getAllPosts();
    });
  }

  Future<void> addComment({
    required int postId,
    required String content,
  }) async {
    state = await AsyncValue.guard(() async {
      await _repository.createComment(postId: postId, content: content);
      return _repository.getAllPosts();
    });
  }
}
