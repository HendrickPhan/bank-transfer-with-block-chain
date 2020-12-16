<?php

namespace App\Http\Requests\Api\User\BankAccount;

use App\Models\BankAccount;
use Illuminate\Foundation\Http\FormRequest;
use App\Models\Setting;
use Exception;

class CreateSavingRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        $minSavingAmount = Setting::where('key', 'min_saving_amounts')
            ->first();
        if (!$minSavingAmount) {
            throw new Exception('Không tìm thấy cài đặt min_saving_amount, kiểm tra lại seed');
        }

        return [
            //
            'transfer_bank_account_number' => 'required|string|size:12',
            'amount' => 'required|integer|min:' . $minSavingAmount->value,
            'type' => 'required|in:' . BankAccount::TYPE_SAVING_1_MONTH . ',' .
                BankAccount::TYPE_SAVING_3_MONTH . ',' .
                BankAccount::TYPE_SAVING_6_MONTH . ',' .
                BankAccount::TYPE_SAVING_12_MONTH
        ];
    }
}
