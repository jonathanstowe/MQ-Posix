# MQ::Posix

Perl 6 binding for POSIX message queues

## Synopsis

```perl6

use MQ::Posix;

my $queue = MQ::Posix.new(name => 'test-queue', :create, :read);


```
