import 'package:flutter/cupertino.dart';

enum HistoryMode { day, week, month, year }
enum Days { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

class HydrationHistoryModel extends ChangeNotifier {
  HistoryMode _selectedMode = HistoryMode.day;
  HistoryMode get selectedMode => _selectedMode;
  set selectedMode(HistoryMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }
}
