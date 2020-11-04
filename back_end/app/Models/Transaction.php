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

    protected $appends = [
        'status_text',
        'type_text'
    ];

    public function getTypeTextAttribute()
    {
        return isset($this->attributes['type']) 
            ? $this->getTypeText($this->attributes['type'])
            : null;
    }

    public static function getTypeText($type)
    {
        $typeTexts = [
            "Transfer",
            "Cash In",
            "Cash Out"
        ];

        return $typeTexts[$type];
    }

    public function getStatusTextAttribute()
    {
        return isset($this->attributes['status']) 
            ? ( $this->attributes['status'] ? "Confirmed" : "Pending")
            : null;
    }

    public function fromAccount() {
        return $this->belongsTo(BankAccount::class, 'from_account', 'account_number');
    }

    public function toAccount() {
        return $this->belongsTo(BankAccount::class, 'to_account', 'account_number');
    }
}
