<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Device;

class DeviceController extends Controller
{
    //
    public function create(Request $request)
    {
        $data = $request->all();
        $device = Device::firstOrCreate([
            'token' => $data['token']
        ], [
            'token' => $data['token']
        ]);
        return $this->responseSuccess($device);
    }

    public function update(Request $request)
    {
        $device = Device::find($request->id);
        $device->user_id = $request->user()->id;
        $device->save();
        return $this->responseSuccess($device);
    }
}
