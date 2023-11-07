import 'package:equatable/equatable.dart';

/// Model class for documents in the jobs collection
class SitesPersonsModel extends Equatable {
  const SitesPersonsModel({
    required this.what,
    required this.name,
  });
  final int what;
  final String name;

  factory SitesPersonsModel.fromMap(Map<String, dynamic> map) {
    return SitesPersonsModel(
      what: map['what'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'what': what,
        'name': name,
      };

  @override
  List<Object?> get props => [what, name];
}
