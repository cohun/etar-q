import 'package:equatable/equatable.dart';

/// Model class for documents in the jobs collection
class SitesPersonsModel extends Equatable {
  const SitesPersonsModel({
    this.what = 0,
    required this.name,
  });
  final int what;
  final String name;

  factory SitesPersonsModel.fromMap(Map<String, dynamic> map) {
    return SitesPersonsModel(
      what: map['what'],
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'what': what,
        'name': name,
      };

  @override
  List<Object?> get props => [what, name];
}
