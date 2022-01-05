class Hydration {
  final int id;
  final int value;
  final DateTime createdAt;

  const Hydration(
      {required this.id, required this.value, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'millisSinceEpoch': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return "Hydration(id: $id, value $value, createdAt: ${createdAt.toString()})";
  }
}
