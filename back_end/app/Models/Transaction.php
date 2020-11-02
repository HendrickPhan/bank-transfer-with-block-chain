<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    CONST TYPE_TRANSFER = 0;
    CONST TYPE_CASH_IN = 1;
    CONST TYPE_CASH_OUT = 2;

    CONST STATUS_PENDING = 0;
    CONST STATUS_CONFIRMED = 1;

    protected $fillable = [
        'type',
        'code',
        'from_account',
        'to_account',
        'amount',
        'fee'
    ];

    public function fromAccount() {
        return $this->belongsTo(BankAccount::class, 'from_account', 'account_number');
    }

    public function toAccount() {
        return $this->belongsTo(BankAccount::class, 'to_account', 'account_number');
    }
}
