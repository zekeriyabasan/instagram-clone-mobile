import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_model.dart';

class PostService {
  Future<List<Post>> getAllPosts() async {
    final response = await DioClient.dio.get(ApiConstants.posts);

    final responseData = response.data as List<dynamic>;
    return responseData
        .map((postJson) => Post.fromJson(postJson as Map<String, dynamic>))
        .toList();
  }

  Future<Post> createPost({
    required String title,
    required String content,
    required String imageUrl,
    required String imageUrlType,
  }) async {
    final response = await DioClient.dio.post(
      ApiConstants.posts,
      data: {
        'title': title,
        'content': content,
        'image_url': imageUrl,
        'image_url_type': imageUrlType,
      },
    );

    return Post.fromJson(response.data as Map<String, dynamic>);
  }

  Future<String> uploadImage(File imageFile) async {
    final fileName = path.basename(imageFile.path);
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    final response = await DioClient.dio.post(
      ApiConstants.uploadPostImage,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return response.data['image_url'] as String;
  }

  Future<void> deletePost(int postId) async {
    await DioClient.dio.delete('${ApiConstants.posts}$postId');
  }
}
