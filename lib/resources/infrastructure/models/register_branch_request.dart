import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

/// A request model for registering a new branch, containing all necessary information.
class RegisterBranchRequest {
  const RegisterBranchRequest({
    required this.name,
    required this.address,
    required this.regionOrState,
    required this.city,
    required this.country,
    required this.description,
    this.image,
  });

  final String name;
  final String address;
  final String regionOrState;
  final String city;
  final String country;
  final String description;
  final XFile? image;

  /// Converts this request into a multipart HTTP request for sending to the server.
  Future<http.MultipartRequest> toMultipartRequest(Uri uri, String method) async {
    final request = http.MultipartRequest(method, uri);

    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['regionOrState'] = regionOrState;
    request.fields['city'] = city;
    request.fields['country'] = country;
    request.fields['description'] = description;

    if (image != null) {
      final bytes = await image!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: image!.name,
        ),
      );
    }

    return request;
  }
}