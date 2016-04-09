     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
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
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CPK030             Date 14Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 257515             Date 11Nov08               *
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
     D SIFTPO                  1    128
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
     C     w@outcd       ifne      w@codes(p)
     C                   movel(p)  w@subcmd      o@opr
     C                   movel(p)  n@004         o@err
     C                   endif
     C                   endif
     C                   add       1             p
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
** tabcmd / tabrtc
CD        250
GET       229150226
PUT       229150226
REN       350250
DEL       250
TYPE      200
LS        227
QUIT      221
