import 'package:flutter/material.dart';
import '../models/sensor_model.dart';
import '../repositories/sensor_repository.dart';

/// Possible states for any async data load.
enum LoadState { initial, loading, loaded, error }

/// Manages the sensor list and the 5-step Add Sensor wizard form.
///
/// Step index map:
///   0 → Basic Info
///   1 → Location & Source
///   2 → Configuration Settings  ← new
///   3 → AI Monitoring Preferences
///   4 → Review & Confirm
class SensorProvider extends ChangeNotifier {
  final SensorRepository _repository;

  SensorProvider(this._repository);

  // ── Sensor list ───────────────────────────────────────────────────────────

  List<SensorModel> _sensors   = [];
  LoadState _loadState         = LoadState.initial;
  String?   _errorMessage;

  List<SensorModel> get sensors      => _sensors;
  LoadState         get loadState    => _loadState;
  String?           get errorMessage => _errorMessage;
  bool              get isLoading    => _loadState == LoadState.loading;

  /// Up to [count] most recent sensors for the Home screen summary row.
  List<SensorModel> recentSensors({int count = 3}) =>
      _sensors.take(count).toList();

  Future<void> loadSensors() async {
    _loadState    = LoadState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _sensors   = await _repository.getSensors();
      _loadState = LoadState.loaded;
    } catch (_) {
      _loadState    = LoadState.error;
      _errorMessage = 'Failed to load sensors. Please try again.';
    }
    notifyListeners();
  }

  // ── Search / filter ───────────────────────────────────────────────────────

  String _searchQuery = '';

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<SensorModel> get filteredSensors {
    if (_searchQuery.isEmpty) return _sensors;
    return _sensors.where((s) =>
      s.id.toLowerCase().contains(_searchQuery) ||
      s.name.toLowerCase().contains(_searchQuery) ||
      s.location.toLowerCase().contains(_searchQuery),
    ).toList();
  }

  // ── Add Sensor wizard ─────────────────────────────────────────────────────

  /// Total number of wizard steps.
  static const int totalWizardSteps = 5;

  /// Index of the final step.
  static const int lastWizardStep = totalWizardSteps - 1;

  AddSensorForm _form        = AddSensorForm();
  int           _wizardStep  = 0;
  bool          _addingLoading = false;

  AddSensorForm get form          => _form;
  int           get wizardStep    => _wizardStep;
  bool          get addingLoading => _addingLoading;
  bool          get isLastStep    => _wizardStep == lastWizardStep;

  void nextWizardStep() {
    if (_wizardStep < lastWizardStep) {
      _wizardStep++;
      notifyListeners();
    }
  }

  void prevWizardStep() {
    if (_wizardStep > 0) {
      _wizardStep--;
      notifyListeners();
    }
  }

  void resetWizard() {
    _form          = AddSensorForm();
    _wizardStep    = 0;
    _addingLoading = false;
    notifyListeners();
  }

  /// Call from wizard step widgets whenever a form field changes.
  void updateForm() => notifyListeners();

  /// Whether the current step passes its validation gate.
  bool get canAdvance {
    switch (_wizardStep) {
      case 0: return _form.step1Valid;
      case 1: return _form.step2Valid;
      case 2: return _form.step3Valid; // optional — always true
      case 3: return true;             // AI prefs optional
      case 4: return true;             // review — always submittable
      default: return false;
    }
  }

  Future<SensorModel?> submitSensor() async {
    _addingLoading = true;
    notifyListeners();
    try {
      final sensor   = await _repository.addSensor(_form);
      _sensors       = [..._sensors, sensor];
      _loadState     = LoadState.loaded;
      _addingLoading = false;
      notifyListeners();
      return sensor;
    } catch (_) {
      _addingLoading = false;
      _loadState     = LoadState.error;
      _errorMessage  = 'Failed to add sensor. Please try again.';
      notifyListeners();
      return null;
    }  }
}
