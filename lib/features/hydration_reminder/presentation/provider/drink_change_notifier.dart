import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/delete_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/get_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/insert_or_update_hydration.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class HydrationChangeNotifier extends ChangeNotifier {
  final InsertOrUpdateHydration insertOrUpdateHydration;
  final GetHydration getHydration;
  final DeleteHydration deleteHydration;

  HydrationChangeNotifier(
      this.insertOrUpdateHydration, this.getHydration, this.deleteHydration);

  Future<void> init() async {
    final box = GetStorage();
    _isCompleted = box.read("isCompleted") ?? false;
    _currentDrink = box.read("current_drink") ?? 0;
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
    });
    if (_newValue > _drinkTarget) {
      toggleIsCompleted(true);
      toggleShowSuccess(true);
    }
    DatabaseHelper.instance.insertOrUpdateHistory(
        History(value: _newValue, createdAt: DateTime.now()));
  }

  Future<void> refresh() async {
    final box = GetStorage();
    int _newValue = await box.read('current_drink');
    _currentDrink = _newValue;
    notifyListeners();
  }

  Future<void> reset() async {
    await cacheCurrentDrink(0);
    DatabaseHelper.instance
        .insertOrUpdateHistory(History(value: 0, createdAt: DateTime.now()));
    toggleIsCompleted(false);
    toggleShowSuccess(false);
  }

  Future<void> undo() async {
    final int _newValue = _currentDrink - _selectedCup.capacity;
    if (_newValue > _drinkTarget) {
      cacheCurrentDrink(_drinkTarget - _selectedCup.capacity).then((_) {
        toggleIsCompleted(false);
        refresh();
      });
      DatabaseHelper.instance.insertOrUpdateHistory(History(
          value: _drinkTarget - _selectedCup.capacity,
          createdAt: DateTime.now()));
    } else if (_newValue < _drinkTarget && _newValue > 0) {
      cacheCurrentDrink(_newValue).then((_) {
        toggleIsCompleted(false);
        refresh();
      });
      DatabaseHelper.instance.insertOrUpdateHistory(
          History(value: _newValue, createdAt: DateTime.now()));
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
  }

  bool _isAddButtonExpanded = false;
  bool get isAddButtonExpanded => _isAddButtonExpanded;
  void toggleIsAddButtonExpanded() {
    _isAddButtonExpanded = !_isAddButtonExpanded;
    notifyListeners();
  }
}
