import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/entities/hydration.dart';
import 'package:flutter/widgets.dart';

class DrinkModel extends ChangeNotifier {
  int _drinkTarget = 1290;
  int get drinkTarget => _drinkTarget;
  set drinkTarget(int target) {
    _drinkTarget = target;
    notifyListeners();
  }

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
  void toggleIsCompleted() {
    _isCompleted = !_isCompleted;
    _currentDrink = 0;
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
  void updateDrink(int value) {
    if (_currentDrink + value < _drinkTarget) {
      try {
        DatabaseHelper.instance
            .insertHydration(Hydration(
          id: 1,
          value: value,
          createdAt: DateTime.now(),
        ))
            .then((value) {
          refresh();
        });
      } catch (e) {
        print(e.toString());
      }
    } else {
      reset();
      toggleIsCompleted();
    }
  }

  void refresh() async {
    final hydrations = await DatabaseHelper.instance.currentHydrations();
    int _newValue = 0;
    for (var element in hydrations) {
      _newValue += element.value;
    }
    _currentDrink = _newValue;
    notifyListeners();
  }

  void reset() {
    DatabaseHelper.instance.reset().then((value) => _currentDrink = 0);
    notifyListeners();
  }

  void undo() async {
    if (_currentDrink - _selectedCup.capacity >= 0) {
      try {
        await DatabaseHelper.instance
            .deleteLastDrink()
            .then((value) => refresh());
      } catch (e) {
        print(e.toString());
      }
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
