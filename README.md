# MQ::Posix

Perl 6 binding for POSIX message queues

## Synopsis

```perl6

use MQ::Posix;

my $queue = MQ::Posix.new(name => 'test-queue', :create, :r, :w);


```

## Description

POSIX message queues offer a mechanism for processes to reliably exchange
data in the form of messages

The messages are presented as a priority ordered queue with higher priority
messages being delivered first and messages of equal priority being delivered
in age order.

The mechanism is simple, having no provision for message metadata and so forth
and whilst reliable, unread messages do not persist beyond the lifetime of the
running kernel.

## Install

If you have a working installation of Rakudo Perl 6 you should be able to
install this with *zef* :

    zef install MQ::Posix

    # or from a local clone

    zef install .

## Support

If this doesn't work as expected or you have new features that you would like
to see please post in https://github.com/jonathanstowe/MQ-Posix/issues

## Licence & Copyright

This is free software, please see the [LICENCE](LICENCE) for details.

© Jonathan Stowe 2017

