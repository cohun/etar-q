import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.address,
    required this.name,
  });

  final String address;
  final String name;

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      address: map['address'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'address': address,
        'name': name,
      };

  @override
  List<Object?> get props => [address, name];
}
