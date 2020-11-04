<?php

use App\Http\Controllers\Api\User\AuthController;
use App\Http\Controllers\Api\User\BankAccountController;
use App\Http\Controllers\Api\User\ReceiverController;
use App\Http\Controllers\Api\User\TransactionController;
use App\Http\Controllers\Api\User\NewsController;
use App\Http\Controllers\Api\User\NotificationController;

use App\Http\Controllers\Api\Admin\InterestRateController as AdminInterestRateController;
use App\Http\Controllers\Api\Admin\BankAccountController as AdminBankAccountController;
use App\Http\Controllers\Api\Admin\UserController as AdminUserController;
use App\Http\Controllers\Api\Admin\SettingController as AdminSettingController;
use App\Http\Controllers\Api\Admin\NotificationController as AdminNotificationController;
use App\Http\Controllers\Api\Admin\NewsController as AdminNewsController;
use App\Http\Controllers\Api\Admin\TransactionController as AdminTransactionController;

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
    | Bank account
    |--------------------------------------------------------------------------
    */
    Route::prefix('bank-account')->group(function () {
        Route::get('/', [BankAccountController::class, 'list']);

        Route::get('/{id}', [BankAccountController::class, 'list']);
    });

    /*
    |--------------------------------------------------------------------------
    | Transaction
    |--------------------------------------------------------------------------
    */
    Route::group(['prefix' => 'transaction', 'middleware' => ['checkPinCode']], function () {
        Route::get('/{account_number}', [TransactionController::class, 'list']);
        
        Route::post('/cash-out', [TransactionController::class, 'createCashOut']);
    
        Route::post('/transfer', [TransactionController::class, 'createTransfer']);
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

        Route::post('/', [AdminUserController::class, 'create']);
    });    

    /*
    |--------------------------------------------------------------------------
    | Bank account
    |--------------------------------------------------------------------------
    */
    Route::prefix('bank-account')->group(function () {
        Route::get('/{user_id}', [AdminBankAccountController::class, 'list'])
            ->where(['user_id' => '[0-9]+']);

        Route::post('/{user_id}', [AdminBankAccountController::class, 'create'])
            ->where(['user_id' => '[0-9]+']);

        Route::get('/detail-bc', [AdminBankAccountController::class, 'detailOnBC']);
    });    

    /*
    |--------------------------------------------------------------------------
    | Interest Rate
    |--------------------------------------------------------------------------
    */
    Route::prefix('interest-rate')->group(function () {
        Route::get('/', [AdminInterestRateController::class, 'list']);

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
});
