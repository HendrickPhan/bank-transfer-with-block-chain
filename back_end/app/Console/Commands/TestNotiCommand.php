<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Http\Services\NotificationService;

class TestNotiCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'test:noti';

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
        $notificationService = new NotificationService();
        $rs = $notificationService->sendBatchNotification([
            'dJttkLZTZDENkb9v1gU1Hh:APA91bEFMW726gJxBYvG8Z52MnavhCijkfqQtsoKGnXdmXv6qDN5JG38plty35hFlMMkYTBo0Pd4CWJwlSqjDUBQNPGzbTgq1nW05RHbehr-gKMrToKUik_KpoRjtK0Mhux-gxpFcp0F'
        ], [
            'topicName' => 'test',
            'body' => "ok",
            'title' => 'title',
            'additional_data' => [ 
                "id" => 1,
                "type" => "ok"
            ]
        ]);
        echo($rs);
        return 0;
    }
}
