import 'package:drink_reminder/common/colors.dart';
import 'package:flutter/material.dart';

class Cup {
  final String name;
  final Color color;
  final IconData image;
  final int capacity;

  const Cup(
      {required this.name,
      required this.color,
      required this.image,
      required this.capacity});
}

const List<Cup> cups = [
  Cup(
      name: "Water",
      color: MyColor.primaryColor,
      image: Icons.water,
      capacity: 250),
  Cup(
      name: "Bottle",
      color: MyColor.primaryColor,
      image: Icons.battery_full,
      capacity: 500),
  Cup(
      name: "Cup",
      color: MyColor.primaryColor,
      image: Icons.coffee,
      capacity: 180),
  Cup(
      name: "Glass",
      color: MyColor.primaryColor,
      image: Icons.coffee,
      capacity: 250),
];
