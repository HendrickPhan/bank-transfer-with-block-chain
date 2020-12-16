<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Api\Admin\Transaction\CreateCashInRequest;
use App\Jobs\AddAccountBalanceBC;
use App\Models\BankAccount;
use Illuminate\Support\Facades\DB;
use App\Models\Transaction;

class TransactionController extends Controller
{
    public function list(Request $request) {
        $limit = $request->input('limit', 10);
        $fromAccount = $request->input('from_account');
        $toAccount = $request->input('to_account');
        $type = $request->input('type');
        $status = $request->input('status');
        $accountNumber = $request->input('account_number');
        
        $query = Transaction::orderBy('id', 'desc');
        if($fromAccount) {
            $query->where('from_account', 'like', "%$fromAccount%");
        }
        if($toAccount) {
            $query->where('to_account', 'like', "%$toAccount%");
        }
        if(isset($type)) {
            $query->where('type', $type);
        }
        if(isset($status)) {
            $query->where('status', $status);
        }
        if($accountNumber) {
            $query->where(function($q) use ($accountNumber) {
                $q->where('from_account', $accountNumber);
                $q->orWhere('to_account', $accountNumber);
            });
        }
        
        $transactions = $query->paginate($limit);

        return $this->responseSuccess($transactions);
    }

    public function detail(Request $request) {
        $transaction = Transaction::find($request->id);
        return $this->responseSuccess($transaction);
    }

    public function createCashIn(CreateCashInRequest $request) {
        $data = $request->validated();

        // validate bank account
        $bankAccount = BankAccount::where('account_number', $data['account_number'])
            ->first();        
        if (!$bankAccount) {
            return $this->responseError('Không tìm thấy tài khoản');
        }

        DB::beginTransaction();
        try {
            // create transaction
            $transaction = Transaction::create([
                'code' => $this->_generateTransactionCode(),
                'type' => Transaction::TYPE_CASH_IN,
                'amount' => $data['amount'],
                'from_account' => env('MONEY_BASE_BANK_ACCOUNT'),
                'to_account' => $bankAccount->account_number,
                'fee' => 0
            ]);
            // dispatch job create transaction on bc
            AddAccountBalanceBC::dispatch($transaction);
                
            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            return $this->responseError($e);
        }

        return $this->responseSuccess("Success");
    }

    private function _generateTransactionCode() {
        return 'TX_' . time() . rand( 10 , 99);
    }
}
