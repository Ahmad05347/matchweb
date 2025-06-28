import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PhotosStep extends StatefulWidget {
  const PhotosStep({super.key});

  @override
  State<PhotosStep> createState() => _PhotosStepState();
}

class _PhotosStepState extends State<PhotosStep> {
  final ImagePicker _picker = ImagePicker();
  final List<dynamic> _selectedImages = []; // Store File or Uint8List
  bool _uploading = false;

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      if (kIsWeb) {
        final Uint8List bytes = await picked.readAsBytes();
        setState(() => _selectedImages.add(bytes));
      } else {
        final File file = File(picked.path);
        setState(() => _selectedImages.add(file));
      }
    }
  }

  Future<void> _uploadImagesToFirebase() async {
    if (_selectedImages.isEmpty) return;

    setState(() => _uploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final List<String> downloadUrls = [];

      for (int i = 0; i < _selectedImages.length; i++) {
        final image = _selectedImages[i];
        final ref = FirebaseStorage.instance.ref(
          'profile_photos/${userId}_${const Uuid().v4()}.jpg',
        );

        UploadTask uploadTask;

        if (kIsWeb && image is Uint8List) {
          uploadTask = ref.putData(
            image,
            SettableMetadata(contentType: 'image/jpeg'),
          );
        } else if (image is File) {
          uploadTask = ref.putFile(image);
        } else {
          continue; // Skip invalid entry
        }

        final snapshot = await uploadTask;
        final url = await snapshot.ref.getDownloadURL();
        downloadUrls.add(url);
      }

      /// Save photo URLs to Firestore (under `photoUrls`)
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'photoUrls': downloadUrls,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photos uploaded successfully!')),
      );
    } catch (e) {
      debugPrint('Image upload error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload photos.')));
    } finally {
      setState(() => _uploading = false);
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: size.width * 0.55,
          height: size.height * 0.65,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFd4c2be), Color(0xFFa28a87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.photo_library_rounded,
                size: 60,
                color: Color(0xFF573746),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload Your Best Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF573746),
                ),
              ),
              const SizedBox(height: 25),

              /// Image Grid Slots
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: List.generate(5, (index) {
                  final isFilled = index < _selectedImages.length;

                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade200,
                      boxShadow: isFilled
                          ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: const Offset(2, 4),
                              ),
                            ]
                          : [],
                      image: isFilled
                          ? DecorationImage(
                              image: _selectedImages[index] is Uint8List
                                  ? MemoryImage(_selectedImages[index])
                                  : FileImage(_selectedImages[index])
                                        as ImageProvider,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            )
                          : null,
                    ),
                    child: isFilled
                        ? Stack(
                            children: [
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black54,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: GestureDetector(
                              onTap: _uploading ? null : _pickImage,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              if (_selectedImages.length < 5 && !_uploading)
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Add Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF573746),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                ),

              const SizedBox(height: 10),

              if (_selectedImages.isNotEmpty && !_uploading)
                ElevatedButton.icon(
                  onPressed: _uploadImagesToFirebase,

                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Upload to Firebase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                ),

              if (_uploading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
