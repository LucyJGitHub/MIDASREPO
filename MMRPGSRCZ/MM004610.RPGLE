     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Effective Interest Rate Details Update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  MM004610 - Midas MM Efective Interest Rate Details Update    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *    
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CDL093             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 262654             Date 11May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14386           Date 25Jul07               *
      *                 BUG13385A          Date 21Mar07               *
      *                 BUG13385           Date 05Mar07               *
      *                 BUG12989B          Date 27Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG12955           Date 19Jan07               *
      *                 BUG12989           Date 12Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 BUG12682           Date 16Nov06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9667            Date 29Dec05               *
      *                 BUG9473            Date 06Dec05               *
      *                 233545             Date 18May05               *
      *                 232928             Date 08Apr05               *
      *                 233612             Date 20May05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  262654 - Enlarge EIR output field to match size of EIR       *
      *           field on LE and MM files.                           *
      *  BUG14386  - Attempt to divide by zero in ZAEIRCALC           *
      *  BUG13385A - Amortised Cost has a discrepancy equal to fee    *
      *              amount                                           *
      *  BUG13385  - Amortised F/D/P to date on amended deal did not  *
      *              change from the previous day.                    *
      *  BUG12989B - Include historic fee amount of deal during re-   *
      *              calculation of EIR.                              *
      *  BUG12955 - Do not include non adjustment to yield fees in    *
      *             EIR Cash flow report.                             *
      *  BUG12989 - Incorrect EIR rate and amortised F/D/P due to     *
      *             early maturity.                                   *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  BUG12682 - MMC004600 00001 failed (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9667 - Update Amortising Fees for the period.             *
      *  BUG9473 - Use Discount amount (DISA) instead of Discount     *
      *            amount to date (DSAM).                             *
      *  233545 - Cut-off Date (Recompile)                            *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  233612 - Stop Accruals processing to be included in          *
      *           Nonlinear amortisation computation                  *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      ** Midas MM Effective Interest Rate Details File
     FMMEIRDL3  UF   E           K DISK    INFSR(*PSSR)

      ** Midas MM Deals File
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
     F                                     INFDS(FSDS)                                       BUG9473

      ** Midas MM Cash Flows by MFDLNO and MFDATE
     FMMCFLSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMCFLSD0 : MMCFLSD1)

      ** Midas LE Effective Interest Rate Amortisation file
     FMMEIRAL3  IF   E           K DISK    INFSR(*PSSR)

      ** Midas DL Fees History File
     FDLFHSTL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas MM Cash Flows
     FMMCFSFL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas DL Fees File
     FDLFEEDLA  IF   E           K DISK    INFSR(*PSSR)

      ** Midas MM EIR Present Cash Flows
     FMMEIRPL0  UF A E           K DISK    INFSR(*PSSR)
     F*                                    RENAME(MMEIRPD0 : ZAEIRPD0)

      ** Midas MM EIR Future Cash Flows
     FMMEIRFL0  UF A E           K DISK    INFSR(*PSSR)
     F*                                    RENAME(MMEIRFD0 : ZAEIRFD0)

      ** Midas LE Cashflows File for Amortisation Calc                                        232928
     FMMAMRTL0  UF A E           K DISK    INFSR(*PSSR)                                       232928
                                                                                              232928
     FMMHISTL0  IF   E           K DISK    INFSR(*PSSR)                                       232928
     F                                     PREFIX(HD)                                         232928
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Layout for the RUNDAT data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CAS011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAS011

      ** Fee Codes Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Hedging ICD Details
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)

      ** ZAEIRF Data Structure                                                                232928
     D ZAEIRF        E DS                  EXTNAME(ZAEIRFPD)                                  232928
                                                                                              232928
      ** ZAAMRT Data Structure                                                                232928
     D ZAAMRT        E DS                  EXTNAME(ZAAMRTPD)                                  232928
                                                                                              232928
     ** File Status Data Structure                                                           BUG9473
     D FSDS            DS                                                                    BUG9473
     D  FREC             *RECORD                                                             BUG9473
                                                                                             BUG9473
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for access objects

     D PRTCD           S              7
     D POPTN           S              7
     D*PFECD****       S              2  0                                                  BUG12989
     D PFECD           S              2                                                     BUG12989

      ** Parameters for ZINTDY

     D PRetCodeOut     S             10
     D ZZINDY          S              5  0
     D ZZBEG           S              5  0
     D ZZEND           S              5  0
     D ZZCALC          S              1
     D INT6DY          S             15  9                                                    242286

      ** Parameters for ZAEIRCALC

     D PInpTNRF        S              6S 0
     D PInpStartEff    S              5  0
     D PInpEndEff      S              5  0
     D*POutEIR**       S             14 12                                                    262654
     D POutEIR         S             15P10                                                    262654
     D PReturnCode     S              7

     D WEvCtlDt        S              5  0

      ** Override SDBRSHL0
     D CMDLEN          S             15  5 INZ(80)
     D***CMD             S             80    DIM(4) CTDATA PERRCD(1)                          232928
     D CMD             S             80    DIM(8) CTDATA PERRCD(1)                            232928

     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CDL093
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
     D WAllFeePaidTdy  S             17P 0                                                    232928
                                                                                              232928
      ** ZAAMRTCALC Parameter (Alpha)                                                         232928
     D PAmortDSA       S            200A                                                      232928
                                                                                              232928
      ** ZAAMRTCALC DS breakdown                                                              232928
     D PAmortDS        DS           200                                                       232928
     D  PPGMName                     10A   INZ('MM004610')                                    232928
     D  WEffIntRate                  15P10                                                    232928
     D  EISTDT                        5P 0                                                    232928
     D  EIENDT                        5P 0                                                    232928
     D  DLNO                          6S 0                                                    232928
     D  PMaturityDate                 5P 0                                                    233578
     D  WStartDate                    5P 0                                                    232928
     D  WEndDate                      5P 0                                                    232928
     D  WkDisc                       13P 0                                                    232928
     D  WAccInd                       1A   INZ('L')                                           232928
     D  WEIPRDP                      15P 0                                                    232928
     D  WEIPRCP                      15P 0                                                    232928
     D  WIntCalcBasis                 1P 0                                                    232928
     D  WProcType                     1A                                                      232928
     D  WkLoanDepI                    1A                                                      232928
     D  PStopAccrualF                 1A                                                      233612
     D  WAmrtAmt                     17P 0                                                    232928
     D  PDrtPrcTdy                   15P 0                                                    232928
     D  PClnPrcTdy                   15P 0                                                    232928
                                                                                              232928
     D HDLNRF2         S              6P 0                                                    CLE148
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CDL093
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************

     C     *LOVAL        SETLL     MMEIRDL3
     C                   READ      MMEIRDL3
     C                   DOW       NOT %EOF(MMEIRDL3)

      ** Access Deals file to get deal's details

     C                   EXSR      SRDEALS

      ** Generate Present Cash Flows

     C                   EXSR      SRPresentCF

      ** Generate Future Cash Flows

     C                   EXSR      SRFutureCF

      ** Calculate EIR

     C                   EXSR      SREIRCalc

      ** Reset EIR recalculation indicator

     C                   EVAL      EIRCAL = *BLANKS

      ** Compute for Amortisation adjustment if last amortisation                             232928
      ** date is not *ZERO                                                                    232928
     C                   IF        EILADT <> *ZERO                                            232928
     C                   EXSR      SRCompAMAJ                                                 232928
     C                   ENDIF                                                                232928
                                                                                              232928
      ** Update Files

     C                   EXSR      SRUpdate

      ** Read next record of EIR Details

     C                   READ      MMEIRDL3

     C                   ENDDO

      **   Exit from program

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEALS - Access Deals file to get deal's details             *
      *                                                               *
      *****************************************************************
     C     SRDEALS       BEGSR

     C     EITRAN        CHAIN     DEALS                                01

     C                   IF        *IN01 = *ON
     C                   EVAL      DBKEY = @OPTN
     C                   MOVE      EITRAN        DBKEY
     C                   EVAL      DBFILE = 'DEALS'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         EVAL      EPTNMR = EITRAN                                            CLE148
     C**********         EVAL      EFTNMR = EITRAN                                            CLE148
     C                   MOVEL     EITRAN        EPTNMR                                       CLE148
     C                   MOVEL     EITRAN        EFTNMR                                       CLE148
                                                                                             BUG9667
      ** Fees and Discounts/Premiums Amortising this EIR period                              BUG9667
                                                                                             BUG9667
     C     *LIKE         DEFINE    EIFDPA        WFDPA                                       BUG9667
     C                   EVAL      wFDPA = 0                                                 BUG9667

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPresentCF - Generate present cash flows. Present cash flow  *
      *               consist of Current Principal, Fee Paid(s),      *
      *               Accrued Interest and Amortised to date          *
      *                                                               *
      *****************************************************************
     C     SRPresentCF   BEGSR

      ** Get current principal then write details to MMEIRPPD

     C*****KRUND         SETLL     MMCFLSL0                                                   232928
     C*****EITRAN        READE     MMCFLSL0                               01                  232928
     C*****KRUND         SETLL     MMCFLSL0                                                   232928
     C*****EITRAN        READPE    MMCFLSL0                                                   232928
     C**********         IF        NOT %EOF(MMCFLSL0) OR *IN01 = *OFF                         232928
                                                                                              232928
     C*****KEY001        SETGT     MMHISTL0                                            232928 CLE148
     C                   MOVEL     EITRAN        WTRAN2                                       CLE148
     C     KEY002        SETGT     MMHISTL0                                                   CLE148
     C                   READP     MMHISTL0                                                   232928
     C**********         IF        NOT %EOF(MMHISTL0) AND HDLNRF = EITRAN              232928 CLE148
     C                   MOVEL     HDLNRF        HDLNRF2                                      CLE148
     C                   IF        NOT %EOF(MMHISTL0) AND HDLNRF2 = EITRAN                    CLE148

      ** Cashflow date
     C                   EVAL      EPFLDT = EISTDT

      ** Cash flow amount
     C**********         EVAL      EPCAMT = MFCPAM                                            232928
     C                   EVAL      EPCAMT = HDCPAM                                            232928

      ** Incoming/Outgoing Indicator
     C                   IF        DTYP = 'IT' OR DTYP = 'TD' OR
     C                             DTYP = 'CI' OR DTYP = 'CD'
     C                   EVAL      EPIOIN = 'I'
     C                   ELSE
     C                   EVAL      EPIOIN = 'O'
     C                   ENDIF

      ** Number of days in Interest Year
     C                   EXSR      SRNDYY

      ** Call ZINTDY passing EIR Start and End Date as parameters
      ** for No. of days from end of effectivity period
     C                   EVAL      ZZBEG = EISTDT
     C                   EVAL      ZZEND = EIENDT
     C                   EXSR      SRZINTDY
     C                   EVAL      EPNDEI = ZZINDY

     C                   WRITE     ZAEIRPD0

     C                   IF        RCDT = 'D'
     C                             AND DISA <> 0
      ** Cash flow amount
     C                   EVAL      EPCAMT = DISA
                                                                                             BUG9667
     C                   EVAL      wFDPA = wFDPA + DISA                                      BUG9667

      ** Incoming/Outgoing Indicator
     C                   IF        DTYP = 'IT' OR DTYP = 'TD' OR
     C                             DTYP = 'CI' OR DTYP = 'CD'
     C                   EVAL      EPIOIN = 'O'
     C                   ELSE
     C                   EVAL      EPIOIN = 'I'
     C                   ENDIF

     C                   WRITE     ZAEIRPD0
     C                   ENDIF

     C                   ENDIF

      ** Get Fee paids details then write details to MMEIRPPD

     C     EITRAN        SETLL     DLFEEDLA
     C     EITRAN        READE     DLFEEDLA                               02

     C                   DOW       *IN02 = *OFF

      ** Do only adjustment to yield fees
     C                   IF        DFRECI = 'D' AND DFADJY = 'Y'
     C                             OR DFRECI = 'M' AND DFADJY = 'Y'                           232928

      ** Cashflow date
                                                                                              232928
      ** Only need Fees settled on EIR Start Date                                             232928
                                                                                              232928
     C                   IF           DFPYON = 'S' AND DFPSTD = EISTDT                        232928
     C                             OR DFPYON = ' ' AND DFPSTD = EISTDT                        232928
     C                             OR DFPYON = 'E' AND DFPEND = EISTDT                        232928
                                                                                              232928
     C                   IF        DFPYON = 'E'                                               232928
     C                   EVAL      EPFLDT = DFPEND                                            232928
     C                   ELSE                                                                 232928
     C                   EVAL      EPFLDT = DFPSTD
     C                   ENDIF                                                                232928

      ** Cash flow amount
     C                   IF        DFFCCY = CCY
     C                   EVAL      EPCAMT = DFFAMT
     C                   ELSE
     C     KFSEQ         CHAIN     MMEIRAL3
     C                   IF        %FOUND(MMEIRAL3)
     C                   EVAL      EPCAMT = EAAMNT
     C                   ENDIF
     C                   ENDIF
                                                                                             BUG9667
     C                   EVAL      wFDPA = wFDPA + EPCAMT                                    BUG9667

      ** Incoming/Outgoing Indicator
     C                   IF        DFDTYP = 'IT' OR DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR DFDTYP = 'CD'
     C                   EVAL      EPIOIN = 'O'
     C                   ELSE
     C                   EVAL      EPIOIN = 'I'
     C                   ENDIF

      ** Number of days in Interest Year
     C                   EXSR      SRNDYY

      ** Call ZINTDY passing Fee Start and End Date as parameters
      ** for No. of days from end of effectivity period
     C**********         EVAL      ZZBEG = DFPSTD                                             232928
     C                   EVAL      ZZBEG = EPFLDT                                             232928
     C                   EVAL      ZZEND = EIENDT
     C                   EXSR      SRZINTDY
     C                   EVAL      EPNDEI = ZZINDY

      ** Compute for all paid fees on run date for net principal                              232928
     C                   IF        DFRECI <> 'R' AND                                          232928
     C                             DFADJY = 'Y'                                               232928
     C                   IF        DFSDAT = BJRDNB                                            232928
     C                   EVAL(R)   WAllFeePaidTdy = WAllFeePaidTdy + DFAMTS                   232928
     C                   ENDIF                                                                232928
     C                   IF        DFLDAT = BJRDNB                                            232928
     C                   EVAL(R)   WAllFeePaidTdy = WAllFeePaidTdy + DFAMTO                   232928
     C                   ENDIF                                                                232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   WRITE     ZAEIRPD0

     C                   ENDIF                                                                232928
     C                   ENDIF

     C     EITRAN        READE     DLFEEDLA                               02
     C                   ENDDO

      ** Get accrued interest then write details to MMEIRPPD

      ** Cashflow date
     C                   EVAL      EPFLDT = VDAT

      ** Cash flow amount
     C**********         EVAL      EPCAMT = AIPD + AIAP                                       232928
      ** Accured interest not settled                                                         232928
     C                   EVAL      EPCAMT = HDAITC - HDIPRD                                   232928

      ** Incoming/Outgoing Indicator
     C                   IF        DTYP = 'IT' OR DTYP = 'TD' OR
     C                             DTYP = 'CI' OR DTYP = 'CD'
     C**********         EVAL      EPIOIN = 'O'                                               232928
     C                   EVAL      EPIOIN = 'I'                                               232928
     C                   ELSE
     C**********         EVAL      EPIOIN = 'I'                                               232928
     C                   EVAL      EPIOIN = 'O'                                               232928
     C                   ENDIF

      ** Number of days in Interest Year
     C                   EXSR      SRNDYY

      ** Call ZINTDY passing EIR Start and End Date as parameters
      ** for No. of days from end of effectivity period
     C**********         EVAL      ZZBEG = VDAT                                               232928
     C**********         EVAL      ZZEND = MDAT                                               232928
     C                   EVAL      ZZBEG = EISTDT                                             232928
     C                   EVAL      ZZEND = EIENDT                                             232928
     C                   EXSR      SRZINTDY
     C                   EVAL      EPNDEI = ZZINDY

     C                   IF        EPCAMT <> 0                                                232928
     C                   WRITE     ZAEIRPD0
     C                   ENDIF                                                                232928

      ***Get*Amortised to date then write details to MMEIRPPD                                 232928
      **********                                                                              232928
      ***Cashflow date                                                                        232928
     C**********         EVAL      EPFLDT = EISTDT                                            232928
      **********                                                                              232928
      ***Cash*flow amount                                                                     232928
     C**********         EVAL      EPCAMT = EIAMTD                                            232928
      **********                                                                              232928
      ***Incoming/Outgoing Indicator                                                          232928
     C**********         IF        DTYP = 'IT' OR DTYP = 'TD' OR                              232928
     C**********                   DTYP = 'CI' OR DTYP = 'CD'                                 232928
     C**********         EVAL      EPIOIN = 'O'                                               232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      EPIOIN = 'I'                                               232928
     C**********         ENDIF                                                                232928
      **********                                                                              232928
      ***Number*of days in Interest Year                                                      232928
     C**********         EXSR      SRNDYY                                                     232928
      **********                                                                              232928
      ***Call*ZINTDY passing EIR Start and End Date as parameters                             232928
      ***for*No. of days from end of effectivity period                                       232928
     C**********         EVAL      ZZBEG = EISTDT                                             232928
     C**********         EVAL      ZZEND = EIENDT                                             232928
     C**********         EXSR      SRZINTDY                                                   232928
     C**********         EVAL      EPNDEI = ZZINDY                                            232928
      **********                                                                              232928
     C**********         WRITE     ZAEIRPD0                                                   232928

      ** Get Fee paids details then write details to MMEIRPPD

     C     EITRAN        SETLL     DLFHSTL0
     C     EITRAN        READE     DLFHSTL0                               04
     C                   DOW       *IN04 = *OFF

     C                   MOVE      HIFCOD        PFECD                                     BUG12989
      *                                                                                    BUG12989
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C**********         PARM      HIFCOD        PFECD                                     BUG12989
     C                   PARM                    PFECD                                     BUG12989
     C     SDFEE         PARM      SDFEE         DSFDY

     C                   IF        AUADJY = 'Y'

      ** Cashflow date
     C                   EVAL      EPFLDT = HIHDAT

      ** Cash flow amount
     C                   EVAL      EPCAMT = HIAMTS

      ** Incoming/Outgoing Indicator
     C**********         IF        DFDTYP = 'IT' OR DFDTYP = 'TD' OR             BUG12989   BUG13385
     C**********                   DFDTYP = 'CI' OR DFDTYP = 'CD'                BUG12989   BUG13385
     C                   IF        DTYP = 'IT' OR DTYP = 'TD' OR                            BUG13385
     C                             DTYP = 'CI' OR DTYP = 'CD'                               BUG13385
     C                   EVAL      EPIOIN = 'O'
     C                   ELSE                                                               BUG12989
     C                   EVAL      EPIOIN = 'I'                                             BUG12989
     C                   ENDIF                                                              BUG12989

      ** Number of days in Interest Year
     C                   EXSR      SRNDYY

      ** Call ZINTDY passing EIR Start and End Date as parameters
      ** for No. of days from end of effectivity period
     C                   EVAL      ZZBEG = EISTDT
     C                   EVAL      ZZEND = EIENDT
     C                   EXSR      SRZINTDY
     C                   EVAL      EPNDEI = ZZINDY

     C                   IF        EIRCAL = 'Y'                                            BUG12989B
     C                   EVAL      wFDPA = wFDPA + EPCAMT                                  BUG12989B
     C                   ENDIF                                                             BUG12989B
     C                   IF        EPCAMT <> 0                                                232928
     C                   WRITE     ZAEIRPD0
     C                   ENDIF                                                                232928
     C                   ENDIF

     C     EITRAN        READE     DLFHSTL0                               04

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNDYY - Get number of days in Interest Year                  *
      *                                                               *
      *****************************************************************
     C     SRNDYY        BEGSR

      ** If FSNDYR from SDHEDGPD is blank

     C                   IF        FSNDYR = *BLANKS
     C                   SELECT
     C                   WHEN      ICBS = 1 OR ICBS = 4
     C                   EVAL      EPNDYY = 365
     C                   WHEN      ICBS = 2 OR ICBS = 3 OR
     C                             ICBS = 5
     C                   EVAL      EPNDYY = 360
     C                   OTHER
     C                   EVAL      EPNDYY = 366
     C                   ENDSL
     C                   MOVE      ICBS          ZZCALC

     C                   ELSE

     C                   MOVE      FSNDYR        EPNDYY
     C                   SELECT
     C                   WHEN      EPNDYY = 360
     C                   EVAL      ZZCALC = '3'
     C                   WHEN      EPNDYY = 365
     C                   EVAL      ZZCALC = '4'
     C                   WHEN      EPNDYY = 366
     C                   EVAL      ZZCALC = '6'
     C                   ENDSL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFutureCF - Generate future cash flows                       *
      *                                                               *
      *****************************************************************
     C     SRFutureCF    BEGSR

     ** Get the current principal amount from the history file

     C*****KRUND         SETGT     MMCFSFL0                                                   232928
     C**********         READP     MMCFSFL0                               03                  232928
                                                                                              232928
     C*****KEY001        SETGT     MMCFSFL0                                         232928 BUG13385A
     C***********        READ      MMCFSFL0                               03        232928 BUG13385A

     C**********         DOW       *IN03 = *OFF AND MFFLDT < EIENDT                           232928
     C**********         DOW       *IN03 = *OFF AND MFFLDT <= EIENDT                232928 BUG13385A
     C**********                   AND MFFLDT >= EISTDT AND MFDLNO = EITRAN                BUG13385A
     C**********                   OR MFFLDT = MDAT AND MFFLDT = EIENDT AND                BUG13385A
     C**********                   *IN03 = *OFF AND MFDLNO = EITRAN                        BUG13385A
                                                                                           BUG13385A
     C     KEY001        SETLL     MMCFSFL0                                                BUG13385A
     C     EITRAN        READE     MMCFSFL0                                                BUG13385A
     C                   DOW       NOT %EOF(MMCFSFL0)                                      BUG13385A
     C                             AND MFFLDT <= EIENDT                                    BUG13385A
                                                                                           BUG13385A
      ** This subroutine writes to ZAEIRFPD (used by EIR Calc and) ZAAMRTPD                BUG13385A
      ** (used by Amort Calc).  Each has specific criteria on which cashflows              BUG13385A
      ** to accept.  But for both processing only cash flows within the EIR                BUG13385A
      ** period should be considered.                                                      BUG13385A
                                                                                           BUG13385A
     C                   IF        MFFLDT >= EISTDT And MFFLDT <= EIENDT                   BUG13385A
     C                             AND (EIENDT - EISTDT) <> 0                               BUG14386
                                                                                           BUG13385A
      ** If cash flow is not an accruing fee or start amount, write to MMEIRFPD            BUG13385A
     C                   IF        MFFTYP <> 'EFAN' AND                                     BUG12955
     C                             MFFTYP <> 'SFAN' AND                                     BUG12955
     C**********                   MFFTYP <> 'SFBN'                               BUG12955 BUG13385A
     C                             MFFTYP <> 'SFBN' AND                                    BUG13385A
     C                             MFFTYP <> 'SAMT'                                        BUG13385A
     C**********         IF        MFFLDT <> VDAT                                          BUG13385A

     C                   EVAL      EFFLDT = MFFLDT
     C                   EVAL      EFCAMT = MFCAMT

      ** Incoming/Outgoing

     C                   EVAL      EFIOIN = MFIOIN
                                                                                              232928
     C                   IF        MFIOIN = 'S'                                               232928
     C                   EVAL      EFIOIN = 'I'                                               232928
     C                   ENDIF                                                                232928

      ** No. of days in interest year
      ** No. of days from end of effectivity period

     C                   EVAL      EFNDYY = MFNDYY
     C                   EVAL      ZZBEG = MFFLDT
     C                   EVAL      ZZEND = EIENDT
     C                   MOVE      ICBS          ZZCALC
     C                   EXSR      SRZINTDY
     C                   EVAL      EFNDEI = ZZINDY
                                                                                             BUG9667
     C                   IF        MFFLDT > EISTDT                                         BUG13385A
     C                   IF        MFFTYP = 'EFAC'                                           BUG9667
     C                             OR MFFTYP = 'SFAM'                                        BUG9667
     C                             OR MFFTYP = 'SFBT'                                        BUG9667
     C                   EVAL      wFDPA = wFDPA + EFCAMT                                    BUG9667
     C                   ENDIF                                                               BUG9667
     C                   ENDIF                                                             BUG13385A

     C                   WRITE     ZAEIRFD0
                                                                                              232928
     C                   CLEAR                   ZAAMRT                                       232928
                                                                                              232928
     C                   IF        MFFLDT <= EILADT                                           232928
     C                             AND MFFTYP <> 'SAMT'                                       232928
     C                             OR MFFLDT <= (EILADT + 1)                                  232928
     C                             AND MFFTYP <> 'SAMT'                                       232928
     C                             AND BKALDI <> 'Y'                                          232928
     C                   EVAL      ZAAMRT = ZAEIRF                                            232928
                                                                                              232928
      ** Set Cashflow types for ZAAMRTCALC                                                    232928
                                                                                              232928
     C                   SELECT                                                               232928
                                                                                              232928
     C                   WHEN      MFFTYP = 'EFAC'                                            232928
     C                             OR MFFTYP = 'SFAM'                                         232928
     C                             OR MFFTYP = 'SFBT'                                         232928
     C                   EVAL      EPCFTP = 'FEEA'                                            232928
                                                                                              232928
     C                   WHEN      MFFTYP = 'SPIN'                                            232928
     C                             OR MFFTYP = 'PINC'                                         232928
     C                             OR MFFTYP = 'PDEC'                                         232928
     C                             OR MFFTYP = 'SSRP'                                         232928
     C                             OR MFFTYP = 'SRPY'                                         232928
     C                             OR MFFTYP = 'SRPA'                                         232928
     C                             OR MFFTYP = 'RPAY'                                         232928
     C                             OR MFFTYP = 'SPTF'                                         232928
     C                             OR MFFTYP = 'PTFA'                                         232928
     C                             OR MFFTYP = 'SPTT'                                         232928
     C                             OR MFFTYP = 'PTTA'                                         232928
     C                   EVAL      EPCFTP = 'PCPL'                                            232928
                                                                                              232928
     C                   WHEN         MFFTYP = 'INTP'                                         232928
     C                             OR MFFTYP = 'SINT'                                         232928
     C                             OR MFFTYP = 'MINT'                                         232928
     C                             OR MFFTYP = 'SMIN'                                         232928
     C                   EVAL      EPCFTP = 'INTP'                                            232928
                                                                                              232928
     C                   OTHER                                                                232928
     C                   EVAL      EPCFTP = *BLANKS                                           232928
     C                   ENDSL                                                                232928
                                                                                              232928
     C                   WRITE     ZAAMRTD0                                                   232928
     C                   ENDIF                                                                232928
     C                   ENDIF
     C                   ENDIF                                                              BUG12955

     C**********         READ      MMCFSFL0                               03
     C     EITRAN        READE     MMCFSFL0
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREIRCalc - Calculate EIR by calling EIR Calculator           *
      *                                                               *
      *****************************************************************
     C     SREIRCalc     BEGSR

      * Override ZAEIRFPD and ZAEIRPPD

     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD(1)
     C                   PARM                    CMDLEN

     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD(2)
     C                   PARM                    CMDLEN

     C                   CALL      'ZAEIRCALC'
     C                   PARM      EITRAN        PInpTNRF
     C                   PARM      EISTDT        PInpStartEff
     C                   PARM      EIENDT        PInpEndEff
     C                   PARM                    POutEIR
     C                   PARM                    PReturnCode

     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD(3)
     C                   PARM                    CMDLEN

     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD(4)
     C                   PARM                    CMDLEN
                                                                                              232928
      ** Save Effective Interest Rate for Adjustment Computation                              232928
     C                   EVAL      WEffIntRate = POutEIR                                      232928

     C                   ENDSR
      ****************************************************************                        232928
      /EJECT                                                                                  232928
      ****************************************************************                        232928
      * SRCompAMAJ - Compute for amortisation adjustment             *                        232928
      ****************************************************************                        232928
     C     SRCompAMAJ    BEGSR                                                                232928
                                                                                              232928
      ** Set parameter to compute for amortisation for EIR start                              232928
      ** date until last amortisation date.                                                   232928
                                                                                              232928
     C                   IF        DTYP = 'IT' OR DTYP = 'TD' OR                              232928
     C                             DTYP = 'CI' OR DTYP = 'CD'                                 232928
     C                   EVAL      WkLoanDepI = 'D'                                           232928
     C                   ELSE                                                                 232928
     C                   EVAL      WkLoanDepI = 'L'                                           232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   EVAL      WStartDate = EISTDT                                        232928
     C                   EVAL      WEndDate   = EILADT                                        232928
                                                                                              232928
     C**********         IF        DSAM <> *ZEROS                                     232928 BUG9473
     C**********         EVAL(R)   WkDisc     = DSAM                                  232928 BUG9473
     C                   IF        FREC = 'DEALSDDF' AND                                     BUG9473
     C                             DISA <> *ZEROS                                            BUG9473
     C                   EVAL(R)   WkDisc     = DISA                                         BUG9473
     C                   EVAL      WProcType = 'D'                                            232928
     C                   ELSE                                                                 232928
     C                   EVAL(R)   WkDisc     = 0                                             232928
     C                   EVAL      WProcType = ' '                                            232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   IF        BKALDI <> 'Y'                                              232928
     C                   EVAL      WAccInd = 'F'                                              232928
     C                   ENDIF                                                                232928
     C                   MOVE      ZZCALC        WIntCalcBasis                                232928
                                                                                              232928
      ** Set previous dirty and clean price to zero since amortisation                        232928
      ** being calculated begins at EIR start date                                            232928
     C                   EVAL      WEIPRDP = *ZERO                                            232928
     C                   EVAL      WEIPRCP = *ZERO                                            232928
                                                                                              232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM                    CMD(5)                                       232928
     C                   PARM                    CMDLEN                                       232928
                                                                                              232928
     C                   EVAL      PMaturityDate = MDAT                                       233578
     C                   EVAL      PStopAccrualF = ' '                                        233612
      *                                                                                       233612
     C                   MOVE      PAMORTDS      PAmortDSA                                    232928
                                                                                              232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM                    CMD(7)                                       232928
     C                   PARM                    CMDLEN                                       232928
     C                   IF        DLNO = 98
     C                   MOVEL     'A'           MYPART
     C                   DUMP
     C                   ENDIF
                                                                                              232928
      ** Call Amortisation Calculator                                                         232928
     C                   CALLB     'ZAAMRTCALC'                                               232928
     C                   PARM                    PAmortDSA                                    232928
                                                                                              232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM                    CMD(6)                                       232928
     C                   PARM                    CMDLEN                                       232928
                                                                                              232928
     C                   MOVEL     PAmortDSA     PAMORTDS                                     232928
     C                   IF        DLNO = 98
     C                   MOVEL     'B'           MYPART            1
     C                   DUMP
     C                   ENDIF
                                                                                              232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM                    CMD(8)                                       232928
     C                   PARM                    CMDLEN                                       232928
                                                                                              232928
      ** Set dirty and clean price                                                            232928
     C                   EVAL(R)   EICPTD = PClnPrcTdy                                        232928
     C                   EVAL(R)   EIDPTD = PDrtPrcTdy                                        232928
     C                   EVAL      EIPRCP = 0                                                 232928
     C                   EVAL      EIPRDP = 0                                                 232928
                                                                                              232928
      ** Set Last date of amortisation to run date and Amortisation                           232928
      ** adjustment to the difference of the calculated amortisation                          232928
      ** and the current amortisation amount to date                                          232928
     C                   EVAL      EIAMAJ = WAmrtAmt                                          232928
                                                                                              232928
     C                   ENDSR                                                                232928
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update MMEIRDPD                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR

     C                   EVAL      EIEIR = POutEIR
     C                   EVAL      EIFDPA = wFDPA                                            BUG9667
     C                   UPDATE    MMEIRDD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZINTDY - Calculate number of interest days between 2 days   *
      *                                                               *
      *****************************************************************
     C     SRZINTDY      BEGSR

     C                   Z-ADD     ZZBEG         ZZBEG9            5 0                        CDL093
     C                   Z-ADD     ZZEND         ZZEND9            5 0                        CDL093
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeOut
     C                   PARM                    ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
     C                   PARM                    INT6DY                                       242286
                                                                                              CDL093
      ** Calculation type '9'                                                                 CDL093
                                                                                              CDL093
     C                   If        ZZCALC = '9'                                               CDL093
      *                                                                                       CDL093
     C                   Z-ADD     ZZBEG9        @@DAYN            5 0                        CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZStartDate                                  CDL093
      *                                                                                       CDL093
     C                   Z-ADD     ZZEND9        @@DAYN                                       CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZEndDate                                    CDL093
                                                                                              CDL093
      ** Check if the period contains a Feb 29                                                CDL093
                                                                                              CDL093
     C                   EXSR      #FEB29                                                     CDL093
      *                                                                                       CDL093
     C                   If        #29Feb = 'Y'                                               CDL093
     C                   EVAL      EPNDYY = 366                                               CDL093
     C                   ELSE                                                                 CDL093
     C                   EVAL      EPNDYY = 365                                               CDL093
     C                   END                                                                  CDL093
      *                                                                                       CDL093
     C                   ENDIF                                                                CDL093

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CDL093
      *****************************************************************
      * *INZSR - Inital processing (Only done first time through)
      *****************************************************************

     C     *INZSR        BEGSR

      **  Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'LE002250'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Call access program for General Ledger details

     C**********         CALL      'AOGELRR0'                                                 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'IR001957'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WEvCtlDt = BJDNWD - 1
     C                   IF        BKAPDT < WEvCtlDt
     C                   EVAL      WEvCtlDt = BKAPDT
     C                   ENDIF

      ** Access Midas SD Hedging ICD File

     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDHEDG        PARM      SDHEDG        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY  =  POPTN
     C                   EVAL      DBFILE =  'SDHEDGPD'
     C                   EVAL      DBASE  =  3
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IN        RUNDAT

     C     KRUND         KLIST
     C                   KFLD                    EITRAN
     C                   KFLD                    AGRDNB

     C     KFSEQ         KLIST
     C                   KFLD                    EITRAN
     C                   KFLD                    DFFSEQ
                                                                                              232928
     C     KEY001        KLIST                                                                232928
     C                   KFLD                    EITRAN                                       232928
     C                   KFLD                    EISTDT                                       232928
                                                                                              CLE148
     C     KEY002        KLIST                                                                CLE148
     C                   KFLD                    WTRAN2            6                          CLE148
     C                   KFLD                    EISTDT                                       CLE148

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
** CPY@
(c) Finastra International Limited 2004
** CMD
OVRDBF FILE(ZAEIRPL0) TOFILE(MMEIRPL0) SEQONLY(*YES 500)
OVRDBF FILE(ZAEIRFL0) TOFILE(MMEIRFL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAEIRFL0)
DLTOVR FILE(ZAEIRPL0)
OVRDBF FILE(ZAAMRTL0) TOFILE(MMAMRTL0) SEQONLY(*YES 500)                                      232928
DLTOVR FILE(ZAAMRTL0)                                                                         232928
OVRDBF FILE(HISTSL0) TOFILE(MMHISTL0) SEQONLY(*YES 500)                                       232928
DLTOVR FILE(HISTSL0)                                                                          232928
