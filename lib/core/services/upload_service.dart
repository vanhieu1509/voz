import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('IMG_UPLOAD_ENDPOINT'),
    headers: {'Authorization': 'Client-ID ${const String.fromEnvironment('IMG_API_KEY')}'},
  )));
});

class UploadService {
  UploadService(this._dio);

  final Dio _dio;

  Future<String> uploadImage(Uint8List bytes) async {
    final response = await _dio.post('', data: FormData.fromMap({'image': base64Encode(bytes)}));
    return response.data['data']['link'] as String;
  }

  String insertIntoBbcode(String url) => '[img]$url[/img]';
}
