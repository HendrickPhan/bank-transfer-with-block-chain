<?php

namespace App\Http\Requests\Api\Admin\BankAccount;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\BankAccount;

class DetailBCRequest extends FormRequest
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
            'account_number' => 'required|exists:bank_accounts,account_number'
        ];
    }
}
