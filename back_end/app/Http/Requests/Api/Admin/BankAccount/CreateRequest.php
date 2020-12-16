<?php

namespace App\Http\Requests\Api\Admin\BankAccount;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\BankAccount;

class CreateRequest extends FormRequest
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
        return [
            'type' => 'required|in:' . BankAccount::TYPE_TRANSFER . ',' .
                BankAccount::TYPE_SAVING_1_MONTH . ',' .
                BankAccount::TYPE_SAVING_3_MONTH . ',' .
                BankAccount::TYPE_SAVING_6_MONTH . ',' .
                BankAccount::TYPE_SAVING_12_MONTH
        ];
    }
}
