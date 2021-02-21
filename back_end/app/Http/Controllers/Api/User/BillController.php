<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Bill;
use App\Models\Transaction;

class BillController extends Controller
{
    //
    public function list(Request $request)
    {
        $query = Bill::where('user_id', $request->user()->id);
        $bills = $query->paginate($request->query('limit', 10));
        return $this->responseSuccess($bills);
    }

    public function detail(Request $request)
    {
        $bill = Bill::where('user_id', $request->user()->id)
            ->where('id', $request->id)
            ->first();
        return $bill; 
    }

    public function paid(Request $request)
    {
        $data = $request->all();
        $user = $request->user();

        // validate bank account
        $bankAccount = BankAccount::where('user_id', $user->id)
            ->where('account_number', $data['account_number'])
            ->first();        
        if (!$bankAccount) {
            return $this->responseError('Không tìm thấy tài khoản');
        }

        // bill
        $bill = Bill::where('user_id', $user->id)
            ->where('id', $data['bill_id'])
            ->first();

        if ($bankAccount->amount < $bill->amount) {
            return $this->responseError('Số tiền vượt quá số dư');
        }

        DB::beginTransaction();
        try {
            // create transaction
            $transaction = Transaction::create([
                'code' => $this->_generateTransactionCode(),
                'type' => Transaction::TYPE_PAID_BILL,
                'amount' => $bill->amount,
                'from_account' => $bankAccount->account_number,
                'to_account' => env('MONEY_BASE_BANK_ACCOUNT'),
                'fee' => 0
            ]);
            // decrease bank account balance
            $bankAccount->decrement('amount', $transaction->amount);
            // dispatch job create transaction on bc
            CreateTransactionOnBC::dispatch($transaction, $request->input('pin_code'), $user->private_key);
            
            $bill->transaction_code = $transaction->code;
            $bill->save();
            
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
