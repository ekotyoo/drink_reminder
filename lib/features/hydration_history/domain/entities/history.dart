class History {
  final int id;
  final int value;
  final DateTime createdAt;

  const History(
      {required this.id, required this.value, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'millisSinceEpoch': createdAt.millisecondsSinceEpoch,
    };
  }

  static History fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      value: map['value'],
      createdAt:
          DateTime.fromMillisecondsSinceEpoch((map['millisSinceEpoch'] as int)),
    );
  }

  @override
  String toString() {
    return "History(id: $id, value $value, createdAt: ${createdAt.toString()})";
  }
}
