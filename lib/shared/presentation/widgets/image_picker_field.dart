import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that allows users to pick an image from their gallery and displays it.
/// It also supports displaying an existing image from a URL if provided.
class ImagePickerField extends StatefulWidget {
  const ImagePickerField({required this.onImagePicked, this.imageUrl, super.key});

  final ValueChanged<XFile?> onImagePicked;
  final String? imageUrl;

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  XFile? _picked;

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() {
      _picked = file;
    });

    widget.onImagePicked(file);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_picked != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.file(
          File(_picked!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(
          widget.imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, _, _) {
            return const Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 40,
                color: Color(0xFF9AA5B4),
              ),
            );
          },
        ),
      );
    } else {
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, color: Color(0xFF9AA5B4), size: 28),
          SizedBox(height: 8),
          Text(
            'FACILITY IMAGE —\nUPLOAD COVER PHOTO',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9AA5B4),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _pick,
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCDD2D9), width: 1.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: content,
      ),
    );
  }
}