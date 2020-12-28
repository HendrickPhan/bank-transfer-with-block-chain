import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/device_model.dart';
import 'package:app/Repositories/device_repository.dart';
import 'dart:async';
import 'bloc.dart';

class DeviceBloc implements Bloc {
  DeviceModel _device;
  DeviceRepository _repository;
  StreamController _controller;

  StreamSink<ApiResponse<DeviceModel>> get deviceSink => _controller.sink;
  Stream<ApiResponse<DeviceModel>> get deviceStream => _controller.stream;

  DeviceBloc() {
    _controller = StreamController<ApiResponse<DeviceModel>>();
    _repository = DeviceRepository();
  }

  init({String token}) async {
    deviceSink.add(ApiResponse.loading('Initiating'));
    try {
      _device = await _repository.initDevice(token: token);
      deviceSink.add(ApiResponse.completed(_device));
    } catch (e) {
      deviceSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  updateUser() async {
    deviceSink.add(ApiResponse.loading('Initiating'));
    try {
      _device = await _repository.updateDeviceUser();
      deviceSink.add(ApiResponse.completed(_device));
    } catch (e) {
      deviceSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
