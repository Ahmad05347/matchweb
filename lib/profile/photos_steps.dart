import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';

class PhotosStep extends StatefulWidget {
  const PhotosStep({super.key});

  @override
  State<PhotosStep> createState() => _PhotosStepState();
}

class _PhotosStepState extends State<PhotosStep> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _uploadedImageUrls = [];
  final List<File> _localImages = [];
  bool _uploading = false;

  Future<void> _pickImage() async {
    if (_uploadedImageUrls.length >= 5) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked != null) {
      final file = File(picked.path);
      setState(() => _localImages.add(file));
      await _uploadToFirebase(file);
    }
  }

  Future<void> _uploadToFirebase(File image) async {
    setState(() => _uploading = true);
    try {
      final fileName = const Uuid().v4();
      final ref = FirebaseStorage.instance.ref().child(
        'profile_photos/$fileName.jpg',
      );
      await ref.putFile(image);
      final url = await ref.getDownloadURL();

      setState(() {
        _uploadedImageUrls.add(url);
      });

      // Store in Firestore (optional - replace 'userId' with actual user ID)
      await FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
          .collection('photos')
          .add({'url': url});
    } catch (e) {
      debugPrint('Upload error: $e');
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _removeImage(int index) async {
    final imageUrl = _uploadedImageUrls[index];

    try {
      // Delete from Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();

      // Optionally delete from Firestore
      final photosCollection = FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
          .collection('photos');
      final snapshot = await photosCollection
          .where('url', isEqualTo: imageUrl)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _uploadedImageUrls.removeAt(index);
        _localImages.removeAt(index);
      });
    } catch (e) {
      debugPrint('Deletion error: $e');
    }
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

              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: List.generate(5, (index) {
                  final isFilled = index < _uploadedImageUrls.length;

                  return GestureDetector(
                    onTap: !isFilled && !_uploading ? _pickImage : null,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isFilled
                            ? Colors.transparent
                            : Colors.grey.shade200,
                        image: isFilled
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  _uploadedImageUrls[index],
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                        boxShadow: isFilled
                            ? [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: const Offset(2, 4),
                                ),
                              ]
                            : [],
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

              if (_uploadedImageUrls.length < 5 && !_uploading)
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
