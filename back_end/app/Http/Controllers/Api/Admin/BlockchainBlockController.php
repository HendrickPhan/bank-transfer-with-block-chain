<?php

namespace App\Http\Controllers\Api\Admin;

use Illuminate\Http\Request;
use Illuminate\Encryption\Encrypter;
use App\Http\Controllers\Controller;
use App\Models\BlockchainBlock;
use App\Jobs\CreateTransactionOnBC;
use App\Http\Requests\Api\User\BankAccount\CreateSavingRequest;
use Illuminate\Support\Facades\Bus;

class BlockchainBlockController extends Controller
{
    public function list(Request $request) 
    {
        $limit = $request->query('limit', 10);
        $query = BlockchainBlock::orderBy('id', 'desc');
        $hash = $request->query('hash');
        if($hash) {
            $query->where('hash', 'like', "%$hash%");
        }
        $blocks = $query->paginate($limit);

        return $this->responseSuccess($blocks);
    }

    public function detail(Request $request)
    {
        $block = BlockchainBlock::with('transactions:id,hash,blockHash')
            ->find($request->id);
        return $this->responseSuccess($block);
    }   
}
