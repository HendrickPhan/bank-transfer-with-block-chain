<?php

use App\Http\Controllers\Api\User\AuthController;
use App\Http\Controllers\Api\User\BankAccountController;
use App\Http\Controllers\Api\User\ReceiverController;
use App\Http\Controllers\Api\User\TransactionController;
use App\Http\Controllers\Api\User\NewsController;
use App\Http\Controllers\Api\User\NotificationController;
use App\Http\Controllers\Api\User\DeviceController;

use App\Http\Controllers\Api\Admin\InterestRateController as AdminInterestRateController;
use App\Http\Controllers\Api\Admin\BankAccountController as AdminBankAccountController;
use App\Http\Controllers\Api\Admin\UserController as AdminUserController;
use App\Http\Controllers\Api\Admin\SettingController as AdminSettingController;
use App\Http\Controllers\Api\Admin\NotificationController as AdminNotificationController;
use App\Http\Controllers\Api\Admin\NewsController as AdminNewsController;
use App\Http\Controllers\Api\Admin\TransactionController as AdminTransactionController;
use App\Http\Controllers\Api\Admin\StatisticController as AdminStatisticController;
use App\Http\Controllers\Api\Admin\BlockchainBlockController as AdminBlockchainBlockController;
use App\Http\Controllers\Api\Admin\BlockchainTransactionController as AdminBlockchainTransactionController;
use App\Http\Controllers\Api\Admin\BillController as AdminBillController;

use App\Http\Controllers\Api\System\BlockchainBlockController as SystemBlockchainBlockController;
use App\Http\Controllers\Api\System\BlockchainTransactionController as SystemBlockchainTransactionController;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

/* --AUTH-- */
Route::post('login', [AuthController::class, 'login']);
Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::get('profile', [AuthController::class, 'profile']);
});


/* --USER-- */
Route::group([
    'middleware' => ['auth:sanctum']
], function () {
    /*
    |--------------------------------------------------------------------------
    | Auth
    |--------------------------------------------------------------------------
    */
    Route::prefix('auth')->group(function () {
        Route::put('/pin-code', [AuthController::class, 'updatePinCode']);

        Route::put('/activate', [AuthController::class, 'activate']);
    });

    /*
    |--------------------------------------------------------------------------
    | Device
    |--------------------------------------------------------------------------
    */
    Route::prefix('device')->group(function () {
        Route::post('/', [DeviceController::class, 'create'])
            ->withoutMiddleware(['auth:sanctum']);

        Route::put('/{id}', [DeviceController::class, 'update']);
    });

    /*
    |--------------------------------------------------------------------------
    | Bank account
    |--------------------------------------------------------------------------
    */
    Route::prefix('bank-account')->group(function () {
        Route::get('/', [BankAccountController::class, 'list']);
      
        Route::get('/selections', [BankAccountController::class, 'selectList']);

        Route::get('/{account_number}/name', [BankAccountController::class, 'getAccountName']);

        Route::get('/{id}', [BankAccountController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
    });

    /*
    |--------------------------------------------------------------------------
    | Transaction
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'transaction'], function () {
        Route::get('/', [TransactionController::class, 'list']);
        
        Route::get('/{account_number}', [TransactionController::class, 'listByAccountNumber']);

        Route::get('/detail/{id}', [TransactionController::class, 'detail']);
        
        Route::post('/cash-out', [TransactionController::class, 'createCashOut'])
            ->middleware('checkPinCode');
    
        Route::post('/transfer', [TransactionController::class, 'createTransfer'])
            ->middleware('checkPinCode');

    });

    /*
    |--------------------------------------------------------------------------
    | Receiver
    |--------------------------------------------------------------------------
    */
    Route::prefix('receiver')->group(function () {
        Route::get('/', [ReceiverController::class, 'list']);
    
        Route::get('/{id}', [ReceiverController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
    
        Route::post('/', [ReceiverController::class, 'add']);
    
        Route::put('/{id}', [ReceiverController::class, 'update'])
            ->where(['user_id' => '[0-9]+']);
    
        Route::delete('/{id}', [ReceiverController::class, 'delete'])
            ->where(['user_id' => '[0-9]+']);
    });
    
    /*
    |--------------------------------------------------------------------------
    | News
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'news'], function () {
        Route::get('/', [NewsController::class, 'list']);
    
        Route::get('/{id}', [NewsController::class, 'detail']);
    });

    /*
    |--------------------------------------------------------------------------
    | Notification
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'notification'], function () {
        Route::get('/', [NotificationController::class, 'list']);
    
        Route::get('/{id}', [NotificationController::class, 'detail']);
    });
});


/* --ADMIN-- */
Route::group([
    'prefix' => 'admin',
    // 'middleware' => ['auth:sanctum']
], function () {
    /*
    |--------------------------------------------------------------------------
    | User
    |--------------------------------------------------------------------------
    */
    Route::prefix('user')->group(function () {
        Route::get('/', [AdminUserController::class, 'list']);
        
        Route::get('/{id}', [AdminUserController::class, 'detail'])
            ->where(['id' => '[0-9]+']);

        Route::put('/{id}', [AdminUserController::class, 'update'])
            ->where(['id' => '[0-9]+']);
            
        Route::post('/', [AdminUserController::class, 'create']);
    });    

    /*
    |--------------------------------------------------------------------------
    | Bank account
    |--------------------------------------------------------------------------
    */
    Route::prefix('{user_id}/bank-account')->group(function () {
        Route::get('/', [AdminBankAccountController::class, 'list'])
            ->where(['user_id' => '[0-9]+']);


        Route::post('/', [AdminBankAccountController::class, 'create'])
            ->where(['user_id' => '[0-9]+']);

        Route::get('/detail-bc', [AdminBankAccountController::class, 'detailOnBC']);
    });    

    Route::get('bank-account/{account_number}', [AdminBankAccountController::class, 'detail'])
        ->where(['account_number' => '[0-9]+']);

    /*
    |--------------------------------------------------------------------------
    | Interest Rate
    |--------------------------------------------------------------------------
    */
    Route::prefix('interest-rate')->group(function () {
        Route::get('/', [AdminInterestRateController::class, 'list']);

        Route::get('/{id}', [AdminInterestRateController::class, 'detail'])
            ->where(['id' => '[0-9]+']);

        Route::put('/{id}', [AdminInterestRateController::class, 'update'])
            ->where(['id' => '[0-9]+']);
    });    

    /*
    |--------------------------------------------------------------------------
    | Setting
    |--------------------------------------------------------------------------
    */
    Route::prefix('setting')->group(function () {
        Route::get('/', [AdminSettingController::class, 'list']);

        Route::get('/{id}', [AdminSettingController::class, 'detail']);
        
        Route::post('/', [AdminSettingController::class, 'add']);
        
        Route::put('/{id}', [AdminSettingController::class, 'update'])
            ->where(['id' => '[0-9]+']);
    });

    /*
    |--------------------------------------------------------------------------
    | News
    |--------------------------------------------------------------------------
    */
    Route::prefix('news')->group(function () {
        Route::get('/', [AdminNewsController::class, 'list']);

        Route::get('/{id}', [AdminNewsController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
        
        Route::post('/', [AdminNewsController::class, 'create']);
        
        Route::put('/{id}', [AdminNewsController::class, 'update'])
            ->where(['id' => '[0-9]+']);
    
        Route::delete('/{id}', [AdminNewsController::class, 'delete'])
            ->where(['id' => '[0-9]+']);
    });

    /*
    |--------------------------------------------------------------------------
    | Notification
    |--------------------------------------------------------------------------
    */
    Route::prefix('notification')->group(function () {
        Route::get('/', [AdminNotificationController::class, 'list']);

        Route::get('/{id}', [AdminNotificationController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
        
        Route::post('/', [AdminNotificationController::class, 'create']);
        
        Route::put('/{id}', [AdminNotificationController::class, 'update'])
            ->where(['id' => '[0-9]+']);
    
        Route::delete('/{id}', [AdminNotificationController::class, 'delete'])
            ->where(['id' => '[0-9]+']);
    });

    /*
    |--------------------------------------------------------------------------
    | Transaction
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'transaction'], function () {
        Route::get('/', [AdminTransactionController::class, 'list']);

        Route::get('/{id}', [AdminTransactionController::class, 'detail'])
            ->where(['id' => '[0-9]+']);

        Route::post('/cash-in', [AdminTransactionController::class, 'createCashIn']);
    });

    /*
    |--------------------------------------------------------------------------
    | Block chain block
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'block-chain/block'], function () {
        Route::get('/', [AdminBlockchainBlockController::class, 'list']);
        
        Route::get('/{id}', [AdminBlockchainBlockController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
    });

    /*
    |--------------------------------------------------------------------------
    | Block chain transaction
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'block-chain/transaction'], function () {
        Route::get('/', [AdminBlockchainTransactionController::class, 'list']);
        
        Route::get('/{id}', [AdminBlockchainTransactionController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
    });
    
    /*
    |--------------------------------------------------------------------------
    | Statistic
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'statistic'], function () {
        Route::get('/daily', [AdminStatisticController::class, 'getDailyStatistic']);

        Route::get('/monthly', [AdminStatisticController::class, 'getMonthlyStatistic']);
    });

    /*
    |--------------------------------------------------------------------------
    | bill
    |--------------------------------------------------------------------------
    */
    Route::prefix('bill')->group(function () {
        Route::get('/', [AdminBillController::class, 'list']);

        Route::get('/{id}', [AdminBillController::class, 'detail'])
            ->where(['id' => '[0-9]+']);
        
        Route::post('/', [AdminBillController::class, 'create']);
    });

});


/* --SYSTEM-- */
Route::group([
    'prefix' => 'system',
    // 'middleware' => ['auth:sanctum']
], function () {
    /*
    |--------------------------------------------------------------------------
    | Block chain block
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'block-chain/block'], function () {
        Route::get('/highest', [SystemBlockchainBlockController::class, 'getHighestBlock']);

        Route::post('/', [SystemBlockchainBlockController::class, 'create']);
    });

    /*
    |--------------------------------------------------------------------------
    | Block chain transaction
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'block-chain/transaction'], function () {
        Route::post('/', [SystemBlockchainTransactionController::class, 'create']);
    });

});