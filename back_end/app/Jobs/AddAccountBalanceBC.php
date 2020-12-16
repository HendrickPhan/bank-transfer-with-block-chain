<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Models\Transaction;
use App\Models\BankAccount;
use GuzzleHttp\Client;
use Carbon\Carbon;

class AddAccountBalanceBC implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $transaction;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($transaction)
    {
        //
        $this->transaction = $transaction;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $transaction = $this->transaction;
        $createdAt = new Carbon($this->transaction->created_at);
        $client = new Client();
        $requestContent = [
            'headers' => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/json'
            ],
            'json' => [
                'code' => $transaction->code,
                'account_number' => $transaction->to_account,
                'amount' => $transaction->amount,
                'time_stamp' => $createdAt->timestamp
            ],
            'timeout' => 600
        ];
        $apiRequest = $client->request(
            'POST', 
            env('NODE_SERVER_URL', 'http://127.0.0.1:3000/') . 'bank-account/add-balance', 
            $requestContent
        );

        $response = json_decode($apiRequest->getBody());
        if($apiRequest->getStatusCode() != 200 ) {
            throw new \Exception("Không thể tạo giao dịch trên BC"); 
        }

        $bankAccount = BankAccount::where('account_number',  $transaction->to_account)
            ->first();

        if(!$bankAccount) {
            throw new \Exception("Không thể tìm thấy tài khoản trên hệ thống"); 
        }

        $transaction->status = Transaction::STATUS_CONFIRMED;
        $transaction->save();

        $bankAccount->increment('amount', $transaction->amount);
    }
}
