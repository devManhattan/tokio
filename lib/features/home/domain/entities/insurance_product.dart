import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class InsuranceProduct extends Equatable {
  const InsuranceProduct({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;

  @override
  List<Object?> get props => [id, label];
}
