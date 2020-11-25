     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Effective Interest Rate Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  LE004610 - LE Lending EIR Calculation Processing             *
      *                                                               *
      *  Function:  This new program will be created to generate the  *
      *             present and future cash flows for the calculation *
      *             of the effective interest rate.  The program will *
      *             also generate reports that would show the         *
      *             effective interest rate details and the cash      *
      *             flows where it was derived.                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 07Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 262654             Date 11May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 BUG10875A          Date 12May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10875           Date 16Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9472            Date 06Dec05               *
      *                 Bug9668            Date 02Jan06               *
      *                 233545             Date 18May05               *
      *                 232928             Date 08Apr05               *
      *                 233612             Date 20May05               *
      *                 233578             Date 19May05               *
      *                 CAS011             Date 16May05               *
      *                 232771             Date 21Mar05               *
      *                 232630             Date 14Mar05               *
      *                 232628             Date 14Mar05               *
      *                 232311             Date 28Feb05               *
      *                 231712             Date 08Feb05               *
      *                 231710             Date 26Jan05               *
      *                 CAS009  *CREATE    Date 06Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  262654 - Enlarge EIR output field to match size of EIR       *
      *           field on LE and MM files.                           *
      *           Also, adjust call to ZAEIRCALC as this is now a     *
      *           module and no longer a bound program.               *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  BUG10875A (Reopen) - Receiver value too small to hold result *
      *                      (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10875 - Receiver value too small to hold result           *
      *             (Recompile)                                       *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9472 - Should exclude non-auto settle fees as events for  *
      *            these fees are not projected.                      *
      *  Bug9668 - Update Amortising Fees for the period.             *
      *  233545 - Cut-off Date (Recompile)                            *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  233612 - Stop Accruals processing to be included in          *
      *           Nonlinear amortisation computation                  *
      *  233578 - Ensure correct discount amount for loans maturing   *
      *           today                                               *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  232771 - Include fees on maturity on the last period         *
      *  232630 - Incorrect non-linear amortization.                  *
      *  232628 - CAS009 Rollover patch (LE).                         *
      *  232311 - Include One off fees that start on the loan's value *
      *           date in the EIR Calculation                         *
      *  231712 - Compute for amortisation adjustment if EIR          *
      *           recalculation indicator is flagged as 'Y'.          *
      *           ZAAMRTCALC created to do Amortisation computation.  *
      *  231710 - All Fees should Amortise at EIR Start Date. Change  *
      *           AIPD + AIAP to IPRD.                                *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *           for Lending                                         *
      *                                                               *
      *****************************************************************

      * Midas LE Effective Interest Rate Details File
     FLEEIRDL3  UF A E           K DISK    INFSR(*PSSR)

      ** Midas LE Effective Interest Rate Amortisation file
     FLEEIRAL4  IF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Lending Fees History file
     FLEFHSTL0  IF   E           K DISK    INFSR(*PSSR)

      * Midas LE Cash Flow File
     FLECFSFL0  IF A E           K DISK    INFSR(*PSSR)

      * Midas LE Present EIR Cash Flows File
     FLEEIRPL0  UF A E           K DISK    INFSR(*PSSR)
     F*                                    RENAME(LEEIRPD0 : ZAEIRPD0)

      * Midas LE Future Cash Flows File
     FLEEIRFL0  UF A E           K DISK    INFSR(*PSSR)
     F*                                    RENAME(LEEIRFD0 : ZAEIRFD0)

      ** Midas LE Cashflows File for Amortisation Calc                                        231712
     FLEAMRTL0  UF A E           K DISK    INFSR(*PSSR)                                       231712
                                                                                              231712
      * Midas LE Loans File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)

      * Midas LE History File
     F***HISTR**   IF   E           K DISK    INFSR(*PSSR)                                    232628
     FHISTSL0   IF   E           K DISK    INFSR(*PSSR)                                       232628

      * Midas LE Lending Fees File
     F***LEFEEDLB  IF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FLEFEEDLC  IF   E           K DISK    INFSR(*PSSR)                                       CAS011

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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

     D***##OX1           S             56    DIM(4)  CTDATA PERRCD(1)                         231712
     D ##OX1           S             56    DIM(6)  CTDATA PERRCD(1)                           231712

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Midas Modules details accessed via access program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Hedging ICD Details
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)

      ** Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)

      ** General Ledger Details                                                               231712
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  231712
                                                                                              231712
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CAS011
      ** Long Access Object Data Structure                                                    CAS011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAS011

      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** ZAEIRF Data Structure                                                                231712
     D ZAEIRF        E DS                  EXTNAME(ZAEIRFPD)                                  231712
                                                                                              231712
      ** ZAAMRT Data Structure                                                                231712
     D ZAAMRT        E DS                  EXTNAME(ZAAMRTPD)                                  231712
                                                                                              231712
      ** Work fields
     D WRCDT           S              1A
     D WBRCA           S              3A
     D*WLNRF****       S              6S 0                                                    CLE148
     D WLNRF           S              6A                                                      CLE148
     D*WCNUM****       S              6S 0                                                    CSD027
     D WCNUM           S              6A                                                      CSD027
     D WSTDT           S              5S 0
     D WFACL           S              5S 0
     D @ICBS           S              1S 0
     D @NDYY           S              3S 0
     D ZZINDY          S              5  0
     D ZZBEG           S              5  0
     D ZZEND           S              5  0
     D ZZCALC          S              1A
     D MESLEN          S             15P 5
     D MESOVR          S             56A
     D PFECD           S              2  0
     D INT6DY          S             15  9                                                    242286
                                                                                              CLE134
     D WFEAUT          S              1A                                                      CLE134
     D CLE134          S              1A                                                      CLE134
                                                                                              CLE134
      ** Work fields for SR/SREIRCalc
      ** Input Parameter
     D*PInpTNRF*       S              6S 0                                                    CLE148
     D PInpTNRF        S              6A                                                      CLE148
     D PInpStartEff    S              5P 0
     D PInpEndEff      S              5P 0

      ** Output Parameter
     D*POutEIR**       S             14P12                                                    262654
     D POutEIR         S             15P10                                                    262654
     D PReturnCode     S              7A

     D WCAMT           S                   LIKE(PRAM)
     D WAllFeePaidTdy  S             17P 0                                                    231712
                                                                                              231712
      ** ZAAMRTCALC Parameter (Alpha)                                                         231712
     D PAmortDSA       S            200A                                                      231712
                                                                                              231712
      ** ZAAMRTCALC DS breakdown                                                              231712
     D PAmortDS        DS           200                                                       231712
     D  PPGMName                     10A   INZ('LE004610')                                    231712
     D  WEffIntRate                  15P10                                                    231712
     D  EISTDT                        5P 0                                                    231712
     D  EIENDT                        5P 0                                                    231712
     D**LNRF****                      6S 0                                             231712 CLE148
     D  LNRF                          6A                                                      CLE148
     D  WMaturityDate                 5P 0                                                    233578
     D  WStartDate                    5P 0                                                    231712
     D  WEndDate                      5P 0                                                    231712
     D  WTOTI                        13P 0                                                    231712
     D  WAccInd                       1A   INZ('L')                                           231712
     D  WEIPRDP                      15P 0                                                    231712
     D  WEIPRCP                      15P 0                                                    231712
     D  WIntCalcBasis                 1P 0                                                    231712
     D  WProcType                     1A                                                      231712
     D  WkLoanInd                     1A                                                      232928
     D  PStopAccrualF                 1A                                                      233612
     D  WAmrtAmt                     17P 0                                                    231712
     D  PDrtPrcTdy                   15P 0                                                    231712
     D  PClnPrcTdy                   15P 0                                                    231712
                                                                                              231712
      *****************************************************************                       231712
      /EJECT
      *****************************************************************
      * MAIN - Main Body                                              *
      *****************************************************************

      ** Get all EIR records that are set for recalculation.
     C     *LOVAL        SETLL     LEEIRDL3
     C                   READ      LEEIRDL3

     C                   DOW       NOT %EOF(LEEIRDL3)

     C                   IF         EIRECI <> '*'                                             232630
      ** Get loan details
     C                   EXSR      SRLoanDetails

      ** Generate Present Cash Flows
     C                   EXSR      SRPresCashFl

      ** Generate Future Cash Flows
     C                   EXSR      SRFutCashFl

      ** Calculate EIR by calling the EIR calculator
     C                   EXSR      SREIRCalc

      ** Compute for Amortisation adjustment if last amortisation                             231712
      ** date is not *ZERO                                                                    231712
     C                   IF        EILADT <> *ZERO                                            231712
     C                   EXSR      SRCompAMAJ                                                 231712
     C                   ENDIF                                                                231712
                                                                                              231712
      ** Update EIR details
     C                   EXSR      SREIRUpdate
     C                   ENDIF                                                                232630

      ** Read another EIR record for recalculation
     C                   READ      LEEIRDL3

     C                   ENDDO
      ** Exit Program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRLoanDetails - Get loan details                             *
      ****************************************************************
     C     SRLoanDetails BEGSR

      ** Get loan details
     C     KLOAN         CHAIN     CLOAN                              21

     C                   EVAL      @ICBS = ICBS
     C                   EVAL      WFACL = 0

     C                   IF        *IN21 = *ON

      ** Database error if record missing
     C                   MOVE      EITRAN        DBKEY
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             Bug9668
      ** Fees and Discounts/Premiums Amortising this EIR period                              Bug9668
                                                                                             Bug9668
     C     *LIKE         DEFINE    EIFDPA        WFDPA                                       Bug9668
     C                   EVAL      wFDPA = 0                                                 Bug9668

      ** Check Loans detail flag to see if accrual is halted                                  233612
     C                   EVAL      PStopAccrualF = ' '                                        233612
     C                   TESTB     '3'           LONI                     50                  233612
     C                   IF        *IN50 = *ON                                                233612
     C                   EVAL      PStopAccrualF = 'Y'                                        233612
     C                   ENDIF                                                                233612
                                                                                              233612
     C                   ENDSR
      /EJECT
      ****************************************************************
      * SRPresCashFl - Generate Present Cash Flow                    *
      ****************************************************************
     C     SRPresCashFl  BEGSR

      ** If found, continue processing
     C                   EVAL      WBRCA = BRCA
     C                   EVAL      WCNUM = CNUM
     C                   EVAL      WSTDT = EISTDT
     C                   EVAL      WLNRF = EITRAN
                                                                                              233578
      ** Ensure that the Total Interest used is the Current TOTI                              233578
     C                   EVAL(R)   WTOTI = TOTI                                               233578

      ** Get the current principal amount from the history file
     C*****KEY001        SETGT     HISTR                              11                      232628
     C**********         READP     HISTR                                                      232628
     C     KEY001        SETGT     HISTSL0                            11                      232628
     C                   READP     HISTSL0                                                    232628

      ** If found latest action prior to EIR start date,
      **  populate fields and write record to LEEIRPPD
     C**********         IF        NOT %EOF(HISTR) and WBRCA = BRCA and                       232628
     C**********                   WCNUM = CNUM and LNRF = EITRAN                             232628
     C                   IF        NOT %EOF(HISTSL0) AND LNRF = EITRAN                        232628
     C                   EVAL      EPTNMR = EITRAN
     C                   EVAL      EPFLDT = EISTDT

     C                   EVAL      EPCAMT = CPAM
     C                   IF        EPCAMT = 0
     C                   EVAL      EPCAMT = PRAM
     C                   ENDIF
     C                   EVAL      WCAMT = EPCAMT

      ** Incoming/outgoing indicator
     C                   IF        PTYP = 66 OR
     C                             PTYP = 67 OR
     C                             PTYP = 69
     C                   EVAL      EPIOIN = 'I'
     C                   ELSE
     C                   EVAL      EPIOIN = 'O'
     C                   ENDIF

      ** Get No. of days in Interest Year
     C                   MOVE      @ICBS         ZZCALC
     C                   EXSR      SRNDYY
     C                   EVAL      EPNDYY = @NDYY

     C                   Z-ADD     EISTDT        ZZBEG
     C                   Z-ADD     EIENDT        ZZEND
     C                   EXSR      ZINTDY
     C                   Z-ADD     ZZINDY        EPNDEI
     C                   WRITE     ZAEIRPD0

      ** ENDIF of READP HISTR
     C                   ENDIF

      ** Discount
     c                   IF        TOTI <> 0
     C***********        EVAL      EPCAMT = TOTI
     C                   EVAL      EPCAMT = WTOTI
                                                                                             Bug9668
     C                   EVAL      wFDPA = wFDPA + WTOTI                                     Bug9668
                                                                                             Bug9668
      ** Incoming/outgoing indicator
     C                   IF        PTYP = 66 OR
     C                             PTYP = 67 OR
     C                             PTYP = 69
     C                   EVAL      EPIOIN = 'O'
     C                   ELSE
     C                   EVAL      EPIOIN = 'I'
     C                   ENDIF

     C                   WRITE     ZAEIRPD0

     C                   ENDIF

      ** Fees with the EIR period
     C*****LNRF          SETLL     LEFEEDLB                                                   CAS011
     C*****LNRF          READE     LEFEEDLB                                                   CAS011
     C     LNRF          SETLL     LEFEEDLC                                                   CAS011
     C     LNRF          READE     LEFEEDLC                                                   CAS011

      **  Do while EIR start date is equal to EIRA start date and
      **  not end of file, then populate fields and write record to LEEIRPPD
     C**********         DOW       NOT %EOF(LEFEEDLB)                                         CAS011
     C                   DOW       NOT %EOF(LEFEEDLC)                                         CAS011
      *                                                                                       CLE134
     C                   MOVE      FEAUTO        WFEAUT                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   IF        WFEAUT = 'C' OR FEAUT2 = 'C'                               CLE134
     C                   MOVE      'Y'           WFEAUT                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   IF        FEADJY = 'Y' and
     C**********                   FEAUTO = 'Y' and                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FERECI = 'D' and
     C                             FEAMTS <> 0  or
     C                             FEADJY = 'Y' and
     C**********                   FEAUTO = 'Y' and                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FERECI = 'D' and
     C                             FEAMTS = 0 and
     C                             FEDDAT <> 0
     C                             OR FEADJY = 'Y' AND                                        232311
     C**********                   FEAUTO = 'Y' and                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FERECI = 'M' AND                                           232311
     C                             FEAMTS <> 0  OR                                            232311
     C                             FEADJY = 'Y' AND                                           232311
     C**********                   FEAUTO = 'Y' and                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FERECI = 'M' AND                                           232311
     C                             FEAMTS = 0  AND                                            232311
     C                             FEDDAT <> 0                                                232311
     C
     C**********         EVAL      EPFLDT = FEPSTD                                            232628
                                                                                              232628
      ** Only need Fees settled on EIR Start Date                                             232628
                                                                                              232628
     C                   IF           FEPYON = 'S' AND FEPSTD = EISTDT                        232628
     C                             OR FEPYON = ' ' AND FEPSTD = EISTDT                        232628
     C                             OR FEPYON = 'E' AND FEPEND = EISTDT                        232628
                                                                                              232628
     C                   IF        FEPYON = 'E'                                               232628
     C                   EVAL      EPFLDT = FEPEND                                            232628
     C                   ELSE                                                                 232628
     C                   EVAL      EPFLDT = FEPSTD                                            232628
     C                   ENDIF                                                                232628

     C                   IF        FEFCCY = CCY
     C                   IF        FEAMTS <> 0
     C                   EVAL      EPCAMT = FEAMTS
     C                   ELSE
     C                   EVAL      EPCAMT = FEFAMT
     C                   ENDIF
     C                   ELSE
     C     KFSEQ         CHAIN     LEEIRAL4
     C                   IF        %FOUND(LEEIRAL4)
     C                   EVAL      EPCAMT = EAAMNT
     C                   ENDIF
     C                   ENDIF
                                                                                             Bug9668
     C                   EVAL      wFDPA = wFDPA + EPCAMT                                    Bug9668

      ** Incoming/outgoing indicator should be 'I'
     C                   IF        PTYP = 66 OR
     C                             PTYP = 67 OR
     C                             PTYP = 69
     C                   EVAL      EPIOIN = 'O'
     C                   ELSE
     C                   EVAL      EPIOIN = 'I'
     C                   ENDIF
      ** Get No. of days in Interest Year
     C                   MOVE      @ICBS         ZZCALC
     C                   EXSR      SRNDYY
     C                   EVAL      EPNDYY = @NDYY
     C**********         Z-ADD     FEPSTD        ZZBEG                                        232628
     C                   Z-ADD     EPFLDT        ZZBEG                                        232628
     C                   Z-ADD     EIENDT        ZZEND
     C                   EXSR      ZINTDY
     C                   Z-ADD     ZZINDY        EPNDEI

      ** Compute for all paid fees on run date for net principal                              231712
     C                   IF        FERECI <> 'R' AND                                          231712
     C**********                   FEAUTO = 'Y' and                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FEADJY = 'Y'                                               231712
     C                   IF        FESDAT = BJRDNB                                            231712
     C                   EVAL(R)   WAllFeePaidTdy = WAllFeePaidTdy + FEAMTS                   231712
     C                   ENDIF                                                                231712
     C                   IF        FEDDAT = BJRDNB                                            231712
     C                   EVAL(R)   WAllFeePaidTdy = WAllFeePaidTdy + FEAMTO                   231712
     C                   ENDIF                                                                231712
     C                   ENDIF                                                                231712
                                                                                              231712
     C                   WRITE     ZAEIRPD0
     C                   ENDIF                                                                232628
     C                   ENDIF
     C*****LNRF          READE     LEFEEDLB                                                   CAS011
     C     LNRF          READE     LEFEEDLC                                                   CAS011
     C                   ENDDO

     C                   EVAL      EPFLDT = VDAT
      ***Accrued*Interest**********************************************                       231710
     C**********         EVAL      EPCAMT = AIPD + AIAP                                       231710
      ***Interest*Paid/Received*to*date********************************                231710 232628
     C**********         EVAL      EPCAMT = IPRD                                       231710 232628
      ** Accured interest not settled                                                         232628
     C                   EVAL      EPCAMT = AITC - IPRD                                       232628
      ** Incoming/outgoing indicator
     C                   IF        PTYP = 66 OR
     C                             PTYP = 67 OR
     C                             PTYP = 69
     C**********         EVAL      EPIOIN = 'O'                                               232628
     C                   EVAL      EPIOIN = 'I'                                               232628
     C                   ELSE
     C**********         EVAL      EPIOIN = 'I'                                               232628
     C                   EVAL      EPIOIN = 'O'                                               232628
     C                   ENDIF
      ** Get No. of days in Interest Year
     C                   MOVE      @ICBS         ZZCALC
     C                   EXSR      SRNDYY
     C                   EVAL      EPNDYY = @NDYY

     C**********         Z-ADD     VDAT          ZZBEG                                        232628
     C**********         Z-ADD     MDAT          ZZEND                                        232628
     C                   Z-ADD     EISTDT        ZZBEG                                        232628
     C                   Z-ADD     EIENDT        ZZEND                                        232628
     C                   EXSR      ZINTDY
     C                   Z-ADD     ZZINDY        EPNDEI
     C                   IF        EPCAMT <> 0                                                232628
     C                   WRITE     ZAEIRPD0
     C                   ENDIF                                                                232628

      ** Get Amortised to date then write details to LEEIRPPD

      ** Cashflow date
     C**********         EVAL      EPFLDT = EISTDT                                            232630

      ** Cash flow amount
     C**********         EVAL      EPCAMT = EIAMTD                                            231712

      ** Incoming/outgoing indicator
     C**********         IF        PTYP = 66 OR                                               232630
     C**********                   PTYP = 67 OR                                               232630
     C**********                   PTYP = 69                                                  232630
     C**********         EVAL      EPIOIN = 'O'                                               232630
     C**********         ELSE                                                                 232630
     C**********         EVAL      EPIOIN = 'I'                                               232630
     C**********         ENDIF                                                                232630

      ** Number of days in Interest Year
     C**********         EXSR      SRNDYY                                                     232630

      ** Call ZINTDY passing EIR Start and End Date as parameters
      ** for No. of days from end of effectivity period
     C**********         EVAL      ZZBEG = EISTDT                                             232630
     C**********         EVAL      ZZEND = EIENDT                                             232630
     C**********         EXSR      ZINTDY                                                     232630
     C**********         EVAL      EPNDEI = ZZINDY                                            232630

     C**********         WRITE     ZAEIRPD0                                                   232630

      ** Get Fee paid  details then write details to LEEIRPPD

     C     EITRAN        SETLL     LEFHSTL0
     C     EITRAN        READE     LEFHSTL0
     C                   DOW       NOT %EOF(LEFHSTL0)

     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      HIFCOD        PFECD
     C     SDFEE         PARM      SDFEE         DSFDY

     C                   IF        AUADJY = 'Y'

      ** Cashflow date
     C                   EVAL      EPFLDT = HIHDAT

      ** Cash flow amount
     C                   EVAL      EPCAMT = HIAMTS

      ** Incoming/Outgoing Indicator
     C                   EVAL      EPIOIN = 'O'

      ** Number of days in Interest Year
     C                   EXSR      SRNDYY

      ** Call ZINTDY passing EIR Start and End Date as parameters
      ** for No. of days from end of effectivity period
     C                   EVAL      ZZBEG = EISTDT
     C                   EVAL      ZZEND = EIENDT
     C                   EXSR      ZINTDY
     C                   EVAL      EPNDEI = ZZINDY

     C                   IF        EPCAMT <> 0                                                232628
     C                   WRITE     ZAEIRPD0
     C                   ENDIF                                                                232628
     C                   ENDIF

     C     EITRAN        READE     LEFHSTL0

     C                   ENDDO

     C                   ENDSR
     C****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRFutCashFl - Generate Future Cash Flows                     *
      *                                                              *
      ****************************************************************
     C     SRFutCashFl   BEGSR

      ** Get all the future cash flows from cash flows file.

     C     KEY002        SETLL     LECFSFL0
     C     LNRF          READE     LECFSFL0
     C                   DOW       NOT %EOF(LECFSFL0)
     C                             AND LFFLDT <= EIENDT

     C**********         IF        (LFFLDT < EIENDT AND LFFLDT > EISTDT AND                   231710
     C**********                   EISTDT = BJRDNB) OR                                        231710
     C**********                   (LFFLDT < EIENDT AND LFFLDT >= EISTDT AND                  231710
     C**********                   EISTDT <> BJRDNB) OR                                       231710
     C**********         IF        (LFFLDT <= EIENDT AND LFFLDT > EISTDT AND          231710 Bug9668
     C**********                   EISTDT = BJRDNB) OR                                231710 Bug9668
     C**********                   (LFFLDT <= EIENDT AND LFFLDT >= EISTDT AND         231710 Bug9668
     C**********                   EISTDT <> BJRDNB) OR                               231710 Bug9668
     C**********                   (LFFLDT = EIENDT AND LFFLDT > EISTDT AND                  Bug9668
     C**********                   LFFLDT = MDAT)                                            Bug9668
                                                                                             Bug9668
      ** This subroutine writes to ZAEIRFPD (used by EIR Calc and) ZAAMRTPD                  Bug9668
      ** (used by Amort Calc).  Each has specific criteria on which cashflows                Bug9668
      ** to accept.  But for both processing only cash flows within the EIR                  Bug9668
      ** period should be considered.                                                        Bug9668
                                                                                             Bug9668
     C                   IF        LFFLDT >= EISTDT And LFFLDT <= EIENDT                     Bug9668

      ** If cash flow is not an accruing fee, write to LEEIRFPD
     C                   IF        LFFTYP <> 'EFAN' AND LFFTYP <> 'SFAN' AND
     C                             LFFTYP <> 'SFBN'
     C                   IF        LFCAMT <> 0
                                                                                              232628
     C                   IF           LFFTYP = 'SFAM' AND LFFLDT = EIENDT                     232628
     C                             AND LFFLDT <> MDAT                                         232771
     C                             OR LFFTYP = 'EFAC' AND LFFLDT = EIENDT                     232628
     C                             AND LFFLDT <> MDAT                                         232771
     C                             OR LFFTYP = 'SFBT' AND LFFLDT = EIENDT                     232628
     C                             AND LFFLDT <> MDAT                                         232771
      ** Fees settled on rollover date will be amortised on the next EIR                      232628
      ** period.                                                                              232628
     C                   ELSE                                                                 232628
                                                                                              232628
     C                   EVAL      EFTNMR = LFLNRF
     C                   EVAL      EFFLDT = LFFLDT
     C                   EVAL      EFCAMT = LFCAMT

      ** Incoming/outgoing indicator based on event type
     C                   EVAL      EFIOIN = LFIOIN
                                                                                              232628
     C                   IF        LFIOIN = 'S'                                               232628
     C                   EVAL      EFIOIN = 'I'                                               232628
     C                   ENDIF                                                                232628

      ** No. of days in interest year not taken from cash flow file
     C                   MOVE      @ICBS         ZZCALC
     C                   EXSR      SRNDYY
     C                   EVAL      EFNDYY = @NDYY

      ** No. of days from end of effectivity period calculated
      ** based on cash flow date and EIR end date.
     C                   Z-ADD     LFFLDT        ZZBEG
     C                   Z-ADD     EIENDT        ZZEND
     C                   EXSR      ZINTDY
     C                   Z-ADD     ZZINDY        EFNDEI
                                                                                             Bug9668
     C                   IF        LFFLDT > EISTDT                                           Bug9668
                                                                                             Bug9668
     C                   IF        LFFTYP = 'EFAC'                                           Bug9668
     C                             OR LFFTYP = 'SFAM'                                        Bug9668
     C                             OR LFFTYP = 'SFBT'                                        Bug9668
     C                   EVAL      wFDPA = wFDPA + EFCAMT                                    Bug9668
     C                   ENDIF                                                               Bug9668
                                                                                             Bug9668
     C                   WRITE     ZAEIRFD0
                                                                                             Bug9668
     C                   ENDIF                                                               Bug9668
                                                                                              231712
     C                   CLEAR                   ZAAMRT                                       231712
                                                                                              231712
     C**********         IF        EISTDT <> LFFLDT                                    231712 232630
     C**********                   AND LFFLDT <= EILADT                                231712 232630
     C**********                   OR EISTDT <> LFFLDT                                 231712 232630
     C**********                   AND LFFLDT <= (EILADT + 1)                          231712 232630
     C                   IF        LFFLDT <= EILADT                                           232630
     C                             AND LFFTYP <> 'SAMT'                                       232630
     C                             OR LFFLDT <= (EILADT + 1)                                  232630
     C                             AND LFFTYP <> 'SAMT'                                       232630
     C                             AND BKALDI <> 'Y'                                          231712
     C                   EVAL      ZAAMRT = ZAEIRF                                            231712
                                                                                              231712
      ** Set Cashflow types for ZAAMRTCALC                                                    231712
                                                                                              231712
     C                   SELECT                                                               231712
                                                                                              231712
     C                   WHEN      LFFTYP = 'EFAC'                                            231712
     C                             OR LFFTYP = 'SFAM'                                         231712
     C                             OR LFFTYP = 'SFBT'                                         231712
     C                   EVAL      EPCFTP = 'FEEA'                                            231712
                                                                                              231712
      ** If a cashflow written is a fee that is not in Loan Currency,                         231712
      ** obtain the converted amount from LEEIRAPD before writing                             231712
      ** to ZAAMRTPD                                                                          231712
                                                                                              231712
     C                   IF        LFCYCD <> CCY                                              231712
                                                                                              231712
     C     KFSEQ         CHAIN     LEEIRAL4                                                   231712
                                                                                              231712
     C                   IF        %FOUND(LEEIRAL4)                                           231712
     C                   EVAL      WCAMT = EAAMNT                                             231712
     C                   ENDIF                                                                231712
     C                   ENDIF                                                                231712
                                                                                              231712
     C                   WHEN      LFFTYP = 'SPIN'                                            231712
     C                             OR LFFTYP = 'PINC'                                         231712
     C                             OR LFFTYP = 'SSRP'                                         231712
     C                             OR LFFTYP = 'SRPY'                                         231712
     C                             OR LFFTYP = 'SRPA'                                         231712
     C                             OR LFFTYP = 'RPAY'                                         231712
     C                             OR LFFTYP = 'SPTF'                                         231712
     C                             OR LFFTYP = 'PTFA'                                         231712
     C                             OR LFFTYP = 'SPTT'                                         231712
     C                             OR LFFTYP = 'PTTA'                                         231712
     C                   EVAL      EPCFTP = 'PCPL'                                            231712
                                                                                              232628
     C                   WHEN         LFFTYP = 'INTP'                                         232628
     C                             OR LFFTYP = 'SINT'                                         232628
     C                             OR LFFTYP = 'MINT'                                         232628
     C                             OR LFFTYP = 'SMIN'                                         232628
     C                   EVAL      EPCFTP = 'INTP'                                            232628
                                                                                              231712
     C                   OTHER                                                                231712
     C                   EVAL      EPCFTP = *BLANKS                                           231712
     C                   ENDSL                                                                231712
                                                                                              231712
     C                   WRITE     ZAAMRTD0                                                   231712
     C                   ENDIF                                                                231712
      *                                                                                       232628
     C                   ENDIF                                                                232628
      *                                                                                       232628
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     LNRF          READE     LECFSFL0
     C                   ENDDO
                                                                                              232628
      ** Do not need to create a dummy cash flow to close out the EIR                         232628
      ** period.  LE0400 and LE4310 generates shadow rollover cash                            232628
      ** flows for the principal and interest.                                                232628

      ***If*not*yet*end*of*file*and*that*the*previous*record*written*on*the                   232628
      ***future*cash*flow*file*is*not*equal*to*maturity*date,*write********                   232628
      ***a*dummy*maturity*future*cash*flow.********************************                   232628
     C**********         IF        NOT %EOF(LECFSFL0) and LFLNRF = EATRAN and          231710 232628
     C**********         IF        NOT %EOF(LECFSFL0) AND LFLNRF = LNRF AND            231710 232628
     C**********                   LFFLDT <> MDAT                                             232628
      **********                                                                              232628
     C**********         EVAL      EFTNMR = LFLNRF                                            232628
     C**********         EVAL      EFFLDT = EIENDT                                            232628
     C**********         EVAL      EFCAMT = WCAMT                                             232628
      ***Incoming/outgoing indicator                                                          232628
     C**********         IF        PTYP = 66 OR                                               232628
     C**********                   PTYP = 67 OR                                               232628
     C**********                   PTYP = 69                                                  232628
     C**********         EVAL      EPIOIN = 'O'                                               232628
     C**********         ELSE                                                                 232628
     C**********         EVAL      EFIOIN = 'I'                                               232628
     C**********         ENDIF                                                                232628
     C**********         EVAL      EFNDYY = LFNDYY                                            232628
     C**********         Z-ADD     0             EFNDEI                                       232628
     C**********         WRITE     ZAEIRFD0                                                   232628
     C**********         WRITE     ZAAMRTD0                                            231712 232628
     C**********         ENDIF                                                                232628
     C                   ENDSR
      ****************************************************************                        231712
      /EJECT                                                                                  231712
      ****************************************************************                        231712
      * SRCompAMAJ - Compute for amortisation adjustment             *                        231712
      ****************************************************************                        231712
     C     SRCompAMAJ    BEGSR                                                                231712
                                                                                              231712
      ** Set parameter to compute for amortisation for EIR start                              231712
      ** date until last amortisation date.                                                   231712
                                                                                              231712
     C                   EVAL      WkLoanInd  = 'L'                                           232928
     C                   EVAL      WMaturityDate = MDAT                                       233578
     C                   EVAL      WStartDate = EISTDT                                        231712
     C                   EVAL      WEndDate   = EILADT                                        231712
     C**********         EVAL(R)   WTOTI      = TOTI                                   231712 233578
     C                   IF        BKALDI <> 'Y'                                              231712
     C                   EVAL      WAccInd = 'F'                                              231712
     C                   ENDIF                                                                231712
     C                   MOVE      ZZCALC        WIntCalcBasis                                231712
                                                                                              231712
     C                   IF        PTYP = 63 OR PTYP = 65                                     231712
     C                             OR PTYP = 67                                               231712
     C                   EVAL      WProcType = 'D'                                            231712
     C                   ELSE                                                                 231712
     C                   EVAL      WProcType = ' '                                            231712
     C                   ENDIF                                                                231712
                                                                                              231712
      ** Set previous dirty and clean price to zero since amortisation                        231712
      ** being calculated begins at EIR start date                                            231712
     C                   EVAL      WEIPRDP = *ZERO                                            231712
     C                   EVAL      WEIPRCP = *ZERO                                            231712
                                                                                              231712
     C                   MOVEL     ##OX1(5)      MESOVR                                       231712
     C                   CALL      'QCMDEXC'                                                  231712
     C                   PARM                    MESOVR                                       231712
     C                   PARM                    MESLEN                                       231712
                                                                                              231712
     C                   MOVE      PAMORTDS      PAmortDSA                                    231712
                                                                                              231712
      ** Call Amortisation Calculator                                                         231712
     C                   CALLB     'ZAAMRTCALC'                                               231712
     C                   PARM                    PAmortDSA                                    231712
                                                                                              231712
     C                   MOVEL     PAmortDSA     PAMORTDS                                     231712
                                                                                              231712
     C                   MOVEL     ##OX1(6)      MESOVR                                       231712
     C                   CALL      'QCMDEXC'                                                  231712
     C                   PARM                    MESOVR                                       231712
     C                   PARM                    MESLEN                                       231712
                                                                                              231712
      ** Set dirty and clean price                                                            231712
     C                   EVAL(R)   EICPTD = PClnPrcTdy                                        231712
     C                   EVAL(R)   EIDPTD = PDrtPrcTdy                                        231712
     C                   EVAL      EIPRCP = 0                                                 232630
     C                   EVAL      EIPRDP = 0                                                 232630
                                                                                              231712
      ** Set Last date of amortisation to run date and Amortisation                           231712
      ** adjustment to the difference of the calculated amortisation                          231712
      ** and the current amortisation amount to date                                          231712
     C                   EVAL      EIAMAJ = WAmrtAmt                                          231712
                                                                                              231712
     C                   ENDSR                                                                231712
      ****************************************************************                        231712
      /EJECT
      ****************************************************************
      * SREIRUpdate - Update EIR file details                        *
      ****************************************************************
     C     SREIRUpdate   BEGSR

     C                   EVAL      EIEIR = POutEIR
     C                   EVAL      EIFDPA = wFDPA                                            Bug9668

      ** Reset the EIR recalculation indicator of all records for
      ** recalculation

     C                   EVAL      EIRCAL = *BLANKS

      ** Update EIR record
     C                   IF        EIRECI = 'D'
     C                             OR EIRECI ='T'                                             232628
     C                   UPDATE    LEEIRDD0
     C                   ELSE
     C                   UPDATE    LEEIRHD0
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRNDYY - Determine No. of Days in Interest Year               *
      *****************************************************************
     C     SRNDYY        BEGSR

      ** If No. of Days in a Year in Hedging ICD is blank, use
      ** the common processing in Midas which are the following.
     C                   IF        FSNDYR = *BLANKS
      ** Calculation Methods are:
     C                   SELECT

      ** 1  Actual/365
      ** 4  365/365 (excluding 29/02)
     C                   WHEN      @ICBS = 1 or @ICBS = 4
     C                   Z-ADD     365           @NDYY

      ** 2  Actual/360
      ** 3  360/360 (sometimes called 30/360)
      ** 5  365/360 (excluding 29/02)
     C                   WHEN      @ICBS = 2 or @ICBS = 3 or
     C                             @ICBS = 5
     C                   Z-ADD     360           @NDYY

      ** 6  Actual/366
     C                   WHEN      @ICBS = 6
     C                   Z-ADD     366           @NDYY
     C                   ENDSL

     C                   ELSE

     C                   MOVE      FSNDYR        @NDYY
     C                   SELECT
     C                   WHEN      @NDYY  = 360
     C                   EVAL      ZZCALC = '3'
     C                   WHEN      @NDYY  = 365
     C                   EVAL      ZZCALC = '4'
     C                   WHEN      @NDYY  = 366
     C                   EVAL      ZZCALC = '6'
     C                   ENDSL

     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      * SREIRCalc - Calculate EIR                                     *
      *****************************************************************
     C     SREIRCalc     BEGSR

     C                   MOVEL     ##OX1(1)      MESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    MESOVR
     C                   PARM                    MESLEN

     C                   MOVEL     ##OX1(2)      MESOVR

      * Override ZAEIRFPD
     C                   CALL      'QCMDEXC'
     C                   PARM                    MESOVR
     C                   PARM                    MESLEN

     C                   EVAL      PInpTNRF = EITRAN
     C                   EVAL      PInpStartEff = EISTDT
     C                   EVAL      PInpEndEff   = EIENDT
     C                   EVAL      POutEIR      = *ZERO
     C                   EVAL      PReturnCode  = *BLANKS

     C**********         CALL      'ZAEIRCALC'                                                262654
     C                   CALLB     'ZAEIRCALC'                                                262654

      ** Input Parameter
     C                   PARM                    PInpTNRF
     C                   PARM                    PInpStartEff
     C                   PARM                    PInpEndEff

      ** Output Parameter
     C                   PARM                    POutEIR
     C                   PARM                    PReturnCode

     C                   MOVEL     ##OX1(3)      MESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    MESOVR
     C                   PARM                    MESLEN

     C                   MOVEL     ##OX1(4)      MESOVR

      * Override ZAEIRFPD
     C                   CALL      'QCMDEXC'
     C                   PARM                    MESOVR
     C                   PARM                    MESLEN
                                                                                              231712
      ** Save Effective Interest Rate for Adjustment Computation                              231712
     C                   EVAL      WEffIntRate = POutEIR                                      231712

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      **  Program Parameters

      ** Key list for accessing History File
     C     KEY001        KLIST
     C**********         KFLD                    WBRCA                                        232628
     C**********         KFLD                    WCNUM                                        232628
     C                   KFLD                    WLNRF
     C                   KFLD                    WSTDT

     C     KEY002        KLIST
     C                   KFLD                    EITRAN
     C                   KFLD                    EISTDT

     C     KLOAN         KLIST
     C                   KFLD                    EITRAN
     C                   KFLD                    WRCDT
     C     KFEE          KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFACL
     C                   KFLD                    EATRAN
     C                   KFLD                    EAFSEQ

     C     KFSEQ         KLIST
     C                   KFLD                    EITRAN
     C                   KFLD                    FEFSEQ

      * Override ZAEIRPPD
     C                   Z-ADD     56            MESLEN


      ** Access Bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   END

      ** Access Module Details
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   END
     C                   EVAL      WRCDT = 'A'

      ** Access Midas SD Hedging ICD File

     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDHEDG        PARM      SDHEDG        DSFDY

      ** Database Error

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBFILE =  'SDHEDGPD'
     C                   EVAL      DBASE  =  3
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              231712
      ** Access General Ledger details                                                        231712
     C**********         CALL      'AOGELRR0'                                          231712 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       @RTCD                                        231712
     C                   PARM      '*FIRST '     @OPTN                                        231712
     C*****SDGELR        PARM      SDGELR        DSFDY                                 231712 CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
                                                                                              231712
      ** Database error                                                                       231712
     C                   IF        @RTCD <> *BLANKS                                           231712
     C     *LOCK         IN        LDA                                                        231712
     C                   EVAL      DBFILE =  'SDGELRPD'                                       231712
     C                   EVAL      DBKEY  =  '*FIRST'                                         231712
     C                   EVAL      DBASE  =  262                                              231712
     C                   OUT       LDA                                                        231712
     C                   EXSR      *PSSR                                                      231712
     C                   ENDIF                                                                231712
      *                                                                                       CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
      *                                                                                       CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVE      'Y'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * ZINTDY - Call ZINTDY module for no. of days calculation       *
      *          for a given start and end date and calculation       *
      *          basis.                                               *
      *****************************************************************
     C     ZINTDY        BEGSR
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeOut
     C                   PARM                    ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
     C                   PARM                    INT6DY                                       242286
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     '*ERROR '     ReturnCode
     C                   MOVEL     'LE004610 '   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP

      **  Terminate the program
     C                   RETURN
      *
     C                   ENDSR
     C****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ** Two Commands added to array ##OX1                                                    231712
**  CPY@
(c) Finastra International Limited 2004
** ##OX1
OVRDBF FILE(ZAEIRPL0) TOFILE(LEEIRPL0) SEQONLY(*YES 500)
OVRDBF FILE(ZAEIRFL0) TOFILE(LEEIRFL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAEIRPL0)
DLTOVR FILE(ZAEIRFL0)
OVRDBF FILE(ZAAMRTL0) TOFILE(LEAMRTL0) SEQONLY(*YES 500)                                      231712
DLTOVR FILE(ZAAMRTL0)                                                                         231712
