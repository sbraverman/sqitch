#perl -w

# SJ 2015-02-10: fter perl 5.10 -CA is invalid on #! line so replace with these use statements
use open ':std', ':utf8';
use open IO => ':bytes';

use POSIX qw(setlocale);
BEGIN {
    if ($^O eq 'MSWin32') {
        require Win32::Locale;
        setlocale POSIX::LC_ALL, Win32::Locale::get_locale();
    } else {
        setlocale POSIX::LC_ALL, '';
    }
}
use FindBin;
use lib "$FindBin::Bin/../lib";
use App::Sqitch;

exit App::Sqitch->go;
