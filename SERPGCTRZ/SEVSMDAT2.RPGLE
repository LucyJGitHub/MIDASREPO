     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate maturity date 2')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSMDAT2 - Validate Maturity Date 2                         *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Warning Array for SE0041
     D PErrs           S              3    DIM(9)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIx             S              3P 0
      *
      ** Parameteres for SE0041
     D PVREQ           S              1A
     D PDate           S              5P 0
     D PCcy            S              3A
      *
      ** Parameters for ZCHKH
     D PDateIn         S              5P 0
     D PCurrency       S              3A
     D PLocation       S              3A
     D PHolInd         S              1A
      *
      ** Parameters for ZDATE1
     D PDateI          S              6A
     D PDaynoOut       S              5P 0
     D BJDFIN          S              1A
     D PErrorFlag      S              1A
      *
      ** Working Variables
     D WWDay           S              5P 0
     D WMatDNo         S              5P 0
      *
      ** Switchable feature(s)
     D CSE007          S              1A
     D CEU017          S              1A
      *
      ** Standing data
     D BJRDNB          S              5P 0
     D BJDNWD          S              5P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      Wix = 0
     C                   Z-ADD     *ZEROS        WMatDNo
      *
      ** Validate maturity date 2
      *
     C                   EXSR      SRValMatDte
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKMATY2 <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKMATY2 <> 'N'
     C                   Z-ADD     WMatDNo       S1MATY
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALMATDTE - Validation for Maturity Date                   *
      *                                                               *
      *****************************************************************
     C     SRValMatDte   BEGSR
 
     C                   IF        DDMATY2 = *BLANKS
 
     C                   IF        DDINCS = 'C'
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0204'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ELSE
      *
      ** Trade basis must be 'P' is maturity date '999999'
      *
     C                   IF        DDMATY2 = '999999'
 
     C                   IF        S1STBS <> 'P' AND
     C                             DDSYBS <> 'AU'
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0155'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   Z-ADD     99999         WMatDno
 
     C                   ELSE
      *
      ** Check valid date
     C                   TESTN                   DDMATY2              01
 
     C                   IF        *IN01 = *OFF
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0204'     MsgIdXAr(IDx)
     C                   GOTO      EValMatDte
     C                   ENDIF
 
     C                   MOVE      *BLANKS       PDateI
     C                   MOVE      DDMATY2       PDateI
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateI
     C                   PARM                    PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0204'     MsgIdXAr(IDx)
     C                   GOTO      EValMatDte
     C                   ENDIF
      *
      ** If long-term maturity indicator is on, add 100 years worth of days
      ** to get same date next century
      *
     C                   IF        DDLTMI = 'Y'
     C                   ADD       36525         PDaynoOut
     C                   ENDIF
      *
      ** Must not be less than run date
      *
     C                   IF        DDMATY2 <> '999999' AND
     C                             PDaynoOut <= BJRDNB  AND
     C                             DDLTMI <> 'Y'
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0156'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** If CSE007 or CEU017 is installed
      *
     C                   IF        CSE007 = 'Y' OR
     C                             CEU017 = 'Y'
      *
      ** If amended, perform extra validation
      *
     C                   EVAL      WWDAY = PDaynoOut + 36525
 
     C                   IF        DDACTN = 'A' AND
     C                             PDaynoOut <> MATY AND
     C                             WWDAY <> MATY AND
     C                             DDLTMI <> 'Y'
 
     C                   CALL      'SE0041'
     C                   PARM      'M'           PVREQ
     C                   PARM                    DDSESN
     C                   PARM      *BLANKS       PCCY
     C                   PARM      PDaynoOut     PDate
     C                   PARM      *BLANKS       PErrs
 
     C     '500'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0157'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C     '501'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0158'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C     '502'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0159'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C     '503'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0160'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   IF        PDate <= BJDNWD
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0142'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C     '506'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *On
     C                   MOVE      'N'           OKMATY2
     C                   ADD       1             IDx
     C                   MOVEL     'DDMATY2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0161'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Check not holiday in value currency (nominal currency if blank)
      ** warning error only - check only if changed
      *
     C                   IF        DDVLCY <> *BLANKS
     C                   MOVE      DDVLCY        PCurrency
     C                   ELSE
     C                   MOVE      DDNMCY        PCurrency
     C                   ENDIF
 
     C                   Z-ADD     PDayNoOut     PDateIn
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PDateIn
     C                   PARM                    PCurrency
     C                   PARM      *BLANKS       PLocation
     C                   PARM                    PHolInd
 
     C                   IF        PHolInd = 'H'
     C                   MOVE      'W'           OKMATY2
     C                   ADD       1             WIx
     C                   MOVEL     'DDMATY2'     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0162'     WMsgIdXAr(WIx)
     C                   ENDIF
 
     C                   Z-ADD     PDaynoOut     WMatDNo
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValMatDte    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate action
     C                   PARM                    CSE007
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** STANDIND DATA
      ** =============
      *
      ** SDBANK - run date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - date of next working day
     C                   PARM                    BJDNWD
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
