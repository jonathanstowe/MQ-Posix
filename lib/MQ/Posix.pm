use v6.*;

use NativeCall;

class MQ::Posix {

    constant __syscall_slong_t = int64;
    constant mqd_t   = int32;
    constant LIB = [ 'rt', v1 ];

    class Attr is repr('CStruct') is export {
        has __syscall_slong_t             $.mq_flags; # Typedef<__syscall_slong_t>->|long int| mq_flags
        has __syscall_slong_t             $.mq_maxmsg; # Typedef<__syscall_slong_t>->|long int| mq_maxmsg
        has __syscall_slong_t             $.mq_msgsize; # Typedef<__syscall_slong_t>->|long int| mq_msgsize
        has __syscall_slong_t             $.mq_curmsgs; # Typedef<__syscall_slong_t>->|long int| mq_curmsgs
        has CArray[__syscall_slong_t]     $.__pad; # Typedef<__syscall_slong_t>->|long int|[4] __pad
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

    sub mq_open(Str $name, int32 $oflag) is native(LIB) returns mqd_t is export { * }

#-From /usr/include/mqueue.h:45
#/* Removes the association between message queue descriptor MQDES and its
#   message queue.  */
#extern int mq_close (mqd_t __mqdes) __THROW;

    sub mq_close(mqd_t $mqdes ) is native(LIB) returns int32 is export { * }

#-From /usr/include/mqueue.h:48
#/* Query status and attributes of message queue MQDES.  */
#extern int mq_getattr (mqd_t __mqdes, struct Attr *__mqstat)

    sub mq_getattr(mqd_t $mqdes, Attr $mqstat ) is native(LIB) returns int32 is export { * }

#-From /usr/include/mqueue.h:53
#/* Set attributes associated with message queue MQDES and if OMQSTAT is
#   not NULL also query its old attributes.  */
#extern int mq_setattr (mqd_t __mqdes,

    sub mq_setattr(mqd_t $mqdes, Attr $mqstat, Attr $omqstat) is native(LIB) returns int32 is export { * }

#-From /usr/include/mqueue.h:59
#/* Remove message queue named NAME.  */
#extern int mq_unlink (const char *__name) __THROW __nonnull ((1));
sub mq_unlink(Str $__name # const char*
              ) is native(LIB) returns int32 is export { * }

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
sub mq_receive(mqd_t                         $__mqdes # Typedef<mqd_t>->|int|
              ,Str                           $__msg_ptr # char*
              ,size_t                        $__msg_len # Typedef<size_t>->|long unsigned int|
              ,Pointer[uint32]               $__msg_prio # unsigned int*
               ) is native(LIB) returns ssize_t is export { * }

#-From /usr/include/mqueue.h:72
#/* Add message pointed by MSG_PTR to message queue MQDES.  */
#extern int mq_send (mqd_t __mqdes, const char *__msg_ptr, size_t __msg_len,
sub mq_send(mqd_t                         $__mqdes # Typedef<mqd_t>->|int|
           ,Str                           $__msg_ptr # const char*
           ,size_t                        $__msg_len # Typedef<size_t>->|long unsigned int|
           ,uint32                        $__msg_prio # unsigned int
            ) is native(LIB) returns int32 is export { * }

}

# vim: expandtab shiftwidth=4 ft=perl6
