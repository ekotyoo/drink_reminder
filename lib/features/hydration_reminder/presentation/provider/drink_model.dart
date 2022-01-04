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

  int _currentDrink = 599;
  int get currentDrink => _currentDrink;
  void updateDrink(int value) {
    if (_currentDrink + value < _drinkTarget) {
      _currentDrink += value;
      notifyListeners();
    } else {
      toggleIsCompleted();
    }
  }

  bool _isAddButtonLongPressed = false;
  bool get isAddButtonLongPressed => _isAddButtonLongPressed;
  void toggleIsAddButtonLongPressed() {
    _isAddButtonLongPressed = !_isAddButtonLongPressed;
    notifyListeners();
  }
}
