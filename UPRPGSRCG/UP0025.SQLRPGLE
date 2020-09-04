     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Report on files with shared format')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0025 - Report on files with shared formats                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CUP042             Date 12Dec14               *
      *  Prev Amend No. CUP041   *REWRITE  Date 24Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP002             Date 15Apr99               *
      *                 CUP001  *CREATE    Date 30Dec98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Restructure of deliverable data files.              *
      *  CUP041 - New utility to remove Switchable Feature data.      *
      *  CUP002 - Make the report more user friendly                  *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
      *****************************************************************
      *
     D PReturnCode     S              1
     D RecCount        S              2  0
     D Action          S              7    INZ('*WRITE')
     D RptPgm          S             10    INZ('UP0025')
     D ErrMessage      S            100
     D Recursive       S              1
      *
     D SFMT          E DS                  EXTNAME(UPSFMTQF)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
      *
      * Insert records into temporary file.
     C/exec SQL
     C+ insert into UPSFMTQF
     C+ (
     C+   SFSRCF
     C+ , SFLIB1
     C+ , SFNAME
     C+ , SFFILE
     C+ , SFLIB2
     C+ , SFMBNM
     C+ )
     C+ select
     C+   c.AUSRCF
     C+ , a.RFLIB
     C+ , a.RFNAME
     C+ , b.RFFILE
     C+ , b.RFLIB
     C+ , c.AUMBNM
     C+ from UPC000038F a
     C+ join UPC000038F b
     C+ on
     C+     a.RFNAME = b.RFNAME
     C+ join UPDLVCPD c
     C+ on
     C+     a.RFFILE = c.AUMBNM
     C+ where
     C+     a.RFFILE <> b.RFFILE
     C+ and a.RFFATR <> 'LF'
     C+ and c.AUMBTP = 'PF'
     C+ and c.AUDTYP <> 'I'
     C/end-exec
      *
     C/exec SQL
     C+ declare ShareFmt cursor for
     C+ select * from UPSFMTQF
     C+ order by
     C+   SFSRCF
     C+ , SFMBNM
     C/end-exec
      *
     C/exec SQL
     C+ open ShareFmt
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ShareFmt
     C+ into :SFMT
     C/end-exec
     C                   DOW       SQLCODE = 0
      *
      ** Check if the file is on the driving file; if it is then ignore.
     C/exec SQL
     C+ select count(*) into :RecCount
     C+ from UPDLVCPD
     C+ where
     C+     AUMBNM = :SFFILE
     C/end-exec
     C                   IF        RecCount = 0
      ** Check if the file is already defined as sharing a format; if it is then
      **  ignore.
     C/exec SQL
     C+ select count(*) into :RecCount
     C**from*UPSFMTPD**                                                                       CUP042
     C+ from UPFMTJW0                                                                         CUP042
     C+ where
     C+     FSFILE = :SFMBNM
     C+ and FSLAYR <> '*CROSS'
     C+ and FSDEL  <> 'Y'                                                                     CUP042
     C/end-exec
     C                   IF        RecCount = 0
     C                   EXSR      WriteWarn
     C                   ENDIF
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from ShareFmt
     C+ into :SFMT
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close ShareFmt
     C/end-exec
      *
      ** If any messages were written then produce report.
     C                   IF        PReturnCode = 'W'
     C                   CALL      'UP008010'
     C                   PARM      '*REPORT'     Action
     C                   PARM                    RptPgm
     C                   PARM                    ErrMessage
     C                   ENDIF
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteWarn - Write warning messages to report                 *
      *                                                               *
      *****************************************************************
     C     WriteWarn     BEGSR
      *
      ** Populate message.
     C                   EVAL      PReturnCode = 'W'
     C                   EVAL      ErrMessage =
     C                             SFSRCF +
     C                             SFLIB1 +
     C                             SFNAME +
     C                             SFFILE +
     C                             SFLIB2 +
     C                             SFMBNM
     C                   CALL      'UP008010'
     C                   PARM                    Action
     C                   PARM                    RptPgm
     C                   PARM                    ErrMessage
      *
     C     WriteWarnE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      PReturnCode = 'E'
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
