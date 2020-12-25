import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/device_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/Ultilities/log.dart';

class DeviceRepository {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  Future<DeviceModel> initDevice({String token}) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    final response = await _provider.post(
      url: 'device',
      data: data,
    );
    //save response token to secure storage_loginController
    await _storage.write(key: "device_id", value: response["id"].toString());
    Log.debug("initDevice Token " + response.toString());
    return DeviceModel.fromJson(response);
  }

  Future<DeviceModel> updateDeviceUser() async {
    String deviceId = await _storage.read(key: "device_id");
    final response = await _provider.put(
      url: 'device/' + deviceId,
    );
    Log.debug("updateDeviceUser device " + response.toString());
    return DeviceModel.fromJson(response);
  }
}
