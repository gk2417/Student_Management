import '../models/student.dart';

abstract class StudentEvent {}

class LoadStudents extends StudentEvent {}

class AddStudent extends StudentEvent {
  final Student student;
  AddStudent(this.student);
}

class UpdateStudent extends StudentEvent {
  final Student student;
  UpdateStudent(this.student);
}

class DeleteStudent extends StudentEvent {
  final int id;
  DeleteStudent(this.id);
}
