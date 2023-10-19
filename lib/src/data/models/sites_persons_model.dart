import 'package:equatable/equatable.dart';

/// Model class for documents in the jobs collection
class SitesPersonsModel extends Equatable {
  const SitesPersonsModel({
    required this.what,
    required this.name,
  });
  final num what;
  final String name;

  factory SitesPersonsModel.fromMap(Map<String, dynamic> map) {
    return SitesPersonsModel(
      what: map['what'] ?? 0,
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
