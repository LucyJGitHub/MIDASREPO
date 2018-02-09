     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV - Display Extension Fields')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SEDPMV3DP - SE Depot Movements Display                       *
      *                                                               *
      *  Function:  This Module displays extension fields.            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  *IN03  -  F3 Pressed exit program                            *
      *  *IN05  -  F5 Pressed redisplay the screen                    *
      *  *IN10  -  F10 Pressed delete                                 *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN30  -  Redisplay the screen                               *
      *  *IN35  -  Enable F5                                          *
      *  *IN40  -  Enable F10                                         *
      *  *IN50  -  Error on field L6LXOPTP                            *
      *  *IN51  -  Error on field L6LXEXCF                            *
      *  *IN52  -  Error on field L6LXTTIM                            *
      *  *IN53  -  Error on field L6LXCABR                            *
      *  *IN54  -  Error on field L6LXCNBR                            *
      *  *IN70  -  Protect/display field L6LXTTIM and L6LXCABR        *
      *  *IN70  -  Protect/display field L6LXCNBR                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
     FSEDPMVLDF CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
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
 
      ** Include the standard declares
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
 
     D @EI             S              1    DIM(5)
 
     D NwDlScnFmt    E DS                  EXTNAME(SEDMRXPD)
     D OkFlags       E DS                  EXTNAME(SEEDMLX1PD)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
 
      ** Standards Input Parameters
 
      ** Enable Function Keys
     D @EINKJ          S              1
     D @EINKE          S              1
      ** Enable Indicator
     D @EIN20          S              1
      ** Check if ULX008 present
     D ULX008          S              1
      ** Standards Output Parameters
 
      ** Function Keys
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   ENDIF
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
     C     C             DOUGT     5
     C                   IF        @EI(C) = 'N' OR
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
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
     C                   END
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
     C                   END
      *
      ** Set screen protect/non-display indicators
      **
      ** Display fields 'Transaction Time' and 'To be Excluded in CAB'
      *
     C                   IF        ULX008 = 'Y'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      *OFF          *IN70
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
     C                   WRITE     SEDPMVLH
     C                   WRITE     SEDPMVLF
 
     C                   EXFMT     SEDPMVLD
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     '00'          *IN(50)
     C                   IF        ULX008 = 'Y'
     C                   MOVEA     '00'          *IN(52)
     C                   MOVEA     '0'           *IN(54)
     C                   ENDIF
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
     C                   IF        ZAPGMQ = *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
      *
      ** Program queue
      *
     C                   PARM                    ZAPGMQ           10
      *
      ** Rel queue
      *
     C                   PARM                    ZAPGRL            5
      *
      ** Message Id.
      *
     C                   PARM                    ZAMSID            7
      *
      ** Message file
      *
     C                   PARM                    ZAMSGF           10
      *
      ** Message data
      *
     C                   PARM                    ZAMSDA          132
      *
      ** Message type
      *
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
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Depot screen format
      *
     C                   PARM                    NwDlScnFmt
      *
      ** Fields in errors
      *
     C                   PARM                    OkFlags
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning errors
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enable Function keys
      *
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
      *
      ** Indicators
      *
     C                   PARM                    @EIN20
      *
      ** If ULX008 is on
      *
     C                   PARM                    ULX008
      *
      ** Standards Output Parameters
      *
      ** Function keys
      *
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKE
     C                   PARM                    @INKJ
     C                   PARM                    BJMRDT
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM  = 'SEDPMV3DP'
      *
      ** Message subfile control
      *
     C                   EVAL      ##PGM = 'SEDPMV3DP'
      *
      ** Messages file
      *
     C                   EVAL      ZAMSGF = 'SEUSRMSG'
      *
      ** Move user and workstation ID to screen fields
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
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
(c) Finastra International Limited 2005
