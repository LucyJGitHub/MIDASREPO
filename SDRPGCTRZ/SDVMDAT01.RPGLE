     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Calc. and validate YRate mat. date module')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVMDAT01 - Calculate & Validate Yield Rate Maturity Date    *
      *              Module                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG9329            Date 02Dec05               *
      *                 228390             Date 14Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 222373             Date 24Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG9329 - Allow insert of period at the end point of         *
      *            maintenance. Applied fix 230448.                   *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  222373 - Parameter Mismatch                                  *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  80  - LOOKUP indicator                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation                                  *
      *  SRINIT     - Initialisation Processing                       *
      *  SRVMATDTE  - Validate Maturity Date                          *
      *  *PSSR      - DB Error Processing                             *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARR1
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Maturity Date
     D PMatAr          S              7    DIM(98)
 
      ** Maturity Date (Numeric)
     D PNMatAr         S              5P 0 DIM(98)
 
      ** Currency Code Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Yield Curve Details
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
                                                                                              CAS008
      ** External DS for SAR details                                                          CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
                                                                                              CAS008
      ** First DS for access programs, short data structure                                   CAS008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS008
 
      ** Period Date (1st subfile record)
     D PeriodDS        DS
     D WPYr                    1      2  0
     D WPMn                    3      4  0
     D WPDy                    5      6  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Period Years (Numeric)
     D PerNYear        S              2  0
 
      ** Period Month (Numeric)
     D PerNMonth       S              2  0
 
      ** Period Days (Numeric)
     D PerNDay         S              2  0
 
      ** OK Flag of Period Years
     D PYrOK           S              1
 
      ** OK Flag of Period Months
     D PMnOK           S              1
 
      ** OK Flag of Period Days
     D PDyOK           S              1
 
      ** Other work fields/index/parameters
     D A               S              4  0
     D B               S              4  0
     D WElementN       S              2
     D WErrFld         S             10
     D WKRDNB          S              5P 0
     D W#SPOT          S              5  0
     D W#SP25Y         S              5  0
     D W#PDNO          S              5  0
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
     D PZFIELD         S             16
     D PZALIGNOK       S              1
     D PZINDT          S              5  0
     D PZNYR           S              2  0
     D PZNMN           S              2  0
     D PZNDY           S              2  0
     D PZPDNO          S              5  0
     D PZPDTE          S              7
     D P#0YCCY         S              3
     D P#0YCFQ         S              1
     D P#0SPDY         S              2                                                       CAS008
     D PZDAYNO         S              5  0
     D PZCCY           S              3
     D PZLOC           S              3
     D PZNRDYS         S              2  0
     D PZDYNBR         S              5  0
     D PPrvPDte        S              5P 0
     D PEntry          S              5  0
 
     D CAS008          S              1A                                                      CAS008
     D PSard           S              6A                                                      CAS008
     D POptn           S              7A                                                      CAS008
     D PRtCd           S              7A                                                      CAS008
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation Processing
 
     C                   EXSR      SRINIT
 
      ** Validate Yield Rate Maturity Date
 
     C                   EXSR      SRVMATDTE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT  - Initialisation Processing                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialize error work fields and arrays
 
     C                   EVAL      RetCodeIn =  *BLANK
     C                   EVAL      FldNamXar2 =  *BLANK
     C                   EVAL      MsgIdXar2 =  *BLANK
     C                   EVAL      MsgDtaXar2 =  *BLANK
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVMATDTE - Validate Yield Rate Maturity Date                 *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * ZFWDT       - Calculate Working Days                          *
      * ZCPD        - Calculate Period Date                           *
      * SRSETERRFLD - Setup Error Field                               *
      *                                                               *
      *****************************************************************
 
     C     SRVMATDTE     BEGSR
 
      ** Set up number of years, months and days for ZCPD
 
     C                   EVAL      PZNYR = PerNYear
     C                   EVAL      PZNMN = PerNMonth
     C                   EVAL      PZNDY = PerNDay
 
      ** Use the currency spot days in all cases to calculate spot date
 
     C                   IF        P#0YCCY = *BLANK
     C                   EVAL      W#SPOT = WKRDNB
     C                   ELSE
     C                   EVAL      PZCCY = P#0YCCY
     C                   EVAL      PZLOC = *BLANK
     C                   EVAL      PZDAYNO = WKRDNB
     C                   IF        CAS008 = 'Y' AND                                           CAS008
     C                             P#0SPDY <> *BLANK                                          CAS008
     C                   MOVE      P#0SPDY       PZNRDYS                                      CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      PZNRDYS = A6SPDY
     C                   ENDIF                                                                CAS008
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    PZDAYNO
     C                   PARM                    PZNRDYS
     C                   PARM                    PZDYNBR
     C                   PARM                    PZCCY
     C                   PARM                    PZLOC
 
     C                   EVAL      W#SPOT = PZDYNBR
     C                   ENDIF
 
     C                   EVAL      PZINDT = W#SPOT
 
      ** Calculate period date
 
     C                   CALLB     'ZCPD'
     C                   PARM                    PZINDT
     C                   PARM                    PZNYR
     C                   PARM                    PZNMN
     C                   PARM                    PZNDY
     C                   PARM                    BJDFIN            1                          222373
     C                   PARM      *ZERO         PZPDNO
     C                   PARM      *BLANK        PZPDTE
 
      ** Check for duplicate records and out of sequence periods
 
     C                   EVAL      B = 1
     C     PZPDNO        LOOKUP    PNMatAr(B)                             80
     C                   IF        *IN80 = *ON
     C                   EVAL      PYrOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDYR    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9211'
 
     C                   EVAL      PMnOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDMN    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9211'
 
     C                   EVAL      PDyOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDDY    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9211'
     C**********         ELSE                                                                BUG9329
     C**********         IF        (PPrvPDte <> *ZERO) AND (PZPDNO < PPrvPDte)               BUG9329
     C**********         EVAL      PYrOK = 'N'                                               BUG9329
     C**********         EVAL      Idx = Idx + 1                                             BUG9329
     C**********         EVAL      WErrFld = '#0PDYR    '                                    BUG9329
     C**********         EXSR      SRSETERRFLD                                               BUG9329
     C**********         EVAL      FldNamXAr2(Idx) = WErrFld                                 BUG9329
     C**********         EVAL      MsgIdXAr2(Idx) = 'USR9212'                                BUG9329
 
     C**********         EVAL      PMnOK = 'N'                                               BUG9329
     C**********         EVAL      Idx = Idx + 1                                             BUG9329
     C**********         EVAL      WErrFld = '#0PDMN    '                                    BUG9329
     C**********         EXSR      SRSETERRFLD                                               BUG9329
     C**********         EVAL      FldNamXAr2(Idx) = WErrFld                                 BUG9329
     C**********         EVAL      MsgIdXAr2(Idx) = 'USR9212'                                BUG9329
 
     C**********         EVAL      PDyOK = 'N'                                               BUG9329
     C**********         EVAL      Idx = Idx + 1                                             BUG9329
     C**********         EVAL      WErrFld = '#0PDDY    '                                    BUG9329
     C**********         EXSR      SRSETERRFLD                                               BUG9329
     C**********         EVAL      FldNamXAr2(Idx) = WErrFld                                 BUG9329
     C**********         EVAL      MsgIdXAr2(Idx) = 'USR9212'                                BUG9329
     C**********         ENDIF                                                               BUG9329
     C                   ENDIF
 
     C                   EVAL      PNMatAr(A) = PZPDNO
     C                   EVAL      PMatAr(A) = PZPDTE
 
      ** Save period date
 
     C                   EVAL      W#PDNO = PZPDNO
 
      ** If compounding frequency is 'D' (Daily), Period Date must be less
      ** than 25 years after spot date.
 
     C                   IF        P#0YCFQ = 'D'
     C                   EVAL      PZINDT = W#SPOT
     C                   EVAL      PZNYR = 25
     C                   EVAL      PZNMN = *ZERO
     C                   EVAL      PZNDY = *ZERO
 
     C                   CALLB     'ZCPD'
     C                   PARM                    PZINDT
     C                   PARM                    PZNYR
     C                   PARM                    PZNMN
     C                   PARM                    PZNDY
     C                   PARM                    BJDFIN            1                          222373
     C                   PARM      *ZERO         PZPDNO
     C                   PARM      *BLANK        PZPDTE
 
     C                   EVAL      W#SP25Y = PZPDNO
 
     C                   IF        W#PDNO >= W#SP25Y
     C                   EVAL      PYrOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDYR    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9213'
 
     C                   EVAL      PMnOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDMN    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9213'
 
     C                   EVAL      PDyOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDDY    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9213'
     C                   ENDIF
     C                   ENDIF
 
      ** If yield curve type is 'Z' (Zero-Coupon), validate first period date
      ** entered that is not spot date. (Note: The first period is the only
      ** period that can be spot  It would be entered as 00Yrs/00Mos/00Dys.)
 
     C**********         IF        (PYrOK = 'Y') AND (PMnOK = 'Y') AND                        228390
     C**********                   (PDyOK = 'Y') AND (FSYLDT = 'Z')                           228390
     C                   IF        ((PYrOK = 'Y') AND (PMnOK = 'Y') AND                       228390
     C                             (PDyOK = 'Y') AND (FSYLDT = 'Z')) OR                       228390
     C                             ((PYrOK = 'Y') AND (PMnOK = 'Y') AND                       228390
     C                             (PDyOK = 'Y') AND (FSYLDT = 'S'))                          228390
 
      ** 1st period date entered
 
     C                   IF        PEntry = 1
     C                   EVAL      WPYr = PerNYear
     C                   EVAL      WPMn = PerNMonth
     C                   EVAL      WPDy = PerNDay
     C                   ENDIF
 
     C                   IF        (PeriodDS <> *ZERO) AND (PEntry = 1) OR
     C                             (PeriodDS = *ZERO) AND (PEntry = 2)
 
      ** Calculate first compounding date = spot + frequency
 
     C                   EVAL      PZNYR = *ZERO
     C                   EVAL      PZNMN = *ZERO
     C                   EVAL      PZNDY = *ZERO
 
     C                   SELECT
     C                   WHEN      P#0YCFQ = 'D'
     C                   EVAL      PZNDY = 1
     C                   WHEN      P#0YCFQ = 'Q'
     C                   EVAL      PZNMN = 3
     C                   WHEN      P#0YCFQ = 'X'
     C                   EVAL      PZNMN = 6
     C                   WHEN      P#0YCFQ = 'Y'
     C                   EVAL      PZNYR = 1
     C                   ENDSL
 
     C                   EVAL      PZINDT = W#SPOT
 
     C                   CALLB     'ZCPD'
     C                   PARM                    PZINDT
     C                   PARM                    PZNYR
     C                   PARM                    PZNMN
     C                   PARM                    PZNDY
     C                   PARM                    BJDFIN            1                          222373
     C                   PARM      *ZERO         PZPDNO
     C                   PARM      *BLANK        PZPDTE
 
      ** Error if period date is after first compounding date
 
     C                   IF        W#PDNO > PZPDNO
     C                   EVAL      PYrOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDYR    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9214'
 
     C                   EVAL      PMnOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDMN    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9214'
 
     C                   EVAL      PDyOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0PDDY    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9214'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETERRFLD - Set up error field                              *
      *                                                               *
      * Called By : SRVMATDTE subroutine                              *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETERRFLD   BEGSR
 
      ** Add Element number
 
     C                   MOVE      A             WElementN
     C                   EVAL      WErrFld = %Trim(WErrFld) + WElementN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By : Called automatically upon module execution        *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    A
     C                   PARM                    PEntry
     C                   PARM                    PerNYear
     C                   PARM                    PerNMonth
     C                   PARM                    PerNDay
     C                   PARM                    PPrvPDte
     C                   PARM                    WKRDNB
     C                   PARM                    P#0YCCY
     C                   PARM                    P#0YCFQ
     C                   PARM                    P#0SPDY                                      CAS008
     C                   PARM                    SDCURR
     C                   PARM                    SDYLDC
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIDXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    PYrOK
     C                   PARM                    PMnOK
     C                   PARM                    PDyOK
     C                   PARM                    PMatAr
     C                   PARM                    PNMatAr
 
      ** Check if switchable feature CAS008 is switched on.                                   CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY'     POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRtCd <> *BLANKS) AND                                     CAS008
     C                             (PRtCd <> '*NRF   ')                                       CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 1                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
