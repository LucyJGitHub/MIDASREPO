     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Next Interest Date')            *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVNXDT01 - Validate FUND Next Interest Date                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors (Warning error blocks input)     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP.*
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValNIDT - Next Interest Date                                *
      * SRZDate1  - Validate and convert date to day number           *
      * SRZDate9  - Convert Midas Day number to YYYYMMDD date format  *
      * SRZChkH   - Check whether date is holiday for currency        *
      * SRZAlign  - Validate numeric fields                           *
      * *INZSR    - Initialise                                        *
      * *PSSR     - Error processing                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** IN - Deal Amendments
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.

      /COPY ZACPYSRC,ERR_XARRYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)

      ** Current Deal in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DC:2)

      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)

      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  N1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029

      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  N2DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N2MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N2DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N2MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N2RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N2PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N2INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029

      ** YYYYMMDD date format of Next Interest Date
     D PDateOutZ9      DS
     D  NIDTYr                 1      4  0
     D  NIDTMn                 5      6  0
     D  NIDTDy                 7      8  0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0

      ** Index for arrays of warning message ids, etc.
     D WIDx            S              3P 0

      ** Work Parameters
     D PValDate        S              5P 0
     D PMatDate        S              5P 0
     D POREDDayNo      S              5P 0
     D PSLIDDayNo      S              5P 0
     D PIACDDayNo      S              5P 0
     D BJRDNB          S              5P 0
     D BJLCCY          S              3A

      ** Work Variables
     D WNIntDate       S              5P 0

      ** Parameters for ZCHKH
     D PDateNIn        S              5P 0
     D PCurrency       S              3A
     D PLocation       S              3A
     D PHolInd         S              1A

      ** Parameters for ZDATE1
     D PDateAIn        S              6A
     D PDaynoOut       S              5P 0
     D BJDFIN          S              1A
     D ErrorFlag       S              1A

      ** Parameters for ZDATE9
     D PDaynoIn        S              5P 0
      *(PDateOutZ9)
     D PRetCode        S              1  0

      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Initialise work variables

     C                   EVAL      IDx = 0
     C                   EVAL      WIDx = 0
     C                   EVAL      WNIntDate = 0

     C                   EXSR      SRValNIDT

      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.

     C*******************IF        OKNIDT <> 'Y'                                              222727
     C                   IF        OKNIDT = 'N'                                               222727

     C                   EVAL      RetCodeIn = 'ERROR'

     C                   ELSE

     C                   Z-ADD     NIDTYr        N1NIYY
     C                   Z-ADD     NIDTMn        N1NIMM
     C                   Z-ADD     NIDTDy        N1NIDD

     C                   Z-ADD     NIDTYr        N2NIYY
     C                   Z-ADD     NIDTMn        N2NIMM
     C                   Z-ADD     NIDTDy        N2NIDD

     C                   Z-ADD     WNIntDate     N1NIPD
     C                   Z-ADD     WNIntDate     N2NIPD

     C                   ENDIF

      *                  ======
     C                   RETURN
      *                  ======

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValNIDT - Next Interest Date                               *
      *                                                               *
      *****************************************************************

     C     SRValNIDT     BEGSR

      ** The Next interest payment date may only be amended when the
      ** Run date is after the deal input date and the next interest
      ** date is not zero

     C                   IF        DDACTN = 'A'

     C                   IF        BJRDNB <= POREDDayNo AND
     C                             DDNIDT <> DCNIDT

     C                   EVAL      OKNIDT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NIDT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0481'
     C                   GOTO      EndValNIDT

     C                   ENDIF

     C                   ENDIF

      **  Validate that the date is valid as a date

     C                   IF        DDNIDT <> *Blanks

     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDNIDT        ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      SRZAlign

     C                   IF        ZAlignOk = 'Y'

     C                   MOVE      DDNIDT        PDateAIn
     C                   EXSR      SRZDate1

     C                   ENDIF

     C                   IF        ErrorFlag = 'Y' OR
     C                             ZAlignOk = 'N'

     C                   EVAL      OKNIDT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NIDT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0438'
     C                   GOTO      EndValNIDT

     C                   ELSE

     C                   EVAL      WNIntDate = PDaynoOut

     C                   ENDIF

      ** Next Interest Date must be after the value date
      ** (If value date is valid)

     C                   IF        WNIntDate <= PValDate AND
     C                             OKVDAT <> 'N'
     C
     C                   EVAL      OKNIDT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NIDT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0440'
     C                   GOTO      EndValNIDT

     C                   ENDIF

      ** Next Interest Date must be before the maturity date
      ** (If the maturity date has been entered ans is valid)

     C                   IF        PMatDate <> 0 AND
     C                             OKMDAT <> 'N' AND
     C                             WNIntDate >= PMatDate

     C                   EVAL      OKNIDT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NIDT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0441'
     C                   GOTO      EndValNIDT

     C                   ENDIF

      ** If Amend, Next Interest Date must be after the last interest
      ** date and the interest accrual control date

     C                   IF        DDACTN = 'A'

     C                   IF        WNIntDate <= PSLIDDayNo

     C                   EVAL      OKNIDT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NIDT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0443'
     C                   GOTO      EndValNIDT

     C                   ENDIF

     C                   IF        WNIntDate <= PIACDDayNo

     C                   EVAL      OKNIDT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NIDT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0442'
     C                   GOTO      EndValNIDT

     C                   ENDIF

     C                   ENDIF

      ** Check if Next Interest Date is a Holiday in Local Currency

     C                   Z-ADD     WNIntDate     PDateNin
     C                   EVAL      PCurrency = BJLCCY
     C                   EVAL      PLocation = *Blanks
     C                   EXSR      SRZChkH

     C                   IF        PHolInd = 'H'

     C                   EVAL      OKNIDT = 'W'
     C                   EVAL      WIDx = WIDx + 1
     C                   EVAL      WFldNmXAr(WIDx)= '#1NIDT'
     C                   EVAL      WMsgIDxAr(WIDx)= 'MMM0445'

     C                   ENDIF

      ** Store date in YYYYMMDD format

     C                   Z-ADD     WNIntDate     PDayNoIn
     C                   EXSR      SRZDate9

     C                   ELSE

      ** Next Interest Date is Blank

     C                   Z-ADD     *Zero         NIDTYr
     C                   Z-ADD     *Zero         NIDTMn
     C                   Z-ADD     *Zero         NIDTDy

     C                   ENDIF

     C     EndValNIDT    ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************

     C     SRZDate1      BEGSR

     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateAIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
      *                                                               *
      *****************************************************************

     C     SRZDate9      BEGSR

     C                   CALLB     'ZDATE9'
     C                   PARM                    PDayNoIn
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCode

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZChkH - Check whether date is holiday for currency         *
      *                                                               *
      *****************************************************************

     C     SRZChkH       BEGSR

     C                   CALLB     'ZCHKH'
     C                   PARM                    PDateNIn
     c                   PARM                    PCurrency
     C                   PARM      *BLANKS       PLocation
     C                   PARM                    PHolInd

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************

     C     SRZAlign      BEGSR

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUT
      ** =====

      ** Return Code
     C                   PARM                    RetCodeIn

      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt

      ** Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt

      ** Standing Data
      ** =============

      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY

      ** Value Date in Midas Day no. format
     C                   PARM                    PValDate

      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate

      ** Original Entry Date in Midas Day format
     C                   PARM                    POREDDayNo

      ** Start/Last Interest Date in Midas Day format
     C                   PARM                    PSLIDDayNo

      ** Interest Accrual Control Date in Midas Day format
     C                   PARM                    PIACDDayNo

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr

      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags

      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1

      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
