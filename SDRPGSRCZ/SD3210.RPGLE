     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD check success of FTP operation')              *
/*OVR *  OVRDBF INPUT  SDFTTIPD                                       *
/*OVR *  OVRDBF OUTPUT SDFTTOPD                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD3210 - Check success of FTP operation                      *
      *                                                               *
      *  Function:  This program reads the script file just           *
      *             processed by FTP and checks for the success of    *
      *             each operation.                                   *
      *                                                               *
      *  Called By: SDC3200 - FTP automated transmission              *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053437  *CREATE  Date 07Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053437 - CGL013 FTP exit program                           *
      *                                                               *
      *****************************************************************
      /EJECT
     FINPUT     IF   E             DISK    INFSR(SRFILE)
     FOUTPUT    IF   E             DISK    INFSR(SRFILE)

     D TABCMD          S             10    DIM(8) CTDATA PERRCD(1)
     D TABRTC          S             30    DIM(8) ALT(TABCMD)
      ** Table of FTP command v expected return code(s)

     D W@CODES         S              3    DIM(10)
      ** Return codes for procesing

     D                 DS
     D SIFTPO                  1    256
     D W@CODE                  1      3
      ** Extract FTP return code from FTP output record

     DRUNDAT         E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date

     DW@FTOUT          S                   LIKE(SIFTPO)
      ** Define work field for comparison with FTP output file

      /SPACE 2
     DN@001            S             80    INZ('user missing or invalid')
     DN@002            S             80    INZ('user or password invalid')
     DN@003            S             80    INZ('operation not performed')
     DN@004            S             80    INZ('unexpected return code(s)')
     DN@005            S             11    INZ('No response')

     D CSC053          S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WBypass         S              1A

     D RtnCde          S              7A
     D SValK1          S             20A
     D SVal1           S            200A
     D SValK2          S             20A
     D SVal2           S            200A
     D SValK3          S             20A
     D SVal3           S            200A
     D SValK4          S             20A
     D SVal4           S            200A
     D SValK5          S             20A
     D SVal5           S            200A
     D SValK6          S             20A
     D SVal6           S            200A
     D SValK7          S             20A
     D SVal7           S            200A
     D SValK8          S             20A
     D SVal8           S            200A
     D SValK9          S             20A
     D SVal9           S            200A
     D SValK0          S             20A
     D SVal10          S            200A

     D FTPSec          S              1A

      /SPACE 2
      /COPY MSCPYSRC,SRERRD
      /EJECT

      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  SR_INIT       : Initialise program                           *
      *  SR_LOGIN      : Check login                                  *
      *  SR_CHECK      : Check success of all FTP subcommands         *
      *                                                               *
      *****************************************************************

      ** Output parameter: o@opr => operation in error
      **                   o@err => error code
     C     *ENTRY        PLIST
     C                   PARM                    o@opr            80
     C                   PARM                    o@err            80

      ** Initialise program
     C                   EXSR      SR_INIT

      ** Check connection OK
     C                   EXSR      SR_CONN

      ** If connection OK check other operations
     C     O@OPR         IFEQ      *BLANK

      ** Check login OK
     C                   EXSR      SR_LOGIN

      ** If login OK check other operations
     C     o@opr         IFEQ      *BLANK
     C                   EXSR      SR_CHECK
     C                   ENDIF

     C                   ENDIF

      ** Terminate
     C                   MOVE      *ON           *INLR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_CONN        : Check connection to FTP server OK                 *
      * --------                                                           *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_CONN       BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_CONN'     @STK(Q)

      ** Look for 'No response received from FTP server.'
     C                   READ      OUTPUT                                 50
     C                   MOVEL     SIFTPO        WRK11            11
     C     *IN50         DOWEQ     *OFF
     C     WRK11         ANDNE     N@005
     C                   READ      OUTPUT                                 50
     C                   MOVEL     SIFTPO        WRK11
     C                   ENDDO

      ** If not found, connection was OK
     C     *IN50         IFEQ      *ON
     C     1             SETLL     OUTPUT
     C                   ELSE
     C                   MOVEL(P)  '*NORESP'     O@OPR
     C                   ENDIF

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_LOGIN       : Check login OK                                    *
      * --------                                                           *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_LOGIN      BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_LOGIN'    @STK(Q)

      ** Look for '331 Password required...'
     C                   READ      OUTPUT                                 50
     C     *IN50         DOWEQ     *OFF
     C     w@code        ANDNE     '331'
     C                   READ      OUTPUT                                 50
     C                   ENDDO

      ** If not found login error occurred: report and exit
     C     *IN50         IFEQ      *ON
     C                   MOVEL(P)  'login'       o@opr
     C                   MOVEL(P)  N@001         o@err
     C                   ELSE

      ** Check next message is '230 User <user> logged in'
     C                   READ      OUTPUT                                 50
     C     *IN50         IFEQ      *ON
     C     w@code        ORNE      '230'
     C                   MOVEL(P)  'login'       o@opr
     C                   MOVEL(p)  N@002         o@err
     C                   ENDIF
     C                   ENDIF

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_CHECK       : Check success of all FTP subcommands              *
      * --------                                                           *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_CHECK      BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_CHECK'    @STK(Q)

      ** Read input file once to skip login details
     C     w@tst3        DOWNE     'TYP'
     C     w@tst3        ANDNE     'CD '
     C                   READ      INPUT                                  55
     C                   MOVEL     SIFTPI        w@tst3            3
     C                   ENDDO

      ** Read input file for FTP subcommands until EoF or error found
     C     *IN55         DOWEQ     *OFF
     C     *IN50         ANDEQ     *OFF
     C     o@err         ANDEQ     *BLANKS

      ** Add output prefix and locate subcommand on output file
     C     w@opfx        CAT       SIFTPI:1      w@ftout
     C                   READ      OUTPUT                                 50
     C     *IN50         DOWEQ     *OFF
     C     w@ftout       ANDNE     SIFTPO
     C                   READ      OUTPUT                                 50
     C                   ENDDO

      ** If subcommand not found on output file setup error and terminate
     C     *IN50         IFEQ      '1'
     C                   MOVEL(P)  SIFTPI        o@opr
     C                   MOVEL(P)  n@003         o@err
     C                   LEAVE
     C                   ENDIF

      ** Check return code(s) for subcommand against arrays (if recognised)
     C     ' '           SCAN      SIFTPI        w@end             5 0
     C     w@end         SUBST(P)  SIFTPI:1      w@subcmd         10
     C     w@subcmd      LOOKUP    TABCMD        TABRTC                   60

     C     *IN60         IFEQ      '1'
     C                   MOVEA     TABRTC        w@codes
     C                   Z-ADD     1             P                 5 0
     C     w@codes(P)    DOWNE     *BLANK
     C     o@err         ANDEQ     *BLANKS
     C     *IN50         ANDEQ     '0'
     C                   READ      OUTPUT                                 50
     C     *IN50         IFEQ      '0'
     C     3             SUBST     SIFTPO        w@outcd           3

      ** Using Secure FTP, the log embeds information message "Connection is secure"
      ** between return codes 125 (Connection already open) and 226 (Transfer Complete)
      ** Bypass this info to avoid pgm issuing 'unexpected return code'.

     C                   MOVEL     'N'           WBypass
     C                   TESTN                   w@outcd              56
     C     CSC053        IFEQ      'Y'
     C     FTPSec        ANDEQ     'Y'
     C     *IN56         ANDNE     *ON
     C                   MOVEL     'Y'           WBypass
     C                   ENDIF

     C     w@outcd       IFNE      w@codes(P)
     C     WBypass       ANDNE     'Y'

     C                   MOVEL(P)  w@subcmd      o@opr
     C                   MOVEL(P)  N@004         o@err
     C                   ENDIF
     C                   ENDIF

      ** Do not increment array index if log record bypassed due to
      ** information message read from log.
     C     WBypass       IFNE      'Y'

     C                   ADD       1             P

     C                   ENDIF

     C                   ENDDO
     C                   ENDIF

      ** Read next FTP subcommand record
     C                   READ      INPUT                                  55
     C                   ENDDO

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_INIT        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_INIT       BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_INIT'     @STK(Q)

      ** Initialise output parameters
     C                   CLEAR                   o@opr
     C                   CLEAR                   o@err

      ** Set prefix for FTP echo output ('>' for current versions of OS/400)
     C                   MOVEL(P)  '>'           w@opfx            5

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q

      ***  Determine if CSC053 (FTP Secure Connection to SWIFT and CM)
      ***  feature is installed

     C                   MOVE      'N'           CSC053
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC053'      PSard

     C     PRtcd         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC053
     C                   ENDIF

     C     CSC053        IFEQ      'Y'
     C                   CLEAR                   SValK1
     C                   CLEAR                   SValK2
     C                   CLEAR                   SValK3
     C                   CLEAR                   SValK4
     C                   CLEAR                   SValK5
     C                   CLEAR                   SValK6
     C                   CLEAR                   SValK7
     C                   CLEAR                   SValK8
     C                   CLEAR                   SValK9
     C                   CLEAR                   SValK0

      ** Initialise the first system value key

     C                   EVAL      SValK1 = 'UseFTPSecureSWIFT'

      ** Retrieve the system value

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RtnCde
     C                   PARM                    SValK1
     C                   PARM                    SVal1
     C                   PARM                    SValK2
     C                   PARM                    SVal2
     C                   PARM                    SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10

      ** If the system value is not found then issue a database error

     C     RtnCde        IFNE      '       '
     C     SVal1         IFEQ      '*NRF'
     C                   EVAL      DBKEY  =  SValK1
     C                   ENDIF
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  1
     C                   EVAL      DBFILE =  'SDSVALPD'
     C                   EVAL      DBPGM  =  'SD3210'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     SVal1         FTPSec
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR

      ********************************************************************
      /COPY MSCPYSRC,SRERRC
      *
      ** Array TABRTC for LS change from 227 to 229.
      *
** tabcmd / tabrtc
CD        250
GET       229150226
PUT       229150226
REN       350250
DEL       250
TYPE      200
LS        229
QUIT      221
