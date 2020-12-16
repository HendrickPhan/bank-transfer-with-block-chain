<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDailyStatisticsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('daily_statistics', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->unsignedInteger('total_cash_in')->default(0);
            $table->unsignedInteger('total_cash_in_amount')->default(0);
            $table->unsignedInteger('total_cash_out')->default(0);
            $table->unsignedInteger('total_cash_out_amount')->default(0);
            $table->unsignedInteger('total_transfer')->default(0);
            $table->unsignedInteger('total_transfer_amount')->default(0);
            $table->unsignedInteger('total_pending')->default(0);
            $table->unsignedInteger('total_pending_amount')->default(0);
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
        Schema::dropIfExists('daily_statistics');
    }
}
