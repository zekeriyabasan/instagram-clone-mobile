import 'package:instagram_clone_mobile/core/constants/api_constants.dart';

class PostUser {
  final String username;

  PostUser({required this.username});

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(username: json['username'] ?? '');
  }
}

class PostComment {
  final int id;
  final String content;
  final int userId;
  final String username;
  final int postId;
  final DateTime timestamp;

  PostComment({
    required this.id,
    required this.content,
    required this.userId,
    required this.username,
    required this.postId,
    required this.timestamp,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      postId: json['post_id'] ?? 0,
      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class Post {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String imageUrlType;
  final int userId;
  final PostUser user;
  final DateTime timestamp;
  final List<PostComment> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.imageUrlType,
    required this.userId,
    required this.user,
    required this.timestamp,
    required this.comments,
  });

  String get imageUrlWithBase {
    if (imageUrl.isEmpty) {
      return '';
    }

    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }

    return '${ApiConstants.baseUrl}/${imageUrl.replaceFirst(RegExp(r'^/+'), '')}';
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      imageUrlType: json['image_url_type'] ?? '',
      userId: json['user_id'] ?? 0,
      user: PostUser.fromJson(json['user'] ?? {}),
      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map(
                (comment) =>
                    PostComment.fromJson(comment as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
