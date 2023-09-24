import 'package:equatable/equatable.dart';

/// Model class for documents in the jobs collection
class Users extends Equatable {
  const Users(
      {required this.uid,
      required this.name,
      required this.company,
      required this.role,
      required this.approvedRole});
  final String uid;
  final String name;
  final String company;
  final String role;
  final String approvedRole;

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] as String,
      name: map['name'] as String,
      company: map['company'] as String,
      role: map['role'] as String,
      approvedRole: map['approvedRole'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'company': company,
        'role': role,
        'approvedRole': approvedRole,
      };

  @override
  List<Object?> get props => [uid, name, company, role, approvedRole];
}
