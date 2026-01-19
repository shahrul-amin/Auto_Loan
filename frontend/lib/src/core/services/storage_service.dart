import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _ensureAuthenticated() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  Future<String?> uploadProfilePicture({
    required String icNumber,
    required File imageFile,
  }) async {
    try {
      await _ensureAuthenticated();

      final String fileName =
          'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'users/$icNumber/profile/$fileName';

      final Reference ref = _storage.ref().child(path);

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'icNumber': icNumber,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      return null;
    }
  }

  Future<String?> uploadLoanDocument({
    required String icNumber,
    required String applicationId,
    required File documentFile,
    required String documentType,
  }) async {
    try {
      await _ensureAuthenticated();

      final String extension = documentFile.path.split('.').last;
      final String sanitizedDocType = documentType
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
          .replaceAll(RegExp(r'_+'), '_');
      final String fileName =
          '${sanitizedDocType}_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final String path =
          'users/$icNumber/loan_applications/$applicationId/$fileName';

      final Reference ref = _storage.ref().child(path);

      String contentType = 'application/octet-stream';
      if (extension.toLowerCase() == 'pdf') {
        contentType = 'application/pdf';
      } else if (['jpg', 'jpeg', 'png'].contains(extension.toLowerCase())) {
        contentType = 'image/${extension.toLowerCase()}';
      }

      final UploadTask uploadTask = ref.putFile(
        documentFile,
        SettableMetadata(
          contentType: contentType,
          customMetadata: {
            'icNumber': icNumber,
            'applicationId': applicationId,
            'documentType': documentType,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading loan document: $e');
      return null;
    }
  }

  Future<bool> deleteFile(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }

  Future<List<String>> getApplicationDocuments({
    required String icNumber,
    required String applicationId,
  }) async {
    try {
      final String path = 'users/$icNumber/loan_applications/$applicationId';
      final Reference ref = _storage.ref().child(path);

      final ListResult result = await ref.listAll();

      final List<String> urls = [];
      for (final Reference item in result.items) {
        final String url = await item.getDownloadURL();
        urls.add(url);
      }

      return urls;
    } catch (e) {
      debugPrint('Error getting application documents: $e');
      return [];
    }
  }

  Stream<TaskSnapshot> uploadProfilePictureWithProgress({
    required String icNumber,
    required File imageFile,
  }) async* {
    await _ensureAuthenticated();

    final String fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String path = 'users/$icNumber/profile/$fileName';

    final Reference ref = _storage.ref().child(path);

    final UploadTask uploadTask = ref.putFile(
      imageFile,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'icNumber': icNumber,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      ),
    );

    yield* uploadTask.snapshotEvents;
  }

  Stream<TaskSnapshot> uploadDocumentWithProgress({
    required String icNumber,
    required String applicationId,
    required File documentFile,
    required String documentType,
  }) async* {
    await _ensureAuthenticated();

    final String extension = documentFile.path.split('.').last;
    final String sanitizedDocType = documentType
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final String fileName =
        '${sanitizedDocType}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final String path =
        'users/$icNumber/loan_applications/$applicationId/$fileName';

    final Reference ref = _storage.ref().child(path);

    String contentType = 'application/octet-stream';
    if (extension.toLowerCase() == 'pdf') {
      contentType = 'application/pdf';
    } else if (['jpg', 'jpeg', 'png'].contains(extension.toLowerCase())) {
      contentType = 'image/${extension.toLowerCase()}';
    }

    final UploadTask uploadTask = ref.putFile(
      documentFile,
      SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'icNumber': icNumber,
          'applicationId': applicationId,
          'documentType': documentType,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      ),
    );

    yield* uploadTask.snapshotEvents;
  }
}
