<?php

namespace App\Http\Controllers\Api\User;

use Illuminate\Http\Request;
use Illuminate\Encryption\Encrypter;
use App\Http\Controllers\Controller;
use App\Models\BankAccount;
use App\Jobs\CreateTransactionOnBC;
use App\Http\Requests\Api\User\BankAccount\CreateSavingRequest;
use Illuminate\Support\Facades\Bus;
class BankAccountController extends Controller
{
    // list bank account of a user
    public function list(Request $request)
    {
        $limit = $request->get('limit', 10);
        $bankAccounts = BankAccount::where('user_id', $request->user()->id)
            ->where('status', BankAccount::STATUS_ACTIVATED)
            ->orderBy('id', 'desc')
            ->paginate($limit);

        return $this->responseSuccess($bankAccounts);
    }

    public function selectList(Request $request)
    {
        $bankAccounts = BankAccount::where('user_id', $request->user()->id)
            ->where('status', BankAccount::STATUS_ACTIVATED)
            ->where('type', BankAccount::TYPE_TRANSFER)
            ->get();
        return $this->responseSuccess($bankAccounts);
    }

    public function detail(Request $request) {
        $bankAccount = BankAccount::where('user_id', $request->user()->id)
            ->where('id', $request->id)
            ->first();

        return $this->responseSuccess($bankAccount);
    }

    public function listSaving(Request $request)
    {
        $limit = $request->get('limit', 10);
        $bankAccounts = BankAccount::where('user_id', $request->user()->id)
            ->where('type', '!=', BankAccount::TYPE_TRANSFER)
            ->orderBy('id', 'desc')
            ->paginate($limit);

        return $this->responseSuccess($bankAccounts);
    }

    public function createSaving(CreateSavingRequest $request)
    {
        $data = $request->validated();
        $user = $request->user();
        //validate transfer_bank_account
        $validatedTransferBankAccount = $this->_validateTransferBankAccount(
            $user->id, $data['transfer_bank_account_number'], $data['amount'] 
        );
        if(!$validatedTransferBankAccount['valid']) {
            return $this->responseError($validatedTransferBankAccount['message']);
        } else {
            $transferBankAccount = $validatedTransferBankAccount['data'];
        }

        $interestRate = InterestRate::where('type', $data['type'])
            ->first();
        if(!$interestRate) {
            return $this->responseError('Không tìm thấy thông tin lãi suât, có thể chưa chạy seed');
        }

        $data['interest_rate'] = $interestRate->rate;
        $data['user_id'] = $user->id;
        $data['account_number'] = $this->_generateAccountNumber();

        $savingBankAccount = BankAccount::create($data);

        // TODO: tranfer money from tranfer bank account to saving
        DB::beginTransaction();
        try {
            // create transaction
            $transaction = Transaction::create([
                'code' => $this->_generateTransactionCode(),
                'type' => Transaction::TYPE_TRANSFER,
                'amount' => $data['amount'],
                'from_account' => $transferBankAccount->account_number,
                'to_account' => $savingBankAccount->account_number,
                'fee' => 0
            ]);
            // decrease bank account balance
            $transferBankAccount->decrement('amount', $transaction->amount);
            $savingBankAccount->increment('amount', $transaction->amount);
            // dispatch job create bank account and transaction on bc
            Bus::chain([
                new CreateBankAccountOnBC(
                    $savingBankAccount->account_number, 
                    $user->phone_number, 
                    $user->address
                ),
                new CreateTransactionOnBC(
                    $transaction, 
                    $request->input('pin_code'), 
                    $user->private_key
                )
            ])->dispatch();

            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            return $this->responseError($e);
        }

        return $this->responseSuccess($savingBankAccount);
    }

    private function _validateTransferBankAccount($userId, $bankAccountNumber, $tranferAmount)
    {
        $bankAccount = BankAccount::where('account_number', $bankAccountNumber)
            ->where('type', BankAccount::TYPE_TRANSFER)
            ->where('user_id', $userId)
            ->first();
        if(!$bankAccount){
            return $this->validateFail('Không tìm thấy tài khoản');
        }

        if($bankAccount->amount < $tranferAmount) {
            return $this->validateFail('Số dư tài khoản không đủ');
        }

        return $this->validateSuccess($bankAccount);
    }

    private function _generateAccountNumber() {
        return time() . rand( 10 , 99);
    }
    
    // TODO
    public function finalization()
    {

    }

    public function getAccountName(Request $request)
    {
        $bankAccount = BankAccount::with('user:id,name')
            ->where('account_number', $request->account_number)
            ->first();
        if(!$bankAccount) {
            return $this->responseError("Bank account info not found");
        }

        return $this->responseSuccess($bankAccount->user->name);
    }
}
