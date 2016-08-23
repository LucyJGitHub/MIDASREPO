     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *===============================================================*
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Details 1 LUX Display')
      *===============================================================*
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SESECS6DP - SE Securities Details 1 LUX Display              *
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
      *  FUNCTION OF INDICATORS                                       *
      *                                                               *
      *  *IN03  -  F3 Pressed exit program                            *
      *  *IN05  -  F5 Pressed redisplay the screen                    *
      *  *IN10  -  F10 Pressed delete                                 *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN25  -  SFLEND control                                     *
      *  *IN35  -  Enable F5                                          *
      *  *IN40  -  Enable F10                                         *
      *  *IN50  -  Error on field #4LXPORE                            *
      *                                                               *
      *****************************************************************
 
     FSESEC1LDF CF   E             WORKSTN
     F                                     RENAME(SESEC1LF0:SCREEN)
 
      *===============================================================*
      ** Automatically included D-specs
      ** ==============================
      ** ==============================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the
      **                                   database handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
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
      *
      ** Manually included D-specs
      ** =========================
      *
      ** Named constants
      ** ---------------
      *
      *
      ** Arrays and Data Structures
      ** --------------------------
      *
      *
      ** Error Indicators Array
      *
     D @EI             S              1    DIM(1)
      *
      ** New Extension in Screen Format (#nLX)
      *
     D NwExScnFmt    E DS                  EXTNAME(SESERXPD)
      *
      ** Error indicators (OK#4LX)
      *
     D OkFlags       E DS                  EXTNAME(SEESELX2PD)
      *
      ** Declared variables
      ** ------------------
      *
     D PRTCD           S              7
     D POPTN           S              7
      *
      ** Define *entry parameters
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Midas SD Bank details ICD file
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      /EJECT
      *---------------------------------------------------------------*
      *
      ** Standards Input Parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
      *
      ** Standards Output Parameters
      *
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
      *===============================================================*
      **             M  A  I  N     P  R  O  C  E  S  S  I  N  G      *
      *===============================================================*
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Return
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN    : Main processing                                  *
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
 
     C     C             DOUGT     1
      *
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
      *
     C                   EVAL      C = C +  1
     C                   EVAL      E = E +  1
     C                   END
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C = C +  1
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
     C                   EVAL      C =  C + 1
     C                   END
      *
      ** Enable fields protection
      *
     C                   IF        @EIN20 = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
      *
      ** Enable functions keys
      *
     C                   IF        @EINKE = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
      *
     C                   IF        @EINKJ = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
      ** Write message subfile and window details screen
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     SCREEN
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   EVAL      *IN(50)  = '0'
      *
      ** Set return keys
      *
     C                   EVAL      @INKC =  *INKC
     C                   EVAL      @INKE =  *INKE
     C                   EVAL      @INKJ =  *INKJ
     C                   EVAL      @INKL =  *INKL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLEAR - Clear program message queue                        *
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
      *  SRSEND - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
     C     SRSEND        BEGSR
      *
     C                   IF        ZAPGMQ  = *BLANK
     C                   EVAL      ZAPGMQ = ##PGM
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
      *  *INZSR - Program initialisation                              *
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
     C                   PARM                    NwExScnFmt
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
      ** Standards Output Parameters
      *
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKE
     C                   PARM                    @INKJ
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM  = 'SESECS6DP'
      *
      ** Message subfile control
     C
     C                   MOVEL     PSProcMod     ##PGM
      *
      ** Messages file
      *
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   EVAL      SJOB   = PSJobName
     C                   EVAL      SUSER  = PSUser
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error       *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
