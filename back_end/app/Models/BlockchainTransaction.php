<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BlockchainTransaction extends Model
{
    protected $fillable = [
        'blockHash',
        'blockNumber',
        'from',
        'hash',
        'input',
        'nonce',
        'to',
        'transactionIndex',
        'value'
    ];
    
    use HasFactory;

    public function block() {
        return $this->belongsTo(BlockchainBlock::class, 'blockHash', 'hash' );
    }
}
