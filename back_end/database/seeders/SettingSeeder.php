<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Setting;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        $minSavingAmount = Setting::firstOrCreate([
            'key' => 'min_saving_amount'
        ],[
            'key' => 'min_saving_amount',
            'value' => 3000000
        ]);

        //
        $transferFee = Setting::firstOrCreate([
            'key' => 'transfer_fee'
        ],[
            'key' => 'transfer_fee',
            'value' => 2000
        ]);

        //
        $cashOutFee = Setting::firstOrCreate([
            'key' => 'cash_out_fee'
        ],[
            'key' => 'cash_out_fee',
            'value' => 1000
        ]);
    }
}
