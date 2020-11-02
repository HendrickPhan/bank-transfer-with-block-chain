<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Str;
use App\Http\Requests\Api\Admin\User\CreateRequest;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    //
    public function list(Request $request) 
    {
        $limit = $request->get('limit', 10);
        $phoneNumber = $request->get('phone_number');
        $name = $request->get('name');
        $query = User::orderBy('id', 'desc');
        if($phoneNumber) {
            $query->where('phone_number', 'like', "%$phoneNumber%");
        }
        if($name) {
            $query->where('name', 'like', "%$name%");
        }

        $users = $query->paginate($limit);

        return $this->responseSuccess($users);
    }

    public function create(CreateRequest $request) 
    {
        $data = $request->validated();
        $password = Str::random(6);
        $data['password'] = Hash::make($password);
        $data['role'] = User::ROLE_USER;
        User::Create($data);

        return $this->responseSuccess($password);
    }

    public function detail(Request $request) 
    {
        $user = User::find($request->id);
        if(!$user) {
            return $this->responseError('Không tìm thấy người dùng');
        }

        return $this->responseSuccess($user);
    }
}
