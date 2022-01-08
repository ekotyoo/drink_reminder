import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/common/helpers.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
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

  Future<List<History>> getAllHistory() async {
    final result = await DatabaseHelper.instance.getAllHistory();
    print(result);
    return result;
  }

  Future<List<History?>> getCurrentWeekHistory() async {
    final result = await DatabaseHelper.instance.getCurrentWeekHistory();
    print(result);
    return result;
  }
}
