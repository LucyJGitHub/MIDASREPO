     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE TRAD - Display - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SETRAD2DP - SE Trades Display                                *
      *                                                               *
      *  Function:  This Module displays the Extension Fields.        *
      *             Display File of Securities & Trading Maintenance  *
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
      *  *IN03  -  F3 Pressed exit program                            *
      *  *IN05  -  F5 Pressed redisplay the screen                    *
      *  *IN10  -  F10 Pressed delete                                 *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN30  -  Redisplay the screen                               *
      *  *IN35  -  Enable F5                                          *
      *  *IN40  -  Enable F10                                         *
      *  *IN50  -  Error on field #6LXAGSD                            *
      *  *IN51  -  Error on field #6LXTTIM                            *
      *  *IN52  -  Error on field #6LXCABR                            *
      *  *IN53  -  Error on field #6LXMTRD                            *
      *  *IN70  -  Protect/display field #6LXTTIM and #6LXCABR        *
      *  *IN70  -  Protect/display field #6LXMTRD                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSETRADLDF CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **Midas SD Bank details ICD file
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D @EI             S              1    DIM(4)
 
     D NwDlScnFmt    E DS                  EXTNAME(SETDRXPD)
     D OkFlags       E DS                  EXTNAME(SEETDLX1PD)
      *
      **   Declared variables
      **   ==================
      *
      ** Define *entry parameters
      ** Standards Input Parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
      *
      ** Extra Input Parameters
      *
     D ULX008          S              1
     D C               S              2S 0
     D E               S              2S 0
     D PRTCD           S              7
     D POPTN           S              7
      *
      ** Standards Output Parameters
      *
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
     C                   EVAL      *INLR   = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main processing                                     *
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
     C                   EVAL      E       = 50
      *
     C                   DO        4             C
     C                   IF        @EI(C)  = 'N' Or @EI(C)  = 'W'
     C                   EVAL      *IN(E)  = *ON
     C                   ENDIF
     C                   EVAL      E       = E + 1
     C                   ENDDO
      *
      ** Write error messages to subfile as message found.
      *
     C                   EVAL      C       = 1
     C                   DOW       C    <= ArrayMax And FldNameArr(C) <> *BLANKS
     C                   EVAL      ZAMSID  = MsgIdArr(C)
     C                   EVAL      ZAMSDA  = MsgDtaArr(C)
     C                   EXSR      SRSEND
     C                   EVAL      C       = C + 1
     C                   ENDDO
      *
      ** Write warning messages to subfile as message found.
      *
     C                   EVAL      C       = 1
     C                   DOW       C    <= ArrayMax And WFldNamArr(C) <> *BLANKS
     C                   EVAL      ZAMSID  = WMsgIdArr(C)
     C                   EVAL      ZAMSDA  = WMsgDtaArr(C)
     C                   EXSR      SRSEND
     C                   EVAL      C       = C + 1
     C                   ENDDO
      *
      ** Set screen protect/non-display indicators
      ** Display fields 'Transaction Time' and 'To be Excluded in CAB'
      *
     C                   IF        ULX008  = 'Y'
     C                   EVAL      *IN70   = *ON
     C                   ELSE
     C                   EVAL      *IN70   = *OFF
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
     C                   WRITE     SETRADLH
     C                   WRITE     SETRADLF
     C                   EXFMT     SETRADLD
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   MOVE      '0'           *IN(50)
     C                   IF        ULX008  = 'Y'
     C                   MOVEA     '00'          *IN(51)
     C                   MOVEA     '0'           *IN(53)
     C                   ENDIF
      *
      ** Set return keys
      *
     C                   EVAL      @INKC   = *INKC
     C                   EVAL      @INKE   = *INKE
     C                   EVAL      @INKJ   = *INKJ
     C                   EVAL      @INKL   = *INKL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLEAR - Clear message file                                 *
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
      *  SRSEND - Send message to program's message queue.            *
      *                                                               *
      *****************************************************************
     C     SRSEND        BEGSR
      *
     C                   IF        ZAPGMQ  = *BLANK
     C                   EVAL      ZAPGMQ  = ##PGM
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
      *  *INZSR - Program Initialisation routine                      *
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
     C                   PARM                    ULX008
      *
      ** Standards Output Parameters
      *
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKE
     C                   PARM                    @INKJ
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM   = 'SETRAD2DP'
      *
      ** Messages file
      *
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'
      *
      ** Message subfile control
      *
     C                   EVAL      ##PGM   = 'SETRAD2DP'
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *    ----------    ------
      *
     C                   EVAL      DDWID   = PSJobName
     C                   EVAL      DDUSER  = PSUser
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
