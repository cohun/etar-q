import 'package:equatable/equatable.dart';

/// Model class for documents in the jobs collection
class Counter extends Equatable {
  const Counter({
    required this.counter,
    required this.address,
    required this.company,
  });
  final num counter;
  final String address;
  final String company;

  factory Counter.fromMap(Map<String, dynamic> map) {
    return Counter(
      counter: map['counter'] ?? '',
      address: map['address'] ?? '',
      company: map['company'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'counter': counter,
        'address': address,
        'company': company,
      };

  @override
  List<Object?> get props => [counter, address, company];
}
