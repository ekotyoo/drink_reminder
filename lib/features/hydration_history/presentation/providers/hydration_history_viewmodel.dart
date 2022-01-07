import 'package:drink_reminder/common/db_helper.dart';
import 'package:flutter/cupertino.dart';

enum HistoryMode { day, week, month, year }
enum Days { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

class HydrationHistoryViewModel extends ChangeNotifier {
  HistoryMode _selectedMode = HistoryMode.day;
  HistoryMode get selectedMode => _selectedMode;
  set selectedMode(HistoryMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  void getHistory() async {
    final result = await DatabaseHelper.instance.getTodayHistory();
    print(result);
  }
}
