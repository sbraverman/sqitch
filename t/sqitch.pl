use IPC::System::Simple qw(system capture);
use File::Basename;

my $dirname = dirname(__FILE__);
my @ecladdout = [];

if ($ARGV[0] eq 'ecladd') # ecladd indicates that the Sqitch Add was called from Eclipse
{
    $ecladdout[0] = 'add';
    $ecladdout[1] = $ARGV[4] . '.' . $ARGV[5] . '.' . $ARGV[6]; # Name of Object (type.schema.name)
    $ecladdout[2] = '--template-directory ' . $ARGV[1] . '/sqitch/etc/templates/'; # $ARGV[1] is the Eclipse workspace location
    $ecladdout[3] = '-t sqlcmd.' . $ARGV[4]; # $ARGV[4] is the template type (table,view,schema etc.)
    $ecladdout[4] = '-r ' . join(' -r ',split(/,/,$ARGV[3])); # $ARGV[3] is a comma-separated list of dependencies
    $ecladdout[5] = '-s object_schema=' . $ARGV[5]; # $ARGV[5] is the schema for the object (used in template)
    $ecladdout[6] = '-s object_name=' . $ARGV[6]; # $ARGV[6] is the object name (used in template)
    $ecladdout[7] = '-n "' . $ARGV[7] .'"'; # $ARGV[7] is the Git commit message

    system($^X, $dirname . "\\run_sqitch.pl", @ecladdout);
    exit;
}

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