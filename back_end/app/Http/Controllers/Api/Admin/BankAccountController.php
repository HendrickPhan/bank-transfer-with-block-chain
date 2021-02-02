<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Api\Admin\BankAccount\CreateRequest;
use App\Http\Requests\Api\Admin\BankAccount\DetailBCRequest;
use App\Jobs\CreateBankAccountOnBC;
use App\Models\BankAccount;
use App\Models\InterestRate;
use App\Models\User;
use GuzzleHttp\Client;

class BankAccountController extends Controller
{
    // list bank account of a user
    public function list(Request $request)
    {
        $limit = $request->get('limit', 10);
        $bankAccounts = BankAccount::where('user_id', $request->user_id)
            ->orderBy('id', 'desc')
            ->paginate($limit);
        $this->_generateTypeText($bankAccounts);
        return $this->responseSuccess($bankAccounts);
    }

    public function detail(Request $request)
    {
        $bankAccount = BankAccount::where('account_number', $request->account_number)
            ->first();
        return $this->responseSuccess($bankAccount);
    }

    // create bank account for user
    public function create(CreateRequest $request)
    {
        $user = User::where('role', User::ROLE_USER)
            ->where('id', $request->user_id)
            ->first();
        if (!$user) {
            return $this->responseError('Không tìm thấy user');
        }
        if (!$user->address) {
            return $this->responseError('User chưa kích hoạt');
        }

        $data = $request->validated();

        $interestRate = InterestRate::where('type', $data['type'])
            ->first();
        if (!$interestRate) {
            return $this->responseError('Không tìm thấy thông tin lãi suât, có thể chưa chạy seed');
        }

        $data['interest_rate'] = $interestRate->rate;
        $data['user_id'] = $user->id;
        $data['account_number'] = $this->_generateAccountNumber();
        switch ($data['type']) {
            case BankAccount::TYPE_SAVING_1_MONTH:
                $data['date_due'] = now()->addDays(30);
                break;
            case BankAccount::TYPE_SAVING_3_MONTH:
                $data['date_due'] = now()->addDays(90);
                break;
            case BankAccount::TYPE_SAVING_6_MONTH:
                $data['date_due'] = now()->addDays(180);
                break;
            case BankAccount::TYPE_SAVING_12_MONTH:
                $data['date_due'] = now()->addDays(360);
                break;
        }
        $bankAccount = BankAccount::create($data);

        CreateBankAccountOnBC::dispatch(
            $bankAccount->account_number,
            $user->phone_number,
            $user->address
        );

        return $this->responseSuccess($bankAccount);
    }

    private function _generateAccountNumber()
    {
        return time() . rand(10, 99);
    }

    private function _generateTypeText(&$bankAccounts)
    {
        foreach ($bankAccounts as $bankAccount) {
            $bankAccount["type_text"] = $bankAccount->getTypeText($bankAccount->type);
        }
    }

    public function detailOnBC(DetailBCRequest $request)
    {
        //
        $client = new Client();
        $requestContent = [
            'headers' => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/json'
            ],
            'query' => [
                'account_number' => $request->input('account_number'),
            ],
            'timeout' => 600
        ];
        $apiRequest = $client->request(
            'GET',
            env('NODE_SERVER_URL', 'http://127.0.0.1:3000/') . 'bank-account',
            $requestContent
        );

        $response = json_decode($apiRequest->getBody());
        if ($apiRequest->getStatusCode() != 200) {
            return $this->responseError("Không thể lấy thông tin từ BC");
        }

        return $this->responseSuccess($response);
    }
}
