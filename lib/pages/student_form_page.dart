import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../models/student.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;
  const StudentFormPage({super.key, this.student});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final rollCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  File? _profileImage;

  late AnimationController _controller;
  late List<Animation<Offset>> _fieldAnimations;

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      nameCtrl.text = widget.student!.name;
      ageCtrl.text = widget.student!.age.toString();
      rollCtrl.text = widget.student!.roll;
      mobileCtrl.text = widget.student!.mobile;
      emailCtrl.text = widget.student!.email;

      if (widget.student!.profileImage != null &&
          File(widget.student!.profileImage!).existsSync()) {
        _profileImage = File(widget.student!.profileImage!);
      }
    }

    
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

 
    _fieldAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = start + 0.6;
      return Tween<Offset>(
        begin: const Offset(1.5, 0), // slide in from right
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    });

    _controller.forward();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    rollCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final student = Student(
      id: widget.student?.id,
      name: nameCtrl.text.trim(),
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      roll: rollCtrl.text.trim(),
      mobile: mobileCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      profileImage: _profileImage?.path,
    );

    if (widget.student == null) {
      context.read<StudentBloc>().add(AddStudent(student));
    } else {
      context.read<StudentBloc>().add(UpdateStudent(student));
    }

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Student" : "Add Student",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 82, 146, 206),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://img.freepik.com/free-photo/open-book_23-2147690478.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Card(
              color: Colors.white.withOpacity(0.85),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        backgroundColor: Colors.blue.shade100,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Animated Fields
                    SlideTransition(
                      position: _fieldAnimations[0],
                      child: TextFormField(
                        controller: nameCtrl,
                        decoration: _inputDecoration("Name"),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter name" : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SlideTransition(
                      position: _fieldAnimations[1],
                      child: TextFormField(
                        controller: ageCtrl,
                        decoration: _inputDecoration("Age"),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter age" : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SlideTransition(
                      position: _fieldAnimations[2],
                      child: TextFormField(
                        controller: rollCtrl,
                        decoration: _inputDecoration("Roll No"),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter roll no" : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SlideTransition(
                      position: _fieldAnimations[3],
                      child: TextFormField(
                        controller: mobileCtrl,
                        decoration: _inputDecoration("Mobile Number"),
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter mobile number" : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SlideTransition(
                      position: _fieldAnimations[4],
                      child: TextFormField(
                        controller: emailCtrl,
                        decoration: _inputDecoration("Email ID"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter email ID";
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _save,
                        child: Text(
                          isEdit ? "Update" : "Save",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
