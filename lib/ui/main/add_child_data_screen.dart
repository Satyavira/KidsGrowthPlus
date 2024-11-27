import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddChildDataScreen extends StatefulWidget {
  const AddChildDataScreen({super.key});

  @override
  State<AddChildDataScreen> createState() => _AddChildDataScreenState();
}

class _AddChildDataScreenState extends State<AddChildDataScreen> {
  String gender = "Laki-laki";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom + 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SvgPicture.asset(
                          'assets/logo_color.svg',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Add Photo Section
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Add photo upload logic
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(Icons.image, size: 50, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              "Tambahkan Foto Anak",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const Text(
                              "Lihat foto anak",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Name Field
                      const Text("Nama Anak"),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your child's name",
                          border: UnderlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Gender Selection
                      const Text("Jenis Kelamin"),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Radio<String>(
                                activeColor: const Color(0xFF002247),
                                value: "Laki-laki",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0), // Adjust the width here for spacing
                            const Text("Laki-laki"),
                            const SizedBox(width: 16.0), // Adjust the width here for spacing between radio buttons
                            Radio<String>(
                              activeColor: const Color(0xFF002247),
                              value: "Perempuan",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                            // const SizedBox(width: 8.0), // Adjust the width here for spacing
                            const Text("Perempuan"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Additional Fields
                      Row(
                        children: [
                          // Birth Date
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tanggal Lahir"),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Add date picker logic
                                  },
                                  child: const Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),

                          // Weight
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Berat Badan"),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    color: const Color(0xFF002247),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF000000))),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is enabled
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is focused
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        Text("Kg", style: TextStyle(color: Colors.white),),
                                        SizedBox(width: 5,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),

                          // Height
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Tinggi Badan"),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    color: const Color(0xFF002247),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF000000))),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is enabled
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is focused
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        Text("Cm", style: TextStyle(color: Colors.white),),
                                        SizedBox(width: 5,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16.0),

                      // Address Field
                      const Text("Alamat"),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your address",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add data submission logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Tambahkan Data",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
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