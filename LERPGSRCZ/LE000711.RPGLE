     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Commitment Fees Extract')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  LE000711   - Midas LE Commitment Fees Extract                *
      *                                                               *
      *  Function:  This program will create the extract file that    *
      *             will be used for the new report showing the fee   *
      *             amounts to be charged at the next fee payment and *
      *             how these are calculated.                         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD055657           Date 14May20               *
      *                 AR674226           Date 04Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR745803           Date 19Apr11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 21Sep05
      *                 227369             Date 17Jun04               *
      *                 CLE037  *CREATE    Date 09Dec03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD055657 - Manual transaction from FFC TI Interface went to  *
      *             repair queue because the facility exchange rate is*
      *             longer than the defined facility exchange rate in *
      *             Midas. Increase the field definition of the Midas *
      *             facility exchange rate. (Recompile)               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. (Child: AR674227)                       *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR745803 - LEC000711 00001 Dbase 002 (Child:AR745804)        *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  227369 - Fees with calculation type '06' never reported.     *
      *  CLE037 - Nordea Commitment Fee Update                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    Function of Indicators                       *
      *                                                               *
      *       01  EOF LEFEEDL1                                        *
      *       02  Record not found FACHISH                            *
      *       03  EOF FACHISA                                         *
      *       04  Record not found FCLTY                              *
      *       05  EOF LEFCAMLB                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT      - Initial Subroutine                              *
      * SRMAIN      - Main Subroutine                                 *
      * SRPROC      - Process live calculated facility fees           *
      * SRFachish   - Obtain facility details from facility history   *
      *                header file                                    *
      * SRAmtHis    - Calculate fee amount for the historic data      *
      * SRAmtFwd    - Project facility balances from today to the next*
      *               payment date                                    *
      * SRAmtLeft   - Process from last date to end date if last      *
      *               date is less than end date                      *
      * SRFCLTY     - Obtain facility details from facility file      *
      * SRAccrue    - Compute fee amount                              *
      * SRChkBal    - Retrieves the correct balance                   *
      * SRTiered    - Tiered Calculations                             *
      * SRThresh    - Threshold calculations                          *
      * SROutFile   - Writes to the extract file                      *
      * SRRtvCcyDet - Retrieve fee currency details                   *
      * SRZINTDY    - Compute number of interest days                 *
      * SRZXRate    - Cross Rate Calculation                          *
      * SRZCONVZ1   - Conversion of amount from one currency to the   *
      *               other                                           *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     FFACHISH   IF   E           K DISK    INFSR(*PSSR)
     FFACHSAL1  IF   E           K DISK    INFSR(*PSSR)
     FLEFCAMLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(FSDS)
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FY)
     F                                     IGNORE(FCLTYHHF:FCLTYZZF)

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CL)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)

     FLEFCAMLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LOAMSLAF)
     F                                     PREFIX(LA)

     FLECFEEPD  O    E             DISK    INFSR(*PSSR)
     F                                     USROPN

     FLE000711AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** AUD: Printer file for Commitment Fees Extract Audit

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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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

     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D FAMT            S             11  0 DIM(5) ASCEND                        Fee Lim Amt
     D FAM             S             16  0 DIM(5) ASCEND                        Fee Amts
     D FRT             S              7  5 DIM(5) ASCEND                        Fee Lim Rate
     D FPC             S              6  3 DIM(5) ASCEND                        Fee Percentge

      ** File Information Data Structure for LE000711AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Base Rate Code Data Structure
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)

      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)


      ** File Status Data Structure
     D FSDS            DS
     D FREC              *RECORD

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Key list fields for FACHISH and FACHISA
     D*K#CNUM***       S              6  0                                                    CSD027
     D K#CNUM          S              6                                                       CSD027
     D K#FACL          S              5  0
     D K#FACT          S              3  0
     D K#FCNO          S              2  0
     D K#DATE          S              5  0

     D K#RTCP          S              1A

      ** Parameter list for AOCURRR0 , AOBSRTR0 , AOSARDR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCcy            S              3A
     D PCcyB           S              3A
     D*PNBRA****       S              2                                                       CSD103
     D PNBRA           S              2A                                                      CSD103
     D PSard           S              6

      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameter list for ZINTDY
     D ZZINDY          S              5  0
     D ZZBEG           S              5  0
     D ZZEND           S              5  0
     D ZZCALC          S              1A
     D***INT6DY*       S             15  7                                                    242286
     D INT6DY          S             15  9                                                    242286
     D WZZCALC         S              1  0

      ** Parameter list for ZCONVZ1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13  8
     D ZMD             S              1A
     D ZCCYI           S              3A
     D ZCCYO           S              3A
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

     D WPct            S              6  3
     D WOrigPct        S              6  3
     D WFPC            S              6  3

     D WSDate          S              5  0
     D WEDate          S              5  0
     D WSDate2         S              5  0
     D WEDate2         S              5  0
     D StartIntDat     S              5  0
     D WOutSDte        S              5  0
     D WOutEDte        S              5  0
     D WNoIntDays      S              5  0
     D WNoIntDays2     S              5  0
     D WNumDYr         S              5  0
     D WSavAmdDate     S              5  0
     D WSavFWDT        S              5  0
     D WSLID           S              5  0

     D WFacMDIN        S              1A
     D WFacNBDP        S              1  0
     D WFacSPRT        S             13  8
     D WFeeMDIN        S              1A
     D WFeeNBDP        S              1  0
     D WFeeSPRT        S             13  8
     D WXCcyMDIN       S              1A
     D WXCcyXRate      S             13  8
     D WZIWRK1         S             30  9
     D WZIWRK2         S             30  9

     D Ix              S              1  0
     D WTD             S              1  0
     D WAmtFlg         S              3A
     D WCNUMKey        S              6A
     D WFACLKey        S              5A
     D WFECALTN        S              2  0
     D WOutRate        S             13  8
     D WBalance        S             16  0
     D*WBalTemp*       S             16  0                                                    CLE106
     D WBalTemp        S             16  3                                                    CLE106
     D WOrigBal        S             16  0
     D WAvgBal         S             16  0
     D WFeeAmt         S             16  0
     D WTotAmt         S             16  0
     D WRollFlg        S              1A
     D WHisFlg         S              1A
     D WFwdFlg         S              1A
     D CIR004          S              1A
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTR           S             30  9

     D WRun            S              1A   INZ('N')

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

     ILEMNFUPF                                                                              AR674226
     I              SQNO                        FSQNO                                       AR674226
     ILEMNFUPE                                                                              AR674226
     I              SQNO                        ESQNO                                       AR674226
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Process Main subroutine

     C                   EXSR      SRINIT
     C                   EXSR      SRMAIN

      ** Return

     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      * SRINIT - Initial Subroutine                                   *
      *****************************************************************
     C     SRINIT        BEGSR

      ** RCF Processing for Audit File.

     C                   EXSR      SRRcfAu

      ** Define variables used

     C     *LIKE         DEFINE    CFFAMT        WFAmount
     C     *LIKE         DEFINE    FADRAM        WDAmount
     C     *LIKE         DEFINE    FAUNDR        WUAmount
     C     *LIKE         DEFINE    CFFAMT        WFAM
     C     *LIKE         DEFINE    CFFAMT        WOutBala
     C     *LIKE         DEFINE    CFFAMT        WOutFee
     C     *LIKE         DEFINE    CFTAMT        WOutTFee
     C     *LIKE         DEFINE    FACFAM        WCurCFAM
     C     *LIKE         DEFINE    CFNUMD        WOutIntD
     C     *LIKE         DEFINE    CFPCT         WOutPct
     C     *LIKE         DEFINE    CFAAMT        WOutAmt
     C     *LIKE         DEFINE    CLBRTE        WBaseRate
     C     *LIKE         DEFINE    CLBRTE        WIntRate
     C     *LIKE         DEFINE    CLINTR        WIntCalc
     C     *LIKE         DEFINE    CLINTR        WTotalInt
     C     *LIKE         DEFINE    CLRTSP        WSprdRate
     C     *LIKE         DEFINE    CLSPIN        WSprdInd
     C     *LIKE         DEFINE    CLICBS        WCalcBasis
     C     *LIKE         DEFINE    CLCPAM        WCPAM
     C     *LIKE         DEFINE    CLCPAM        WkAmt
     C     *LIKE         DEFINE    PRAM          WPRAM
     C     *LIKE         DEFINE    FWAM          WFWAM

     C     FACHISAK      KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#DATE

     C     FACHISAK2     KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL

     C     FACHISHK      KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO

     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RTCP

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRMAIN - Main Subroutine                                      *
      *****************************************************************
     C     SRMAIN        BEGSR

      ** Open LECFEEPD if it is not yet opened

     C                   OPEN      LECFEEPD

     C     *LOVAL        SETLL     LEFEEDL1
     C                   READ      LEFEEDL1                               01

     C                   DOW       %EOF(LEFEEDL1) = '0'

     C                   IF        FERECI = 'D' and FECALT <> ' '

      ** Process live calculated facility fees

     C                   EXSR      SRPROC
     C                   ENDIF

     C                   READ      LEFEEDL1                               01
     C                   ENDDO

      ** Close LECFEEPD

     C                   CLOSE     LECFEEPD

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRPROC - Process live calculated facility fees                *
      *****************************************************************
     C     SRPROC        BEGSR

     C                   EVAL      WSDate  = 0
     C                   EVAL      WEDate  = 0
     C                   EVAL      WSDate2 = 0
     C                   EVAL      WEDate2 = 0

     C                   Z-ADD     FEAMT1        FAMT(1)
     C                   Z-ADD     FEAMT2        FAMT(2)
     C                   Z-ADD     FEAMT3        FAMT(3)
     C                   Z-ADD     FEAMT4        FAMT(4)
     C                   Z-ADD     FEAMT5        FAMT(5)
     C                   Z-ADD     FEFRT1        FRT(1)
     C                   Z-ADD     FEFRT2        FRT(2)
     C                   Z-ADD     FEFRT3        FRT(3)
     C                   Z-ADD     FEFRT4        FRT(4)
     C                   Z-ADD     FEFRT5        FRT(5)

      ** Initalise work variables

     C                   EVAL      WAvgBal     = 0
     C                   EVAL      WBalance    = 0
     C                   EVAL      WOrigBal    = 0
     C                   EVAL      WFAmount    = 0
     C                   EVAL      WFeeAmt     = 0
     C                   EVAL      WTotAmt     = 0
     C                   EVAL      WFAM        = 0
     C                   EVAL      WOutBala    = 0
     C                   EVAL      WOutFee     = 0
     C                   EVAL      WOutTFee    = 0
     C                   EVAL      WCurCFAM    = 0
     C                   EVAL      WDAmount    = 0
     C                   EVAL      WUAmount    = 0
     C                   EVAL      WOutIntD    = 0
     C                   EVAL      WOutPct     = 0

      ** Set Period Start Date

     C                   IF        FELPDT <> 0
     C                   EVAL      WSDate = FELPDT
     C                   ELSE
     C                   EVAL      WSDate = FEPSTD
     C                   ENDIF

      ** Set Period End Date

     C                   IF        FENPYD <> 0
     C                   EVAL      WEDate = FENPYD
     C                   ELSE
     C                   EVAL      WEDate = FEPEND
     C                   ENDIF

      ** Retrieve fee currency details

     C                   EVAL      PCcy = FEFCCY

     C                   EXSR      SRRtvCcyDet

      ** Save decimal place, multiply/divide indicator, and spot rate

     C                   EVAL      WFeeNBDP = A6NBDP                            Decimal places (1N)
     C                   EVAL      WFeeMDIN = A6MDIN                            Mult/Div Ind (1A)
     C                   EVAL      WFeeSPRT = A6SPRT                            Spot Rate (13,8P)

      ** Set flag to know if actual amounts or average is used

     C                   IF        (FECALT = '04') or (FECALT = '05') or
     C                             (FECALT = '06') or (FECALT = '14') or
     C                             (FECALT = '15') or (FECALT = '16') or
     C                             (FECALT = '22')
     C                   EVAL      WAmtFlg = 'ACT'
     C                   ELSE
     C                   EVAL      WAmtFlg = 'AVG'
     C                   ENDIF                                                                227369

      ** Compute number of interest days

     C                   EVAL      ZZBEG = WSDate
     C                   EVAL      ZZEND = WEDate
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      SRZINTDY
     C                   EVAL      WNoIntDays = ZZINDY
     C**********         ENDIF                                                                227369

     C                   IF        WNoIntDays > 0

      ** Obtain facility details from facility history header file

     C                   EVAL      K#CNUM = FECNUM
     C                   IF        FEFACL = *ZERO                                           AR745803
     C                   EXSR      SRCLOAN                                                  AR745803
     C                   ELSE                                                               AR745803
     C                   MOVEL     FEFACL        K#FACT
     C                   MOVE      FEFACL        K#FCNO
     C                   ENDIF                                                              AR745803
     C                   EXSR      SRFachish

      ** Calculate historic fee amounts

     C                   EVAL      WHisFlg = 'N'
     C                   EVAL      WFwdFlg = 'N'
     C**********         EVAL      K#CNUM = FECNUM                                          AR745803
     C                   EVAL      K#FACL = FEFACL
     C                   EXSR      SRAmtHis

      ** Project the facility balances from today through to the end
      ** of the current period

     C                   EXSR      SRAmtFwd

      ** Process remaining days if end date greater than current end date

     C                   IF        WEDate > WEDate2
     C                   EXSR      SRAmtLeft
     C                   ENDIF

      ** If Average amount specified, compute for fee amount

     C                   IF        WAmtFlg = 'AVG'
     C                   EVAL      WBalance = WAvgBal
     C                   EVAL      WNoIntDays2 = WNoIntDays
     C                   EVAL      WOutSDte = WSDate
     C                   EVAL      WOutEDte = WEDate
     C                   IF        WBalance > 0
     C                   EXSR      SRAccrue
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      * SRFachish - Obtain facility details from facility history     *
      *              header file                                      *
      *****************************************************************
     C     SRFachish     BEGSR

     C     FACHISHK      CHAIN     FACHISH                            02
     C                   IF        %FOUND(FACHISH) = '0'
     C                   MOVEL     K#CNUM        WCNUMKey
     C                   MOVEL     K#FACT        WFACLKey
     C                   MOVE      K#FCNO        WFACLKey
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 002
     C                   EVAL      DBFile = 'FACHISH'
     C                   EVAL      DBKey = WCNUMKey + WFACLKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRAmtHis - Calculate fee amount for the historic data         *
      *****************************************************************
     C     SRAmtHis      BEGSR

      ** Initialise average balance

     C                   EVAL      WAvgBal = 0
     C                   EVAL      WSDate2 = WSDate
     C                   EVAL      K#DATE = WSDate

      ** Get starting balance to be used in fee computation

     C     FACHISAK      SETGT     FACHSAL1
     C                   READP     FACHSAL1                               03

      ** Retrieve correct balance using SRChkBal

     C                   EXSR      SRChkBal

     C                   DOW       %EOF(FACHSAL1) = '0' and
     C                              FADATE <= WEDate

     C     FACHISAK2     READE     FACHSAL1                               03

     C                   IF        %EOF(FACHSAL1) = '0'

     C                   IF        FADATE <= WEDate
     C                   EVAL      WEDate2 = FADATE
     C                   ELSE
     C                   EVAL      WEDate2 = WEDate
     C                   ENDIF
     C                   EVAL      WOutSDte = WSDate2
     C                   EVAL      WOutEDte = WEDate2

      ** Compute no of interest days

     C                   EVAL      ZZBEG = WSDate2
     C                   EVAL      ZZEND = WEDate2
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      SRZINTDY
     C                   EVAL      WNoIntDays2 = ZZINDY
     C

     C                   IF        WNoIntDays2 > 0

     C                   EVAL      WHisFlg = 'Y'

      ** If Average amount specified

     C                   IF        WAmtFlg = 'AVG'
     C                   EVAL      WBalance = (WOrigBal * WNoIntDays2) / +
     C                                        WNoIntDays
     C                   EVAL      WAvgBal = WAvgBal + WBalance
     C

      ** ... else if actual

     C                   ELSE

     C                   EVAL      WBalance = WOrigBal

      ** Compute Fee Amount

     C                   IF        WBalance > 0
     C                   EXSR      SRAccrue
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Save history date to work start date

     C                   EVAL      WSDate2 = WEDate2

      ** Retrieve correct balance using SRChkBal

     C                   EXSR      SRChkBal

     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRAmtFwd - Project facility balances from today to the next   *
      *            payment date                                       *
      *****************************************************************
     C     SRAmtFwd      BEGSR

      ** Access Facility Details

     C                   EXSR      SRFCLTY
     C                   EVAL      WSavFWDT = 0
     C                   IF        WSDate2 = 0
     C                   EVAL      WSDate2 = WSDate
     C                   ENDIF
     C                   EVAL      K#DATE = WSDate2

     C     FACHISAK      SETGT     LEFCAMLB
     C                   READP     LEFCAMLB                               05

     C                   EXSR      SRChkBalF

      ** Read through all forward facility amendments, loan increases, loan
      ** repayments affecting the facility amount of the key facility (LF/LEFCAMLB)

     C                   DOW       %EOF(LEFCAMLB) = '0' and FWDT <= WEDate

     C     FACHISAK2     READE     LEFCAMLB                               05

     C                   IF        %EOF(LEFCAMLB) = '0' and FWDT <= WEDate

      ** Compute for the balance as changed by the current forward transaction

     C                   EXSR      SRFWDBAL


     C                   EVAL      WEDate2 = FWDT

     C                   EVAL      WOutSDte = WSDate2
     C                   EVAL      WOutEDte = WEDate2

      ** Compute no of interest days

     C                   EVAL      ZZBEG = WSDate2
     C                   EVAL      ZZEND = WEDate2
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      SRZINTDY
     C                   EVAL      WNoIntDays2 = ZZINDY

     C                   IF        WNoIntDays2 > 0

     C                   EVAL      WFwdFlg = 'Y'

      ** If Average amount specified

     C                   IF        WAmtFlg = 'AVG'
     C                   EVAL      WBalance = (WOrigBal * WNoIntDays2) / +
     C                                        WNoIntDays
     C                   EVAL      WAvgBal= WAvgBal + WBalance

      ** ... else if actual

     C                   ELSE

     C                   EVAL      WBalance = WOrigBal

      ** Compute Fee Amount

     C                   IF        WBalance > 0
     C                   EXSR      SRAccrue
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WSDate2 = WEDate2

      ** Retrieve correct balance using SRChkBalF

     C                   EXSR      SRChkBalF

     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRAmtLeft - Process from last date to end date if last date is*
      *             less than end date                                *
      *****************************************************************
     C     SRAmtLeft     BEGSR

     C                   IF        WHisFlg = 'N' and WFwdFlg = 'N'
     C                   EXSR      SRFCLTY
     C                   ENDIF

      ** Select on the following to work out the balance for computation

     C                   SELECT

      ** Process available amount

     C                   WHEN      WFECALTN <= 6
     C                   EVAL      WOrigBal = 0
     C                   IF        WUAmount > 0
     C                   EVAL      WOrigBal = WUAmount
     C                   ENDIF

      ** Process outstanding amount

     C                   WHEN      WFECALTN <= 16
     C                   EVAL      WOrigBal = WDAmount

      ** Process facility amount

     C                   WHEN      WFECALTN <= 22
     C                   EVAL      WOrigBal = WFAmount
     C                   ENDSL

     C                   EVAL      WCurCFAM = WFAmount

     C                   IF        WEDate2 > 0
     C                   EVAL      WSDate2 = WEDate2
     C                   ELSE
     C                   EVAL      WSDate2 = WSDate
     C                   ENDIF
     C                   EVAL      WEDate2 = WEDate
     C                   EVAL      WOutSDte = WSDate2
     C                   EVAL      WOutEDte = WEDate2

      ** Compute no of interest days

     C                   EVAL      ZZBEG = WSDate2
     C                   EVAL      ZZEND = WEDate2
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      SRZINTDY
     C                   EVAL      WNoIntDays2 = ZZINDY

     C                   IF        WNoIntDays2 > 0

      ** If Average amount specified

     C                   IF        WAmtFlg = 'AVG'
     C                   EVAL      WBalance = (WOrigBal * WNoIntDays2) / +
     C                                        WNoIntDays
     C                   EVAL      WAvgBal= WAvgBal + WBalance
     C

      ** ... else if actual

     C                   ELSE

     C                   EVAL      WBalance = WOrigBal

      ** Compute Fee Amount

     C                   IF        WBalance > 0
     C                   EXSR      SRAccrue
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRFCLTY - Obtain facility details from facility file          *
      *****************************************************************
     C     SRFCLTY       BEGSR

     C                   EVAL      K#RTCP = 'A'
     C     FCLTYK        CHAIN     FCLTY                              04
     C                   IF        %FOUND(FCLTY) = '0'
     C                   MOVEL     K#CNUM        WCNUMKey
     C                   MOVEL     K#FACT        WFACLKey
     C                   MOVE      K#FCNO        WFACLKey
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 003
     C                   EVAL      DBFile = 'FCLTY'
     C                   EVAL      DBKey = WCNUMKey + WFACLKey + K#RTCP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      K#RTCP = 'B'
     C     FCLTYK        CHAIN     FCLTY                              04
     C                   IF        %FOUND(FCLTY) = '0'
     C                   MOVEL     K#CNUM        WCNUMKey
     C                   MOVEL     K#FACT        WFACLKey
     C                   MOVE      K#FCNO        WFACLKey
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 007
     C                   EVAL      DBFile = 'FCLTY'
     C                   EVAL      DBKey = WCNUMKey + WFACLKey + K#RTCP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WDAmount = FYOAM1
     C                   EVAL      WFAmount = FYFAMT
     C                   EVAL      WUAmount = WFAmount - WDAmount

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAccrue - Compute fee amount                                 *
      *****************************************************************
     C     SRAccrue      BEGSR

      ** Calculate percentage if required

     C**********         IF        FEPIND <> 'A'                                              CLE106
     C                   IF        FEPIND = 'P'                                               CLE106
     C                   IF        WAmtFlg = 'AVG'
     C                   EVAL      WBalTemp = (WBalance / FHOFAM) * 100
     C                   EVAL      WBalance = FHOFAM
     C                   ELSE
     C                   EVAL      WBalTemp = (WBalance / WCurCFAM) * 100
     C                   EVAL      WBalance = WCurCFAM
     C                   ENDIF
     C                   IF        WBalTemp > 100
     C                   EVAL      WPct = 100
     C                   ELSE
     C                   EVAL(H)   WPct = WBalTemp
     C                   ENDIF
     C                   ENDIF

      ** Convert balance from facility currency to fee currency if necessary

     C                   IF        FHFCCY <> FEFCCY

      ** Retrieve facility currency details

     C                   EVAL      PCcy = FHFCCY

     C                   EXSR      SRRtvCcyDet

      ** Save decimal place, multiply/divide indicator, and spot rate

     C                   EVAL      WFacNBDP = A6NBDP                            Decimal places (1N)
     C                   EVAL      WFacMDIN = A6MDIN                            Mult/Div Ind (1A)
     C                   EVAL      WFacSPRT = A6SPRT                            Spot Rate (13,8P)

      ** Obtain cross-currency exchange rate from standing data if
      **  exchange rate field on fees master file is blank

     C                   IF        FEERAT = 0

      ** Retrieve cross currency exchange rate

     C                   Z-ADD     WFacSPRT      ZRATE1
     C                   EVAL      ZMDI1 = WFacMDIN
     C                   Z-ADD     WFeeSPRT      ZRATE2
     C                   EVAL      ZMDI2 = WFeeMDIN
     C                   EXSR      SRZXRate
     C                   EVAL      WXCcyXRate = ZRATEX
     C                   EVAL      WXCcyMDIN  = ZMDIX

      ** Convert balance from facility currency to fee currency

     C                   Z-ADD     WBalance      ZAMTCI
     C                   Z-ADD     WXCcyXRate    ZEXCH
     C                   EVAL      ZMD = WXCcyMDIN
     C                   EVAL      ZCCYI = FHFCCY
     C                   EVAL      ZCCYO = FEFCCY
     C                   Z-ADD     WFacNBDP      ZCDPI
     C                   Z-ADD     WFeeNBDP      ZCDPO
     C                   EXSR      SRZCONVZ1
     C                   ELSE

     C                   Z-ADD     WBalance      ZAMTCI
     C                   Z-ADD     FEERAT        ZEXCH
     C                   EVAL      ZMD = FEMDIN
     C                   EVAL      ZCCYI = FHFCCY
     C                   EVAL      ZCCYO = FEFCCY
     C                   Z-ADD     WFacNBDP      ZCDPI
     C                   Z-ADD     WFeeNBDP      ZCDPO
     C                   EXSR      SRZCONVZ1
     C                   ENDIF

     C                   Z-ADD     ZAMTCO        WBalance

     C                   ENDIF

      ** Retrieve calculation day basis equivalent

     C                   SELECT
     C                   WHEN      FECALC = 1 or FECALC = 4
     C                   EVAL      WNumDYr = 36500
     C                   WHEN      FECALC = 2 or FECALC = 3 or FECALC = 5
     C                   EVAL      WNumDYr = 36000
     C                   WHEN      FECALC = 6
     C                   EVAL      WNumDYr = 36600
     C                   ENDSL

      ** Initialise total fee amount field

     C                   EVAL      WTotAmt = 0

      ** Compute fee amount

     C                   SELECT
     C                   WHEN      (FECALT = '01') or (FECALT = '04') or
     C                             (FECALT = '11') or (FECALT = '14')

      ** Tiered calculations

     C                   EXSR      SRTiered

     C                   WHEN      (FECALT = '02') or (FECALT = '05') or
     C                             (FECALT = '12') or (FECALT = '15')

      ** Threshold calculations

     C                   EXSR      SRThresh

     C                   WHEN      (FECALT = '03') or (FECALT = '06') or
     C                             (FECALT = '13') or (FECALT = '16') or
     C                             (FECALT = '21') or (FECALT = '22')

      ** Single calculations

     C                   EVAL(H)   WTotAmt = (WBalance * FRT(1) *+
     C                                        WNoIntDays2)/WNumDYr

      ** Update File

     C                   EVAL      WOutBala = WBalance
     C                   EVAL      WOutFee  = WTotAmt
     C                   EVAL      WOutRate = FRT(1)
     C                   EVAL      WOutIntD = WNoIntDays2
     C                   EVAL      WOutPct  = 0
     C                   EXSR      SROutFile

     C                   ENDSL

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRChkBal - Retrieves the correct balance                      *
      *****************************************************************
     C     SRChkBal      BEGSR

      ** Initialise original balance

     C                   EVAL      WOrigBal = 0
     C                   MOVE      FECALT        WFECALTN
     C                   EVAL      WDAmount = FADRAM
     C                   EVAL      WUAmount = FAUNDR
     C                   EVAL      WFAmount = FACFAM

     C                   SELECT

      ** Process available amount

     C                   WHEN      WFECALTN <= 6
     C                   IF        FAUNDR > 0
     C                   EVAL      WOrigBal = FAUNDR
     C                   ENDIF

      ** Process outstanding amount

     C                   WHEN      WFECALTN <= 16
     C                   EVAL      WOrigBal = FADRAM

      ** Process facility amount

     C                   WHEN      WFECALTN <= 22
     C                   EVAL      WOrigBal = FACFAM
     C                   ENDSL

      ** Set current facility amount to facility amount

     C                   EVAL      WCurCFAM = FACFAM

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRChkBalF - Projects future balances                          *
      *****************************************************************
     C     SRChkBalF     BEGSR

      ** Initialise original balance

     C                   EVAL      WOrigBal = 0

     C                   SELECT

      ** Process available amount

     C                   WHEN      WFECALTN <= 6
     C                   IF        WUAmount > 0
     C                   EVAL      WOrigBal = WUAmount
     C                   ENDIF

      ** Process outstanding amount

     C                   WHEN      WFECALTN <= 16
     C                   EVAL      WOrigBal = WDAmount

      ** Process facility amount

     C                   WHEN      WFECALTN <= 22
     C                   EVAL      WOrigBal = WFAmount
     C                   ENDSL

      ** Set current facility amount to facility amount

     C                   EVAL      WCurCFAM = WFAmount

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRFWDBAL - Projects future balances                           *
      *****************************************************************
     C     SRFWDBAL      BEGSR

      ** Update Facility balances

     C                   SELECT
     C                   WHEN      FREC = 'LEFCAMPF'

     C                   IF        FATP = 'FI'
     C                   EVAL      WFAmount = WFAmount + FWAM
     C                   EVAL      WUAmount = WUAmount + FWAM
     C                   ENDIF

     C                   IF        FATP = 'FD'
     C                   EVAL      WFAmount = WFAmount - FWAM
     C                   EVAL      WUAmount = WUAmount - FWAM
     C                   ENDIF

     C                   WHEN      FREC = 'LEMNFUPF'

     C                   EVAL      WFWAM = FWAM

     C                   IF        FYFCCY <> UCCY

      ** Retrieve utilisation currency details

     C                   EVAL      PCcy = UCCY

     C                   EXSR      SRRtvCcyDet

     C                   Z-ADD     FWAM          ZAMTCI
     C                   Z-ADD     UXRT          ZEXCH
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = UCCY
     C                   EVAL      ZCCYO = FYFCCY
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   Z-ADD     WFacNBDP      ZCDPO
     C                   EXSR      SRZCONVZ1
     C                   Z-ADD     ZAMTCO        WFWAM
     C                   ENDIF

     C                   EVAL      WDAmount = WDAmount + WFWAM
     C                   EVAL      WUAmount = WUAmount - WFWAM

     C                   WHEN      FREC = 'CLOANCL1' or FREC = 'CLOANCL2'

     C                   EVAL      WFWAM = FWAM

     C                   IF        FYFCCY <> CCY

      ** Retrieve utilisation currency details

     C                   EVAL      PCcy = CCY

     C                   EXSR      SRRtvCcyDet

     C                   Z-ADD     FWAM          ZAMTCI
     C                   Z-ADD     FCXR          ZEXCH
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = CCY
     C                   EVAL      ZCCYO = FYFCCY
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   Z-ADD     WFacNBDP      ZCDPO
     C                   EXSR      SRZCONVZ1
     C                   Z-ADD     ZAMTCO        WFWAM
     C                   ENDIF
     C
     C                   IF        PTYP = 66 or PTYP = 67 or
     C                             PTYP = 70 or PTYP = 71
     C                   EVAL      WDAmount = WDAmount + WFWAM
     C                   EVAL      WUAmount = WUAmount - WFWAM
     C                   ELSE
     C                   EVAL      WDAmount = WDAmount - WFWAM
     C                   EVAL      WUAmount = WUAmount + WFWAM
     C                   ENDIF

     C                   WHEN      FREC = 'LOAMSDKF'

     C                   IF        AMTP = 'RE' and REPT = 3
     C                   EVAL      WPRAM = TAMT
     C                   EXSR      SRCALINT
     C                   EVAL      WFWAM = TAMT - WIntCalc
     C                   ELSE
     C                   EVAL      WFWAM = PRAM
     C                   ENDIF

     C                   IF        FYFCCY <> CCY

      ** Retrieve utilisation currency details

     C                   EVAL      PCcy = CCY

     C                   EXSR      SRRtvCcyDet

     C                   Z-ADD     WFWAM         ZAMTCI
     C                   Z-ADD     FCXR          ZEXCH
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = CCY
     C                   EVAL      ZCCYO = FYFCCY
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   Z-ADD     WFacNBDP      ZCDPO
     C                   EXSR      SRZCONVZ1
     C                   Z-ADD     ZAMTCO        WFWAM
     C                   ENDIF
     C
     C                   IF        PTYP = 66 or PTYP = 67 or
     C                             PTYP = 70 or PTYP = 71
     C                   EVAL      WDAmount = WDAmount - WFWAM
     C                   EVAL      WUAmount = WUAmount + WFWAM
     C                   ELSE
     C                   EVAL      WDAmount = WDAmount + WFWAM
     C                   EVAL      WUAmount = WUAmount - WFWAM
     C                   ENDIF

     C                   WHEN      FREC = 'LEMNFUPE'

     C                   EVAL      WDAmount = WDAmount + FWAM
     C                   IF        FYRVCR = 'Y'
     C                   EVAL      WUAmount = WUAmount + FWAM
     C                   ELSE
     C                   EVAL      WFAmount = WFAmount - FWAM
     C                   ENDIF

     C                   WHEN      FREC = 'CLOANCL4' or FREC = 'CLOANCL5'
     C                             or FREC = 'CLOANCL6'

     C                   EVAL      WFWAM = FWAM

     C                   IF        FREC = 'CLOANCL6' and REPT = 3
     C                   EVAL      WPRAM = FWAM
     C                   EXSR      SRCALINT
     C                   EVAL      WFWAM = FWAM - WIntCalc
     C                   ENDIF

     C                   IF        FYFCCY <> CCY

      ** Retrieve loan currency details

     C                   EVAL      PCcy = CCY

     C                   EXSR      SRRtvCcyDet

     C                   Z-ADD     WFWAM         ZAMTCI
     C                   Z-ADD     FCXR          ZEXCH
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = CCY
     C                   EVAL      ZCCYO = FYFCCY
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   Z-ADD     WFacNBDP      ZCDPO
     C                   EXSR      SRZCONVZ1
     C                   Z-ADD     ZAMTCO        WFWAM
     C                   ENDIF

     C                   IF        FYRVCR = 'Y'
     C                   EVAL      WUAmount = WUAmount + FWAM
     C                   ELSE
     C                   EVAL      WFAmount = WFAmount - FWAM
     C                   ENDIF

     C                   WHEN      FREC = 'CLOANCL3'
     C                   EVAL      WFWAM = FWAM
     C                   EVAL      WPRAM = FWAM
     C                   EXSR      SRCALINT
     C                   EVAL      WDAmount = WDAmount + WIntCalc
     C                   EVAL      WUAmount = WUAmount - WIntCalc

     C                   ENDSL

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRCALINT - Compute for interest happens on interest payment   *
      *            date or repayment date for repay type 3            *
      *****************************************************************
     C     SRCALINT      BEGSR

      ** Get loan details

     C     LNRF          CHAIN     CLOAN                              06
     C                   IF        %FOUND(CLOAN) = '0'
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 004
     C                   EVAL      DBFile = 'CLOAN'
     C                   MOVE      LNRF          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set a flag that will process rollover's change of rates

     C                   EVAL      WRollFlg = 'N'
     C                   IF        CLRLDT < FWDT
     C**********         IF        CLNBRA > 0 or CLNRTS > 0 or CLNSIN <> *BLANKS              CSD103
     C                   IF        CLNBRA <> *BLANKS or CLNRTS > 0                            CSD103
     C                             or CLNSIN <> *BLANKS                                       CSD103
     C**********                   or CLNCAS > 0                                              CLE106
     C                             or CLNCAS > 0 or CLNBSR > 0                                CLE106
     C                   EVAL      WRollFlg = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WCPAM = CLCPAM
     C                   EVAL      WSLID = CLSLID
     C                   EVAL      WSavAmdDate = 0
     C                   EVAL      WTotalInt = 0

     C     *LOVAL        SETLL     LEFCAMLA
     C     LNRF          READE     LEFCAMLA                               07

     C                   DOW       %EOF(LEFCAMLA) = '0' and LAVDAT < FWDT
     C                   IF        LAVDAT <> WSavAmdDate or CLRLDT < LAVDAT
     C                              and WRollFlg = 'Y'
     C                   IF        WRollFlg = 'Y' and CLRLDT < LAVDAT
     C**********         IF        CLNBRA > 0                                                 CSD103
     C                   IF        CLNBRA <> *BLANKS                                          CSD103
     C                   MOVE      CLNBRA        PNBRA
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      CLCCY         PCcyB
     C                   PARM                    PNBRA
     C     SDBSRT        PARM      SDBSRT        DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 005
     C                   EVAL      DBFile = 'SDBSRTPD'
     C                   EVAL      DBKey = PNBRA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     BACBSR        WBaseRate
     C                   ELSE
     C                   Z-ADD     CLBRTE        WBaseRate
     C                   ENDIF

     C                   IF        CLNRTS > 0
     C                   Z-ADD     CLNRTS        WSprdRate
     C                   ELSE
     C                   Z-ADD     CLRTSP        WSprdRate
     C                   ENDIF

     C                   IF        CLNSIN <> *BLANKS
     C                   MOVE      CLNSIN        WSprdInd
     C                   ELSE
     C                   MOVE      CLSPIN        WSprdInd
     C                   ENDIF

     C                   IF        CLNBSR > 0                                                 CLE106
     C                   Z-ADD     CLNBSR        WBaseRate                                    CLE106
     C                   ELSE                                                                 CLE106
     C                   Z-ADD     CLBRTE        WBaseRate                                    CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   IF        CLNCAS > 0
     C                   Z-ADD     CLNCAS        WCalcBasis
     C                   ELSE
     C                   Z-ADD     CLICBS        WCalcBasis
     C                   ENDIF

      ** Compute for interest

     C                   SELECT
     C                   WHEN      WSprdInd = 'A'
     C                   EVAL      WIntRate = WBaseRate + WSprdRate
     C                   WHEN      WSprdInd = 'S'
     C                   EVAL      WIntRate = WBaseRate - WSprdRate
     C                   WHEN      WSprdInd = 'P'
     C                   EVAL      WIntRate = WBaseRate * (WSprdRate/100)
     C                   ENDSL

     C                   EVAL      WRollFlg = 'N'

     C                   ELSE

      ** Compute for interest rate

     C                   Z-ADD     CLICBS        WCalcBasis
     C                   SELECT
     C                   WHEN      CLSPIN   = 'A'
     C                   EVAL      WIntRate = CLBRTE + CLRTSP
     C                   WHEN      CLSPIN   = 'S'
     C                   EVAL      WIntRate = CLBRTE - CLRTSP
     C                   WHEN      CLSPIN   = 'P'
     C                   EVAL      WIntRate = CLBRTE * (CLRTSP/100)
     C                   ENDSL

     C                   ENDIF

     C                   EVAL      ZZBEG   = LAVDAT
     C                   EVAL      ZZEND   = WSavAmdDate
     C                   MOVE      WCalcBasis    ZZCALC
     C                   EVAL      ZIAMT   = WCPAM
     C                   EVAL      ZIRATE  = WIntRate
     C                   EXSR      SRGLINTC

     C                   Z-ADD     ZINTR         WIntCalc

     C                   IF        FREC = 'CLOANCL3'
     C                   EVAL      WTotalInt = WTotalInt + WIntCalc
     C                   ENDIF
     C                   ENDIF

     C                   IF        AMTP = 'PT' or AMTP = 'PI'
     C                   EVAL      WCPAM = WCPAM + PRAM
     C                   ELSE
     C                   IF        AMTP = 'RE' and REPT = 3
     C                   EVAL      WkAmt = TAMT - WIntCalc
     C                   EVAL      WCPAM = WCPAM - WkAmt
     C                   ELSE
     C                   EVAL      WCPAM = WCPAM - PRAM
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WSavAmdDate = LAVDAT
     C                   ENDDO

     C                   IF        FREC = 'CLOANCL3'
     C                   IF        WSavAmdDate <> 0
     C                   EVAL      StartIntDat = WSavAmdDate
     C                   ELSE
     C                   EVAL      StartIntDat = CLSLID
     C                   ENDIF

     C                   EVAL      ZZBEG   = StartIntDat
     C                   EVAL      ZZEND   = FWDT
     C                   MOVE      WCalcBasis    ZZCALC
     C                   EVAL      ZIAMT   = WCPAM
     C                   EVAL      ZIRATE  = WIntRate
     C                   EXSR      SRGLINTC

     C                   Z-ADD     ZINTR         WTotalInt

     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRTiered - Tiered Calculations                                *
      *****************************************************************
     C     SRTiered      BEGSR

     C                   IF        FEPIND = 'A'
     C

      ** Set FAM to limits amounts (FAMT) converted to fee decimal places

     C                   EVAL      WTD = WFeeNBDP + 4
     C                   EVAL      FAM = FAMT * POWER(WTD)
     C                   EVAL      WOrigBal = WBalance

     C                   EVAL      WFAM = 0                                     (13,0)
     C                   EVAL      Ix = 1                                       (1,0)

     C                   DOW       WBalance > 0 and Ix < 6
     C                   IF        WOrigBal < FAM(Ix) or
     C                             FAM(Ix) = 0
     C                   EVAL      WFeeAmt = WBalance * FRT(Ix)
     C                   EVAL      WOutBala = WBalance
     C                   EVAL      WOutTFee = 0
     C                   ELSE
     C                   EVAL      WFeeAmt = (FAM(Ix) - WFAM) * FRT(Ix)
     C                   EVAL      WOutBala = FAM(Ix) - WFAM
     C                   EVAL      WOutTFee = FAM(Ix)
     C                   ENDIF
     C                   EVAL(H)   WFeeAmt   = (WFeeAmt * WNoIntDays2) /+
     C                                          WNumDYr

     C                   IF        WFeeAmt > 0

      ** Update File

     C                   EVAL      WOutRate = FRT(Ix)
     C                   EVAL      WOutFee  = WFeeAmt
     C                   EVAL      WOutIntD = 0
     C                   EVAL      WOutPct  = 0
     C                   EVAL      WOutAmt  = 0
     C                   EXSR      SROutFile

     C                   ENDIF

     C                   EVAL      WTotAmt = WTotAmt + WFeeAmt
     C                   EVAL      WBalance = WOrigBal - FAM(Ix)
     C                   EVAL      WFAM = FAM(Ix)
     C                   EVAL      Ix = Ix + 1

     C                   ENDDO

     C                   EVAL      WBalance = WOrigBal

     C                   ENDIF

     C                   IF        FEPIND = 'P'
     C

      ** Set FPC to FAMT / 1000

     C                   EVAL      FPC = FAMT / 1000

     C                   EVAL      WOrigPct = WPct
     C                   EVAL      WFPC = 0                                     (6,3)
     C                   EVAL      Ix = 1

     C                   DOW       WPct > 0 and Ix < 6
     C                   IF        WOrigPct < FPC(Ix) or
     C                             FPC(Ix) = 0
     C                   EVAL      WFeeAmt  = WBalance * WPct
     C**********         EVAL      WOutBala = WBalance                                        CLE106
     C                   EVAL      WOutBala = WBalance * WPct / 100                           CLE106
     C                   EVAL      WOutPct  = 0
     C                   ELSE
     C                   EVAL      WFeeAmt  = (FPC(Ix) - WFPC) * WBalance
     C                   EVAL      WOutBala = (FPC(Ix) - WFPC) * WBalance /+
     C                                        100
     C                   EVAL      WOutPct  = FPC(Ix)
     C                   ENDIF

     C                   EVAL      WFeeAmt = (WFeeAmt * FRT(Ix)) / 100
     C                   EVAL(H)   WFeeAmt   = (WFeeAmt * WNoIntDays2) /+
     C                                          WNumDYr

     C                   IF        WFeeAmt > 0

      ** Update File

     C                   EVAL      WOutTFee  = 0
     C                   EVAL      WOutRate  = FRT(Ix)
     C                   EVAL      WOutFee   = WFeeAmt
     C                   EVAL      WOutIntD  = 0
     C                   EVAL      WOutAmt  = 0
     C                   EXSR      SROutFile

     C                   ENDIF

     C                   EVAL      WTotAmt = WTotAmt + WFeeAmt
     C                   EVAL      WPct = WOrigPct - FPC(Ix)
     C                   EVAL      WFPC = FPC(Ix)
     C                   EVAL      Ix = Ix + 1

     C                   ENDDO
     C                   ENDIF

     C                   IF        WTotAmt > 0

      ** Update File

     C                   SELECT                                                               CLE106
     C                   WHEN      FEPIND='P'                                                 CLE106
     C                             AND WFECALTN<=6                                            CLE106
     C                   EVAL      WOutBala  = WUAmount                                       CLE106
     C                   WHEN      FEPIND='P'                                                 CLE106
     C                             AND WFECALTN<=16                                           CLE106
     C                   EVAL      WOutBala  = WDAmount                                       CLE106
     C                   OTHER                                                                CLE106
     C                   EVAL      WOutBala  = WBalance
     C                   ENDSL                                                                CLE106
     C                   EVAL      WOutTFee  = 0
     C                   EVAL      WOutRate  = 0
     C                   EVAL      WOutFee   = WTotAmt
     C                   EVAL      WOutIntD  = WNoIntDays2
     C                   EVAL      WOutPct   = 0
     C                   EVAL      WOutAmt  = 0
     C                   EXSR      SROutFile

     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRThresh - Threshold calculations                             *
      *****************************************************************
     C     SRThresh      BEGSR

      ** Store balance to output variable so that correct balance is written in file

     C                   EVAL      WOutBala = WBalance

      ** Fee uses amount

     C                   IF        FEPIND = 'A'

      ** Set FAM to limits amounts (FAMT) converted to fee decimal places

     C                   EVAL      WTD = WFeeNBDP + 4
     C                   EVAL      FAM = FAMT * POWER(WTD)
     C                   EVAL      Ix = 1

      ** Look up FAM array to find element which is greater than or equal to the balance

     C     WBalance      LOOKUP    FAM(Ix)                            20  20

     C                   IF        *IN20 = '0'

     C                   EVAL      Ix = 1
     C                   DOW       Ix < 6
     C                   IF        FAM(Ix) = 0 and FRT(Ix) <> 0
     C**********         EVAL      WBalance = WBalance * FRT(Ix)                              CLE106
     C                   EVAL      WBalance = WOutBala * FRT(Ix)                              CLE106
     C                   LEAVE
     C                   ELSE
     C                   EVAL      WBalance = 0
     C                   ENDIF
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      WBalance = WBalance * FRT(Ix)
     C                   ENDIF

     C                   EVAL(H)   WTotAmt  = (WBalance * WNoIntDays2) /+
     C                                          WNumDYr

     C                   ENDIF

      ** Fee uses percentage

     C                   IF        FEPIND = 'P'

      ** Set FPC to FAMT / 1000

     C                   EVAL      FPC = FAMT / 1000
     C                   EVAL      WBalance = WBalance * WPct
     C                   EVAL      Ix = 1

      ** Look up FPC array to find element which is greater than or equal to the percentage

     C     WPct          LOOKUP    FPC(Ix)                            20  20

     C                   IF        *IN20 = '0'

     C                   EVAL      Ix = 1
     C                   DOW       Ix < 6
     C                   IF        FAM(Ix) = 0 and FRT(Ix) <> 0
     C                   EVAL      WBalance = WBalance * FRT(Ix)
     C                   LEAVE
     C                   ELSE
     C                   EVAL      WBalance = 0
     C                   ENDIF
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      WBalance = WBalance * FRT(Ix)
     C                   ENDIF

     C                   EVAL(H)   WTotAmt = ((WBalance / 100) *+
     C                                           WNoIntDays2)/WNumDYr

     C                   ENDIF

     C                   IF        WTotAmt > 0

      ** Update File

     C                   SELECT                                                               CLE106
     C                   WHEN      FEPIND='P'                                                 CLE106
     C                             AND WFECALTN<=6                                            CLE106
     C                   EVAL      WOutBala  = WUAmount                                       CLE106
     C                   WHEN      FEPIND='P'                                                 CLE106
     C                             AND WFECALTN<=16                                           CLE106
     C                   EVAL      WOutBala  = WDAmount                                       CLE106
     C                   ENDSL                                                                CLE106
     C                   EVAL      WOutFee  = WTotAmt
     C                   EVAL      WOutRate = FRT(Ix)
     C                   EVAL      WOutIntD = WNoIntDays2
     C                   EVAL      WOutPct  = 0
     C                   EVAL      WOutAmt  = 0
     C                   IF        FEPIND   = 'P'
     C                   EVAL      WOutPct  = WPct
     C                   ELSE
     C                   EVAL      WOutPct  = 0
     C                   ENDIF
     C                   EXSR      SROutFile

     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SROutFile - Writes to the extract file                        *
      *****************************************************************
     C     SROutFile     BEGSR

      ** Format fields for output to LECFEEPD

     C                   EVAL      CFBRCA = FEBRCA
     C                   EVAL      CFCNUM = FECNUM
     C                   MOVEL     FEFACL        CFFACT
     C                   MOVE      FEFACL        CFFCNO
     C                   EVAL      CFFSEQ = FEFSEQ
     C                   EVAL      CFPDST = WOutSDte
     C                   EVAL      CFPDEN = WOutEDte
     C                   EVAL      CFBALA = WOutBala
     C                   EVAL      CFRATE = WOutRate
     C                   EVAL      CFNUMD = WOutIntD
     C                   EVAL      CFFAMT = WOutFee
     C                   EVAL      CFTAMT = WOutTFee
     C                   EVAL      CFPCT  = WOutPct
     C                   EVAL      CFAAMT = WOutAmt
     C                   WRITE     LECFEED0
     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRRtvCcyDet - Retrieve fee currency details                   *
      *****************************************************************
     C     SRRtvCcyDet   BEGSR

      ** Access AOCURRR0 to get the currency details for the fee currency

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database Error

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 001
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRZINTDY - Compute number of interest days                    *
      *****************************************************************
     C     SRZINTDY      BEGSR

     C                   CALLB     'ZINTDY'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
     C                   PARM                    INT6DY

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRGLINTC - Compute interest for a given period                *
      *****************************************************************
     C     SRGLINTC      BEGSR

      **  Calculate number of days of the calculation method used

     C                   MOVE      ZZCALC        WZZCALC
     C                   EXSR      SRZINTDY

      ** Multiply Rate & Day No. first

     C                   EVAL      WZIWRK1 = ZIAMT * ZIRATE
     C                   IF        WZZCALC = 6
     C                   EVAL      WZIWRK2 = WZIWRK1 * INT6DY
     C                   ELSE
     C                   EVAL      WZIWRK2 = WZIWRK1 * ZZINDY
     C                   ENDIF

     C                   IF        WZZCALC = 2 or WZZCALC = 3 or
     C                             WZZCALC = 5 or WZZCALC = 7 and CIR004 = 'Y'
     C                   EVAL(H)   ZINTR =  WZIWRK2 / 36000
     C                   ENDIF

     C                   IF        WZZCALC = 1 or WZZCALC = 4
     C                   EVAL(H)   ZINTR =  WZIWRK2 / 36500
     C                   ENDIF

     C                   IF        WZZCALC = 6
     C                   EVAL(H)   ZINTR =  WZIWRK2 / 36600
     C                   ENDIF

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * SRZXRate - Cross Rate Calculation                             *
      *****************************************************************
     C     SRZXRate      BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDSR
      *****************************************************************

      /EJECT
      ****************************************************************
      * SRZCONVZ1 - Conversion of amount from one currency to the     *
      *             other                                             *
      ****************************************************************
     C     SRZCONVZ1     BEGSR
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output audit details                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Output Report Header and File Controls.

     C                   WRITE     HEADAU

     C                   WRITE     DBERROR

      ** End Program and Return.

     C                   EVAL      *INLR = True
     C                   RETURN

     C                   ENDSR
      *****************************************************************

      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize program name

     C                   MOVEL     'LE000711  '  DBPGM

     C                   EVAL      CIR004 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *Blanks
     C                   EVAL      CIR004 = 'Y'
     C                   ELSE

      ** Database error

     C                   IF        PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 006
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CIR004'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfAU       BEGSR

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = PSFNumU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      CFBRCA        SEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANKS       ZSErr

     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************                     AR745803
      /EJECT                                                                                AR745803
      *****************************************************************                     AR745803
      *                                                               *                     AR745803
      * SRCLOAN  - Get facilty details using loan reference           *                     AR745803
      *                                                               *                     AR745803
      *****************************************************************                     AR745803
     C     SRCLOAN       BEGSR                                                              AR745803
                                                                                            AR745803
      ** Get loan details                                                                   AR745803
                                                                                            AR745803
     C     FELOAN        CHAIN     CLOAN                                                    AR745803
     C                   IF        %FOUND(CLOAN) = '0'                                      AR745803
     C     *LOCK         IN        LDA                                                      AR745803
     C                   EVAL      DBase  = 008                                             AR745803
     C                   EVAL      DBFile = 'CLOAN'                                         AR745803
     C                   MOVE      LNRF          DBKEY                                      AR745803
     C                   OUT       LDA                                                      AR745803
     C                   EXSR      *PSSR                                                    AR745803
     C                   ENDIF                                                              AR745803
     C                   Z-ADD     CLFTYP        K#FACT                                     AR745803
     C                   Z-ADD     CLFSEQ        K#FCNO                                     AR745803
     C                   EVAL      K#CNUM = CLFCUS                                          AR745803
     C                   MOVEL     K#FACT        FEFACL                                     AR745803
     C                   MOVE      K#FCNO        FEFACL                                     AR745803
                                                                                            AR745803
     C                   ENDSR                                                              AR745803
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

      ** Check to see that *PSSR has not already been called.

     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF

      ** If *PSSR already run, then just end the program here.

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
