<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Notification;
class NotificationController extends Controller
{
    //
    public function list(Request $request) {
        $limit = $request->input('limit', 10);
        $notifications = Notification::paginate($limit);
        return $this->responseSuccess($notifications);
    }

    public function detail(Request $request) {
        $notification = Notification::find($request->id);
        return $this->responseSuccess($notification);
    }
}
