#!perl6

use v6.c;
use Test;

use MQ::Posix;

my $obj;

my $name = ('a' .. 'z').pick(8).join('') ~ $*PID.Str;

lives-ok { $obj = MQ::Posix.new(:$name, :r, :w, :create) }, "new";

isa-ok $obj, MQ::Posix;

my $attrs;

lives-ok { $attrs = $obj.get-attributes }, "get-attributes";
isa-ok $attrs, 'MQ::Posix::Attr';

cmp-ok $attrs.maxmsg, '>', 0,  "got maxmsg";
cmp-ok $attrs.msgsize, '>', 0, "got msgsize";

lives-ok { $obj.set-attributes( maxmsg => 15, msgsize => 4096) }, "set-attibutes";

lives-ok { $attrs = $obj.get-attributes }, "get-attributes again";
todo "something odd", 2;
cmp-ok $attrs.maxmsg, '==', 15,  "got maxmsg we set";
cmp-ok $attrs.msgsize, '==', 4096, "got msgsize we set";

diag $attrs.perl;



lives-ok { $obj.close }, "close";
lives-ok { $obj.unlink } , "unlink";

done-testing;
# vim: ft=perl6 ts=4 sw=4 expandtab
