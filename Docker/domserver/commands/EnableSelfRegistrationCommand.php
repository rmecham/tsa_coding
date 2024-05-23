<?php declare(strict_types=1);

namespace App\Command;

use App\Entity\TeamCategory;
use App\Utils\Utils;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'domjudge:enable-self-registration',
    description: 'Enables teams to self-register as needed for TSA contests'
)]
class EnableSelfRegistrationCommand extends Command
{
    public function __construct(
        protected readonly EntityManagerInterface $em,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $style = new SymfonyStyle($input, $output);

        $self_reg = $this->em
            ->getRepository(TeamCategory::class)
            ->find(2);
        if (!$self_reg) {
            $style->error('Cannot find team category with ID 2.');
            return Command::FAILURE;
        }
        $self_reg->setAllowSelfRegistration(true);

        $this->em->flush();

        $style->success('Self registration enabled for team category 2.');

        return Command::SUCCESS;
    }
}
