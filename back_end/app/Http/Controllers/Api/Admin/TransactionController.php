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
    //
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
