import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import 'student_form_page.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students",style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: const Color.fromARGB(255, 82, 146, 206),),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentFormPage()),
        ).then((_) => context.read<StudentBloc>().add(LoadStudents())),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f", 
            ),
            fit: BoxFit.cover, // makes it fill the screen
          ),
        ),
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentLoaded) {
              if (state.students.isEmpty) {
                return const Center(child: Text("No students yet"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.students.length,
                itemBuilder: (context, i) {
                  final s = state.students[i];
                  return Card(
                    color: Colors.white.withOpacity(0.8), 
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: (s.profileImage != null &&
                                s.profileImage!.isNotEmpty)
                            ? FileImage(File(s.profileImage!))
                            : null,
                        child: (s.profileImage == null ||
                                s.profileImage!.isEmpty)
                            ? const Icon(Icons.person,
                                size: 30, color: Colors.grey)
                            : null,
                      ),
                      title: Text(
                        s.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Age: ${s.age}"),
                          Text("Roll No: ${s.roll}"),
                          Text("Mobile: ${s.mobile}"),
                          Text("Email: ${s.email}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context
                              .read<StudentBloc>()
                              .add(DeleteStudent(s.id!));
                        },
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentFormPage(student: s),
                        ),
                      ).then((_) =>
                          context.read<StudentBloc>().add(LoadStudents())),
                    ),
                  );
                },
              );
            } else if (state is StudentError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
