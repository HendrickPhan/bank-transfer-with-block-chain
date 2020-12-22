<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Api\Admin\InterestRate\UpdateRequest;
use App\Models\InterestRate;

class InterestRateController extends Controller
{
    //
    public function list(Request $request)
    {
        $limit = $request->get('limit', 10);
        $interestRates = InterestRate::orderBy('id', 'desc')
            ->paginate($limit);
        $this->_generateTypeText($interestRates);
        return $this->responseSuccess($interestRates);
    }
    
    public function update(UpdateRequest $request)
    {
        $interestRate = InterestRate::find($request->id);
        if(!$interestRate) {
            return $this->responseError('Không tìm thấy lãi suất');
        }
        $data = $request->validated();
        $interestRate->update($data);
        return $this->responseSuccess($interestRate);
    }

    public function detail(Request $request)
    {
        $interestRate = InterestRate::find($request->id);
        $interestRate["type_text"] = $interestRate->getTypeText($interestRate->type); 
        return $this->responseSuccess($interestRate);
    }

    private function _generateTypeText(&$interestRates) {
        foreach($interestRates as $interestRate) {
            $interestRate["type_text"] = $interestRate->getTypeText($interestRate->type); 
        }
    }
}
