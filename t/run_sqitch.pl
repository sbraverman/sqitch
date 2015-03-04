#perl -w

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
