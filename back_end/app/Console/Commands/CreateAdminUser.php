<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class CreateAdminUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'admin:create';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

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
        //
        $phoneNumber = $this->ask("What is your phone number?");
        $name = $this->ask("What is your name?");
        $password = $this->secret("What is your password?");
        $confirmPassword = $this->secret("Retype your password?");
        
        if($password != $confirmPassword) {
            echo("Wrong confirm password \n");
            return;
        }

        $exist = User::where("phone_number", $phoneNumber)->count();
        if($exist) {
            echo("User already exists \n");
            return;
        }

        $user = User::create([
            "phone_number" => $phoneNumber,
            "name" => $name,
            "password" => Hash::make($password),
            "role" => User::ROLE_ADMIN
        ]);
        
        echo("Admin user created success \n");
        
        return;
    }
}
