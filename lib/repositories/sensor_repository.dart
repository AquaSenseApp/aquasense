import '../models/sensor_model.dart';

/// Abstract interface for sensor data operations.
/// Screens depend on this interface — swap the implementation
/// (mock ↔ real API) without touching any UI code.
abstract class SensorRepository {
  Future<List<SensorModel>> getSensors();
  Future<SensorModel?> getSensorById(String id);
  Future<SensorModel> addSensor(AddSensorForm form);
  Future<void> deleteSensor(String id);
}

/// In-memory sensor repository that pre-seeds realistic sample data.
/// Replace with an HTTP/Firestore implementation using the same interface.
class MockSensorRepository implements SensorRepository {
  /// Internal mutable list — simulates a local database.
  final List<SensorModel> _sensors = [
    SensorModel(
      id: 'AQ-PH-202',
      name: 'pH Sensor Alpha',
      location: 'Amuwo Odofin, Lagos',
      parameter: ParameterType.pH,
      riskLevel: RiskLevel.high,
      latestReading: SensorReading(
        value: 7.2,
        parameter: ParameterType.pH,
        trend: TrendDirection.up,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      aiInsight: 'The pH level is above the acceptable dischar...',
      aiAdvisoryEnabled: true,
      dataSource: DataSourceType.iot,
      sensitivityLevel: RiskSensitivityLevel.high,
    ),
    SensorModel(
      id: 'AQ-PH-202',
      name: 'pH Sensor Beta',
      location: 'Amuwo Odofin, Lagos',
      parameter: ParameterType.pH,
      riskLevel: RiskLevel.medium,
      latestReading: SensorReading(
        value: 5.2,
        parameter: ParameterType.pH,
        trend: TrendDirection.up,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      aiInsight: 'Acidity exceeds safe discharge limits.',
      aiAdvisoryEnabled: true,
      dataSource: DataSourceType.iot,
      sensitivityLevel: RiskSensitivityLevel.medium,
    ),
    SensorModel(
      id: 'AQ-TUR-145',
      name: 'Turbidity Monitor A',
      location: 'Mowe, Ogun',
      parameter: ParameterType.turbidity,
      riskLevel: RiskLevel.low,
      latestReading: SensorReading(
        value: 2.3,
        parameter: ParameterType.turbidity,
        trend: TrendDirection.down,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      aiInsight: 'pH is below safe range. Acidic levels detected.',
      aiAdvisoryEnabled: true,
      dataSource: DataSourceType.mqtt,
      sensitivityLevel: RiskSensitivityLevel.low,
    ),
    SensorModel(
      id: 'AQ-TUR-145',
      name: 'Turbidity Monitor B',
      location: 'Berger, Lagos',
      parameter: ParameterType.turbidity,
      riskLevel: RiskLevel.low,
      latestReading: SensorReading(
        value: 2.3,
        parameter: ParameterType.turbidity,
        trend: TrendDirection.down,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      aiInsight: 'Acidity exceeds safe discharge limits.',
      aiAdvisoryEnabled: false,
      dataSource: DataSourceType.modbus,
      sensitivityLevel: RiskSensitivityLevel.low,
    ),
  ];

  @override
  Future<List<SensorModel>> getSensors() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_sensors);
  }

  @override
  Future<SensorModel?> getSensorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _sensors.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SensorModel> addSensor(AddSensorForm form) async {
    await Future.delayed(const Duration(seconds: 1));
    final sensor = SensorModel(
      id:             form.sensorId,
      name:           form.sensorName,
      location:       '${form.specificLocation}, ${form.site}',
      parameter:      form.parameterType ?? ParameterType.other,
      riskLevel:      RiskLevel.low,
      latestReading:  SensorReading(
        value:     0.0,
        parameter: form.parameterType ?? ParameterType.other,
        trend:     TrendDirection.stable,
        timestamp: DateTime.now(),
      ),
      aiInsight:         'Awaiting first reading.',
      aiAdvisoryEnabled: form.aiAdvisoryEnabled,
      gpsCoordinates:    form.gpsCoordinates.isNotEmpty ? form.gpsCoordinates : null,
      dataSource:        form.dataSourceType ?? DataSourceType.iot,
      sensitivityLevel:  form.sensitivityLevel ?? RiskSensitivityLevel.medium,
    );
    _sensors.add(sensor);
    return sensor;
  }

  @override
  Future<void> deleteSensor(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sensors.removeWhere((s) => s.id == id);
  }
}