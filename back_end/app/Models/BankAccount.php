<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BankAccount extends Model
{
    use HasFactory;

    const STATUS_PENDING = 0;
    const STATUS_ACTIVATED = 1;

    const TYPE_TRANSFER = 0;
    const TYPE_SAVING_1_MONTH = 1;
    const TYPE_SAVING_3_MONTH = 2;
    const TYPE_SAVING_6_MONTH = 3;
    const TYPE_SAVING_12_MONTH = 4;

    protected $fillable = [
        'user_id',
        'account_number',
        'type',
        'amount',
        'interest_rate',
        'date_due',
        'status'
    ];

    protected $appends = [
        'status_text',
        'type_text'
    ];

    public function getTypeTextAttribute()
    {
        return isset($this->attributes['status']) 
            ? $this->getTypeText($this->attributes['status'])
            : null;
    }

    public function getStatusTextAttribute()
    {
        return isset($this->attributes['status']) 
            ? ( $this->attributes['status'] ? "Activated" : "Pending")
            : null;
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function getTypeText($type)
    {
        $typeTexts = [
            "Transfer",
            "Saving 1",
            "Saving 3",
            "Saving 6",
            "Saving 12"
        ];

        return $typeTexts[$type];
    }

    public function transactions()
    {
        return $this->hasMany(
            Transaction::class, 
            'account_number', 
            'account_number'
        );
    }
}
