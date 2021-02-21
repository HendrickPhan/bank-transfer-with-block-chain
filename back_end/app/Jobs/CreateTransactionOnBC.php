<?php

namespace App\Jobs;

use App\Models\Transaction;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use GuzzleHttp\Client;
use Carbon\Carbon;
use Illuminate\Encryption\Encrypter;
use App\Models\Notification;
use App\Http\Services\NotificationService;
use App\Models\BankAccount;
use App\Models\Bill;
use Illuminate\Support\Facades\Log;

class CreateTransactionOnBC implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $transaction;
    protected $privateKey;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($transaction, $pinCode, $encryptedPrivate)
    {
        //
        $this->transaction = $transaction;
        $key = str_pad($pinCode, 16, "x", STR_PAD_BOTH);
        $crypt = new Encrypter($key);
        $this->privateKey = $crypt->decrypt($encryptedPrivate);
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
                'private' => $this->privateKey,
                'code' => $transaction->code,
                'from_account' => $transaction->from_account,
                'to_account' => $transaction->to_account,
                'amount' => $transaction->amount,
                'fee' => $transaction->fee,
                'time_stamp' => $createdAt->timestamp
            ],
            'timeout' => 600
        ];
        $apiRequest = $client->request(
            'POST', 
            env('NODE_SERVER_URL', 'http://127.0.0.1:3000/') . 'transfer', 
            $requestContent
        );

        $response = json_decode($apiRequest->getBody());
        // TODO: save transaction hash for future tracking
        if($apiRequest->getStatusCode() != 200 ) {
            throw new \Exception("Không thể tạo transaction trên BC"); 
        }

        $transaction->status = Transaction::STATUS_CONFIRMED;
        $transaction->save();

        if($transaction->type == Transaction::TYPE_TRANSFER)  {
            // add amount to to bank account
            $toAccount = $transaction->toAccount;
            $toAccount->increment('amount', $transaction->amount);
        }

        if($transaction->type == Transaction::TYPE_PAID_BILL)  {
            // update bill info
            $bill = $transaction->bill;
            $bill->status = Bill::STATUS_PAID;
            $bill->paid_at = now();
            $bill->save();
            Log::info('OK');
        }

        // noti
        $this->notiReceiver($transaction);
    }

    private function notiReceiver($transaction) {
        $toAccount = $transaction->toAccount;
        $user = $toAccount->user;
        $noti = Notification::create([
            'user_id' => $toAccount->user_id,
            'title' => 'Received',
            'body' => "Your account number {$toAccount->account_number} had just received {$transaction->amount}"
        ]);
        $notificationService = new NotificationService();
        $notificationService->sendNotificationToAllUserDevice($user,  [
            'title' => $noti->title,
            'body' => $noti->body,
        ],);
    }
}
