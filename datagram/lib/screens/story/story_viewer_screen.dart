import 'package:flutter/material.dart';

class StoryViewerScreen extends StatelessWidget {
  final String storyId;
  
  const StoryViewerScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Visualizador de Story: $storyId'),
      ),
    );
  }
}
