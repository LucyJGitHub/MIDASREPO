     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Maturity Date')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVMTDT01 - Validate FUND Maturity Date                      *
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
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212582             Date 28Nov02               *
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
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors (MMM0136 incorrectly issued)     *
      *  212582 - Maturity date field is not updated on file if it    *
      *           is a holiday in the local currency.                 *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP.*
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    04         READP: Record found Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValMDAT - Validate Maturity Date                            *
      * SRZDate1  - Validate and convert date to day number           *
      * SRZDate9  - Convert Midas Day number to YYYYMMDD date format  *
      * SRZDate10 - Convert YYYYMMDD date format to Midas Day No.     *
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

      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  D1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  D1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  D1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  D1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  D1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  D1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  D1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029

      ** Latest Deal Amendment Value Date (YYYYMMDD)
     D DAmdValDat      DS
     D  DAmdYr                 1      4  0
     D  DAmdMn                 5      6  0
     D  DAmdDy                 7      8  0

      ** Deal Transaction Date (YYYYMMDD)
     D D1OREDDate      DS
     D  D1OREDYr               1      4  0
     D  D1OREDMn               5      6  0
     D  D1OREDDy               7      8  0

      ** Start/Last Interest Date (YYYYMMDD)
     D D1SLIDDate      DS
     D  D1SLIDYr               1      4  0
     D  D1SLIDMn               5      6  0
     D  D1SLIDDy               7      8  0

      ** Interest Accrual Control Date (YYYYMMDD)
     D D1IACDDate      DS
     D  D1IACDYr               1      4  0
     D  D1IACDMn               5      6  0
     D  D1IACDDy               7      8  0

      ** YYYYMMDD date format of Maturity Date
     D PDateOutZ9      DS
     D  MDATYr                 1      4  0
     D  MDATMn                 5      6  0
     D  MDATDy                 7      8  0

      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFilIn            04     04

      ** Input parameter for ZDATE10
     D                 DS
     D PDateIn                 1      8  0

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
     D BJRDNB          S              5P 0
     D BJLCCY          S              3A

      ** Work Variables
     D WMatDate        S              5P 0
     D WDAValDat       S              5P 0
     D WOREDDayNo      S              5P 0
     D WSLIDDayNo      S              5P 0
     D WIACDDayNo      S              5P 0
     D WVDEAMN         S              6  0
     D WVYY            S              4  0
     D WVMM            S              2  0
     D WVDD            S              2  0
     D WVSEQ           S              3  0

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

      ** Parameters for ZDATE10
      *(PDateIn)
     D PMDNO           S              5P 0

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
     C                   EVAL      WMatDate = 0
     C                   EVAL      WDAValDat = 0
     C                   EVAL      WOREDDayNo = 0
     C                   EVAL      WSLIDDayNo = 0
     C                   EVAL      WIACDDayNo = 0
     c                   EVAL      WVDEAMN = 0
     C                   EVAL      WVYY = 0
     C                   EVAL      WVMM = 0
     C                   EVAL      WVDD = 0
     C                   EVAL      WVSEQ = 0

     C                   EXSR      SRValMDAT

      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.

     C                   IF        OKMDAT <> 'Y'

     C                   EVAL      RetCodeIn = 'ERROR'

     C**********         ELSE                                                                 212582
                                                                                              212582
     C                   ENDIF                                                                212582
                                                                                              212582
     C                   IF        OKMDAT <> 'N'                                              212582

     C                   Z-ADD     MDATYr        N1MDYY
     C                   Z-ADD     MDATMn        N1MDMM
     C                   Z-ADD     MDATDy        N1MDDD

     C                   Z-ADD     MDATYr        N2MDYY
     C                   Z-ADD     MDATMn        N2MDMM
     C                   Z-ADD     MDATDy        N2MDDD

     C                   Z-ADD     WMatDate      N1MATD
     C                   Z-ADD     WMatDate      N2MATD

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
      *  SRValMDAT - Validate Maturity Date                           *
      *                                                               *
      *****************************************************************

     C     SRValMDAT     BEGSR

      ** Maturity Date cannot be amended on input date

     C                   IF        DDACTN = 'A'

      ** Get Midas day no. of Deal Transaction Date

     C                   EVAL      D1OREDYr = D1DTYY
     C                   EVAL      D1OREDMn = D1DTMM
     C                   EVAL      D1OREDDy = D1DTDD
     C                   MOVE      D1OREDDate    PDateIn
     C                   EXSR      SRZDate10
     C                   Z-ADD     PMDNO         WOREDDayNo

     C                   SELECT

     C                   WHEN      BJRDNB <= WOREDDayNo AND
     C                             DDMDAT <> DCMDAT

     C                   EVAL      OKMDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1MDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0583'
     C                   GOTO      EndValMDAT

     C                   WHEN      DCMDAT <> *Blanks AND
     C                             DDMDAT = *Blanks

     C                   EVAL      OKMDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1MDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0126'
     C                   GOTO      EndValMDAT

     C                   ENDSL

     C                   ENDIF

      ** If Maturity Date is not blank, entry date must be numeric

     C                   IF        DDMDAT <> *Blanks

     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDMDAT        ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      SRZAlign

     C                   IF        ZAlignOk = 'Y'

     C                   MOVE      DDMDAT        PDateAIn
     C                   EXSR      SRZDate1

     C                   ENDIF

     C                   IF        ErrorFlag = 'Y' OR
     C                             ZAlignOk = 'N'

     C                   EVAL      OKMDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1MDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0128'
     C                   GOTO      EndValMDAT

     C                   ELSE

     C                   EVAL      WMatDate = PDaynoOut

     C                   ENDIF

      ** Maturity Date must NOT be less than the Value Date

     C                   IF        WMatDate <= PValDate

     C                   EVAL      OKMDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1MDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0130'
     C                   GOTO      EndValMDAT

     C                   ENDIF

     C                   IF        DDACTN = 'A'

      ** If Amend, Maturity Date must be after the last interest
      ** date and the interest accrual control date

      ** Get Midas day no. of Last Interest Date
     C                   EVAL      D1SLIDYr = D1SLYY
     C                   EVAL      D1SLIDMn = D1SLMM
     C                   EVAL      D1SLIDDy = D1SLDD
     C                   MOVE      D1SLIDDate    PDateIn
     C                   EXSR      SRZDate10
     C                   Z-ADD     PMDNO         WSLIDDayNo

      ** Get Midas day no. of Interest Accrual Control Date
     C                   EVAL      D1IACDYr = D1IAYY
     C                   EVAL      D1IACDMn = D1IAMM
     C                   EVAL      D1IACDDy = D1IADD
     C                   MOVE      D1IACDDate    PDateIn
     C                   EXSR      SRZDate10
     C                   Z-ADD     PMDNO         WIACDDayNo

     C                   IF        WMatDate <= WIACDDayNo OR
     C                             WMatDate <= WSLIDDayNo

     C                   EVAL      OKMDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1MDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0133'
     C                   GOTO      EndValMDAT

     C                   ENDIF

      ** If Amend and the transaction have a live deal amendment in
      ** Deal amendments file, the maturity date must be after the
      ** latest deal amendment's value date

      ** Read Amendments file to check existing record for later
      ** validation
     C                   MOVE      DDDLNO        WVDEAMN
     C                   EVAL      WVYY = 9999
     C                   EVAL      WVMM = 99
     C                   EVAL      WVDD = 99
     C                   EVAL      WVSEQ = 999
     C     WDEAMK        SETGT     MMLVDMLL
     C                   READP     MMLVDMLL                               04

     C                   IF        EndOfFilIn = False
     C                             AND  HNDA38 =  WVDEAMN                                     222727

     C                   Z-ADD     HNVDYY        DAmdYr
     C                   Z-ADD     HNVDMM        DAmdMn
     C                   Z-ADD     HNVDDD        DAmdDy
     C                   MOVE      DAmdValDat    PDateIn
     C                   EXSR      SRZDate10
     C                   Z-ADD     PMDNO         WDAValDat

     C                   IF        WMatDate <= WDAValDat

     C                   EVAL      OKMDAT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1MDAT'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0136'
     C                   GOTO      EndValMDAT

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Maturity Date is blank

     C                   ELSE

     C                   Z-ADD     0             WMatDate

     C                   ENDIF

      ** Warning if Maturity Date is a Holiday in Local Currency

     C                   IF        WMatDate <> 0

     C                   Z-ADD     WMatDate      PDateNin
     C                   EVAL      PCurrency = BJLCCY
     C                   EVAL      PLocation = *Blanks
     C                   EXSR      SRZChkH

     C                   IF        PHolInd = 'H'

     C                   EVAL      OKMDAT = 'W'
     C                   EVAL      WIDx = WIDx + 1
     C                   EVAL      WFldNmXAr(WIDx)= '#1MDAT'
     C                   EVAL      WMsgIDxAr(WIDx)= 'MMM0135'

     C                   ENDIF

     C                   ENDIF

      ** Store date in YYYYMMDD format

     C                   Z-ADD     WMatDate      PDayNoIn
     C                   EXSR      SRZDate9

     C     EndValMDAT    ENDSR

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
      *  SRZDate10 - Convert YYYYMMDD Format Date to Midas Day No.    *
      *                                                               *
      *****************************************************************

     C     SRZDate10     BEGSR

     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM                    PMDNO

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

      ** Current Deal in File Format of main deal
     C                   PARM                    CrDlFilFmt1

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

      ** Maturity Date in Midas Day no. format
     C                   PARM                    WMatDate

      ** Original Entry Date in Midas Day format
     C                   PARM                    WOREDDayNo

      ** Start/Last Interest Date in Midas Day format
     C                   PARM                    WSLIDDayNo

      ** Interest Accrual Control Date in Midas Day format
     C                   PARM                    WIACDDayNo

      ** Key fields of file MMDEAMPP
     C     WDEAMK        KLIST
     C                   KFLD                    WVDEAMN
     C                   KFLD                    WVYY
     C                   KFLD                    WVMM
     C                   KFLD                    WVDD
     C                   KFLD                    WVSEQ

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
