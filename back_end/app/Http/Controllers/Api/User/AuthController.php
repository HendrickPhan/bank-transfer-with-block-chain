<?php

namespace App\Http\Controllers\Api\User;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\User\Auth\ActivateRequest;
use App\Http\Requests\Api\User\Auth\LoginRequest;
use App\Http\Requests\Api\User\Auth\UpdatePasswordRequest;
use App\Http\Requests\Api\User\Auth\UpdatePinCodeRequest;
use App\Models\User;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\DB;
use Illuminate\Encryption\Encrypter;


class AuthController extends Controller
{
    //
    public function login(LoginRequest $request)
    {
        $data = $request->validated();
        $user = User::where('phone_number', $data['phone_number'])
            ->first();
        if(!$user) {
            return $this->responseError('Không tìm thấy số điện thoại');
        }

        if(!Hash::check($data['password'], $user->password)) {
            return $this->responseError('Sai mật khẩu');
        }
        
        $token = $user->createToken('login-token');

        return $this->responseSuccess($token->plainTextToken);
    }

    public function profile(Request $request)
    {

        return $this->responseSuccess($request->user());
    }

    public function updatePassword(UpdatePasswordRequest $request)
    {
        $data = $request->validated();
        $user = $request->user();

        if(!Hash::check($data['old_password'], $user->password)) {
            return $this->responseError('Sai mật khẩu');
        }

        $user->password = Hash::make($data['new_password']);
        $user->save();

        return $this->responseSuccess('Cập nhập thành công');
    }

    public function updatePinCode(UpdatePinCodeRequest $request)
    {
        $user = $request->user();
        $data = $request->validated();
        
        if(!Hash::check($data['pin_code'], $user->pin_code)) {
            return $this->responseError('Pin code không đúng');
        }

        $user->pin_code = Hash::make($data['new_pin_code']);
        $user->save();
        // TODO: change encrypt of all bank account related
        return $this->responseSuccess('Cập nhập thành công');
    }

    public function activate(ActivateRequest $request) 
    {
        $user = $request->user();
        if($user->pin_code) {
            return $this->responseError('Đã được kích hoạt, không thể tiếp tục kích hoạt');
        }
        $data = $request->validated();
        
        DB::beginTransaction();
        try {
            $accountData = $this->_createNewAddress();
            $key = str_pad($data['pin_code'], 16, "x", STR_PAD_BOTH);
            $crypt = new Encrypter($key);
            $privateKey = $crypt->encrypt($accountData->privateKey);
            
            $user->pin_code = Hash::make($data['pin_code']);
            $user->address = $accountData->address;
            $user->private_key = $privateKey;
            $user->save();
            DB::commit();
        } catch(\Exception $e) {
            DB::rollback();
            return $this->responseError($e);
        }

        return $this->responseSuccess("Kích hoạt thành công");
    }

    static private function _createNewAddress() {
        $client = new Client();
        $requestContent = [
            'headers' => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/json'
            ]
        ];
        $apiRequest = $client->request(
            'POST', 
            env('NODE_SERVER_URL', 'http://127.0.0.1:3000/') . 'new-address', 
            $requestContent
        );

        $response = json_decode($apiRequest->getBody());
        return $response;
    }

}
