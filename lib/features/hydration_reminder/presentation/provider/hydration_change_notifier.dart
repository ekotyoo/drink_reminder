import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/delete_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/get_complete_status.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/get_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/insert_or_update_complete_status.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/insert_or_update_hydration.dart';
import 'package:flutter/widgets.dart';

enum HydrationState { initial, loading, loaded, error }

class HydrationChangeNotifier extends ChangeNotifier {
  final InsertOrUpdateHydration insertOrUpdateHydration;
  final GetHydration getHydration;
  final DeleteHydration deleteHydration;
  final InsertOrUpdateCompleteStatus insertOrUpdateCompleteStatus;
  final GetCompleteStatus getCompleteStatus;

  HydrationChangeNotifier(
      this.insertOrUpdateHydration,
      this.getHydration,
      this.deleteHydration,
      this.insertOrUpdateCompleteStatus,
      this.getCompleteStatus);

  Future<void> init() async {
    _getCurrentDrink();
    _getCompleteStatus();
  }

  HydrationState _state = HydrationState.initial;
  HydrationState get state => _state;

  void _setState(HydrationState state) {
    _state = state;
    notifyListeners();
  }

  int _drinkTarget = 1290;
  int get drinkTarget => _drinkTarget;
  set drinkTarget(int target) {
    _drinkTarget = target;
    notifyListeners();
  }

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
  void toggleIsCompleted(bool value) async {
    final result = await insertOrUpdateCompleteStatus.execute(value);
    result.fold((l) {
      _isCompleted = value;
      _setState(HydrationState.error);
    }, (r) {
      _setState(HydrationState.loaded);
    });
    refresh();
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

  void _getCurrentDrink() async {
    _setState(HydrationState.loading);
    final result = await getHydration.execute();
    result.fold((l) {
      _currentDrink = 0;
      _setState(HydrationState.error);
    }, (r) {
      _currentDrink = r;
      _setState(HydrationState.loaded);
    });
  }

  void _getCompleteStatus() async {
    _setState(HydrationState.loading);
    final result = await getCompleteStatus.excecute();
    result.fold((l) {
      _setState(HydrationState.error);
    }, (r) {
      _isCompleted = r;
      _setState(HydrationState.loaded);
    });
  }

  Future<void> updateDrink(int value) async {
    _setState(HydrationState.loading);
    int _newValue = _currentDrink + value;
    final result = await insertOrUpdateHydration.execute(_newValue);
    result.fold((l) {
      _setState(HydrationState.error);
    }, (r) {
      _setState(HydrationState.loaded);
      if (_newValue > _drinkTarget) {
        toggleIsCompleted(true);
        toggleShowSuccess(true);
      }
    });
    DatabaseHelper.instance.insertOrUpdateHistory(
        History(value: _newValue, createdAt: DateTime.now()));
    refresh();
  }

  Future<void> refresh() async {
    _getCurrentDrink();
    _getCompleteStatus();
    notifyListeners();
  }

  Future<void> reset() async {
    _setState(HydrationState.loading);
    final result = await insertOrUpdateHydration.execute(0);
    result.fold((l) {
      _setState(HydrationState.error);
    }, (r) {
      DatabaseHelper.instance
          .insertOrUpdateHistory(History(value: 0, createdAt: DateTime.now()));

      toggleIsCompleted(false);
      toggleShowSuccess(false);
      _setState(HydrationState.loaded);
    });
    refresh();
  }

  Future<void> undo() async {
    final int _newValue = _currentDrink - _selectedCup.capacity;
    _setState(HydrationState.loading);
    if (_newValue > _drinkTarget) {
      final result = await insertOrUpdateHydration
          .execute(_drinkTarget - _selectedCup.capacity);
      result.fold((l) {
        _setState(HydrationState.error);
      }, (r) {
        toggleIsCompleted(false);
        _setState(HydrationState.loaded);
      });
      DatabaseHelper.instance.insertOrUpdateHistory(History(
          value: _drinkTarget - _selectedCup.capacity,
          createdAt: DateTime.now()));
    } else if (_newValue < _drinkTarget && _newValue > 0) {
      final result = await insertOrUpdateHydration.execute(_newValue);
      result.fold((l) {
        _setState(HydrationState.error);
      }, (r) {
        toggleIsCompleted(false);
        _setState(HydrationState.loaded);
      });
      DatabaseHelper.instance.insertOrUpdateHistory(
          History(value: _newValue, createdAt: DateTime.now()));
    } else {
      reset();
    }
    refresh();
  }

  bool _isAddButtonExpanded = false;
  bool get isAddButtonExpanded => _isAddButtonExpanded;
  void toggleIsAddButtonExpanded() {
    _isAddButtonExpanded = !_isAddButtonExpanded;
    notifyListeners();
  }
}
