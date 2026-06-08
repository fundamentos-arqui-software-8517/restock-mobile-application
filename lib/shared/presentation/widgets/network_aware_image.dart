import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Displays a cached remote image, falling back safely when offline.
class NetworkAwareImage extends StatelessWidget {
  const NetworkAwareImage({
    required this.imageUrl,
    required this.placeholder,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    super.key,
  });

  static final Map<String, Future<bool>> _hostChecks = {};

  final String? imageUrl;
  final Widget placeholder;
  final BoxFit fit;
  final double? width;
  final double? height;

  static final _cacheManager = DefaultCacheManager();
  static Future<bool> _canResolveHost(String host) {
    return _hostChecks.putIfAbsent(host, () async {
      try {
        final addresses = await InternetAddress.lookup(host);
        return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
      } on SocketException {
        return false;
      }
    });
  }

  Future<File?> _loadImageFile(String url, String host) async {
    final cached = await _cacheManager.getFileFromCache(url);
    if (cached != null && await cached.file.exists()) {
      return cached.file;
    }

    final canResolveHost = await _canResolveHost(host);
    if (!canResolveHost) return null;

    try {
      return await _cacheManager.getSingleFile(url);
    } on Object {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl ?? '');
    final host = uri?.host;

    if (host == null || host.isEmpty) {
      return placeholder;
    }

    return FutureBuilder<File?>(
      future: _loadImageFile(imageUrl!, host),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder;
        }

        final file = snapshot.data;
        if (file == null) {
          return placeholder;
        }

        return Image.file(file, fit: fit, width: width, height: height);
      },
    );
  }
}
