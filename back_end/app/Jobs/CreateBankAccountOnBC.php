<?php

namespace App\Jobs;

use App\Models\BankAccount;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use GuzzleHttp\Client;

class CreateBankAccountOnBC implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $accountNumber;
    protected $phoneNumber;
    protected $address;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($accountNumber, $phoneNumber, $address)
    {
        //
        $this->accountNumber = $accountNumber;
        $this->phoneNumber = $phoneNumber;
        $this->address = $address;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        //
        $client = new Client();
        $data = [
            'account_number' => $this->accountNumber,
            'owner_phone_number' => $this->phoneNumber,
            'account_address' => $this->address,
            
        ];
        $requestContent = [
            'headers' => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/json'
            ],
            'json' => $data,
            'timeout' => 600
        ];
        var_dump($data);
        $apiRequest = $client->request(
            'POST', 
            env('NODE_SERVER_URL', 'http://127.0.0.1:3000/') . 'bank-account', 
            $requestContent
        );

        $response = json_decode($apiRequest->getBody());
        if($apiRequest->getStatusCode() != 200 ) {
            throw new \Exception("Không thể tạo bank account trên BC"); 
        }

        $bankAccount = BankAccount::where('account_number', $this->accountNumber)
            ->first();

        if(!$bankAccount) {
            throw new \Exception("Không thể tìm thấy bank account trên BC"); 
        }

        $bankAccount->status = BankAccount::STATUS_ACTIVATED;
        $bankAccount->save();
    }
}
