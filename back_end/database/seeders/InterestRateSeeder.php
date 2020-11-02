<?php

namespace Database\Seeders;

use App\Models\InterestRate;
use App\Models\BankAccount;
use Illuminate\Database\Seeder;

class InterestRateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        InterestRate::firstOrCreate([
            'type' => BankAccount::TYPE_TRANSFER,
        ], [
            'type' => BankAccount::TYPE_TRANSFER,
            'rate' => 0.1,
        ]);

        InterestRate::firstOrCreate([
            'type' => BankAccount::TYPE_SAVING_1_MONTH,
        ], [
            'type' => BankAccount::TYPE_SAVING_1_MONTH,
            'rate' => 3.9,
        ]);

        InterestRate::firstOrCreate([
            'type' => BankAccount::TYPE_SAVING_3_MONTH,
        ], [
            'type' => BankAccount::TYPE_SAVING_3_MONTH,
            'rate' => 4.1,
        ]);

        InterestRate::firstOrCreate([
            'type' => BankAccount::TYPE_SAVING_6_MONTH,
        ], [
            'type' => BankAccount::TYPE_SAVING_6_MONTH,
            'rate' => 4.5,
        ]);

        InterestRate::firstOrCreate([
            'type' => BankAccount::TYPE_SAVING_12_MONTH,
        ], [
            'type' => BankAccount::TYPE_SAVING_12_MONTH,
            'rate' => 4.9,
        ]);

    }
}
