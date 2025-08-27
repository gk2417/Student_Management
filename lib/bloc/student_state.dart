import '../models/student.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;
  StudentLoaded(this.students);
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}
