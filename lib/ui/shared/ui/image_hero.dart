import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class ImageHero extends StatelessWidget {
  static const routename = '/image_hero';
  const ImageHero({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: buildBackIcon(context),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close))
        ],
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            imageUrl,
          ),
        ),
      ),
    );
  }
}
