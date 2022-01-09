import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:flutter/material.dart';

class CupModel extends Cup {
  const CupModel(
    int id,
    String name,
    Color color,
    IconData image,
    int capacity,
  ) : super(
          id: id,
          name: name,
          color: color,
          image: image,
          capacity: capacity,
        );
}
