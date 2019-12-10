<?php

declare(strict_types=1);

namespace Keboola\Tests\FakeSandbox\Controller;

use Keboola\Temp\Temp;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\Filesystem\Filesystem;

class ApiControllerTest extends WebTestCase
{
    public function setUp(): void
    {
        parent::setUp();
    }

    public function testCopy(): void
    {
        $client = static::createClient([], []);
        $temp = new Temp();
        putenv('data_dir=' . $temp->getTmpFolder());
        $fs = new Filesystem();
        $fs->mirror(__DIR__ . '/../data/', $temp->getTmpFolder());
        $client->request('GET', '/copy', [], [], []);
        self::assertEquals(200, $client->getResponse()->getStatusCode(), (string) $client->getResponse()->getContent());
        $response = json_decode((string) $client->getResponse()->getContent(), true);
        self::assertEquals(
            [
                '/out/files/dummy',
                '/out/tables/source.csv',
            ],
            $response
        );
    }

    public function testList(): void
    {
        putenv('data_dir=' . __DIR__ . '/../data/');
        $client = static::createClient([], []);
        $client->request('GET', '/list', [], [], []);
        self::assertEquals(200, $client->getResponse()->getStatusCode(), (string) $client->getResponse()->getContent());
        $response = json_decode((string) $client->getResponse()->getContent(), true);
        self::assertEquals(
            [
                'files',
                'files/dummy',
                'files/dummy.manifest',
                'tables',
                'tables/source.csv',
                'tables/source.csv.manifest',
            ],
            $response
        );
    }

    public function testIndex(): void
    {
        $client = static::createClient([], []);
        $client->request('GET', '/', [], [], []);
        self::assertEquals(200, $client->getResponse()->getStatusCode(), (string) $client->getResponse()->getContent());
        $response = json_decode((string) $client->getResponse()->getContent(), true);
        self::assertEquals(
            ['message' => 'All your base are belong to us'],
            $response
        );
    }
}
