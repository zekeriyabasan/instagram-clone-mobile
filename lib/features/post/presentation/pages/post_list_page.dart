import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/post_provider.dart';

class PostListPage extends ConsumerWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postNotifierProvider);

    return postsState.when(
      data: (posts) {
        if (posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: ref.read(postNotifierProvider.notifier).refreshPosts,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Henüz post yok.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ref.read(postNotifierProvider.notifier).refreshPosts,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(post: post);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Postlar yüklenirken hata oluştu: $error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
    );
  }
}

class PostCard extends ConsumerStatefulWidget {
  final dynamic post;

  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen yorum alanını doldurun.')),
      );
      return;
    }

    setState(() => _isCommentLoading = true);

    try {
      await ref
          .read(postNotifierProvider.notifier)
          .addComment(postId: widget.post.id, content: content);
      _commentController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Yorum eklendi.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Yorum gönderilemedi: $error')));
    } finally {
      if (mounted) {
        setState(() => _isCommentLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.post.user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ref
                    .watch(currentUserIdProvider)
                    .when(
                      data: (userId) {
                        if (userId == widget.post.userId) {
                          return IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await ref
                                  .read(postNotifierProvider.notifier)
                                  .deletePost(widget.post.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Post silindi.'),
                                  ),
                                );
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.post.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.post.content),
            if (widget.post.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.post.imageUrlWithBase,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  placeholder:
                      (context, url) => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.error_outline)),
                      ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Paylaşıldı: ${widget.post.timestamp.toLocal()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (widget.post.comments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Yorumlar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.post.comments.map(
                (comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Text(
                          comment.username.isNotEmpty
                              ? comment.username[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(comment.content),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Yorum ekle',
                suffixIcon: IconButton(
                  icon:
                      _isCommentLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.send),
                  onPressed: _isCommentLoading ? null : _submitComment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
