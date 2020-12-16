<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\Admin\Notification\CreateRequest;
use App\Http\Requests\Api\Admin\Notification\UpdateRequest;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    //
    public function list(Request $request) {
        $limit = $request->get('limit', 10);
        $keyword = $request->get('key_word');
        $query = Notification::orderBy('id', 'desc');
        if ($keyword) {
            $query->where('title', 'like', "%$keyword%");
        }
        $notifications = $query->paginate($limit);
        return $this->responseSuccess($notifications);
    }

    public function detail(Request $request) {
        $notification = Notification::find($request->id);
        if(!$notification) {
            return $this->responseError('Không tìm thấy thông báo');
        }

        return $this->responseSuccess($notification);
    }

    public function create(CreateRequest $request) {
        $data = $request->validated();
        $notification = Notification::create($data);

        return $this->responseSuccess($notification);
    }

    public function update(UpdateRequest $request) {
        $notification = Notification::find($request->id);
        if (!$notification) {
            return $this->responseError('Không tìm thấy thông báo');
        }
        $data = $request->validated();
        $notification->update($data);

        return $this->responseSuccess($notification);
    }

    public function delete(Request $request) {
        $notification = Notification::find($request->id);
        if (!$notification) {
            return $this->responseError('Không tìm thấy thông báo');
        }
        $notification->delete();

        return $this->responseSuccess('Xóa thành công');
    }
}
