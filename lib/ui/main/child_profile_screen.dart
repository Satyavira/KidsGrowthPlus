import 'package:flutter/material.dart';

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
                // AppBar Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "KidsGrowth+",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "Profil anak",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
        
                SizedBox(
                  height: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryCard(
                        "Info Stunting",
                        "Fitur ini memberikan informasi seputar stunting baik itu video, blog atau artikel",
                        Colors.teal,
                        Icons.info,
                      ),
                      _buildCategoryCard(
                        "Peta Stunting",
                        "Fitur ini memberikan informasi berupa peta penyebab stunting di Indonesia dan daerah",
                        Colors.lightBlue,
                        Icons.map,
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 16.0),
        
                // Medical Consultation Section
                const Text(
                  "Konsultasi Medis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
        
                Column(
                  children: [
                    _buildDoctorCard(
                      "Dr. Samuel",
                      "Rumah sakit Permata Bunda",
                      "222.444",
                      "Ahli Gizi",
                      true,
                    ),
                    _buildDoctorCard(
                      "Dr. Putri",
                      "Rumah sakit Permata Bunda",
                      "333.555",
                      "Spesialis anak",
                      false,
                    ),
                    _buildDoctorCard(
                      "Dr. Wilbert",
                      "Rumah sakit Permata Bunda",
                      "444.666",
                      "Ahli Gizi",
                      false,
                    ),
                  ],
                ),
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
      width: 200,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
      String name,
      String hospital,
      String contact,
      String specialization,
      bool isSelected,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          // Doctor Avatar
          CircleAvatar(
            backgroundColor: Colors.lightBlue.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 16.0),

          // Doctor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  hospital,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4.0),
                Text(
                  contact,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4.0),
                Text(
                  specialization,
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
          ),

          // Radio Button
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (value) {
              // Handle radio button selection
            },
          ),
        ],
      ),
    );
  }
}
