import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class DrinkModel extends ChangeNotifier {
  Future<void> init() async {
    final box = GetStorage();
    final bool? newIsCompleted = box.read("isCompleted");
    final int? newCurrentDrink = box.read("current_drink");
    _isCompleted = newIsCompleted ?? false;
    _currentDrink = newCurrentDrink ?? 0;
  }

  int _drinkTarget = 1290;
  int get drinkTarget => _drinkTarget;
  set drinkTarget(int target) {
    _drinkTarget = target;
    notifyListeners();
  }

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
  void toggleIsCompleted(bool value) {
    _isCompleted = value;
    cacheCompleteStatus(value);
    notifyListeners();
  }

  bool _showSuccess = false;
  bool get showSuccess => _showSuccess;
  void toggleShowSuccess(bool value) {
    _showSuccess = value;
    notifyListeners();
  }

  Cup _selectedCup = cups[0];
  Cup get selectedCup => _selectedCup;
  void setSelectedCup(Cup newCup) {
    _selectedCup = newCup;
    notifyListeners();
  }

  int _currentDrink = 0;
  int get currentDrink => _currentDrink;
  Future<void> updateDrink(int value) async {
    int _newValue = _currentDrink + value;
    cacheCurrentDrink(_newValue).then((_) {
      refresh();
      notifyListeners();
    });
    if (_newValue > _drinkTarget) {
      toggleIsCompleted(true);
      toggleShowSuccess(true);
      DatabaseHelper.instance.insertOrUpdateHistory(
          History(value: _newValue, createdAt: DateTime.now()));
    }
  }

  void refresh() async {
    final box = GetStorage();
    int _newValue = await box.read('current_drink');
    _currentDrink = _newValue;
  }

  Future<void> reset() async {
    await cacheCurrentDrink(0);
    toggleIsCompleted(false);
    toggleShowSuccess(false);
    notifyListeners();
  }

  void undo() async {
    final int _newValue = _currentDrink - _selectedCup.capacity;
    if (_newValue > _drinkTarget) {
      cacheCurrentDrink(_drinkTarget - _selectedCup.capacity).then((_) {
        refresh();
        toggleIsCompleted(false);
        notifyListeners();
      });
    } else if (_newValue < _drinkTarget && _newValue > 0) {
      cacheCurrentDrink(_newValue).then((_) {
        refresh();
        toggleIsCompleted(false);
        notifyListeners();
      });
    } else {
      reset();
    }
  }

  Future<void> cacheCompleteStatus(bool value) async {
    final box = GetStorage();
    try {
      await box.write('isCompleted', value).then((value) => _isCompleted);
    } catch (e) {
      // ! TODO: Implement error handling
    }
  }

  Future<void> cacheCurrentDrink(int newValue) async {
    final box = GetStorage();
    try {
      await box
          .write('current_drink', newValue)
          .then((value) => _currentDrink = newValue);
    } catch (e) {
      // ! TODO: Implement error handling
    }
    notifyListeners();
  }

  bool _isAddButtonExpanded = false;
  bool get isAddButtonExpanded => _isAddButtonExpanded;
  void toggleIsAddButtonExpanded() {
    _isAddButtonExpanded = !_isAddButtonExpanded;
    notifyListeners();
  }
}
