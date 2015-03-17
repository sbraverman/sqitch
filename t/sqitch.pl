use IPC::System::Simple qw(system capture);





if ($ARGV[0] eq 'help')
{
	system($^X, "run_sqitch.pl", @ARGS);
} 