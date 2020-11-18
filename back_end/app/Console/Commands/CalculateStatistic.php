<?php

namespace App\Console\Commands;

use App\Models\DailyStatistic;
use App\Models\MonthlyStatistic;
use Illuminate\Console\Command;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;

class CalculateStatistic extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'statistic:run {--date=}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Run calculate statistic daily';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $date = $this->option('date');
        if (!$date) {
            $date = now()->format('Y-m-d');
        }

        $totalCashIn = 0;
        $totalCashInAmount = 0;
        $totalCashOut = 0;
        $totalCashOutAmount = 0;
        $totalTransfer = 0;
        $totalTransferAmount = 0;
        $totalPending = 0;
        $totalPendingAmount = 0;

        // confirmed
        $confirmedData = Transaction::select(
            'type',
            DB::raw('COUNT(*) as total'),
            DB::raw('SUM(amount) as total_amount')
        )
            ->where('status', Transaction::STATUS_CONFIRMED)
            ->whereDate('created_at', $date)
            ->groupBy('type')
            ->get();


        foreach ($confirmedData as $typeData) {
            switch ($typeData->type) {
                case Transaction::TYPE_CASH_IN:
                    $totalCashIn = $typeData->total;
                    $totalCashInAmount = $typeData->total_amount;
                    break;
                case Transaction::TYPE_CASH_OUT:
                    $totalCashOut = $typeData->total;
                    $totalCashOutAmount = $typeData->total_amount;
                    break;
                case Transaction::TYPE_TRANSFER:
                    $totalTransfer = $typeData->total;
                    $totalTransferAmount = $typeData->total_amount;
                    break;
            }
        }

        $unconfirmedData = Transaction::select(
            DB::raw('COUNT(*) as total'),
            DB::raw('SUM(amount) as total_amount')
        )
            ->where('status', Transaction::STATUS_PENDING)
            ->whereDate('created_at', $date)
            ->first();

        $dailyData = DailyStatistic::updateOrCreate([
            'date' => $date,
        ], [
            'date' => $date,
            'total_cash_in' => $totalCashIn,
            'total_cash_in_amount' => $totalCashInAmount,
            'total_cash_out' => $totalCashOut,
            'total_cash_out_amount' => $totalCashOutAmount,
            'total_transfer' => $totalTransfer,
            'total_transfer_amount' => $totalTransferAmount,
            'total_pending' => $totalPending,
            'total_pending_amount' => $totalPendingAmount
        ]);
        $this->info($date);
        $this->calculateMonthlyStatistic($date);
        return 0;
    }

    private function calculateMonthlyStatistic($date) {
        $firstDayOfMonth = substr($date, 0, 8) . '01';
        $data = DailyStatistic::select(
            DB::raw('SUM(total_cash_in) as total_cash_in'),
            DB::raw('SUM(total_cash_in_amount) as total_cash_in_amount'),
            DB::raw('SUM(total_cash_out) as total_cash_out'),
            DB::raw('SUM(total_cash_out_amount) as total_cash_out_amount'),
            DB::raw('SUM(total_transfer) as total_transfer'),
            DB::raw('SUM(total_transfer_amount) as total_transfer_amount'),
            DB::raw('SUM(total_pending) as total_pending'),
            DB::raw('SUM(total_pending_amount) as total_pending_amount')
        )->whereBetween('date', [$firstDayOfMonth, $date])
        ->first()
        ->toArray();
            
        MonthlyStatistic::updateOrCreate([
            'date' => $firstDayOfMonth
        ], $data);
    }
}
