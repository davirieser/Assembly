
; ---------------------------------------------------------------------------- ;

%if 0

--------------------------------------------------------------------------------
NOTE: Linux Syscalls
https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
Extract all Syscalls from the Syscall Table:
--------------------------------------------------------------------------------

let string = "";
for (let name of document.getElementsByTagName("table")[1].children[1].children) {
    string += "CREATE_SYSCALL " +
                name.children[1].textContent.toUpperCase() + ", " +
                name.children[0].textContent + newline;
}

%endif

; ---------------------------------------------------------------------------- ;

%macro CREATE_SYSCALL 2
    %define SYS_%1 %2
%endmacro

%macro CALL_SYS 1
    mov rax, SYS_%1
    syscall
%endmacro

; ---------------------------------------------------------------------------- ;

CREATE_SYSCALL READ, 0
CREATE_SYSCALL WRITE, 1
CREATE_SYSCALL OPEN, 2
CREATE_SYSCALL CLOSE, 3
CREATE_SYSCALL STAT, 4
CREATE_SYSCALL FSTAT, 5
CREATE_SYSCALL LSTAT, 6
CREATE_SYSCALL POLL, 7
CREATE_SYSCALL LSEEK, 8
CREATE_SYSCALL MMAP, 9
CREATE_SYSCALL MPROTECT, 10
CREATE_SYSCALL MUNMAP, 11
CREATE_SYSCALL BRK, 12
CREATE_SYSCALL RT_SIGACTION, 13
CREATE_SYSCALL RT_SIGPROCMASK, 14
CREATE_SYSCALL RT_SIGRETURN, 15
CREATE_SYSCALL IOCTL, 16
CREATE_SYSCALL PREAD64, 17
CREATE_SYSCALL PWRITE64, 18
CREATE_SYSCALL READV, 19
CREATE_SYSCALL WRITEV, 20
CREATE_SYSCALL ACCESS, 21
CREATE_SYSCALL PIPE, 22
CREATE_SYSCALL SELECT, 23
CREATE_SYSCALL SCHED_YIELD, 24
CREATE_SYSCALL MREMAP, 25
CREATE_SYSCALL MSYNC, 26
CREATE_SYSCALL MINCORE, 27
CREATE_SYSCALL MADVISE, 28
CREATE_SYSCALL SHMGET, 29
CREATE_SYSCALL SHMAT, 30
CREATE_SYSCALL SHMCTL, 31
CREATE_SYSCALL DUP, 32
CREATE_SYSCALL DUP2, 33
CREATE_SYSCALL PAUSE, 34
CREATE_SYSCALL NANOSLEEP, 35
CREATE_SYSCALL GETITIMER, 36
CREATE_SYSCALL ALARM, 37
CREATE_SYSCALL SETITIMER, 38
CREATE_SYSCALL GETPID, 39
CREATE_SYSCALL SENDFILE, 40
CREATE_SYSCALL SOCKET, 41
CREATE_SYSCALL CONNECT, 42
CREATE_SYSCALL ACCEPT, 43
CREATE_SYSCALL SENDTO, 44
CREATE_SYSCALL RECVFROM, 45
CREATE_SYSCALL SENDMSG, 46
CREATE_SYSCALL RECVMSG, 47
CREATE_SYSCALL SHUTDOWN, 48
CREATE_SYSCALL BIND, 49
CREATE_SYSCALL LISTEN, 50
CREATE_SYSCALL GETSOCKNAME, 51
CREATE_SYSCALL GETPEERNAME, 52
CREATE_SYSCALL SOCKETPAIR, 53
CREATE_SYSCALL SETSOCKOPT, 54
CREATE_SYSCALL GETSOCKOPT, 55
CREATE_SYSCALL CLONE, 56
CREATE_SYSCALL FORK, 57
CREATE_SYSCALL VFORK, 58
CREATE_SYSCALL EXECVE, 59
CREATE_SYSCALL EXIT, 60
CREATE_SYSCALL WAIT4, 61
CREATE_SYSCALL KILL, 62
CREATE_SYSCALL UNAME, 63
CREATE_SYSCALL SEMGET, 64
CREATE_SYSCALL SEMOP, 65
CREATE_SYSCALL SEMCTL, 66
CREATE_SYSCALL SHMDT, 67
CREATE_SYSCALL MSGGET, 68
CREATE_SYSCALL MSGSND, 69
CREATE_SYSCALL MSGRCV, 70
CREATE_SYSCALL MSGCTL, 71
CREATE_SYSCALL FCNTL, 72
CREATE_SYSCALL FLOCK, 73
CREATE_SYSCALL FSYNC, 74
CREATE_SYSCALL FDATASYNC, 75
CREATE_SYSCALL TRUNCATE, 76
CREATE_SYSCALL FTRUNCATE, 77
CREATE_SYSCALL GETDENTS, 78
CREATE_SYSCALL GETCWD, 79
CREATE_SYSCALL CHDIR, 80
CREATE_SYSCALL FCHDIR, 81
CREATE_SYSCALL RENAME, 82
CREATE_SYSCALL MKDIR, 83
CREATE_SYSCALL RMDIR, 84
CREATE_SYSCALL CREAT, 85
CREATE_SYSCALL LINK, 86
CREATE_SYSCALL UNLINK, 87
CREATE_SYSCALL SYMLINK, 88
CREATE_SYSCALL READLINK, 89
CREATE_SYSCALL CHMOD, 90
CREATE_SYSCALL FCHMOD, 91
CREATE_SYSCALL CHOWN, 92
CREATE_SYSCALL FCHOWN, 93
CREATE_SYSCALL LCHOWN, 94
CREATE_SYSCALL UMASK, 95
CREATE_SYSCALL GETTIMEOFDAY, 96
CREATE_SYSCALL GETRLIMIT, 97
CREATE_SYSCALL GETRUSAGE, 98
CREATE_SYSCALL SYSINFO, 99
CREATE_SYSCALL TIMES, 100
CREATE_SYSCALL PTRACE, 101
CREATE_SYSCALL GETUID, 102
CREATE_SYSCALL SYSLOG, 103
CREATE_SYSCALL GETGID, 104
CREATE_SYSCALL SETUID, 105
CREATE_SYSCALL SETGID, 106
CREATE_SYSCALL GETEUID, 107
CREATE_SYSCALL GETEGID, 108
CREATE_SYSCALL SETPGID, 109
CREATE_SYSCALL GETPPID, 110
CREATE_SYSCALL GETPGRP, 111
CREATE_SYSCALL SETSID, 112
CREATE_SYSCALL SETREUID, 113
CREATE_SYSCALL SETREGID, 114
CREATE_SYSCALL GETGROUPS, 115
CREATE_SYSCALL SETGROUPS, 116
CREATE_SYSCALL SETRESUID, 117
CREATE_SYSCALL GETRESUID, 118
CREATE_SYSCALL SETRESGID, 119
CREATE_SYSCALL GETRESGID, 120
CREATE_SYSCALL GETPGID, 121
CREATE_SYSCALL SETFSUID, 122
CREATE_SYSCALL SETFSGID, 123
CREATE_SYSCALL GETSID, 124
CREATE_SYSCALL CAPGET, 125
CREATE_SYSCALL CAPSET, 126
CREATE_SYSCALL RT_SIGPENDING, 127
CREATE_SYSCALL RT_SIGTIMEDWAIT, 128
CREATE_SYSCALL RT_SIGQUEUEINFO, 129
CREATE_SYSCALL RT_SIGSUSPEND, 130
CREATE_SYSCALL SIGALTSTACK, 131
CREATE_SYSCALL UTIME, 132
CREATE_SYSCALL MKNOD, 133
CREATE_SYSCALL USELIB, 134
CREATE_SYSCALL PERSONALITY, 135
CREATE_SYSCALL USTAT, 136
CREATE_SYSCALL STATFS, 137
CREATE_SYSCALL FSTATFS, 138
CREATE_SYSCALL SYSFS, 139
CREATE_SYSCALL GETPRIORITY, 140
CREATE_SYSCALL SETPRIORITY, 141
CREATE_SYSCALL SCHED_SETPARAM, 142
CREATE_SYSCALL SCHED_GETPARAM, 143
CREATE_SYSCALL SCHED_SETSCHEDULER, 144
CREATE_SYSCALL SCHED_GETSCHEDULER, 145
CREATE_SYSCALL SCHED_GET_PRIORITY_MAX, 146
CREATE_SYSCALL SCHED_GET_PRIORITY_MIN, 147
CREATE_SYSCALL SCHED_RR_GET_INTERVAL, 148
CREATE_SYSCALL MLOCK, 149
CREATE_SYSCALL MUNLOCK, 150
CREATE_SYSCALL MLOCKALL, 151
CREATE_SYSCALL MUNLOCKALL, 152
CREATE_SYSCALL VHANGUP, 153
CREATE_SYSCALL MODIFY_LDT, 154
CREATE_SYSCALL PIVOT_ROOT, 155
CREATE_SYSCALL _SYSCTL, 156
CREATE_SYSCALL PRCTL, 157
CREATE_SYSCALL ARCH_PRCTL, 158
CREATE_SYSCALL ADJTIMEX, 159
CREATE_SYSCALL SETRLIMIT, 160
CREATE_SYSCALL CHROOT, 161
CREATE_SYSCALL SYNC, 162
CREATE_SYSCALL ACCT, 163
CREATE_SYSCALL SETTIMEOFDAY, 164
CREATE_SYSCALL MOUNT, 165
CREATE_SYSCALL UMOUNT2, 166
CREATE_SYSCALL SWAPON, 167
CREATE_SYSCALL SWAPOFF, 168
CREATE_SYSCALL REBOOT, 169
CREATE_SYSCALL SETHOSTNAME, 170
CREATE_SYSCALL SETDOMAINNAME, 171
CREATE_SYSCALL IOPL, 172
CREATE_SYSCALL IOPERM, 173
CREATE_SYSCALL CREATE_MODULE, 174
CREATE_SYSCALL INIT_MODULE, 175
CREATE_SYSCALL DELETE_MODULE, 176
CREATE_SYSCALL GET_KERNEL_SYMS, 177
CREATE_SYSCALL QUERY_MODULE, 178
CREATE_SYSCALL QUOTACTL, 179
CREATE_SYSCALL NFSSERVCTL, 180
CREATE_SYSCALL GETPMSG, 181
CREATE_SYSCALL PUTPMSG, 182
CREATE_SYSCALL AFS_SYSCALL, 183
CREATE_SYSCALL TUXCALL, 184
CREATE_SYSCALL SECURITY, 185
CREATE_SYSCALL GETTID, 186
CREATE_SYSCALL READAHEAD, 187
CREATE_SYSCALL SETXATTR, 188
CREATE_SYSCALL LSETXATTR, 189
CREATE_SYSCALL FSETXATTR, 190
CREATE_SYSCALL GETXATTR, 191
CREATE_SYSCALL LGETXATTR, 192
CREATE_SYSCALL FGETXATTR, 193
CREATE_SYSCALL LISTXATTR, 194
CREATE_SYSCALL LLISTXATTR, 195
CREATE_SYSCALL FLISTXATTR, 196
CREATE_SYSCALL REMOVEXATTR, 197
CREATE_SYSCALL LREMOVEXATTR, 198
CREATE_SYSCALL FREMOVEXATTR, 199
CREATE_SYSCALL TKILL, 200
CREATE_SYSCALL TIME, 201
CREATE_SYSCALL FUTEX, 202
CREATE_SYSCALL SCHED_SETAFFINITY, 203
CREATE_SYSCALL SCHED_GETAFFINITY, 204
CREATE_SYSCALL SET_THREAD_AREA, 205
CREATE_SYSCALL IO_SETUP, 206
CREATE_SYSCALL IO_DESTROY, 207
CREATE_SYSCALL IO_GETEVENTS, 208
CREATE_SYSCALL IO_SUBMIT, 209
CREATE_SYSCALL IO_CANCEL, 210
CREATE_SYSCALL GET_THREAD_AREA, 211
CREATE_SYSCALL LOOKUP_DCOOKIE, 212
CREATE_SYSCALL EPOLL_CREATE, 213
CREATE_SYSCALL EPOLL_CTL_OLD, 214
CREATE_SYSCALL EPOLL_WAIT_OLD, 215
CREATE_SYSCALL REMAP_FILE_PAGES, 216
CREATE_SYSCALL GETDENTS64, 217
CREATE_SYSCALL SET_TID_ADDRESS, 218
CREATE_SYSCALL RESTART_SYSCALL, 219
CREATE_SYSCALL SEMTIMEDOP, 220
CREATE_SYSCALL FADVISE64, 221
CREATE_SYSCALL TIMER_CREATE, 222
CREATE_SYSCALL TIMER_SETTIME, 223
CREATE_SYSCALL TIMER_GETTIME, 224
CREATE_SYSCALL TIMER_GETOVERRUN, 225
CREATE_SYSCALL TIMER_DELETE, 226
CREATE_SYSCALL CLOCK_SETTIME, 227
CREATE_SYSCALL CLOCK_GETTIME, 228
CREATE_SYSCALL CLOCK_GETRES, 229
CREATE_SYSCALL CLOCK_NANOSLEEP, 230
CREATE_SYSCALL EXIT_GROUP, 231
CREATE_SYSCALL EPOLL_WAIT, 232
CREATE_SYSCALL EPOLL_CTL, 233
CREATE_SYSCALL TGKILL, 234
CREATE_SYSCALL UTIMES, 235
CREATE_SYSCALL VSERVER, 236
CREATE_SYSCALL MBIND, 237
CREATE_SYSCALL SET_MEMPOLICY, 238
CREATE_SYSCALL GET_MEMPOLICY, 239
CREATE_SYSCALL MQ_OPEN, 240
CREATE_SYSCALL MQ_UNLINK, 241
CREATE_SYSCALL MQ_TIMEDSEND, 242
CREATE_SYSCALL MQ_TIMEDRECEIVE, 243
CREATE_SYSCALL MQ_NOTIFY, 244
CREATE_SYSCALL MQ_GETSETATTR, 245
CREATE_SYSCALL KEXEC_LOAD, 246
CREATE_SYSCALL WAITID, 247
CREATE_SYSCALL ADD_KEY, 248
CREATE_SYSCALL REQUEST_KEY, 249
CREATE_SYSCALL KEYCTL, 250
CREATE_SYSCALL IOPRIO_SET, 251
CREATE_SYSCALL IOPRIO_GET, 252
CREATE_SYSCALL INOTIFY_INIT, 253
CREATE_SYSCALL INOTIFY_ADD_WATCH, 254
CREATE_SYSCALL INOTIFY_RM_WATCH, 255
CREATE_SYSCALL MIGRATE_PAGES, 256
CREATE_SYSCALL OPENAT, 257
CREATE_SYSCALL MKDIRAT, 258
CREATE_SYSCALL MKNODAT, 259
CREATE_SYSCALL FCHOWNAT, 260
CREATE_SYSCALL FUTIMESAT, 261
CREATE_SYSCALL NEWFSTATAT, 262
CREATE_SYSCALL UNLINKAT, 263
CREATE_SYSCALL RENAMEAT, 264
CREATE_SYSCALL LINKAT, 265
CREATE_SYSCALL SYMLINKAT, 266
CREATE_SYSCALL READLINKAT, 267
CREATE_SYSCALL FCHMODAT, 268
CREATE_SYSCALL FACCESSAT, 269
CREATE_SYSCALL PSELECT6, 270
CREATE_SYSCALL PPOLL, 271
CREATE_SYSCALL UNSHARE, 272
CREATE_SYSCALL SET_ROBUST_LIST, 273
CREATE_SYSCALL GET_ROBUST_LIST, 274
CREATE_SYSCALL SPLICE, 275
CREATE_SYSCALL TEE, 276
CREATE_SYSCALL SYNC_FILE_RANGE, 277
CREATE_SYSCALL VMSPLICE, 278
CREATE_SYSCALL MOVE_PAGES, 279
CREATE_SYSCALL UTIMENSAT, 280
CREATE_SYSCALL EPOLL_PWAIT, 281
CREATE_SYSCALL SIGNALFD, 282
CREATE_SYSCALL TIMERFD_CREATE, 283
CREATE_SYSCALL EVENTFD, 284
CREATE_SYSCALL FALLOCATE, 285
CREATE_SYSCALL TIMERFD_SETTIME, 286
CREATE_SYSCALL TIMERFD_GETTIME, 287
CREATE_SYSCALL ACCEPT4, 288
CREATE_SYSCALL SIGNALFD4, 289
CREATE_SYSCALL EVENTFD2, 290
CREATE_SYSCALL EPOLL_CREATE1, 291
CREATE_SYSCALL DUP3, 292
CREATE_SYSCALL PIPE2, 293
CREATE_SYSCALL INOTIFY_INIT1, 294
CREATE_SYSCALL PREADV, 295
CREATE_SYSCALL PWRITEV, 296
CREATE_SYSCALL RT_TGSIGQUEUEINFO, 297
CREATE_SYSCALL PERF_EVENT_OPEN, 298
CREATE_SYSCALL RECVMMSG, 299
CREATE_SYSCALL FANOTIFY_INIT, 300
CREATE_SYSCALL FANOTIFY_MARK, 301
CREATE_SYSCALL PRLIMIT64, 302
CREATE_SYSCALL NAME_TO_HANDLE_AT, 303
CREATE_SYSCALL OPEN_BY_HANDLE_AT, 304
CREATE_SYSCALL CLOCK_ADJTIME, 305
CREATE_SYSCALL SYNCFS, 306
CREATE_SYSCALL SENDMMSG, 307
CREATE_SYSCALL SETNS, 308
CREATE_SYSCALL GETCPU, 309
CREATE_SYSCALL PROCESS_VM_READV, 310
CREATE_SYSCALL PROCESS_VM_WRITEV, 311
CREATE_SYSCALL KCMP, 312
CREATE_SYSCALL FINIT_MODULE, 313
CREATE_SYSCALL SCHED_SETATTR, 314
CREATE_SYSCALL SCHED_GETATTR, 315
CREATE_SYSCALL RENAMEAT2, 316
CREATE_SYSCALL SECCOMP, 317
CREATE_SYSCALL GETRANDOM, 318
CREATE_SYSCALL MEMFD_CREATE, 319
CREATE_SYSCALL KEXEC_FILE_LOAD, 320
CREATE_SYSCALL BPF, 321
CREATE_SYSCALL EXECVEAT, 322
CREATE_SYSCALL USERFAULTFD, 323
CREATE_SYSCALL MEMBARRIER, 324
CREATE_SYSCALL MLOCK2, 325
CREATE_SYSCALL COPY_FILE_RANGE, 326
CREATE_SYSCALL PREADV2, 327
CREATE_SYSCALL PWRITEV2, 328
CREATE_SYSCALL PKEY_MPROTECT, 329
CREATE_SYSCALL PKEY_ALLOC, 330
CREATE_SYSCALL PKEY_FREE, 331
CREATE_SYSCALL STATX, 332

; ---------------------------------------------------------------------------- ;
