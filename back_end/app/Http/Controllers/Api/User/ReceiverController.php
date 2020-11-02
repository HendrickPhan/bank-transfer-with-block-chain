<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\User\Receiver\AddRequest;
use App\Http\Requests\Api\User\Receiver\UpdateRequest;
use App\Models\Receiver;
use Illuminate\Http\Request;

class ReceiverController extends Controller
{
    //
    public function list(Request $request){
        $limit = $request->get('limit', 10);
        $query = Receiver::where('user_id', $request->user()->id)
            ->orderBy('name', 'asc');
        $keyword = $request->get('keyword');
        if($keyword) {
            $query->where('name', 'like', "%$keyword%");
        }

        $receivers = $query->paginate($limit);
        return $this->responseSuccess($receivers);
    }

    public function detail(Request $request){
        $receiver = $this->_getUserReceiver($request);
        if(!$receiver) {
            return $this->responseError('Không tìm thấy thông tin người nhận');
        }
        
        return $this->responseSuccess($receiver);
    }

    public function add(AddRequest $request){
        $data = $request->validated();
        $data['user_id'] = $request->user()->id;
        $receiver = Receiver::create($data);

        return $this->responseSuccess($receiver);
    }

    public function update(UpdateRequest $request){
        $receiver = $this->_getUserReceiver($request);

        if(!$receiver) {
            return $this->responseError('Không tìm thấy thông tin người nhận');
        }

        $data = $request->validated();
        $receiver->update($data);

        return $this->responseSuccess($receiver);
    }

    public function delete(Request $request){
        $receiver = $this->_getUserReceiver($request);

        if(!$receiver) {
            return $this->responseError('Không tìm thấy thông tin người nhận');
        }

        $receiver->delete();

        return $this->responseSuccess('Xóa thành công');
    }

    private function _getUserReceiver($request){
        $receiver = Receiver::where('id',  $request->id)
            ->where('user_id', $request->user()->id)
            ->first();

        return $receiver;
    }
}
