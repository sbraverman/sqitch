use IPC::System::Simple qw(system capture);
use File::Basename;

my $dirname = dirname(__FILE__);

if ($ARGV[0] eq 'help')
{
	system($^X, $dirname . "\\run_sqitch.pl", @ARGV);
	exit;
} 

if ($ARGV[0] eq '' && $ARGV[1] eq '')
{
    system($^X, $dirname . "\\run_sqitch.pl", 'help');
    exit;
} 

if (($ARGV[1] eq 'alpha' || $ARGV[1] eq 'beta' || $ARGV[1] eq 'live') && 
    ($ARGV[0] eq 'checkout' || $ARGV[0] eq 'deploy' || $ARGV[0] eq 'rebase' || $ARGV[0] eq 'revert' || $ARGV[0] eq 'verify'))
    {
    	system("dsmod group \"CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\" -addmbr \"CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\"");
    	system($^X, $dirname . "\\run_sqitch.pl", @ARGV);
    	system("dsmod group \"CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\" -rmmbr \"CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\"");
    }
    else
    {
    	system($^X, $dirname . "\\run_sqitch.pl", @ARGV);
    }