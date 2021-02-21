<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bill extends Model
{
    use HasFactory;
    
    CONST STATUS_NOT_PAID = 0;
    CONST STATUS_PAID = 1;

    protected $fillable = [
        'user_id',
        'type',
        'amount',
        'time',
        'paid_at',
        'status',
        'transaction_code'
    ];

    protected $appends = [
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
            "Water",
            "Electricity",
            "Internet",
        ];

        return $typeTexts[$type];
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function transaction()
    {
        return $this->belongsTo(Transaction::class, 'transaction_code', 'code');
    }
}
