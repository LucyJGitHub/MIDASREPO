      /if defined(MRIFSIBMPR_inc)
      /eof
      /else
      /define MRIFSIBMPR_inc
      /endif

      *  This member contains RPGLE prototypes for IBM procedures for using IFS files.
      *  Normally these would be included from an IBM source file but the only
      *  prototypes that seem to be in QSYSINC are for C (or maybe C++) so
      *  RPGLE equivalents are created herein.

      *  This member will ussually only be included by RPGLE programs that contain
      *  wrapper function for the IBM supplied procedures.

      * -------------------------------------------------------------------
      *
      *  --------------
      *  Change History
      *  --------------
      *  Date (ISO)  ID       Who   Description (multiple lines if needed)
      *  ----------  --       ---   ----------------------------------------
      *  2021-12-16  MD058809       After installation of MQ9 compatibility patch and
      *                             restart of the Meridian Replication subsystem
      *                             REPMIDASPT, the job MPT1PBSIN ended in MSGW.
      *
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Values for oflag parameter, used by open()
     D O_APPEND        S             10I 0   inz(256)
     D O_CCSID         S             10I 0   inz(32)
     D O_CODEPAGE      S             10I 0   inz(8388608)
     D O_CREAT         S             10I 0   inz(8)
     D O_EXCL          S             10I 0   inz(16)
     D O_RDONLY        S             10I 0   inz(1)
     D O_RDWR          S             10I 0   inz(4)
     D O_TEXTDATA      S             10I 0   inz(16777216)
     D O_TRUNC         S             10I 0   inz(64)
     D O_WRONLY        S             10I 0   inz(2)

      * -------------------------------------------------------------------
      * User authorities for omode parameter, used by open()
      * from QSYSINC/SYS, member STAT
     D S_IRUSR         S             10I 0   inz(256)
     D S_IWUSR         S             10I 0   inz(128)
     D S_IXUSR         S             10I 0   inz( 64)
     D S_IRWXU         S             10I 0   inz(448)

      * Group authorities
     D S_IRGRP         S             10I 0   inz( 32)
     D S_IWGRP         S             10I 0   inz( 16)
     D S_IXGRP         S             10I 0   inz(  8)
     D S_IRWXG         S             10I 0   inz( 56)

      * Other authorities
     D S_IROTH         S             10I 0   inz(  4)
     D S_IWOTH         S             10I 0   inz(  2)
     D S_IXOTH         S             10I 0   inz(  1)
     D S_IRWXO         S             10I 0   inz(  7)

      * -------------------------------------------------------------------
      * Open an IFS file

     D open            PR            10I 0   ExtProc('open')
     D  open_Filename                  *     value
     D  open_OpenFlag                10I 0   value
     D  open_Mode                    10I 0   value options(*nopass)
     D  open_Codepage                10I 0   value options(*nopass)
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Read from an IFS file

     D read            PR            10I 0   ExtProc('read')
     D  read_FileDescriptor...
     D                               10I 0   value
     D  read_DataReturned...
     D                                 *     value
     D  read_BytesToRead...
     D                               10I 0   value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Write to an IFS file starting at a specified offset

     D pwrite          PR            10I 0   ExtProc('pwrite')
     D  pwrite_FileDescriptor...
     D                               10I 0   value
     D  pwrite_DataToWrite...
     D                                 *     value
     D  pwrite_BytesToWrite...
     D                               10I 0   value
     D  pwrite_Offset                10I 0   value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Close

     D close           PR            10I 0   ExtProc('close')
     D  close_FileDescriptor...
     D                               10I 0   value
      * ------------------------c------------------------------------------

      * -------------------------------------------------------------------
      * Get error information

     D getErrorInfo    PR              *     ExtProc('__errno')
      * ------------------------c------------------------------------------

      * -------------------------------------------------------------------
      * Clear an IFS file

     D fclear          PR            10I 0   ExtProc('fclear')
     D  clear_FileDescriptor...
     D                               10I 0   value
     D  clear_BytesToWrite...
     D                               10I 0   value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Write to an IFS file

     D write           PR            10I 0   ExtProc('write')
     D  write_FileDescriptor...
     D                               10I 0   value
     D  write_DataToWrite...
     D                                 *     value
     D  write_BytesToWrite...
     D                               10I 0   value
      * -------------------------------------------------------------------

