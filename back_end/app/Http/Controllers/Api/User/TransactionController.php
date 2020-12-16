<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Api\User\Transaction\CreateTransferRequest;
use App\Http\Requests\Api\User\Transaction\CreateCashOutRequest;
use App\Jobs\CreateTransactionOnBC;
use App\Models\BankAccount;
use App\Models\Setting;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    //
    public function list(Request $request) {
        $user = $request->user();
        $limit = $request->input('limit', 10);
        $bankAccount = BankAccount::where('user_id', $user->id)
            ->where('account_number', $request->account_number)
            ->first();        
        if (!$bankAccount) {
            return $this->responseError('Không tìm thấy tài khoản');
        }
        $transactions = $bankAccount->transactions()
            ->paginate($limit);
            
        return $this->response($transactions);
    }

    public function detail(Request $request) {

    }

    public function createTransfer(CreateTransferRequest $request) {
        $data = $request->validated();
        $user = $request->user();
        // validate bank account
        $bankAccount = BankAccount::where('user_id', $user->id)
            ->where('account_number', $data['account_number'])
            ->first();        
        if (!$bankAccount) {
            return $this->responseError('Không tìm thấy tài khoản');
        }

        $toBankAccount = BankAccount::where('account_number', $data['to_account_number'])
            ->first();
        if (!$toBankAccount) {
            return $this->responseError('Không tìm thấy tài khoản nhận');
        }

        // get fee
        $transferFee = $this->_getTransferFee();

        if ($bankAccount->amount < $data['amount'] + $transferFee) {
            return $this->responseError('Số tiền vượt quá số dư');
        }

        DB::beginTransaction();
        try {
            // create transaction
            $transaction = Transaction::create([
                'code' => $this->_generateTransactionCode(),
                'type' => Transaction::TYPE_TRANSFER,
                'amount' => $data['amount'],
                'from_account' => $bankAccount->account_number,
                'to_account' => $toBankAccount->account_number,
                'fee' => $transferFee
            ]);
            // decrease bank account balance
            $bankAccount->decrement('amount', $transaction->amount + $transferFee);
            // dispatch job create transaction on bc
            CreateTransactionOnBC::dispatch($transaction, $request->input('pin_code'), $user->private_key);

            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            return $this->responseError($e);
        }

        return $this->responseSuccess("Success");
    }

    public function createCashOut(CreateCashOutRequest $request) {
        $data = $request->validated();
        $user = $request->user();

        // validate bank account
        $bankAccount = BankAccount::where('user_id', $user->id)
            ->where('account_number', $data['account_number'])
            ->first();        
        if (!$bankAccount) {
            return $this->responseError('Không tìm thấy tài khoản');
        }

        //get fee
        $cashOutFee = $this->_getCashOutFee();

        if ($bankAccount->amount < $data['amount'] + $cashOutFee) {
            return $this->responseError('Số tiền vượt quá số dư');
        }

        DB::beginTransaction();
        try {
            // create transaction
            $transaction = Transaction::create([
                'code' => $this->_generateTransactionCode(),
                'type' => Transaction::TYPE_CASH_OUT,
                'amount' => $data['amount'],
                'from_account' => $bankAccount->account_number,
                'to_account' => env('MONEY_BASE_BANK_ACCOUNT'),
                'fee' => $cashOutFee
            ]);
            // decrease bank account balance
            $bankAccount->decrement('amount', $transaction->amount + $cashOutFee);
            // dispatch job create transaction on bc
            CreateTransactionOnBC::dispatch($transaction, $request->input('pin_code'), $user->private_key);
                
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

    private function _getCashOutFee() {
        $cashOutFeeSetting = Setting::where('key', 'cash_out_fee')
            ->first();
        if(!$cashOutFeeSetting) {
            throw new \Exception ('Không tìm thấy setting cho phí rút tiền');
        }
        return $cashOutFeeSetting->value;
    }
    
    private function _getTransferFee() {
        $transferFeeSetting = Setting::where('key', 'transfer_fee')
            ->first();
        if(!$transferFeeSetting) {
            throw new \Exception ('Không tìm thấy setting cho phí rút tiền');
        }
        return $transferFeeSetting->value;
    }
}
