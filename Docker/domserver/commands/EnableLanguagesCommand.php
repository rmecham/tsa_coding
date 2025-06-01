<?php declare(strict_types=1);

namespace App\Command;

use App\Entity\Language;
use App\Utils\Utils;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'domjudge:enable-languages',
    description: 'Enables the languages needed for TSA contests'
)]
class EnableLanguagesCommand extends Command
{
    public function __construct(
        protected readonly EntityManagerInterface $em,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $style = new SymfonyStyle($input, $output);

        // These are the languages we are targeting to enable: C#, Javascript, Ruby, Rust, Swift
        $langs = array('csharp', 'js', 'rb', 'rs', 'swift');

        foreach ($langs as $lang) {
            $db_lang = $this->em
                ->getRepository(Language::class)
                ->find($lang);
            if (!$db_lang) {
                $style->error('Cannot find language with ID ' . $lang . '.');
                return Command::FAILURE;
            }
            $db_lang->setAllowSubmit(true);
        }

        $this->em->flush();

        $langs_str = implode(', ', $langs);
        $style->success('The following languages have been enabled: ' . $langs_str . '.');

        return Command::SUCCESS;
    }
}
