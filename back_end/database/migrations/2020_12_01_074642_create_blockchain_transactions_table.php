<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBlockchainTransactionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('blockchain_transactions', function (Blueprint $table) {
            $table->id();
            $table->text('blockHash');
            $table->unsignedInteger('blockNumber');
            $table->text('from');
            $table->text('hash');
            $table->text('input');
            $table->unsignedInteger('nonce');
            $table->text('to')->nullable();
            $table->unsignedInteger('transactionIndex');
            $table->unsignedBigInteger('value');
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
        Schema::dropIfExists('blockchain_transactions');
    }
}
