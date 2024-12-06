import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_growth_plus/styles/colors.dart';

class ChildProfileScreen extends StatelessWidget {
  const ChildProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                // AppBar Section
                Center(
                  child: Text(
                    "Profil Anak",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF002247),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SvgPicture.asset(
                        'assets/logo_color.svg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        // Add menu functionality
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Category Section
                const Text(
                  "Kategori",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        "Info Stunting",
                        "Fitur ini memberikan informasi seputar stunting baik itu video, blog atau artikel",
                        Colors.teal,
                        Icons.info,
                      ),
                    ),
                    SizedBox(width: 16.0,),
                    Expanded(
                      child: _buildCategoryCard(
                        "Konsultasi AI",
                        "Fitur ini memberikan akses konsultasi dengan AI yang berkaitan dengan stunting",
                        Colors.teal,
                        Icons.android,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0,),
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        "Konsultasi Medis",
                        "Fitur ini memberikan user akses untuk konsultasi virtual dengan tenaga medis",
                        Colors.teal,
                        Icons.local_hospital,
                      ),
                    ),
                    SizedBox(width: 16.0,),
                    Expanded(
                      child: _buildCategoryCard(
                        "Prediksi Stunting",
                        "Fitur ini memberikan user prediksi dan keterangan tentang kondisi anak",
                        Colors.teal,
                        Icons.analytics,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      String title,
      String description,
      Color color,
      IconData icon,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Icon(icon, color: color, size: 30)),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: darkBlue),
            ),
          ],
        ),
      ),
    );
  }
}
