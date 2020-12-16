<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BlockchainBlock extends Model
{
    protected $fillable = [
        'difficulty',
        'extraData',
        'gasLimit',
        'gasUsed',
        'hash',
        'logsBloom',
        'miner',
        'mixHash',
        'nonce',
        'number',
        'parentHash',
        'receiptsRoot',
        'size',
        'stateRoot',
        'timestamp',
        'totalDifficulty',
    ];

    use HasFactory;

    public function transactions () {
        return $this->hasMany(BlockchainTransaction::class, 'blockHash', 'hash');
    }
}
