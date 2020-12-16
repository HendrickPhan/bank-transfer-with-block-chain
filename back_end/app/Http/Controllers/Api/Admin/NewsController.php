<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\Admin\News\CreateRequest;
use App\Http\Requests\Api\Admin\News\UpdateRequest;
use App\Models\News;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    //
    public function list(Request $request) {
        $limit = $request->get('limit', 10);
        $keyword = $request->get('key_word');
        $query = News::orderBy('id', 'desc');
        if ($keyword) {
            $query->where('title', 'like', "%$keyword%");
        }
        $news = $query->paginate($limit);
        return $this->responseSuccess($news);
    }

    public function detail(Request $request) {
        $news = News::find($request->id);
        if(!$news) {
            return $this->responseError('Không tìm thấy tin tức');
        }

        return $this->responseSuccess($news);
    }

    public function create(CreateRequest $request) {
        $data = $request->validated();
        $news = News::create($data);

        return $this->responseSuccess($news);
    }

    public function update(UpdateRequest $request) {
        $news = News::find($request->id);
        if (!$news) {
            return $this->responseError('Không tìm thấy tin tức');
        }
        $data = $request->validated();
        $news->update($data);

        return $this->responseSuccess($news);
    }

    public function delete(Request $request) {
        $news = News::find($request->id);
        if (!$news) {
            return $this->responseError('Không tìm thấy tin tức');
        }
        $news->delete();

        return $this->responseSuccess('Xóa thành công');
    }
}
