     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY - Display - LU Window')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY6DP - FT Incoming Payments Display                     *
      *                                                               *
      *  Function:  This function displays the Extended Details       *
      *             screen of the Incoming payments                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD027047           Date 19Aug14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
 
     FFTIPAYDLDFCF   E             WORKSTN
     F                                     INFDS(FILEDS)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
 
      *
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** Include the MM standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
 
      *
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
 
      *
      **
      **   Named constants
      **   ===============
      **
      *
 
      *
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      *
 
     D @EI             S              1    DIM(6)
 
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
 
     D C               S              2  0
     D E               S              2  0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D NwDlScnFmt    E DS                  EXTNAME(FTIPRXPD)
     D OkFlags       E DS                  EXTNAME(FTEIPLX1PD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *
      **
      **   Declared variables
      **   ==================
      **
      *
      ** Define *entry parameters
      *
 
      *
      ** Standards Input Parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
 
      *
      ** Extra Input Parameters
      *
 
      *
      ** Standards Output Parameters
      *
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
     D @INKD           S              1
 
      *
      ** Define working DS
      ** File feedback data structure used to determine cursor location
      *
     D FILEDS          DS
     D BINROW                370    370
     D BINCOL                371    371
     D WFILEDS         S              2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Return
      *
     C**********         RETURN                                                             MD027047
     C                   SETON                                        LR                    MD027047
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Main processing                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   EVAL      C = 1
     C                   EVAL      E = 50
      *
     C                   DOU       C > 6
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   EVAL      E = E + 1
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   EVAL      C = 1
     C                   DOW       C <= ArrayMax and
     C                             FldNameArr(C) <> *Blanks
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C = C + 1
     C                   ENDDO
      *
      ** Do while warning messages found write warning messages to
      ** subfile
      *
     C                   EVAL      C = 1
     C                   DOW       C <= ArrayMax and
     C                             WFldNamArr(C) <> *Blanks
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C = C + 1
     C                   ENDDO
      *
      ** Set screen protect/non-display indicators
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
     C                   EXFMT     FTPAYDF1
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     '000000'      *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKD         @INKD
     C                   MOVE      FILEDS        WFILEDS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLEAR - Clear message file                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSEND - Send message to program's message queue.             *
      *                                                               *
      *****************************************************************
      *
     C     SRSEND        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
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
      ** Standards Output Parameters
      *
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKE
     C                   PARM                    @INKJ
     C                   PARM                    @INKD
     C                   PARM                    WFILEDS
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTIPAY6DP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVEL     'FTIPAY6DP'   ##PGM
      *
      ** Messages file
      *
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   EVAL      SUSER = PSUSER
     C                   EVAL      SWSID = PSJobName
     C                   MOVE      BJMRDT        SRUNA
      *
     C                   ENDSR
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
