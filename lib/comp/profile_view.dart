import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final String name;
  const ProfileView({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF573746),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: size.width * 0.7,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFd4c2be), Color(0xFFa28a87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://source.unsplash.com/random/600x600?sig=$name',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF573746),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Age: 28"),
              const Text("City: Lahore"),
              const SizedBox(height: 20),
              const Text(
                "Bio: A passionate and creative individual looking for a meaningful connection. Loves books, traveling, and deep conversations.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                label: const Text("Send Match Request"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF573746),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
