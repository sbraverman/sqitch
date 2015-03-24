use IPC::System::Simple qw(system capture);
use File::Basename;

my $dirname = dirname(__FILE__);
my @addarg = [];

if ($ARGV[0] eq 'add') 
{
    $addarg[0] = 'add';
    $addarg[1] = $ARGV[1] . '.' . $ARGV[2] . '.' . $ARGV[3]; # Name of Object (type.schema.name)
    $addarg[2] = '--template-directory ' . $ARGV[6] . '/sqitch/etc/templates/'; # $ARGV[6] is the Eclipse workspace location
    $addarg[3] = '-t sqlcmd.' . $ARGV[1]; # $ARGV[1] is the template type (table,view,schema etc.)
    $addarg[4] = '-r ' . join(' -r ',split(/,/,$ARGV[4])); # $ARGV[4] is a comma-separated list of dependencies
    $addarg[5] = '-s object_schema=' . $ARGV[2]; # $ARGV[2] is the schema for the object (used in template)
    $addarg[6] = '-s object_name=' . $ARGV[3]; # $ARGV[3] is the object name (used in template)
    $addarg[7] = '-n "' . $ARGV[5] .'"'; # $ARGV[5] is the Git commit message

    system($^X, $dirname . "\\sqitch.pl", @addarg);
    exit;
}

if ($ARGV[0] eq 'help')
{
	system($^X, $dirname . "\\sqitch.pl", @ARGV);
	exit;
} 

if ($ARGV[0] eq '' && $ARGV[1] eq '')
{
    system($^X, $dirname . "\\sqitch.pl", 'help');
    exit;
} 

if (($ARGV[1] eq 'alpha' || $ARGV[1] eq 'beta' || $ARGV[1] eq 'live') && 
    ($ARGV[0] eq 'checkout' || $ARGV[0] eq 'deploy' || $ARGV[0] eq 'rebase' || $ARGV[0] eq 'revert' || $ARGV[0] eq 'verify'))
    {
    	system("dsmod group \"CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\" -addmbr \"CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\"");
    	system($^X, $dirname . "\\sqitch.pl", @ARGV);
    	system("dsmod group \"CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\" -rmmbr \"CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk\"");
    }
    else
    {
    	system($^X, $dirname . "\\sqitch.pl", @ARGV);
    }