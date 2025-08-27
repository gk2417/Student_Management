class Student {
  final int? id;
  final String name;
  final int age;
  final String roll;
  final String mobile;
  final String email;
  final String? profileImage; // ✅ new field

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.roll,
    required this.mobile,
    required this.email,
    this.profileImage,
  });

  // Convert Student to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'roll': roll,
      'mobile': mobile,
      'email': email,
      'profileImage': profileImage, // ✅ save in DB
    };
  }

  // Convert Map from SQLite back to Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      roll: map['roll'],
      mobile: map['mobile'],
      email: map['email'],
      profileImage: map['profileImage'], // ✅ load from DB
    );
  }
}
