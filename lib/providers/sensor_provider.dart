import 'package:flutter/material.dart';
import '../models/sensor_model.dart';
import '../repositories/sensor_repository.dart';

/// Possible states for any async data operation.
enum LoadState { initial, loading, loaded, error }

/// Manages the sensor list and the Add Sensor wizard form.
///
/// Consumed by:
///   - [SensorsScreen]  — list + empty state
///   - [HomeScreen]     — recent sensors section
///   - [AddSensorSheet] — wizard form steps
class SensorProvider extends ChangeNotifier {
  final SensorRepository _repository;

  SensorProvider(this._repository);

  // ── Sensor list state ─────────────────────────────────────────────────────

  List<SensorModel> _sensors    = [];
  LoadState _loadState          = LoadState.initial;
  String?   _errorMessage;

  List<SensorModel> get sensors     => _sensors;
  LoadState         get loadState   => _loadState;
  String?           get errorMessage => _errorMessage;
  bool              get isLoading   => _loadState == LoadState.loading;

  /// Returns up to [count] most recent sensors for the Home screen summary.
  List<SensorModel> recentSensors({int count = 3}) =>
      _sensors.take(count).toList();

  /// Loads sensors from the repository. Safe to call multiple times.
  Future<void> loadSensors() async {
    _loadState = LoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _sensors   = await _repository.getSensors();
      _loadState = LoadState.loaded;
    } catch (e) {
      _loadState    = LoadState.error;
      _errorMessage = 'Failed to load sensors. Please try again.';
    }

    notifyListeners();
  }

  // ── Search / filter ───────────────────────────────────────────────────────

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  /// Filters the sensor list by ID, name, or location.
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  /// Sensors filtered by the current search query.
  List<SensorModel> get filteredSensors {
    if (_searchQuery.isEmpty) return _sensors;
    return _sensors.where((s) {
      return s.id.toLowerCase().contains(_searchQuery) ||
             s.name.toLowerCase().contains(_searchQuery) ||
             s.location.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // ── Add Sensor wizard ─────────────────────────────────────────────────────

  /// Form object shared across all wizard steps.
  AddSensorForm _form = AddSensorForm();
  AddSensorForm get form => _form;

  /// Current wizard step index (0-based).
  int _wizardStep = 0;
  int get wizardStep => _wizardStep;

  bool _addingLoading = false;
  bool get addingLoading => _addingLoading;

  /// Advance to the next wizard step.
  void nextWizardStep() {
    if (_wizardStep < 3) {
      _wizardStep++;
      notifyListeners();
    }
  }

  /// Go back one wizard step.
  void prevWizardStep() {
    if (_wizardStep > 0) {
      _wizardStep--;
      notifyListeners();
    }
  }

  /// Reset form and wizard step — called when the sheet is closed/reopened.
  void resetWizard() {
    _form        = AddSensorForm();
    _wizardStep  = 0;
    _addingLoading = false;
    notifyListeners();
  }

  /// Notify listeners when form fields change (called from wizard steps).
  void updateForm() => notifyListeners();

  /// Submits the completed form, adds the sensor, refreshes the list.
  /// Returns the newly created [SensorModel] on success.
  Future<SensorModel?> submitSensor() async {
    _addingLoading = true;
    notifyListeners();

    try {
      final sensor = await _repository.addSensor(_form);
      _sensors = [..._sensors, sensor]; // immutable-style update
      _loadState     = LoadState.loaded;
      _addingLoading = false;
      notifyListeners();
      return sensor;
    } catch (e) {
      _addingLoading = false;
      _errorMessage  = 'Failed to add sensor. Please try again.';
      notifyListeners();
      return null;
    }
  }
}