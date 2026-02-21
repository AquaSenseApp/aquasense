
/// Risk level of a sensor reading — drives badge colour and AI alerts.
enum RiskLevel {
  low,
  medium,
  high;

  /// Human-readable label shown in the badge.
  String get label {
    switch (this) {
      case RiskLevel.low:    return 'low';
      case RiskLevel.medium: return 'medium';
      case RiskLevel.high:   return 'high';
    }
  }
}

/// The physical quantity a sensor measures.
enum ParameterType {
  pH,
  turbidity,
  dissolvedOxygen,
  temperature,
  conductivity,
  other;

  String get label {
    switch (this) {
      case ParameterType.pH:               return 'pH';
      case ParameterType.turbidity:        return 'Turbidity';
      case ParameterType.dissolvedOxygen:  return 'Dissolved Oxygen';
      case ParameterType.temperature:      return 'Temperature';
      case ParameterType.conductivity:     return 'Conductivity';
      case ParameterType.other:            return 'Other';
    }
  }

  /// Unit abbreviation shown next to the reading value.
  String get unit {
    switch (this) {
      case ParameterType.pH:               return 'pH';
      case ParameterType.turbidity:        return 'NTU';
      case ParameterType.dissolvedOxygen:  return 'mg/L';
      case ParameterType.temperature:      return '°C';
      case ParameterType.conductivity:     return 'µS/cm';
      case ParameterType.other:            return '';
    }
  }
}

/// Trend direction of the latest sensor reading.
enum TrendDirection { up, down, stable }

/// Source type for how the sensor transmits data.
enum DataSourceType {
  iot,
  manual,
  modbus,
  mqtt;

  String get label {
    switch (this) {
      case DataSourceType.iot:    return 'IoT Device';
      case DataSourceType.manual: return 'Manual Entry';
      case DataSourceType.modbus: return 'Modbus';
      case DataSourceType.mqtt:   return 'MQTT';
    }
  }
}

/// Risk sensitivity setting for the AI advisory engine.
enum RiskSensitivityLevel {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case RiskSensitivityLevel.low:    return 'Low';
      case RiskSensitivityLevel.medium: return 'Medium';
      case RiskSensitivityLevel.high:   return 'High';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sensor data models
// ─────────────────────────────────────────────────────────────────────────────

/// Immutable value object representing a single sensor reading.
class SensorReading {
  final double value;
  final ParameterType parameter;
  final TrendDirection trend;
  final DateTime timestamp;

  const SensorReading({
    required this.value,
    required this.parameter,
    required this.trend,
    required this.timestamp,
  });

  /// Formatted reading string, e.g. "5.2 pH" or "2.3 NTU".
  String get displayValue => '$value ${parameter.unit}';
}

/// Full sensor entity stored in the repository.
class SensorModel {
  final String id;            // e.g. "AQ-PH-202"
  final String name;
  final String location;      // e.g. "Amuwo Odofin, Lagos"
  final ParameterType parameter;
  final RiskLevel riskLevel;
  final SensorReading latestReading;
  final String aiInsight;     // Short AI-generated advisory text
  final bool aiAdvisoryEnabled;
  final String? gpsCoordinates;
  final DataSourceType dataSource;
  final RiskSensitivityLevel sensitivityLevel;

  const SensorModel({
    required this.id,
    required this.name,
    required this.location,
    required this.parameter,
    required this.riskLevel,
    required this.latestReading,
    required this.aiInsight,
    this.aiAdvisoryEnabled = true,
    this.gpsCoordinates,
    this.dataSource = DataSourceType.iot,
    this.sensitivityLevel = RiskSensitivityLevel.medium,
  });

  SensorModel copyWith({
    String? id,
    String? name,
    String? location,
    ParameterType? parameter,
    RiskLevel? riskLevel,
    SensorReading? latestReading,
    String? aiInsight,
    bool? aiAdvisoryEnabled,
    String? gpsCoordinates,
    DataSourceType? dataSource,
    RiskSensitivityLevel? sensitivityLevel,
  }) {
    return SensorModel(
      id:                 id               ?? this.id,
      name:               name             ?? this.name,
      location:           location         ?? this.location,
      parameter:          parameter        ?? this.parameter,
      riskLevel:          riskLevel        ?? this.riskLevel,
      latestReading:      latestReading    ?? this.latestReading,
      aiInsight:          aiInsight        ?? this.aiInsight,
      aiAdvisoryEnabled:  aiAdvisoryEnabled ?? this.aiAdvisoryEnabled,
      gpsCoordinates:     gpsCoordinates   ?? this.gpsCoordinates,
      dataSource:         dataSource       ?? this.dataSource,
      sensitivityLevel:   sensitivityLevel ?? this.sensitivityLevel,
    );
  }
}

/// Transient form data collected during the Add Sensor wizard.
/// Mutable — fields are set as the user progresses through each step.
class AddSensorForm {
  // Step 1 — Basic Info
  ParameterType? parameterType;
  String sensorId        = '';
  String sensorName      = '';

  // Step 2 — Location & Source
  String site            = '';
  String specificLocation = '';
  String gpsCoordinates  = '';
  DataSourceType? dataSourceType;

  // Step 3 — AI Preferences
  bool aiAdvisoryEnabled      = false;
  RiskSensitivityLevel? sensitivityLevel;

  AddSensorForm();

  /// True when the minimum required fields for step 1 are filled.
  bool get step1Valid =>
      parameterType != null &&
      sensorId.isNotEmpty &&
      sensorName.isNotEmpty;

  /// True when the minimum required fields for step 2 are filled.
  bool get step2Valid =>
      site.isNotEmpty && specificLocation.isNotEmpty;
}
