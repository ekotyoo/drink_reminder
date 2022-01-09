import 'package:drink_reminder/common/colors.dart';
import 'package:flutter/material.dart';

class Cup {
  final int id;
  final String name;
  final Color color;
  final String imagePath;
  final int capacity;

  const Cup(
      {required this.id,
      required this.name,
      required this.color,
      required this.imagePath,
      required this.capacity});
}

const List<Cup> cups = [
  Cup(
      id: 1,
      name: "Water",
      color: MyColor.primaryColor,
      imagePath: 'assets/icons/cup1.svg',
      capacity: 250),
  Cup(
      id: 2,
      name: "Bottle",
      color: MyColor.primaryColor,
      imagePath: 'assets/icons/cup2.svg',
      capacity: 500),
  Cup(
      id: 3,
      name: "Cup",
      color: MyColor.primaryColor,
      imagePath: 'assets/icons/cup3.svg',
      capacity: 180),
  Cup(
      id: 4,
      name: "Glass",
      color: MyColor.primaryColor,
      imagePath: 'assets/icons/cup4.svg',
      capacity: 250),
];
