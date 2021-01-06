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
            $table->unsignedInteger('difficulty')->nullable();
            $table->text('extraData')->nullable();
            $table->unsignedInteger('gasLimit')->nullable();
            $table->unsignedInteger('gasUsed')->nullable();
            $table->text('hash')->nullable();
            $table->text('logsBloom')->nullable();
            $table->text('miner')->nullable();
            $table->text('mixHash')->nullable();
            $table->text('nonce')->nullable();
            $table->unsignedInteger('number')->nullable();
            $table->text('parentHash')->nullable();
            $table->text('receiptsRoot')->nullable();
            $table->unsignedInteger('size')->nullable();
            $table->text('stateRoot')->nullable();
            $table->unsignedBigInteger('timestamp')->nullable();
            $table->unsignedInteger('totalDifficulty')->nullable();
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
