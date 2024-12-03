import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kids_growth_plus/ui/main/child_profile_screen.dart';

import '../../styles/colors.dart';

class AddChildDataScreen extends StatefulWidget {
  const AddChildDataScreen({super.key});

  @override
  State<AddChildDataScreen> createState() => _AddChildDataScreenState();
}

class _AddChildDataScreenState extends State<AddChildDataScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = "Laki-laki";
  String? selectedDate;
  bool _breastfeeding = false;

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController birthWeightController = TextEditingController();
  final TextEditingController birthLengthController = TextEditingController();
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
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image file is too large. Maximum size is 5MB.')),
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

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must confirm
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${nameController.text}'),
                Text('Gender: $gender'),
                Text('Birth Date: $selectedDate'),
                Text('Weight: ${weightController.text} Kg'),
                Text('Height: ${heightController.text} Cm'),
                Text('Address: ${addressController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _submitForm(); // Submit the form after confirmation
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ChildProfileScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select the child's birthdate.")),
        );
        return;
      }
      print("Name: ${nameController.text}");
      print("Gender: $gender");
      print("Birth Date: $selectedDate");
      print("Weight: ${weightController.text} Kg");
      print("Height: ${heightController.text} Cm");
      print("Address: ${addressController.text}");
      print("Photo Path: ${_selectedImage?.path ?? 'No photo selected'}");
      _showConfirmationDialog();
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                                  activeColor: darkBlue,
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
                                  activeColor: darkBlue,
                                ),
                              ),
                            ],
                          ),
                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Tanggal Lahir
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            const Icon(Icons.calendar_today, color: darkBlue),
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
                                child: _buildNumericField(label: "Berat Badan", controller: weightController, suffix: "Kg"),
                              ),
                              const SizedBox(width: 16), // Space between columns
                  
                              // Tinggi Badan
                              Flexible(
                                child: _buildNumericField(label: "Tinggi Badan", controller: heightController, suffix: "Cm"),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16.0),

                          Row(
                            children: [
                              Expanded(
                                child: _buildNumericField(
                                  label: "Berat Lahir",
                                  controller: birthWeightController,
                                  suffix: "Kg",
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildNumericField(
                                  label: "Panjang Lahir",
                                  controller: birthLengthController,
                                  suffix: "Cm",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16.0),

                          Row(
                            children: [
                              Checkbox(
                                value: _breastfeeding,
                                activeColor: darkBlue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _breastfeeding = value!;
                                  });
                                },
                              ),
                              Text('Menyusui'),
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumericField(
      {required String label,
        required TextEditingController controller,
        required String suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text(label)),
        const SizedBox(height: 8),
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "$label tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(suffix, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
