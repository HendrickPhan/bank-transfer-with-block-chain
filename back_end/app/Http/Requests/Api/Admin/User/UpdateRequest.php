<?php

namespace App\Http\Requests\Api\Admin\User;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
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
            'name' => 'max:255|string',
            'password' => 'max:255|string',
            'phone_number' => 'min:10|max:12|string|unique:users,phone_number,' . $this->request->id
        ];
    }
}

