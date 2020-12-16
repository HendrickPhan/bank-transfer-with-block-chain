<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Str;
use App\Http\Requests\Api\Admin\User\CreateRequest;
use App\Http\Requests\Api\Admin\User\UpdateRequest;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    //
    public function list(Request $request) 
    {
        $limit = $request->get('limit', 10);
        $keyword = $request->get('keyword');
        $query = User::orderBy('id', 'desc');

        if($keyword) {
            $query->where(function($q) use ($keyword) {
                $q->where('phone_number', 'like', "%$keyword%");
                $q->orWhere('name', 'like', "%$keyword%");
            });
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

    public function update(UpdateRequest $request)
    {
        $user = User::find($request->id);
        $data = $request->validated();
        $password = $request->input('password');
        if ($password) {
            $data['password'] = Hash::make($password);
        }
        $user->update($data);
        return $this->responseSuccess($user);
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
