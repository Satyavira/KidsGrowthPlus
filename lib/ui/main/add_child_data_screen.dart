import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddChildDataScreen extends StatefulWidget {
  const AddChildDataScreen({super.key});

  @override
  State<AddChildDataScreen> createState() => _AddChildDataScreenState();
}

class _AddChildDataScreenState extends State<AddChildDataScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = "Laki-laki";
  String? selectedDate;

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      print('Image path: ${image?.path}');

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
        return;
      }

      // Check if the file exists
      final file = File(image.path);
      if (!await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The selected image file does not exist')),
        );
        return;
      }

      // Set the selected image
      setState(() {
        _selectedImage = file;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
        ),
      );
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert position to address
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
        setState(() {
          addressController.text = address;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get address: $e')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print("Name: ${nameController.text}");
      print("Gender: $gender");
      print("Birth Date: $selectedDate");
      print("Weight: ${weightController.text} Kg");
      print("Height: ${heightController.text} Cm");
      print("Address: ${addressController.text}");
      print("Photo Path: ${_selectedImage?.path ?? 'No photo selected'}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
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
                                onTap: () => _showPhotoOptions(context),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: _selectedImage != null
                                        ? DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: _selectedImage == null
                                      ? const Icon(Icons.image, size: 50, color: Colors.grey)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                "Tambahkan Foto Anak",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16.0),

                        // Name Field
                        const Text("Nama Anak"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Enter your child's name",
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nama Anak tidak boleh kosong";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16.0),

                        // Gender Selection
                        const Text("Jenis Kelamin"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Laki-laki"),
                                value: "Laki-laki",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                                activeColor: const Color(0xFF002247),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Perempuan"),
                                value: "Perempuan",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                                activeColor: const Color(0xFF002247),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            // Tanggal Lahir
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tanggal Lahir"),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      height: 55,
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.calendar_today, color: Color(0xFF002247)),
                                          Text(
                                            selectedDate ?? "xx/xx/xxxx",
                                            style: TextStyle(
                                              color: selectedDate == null ? Colors.grey : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16), // Space between columns

                            // Berat Badan
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Berat Badan"),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF002247),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: TextFormField(
                                              controller: weightController,
                                              decoration: const InputDecoration(
                                                hintText: "0",
                                                hintStyle: TextStyle(color: Colors.white),
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF000000))),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is enabled
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is focused
                                                ),
                                              ),
                                              style: const TextStyle(color: Colors.white),
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "Berat tidak boleh kosong";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text("Kg", style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16), // Space between columns

                            // Tinggi Badan
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tinggi Badan"),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF002247),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: TextFormField(
                                              controller: heightController,
                                              decoration: const InputDecoration(
                                                hintText: "0",
                                                hintStyle: TextStyle(color: Colors.white),
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF000000))),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is enabled
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white), // White underline when the field is focused
                                                ),
                                              ),
                                              style: const TextStyle(color: Colors.white),
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "Tinggi badan tidak boleh kosong";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text("Cm", style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
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
                        TextFormField(
                          controller: addressController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Detecting your address...",
                            border: UnderlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.location_on),
                              onPressed: _getCurrentLocation,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Alamat tidak boleh kosong (Klik Icon untuk alamat)";
                            }
                            return null;
                          },
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
                        onPressed: _submitForm,
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
      ),
    );
  }
}
