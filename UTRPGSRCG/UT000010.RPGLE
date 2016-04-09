     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas UT Create FTP commands')
/*XBI1*  CRTSRCPF FILE(QTEMP/FTPCOMMAND) RCDLEN(212) MBR(INPUT)       *
/*XBI2*  OVRDBF INPUT FTPCOMMAND INPUT                                *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000010 - Send objects via FTP                              *
      *                                                               *
      *  Function:  This module creates the FTP commands to send      *
      *             and optionally restore objects.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK022             Date 06Jul05               *
      *  Prev Amend No. CUP096  *CREATE    Date 17Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK022 - Should not use zone /COPYs.                         *
      *  CUP096 - New Utility                                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Output file for FTP commands
     FINPUT     O    E             DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D*COPY*ZACPYSRC,STD_D_SPEC*                                                              CPK022
     D/COPY GPCPYSRCG,STD_D_SPEC                                                              CPK022
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ***The*following*/COPY*includes*the*MM*standard*declares:                               CPK022
     D*COPY*ZACPYSRC,STDDECLARE*                                                              CPK022
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D*COPY*ZACPYSRC,PSDS*                                                                    CPK022
     D/COPY GPCPYSRCG,PSDS                                                                    CPK022
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ***The*following*/COPY*line*includes*all*the*definitions*of*the*error**                 CPK022
      ***arrays,*including*the*named*constant*giving*the*size*of*************                 CPK022
      ***the*arrays.**Note*that*it*uses*#MsgID*and**MsgData,*and*so*requires*                 CPK022
      ***STD_D_SPEC.*********************************************************                 CPK022
     D*COPY*ZACPYSRC,ERR_ARRAYS*                                                              CPK022
      **------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Parameters
     D RemoteUser      S             10A
     D Password        S             10A
     D ToFile          S             10A
     D ToLib           S             10A
     D Restore         S              4A
     D FLib            S             10A
     D RstLib          S             10A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * First set up the user and password
     C                   Eval      SRCDTA = RemoteUser + ' ' +
     C                             Password
     C                   Write     FTPCommand
 
      * Set binary representation
     C                   Eval      SRCDTA = 'BIN'
     C                   Write     FTPCommand
 
      * Set naming convention
     C                   Eval      SRCDTA = 'NA 1'
     C                   Write     FTPCommand
 
     C                   Eval      SRCDTA = 'PUT ' + '/qsys.lib/Qtemp.lib/+
     C                             FTPOBJ.savf /qsys.lib/' + %Trim(ToLib) +
     C                              '.lib/' + %Trim(ToFile) + '.savf'
     C                   Write     FTPCommand
      *
      * If restore requested set command to restore objects
     C                   If        Restore = '*YES'
     C                   If        RstLib = '*SAVLIB'
     C                   Eval      RstLib = Flib
     C                   EndIf
 
      * Make sure the library exists
     C                   Eval      SRCDTA = 'QUO RCMD CRTLIB '+ RstLib
     C                   Write     FTPCommand
      *
     C                   Eval      SRCDTA = 'QUO RCMD RSTOBJ *ALL '+%Trim(Flib)+
     C                             ' *SAVF *ALL SAVF(' + %Trim(ToLib) + '/' +
     C                             %Trim(ToFile) + ') RSTLIB(' +%Trim(RstLib) +
     C                             ')'
     C                   Write     FTPCommand
     C                   EndIf
 
      ** Set Quit message
     C                   Eval      SRCDTA = 'QUIT'
     C                   Write     FTPCommand
 
     C                   Eval      *INLR = *On
 
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RemoteUser
     C                   PARM                    Password
     C                   PARM                    ToFile
     C                   PARM                    ToLib
     C                   PARM                    Restore
     C                   PARM                    FLib
     C                   PARM                    RstLib
 
      **------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C*COPY*ZACPYSRC,DBFIELDS*                                                                CPK022
     C/COPY GPCPYSRCG,DBFIELDS                                                                CPK022
      **------------------------------------------------------------------------
 
     C                   EndSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C*COPY*ZACPYSRC,PSSR_ILENE*                                                              CPK022
     C/COPY GPCPYSRCG,PSSR_ILENE                                                              CPK022
      **------------------------------------------------------------------------
     C                   SetOn                                        LR
     C                   Return
 
     C                   EndSR
      ********************************************************************
