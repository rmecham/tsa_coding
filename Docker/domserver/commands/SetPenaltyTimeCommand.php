<?php declare(strict_types=1);

namespace App\Command;

use App\Entity\Configuration;
use App\Utils\Utils;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'domjudge:set-penalty-time',
    description: 'Sets the penalty time to TSA defaults'
)]
class SetPenaltyTimeCommand extends Command
{
    public function __construct(
        protected readonly EntityManagerInterface $em,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $style = new SymfonyStyle($input, $output);

        $penaltyTimeConfiguration = $this->em
            ->getRepository(Configuration::class)
            ->findOneBy(['name' => 'penalty_time']);
        if (!$penaltyTimeConfiguration) {
            $penaltyTimeConfiguration = new Configuration();
            $penaltyTimeConfiguration->setName('penalty_time');
            $this->em->persist($penaltyTimeConfiguration);
        }
        $penaltyTimeConfiguration->setValue(0);

        $this->em->flush();

        $style->success('Set penalty time to 0.');

        return Command::SUCCESS;
    }
}
