<?php

namespace App\Http\Controllers\Api\System;

use Illuminate\Http\Request;
use Illuminate\Encryption\Encrypter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\User\BankAccount\CreateSavingRequest;
use Illuminate\Support\Facades\Bus;
use App\Models\BlockchainTransaction;

class BlockchainTransactionController extends Controller
{
    public function create(Request $request) 
    {
        $data = $request->all();
        $transaction = BlockchainTransaction::updateOrCreate([
            'hash' => $data['hash']
        ],$data);

        return $this->responseSuccess($transaction);    
    }
}
