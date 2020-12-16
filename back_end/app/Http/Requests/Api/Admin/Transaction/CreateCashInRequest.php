<?php

namespace App\Http\Requests\Api\Admin\Transaction;

use Illuminate\Foundation\Http\FormRequest;

class CreateCashInRequest extends FormRequest
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
            //
            'amount' => 'required|integer|min:1000|max:5000000',
            'account_number' => 'required|string'
        ];
    }
}
