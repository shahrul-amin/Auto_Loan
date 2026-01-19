import 'dart:io';
import 'dart:developer' as developer;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class DocumentUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _logTag = 'DocumentUploadService';

  /// Upload a document file to Firebase Storage
  /// Returns the download URL on success, null on failure
  Future<String?> uploadDocument({
    required File file,
    required String icNumber,
    required String applicationId,
  }) async {
    try {
      final String filename = path.basename(file.path);
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String storagePath =
          'loan_documents/$icNumber/$applicationId/${timestamp}_$filename';

      // Create reference
      final Reference ref = _storage.ref().child(storagePath);

      // Upload file
      final UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          customMetadata: {
            'icNumber': icNumber,
            'applicationId': applicationId,
            'originalFilename': filename,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for completion
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to upload document',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Upload multiple documents
  Future<List<String>> uploadMultipleDocuments({
    required List<File> files,
    required String icNumber,
    required String applicationId,
    Function(int current, int total)? onProgress,
  }) async {
    final List<String> downloadUrls = [];

    for (int i = 0; i < files.length; i++) {
      final url = await uploadDocument(
        file: files[i],
        icNumber: icNumber,
        applicationId: applicationId,
      );

      if (url != null) {
        downloadUrls.add(url);
      }

      if (onProgress != null) {
        onProgress(i + 1, files.length);
      }
    }

    return downloadUrls;
  }

  /// Get download URL for an existing document
  Future<String?> getDocumentUrl({
    required String icNumber,
    required String applicationId,
    required String filename,
  }) async {
    try {
      final String storagePath =
          'loan_documents/$icNumber/$applicationId/$filename';
      final Reference ref = _storage.ref().child(storagePath);

      return await ref.getDownloadURL();
    } catch (e, stackTrace) {
      developer.log(
        'Failed to get document URL',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Delete a document
  Future<bool> deleteDocument({
    required String icNumber,
    required String applicationId,
    required String filename,
  }) async {
    try {
      final String storagePath =
          'loan_documents/$icNumber/$applicationId/$filename';
      final Reference ref = _storage.ref().child(storagePath);

      await ref.delete();
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to delete document',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// List all documents for an application
  Future<List<Map<String, dynamic>>> listApplicationDocuments({
    required String icNumber,
    required String applicationId,
  }) async {
    try {
      final String folderPath = 'loan_documents/$icNumber/$applicationId/';
      final Reference ref = _storage.ref().child(folderPath);

      final ListResult result = await ref.listAll();

      final List<Map<String, dynamic>> documents = [];

      for (final Reference item in result.items) {
        final String url = await item.getDownloadURL();
        final FullMetadata metadata = await item.getMetadata();

        documents.add({
          'name': item.name,
          'url': url,
          'size': metadata.size,
          'contentType': metadata.contentType,
          'uploadedAt': metadata.timeCreated?.toIso8601String(),
        });
      }

      return documents;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to list documents',
        name: _logTag,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}
