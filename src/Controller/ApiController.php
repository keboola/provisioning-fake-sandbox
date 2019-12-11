<?php

declare(strict_types=1);

namespace Keboola\FakeSandbox\Controller;

use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Filesystem\Filesystem;
use Symfony\Component\Finder\Finder;
use Symfony\Component\HttpFoundation\JsonResponse;

class ApiController extends AbstractController
{
    /** @var LoggerInterface */
    private $logger;

    /** @var string */
    private $dataDir;

    public function __construct(LoggerInterface $logger, string $dataDir)
    {
        $this->logger = $logger;
        $this->dataDir = $dataDir;
    }

    public function index(): JsonResponse
    {
        return $this->json(['message' => 'All your base are belong to us']);
    }

    public function list(): JsonResponse
    {
        $finder = new Finder();
        $finder->in($this->dataDir)->sortByName();
        $files = [];
        foreach ($finder as $file) {
            $this->logger->info(sprintf('Listing file "%s".', $file->getPathname()));
            $files[] = str_replace('\\', '/', $file->getRelativePathname());
        }
        return $this->json($files);
    }

    public function copy(): JsonResponse
    {
        $fs = new Filesystem();
        $finder = new Finder();
        $finder->files()->notName('*.manifest')->in($this->dataDir . '/in/')->sortByName();
        $files = [];
        foreach ($finder as $sourceFile) {
            $this->logger->info(sprintf('Copying file "%s".', $sourceFile->getPathname()));
            $target = '/out/' . str_replace('\\', '/', $sourceFile->getRelativePathname());
            $files[] = $target;
            $fs->copy($sourceFile->getPathname(), $this->dataDir . '/' . $target);
        }
        return $this->json($files);
    }
}
