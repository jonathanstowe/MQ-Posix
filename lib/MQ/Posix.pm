use v6.c;

use NativeCall;
use NativeHelpers::Array;

class MQ::Posix {

    constant __syscall_slong_t  = int64;
    constant mqd_t              = int32;

    constant LIB = [ 'rt', v1 ];

    constant ReadOnly   = 0;
    constant WriteOnly  = 1;
    constant ReadWrite  = 2;

    constant Create     = 64;
    constant Exclusive  = 128;


    class Attr is repr('CStruct') {
        has __syscall_slong_t           $.flags;
        has __syscall_slong_t           $.max-messages;
        has __syscall_slong_t           $.message-size;
        has __syscall_slong_t           $.current-messages;
        has __syscall_slong_t           $!__pad_1;
        has __syscall_slong_t           $!__pad_2;
        has __syscall_slong_t           $!__pad_3;
        has __syscall_slong_t           $!__pad_4;
    }

    has Str $.name is required;
    has Int  $!open-flags;

    has Int $.max-messages;
    has Int $.message-size;

    has Int $.mode;


    has Int $!queue-descriptor;

    my $errno := cglobal(Str, 'errno', int32);

    sub mq_open(Str $name, int32 $oflag, int32 $mode, Attr $attr) is native(LIB) returns mqd_t  { * }

    
    method queue-descriptor(--> mqd_t) {
        my Attr $attr;

        if ( $!open-flags & Create ) && ( $!message-size || $!max-messages ) {
            $attr = Attr.new(message-size => $!message-size || 8192, max-messages => $!max-messages || 10);
        }
        $!queue-descriptor //= mq_open($!name, $!open-flags, $!mode, $attr);
    }

# == /usr/include/mqueue.h ==

#-From /usr/include/mqueue.h:40
#/* Establish connection between a process and a message queue NAME and
#   return message queue descriptor or (mqd_t) -1 on error.  OFLAG determines
#   the type of access used.  If O_CREAT is on OFLAG, the third argument is
#   taken as a `mode_t', the mode of the created message queue, and the fourth
#   argument is taken as `struct Attr *', pointer to message queue
#   attributes.  If the fourth argument is NULL, default attributes are
#   used.  */
#extern mqd_t mq_open (const char *__name, int __oflag, ...)


    submethod BUILD(Str :$!name!, Bool :$r, Bool :$w, Bool :$create, Bool :$exclusive, Int :$!max-messages, Int :$!message-size, Int :$!mode = 0o660) {
        if !$!name.starts-with('/') {
            $!name = '/' ~ $!name;
        }
        $!open-flags = do if $r && $w {
            ReadWrite;
        }
        elsif $w {
            WriteOnly;
        }
        else {
            ReadOnly;
        }

        if $create {
            $!open-flags +|= Create;
            if $exclusive {
                $!open-flags +|= Exclusive;
            }
        }

    }

#-From /usr/include/mqueue.h:45
#/* Removes the association between message queue descriptor MQDES and its
#   message queue.  */
#extern int mq_close (mqd_t __mqdes) __THROW;

    sub mq_close(mqd_t $mqdes ) is native(LIB) returns int32 { * }

    method close( --> Bool) {
        my Bool $rc = True;
        if $!queue-descriptor.defined {
            $rc = !mq_close($!queue-descriptor);
        }
        $rc;
    }

#-From /usr/include/mqueue.h:48
#/* Query status and attributes of message queue MQDES.  */
#extern int mq_getattr (mqd_t __mqdes, struct Attr *__mqstat)

    sub mq_getattr(mqd_t $mqdes, Attr $mqstat is rw) is native(LIB) returns int32  { * }

    method get-attributes(--> Attr) {
        my $attrs = Attr.new;
        mq_getattr(self.queue-descriptor, $attrs);
        $attrs;
    }

#-From /usr/include/mqueue.h:53
#/* Set attributes associated with message queue MQDES and if OMQSTAT is
#   not NULL also query its old attributes.  */
#extern int mq_setattr (mqd_t __mqdes,

    sub mq_setattr(mqd_t $mqdes, Attr $mqstat, Attr $omqstat) is native(LIB) returns int32 { * }


    proto method set-attributes(|c) { * }

    multi method set-attributes(:$maxmsg!, :$msgsize! --> Bool ) {
        self.set-attributes(Attr.new(:$maxmsg, :$msgsize));
    }

    multi method set-attributes(Attr:D $mqstat --> Bool) {
        my $rc = mq_setattr(self.queue-descriptor, $mqstat, Attr);
        !$rc;
    }

#-From /usr/include/mqueue.h:59
#/* Remove message queue named NAME.  */
#extern int mq_unlink (const char *__name) __THROW __nonnull ((1));

    sub mq_unlink(Str $name ) is native(LIB) returns int32 { * }

    method unlink(--> Bool) {
        !mq_unlink($!name);
    }

#`(
#-From /usr/include/mqueue.h:63
#/* Register notification issued upon message arrival to an empty
#   message queue MQDES.  */
#extern int mq_notify (mqd_t __mqdes, const struct sigevent *__notification)
sub mq_notify(mqd_t                         $__mqdes # Typedef<mqd_t>->|int|
             ,sigevent                      $__notification # const sigevent*
              ) is native(LIB) returns int32 is export { * }
)

#-From /usr/include/mqueue.h:68
#/* Receive the oldest from highest priority messages in message queue
#   MQDES.  */
#extern ssize_t mq_receive (mqd_t __mqdes, char *__msg_ptr, size_t __msg_len,

    sub mq_receive(mqd_t $mqdes, Str $msg_ptr, size_t $msg_len, Pointer[uint32] $msg_prio) is native(LIB) returns ssize_t { * }

#-From /usr/include/mqueue.h:72
#/* Add message pointed by MSG_PTR to message queue MQDES.  */
#extern int mq_send (mqd_t __mqdes, const char *__msg_ptr, size_t __msg_len,

    sub mq_send(mqd_t $mqdes, Str $msg_ptr, size_t  $msg_len, uint32 $msg_prio ) is native(LIB) returns int32  { * }

}

# vim: expandtab shiftwidth=4 ft=perl6
