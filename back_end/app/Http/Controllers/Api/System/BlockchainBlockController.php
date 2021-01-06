<?php

namespace App\Http\Controllers\Api\System;

use Illuminate\Http\Request;
use Illuminate\Encryption\Encrypter;
use App\Http\Controllers\Controller;
use App\Models\BlockchainBlock;
use App\Jobs\CreateTransactionOnBC;
use App\Http\Requests\Api\User\BankAccount\CreateSavingRequest;
use Illuminate\Support\Facades\Bus;

class BlockchainBlockController extends Controller
{
    public function getHighestBlock() 
    {
        $highestBlock = BlockchainBlock::orderBy('number', 'desc')
            ->first();
        return $highestBlock;
    }

    public function create(Request $request) {
        $data = $request->all();
        $block = BlockchainBlock::firstOrCreate([
            "number" => $data["number"]
        ],$data);
        return $this->responseSuccess($block);
    }   
}
