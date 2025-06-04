import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class WaterTankImages extends StatelessWidget {
  final List<String> imageFiles; // List of image URLs
  final VoidCallback? onDelete;

  const WaterTankImages({
    required this.imageFiles,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFiles.length == 1) {
      // Single image: Display full screen with zoom and delete option
      return Scaffold(
        appBar: AppBar(
          actions: [
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
          ],
        ),
        body: PhotoView(
          imageProvider: NetworkImage(imageFiles[0]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
        ),
      );
    } else {
      // Multiple images: Display in grid, navigate to full screen on tap
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: imageFiles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Open full-screen image viewer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imageFiles: imageFiles,
                        initialIndex: index,
                        onDelete: onDelete,
                      ),
                    ),
                  );
                },
                child: Image.network(
                  imageFiles[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageFiles;
  final int initialIndex;
  final VoidCallback? onDelete;

  const FullScreenImageViewer({
    Key? key,
    required this.imageFiles,
    required this.initialIndex,
    this.onDelete,
  }) : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Set the initially selected image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     if (widget.onDelete != null)
      //       IconButton(
      //         icon: const Icon(Icons.delete),
      //         onPressed: widget.onDelete,
      //       ),
      //   ],
      // ),
      body: PhotoViewGallery.builder(
        itemCount: widget.imageFiles.length,
        pageController: PageController(initialPage: currentIndex),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageFiles[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? null
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
    );
  }
}
