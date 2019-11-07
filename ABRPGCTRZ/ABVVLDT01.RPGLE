     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Value Date')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVVLDT01 - Validate FUND Value Date                         *
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
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 197202             Date 29Aug01               *
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
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  197202 - Value date shows as blank when enq on accepted deal *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValVDAT - Validate Value Date                               *
      * SRZDate1  - Validate and convert date to day number           *
      * SRZDate2  - Convert Midas Day number to Date Format           *
      * SRZDate9  - Convert Midas Day number to YYYYMMDD date format  *
      * SRZChkH   - Check whether date is holiday for currency
      * SRZAlign  - Validate numeric fields                           *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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

      ** YYYYMMDD date format of Value Date
     D PDateOutZ9      DS
     D  VDATYr                 1      4  0
     D  VDATMn                 5      6  0
     D  VDATDy                 7      8  0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0

      ** Index for arrays of warning message ids, etc.
     D WIDx            S              3P 0

      ** Work Parameters
     D PDealDate       S              5P 0
     D BJRDNB          S              5P 0
     D BJLCCY          S              3A

      ** Work Variables
     D WValDate        S              5P 0

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

      ** Parameters for ZDATE2
     D PDaynoIn        S              5P 0
     D PDateOut        S              6  0
     D PADateOut       S              7A

      ** Parameters for ZDATE9
      *(PDaynoIn)
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
     C                   EVAL      WValDate = 0

     C                   EXSR      SRValVDAT

      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.

     C                   IF        OKVDAT <> 'Y' OR
     C                             OKDDAT <> 'Y'

     C                   EVAL      RetCodeIn = 'ERROR'

     C**********         ELSE                                                                 197202
     C                   ENDIF                                                                197202

     C                   IF        OKVDAT <> 'N' AND                                          197202
     C                             OKDDAT <> 'N'                                              197202
                                                                                              197202
     C                   Z-ADD     VDATYr        N1VDYY
     C                   Z-ADD     VDATMn        N1VDMM
     C                   Z-ADD     VDATDy        N1VDDD

     C                   Z-ADD     VDATYr        N2VDYY
     C                   Z-ADD     VDATMn        N2VDMM
     C                   Z-ADD     VDATDy        N2VDDD

     C                   Z-ADD     WValDate      N1DVSD
     C                   Z-ADD     WValDate      N2DVSD

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
      *  SRValVDAT - Validate Value Date                              *
      *                                                               *
      *****************************************************************

     C     SRValVDAT     BEGSR

      ** Default to Rundate

     C                   IF        DDVDAT = *Blanks

     C                   Z-ADD     BJRDNB        PDaynoIn
     C                   EXSR      SRZDate2

     C                   MOVE      PDateOut      DDVDAT
     C                   Z-ADD     BJRDNB        WValDate
     C                   GOTO      EndValVDAT

     C                   ENDIF

      ** Entry date must be numeric

     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDVDAT        ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      SRZAlign

     C                   IF        ZAlignOk = 'Y'

     C                   MOVE      DDVDAT        PDateAIn
     C                   EXSR      SRZDate1

     C                   ENDIF

     C                   IF        ErrorFlag = 'Y' OR
     C                             ZAlignOk = 'N'

     C                   EVAL      OKVDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1VDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0125'
     C                   GOTO      EndValVDAT

     C                   ELSE

     C                   EVAL      WValDate = PDaynoOut

     C                   ENDIF

      ** Deal Date must be less than the Value Date

     C                   IF        PDealDate > WValDate

     C                   EVAL      OKDDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1DDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0250'
     C                   GOTO      EndValVDAT

     C                   ENDIF

      ** Warning if Value Date is a Holiday in Local Currency

     C                   Z-ADD     WValDate      PDateNin
     C                   EVAL      PCurrency = BJLCCY
     C                   EVAL      PLocation = *Blanks
     C                   EXSR      SRZChkH

     C                   IF        PHolInd = 'H'

     C                   EVAL      OKVDAT = 'W'
     C                   EVAL      WIDx = WIDx + 1
     C                   EVAL      WFldNmXAr(WIDx)= '#1VDAT'
     C                   EVAL      WMsgIDxAr(WIDx)= 'MMM0131'

     C                   ENDIF

      ** Store date in YYYYMMDD format

     C                   Z-ADD     WValDate      PDayNoIn
     C                   EXSR      SRZDate9

     C     EndValVDAT    ENDSR

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
      *  SRZDate2 - Convert Midas Day number to Date Format.          *
      *                                                               *
      *****************************************************************

     C     SRZDate2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    PDaynoIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut

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

      ** Standing Data
      ** =============

      ** SDBANK: Date Format Indicator
     C                   PARM                    BJDFIN
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY

      ** Deal Date in Midas Day no. format

     C                   PARM                    PDealDate

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

      ** Value Date in Midas Day no. format
     C                   PARM                    WValDate

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
