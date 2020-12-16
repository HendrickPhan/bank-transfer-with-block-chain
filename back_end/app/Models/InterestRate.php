<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InterestRate extends Model
{
    use HasFactory;
    
    protected $table = 'interest_rates';
    
    protected $fillable = [
        'type',
        'rate'
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'rate' => 'float',
    ];

    public function getTypeText($type)
    {
        $typeTexts = [
            "Tài khoản giao dịch",
            "Tài khoản tiết kiệm 1 tháng",
            "Tài khoản tiết kiệm 3 tháng",
            "Tài khoản tiết kiệm 6 tháng",
            "Tài khoản tiết kiệm 12 tháng"
        ];

        return $typeTexts[$type];
    }
}
