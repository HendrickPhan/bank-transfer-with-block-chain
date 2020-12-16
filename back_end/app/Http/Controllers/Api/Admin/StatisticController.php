<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\DailyStatistic;
use App\Models\MonthlyStatistic;

class StatisticController extends Controller
{
    //

    public function getDailyStatistic(Request $request)
    {
        $dailyStatistics = DailyStatistic::whereBetween('date', [
            $request->input('from_date'),
            $request->input('to_date')
        ])
            ->get();

        return $this->responseSuccess($dailyStatistics);
    }

    public function getMonthlyStatistic(Request $request)
    {
        $monthlyStatistics = MonthlyStatistic::whereBetween('date', [
            $request->input('from_date'),
            $request->input('to_date')
        ])
            ->get();

        return $this->responseSuccess($monthlyStatistics);
    }
}
