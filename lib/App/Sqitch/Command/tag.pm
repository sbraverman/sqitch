package App::Sqitch::Command::tag;

use v5.10.1;
use strict;
use warnings;
use utf8;
use Moose;
use Locale::TextDomain qw(App-Sqitch);
use namespace::autoclean;

extends 'App::Sqitch::Command';

our $VERSION = '0.50';

sub execute {
    my ( $self, $name ) = @_;
    my $sqitch = $self->sqitch;
    my $plan   = $sqitch->plan;

    if (defined $name) {
        my $tag = $plan->add_tag($name);

        # We good, write the plan file back out.
        $plan->write_to( $sqitch->plan_file );
        $self->info(__x(
            'Tagged "{change}" with {tag}',
            change => $tag->change->format_name,
            tag    => $tag->format_name,
        ));
    } else {
        # Emit a list of tags.
        $self->info($_->format_name) for $plan->tags;
    }

    return $self;
}

1;

__END__

=head1 Name

App::Sqitch::Command::tag - Tag a Sqitch change

=head1 Synopsis

  my $cmd = App::Sqitch::Command::tag->new(%params);
  $cmd->execute;

=head1 Description

Tags a Sqitch change. The tag will be added to the last change in the plan.

=head1 Interface

=head2 Instance Methods

=head3 C<execute>

  $tag->execute($command);

Executes the C<tag> command.

=head1 See Also

=over

=item L<sqitch-tag>

Documentation for the C<tag> command to the Sqitch command-line client.

=item L<sqitch>

The Sqitch command-line client.

=back

=head1 Author

David E. Wheeler <david@justatheory.com>

=head1 License

Copyright (c) 2012 iovation Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut