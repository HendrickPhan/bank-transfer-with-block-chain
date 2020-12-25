<?php

namespace App\Http\Services;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Exception;

class NotificationService 
{
    public function sendNotificationToAllUserDevice($user, $data)
    {
        $devices = $user->devices();
        $tokens = $devices->pluck('token');
        $data['topicName'] = $user->phone_number; 
        $this->sendBatchNotification($tokens, $data);
    }

    /**
     * @param $deviceTokens
     * @param $data
     * @throws GuzzleException
     */
    public function sendBatchNotification($deviceTokens, $data = [])
    {
        $this->subscribeTopic($deviceTokens, $data['topicName']);
        $this->sendNotification($data, $data['topicName']);
        $this->unsubscribeTopic($deviceTokens, $data['topicName']);
    }

    /**
     * @param $data
     * @param $topicName
     * @throws GuzzleException
     */
    public function sendNotification($data, $topicName = null)
    {
        $url = 'https://fcm.googleapis.com/fcm/send';
        $data = [
            'to' => '/topics/' . $topicName,
            'notification' => [
                'body' => $data['body'] ?? 'Something',
                'title' => $data['title'] ?? 'Something',
                'image' => $data['image'] ?? null,
            ],
            'data' => [
                'additional_data' => $data['additional_data'] ?? null,
            ],
            'apns' => [
                'payload' => [
                    'aps' => [
                        'mutable-content' => 1,
                    ],
                ],
                'fcm_options' => [
                    'image' => $data['image'] ?? null,
                ], 
            ],
        ];

        $this->execute($url, $data);
    }

    /**
     * @param $deviceToken
     * @param $topicName
     * @throws GuzzleException
     */
    public function subscribeTopic($deviceTokens, $topicName = null)
    {
        $url = 'https://iid.googleapis.com/iid/v1:batchAdd';
        $data = [
            'to' => '/topics/' . $topicName,
            'registration_tokens' => $deviceTokens,
        ];

        $this->execute($url, $data);
    }

    /**
     * @param $deviceToken
     * @param $topicName
     * @throws GuzzleException
     */
    public function unsubscribeTopic($deviceTokens, $topicName = null)
    {
        $url = 'https://iid.googleapis.com/iid/v1:batchRemove';
        $data = [
            'to' => '/topics/' . $topicName,
            'registration_tokens' => $deviceTokens,
        ];

        $this->execute($url, $data);
    }

    /**
     * @param $url
     * @param array $dataPost
     * @param string $method
     * @return bool
     * @throws GuzzleException
     */
    private function execute($url, $dataPost = [], $method = 'POST')
    {
        $result = false;
        try {
            $client = new Client();
            $result = $client->request($method, $url, [
                'headers' => [
                    'Content-Type' => 'application/json',
                    'Authorization' => 'key=' . env('SERVER_KEY'),
                ],
                'json' => $dataPost,
                'timeout' => 300,
            ]);
            
            Log::debug(env('SERVER_KEY'));
            Log::debug($result->getBody());
            $result = $result->getStatusCode() == Response::HTTP_OK;

        } catch (Exception $e) {
            Log::debug($e);
        }

        return $result;
    }
}