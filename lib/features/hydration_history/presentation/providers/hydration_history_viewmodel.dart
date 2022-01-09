import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:flutter/cupertino.dart';

enum HistoryMode { day, week, month, year }
enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class HydrationHistoryViewModel extends ChangeNotifier {
  Future<void> init() async {
    _currentWeekHistory = await getCurrentWeekHistory();
    _average = _calculateAverage();
    _highestValue = _calculateHighestValue();
    notifyListeners();
  }

  HistoryMode _selectedMode = HistoryMode.week;
  HistoryMode get selectedMode => _selectedMode;
  set selectedMode(HistoryMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  Future<List<History>> getAllHistory() async {
    final result = await DatabaseHelper.instance.getAllHistory();
    return result;
  }

  List<History?> _currentWeekHistory = List.filled(7, null);
  List<History?> get currentWeekHistory => _currentWeekHistory;
  Future<List<History?>> getCurrentWeekHistory() async {
    final result = await DatabaseHelper.instance.getCurrentWeekHistory();
    return result;
  }

  double _average = 0;
  double get average => _average;
  // This function is used to get average drink amount of the current week.
  double _calculateAverage() {
    double sum = 0;
    final _newList = _currentWeekHistory.where((element) => element != null);

    for (var element in _newList) {
      sum += element!.value;
    }

    final average = sum / _newList.length / 1000;

    return average;
  }

  int _highestValue = 1;
  int get highestValue => _highestValue;
  // We need the highest value of the histories, to get the proportion/percentage
  // of each history, so each history's height will be relative
  // to the highest history value.
  int _calculateHighestValue() {
    final _newList = _currentWeekHistory.where((element) => element != null);

    final highestHistory = _newList.reduce(
        (value, element) => value!.value > element!.value ? value : element);

    return highestHistory!.value;
  }
}
