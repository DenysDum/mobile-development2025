import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttProvider with ChangeNotifier {
  final String _server = '9b21838509c24387967bc56a51c802bc.s1.eu.hivemq.cloud';

  final int _port = 8883;

  final String _username = 'PizzaApp';
  final String _password = 'PizzaApp1803';

  final String _clientId = 'flutter_pizza_app_${DateTime.now().millisecondsSinceEpoch}';

  MqttServerClient? _client;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String _orderStatus = 'confirmed';
  String get orderStatus => _orderStatus;

  Future<void> connect() async {
    _client = MqttServerClient.withPort(_server, _clientId, _port);

    _client!.secure = true;
    _client!.securityContext = SecurityContext.defaultContext;

    _client!.onBadCertificate = (dynamic certificate) => true;

    _client!.logging(on: false);
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = _onDisconnected;
    _client!.onConnected = _onConnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    _client!.connectionMessage = connMessage;

    try {
      print('MQTT: Підключення до HiveMQ Cloud...');
      await _client!.connect(_username, _password);
    } catch (e) {
      print('MQTT: Помилка підключення - $e');
      _disconnect();
    }

    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      _isConnected = true;
      notifyListeners();
    } else {
      _disconnect();
    }
  }

  void subscribeToOrder(String orderId) {
    if (!_isConnected || _client == null) return;

    final topic = 'pizza/orders/$orderId/status';
    print('MQTT: Підписка на $topic');

    _client!.subscribe(topic, MqttQos.atMostOnce);

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('MQTT: Отримано -> $payload');
      _updateStatus(payload);
    });
  }

  void _updateStatus(String newStatus) {
    _orderStatus = newStatus;
    notifyListeners();
  }

  void _onConnected() {
    print('MQTT: Connected to Cloud');
    _isConnected = true;
    notifyListeners();
  }

  void _onDisconnected() {
    print('MQTT: Disconnected');
    _isConnected = false;
    notifyListeners();
  }

  void _disconnect() {
    _client?.disconnect();
    _isConnected = false;
    notifyListeners();
  }
}