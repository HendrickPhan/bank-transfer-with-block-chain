<?php

namespace App\Http\Controllers\Api\User;

use Illuminate\Http\Request;
use Illuminate\Encryption\Encrypter;
use App\Http\Controllers\Controller;
use App\Models\BankAccount;
use App\Http\Requests\Api\User\BankAccount\CreateSavingRequest;

class BankAccountController extends Controller
{
    // list bank account of a user
    public function list(Request $request)
    {
        $limit = $request->get('limit', 10);
        $bankAccounts = BankAccount::where('user_id', $request->user()->id)
            ->orderBy('id', 'desc')
            ->paginate($limit);

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
        $userId =  $request->user()->id;
        //validate transfer_bank_account
        $validatedTransferBankAccount = $this->_validateTransferBankAccount(
            $userId, $data['transfer_bank_account_number'], $data['amount'] 
        );
        if(!$validatedTransferBankAccount['valid']) {
            return $this->responseError($validatedTransferBankAccount['message']);
        }

        $interestRate = InterestRate::where('type', $data['type'])
            ->first();
        if(!$interestRate) {
            return $this->responseError('Không tìm thấy thông tin lãi suât, có thể chưa chạy seed');
        }

        $data['interest_rate'] = $interestRate->rate;
        $data['user_id'] = $userId;
        $data['account_number'] = $this->_generateAccountNumber();

        $savingBankAccount = BankAccount::create($data);

        // TODO: tranfer money from tranfer bank account to saving
        return $this->responseSuccess($savingBankAccount);
    }

    private function _validateTransferBankAccount($userId, $bankAccountNumber, $tranferAmount)
    {
        $bankAccount = BankAccount::where('account_number', $bankAccountNumber)
            ->where('user_id', $userId)
            ->first();
        if(!$bankAccount){
            return $this->validateFail('Không tìm thấy tài khoản');
        }

        if($bankAccount->amount < $tranferAmount) {
            return $this->validateFail('Số dư tài khoản không đủ');
        }

        return $this->validateFail($bankAccount);
    }

    private function _generateAccountNumber() {
        return time() . rand( 10 , 99);
    }
    
    // TODO
    public function finalization()
    {

    }
}
