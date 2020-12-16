<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\News;

class NewsController extends Controller
{
    //
    public function list(Request $request) {
        $limit = $request->input('limit', 10);
        $news = News::paginate($limit);
        return $this->responseSuccess($news);
    }

    public function detail(Request $request) {
        $news = News::find($request->id);
        return $this->responseSuccess($news);
    }

}
