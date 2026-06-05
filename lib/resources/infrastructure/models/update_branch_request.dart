import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// A request model for updating an existing branch, containing all necessary information.
class UpdateBranchRequest {
  const UpdateBranchRequest({
    required this.name,
    required this.address,
    required this.city,
    required this.regionOrState,
    required this.country,
    required this.description,
    this.image,
  });

  final String name;
  final String address;
  final String city;
  final String regionOrState;
  final String country;
  final String description;
  final XFile? image;

  /// Converts this request into a multipart HTTP request for sending to the server.
  Future<http.MultipartRequest> toMultipartRequest(Uri uri) async {
    final request = http.MultipartRequest('PUT', uri);

    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['city'] = city;
    request.fields['regionOrState'] = regionOrState;
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