<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBlockchainBlocksTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('blockchain_blocks', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('difficulty');
            $table->text('extraData');
            $table->unsignedInteger('gasLimit');
            $table->unsignedInteger('gasUsed');
            $table->text('hash');
            $table->text('logsBloom');
            $table->text('miner');
            $table->text('mixHash');
            $table->text('nonce');
            $table->unsignedInteger('number');
            $table->text('parentHash');
            $table->text('receiptsRoot');
            $table->unsignedInteger('size');
            $table->text('stateRoot');
            $table->unsignedBigInteger('timestamp');
            $table->unsignedInteger('totalDifficulty');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('blockchain_blocks');
    }
}
