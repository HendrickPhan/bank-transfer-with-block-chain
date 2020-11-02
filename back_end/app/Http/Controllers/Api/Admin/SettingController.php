<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\Admin\Setting\AddRequest;
use App\Http\Requests\Api\Admin\Setting\UpdateRequest;
use App\Models\Setting;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    //
    public function list(Request $request) {
        $limit = $request->get('limit', 10);
        $keyword = $request->get('key_word');
        $query = Setting::orderBy('id', 'desc');
        if ($keyword) {
            $query->where('key', 'like', "%$keyword%");
        }
        $settings = $query->paginate($limit);
        return $this->responseSuccess($settings);
    }

    public function update(UpdateRequest $request) {
        $setting = Setting::find($request->id);
        if (!$setting) {
            return $this->responseError('Không tìm thấy setting');
        }
        $data = $request->validated();
        $setting->update($data);

        return $this->responseSuccess($setting);
    }

    public function add(AddRequest $request) {
        $data = $request->validated();
        $setting = Setting::create($data);
        return $this->responseSuccess($setting);
    }
}
