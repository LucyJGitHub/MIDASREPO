     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS check success of FTP operation')              *
/*OVR *  OVRDBF INPUT  MSFTTIPD                                       *
/*OVR *  OVRDBF OUTPUT MSFTTOPD                                       *
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS3210 - Check success of FTP operation                      *
      *                                                               *
      *  Function:  This program reads the script file just           *
      *             processed by FTP and checks for the success of    *
      *             each operation.                                   *
      *                                                               *
      *  Called By: MSC3200 - Alliance automated transmission         *
      *             MSC3250 - Alliance automated receive              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD051817           Date 20Aug18               *
      *                 CSC053             Date 20Aug18               *
      *                 AR1033033          Date 20Aug18               *
      *                 MD046248           Date 27Oct17               *
      *                 CPK030             Date 14Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257515             Date 11Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW027             Date 21May2002             *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 165212             Date 30Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147256             Date 16Nov98               *
      *                 CSW009 *CREATE     Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD051817 - Unexpected return code is sent to MOPERQ by       *
      *             interface job MS_A2M_AFT                          *
      *  CSC053 - FTP Secure Connections for SWIFT and CM             *
      *         - Added the use of system value UseFTPSecureSWIFT     *
      *  AR1033033 - Job MS_M2A_AFT requires amendment for FTPS.      *
      *              Fix for CSC053 (Secure FTP connection for        *
      *              SWIFT and Correspondence Manager)                *
      *              (Child: AR1033034)                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK030 - Clean up of deliverable data library.               *
      *  257515 - Swift message can't be found in swift alliance.     *
      *  CSW027 - Midas message manager AFT interface                 *
      *  165212 - partially reverse 147256 and correct MSAFT3PD       *
      *  147256 - externalise FTP return codes                        *
      *  CSW009 - Midas-SWIFT Alliance Automated File Transfer        *
      *                                                               *
      *****************************************************************
      /EJECT
     FINPUT     IF   E             disk    infsr(srfile)
     FOUTPUT    IF   E             disk    infsr(srfile)
     F***MSAFT1PD* ITF   80        disk                                                147256 CPK030
     F***MSAFT2PD* ITF  240        disk                                                147256 CPK030
      /EJECT
     D*cpy@*****       S             80    dim(1) ctdata perrcd(1)                            CPK030
      ** Array containing Copyright statement
      *
     D*tabcmd****      S             10    dim(8) ctdata perrcd(1)                            147256
     D*tabrtc****      S             30    dim(8) alt(tabcmd)                                 147256
     D*cmd******       S             10    dim(8) perrcd(8)                            147256 CPK030
     D**********                           fromfile(msaft1pd)                          147256 CPK030
     D*rtc******       S             30    dim(8) perrcd(8)                            147256 CPK030
     D**********                           fromfile(msaft2pd)                          147256 CPK030
     D tabcmd          S             10    dim(8) ctdata perrcd(1)                            CPK030
     D tabrtc          S             30    dim(8) alt(tabcmd)                                 CPK030
      ** Table of FTP command v expected return code(s)
      *
     D w@codes         S              3    dim(10)
      ** Return codes for procesing
      *
     D                 DS
     D*SIFTPO***               1    128                                                       CSD101
     D SIFTPO                  1    256                                                       CSD101
     D w@code                  1      3
      ** Extract FTP return code from FTP output record
      *
     Drundat         E DS                  extname(RUNDAT)
      ** Data Area for run-date
      *
     Dw@ftout          S                   like(SIFTPO)
      ** Define work field for comparison with FTP output file
      *
      /SPACE 2
     Dn@001            S             80    inz('user missing or invalid')
     Dn@002            S             80    inz('user or password invalid')
     Dn@003            S             80    inz('operation not performed')
     Dn@004            S             80    inz('unexpected return code(s)')
     Dn@005            S             11    inz('No response')                                 257515
      *                                                                                    AR1033033
     D CSC053          S              1A                                                   AR1033033
     D PRtcd           S              7A                                                   AR1033033
     D POptn           S              7A                                                   AR1033033
     D PSard           S              6A                                                   AR1033033
     D WBypass         S              1A                                                   AR1033033
      *                                                                                       CSC053
     D RtnCde          S              7A                                                      CSC053
     D SValK1          S             20A                                                      CSC053
     D SVal1           S            200A                                                      CSC053
     D SValK2          S             20A                                                      CSC053
     D SVal2           S            200A                                                      CSC053
     D SValK3          S             20A                                                      CSC053
     D SVal3           S            200A                                                      CSC053
     D SValK4          S             20A                                                      CSC053
     D SVal4           S            200A                                                      CSC053
     D SValK5          S             20A                                                      CSC053
     D SVal5           S            200A                                                      CSC053
     D SValK6          S             20A                                                      CSC053
     D SVal6           S            200A                                                      CSC053
     D SValK7          S             20A                                                      CSC053
     D SVal7           S            200A                                                      CSC053
     D SValK8          S             20A                                                      CSC053
     D SVal8           S            200A                                                      CSC053
     D SValK9          S             20A                                                      CSC053
     D SVal9           S            200A                                                      CSC053
     D SValK0          S             20A                                                      CSC053
     D SVal10          S            200A                                                      CSC053
      ** Parameters for AOSVALR0                                                              CSC053
      *                                                                                       CSC053
     D FTPSec          S              1A                                                      CSC053
      ** Other work Variables                                                                 CSC053
      *                                                                                       CSC053
      /SPACE 2
      /COPY MSCPYSRC,SRERRD
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_login      : Check login                                  *
      *  sr_check      : Check success of all FTP subcommands         *
      *                                                               *
      *****************************************************************
      *
      ** Output parameter: o@opr => operation in error
      **                   o@err => error code
     C     *entry        plist
     C                   parm                    o@opr            80
     C                   parm                    o@err            80
      *
      ***Set*up*copyright*parameter*                                                          CPK030
     C**********         movea     cpy@          cpy2@            80                          CPK030
      *
      ** Initialise program
     C                   exsr      sr_init
      *                                                                                       257515
      ** Check connection OK                                                                  257515
     C                   EXSR      SR_CONN                                                    257515
      *                                                                                       257515
      ** If connection OK check other operations                                              257515
     C     O@OPR         IFEQ      *BLANK                                                     257515
      *
      ** Check login OK
     C                   exsr      sr_login
      *
      ** If login OK check other operations
     C     o@opr         ifeq      *blank
     C                   exsr      sr_check
     C                   endif
      *                                                                                       257515
     C                   ENDIF                                                                257515
      *
      ** Terminate
     C                   move      *on           *inlr
      /EJECT                                                                                  257515
      **********************************************************************                  257515
      * SR_CONN        : Check connection to FTP server OK                 *                  257515
      * --------                                                           *                  257515
      *                                                                    *                  257515
      * Called by      : Mainline                                          *                  257515
      *                                                                    *                  257515
      * Calls          : -                                                 *                  257515
      *                                                                    *                  257515
      **********************************************************************                  257515
      *                                                                                       257515
     C     SR_CONN       BEGSR                                                                257515
      *                                                                                       257515
      ** Push subroutine                                                                      257515
     C                   ADD       1             Q                                            257515
     C                   MOVEL     'SR_CONN'     @STK(Q)                                      257515
      *                                                                                       257515
      ** Look for 'No response received from FTP server.'                                     257515
     C                   READ      OUTPUT                                 50                  257515
     C                   MOVEL     SIFTPO        WRK11            11                          257515
     C     *IN50         DOWEQ     *OFF                                                       257515
     C     WRK11         ANDNE     N@005                                                      257515
     C                   READ      OUTPUT                                 50                  257515
     C                   MOVEL     SIFTPO        WRK11                                        257515
     C                   ENDDO                                                                257515
      *                                                                                       257515
      ** If not found, connection was OK                                                      257515
     C     *IN50         IFEQ      *ON                                                        257515
     C     1             SETLL     OUTPUT                                                     257515
     C                   ELSE                                                                 257515
     C                   MOVEL(P)  '*NORESP'     O@OPR                                        257515
     C                   ENDIF                                                                257515
      *                                                                                       257515
      ** Pop subroutine                                                                       257515
     C                   CLEAR                   @STK(Q)                                      257515
     C                   SUB       1             Q                                            257515
     C                   ENDSR                                                                257515
      /EJECT
      **********************************************************************
      * sr_login       : Check login OK                                    *
      * --------                                                           *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_login      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_login'    @STK(Q)
      *
      ** Look for '331 Password required...'
     C                   read      output                                 50
     C     *in50         doweq     *off
     C     w@code        andne     '331'
     C                   read      output                                 50
     C                   enddo
      *
      ** If not found login error occurred: report and exit
     C     *in50         ifeq      *on
     C                   movel(p)  'login'       o@opr
     C                   movel(p)  n@001         o@err
     C                   else
      *
      ** Check next message is '230 User <user> logged in'
     C                   read      output                                 50
     C     *in50         ifeq      *on
     C     w@code        orne      '230'
     C                   movel(p)  'login'       o@opr
     C                   movel(p)  n@002         o@err
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_check       : Check success of all FTP subcommands              *
      * --------                                                           *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_check      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_check'    @STK(Q)
      *
      ** Read input file once to skip login details
     C     w@tst3        downe     'TYP'                                                      CSW027
     C     w@tst3        andne     'CD '                                                      CSW027
     C                   read      input                                  55
     C                   movel     SIFTPI        w@tst3            3                          CSW027
     C                   end                                                                  CSW027
      *
      ** Read input file for FTP subcommands until EoF or error found
     C**********         read      input                                  55                  CSW027
     C     *in55         doweq     *off
     C     *in50         andeq     *off
     C     o@err         andeq     *blanks
      *
      ** Add output prefix and locate subcommand on output file
     C     w@opfx        cat       SIFTPI:1      w@ftout
     C                   read      output                                 50
     C     *in50         doweq     *off
     C     w@ftout       andne     SIFTPO
     C                   read      output                                 50
     C                   enddo
      *
      ** If subcommand not found on output file setup error and terminate
     C     *in50         ifeq      '1'
     C                   movel(p)  SIFTPI        o@opr
     C                   movel(p)  n@003         o@err
     C                   leave
     C                   endif
      *
      ** Check return code(s) for subcommand against arrays (if recognised)
     C     ' '           scan      SIFTPI        w@end             5 0
     C     w@end         subst(p)  SIFTPI:1      w@subcmd         10
     C*****w@subcmd      lookup    tabcmd        tabrtc                   60                  147256
     C*****              z-add     0             x                 1 0                  147256165212
     C**********         z-add     1             x                 1 0                 165212 CPK030
     C*****w@subcmd      lookup    cmd(x)                                 60           147256 CPK030
     C     w@subcmd      lookup    tabcmd        tabrtc                   60                  CPK030
      *
     C     *in60         ifeq      '1'
     C***********        movea     tabrtc        w@codes                                      147256
     C**********         movea     rtc(x)        w@codes                               147256 CPK030
     C                   movea     tabrtc        w@codes                                      CPK030
     C                   z-add     1             p                 5 0
     C     w@codes(p)    downe     *blank
     C     o@err         andeq     *blanks
     C     *in50         andeq     '0'
     C                   read      output                                 50
     C     *in50         ifeq      '0'
     C     3             subst     SIFTPO        w@outcd           3
      *                                                                                    AR1033033
      ** Using Secure FTP, the log embeds information message "Connection is secure"       AR1033033
      ** between return codes 125 (Connection already open) and 226 (Transfer Complete)    AR1033033
      ** Bypass this info to avoid pgm issuing 'unexpected return code'.                   AR1033033
      *                                                                                    AR1033033
     C                   movel     'N'           WBypass                                   AR1033033
     C                   testn                   w@outcd              56                   AR1033033
     C     CSC053        ifeq      'Y'                                                     AR1033033
     C     FTPSec        andeq     'Y'                                                        CSC053
     C     *IN56         andne     *ON                                                     AR1033033
     C                   movel     'Y'           WBypass                                   AR1033033
     C                   endif                                                             AR1033033
      *                                                                                    AR1033033
     C     w@outcd       ifne      w@codes(p)
      *                                                                                    AR1033033
     C     WBypass       andne     'Y'                                                     AR1033033
      *                                                                                    AR1033033
     C                   movel(p)  w@subcmd      o@opr
     C                   movel(p)  n@004         o@err
     C                   endif
     C                   endif
      *                                                                                    AR1033033
      ** Do not increment array index if log record bypassed due to                        AR1033033
      ** information message read from log.                                                AR1033033
     C     WBypass       ifne      'Y'                                                     AR1033033
      *                                                                                    AR1033033
     C                   add       1             p
      *                                                                                    AR1033033
     C                   endif                                                             AR1033033
      *                                                                                    AR1033033
     C                   enddo
     C                   endif
      *
      ** Read next FTP subcommand record
     C                   read      input                                  55
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Initialise output parameters
     C                   clear                   o@opr
     C                   clear                   o@err
      *
      ** Set prefix for FTP echo output ('>' for current versions of OS/400)
     C                   movel(p)  '>'           w@opfx            5
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *                                                                                    AR1033033
      ***  Determine if CSC053 (FTP Secure Connection to SWIFT and CM)                     AR1033033
      ***  feature is installed                                                            AR1033033
      *                                                                                    AR1033033
     C                   Move      'N'           CSC053                                    AR1033033
     C                   Call      'AOSARDR0'                                              AR1033033
     C                   Parm      *BLANKS       PRtcd                                     AR1033033
     C                   Parm      '*VERIFY'     POptn                                     AR1033033
     C                   Parm      'CSC053'      PSard                                     AR1033033
      *                                                                                    AR1033033
     C     PRtcd         Ifeq      *BLANKS                                                 AR1033033
     C                   Move      'Y'           CSC053                                    AR1033033
     C                   Endif                                                             AR1033033
      *                                                                                    AR1033033
     C     CSC053        IFEQ      'Y'                                                        CSC053
     C                   CLEAR                   SValK1                                       CSC053
     C                   CLEAR                   SValK2                                       CSC053
     C                   CLEAR                   SValK3                                       CSC053
     C                   CLEAR                   SValK4                                       CSC053
     C                   CLEAR                   SValK5                                       CSC053
     C                   CLEAR                   SValK6                                       CSC053
     C                   CLEAR                   SValK7                                       CSC053
     C                   CLEAR                   SValK8                                       CSC053
     C                   CLEAR                   SValK9                                       CSC053
     C                   CLEAR                   SValK0                                       CSC053
                                                                                              CSC053
      ** Initialise the first system value key                                                CSC053
                                                                                              CSC053
     C                   EVAL      SValK1 = 'UseFTPSecureSWIFT'                               CSC053
                                                                                              CSC053
      ** Retrieve the system value                                                            CSC053
                                                                                              CSC053
     C                   CALL      'AOSVALR0'                                                 CSC053
     C                   PARM      *BLANKS       RtnCde                                       CSC053
     C                   PARM                    SValK1                                       CSC053
     C                   PARM                    SVal1                                        CSC053
     C                   PARM                    SValK2                                       CSC053
     C                   PARM                    SVal2                                        CSC053
     C                   PARM                    SValK3                                       CSC053
     C                   PARM                    SVal3                                        CSC053
     C                   PARM                    SValK4                                       CSC053
     C                   PARM                    SVal4                                        CSC053
     C                   PARM                    SValK5                                       CSC053
     C                   PARM                    SVal5                                        CSC053
     C                   PARM                    SValK6                                       CSC053
     C                   PARM                    SVal6                                        CSC053
     C                   PARM                    SValK7                                       CSC053
     C                   PARM                    SVal7                                        CSC053
     C                   PARM                    SValK8                                       CSC053
     C                   PARM                    SVal8                                        CSC053
     C                   PARM                    SValK9                                       CSC053
     C                   PARM                    SVal9                                        CSC053
     C                   PARM                    SValK0                                       CSC053
     C                   PARM                    SVal10                                       CSC053
                                                                                              CSC053
      ** If the system value is not found then issue a database error                         CSC053
                                                                                              CSC053
     C     RtnCde        IFNE      '       '                                                  CSC053
     C     SVal1         IFEQ      '*NRF'                                                     CSC053
     C                   EVAL      DBKEY  =  SValK1                                           CSC053
     C                   ENDIF                                                                CSC053
     C     *LOCK         IN        LDA                                                        CSC053
     C                   EVAL      DBASE  =  024                                              CSC053
     C                   EVAL      DBFILE =  'SDSVALPD'                                       CSC053
     C                   EVAL      DBPGM  =  'MS3250'                                         CSC053
     C                   OUT       LDA                                                        CSC053
     C                   EXSR      *PSSR                                                      CSC053
     C                   ELSE                                                                 CSC053
     C                   MOVEL     SVal1         FTPSec                                       CSC053
     C                   ENDIF                                                                CSC053
     C                   ENDIF                                                                CSC053
     C                   endsr
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
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
      /COPY MSCPYSRC,SRERRC
      *                                                                                     MD051817
      ** Array TABRTC for LS change from 227 to 229.                                        MD051817
      *                                                                                     MD051817
** tabcmd / tabrtc
CD        250
GET       229150226
PUT       229150226
REN       350250
DEL       250
TYPE      200
LS        229
QUIT      221
