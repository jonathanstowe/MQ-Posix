# MQ::Posix

Raku binding for POSIX message queues

![Build Status](https://github.com/jonathanstowe/MQ-Posix/workflows/CI/badge.svg)

## Synopsis

```raku

use MQ::Posix;

my $queue = MQ::Posix.new(name => 'test-queue', :create, :r );

react {
    whenever $queue.Supply -> $buf {
        say $buf.decode;
    }
    whenever signal(SIGINT) {
        $queue.close;
        $queue.unlink;
        done;
    }
}
```

And in some separate process:

```raku

use MQ::Posix;

my $queue = MQ::Posix.new(name => 'test-queue', :create, :w );

await $queue.send("some test message", priority => 10);

$queue.close;

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

If you have a working installation of Rakudo you should be able to install this with *zef* :

    zef install MQ::Posix

    # or from a local clone

    zef install .

## Support

This should work on any operating system that has good modern POSIX
support, however some systems may not enable kernel message queues by
the default and you may need some kernel build configuration to do so.
Also the limits and defaults for number of messages and maximum message
sizes are set in different ways as this is not explicitly stated in the
standard, on Linux, for example, you can use the ```sysctl``` interface
to control these parameters, on other systems you may need to supply
them as kernel build configuration.

If this doesn't work as expected or you have new features that you would like to see please post in https://github.com/jonathanstowe/MQ-Posix/issues

## Licence & Copyright

This is free software, please see the [LICENCE](LICENCE) for details.

© Jonathan Stowe 2017 - 2021

