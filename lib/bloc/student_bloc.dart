import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/db/db_helper.dart';
import 'student_event.dart';
import 'student_state.dart';


class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final db = DatabaseHelper.instance;

  StudentBloc() : super(StudentInitial()) {
    on<LoadStudents>(_onLoad);
    on<AddStudent>(_onAdd);
    on<UpdateStudent>(_onUpdate);
    on<DeleteStudent>(_onDelete);
  }

  Future<void> _onLoad(LoadStudents event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final data = await db.getAll();
      emit(StudentLoaded(data));
    } catch (e) {
      emit(StudentError("Failed to load students"));
    }
  }

  Future<void> _onAdd(AddStudent event, Emitter<StudentState> emit) async {
    await db.insert(event.student);
    add(LoadStudents());
  }

  Future<void> _onUpdate(UpdateStudent event, Emitter<StudentState> emit) async {
    await db.update(event.student);
    add(LoadStudents());
  }

  Future<void> _onDelete(DeleteStudent event, Emitter<StudentState> emit) async {
    await db.delete(event.id);
    add(LoadStudents());
  }
}



