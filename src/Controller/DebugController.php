<?php

namespace App\Controller;

use Composer\InstalledVersions;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class DebugController extends AbstractController
{
    #[Route('/debug', name: 'debug')]
    public function __invoke(): Response
    {
        ob_start();
        phpinfo();
        $phpinfo = ob_get_clean();

        $phppackages = InstalledVersions::getRawData()['versions'];

        return $this->render('index/debug.html.twig', [
            'php_info' => $phpinfo,
            'php_packages' => $phppackages,
        ]);
    }
}
