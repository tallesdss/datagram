import 'package:flutter/material.dart';
import 'safe_network_image.dart';

class StoryCircle extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool isViewed;
  final VoidCallback? onTap;

  const StoryCircle({
    super.key,
    required this.username,
    required this.imageUrl,
    this.isViewed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isViewed
                  ? null
                  : LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.orange,
                        Colors.red,
                      ],
                    ),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: SafeProfileImage(
                imageUrl: imageUrl,
                radius: 28,
                fallbackText: username.isNotEmpty ? username[0] : 'S',
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              username,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
