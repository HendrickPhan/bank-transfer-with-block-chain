<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Bill;
use App\Models\User;

class BillController extends Controller
{
    //
    public function list(Request $request)
    {
        $query = Bill::query();
        $phoneNumber = $request->query('phone_number');
        if($phoneNumber) {
            $query->whereHas('user', function($q) use ($phoneNumber){
                $q->where('phone_number', 'like', "%$phoneNumber");
            });
        }

        $bills = $query->paginate($request->query('limit', 10));
        return $this->responseSuccess($bills);
    }

    public function detail(Request $request)
    {
        $bill = Bill::with('user')
            ->find($request->id);
            
        return $this->responseSuccess($bill);
    }

    public function create(Request $request)
    {
        $phoneNumber = $request->input('phone_number');
        $user = User::where('phone_number', $phoneNumber)
            ->first();
        
        if(!$user) {
            return $this->responseError('');
        }

        $data = $request->all();
        $data['user_id'] = $user->id;
        $bill = Bill::create($data);

        return $this->responseSuccess($bill);
    }

}
