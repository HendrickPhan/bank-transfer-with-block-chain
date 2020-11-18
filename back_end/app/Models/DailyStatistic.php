<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DailyStatistic extends Model
{
    use HasFactory;

    protected $table="daily_statistics";

    protected $fillable = [
        'date',
        'total_cash_in',
        'total_cash_in_amount',
        'total_cash_out',
        'total_cash_out_amount',
        'total_transfer',
        'total_transfer_amount',
        'total_pending',
        'total_pending_amount'
    ];
}
