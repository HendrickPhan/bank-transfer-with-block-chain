<?php

namespace App\Http\Controllers\Api\Admin;

use Illuminate\Http\Request;
use Illuminate\Encryption\Encrypter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\User\BankAccount\CreateSavingRequest;
use Illuminate\Support\Facades\Bus;
use App\Models\BlockchainTransaction;

class BlockchainTransactionController extends Controller
{
    public function list(Request $request) 
    {
        $limit = $request->query('limit', 10);  
        $query = BlockchainTransaction::orderBy('id', 'desc');
        $hash = $request->query('hash');
        if($hash) {
            $query->where('hash', 'like', "%$hash%");
        }
        $transactions = $query->paginate($limit);

        return $this->responseSuccess($transactions);
    }

    public function detail(Request $request)
    {
        $transaction = BlockchainTransaction::with('block:id,hash')
            ->find($request->id);
        return $this->responseSuccess($transaction);
    }
}
