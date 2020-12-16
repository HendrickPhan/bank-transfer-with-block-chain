<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    static function responseSuccess($data, $code = 200)
    {
        return response()->json($data, $code);
    }

    static function responseError($message, $code = 400)
    {
        return response()->json([
            "errors" => [
                "message" => [$message]
            ]
        ], $code);
    }

    static function validateFail($message)
    {
        return [
            'valid' => false,
            'message' => $message
        ];
    }

    static function validateSuccess($data)
    {
        return [
            'valid' => true,
            'data'=> $data
        ];
    }
}
