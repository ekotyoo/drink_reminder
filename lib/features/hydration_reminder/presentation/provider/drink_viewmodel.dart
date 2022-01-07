import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class DrinkModel extends ChangeNotifier {
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
    }
  }

  void refresh() async {
    final box = GetStorage();
    int? _newValue = box.read('current_drink');
    _currentDrink = _newValue ?? 0;
  }

  Future<void> reset() async {
    await cacheCurrentDrink(0);
    toggleIsCompleted(false);
    toggleShowSuccess(false);
    notifyListeners();
  }

  void undo() async {
    final int _newValue = _currentDrink - _selectedCup.capacity;
    if (_newValue > 0) {
      cacheCurrentDrink(_newValue).then((_) {
        refresh();
      });
    } else {
      reset();
    }
    notifyListeners();
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
