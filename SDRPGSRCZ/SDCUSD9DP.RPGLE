     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Display - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSD9DP - SD Customers Details Display - LU Window         *
      *                                                               *
      *  Function:  This function displays the Extended Details       *
      *             window screen of the Customers                    *
      *                                                               *
      *  Component of:  SP8SD0006 - Core Luxembourg service program   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  03  -  F3 Pressed exit program                               *
      *  05  -  F5 Pressed redisplay the screen                       *
      *  10  -  F10 Pressed delete                                    *
      *  12  -  F12 Pressed goto previous screen                      *
      *  20  -  Protect fields in enquire mode                        *
      *  30  -  Redisplay the screen                                  *
      *  35  -  Enable F5                                             *
      *  40  -  Enable F10                                            *
      *  50  -  Error on field #6LXPAPS                               *
      *  51  -  Error on field #6LXCGRP                               *
      *  52  -  Error on field #6LXCONS                               *
      *  53  -  Error on field #6LXECOS                               *
      *  54  -  Error on field #6LXNCOS                               *
      *  55  -  Error on field #6LXINRF                               *
      *  56  -  Error on field #6LXPERF                               *
      *  57  -  Error on field #6LXAUTG                               *
      *  58  -  Error on field #6LXPROG                               *
      *  59  -  Error on field #6LXASSP                               *
      *  61  -  Error on field #6LXICCD                               *
      *  62  -  Error on field #6LXMCID                               *
      *  63  -  Error on field #6LXSMRS                               *
      *  70  -  Protect/display field #6LXAUTG, #6LXPROG, #6LXASSP    *
      *  72  -  Protect/display field #6LXICCD, #6LXMCID              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
     FSDCUSDD9DFCF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D @EI             S              1    DIM(13)
 
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)
     D OkFlags       E DS                  EXTNAME(SDECULX2PD)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
      *
      ** Standards Input Parameters
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
      *
      ** Extra Input Parameters
     D ULX008          S              1
     D ULX012          S              1
      *
      ** Standards Output Parameters
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Main processing                                      *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
     C     C             DOUGT     13
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Do while warning messages found write warning messages to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Set screen protect/non-display indicators
      ** Display fields 'Investm. Comany Code' and 'Market Centre Y/N'
      *
     C     ULX008        IFEQ      'Y'
     C                   MOVE      *ON           *IN72
     C                   ELSE
     C                   MOVE      *OFF          *IN72
     C                   ENDIF
      *
      ** Display fields 'Guarantee & Collateral Au.', 'Processing for
      ** Economic Group' and 'Assets Pledged'
      *
     C     ULX012        IFEQ      'Y'
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN71
     C                   ELSE
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN71
     C                   ENDIF
      *
      ** Protect all fields
      *
     C     @EIN20        COMP      'Y'                                    20
      *
      ** Enable functions keys
      *
     C     @EINKE        COMP      'Y'                                    35
     C     @EINKJ        COMP      'Y'                                    40
      *
      ** Write message subfile and window details screen
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     SDCUSDF0
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '000'         *IN(60)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLEAR - Clear message file                                  *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSEND - Send message to program's message queue.             *
      *                                                               *
      *****************************************************************
     C     SRSEND        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Standards Input Parameters
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
     C                   PARM                    @EIN20
      *
      ** Extra Input Parameters
      *
     C                   PARM                    ULX008
     C                   PARM                    ULX012
      *
      ** Standards Output Parameters
      *
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKE
     C                   PARM                    @INKJ
     C                   PARM                    BJMRDT
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSD9DP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVEL     'SDCUSD9DP'   ##PGM
     C                   Eval      ##JOB = PSJobName
     C                   Eval      ##USR = PSUser
      *
      ** Messages file
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
