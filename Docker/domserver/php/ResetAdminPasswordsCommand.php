<?php declare(strict_types=1);

namespace App\Command;

use App\Entity\User;
use App\Utils\Utils;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[AsCommand(
    name: 'domjudge:reset-admin-passwords',
    description: 'Resets the admin and judgehost passwords based on environment variables'
)]
class ResetAdminPasswordsCommand extends Command
{
    public function __construct(
        protected readonly EntityManagerInterface $em,
        protected readonly UserPasswordHasherInterface $passwordHasher
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $style = new SymfonyStyle($input, $output);

        $admin_user = $this->em
            ->getRepository(User::class)
            ->findOneBy(['username' => 'admin']);

        if (!$admin_user) {
            $style->error('Cannot find user with username admin.');
            return Command::FAILURE;
        }
        $judge_user = $this->em
            ->getRepository(User::class)
            ->findOneBy(['username' => 'judgehost']);

        if (!$judge_user) {
            $style->error('Cannot find user with username judgehost.');
            return Command::FAILURE;
        }

        $admin_pw = getenv('DJ_ADMIN_PASSWORD');
        $judge_pw = getenv('JUDGEDAEMON_PASSWORD');

        $admin_user->setPassword(
            $this->passwordHasher->hashPassword($admin_user, $admin_pw)
        );
        $judge_user->setPassword(
            $this->passwordHasher->hashPassword($judge_user, $judge_pw)
        );
        $this->em->flush();

        $style->success('New password for admin is ' . $admin_pw);
        $style->success('New password for judgehost is ' . $judge_pw);

        return Command::SUCCESS;
    }
}
