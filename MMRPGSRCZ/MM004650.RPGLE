     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Fee and Discount Amortisation A/C Key Gen')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MM004650 - Midas MM Fee and Discount Amortisation A/C Key    *
      *             Generation (Non-Linear)                           *
      *                                                               *
      *  Function:  This program will generate the account key for    *
      *             Fee and Discount Amortisation                     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24989           Date 23Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW208             Date 15Apr08               *
      *                 253286 (BUG16721)  Date 18Apr08               *
      *                 BUG13578           Date 26Mar07               *
      *                 BUG13085C          Date 14Mar07               *
      *                 BUG13085B          Date 06Mar07               *
      *                 BUG13441           Date 06Mar07               *
      *                 BUG13476           Date 04Mar07               *
      *                 BUG13085A          Date 01Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13306           Date 21Feb07               *
      *                 BUG13145           Date 31Jan07               *
      *                 BUG13047           Date 18Jan07               *
      *                 BUG12954           Date 04Jan07               *
      *                 BUG13006           Date 04Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12840           Date 06Dec06               *
      *                 242286             Date 27Sep06               *
      *                 BUG12682           Date 16Nov06               *
      *                 BUG12667           Date 14Nov06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9667            Date 29Dec05               *
      *                 BUG9356            Date 11Dec05               *
      *                 BUG9473            Date 06Dec05               *
      *                 233578             Date 19May05               *
      *                 233601             Date 24May05               *
      *                 233545             Date 18May05               *
      *                 232928             Date 08Apr05               *
      *                 233612             Date 20May05               *
      *                 CAS011             Date 16May05               *
      *                 231708             Date 21Jan05               *
      *                 231271             Date 21Dec04               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24989 - Limit Utilisation Enq - Decimal Data error        *
      *             (Recompile)                                       *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW208 - SWIFT 2008 Changes (Recompile)                      *
      *  253286 - Do not generate non-linear UP/UL when NPV=0 and     *
      *           yield curve=*blanks (BUG16721)                      *
      *  BUG13578 - Incorrect amount of fee amortisation (MM004650P1) *
      *             on the 2nd day of the deal                        *
      *  BUG13085C - Account keys amount not equal to AFDP            *
      *  BUG13085B - Reopen BUG13085.                                 *
      *  BUG13476 - Incorrect Account Keys / Account Key Amounts for  *
      *             discounted deal w/ amortising fee                 *
      *  BUG13441 - Suppress generation of Sale profit / loss account *
      *             key for deals not yet sold.                       *
      *  BUG13085A - Incorrect details on MM004620P1.                 *
      *  BUG13306 - Fee amount reflected incorrect.                   *
      *  BUG13145 - Incorrect Account Keys / Account Key Amounts for  *
      *             discounted deal w/ amortising fee                 *
      *  BUG13047 - Incorrect fee code on the Fee Account Keys Gene-  *
      *             rated Report MM004650P1.                          *
      *  BUG12954 - When writing cashflows for amortisation calcu-    *
      *             lation, do not add 1 day to the event control     *
      *             date even if on 'first' day accrual setting.      *
      *             This is causing an error in the computation       *
      *             of 'all cash flows today' and eventually an error *
      *             in the dirty and clean prices.                    *
      *  BUG13006 - Incorrect report details.                         *
      *             Files DLFEEDL5 and DLFEEDLH are multiple format   *
      *             logical files, should check record format read    *
      *             before referencing data fields.                   *
      *  BUG12840 - MMC004650 00001 failed                            *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  BUG12682 - MMC004600 00001 failed (Recompile)                *
      *  BUG12667 - Record locking error in DLFEEDL5                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9667 - Incorrect report details.                          *
      *  BUG9356- Extended Deal Sub Type (CDL038)                     *
      *  BUG9473 - Use Discount amount (DISA) instead of Discount     *
      *            amount to date (DSAM).                             *
      *  233578 - Ensure correct discount amount for loans maturing   *
      *           today and include maturing loans today              *
      *  233601 - Generate Non Linear account keys.                   *
      *  233545 - Cut-off Date (Recompile)                            *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  233612 - Stop Accruals processing to be included in          *
      *           Nonlinear amortisation computation                  *
      *  CAS011 - EUR/AC Accounting Upgrade to MP1                    *
      *  231708 - Prem. and Disc for Non Linear Amort does not post   *
      *           correctly                                           *
      *  231271 - Program ended with try to write to close file       *
      *           MM004650P1.                                         *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas FD Deal type/subtype file
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Hedging ICD File
     FSDHEDGPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Dealing data
     FSDDEALPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Deals File Live and Historic
     F***DEALSL5   UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FDEALSL8   UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     INFDS(FSDS)
      ** Midas Dealing Fees
     FDLFEEDL1  UF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Fees History File by Deal No/Fee Seq
     FDLFHSTL1  UF   E           K DISK    INFSR(*PSSR)
                                                                                              232928
      ** Midas Dealing Fees                                                                   232928
     FDLFEEDL5  UF   E           K DISK    INFSR(*PSSR)                                       232928
     F                                     RENAME(DLFEEDD0:DLFEEDD5)                          232928
     F                                     RENAME(DLFHSTD0:DLFHSTD5)                          232928
     F                                     INFDS(FEESDS)                                      232928
      ** Midas Dealing Fees                                                                   232928
     FDLFEEDLH  UF   E           K DISK    INFSR(*PSSR)                                       232928
     F                                     RENAME(DLFEEDD0:DLFEEDDG)                          232928
     F                                     RENAME(DLFHSTD0:DLFHSTDG)                          232928
     F                                     INFDS(FEE2SDS)                                     232928
      ** Midas MM Effective Interest Rate Details EATRAN/EASTDT
     FMMEIRDL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas MM Cash Flows Using All-in-Rate                                                232928
     FMMCFSFL0  IF   E           K DISK    INFSR(*PSSR)                                       232928
                                                                                              232928
      ** Midas MM Cashflows File for Amortisation Calc                                        232928
     FMMAMRTL0  UF A E           K DISK    INFSR(*PSSR)                                       232928
                                                                                              232928
      ** Midas Re-valued MM Transactions by Deal Number
     FMMNPVAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MM Cash Flows Using All-in-Rate File
     FMMEIRAL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Deals Generated Account Keys - Detail
     FDKEYSDP   O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(DK)
      ** Midas DL Deals Generated Account Keys - Trailer
     FDKEYSZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DZ)
      ** Non-Linear Discount Amortisation Report
     FMM004650P2O    E             PRINTER INFDS(SPOOL2)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN02)
     F                                     USROPN
      ** Non-Linear Fee Amortisation Report
     FMM004650P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN01)
     F                                     USROPN
      ** Non-Linear Fee Amortisation Audit Report
     FMM004650AUO    E             PRINTER INFDS(SPOOLU)

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

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Midas GL ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** External data structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External data structure for Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External data structure for Branch Details File
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External data structure for Fee codes
     D SDFEE         E DS                  EXTNAME(SDFEEPD)

      ** External data structure for Customer Details File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CAS011

      ** External data structure for EIR File (Current)
     D EIRCurrFmt    E DS                  EXTNAME(MMEIRDPD)

      ** External data structure for EIR File (History)
     D EIRHistFmt    E DS                  EXTNAME(MMEIRHPD)
     D                                     PREFIX(HI:2)
      ** File Information Data Structure for MM004650P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      ** File Information Data Structure for MM004650P1
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0

      ** File Information Data Structure for MM004650AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     ** File Status Data Structure
     D FSDS            DS
     D  FREC             *RECORD
                                                                                              232928
     ** File Status Data Structure for DLFEEDL5                                               232928
     D FEESDS          DS                                                                     232928
     D  FEEREC           *RECORD                                                              232928
                                                                                              232928
     ** File Status Data Structure for DLFEEDLH                                               232928
     D FEE2SDS         DS                                                                     232928
     D  FEE2REC          *RECORD                                                              232928

     D WkAkey          DS
     D  WkDtyp                 1      2
     D  WkTyp1                 3      3
     D  WkDtst                 4      5
     D  WkNlnr                 6      6
     D  WkBlnk                 7      9
     D  WkTyp2                10     10
     D  WkClas                11     14                                                      BUG9356
                                                                                              232928
      ** ZAAMRTCALC Parameter (Alpha)                                                         232928
     D PAmortDSA       S            200A                                                      232928
                                                                                              232928
      ** ZAAMRTCALC DS breakdown                                                              232928
     D PAmortDS        DS           200                                                       232928
     D  PPGMName                     10A   INZ('MM004650')                                    232928
     D  ZEIEIR                       15P10                                                    232928
     D  ZEISTDT                       5P 0                                                    232928
     D  ZEIENDT                       5P 0                                                    232928
     D  DLNO                                                                                  232928
     D  PMaturityDate                 5P 0                                                    233578
     D  WStartDate                    5P 0                                                    232928
     D  WEndDate                      5P 0                                                    232928
     D  WkDisc                       13P 0                                                    232928
     D  WAccInd                       1A   INZ('L')                                           232928
     D  ZEIDPTD                      15P 0                                                    232928
     D  ZEICPTD                      15P 0                                                    232928
     D  WkICBS                        1P 0                                                    232928
     D  WProcType                     1A                                                      232928
     D  WkLoanDepI                    1A                                                      232928
     D  PStopAccrualF                 1A                                                      233612
     D  WkAmortAmt                   17P 0                                                    232928
     D  PDrtPrcTdy                   15P 0                                                    232928
     D  PClnPrcTdy                   15P 0                                                    232928
      *                                                                                       232928
      ** Array containing overrides                                                           232928
     D ##OVR           S             56    DIM(4)  CTDATA PERRCD(1)                           232928
                                                                                              232928
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WkAmount1       S             13P 0 DIM(99)
     D WkAmount2       S             13P 0 DIM(99)
     D WkBackAmt       S             13P 0 DIM(99)
     D WkFeeSeq        S              2  0 DIM(99)                                            232928
     D WAmortAmount    S             15P 0 DIM(99)                                            232928
     D WFeePostAmt     S             15P 0 DIM(99)                                            232928
     D WkFval          S                   LIKE(PCPL)
     D WkBrca          S                   LIKE(BRCA)
     D***WkAmortAmt      S                   LIKE(PCPL)                                       232928
     D WkAmorToti      S             13P 0
     D WkToti1         S                   LIKE(DISA)
     D***WkToti2         S                   LIKE(DISA)                                       232928
     D WkAmtSum1       S             13P 0
     D WkAmtSum2       S             13P 0
     D WkAmtSumB       S             13P 0
     D***WkAmtSumH       S             13P 0                                                  232928
     D WkSumAll        S             13P 0
     D WAllFeePostAmt  S             18P 0                                                    232928
     D***WkNetPcpl       S             13P 0                                                  232928
     D***WkClnPrc        S              8F                                                    232928
     D***WkPrvClnPrc     S              8F                                                    232928
     D WWAMDS          S                   LIKE(AMDS)
     D WkAmtKey        S                   LIKE(DFAMTS)
     D WkKeyAmt        S             13S 0
     D WkKeyAmt1       S                   LIKE(DKEAMT)
     D WkKeyAmtSav     S                   LIKE(DKEAMT)
     D WkEvcd          S              5  0
     D WkTime          S              4F
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
     D***WKSUBEA         S             15P 0                                      BUG13085C BUG13578
     D***WkKeyAmtADD     S             13S 0                                      BUG13085C BUG13578

      ** Fields used in GLZADD/GLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWk2           S              4  0
     D ZZWk3           S             15  0
     D ZZNEGD          S              5

     D PRetCode        S              7A
     D POption         S              7A
     D PCurrency       S              3A

     D WEvCD           S              5P 0
     D WAmortAmnt      S             20P 0
     D RQDLN1          S              3S 0
     D RQDLN2          S              3S 0
     D DIFLN1          S              3S 0
     D DIFLN2          S              3S 0
     D SvBRCA          S              3A
     D WkDLNO          S                   LIKE(DLNO)
     D WkFSEQ          S                   LIKE(DFFSEQ)
     D WkSdat          S                   LIKE(DFPSTD)
     D PBRCA           S              3A
      ** ZSEdit parms
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
      ** Return code
     D PRtCd           S              7A
      ** Option
     D POpTn           S              7A
      ** Switchable feature ID (for AOSARDR0)
     D PSARD           S              6A
      ** ZSFile parms
     D ZSEQ            S              5A
     D ZSENTY          S              3A
     D ZSNUM           S              6S 0
     D ZSERR           S              1A
     D WRCOUNT         S              5S 0
     D RCOUNT          S              5S 0
     D RCOUNTF         S              5S 0
     D RCOUNTD         S              5S 0
     D WDaysInYear     S              3S 0
     D WID1            S              3S 0
     D WID2            S              3S 0
     D***WkAccrued       S                   LIKE(AIPD)                                       232928
     D WkUAFA          S                   LIKE(DFUAFA)
     D WkFcod          S              2A
     D***WkICBS          S              1A                                                    232928
     D***WkICBSH         S              1A                                                    232928
     D WkICBSH         S              1P 0                                                    232928
     D WkDiff          S                   LIKE(DFAMTD)
     D WkAmtd          S                   LIKE(DFAMTD)
     D WkAmtd2         S                   LIKE(DFAMTD)
     D WkMult          S              3  0
     D WSavprocType    S              1                                                    BUG13085A

     D KDate           S              5P 0                                                    232928
     D KTran           S              6S 0                                                    232928
     D KFeeSeq         S              2S 0                                                    232928
                                                                                              232928
      ** QCMDEXC Parameters                                                                   232928
     D PCommand        S             56A                                                      232928
     D PCmdLen         S             15P 5 INZ(56)                                            232928
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Perform Initialisation.

     C                   EXSR      Init
      ** Exit program when amortisation method is Linear
     C                   IF        FSAMRM = 'L'
     C                   GOTO      EXIT
     C                   ENDIF
      ***Read*all*records*from*DEALSL5*********************************                       CAS011
     C******LOVAL        SETLL     DEALSL5                                                    CAS011
     C**********         READ      DEALSL5                                                    CAS011
     C**********         IF        %EOF(DEALSL5)                                              CAS011
      ** Read all records from DEALSL8                                                        CAS011
     C     *LOVAL        SETLL     DEALSL8                                                    CAS011
     C                   READ      DEALSL8                                                    CAS011
     C                   IF        %EOF(DEALSL8)                                              CAS011
     C                   EXSR      SrAudit
     C                   ELSE

     C**********         DOW       NOT %EOF(DEALSL5)                                          CAS011
     C                   DOW       NOT %EOF(DEALSL8)                                          CAS011
     C     DTSTKY        CHAIN     FDDTSTL1
     C                   IF        %FOUND(FDDTSTL1)
     C                   IF        FSACAI = 'Y'
     C     DLNO          CHAIN     MMEIRDL0
     C                   IF        %FOUND(MMEIRDL0) AND EIFDPA <> *ZERO
     C                   IF        BRCA <> SvBRCA
      ** Close the previous branch's spool files

     C                   IF        SvBRCA <> *BLANKS
     C                   EXSR      ClsP1
     C                   EXSR      ClsP2
     C                   ENDIF
      ** Access the next Branch's Details

     C                   EVAL      PBRCA = BRCA
     C                   EXSR      SrBranch

      ** Open the next branch's spool files

     C                   EXSR      OpnP1
     C                   EXSR      OpnP2
     C                   EVAL      SvBRCA = BRCA
     C                   ENDIF
     C                   EXSR      SRProcess
     C                   EXSR      SRAmortise
     C                   UPDATE    MMEIRDD0
     C                   SELECT
     C                   WHEN      FREC = 'DEALSDCF'
     C                   UPDATE    DEALSDCF
     C                   WHEN      FREC = 'DEALSDDF'
     C                   UPDATE    DEALSDDF
     C                   WHEN      FREC = 'DLCHISD0'
     C                   UPDATE    DLCHISD0
     C                   WHEN      FREC = 'DLDHISD0'
     C                   UPDATE    DLDHISD0
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C**********         READ      DEALSL5                                                    CAS011
     C                   READ      DEALSL8                                                    CAS011
     C                   ENDDO

     C                   SETON                                        32
      ** Close Spool Files
      ** Only write if the file is being written before                                       231271
     C                   IF        P1OPEN = 'Y'                                               231271
                                                                                              231271
     C                   EXSR      ClsP1
     C                   ENDIF                                                                231271
     C                   IF        P2OPEN = 'Y'                                               231271
     C                   EXSR      ClsP2
     C                   ENDIF                                                                231271
      ** Update Trailer File

     C                   EXSR      SRUpdTrl
      ** Write to trailer
     C                   EXSR      SrAudit
     C                   ENDIF
     C     EXIT          TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Process deal records                              *
      *                                                               *
      *****************************************************************

     C     SrProcess     BEGSR

     C                   IF        FREC = 'DEALSDCF' OR FREC = 'DEALSDDF'
     C                   EXSR      SrFeeReverse
     C                   ELSE
     C                   EXSR      SrDealReverse
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFeeReverse - Generate account key for Fee Reversal.         *
      *                                                               *
      *****************************************************************

     C     SrFeeReverse  BEGSR
     C     DLNO          SETLL     DLFEEDL1
     C     DLNO          READE     DLFEEDL1
     C                   IF        %EOF(DLFEEDL1)
     C                   GOTO      EndFeeRev
     C                   ELSE
     C                   DOW       NOT %EOF(DLFEEDL1)
      ** Generate reversal account key when Non-Linear Amortised discount
      ** to date is not zero.
     C                   IF        DFAMTD <> 0 AND DFRECI = '*'
     C                             AND WkEvcd = DFLCHD
     C                   EVAL      WWAMDS = DFAMTD
     C                   EVAL      RRIND = '1'
     C                   EVAL      WkKeyAmt = WWAMDS
     C                   IF        WkKeyAmt <> *ZERO
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTF = RCOUNTF + 1
     C                   EXSR      SrAccKey1
     C                   EXSR      SrWriteP1
     C                   ENDIF
     C                   EVAL      WkDLNO = DLNO
     C                   EVAL      WkFseq = DFFSEQ
     C                   EVAL      WkSdat = DFPSTD
     C     DLFEKEY       CHAIN     MMEIRAL3
     C                   IF        %FOUND(MMEIRAL3)
     C                   EVAL      EIFDPA = EIFDPA - EAAMNT
     C                   IF        DFFCCY <> CCY
     C                   EVAL      WkAMTD2 = DFAMTD
     C                   ELSE
     C                   SELECT
     C                   WHEN      EAMDIN = 'M'
     C                   EVAL      WkAMTD2 = DFAMTD * EAXRAT
     C                   WHEN      EAMDIN = 'D'
     C                   EVAL      WkAMTD2 = DFAMTD / EAXRAT
     C                   ENDSL
     C                   ENDIF
     C                   EVAL      EIAMTD = EIAMTD - WkAMTD2
     C                   ENDIF
     C                   ENDIF
     C     DLNO          READE     DLFEEDL1
     C                   ENDDO
     C                   ENDIF
                                                                                              233601
      ** Post reversal for Fee amount to be amortised non-linearly                            233601
                                                                                              233601
     C     DLNO          SETLL     DLFEEDL5                                                   233601
     C     DLNO          READE     DLFEEDL5                                                   233601
     C                   DOW       NOT %EOF(DLFEEDL5)                                         233601
     C                             AND %FOUND(DLFEEDL5)                                       233601
     C**********         IF            DFRECI = '*'                                  233601 BUG13006
     C**********                   AND DFNLAI = 'Y'                                  233601 BUG13006
     C                   IF        FEEREC = 'DLFEEDD5' AND                                  BUG13006
     C                             DFRECI = '*'        AND                                  BUG13006
     C                             DFNLAI = 'Y'        OR                                   BUG13006
     C                             FEEREC = 'DLFHSTD5' AND                                  BUG13006
     C                             HIRECI = '*'        AND                                  BUG13006
     C                             DFNLAI = 'Y'                                             BUG13006
     C**********         EVAL      WkKeyAmt = DFFEAM                                  233601 BUG9667
     C                   IF        FEEREC = 'DLFEEDD5'                                      BUG13006
     C                   EVAL      WkKeyAmt = DFFAMT                                         BUG9667
     C                   ELSE                                                               BUG13006
     C                   EVAL      WkKeyAmt = HIAMTS                                        BUG13006
     C                   ENDIF                                                              BUG13006
     C                   EVAL      DKREVI = 1                                                 233601
     C                   EXSR      SrAccKey4                                                  233601
     C                   EXSR      SrWriteP3                                                  233601
     C                   EVAL      DFNLAI = 'R'                                               233601
     C                   IF        FEEREC = 'DLFEEDD5'                                        233601
     C                   UPDATE    DLFEEDD5                                                   233601
     C                   ELSE                                                                 233601
     C                   UPDATE    DLFHSTD5                                                   233601
     C                   ENDIF                                                                233601
     C                   EVAL      RCOUNT = RCOUNT + 1                                        233601
     C                   EVAL      RCOUNTF = RCOUNTF + 1                                      233601
     C                   ELSE                                                               BUG12667
     C                   UNLOCK    DLFEEDL5                                                 BUG12667
     C                   ENDIF                                                                233601
     C     DLNO          READE     DLFEEDL5                                                   233601
     C                   ENDDO                                                                233601
                                                                                              233601
     C     EndFeeRev     ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDealReverse - Generate account key for Deal Reversal.       *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SrDealReverse BEGSR

     C                   EVAL      EIRECI = '*'
      ** Generate reversal account key when Non-Linear Amortised discount
      ** to date is not zero.
     C                   IF        AMDS <> 0
     C                   EVAL      WWAMDS = AMDS
     C                   EVAL      RRIND = '1'
     C                   EVAL      DKREVI = 1
     C                   EVAL      WkNlnr = 'N'
     C                   EVAL      WkBlnk = *BLANK
     C
     C                   EVAL      WkKeyamt = WWAMDS
     C                   IF        WkKeyAmt <> *ZERO
     C                   EXSR      SrAccKey2
     C                   ENDIF
     C                   EVAL      AMDS = 0
     C                   ENDIF
      ** Generate reversal account key for unrealised re-valued profit
     C                   IF        YAINT <> *ZERO
     C                   EVAL      WkKeyAmt = YAINT
     C                   EVAL      YAINT = *ZERO
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      RRIND = '1'
     C                   EVAL      DKREVI = 1
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkNlnr = *BLANK
     C                   MOVE      'NU'          WkBlnk
     C                   IF        WkKeyAmt < *ZERO
     C                   EVAL      WkTyp2 = 'L'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortise - Compute amount to amortise for the period        *
      *                                                               *
      *****************************************************************

     C     SrAmortise    BEGSR
      *                                                                                       232928
      ** Codes Relevant to the Computation of the Amortisation Amount has                     232928
      ** been commented out of this program and is now being done in                          232928
      ** ZAAMRTCALC                                                                           232928
                                                                                              232928
     C                   EVAL      WkAmount1 = *ZERO
     C                   EVAL      WkAmount2 = *ZERO
     C                   EVAL      WkBackAmt = *ZERO
     C                   EVAL      WkAmtSum1 = *ZERO
     C                   EVAL      WkAmtSum2 = *ZERO
     C                   EVAL      WkAmtSumB = *ZERO
     C                   EVAL      WkFeeSeq = *ZERO                                           232928
      *                                                                                       232928
     C                   EVAL      WAmortAmount(*) = *ZERO                                    232928
      *                                                                                       232928
     C**********         IF        WkICBSH = *BLANKS                                          232928
     C**********         MOVE      ICBS          WkICBS                                       232928
     C                   IF        WkICBSH = 0                                                232928
     C                   EVAL      WkICBS = ICBS                                              232928
     C                   ELSE
     C                   EVAL      WkICBS = WkICBSH
     C                   ENDIF
      ** Compute for today's amortisation
     C                   IF        RCDT = 'C'
     C                   EVAL      WkFVal = PCPL
     C                   EVAL      WkToti1 = *ZERO
     C**********         EVAL      WkToti2 = *ZERO                                            232928
     C                   ELSE
     C                   EVAL      WKFVAL = FVAL
     C                   IF        BNNAIA = 'Y'
     C                   EVAL      WkToti1 = FVAL - PUPR
     C                   ELSE
     C                   EVAL      WkToti1 = DISA
     C                   ENDIF
     C**********         EVAL      PZCALC = WkICBS                                            232928
     C**********         IF        VDAT < ORED                                                232928
     C**********         EVAL      PZBEG = ORED                                               232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      PZBEG = VDAT                                               232928
     C**********         ENDIF                                                                232928
     C**********         EVAL      PZEND = EIENDT                                             232928
     C**********         EXSR      SrZINTDY                                                   232928
     C**********         IF        BKALDI = 'Y'                                               232928
     C**********         EVAL      WkTime = PZINDY                                            232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkTime = PZINDY + 1                                        232928
     C**********         ENDIF                                                                232928
     C**********         EVAL      WkToti2 = WkToti1 / WkTime                                 232928
     C                   ENDIF
                                                                                              232928
      ** Fee Amortisations                                                                    232928
     C                   EVAL      WkDLNO = DLNO
     C                   EVAL      WId1 = 1
     C*****DLNO          SETLL     DLFEEDL1                                                   232928
     C*****DLNO          READE     DLFEEDL1                                                   232928
     C**********         IF        %EOF(DLFEEDL1)                                             232928
                                                                                              232928
     C     DLNO          SETLL     DLFEEDL5                                                   232928
     C*****DLNO*         READE     DLFEEDL5                                          232928 BUG12667
     C     DLNO          READE(N)  DLFEEDL5                                                 BUG12667
                                                                                              232928
     C                   IF        %EOF(DLFEEDL5)                                             232928
                                                                                              232928
     C                   EVAL      WkAmtSum1 = *ZERO
     C                   EVAL      WkAmtSum2 = *ZERO
     C                   EVAL      WkAmtSumB = *ZERO
     C                   EVAL      WId1 = *ZERO
                                                                                              232928
     C                   ELSE
     C**********         DOW       NOT %EOF(DLFEEDL1)                                         232928
     C**********         IF        DFAMTS <> *ZERO AND DFRECI = 'D'                           232928
     C**********                   AND DFPYON = 'S'                                           232928
     C**********         IF        DFADJY = 'Y'                                               232928
                                                                                              232928
     C                   DOW       NOT %EOF(DLFEEDL5)                                         232928
     C                   IF        FEEREC = 'DLFEEDD5'                                        232928
     C                   EVAL      WkFeeRECI = DFRECI                                         232928
     C                   EVAL      WkFeeDLNO = DFDLNO                                         232928
     C                   EVAL      WkFeeFSEQ = DFFSEQ                                         232928
     C                   EVAL      WkFeeFCCY = DFFCCY                                         232928
     C                   EVAL      WkFeeFAMT = DFFAMT                                         232928
     C                   EVAL      WkFeeAMTD = DFAMTD                                         232928
     C                   EVAL      WkFeeADJY = DFADJY                                         232928
     C                   ELSE                                                                 232928
     C                   EVAL      WkFeeRECI = HIRECI                                         232928
     C                   EVAL      WkFeeDLNO = HIDLNO                                         232928
     C                   EVAL      WkFeeFSEQ = HIFSEQ                                         232928
     C                   EVAL      WkFeeFCCY = HIFCCY                                         232928
     C                   EVAL      WkFeeFAMT = HIAMTS                                         232928
     C                   EVAL      WkFeeAMTD = HIAMTD                                         232928
     C                   MOVEL     HIFCOD        PFeeC             2                          232928
     C                   CALL      'AOFEER0'                                                  232928
     C                   PARM      *BLANKS       PRtCd                                        232928
     C                   PARM      '*KEY   '     POptn                                        232928
     C                   PARM                    PFeeC                                        232928
     C     SDFEE         PARM      SDFEE         DSFDY                                        232928
     C                   EVAL      WkFeeADJY = AUADJY                                         232928
     C                   ENDIF                                                                232928
                                                                                              232928
      ** Process all live fees whose cashflow date is within the EIR period.                  232928
     C                   IF        WkFeeRECI <> 'R' AND                                       232928
     C                             WkFeeRECI <> '*' AND                                      BUG9667
     C                             WkFeeDLNO <> *ZERO AND                                     232928
     C                             WkFeeADJY = 'Y' AND                                        232928
     C                             WkFeeAMTD <> WkFeeFAMT                                     232928
                                                                                              232928
      *                                                                                       232928
     C                   EVAL      WkFeeSeq(WId1) = WkFeeFSEQ                                 232928
                                                                                              232928
     C                   EVAL      KTran = WkFeeDLNO                                          232928
     C                   EVAL      KFeeSeq = WkFeeFSEQ                                        232928
     C     KFee          CHAIN     MMEIRAL3                                                   232928
                                                                                              232928
     C                   IF        WkFeeFCCY = CCY                                            232928
     C                   EVAL      WkAmount1 (WId1) = WkFeeFAMT                               232928
     C                   EVAL(R)   WAmortAmount (WId1) = WkFeeAMTD                            232928
     C                   IF        FEEREC = 'DLFHSTD5'                                        232928
     C                             AND %FOUND(MMEIRAL3)                                       232928
     C                   EVAL      WkAmount1 (WId1) = EAAMNT                                  232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   ELSE                                                                 232928
                                                                                              232928
     C                   IF        %FOUND(MMEIRAL3)                                           232928
     C                   EVAL      WkAmount1 (WId1) = EAAMNT                                  232928
     C                   IF        EAMDIN = 'M'                                               232928
     C                   EVAL(R)   WAmortAmount(WId1)= WkFeeAMTD * EAXRAT                     232928
     C                   ELSE                                                                 232928
     C                   EVAL(R)   WAmortAmount(WId1)= WkFeeAMTD / EAXRAT                     232928
     C                   ENDIF                                                                232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   ENDIF                                                                232928
     C                   EVAL      WId1 = WId1 + 1                                            232928
                                                                                              232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C*****DLNO*         READE     DLFEEDL5                                          232928 BUG12667
     C     DLNO          READE(N)  DLFEEDL5                                                 BUG12667
     C                   ENDDO                                                                232928
                                                                                              232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   Z-ADD     0             WkAmtSum1                                    232928
                                                                                              232928
     C                   IF        WId1 >= 1                                                  232928
     C                   XFOOT     WkAmount1     WkAmtSum1                                    232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C**********         IF        DFFCCY = CCY                                               232928
     C**********         EVAL      WkAmount1 (WId1) = DFAMTS                                  232928
     C**********         EVAL      WkBackAmt (WId1) = DFUAFA                                  232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkFseq = DFFSEQ                                            232928
     C**********         EVAL      WkSdat = DFPSTD                                            232928
     C*****DLFEKEY       CHAIN     MMEIRAL3                                                   232928
     C**********         IF        %FOUND(MMEIRAL3)                                           232928
     C**********         EVAL      WkAmount1 (WId1) = EAAMNT                                  232928
     C**********         IF        EAMDIN = 'M'                                               232928
     C**********         EVAL      WkBackAmt(WId1) = DFUAFA * EAXRAT                          232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkBackAmt(WId1) = DFUAFA / EAXRAT                          232928
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C**********         EVAL      PZCALC = WkICBS                                            232928
     C**********         IF        DFPSTD < DFORED                                            232928
     C**********         EVAL      PZBEG = DFORED                                             232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      PZBEG = DFPSTD                                             232928
     C**********         ENDIF                                                                232928
     C**********         EVAL      PZEND = EIENDT                                             232928
     C**********         EXSR      SrZINTDY                                                   232928
     C**********         IF        BKALDI = 'Y'                                               232928
     C**********         EVAL      WkTime = PZINDY                                            232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkTime = PZINDY + 1                                        232928
     C**********         ENDIF                                                                232928
     C**********         IF        DFLDAT = *ZERO                                             232928
     C**********         IF        DFPSTD < DFORED                                            232928
     C**********         SELECT                                                               232928
     C**********         WHEN      BKALDI = 'Y'                                               232928
     C**********         EVAL      WkMult = WkEvcd - DFORED                                   232928
     C**********         OTHER                                                                232928
     C**********         EVAL      WkMult = WkEvcd - DFORED + 1                               232928
     C**********         ENDSL                                                                232928
     C**********         ELSE                                                                 232928
     C**********         SELECT                                                               232928
     C**********         WHEN      BKALDI = 'Y'                                               232928
     C**********         EVAL      WkMult = WkEvcd - DFPSTD                                   232928
     C**********         OTHER                                                                232928
     C**********         EVAL      WkMult = WkEvcd - DFPSTD + 1                               232928
     C**********         ENDSL                                                                232928
     C**********         ENDIF                                                                232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkMult = WkEvcd - DFLDAT                                   232928
     C**********         ENDIF                                                                232928
     C**********         EVAL      WkAmount2(WId1) = WkAmount1(WId1) / WkTime                 232928
     C**********                                    * WkMult                                  232928
     C**********         EVAL      WId1 = WId1 + 1                                            232928
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C*****DLNO*         READE     DLFEEDL1                                                   232928
     C**********         ENDDO                                                                232928
     C**********         IF        WId1 >= 1                                                  232928
     C**********         XFOOT     WkAmount1     WkAmtSum1                                    232928
     C**********         XFOOT     WkAmount2     WkAmtSum2                                    232928
     C**********         XFOOT     WkBackAmt     WkAmtSumB                                    232928
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C*****DLNO*         SETLL     DLFHSTL1                                                   232928
     C*****DLNO*         READE     DLFHSTL1                                                   232928
     C**********         IF        %EOF(DLFHSTL1)                                             232928
     C**********         EVAL      WkAmtSumH = *ZERO                                          232928
     C**********         ELSE                                                                 232928
     C**********         DOW       NOT %EOF(DLFHSTL1)                                         232928
     C**********         CALL      'AOFEER0'                                                  232928
     C**********         PARM      *BLANKS       PRtCd                                        232928
     C**********         PARM      '*KEY   '     POptn                                        232928
     C**********         PARM                    HIFCOD                                       232928
     C*****SDFEE         PARM      SDFEE         DSFDY                                        232928
     C**********         IF        AUADJY = 'Y'                                               232928
     C**********         IF        DFFCCY = CCY                                               232928
     C**********         EVAL      WkAmtSumH = WkAmtSumH + HIAMTS                             232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkFseq = HIFSEQ                                            232928
     C*****DLFEKEY       CHAIN     MMEIRAL3                                                   232928
     C**********         IF        %FOUND(MMEIRAL3)                                           232928
     C**********         EVAL      WkAmtSumH = WkAmtSumH + EAAMNT                             232928
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C*****DLNO*         READE     DLFHSTL1                                                   232928
     C**********         ENDDO                                                                232928
     c**********         ENDIF                                                                232928
     C**********         EVAL      WkNetPcpl = WkFval - WkToti1 - WkAmtSum1                   232928
     C**********                               - WkAmtSumH                                    232928
      ** Compute*for*the*Accrued*Interest******************************                       232928
     C**********         EVAL      WkAccrued = AIPD - IPRD + AIAP                             232928
                                                                                              232928
      ** Last Accrual Date is the EIR Start Date when the Last                                232928
      ** Amortisation Date is Zero                                                            232928
     C                   EVAL      KDate = EISTDT                                             232928
     C                   IF        EILADT = *ZERO                                             232928
     C                   EVAL      WStartDate = EISTDT                                        232928
     C                   ELSE                                                                 232928
     C                   EVAL      WStartDate = EILADT                                        232928
     C                   ENDIF                                                                232928
      ***Compute*for*time**********************************************                       232928
     C**********         EVAL      PZCALC = WkICBS                                            232928
     C**********         EVAL      PZBEG = EISTDT                                             232928
     C**********         EVAL      PZEND = WkEvcd                                             232928
     C**********         EXSR      SrZINTDY                                                   232928
      *                                                                                       232928
      ** Check if the system is set to Last Day Accrual                                       232928
      *                                                                                       232928
     C                   IF        BKALDI <> 'Y'                                              232928
     C                   EVAL      WAccInd = 'F'                                              232928
     C                   ENDIF                                                                232928
     C**********         IF        BKALDI = 'Y'                                               232928
     C**********         EVAL      WkTime = PZINDY                                            232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkTime = PZINDY + 1                                        232928
     C**********         ENDIF                                                                232928
     C**********         EXSR      SrGetYearNo                                                232928
     C**********         EVAL      WkTime = WkTime / WDaysInYear                              232928
      ***Compute*for*the*Clean*Price***********************************                       232928
     C**********         EVAL      WkClnPrc =  WkNetPcpl * (1 + EIEIR) ** Wktime              232928
     C**********                               - (WkAccrued)                                  232928
                                                                                              232928
      ** Obtain Cashflows from MMCFLSPD                                                       232928
     C     KCashFlow     SETLL     MMCFSFL0                                                   232928
     C     KCashFlow     READE     MMCFSFL0                                                   232928
                                                                                              232928
      ** Write all cashflows from EIR Start to Event Control Date                             232928
                                                                                            BUG12954
      ** Select cashflows up to event control date only whether                             BUG12954
      ** on first or last day accrual                                                       BUG12954
                                                                                            BUG12954
     C                   DOW       NOT %EOF(MMCFSFL0)                                         232928
     C                             AND MFFLDT <= WkEvcd                                       232928
     C**********                   AND WAccInd = 'L'                                 232928 BUG12954
     C**********                   OR NOT %EOF(MMCFSFL0)                             232928 BUG12954
     C**********                   AND MFFLDT <= (WkEvcd + 1)                        232928 BUG12954
     C**********                   AND WAccInd = 'F'                                 232928 BUG12954
                                                                                              232928
      ** Exclude start amount                                                                 232928
     C                   IF        MFFTYP = 'SAMT'                                            232928
     C                             OR MFFTYP = 'SSAM'                                         232928
      ** Non-fees equal to EIR period start date                                              232928
     C                             OR MFFTYP <> 'EFAC' AND MFFTYP <> 'SFAM'                   232928
     C                             AND MFFTYP <> 'SFBT' AND MFFLDT = EISTDT                   232928
      ** Shadow rollover principal only.                                                      232928
     C                             OR MFFTYP = 'ROPR' AND MFFLDT = EISTDT                     232928
                                                                                              232928
     C     DLNO          READE     MMCFSFL0                                                   232928
     C                   ITER                                                                 232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C**********         EVAL      EPTNMR = MFDLNO                                     232928 CLE148
     C                   MOVEL     MFDLNO        EPTNMR                                       CLE148
     C                   EVAL      EPFLDT = MFFLDT                                            232928
     C                   EVAL      EPCAMT = MFCAMT                                            232928
     C                   EVAL      EPIOIN = MFIOIN                                            232928
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
      ** If a cashflow written is a fee that is not in Loan Currency,                         232928
      ** obtain the converted amount from MMEIRAPD before writing                             232928
      ** to ZAAMRTPD                                                                          232928
                                                                                              232928
     C                   IF        MFCYCD <> CCY                                              232928
                                                                                              232928
     C                   EVAL      KTran = MFDLNO                                             232928
     C                   EVAL      KFeeSeq = MFFSEQ                                           232928
                                                                                              232928
     C                   EVAL      KTran = MFDLNO                                             232928
     C                   EVAL      KFeeSeq = MFFSEQ                                           232928
     C     KFee          CHAIN     MMEIRAL3                                                   232928
                                                                                              232928
     C                   IF        %FOUND(MMEIRAL3)                                           232928
     C                   EVAL      EPCAMT = EAAMNT                                            232928
     C                   ENDIF                                                                232928
     C                   ENDIF                                                                232928
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
      *                                                                                       232928
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
     C     DLNO          READE     MMCFSFL0                                                   232928
                                                                                              232928
     C                   ENDDO                                                                232928
                                                                                              232928
      ** Override MMAMRTPD                                                                    232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM      ##OVR(1)      PCommand                                     232928
     C                   PARM                    PCmdLen                                      232928
                                                                                              232928
      ** Override MMHISTL0                                                                    232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM      ##OVR(3)      PCommand                                     232928
     C                   PARM                    PCmdLen                                      232928
      *                                                                                       232928
     C*********          IF        DSAM <> *ZEROS                                     232928 BUG9473
     C                   IF        FREC = 'DEALSDDF' AND                                     BUG9473
     C                             DISA <> *ZEROS                                            BUG9473
     C                   EVAL(R)   WkDisc     = DISA                                         BUG9473
     C                   EVAL      WProcType = 'D'                                            232928
     C                   ELSE                                                                 232928
     C                   EVAL(R)   WkDisc     = 0                                            BUG9473
     C                   EVAL      WProcType = ' '                                            232928
     C                   ENDIF                                                                232928
      *                                                                                       232928
     C                   IF        WkEvcd    < EIENDT                                         232928
     C                   EVAL      WEndDate = WkEvcd                                          232928
     C                   Else                                                                 232928
     C                   EVAL      WEndDate = EIENDT                                          232928
     C                   EndIf                                                                232928
      *                                                                                       232928
     C                   Z-ADD     EIEIR         ZEIEIR                                       232928
     C                   Z-ADD     EISTDT        ZEISTDT                                      232928
     C                   Z-ADD     EIENDT        ZEIENDT                                      232928
     C                   Z-ADD     EIDPTD        ZEIDPTD                                      232928
     C                   Z-ADD     EICPTD        ZEICPTD                                      232928
     C**********         Z-ADD     0             WkDisc                               232928 BUG9473
                                                                                              232928
     C                   EVAL      PMaturityDate = MDAT                                       233578
     C                   EVAL      PStopAccrualF = ' '                                        233612
                                                                                              233612
     C                   IF           DTYP = 'IT'                                             232928
     C                             Or DTYP = 'TD'                                             232928
     C                             Or DTYP = 'CI'                                             232928
     C                             Or DTYP = 'CD'                                             232928
     C                   EVAL      WkLoanDepI = 'D'                                           232928
     C                   ELSE                                                                 232928
     C                   EVAL      WkLoanDepI = 'L'                                           232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   IF        WProcType = 'D'                                         BUG13085A
     C                   EVAL      WSavprocType = WProcType                                BUG13085A
     C                   EVAL      WProcType = ' '                                         BUG13085A
     C                   ENDIF                                                             BUG13085A
     C                   MOVE      PAMORTDS      PAmortDSA                                    232928
                                                                                              232928
      ** Call Amortisation Calculator                                                         232928
     C                   CALLB     'ZAAMRTCALC'                                               232928
     C                   PARM                    PAmortDSA                                    232928
                                                                                              232928
     C                   MOVEL     PAmortDSA     PAMORTDS                                     232928
      *                                                                                       232928
     C                   IF        WSavprocType = 'D'                                      BUG13085A
     C                   EVAL      WProcType = WSavprocType                                BUG13085A
     C                   ENDIF                                                             BUG13085A
     C                   Z-ADD     ZEIEIR        EIEIR                                        232928
     C                   Z-ADD     ZEISTDT       EISTDT                                       232928
     C                   Z-ADD     ZEIENDT       EIENDT                                       232928
     C                   Z-ADD     ZEIDPTD       EIDPTD                                       232928
     C                   Z-ADD     ZEICPTD       EICPTD                                       232928
                                                                                              232928
      ** Update Last Amortisation Date                                                        232928
     C                   EVAL      EILADT = WEndDate                                          232928
     C                   IF        EIAMAJ <> 0                                                232928
     C                   EVAL      WkAmortAmt = WkAmortAmt + EIAMAJ                           232928
     C                   EVAL      EIAMAJ = 0                                                 232928
     C                   ELSE                                                                 232928
     C                   EVAL      WkAmortAmt = WkAmortAmt + EIAMTD                           232928
     C                   ENDIF                                                                232928
                                                                                              232928
      ** Delete Override                                                                      232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM      ##OVR(2)      PCommand                                     232928
     C                   PARM                    PCmdLen                                      232928
      *                                                                                       232928
     C                   CALL      'QCMDEXC'                                                  232928
     C                   PARM      ##OVR(4)      PCommand                                     232928
     C                   PARM                    PCmdLen                                      232928
                                                                                              232928
      ** Update yesterday's amortised cost
     C                   EVAL      YACOST = AMCOST
      ** Amortised cost
     C**********         EVAL      AMCOST = WkClnPrc                                          232928
     C                   EVAL      AMCOST = PDrtPrcTdy                                        232928
      ** Previous Clean Price
     C**********         EVAL      WkPrvClnPrc = EIPRCP                                       232928
     C**********         IF        WkPrvClnPrc <> *ZERO                                       232928
      ** Compute for the Amortisation Amount
     C**********         EVAL      WkAmortAmt = WkClnPrc - WkPrvClnPrc                        232928
     C**********         ELSE                                                                 232928
     C**********         EVAL      WkAmortAmt = WkClnPrc - WkNetPcpl                          232928
     C**********         ENDIF                                                                232928
      *                                                                                       232928
      ** Compute for the sum of the total discount and fee amount (discount and premium)
     C**********         EVAL      WkSumAll = WkToti2 + WkAmtSum2                             232928
     C                   EVAL      WkSumAll = WkToti1 + WkAmtSum1                             232928
      ** Compute for the proportioned amortisation amount for each Fee, Discount or Premium
     C                   IF        WkSumAll <> *ZERO
     C                   EXSR      SrAmortFDP
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortFDP - Compute for the proportioned amortisation amount *
      *              for each Fee, Discount or Premium.               *
      *                                                               *
      *****************************************************************

     C     SrAmortFDP    BEGSR
     C**********         EVAL      WId2 = 1                                                   232928
      ** Compute for the proportioned amount of total discount
     C**********         EVAL      WkAmorToti = WkToti2 / WkSumAll * WkAmortAmt               232928
     C                   EVAL      WkAmorToti = WkToti1 / WkSumAll * WkAmortAmt               232928
     C                                                             - AMDS                     232928
      ** On the fee's last day of amortisation, post the difference                           232928
      ** between the total interest amount and it's non-linear                                232928
      ** amortisation amount to date thus avoid discrepancies between                         232928
      ** the final non-linear amortisation to date and total interest                         232928
     C                   IF        EIENDT <= WkEvcd                                           232928
     C                   EVAL      WkAmorToti = TOTI - AMDS                                   232928
     C                   ENDIF                                                                232928
      *                                                                                       232928
     C                   EVAL      WkKeyAmt = WkAmorToti
                                                                                              232928
     C**********         EVAL      AFDP = AFDP + WkAmortAmt + ANADJ + WkAmtSumB               232928
     C**********         EVAL      AMDS = AMDS + WkAmorToti + ANADJ + WkAmtSumb               232928
     C                   EVAL      AFDP = WkAmortAmt + WkAmtSumb                              232928
     C                   EVAL      AMDS = AMDS + WkAmorToti + WkAmtSumb                       232928
     C                   EVAL      DSAM = DSAM - WkAmortoti
     C                   EVAL      EIPRCP = EICPTD
     C                   EVAL      EIPRDP = EIDPTD
     C**********         EVAL      EICPTD = WkClnPrc                                          232928
     C                   EVAL      EICPTD = PClnPrcTdy                                        232928
     C**********         EVAL      EIDPTD = WkClnPrc + WkAccrued                              232928
     C                   EVAL      EIDPTD = PDrtPrcTdy                                        232928
     C**********         EVAL      EIAMTD = EIAMTD + WkAmortAmt + ANADJ                       232928
     C**********                            + WkAmtSumb                                       232928
     C                   EVAL      EIAMTD = WkAmortAmt + WkAmtSumb                            232928
      *                                                                                       232928
      ** Generate account key for non-linear amortisation discount/premium
     C                   IF        WkKeyAmt <> 0
     C                   EVAL      RRIND = '0'
     C                   EVAL      DKREVI = *ZERO
     C                   EVAL      WkNlnr = 'N'
     C                   EVAL      WkBlnk = *BLANK
     C                   EXSR      SrAccKey2
     C                   ENDIF
      ** Generate account key for non-linear amortisation adjustment not yet posted
     C                   IF        ANADJ <> 0
     C                   EVAL      WkKeyAmt = ANADJ
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      AMADJ = AMADJ + ANADJ
     C                   EVAL      ANADJ = *ZERO
     C                   EVAL      RRIND = '0'
     C                   EVAL      DKREVI = *ZERO
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkNlnr = 'N'
     C                   EVAL      WkBlnk = *BLANK
     C                   IF        WkKeyAmt < 0
     C                   EVAL      WkTyp2 = 'C'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'D'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
     C                   ENDIF
      ** Generate reversal account key for unrealised re-valued profit
     C                   IF        YAINT <> *ZERO
     C                   EVAL      WkKeyAmt = YAINT
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      RRIND = '1'
     C                   EVAL      DKREVI = 1
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkNlnr = *BLANK
     C                   MOVE      'NU'          WkBlnk
     C                   IF        WkKeyAmt < *ZERO
     C                   EVAL      WkTyp2 = 'L'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
     C                   ENDIF
      ** Generate account key for unrealised re-valued profit
     C                   Eval      YAINT = 0                                                  253286
     C     DLNO          CHAIN     MMNPVAL0
     C                   IF        %FOUND(MMNPVAL0)
     C                             And MNNPVA <> 0                                            253286
     C                             And MNYLDC <> ' '                                          253286
     C                   EVAL      WkKeyAmt = MNNPVA - AMCOST
     C                   EVAL      YAINT = WkKeyAmt
     C                   IF        WkKeyAmt <> *ZERO
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      RRIND = '0'
     C                   EVAL      DKREVI = *ZERO
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkNlnr = *BLANK
     C                   MOVE      'NU'          WkBlnk
     C                   IF        WkKeyAmt < *ZERO
     C                   EVAL      WkTyp2 = 'L'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
     C
     C                   ENDIF
     C                   ENDIF
     C
                                                                                              232928
      ** Fees                                                                                 232928
                                                                                              232928
     C**********         IF        WkAmtSum2 <> *ZERO                                         232928
     C*****DLNO*         SETLL     DLFEEDL1                                                   232928
     C*****DLNO*         READE     DLFEEDL1                                                   232928
     C**********         DOW       NOT %EOF(DLFEEDL1)                                         232928
     C**********         IF        DFAMTS <> *ZERO AND DFRECI = 'D'                           232928
     C**********                   AND DFPYON = 'S'                                           232928
     C**********         IF        DFADJY = 'Y'                                               232928
     C**********         EVAL      WkKeyAmt = WkAmount2(WId2) / WksumAll                      232928
     C**********                              * WkAmortAmt                                    232928
     C                   IF        WkAmtSum1 <> *ZERO                                         232928
                                                                                              232928
     C                   EVAL      WId2 = 1                                                   232928
                                                                                              232928
     C                   DOW       WkAmount1(WId2) <> 0                                       232928
                                                                                              232928
     C                   EVAL      KTran = DLNO                                               232928
     C                   EVAL      KFeeSeq  = WkFeeSeq(WId2)                                  232928
     C                   EVAL      WkKeyAmt = WkAmount1(WId2) / WksumAll                      232928
     C                                        * WkAmortAmt - WAmortAmount(WId2)               232928
                                                                                              232928
     C     KFee          CHAIN     DLFEEDLH                                                   232928
                                                                                              232928
     C                   IF        FEE2REC = 'DLFEEDDG'                                       232928
     C                   EVAL      WkFeeFCCY = DFFCCY                                         232928
     C                   EVAL      WkFeeFAMT = DFFAMT                                         232928
     C                   EVAL      WkFeeUAFA = DFUAFA                                         232928
     C                   EVAL      WkFeeAMTD = DFAMTD                                         232928
     C                   MOVE      DFFCOD        WkBlnk                                     BUG13047
     C                   ELSE                                                                 232928
     C                   EVAL      WkFeeFCCY = HIFCCY                                         232928
     C                   EVAL      WkFeeFAMT = HIAMTS                                         232928
     C                   EVAL      WkFeeUAFA = 0                                              232928
     C                   EVAL      WkFeeAMTD = HIAMTD                                         232928
     C                   MOVE      HIFCOD        WkBlnk                                     BUG13047
     C                   ENDIF                                                                232928
                                                                                              232928
     C**********         IF        DFFCCY <> CCY                                              232928
     C**********         EVAL      WkFseq = DFFSEQ                                            232928
     C**********         EVAL      WkSdat = DFPSTD                                            232928
     C*****DLFEKEY       CHAIN     MMEIRAL3                                                   232928
                                                                                              232928
     C     KFee          CHAIN     MMEIRAL3                                                   232928
     C**********         IF        WkFeeFCCY = CCY                                   232928 BUG12840
     C                   IF        WkFeeFCCY <> CCY                                         BUG12840
     C                   IF        %FOUND(MMEIRAL3)
      ***Recompute Account Key Amount using EAAMNT if currency                   BUG13085B BUG13085C
      ***not*equal to Fee currency                                               BUG13085B BUG13085C
     C**********         EVAL      WkKeyAmt = EAAMNT / WksumAll                  BUG13085B BUG13085C
     C**********                              * WkAmortAmt - WAmortAmount(WId2)  BUG13085B BUG13085C
      *                                                                          BUG13085B BUG13085C
      *                                                                           BUG13085C BUG13578
     C**********         EVAL      WkKeyAmtAdd = 0                                BUG13085C BUG13578
     C**********         EVAL      WkSUBEA = 0                                    BUG13085C BUG13578
     C**********         IF        EAAMNT > EAOAMT                                BUG13085C BUG13578
     C**********         EVAL      WkSUBEA = EAAMNT - EAOAMT                      BUG13085C BUG13578
     C**********         EVAL      WkKeyAmtAdd = WkSUBEA / WksumAll               BUG13085C BUG13578
     C**********                              * WkAmortAmt - WAmortAmount(WId2)   BUG13085C BUG13578
     C**********         ENDIF                                                    BUG13085C BUG13578
     C                   SELECT
     C                   WHEN      EAMDIN = 'M'
     C**********         EVAL      WkKeyAmt = WkKeyAmt / EAXRAT                             BUG13578
     C                   EVAL (H)  WkKeyAmt = WkKeyAmt / EAXRAT                             BUG13578
     C                   WHEN      EAMDIN = 'D'
     C**********         EVAL      WkKeyAmt = WkkeyAmt * EAXRAT                             BUG13578
     C                   EVAL (H)  WkKeyAmt = WkkeyAmt * EAXRAT                             BUG13578
     C                   ENDSL
     C**********         EVAL      WkKeyAmt = Wkkeyamt + WkKeyAmtADD              BUG13085C BUG13578
     C                   ENDIF
     C                   ENDIF
     C**********         EVAL      WId2 = WId2 + 1                                            232928
      ** Check if unamortised back-valued fee amount is not zero. If yes
      ** add this value, after converting this amount to deal currency,
      ** to the proportioned amortisation amount.
     C**********         IF        DFUAFA <> 0                                                232928
     C**********         EVAL      WkKeyAmt = WkKeyAmt + DFUAFA                               232928
     C**********         ENDIF                                                                232928
                                                                                              232928
     C                   IF        WkFeeUAFA <> 0                                             232928
     C                   EVAL      WkKeyAmt = WkKeyAmt + WkFeeUAFA                            232928
     C                   ENDIF                                                                232928
     C
     C                   IF        WkKeyAmt <> 0
     C**********         EVAL      WkAMTD = DFAMTD + WkKeyAmt                                 232928
     C**********         IF        EIENDT <= WkEvcd AND WkAMTD <> DFAMTS                      232928
     C**********         EVAL      WkDiff = WkAMTD - DFAMTS                                   232928
     C**********         EVAL      WkAMTD = DFAMTS                                            232928
     C                   EVAL      WkAMTD = WkFeeAMTD + WkKeyAmt                              232928
     C                   IF        EIENDT <= WkEvcd AND WkAMTD <> WkFeeFAMT                   232928
     C                   EVAL      WkDiff = WkAMTD - WkFeeFAMT                                232928
     C                   EVAL      WkKeyAmt = WkKeyamt - WkDiff
     C                   EVAL      WkAMTD = WkFeeFAMT                                         232928
     C                   ENDIF
                                                                                              232928
     C                   IF        FEE2REC = 'DLFEEDDG'                                       232928
     C                   EVAL      DFAMTD = WkAMTD
     C                   EVAL      DFAFES = DFAFES + WkKeyAmt
     C                   EVAL      DFUAFA = *ZERO
     C                   EVAL      DFLDAT = WkEvcd
     C                   UPDATE    DLFEEDDG                                                   232928
     C**********         UPDATE    DLFEEDD0                                                   232928
     C                   ELSE                                                                 232928
     C                   EVAL      HIAMTD = WkAMTD                                            232928
     C                   UPDATE    DLFHSTDG                                                   232928
     C                   ENDIF                                                                232928
                                                                                              232928
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTF = RCOUNTF + 1
      ** Write to report and account key file                                               BUG13578
      ** Before updating fields and writing to printer file, check if deal and fee currency BUG13578
      ** is not equal, if not, convert again to deal currency for reporting purposes        BUG13578
     C                   EXSR      SrConvert                                                BUG13578
     C                   EXSR      SrAccKey3
     C                   EVAL      FEEREC = FEE2REC                                         BUG13006
     C                   EXSR      SrWriteP3
     C                   ELSE                                                               BUG12667
     C                   UNLOCK    DLFEEDLH                                                 BUG12667
     C                   ENDIF
     C**********         ENDIF                                                                232928
     C**********         ENDIF                                                                232928
     C                   EVAL      WId2 = WId2 + 1                                            232928
     C*****DLNO*         READE     DLFEEDL1                                                   232928
     C                   ENDDO
     C                   ENDIF
                                                                                              233601
      ** Post Fee amount to be amortised non-linearly                                         233601
                                                                                              233601
     C     DLNO          SETLL     DLFEEDL5                                                   233601
     C     DLNO          READE     DLFEEDL5                                                   233601
     C                   DOW       NOT %EOF(DLFEEDL5)                                         233601
     C                             AND %FOUND(DLFEEDL5)                                       233601
     C**********         IF            DFRECI <> '*'                                 233601 BUG13006
     C**********                   AND DFNLAI = 'Y'                                 BUG9667 BUG13006
     C**********                   AND DFNLAI <> 'Y'                                  233601 BUG9667
     C                   IF        FEEREC = 'DLFEEDD5' AND                                  BUG13006
     C                             DFRECI = '*'        AND                                  BUG13006
     C                             DFNLAI = 'Y'        OR                                   BUG13006
     C                             FEEREC = 'DLFHSTD5' AND                                  BUG13006
     C                             HIRECI = '*'        AND                                  BUG13006
     C                             DFNLAI = 'Y'                                             BUG13006
     C**********         EVAL      WkKeyAmt = DFFEAM                                  233601 BUG9667
     C                   IF        FEEREC = 'DLFEEDD5'                                      BUG13006
     C                   EVAL      WkKeyAmt = DFFAMT                                         BUG9667
     C                   ELSE                                                               BUG13006
     C                   EVAL      WkKeyAmt = HIAMTS                                        BUG13006
     C                   ENDIF                                                              BUG13006
     C                   EVAL      DKREVI = 0                                                 233601
     C                   EXSR      SrAccKey4                                                  233601
     C                   EXSR      SrWriteP3                                                  233601
     C                   EVAL      DFNLAI = 'Y'                                               233601
     C                   IF        FEEREC = 'DLFEEDD5'                                        233601
     C                   UPDATE    DLFEEDD5                                                   233601
     C                   ELSE                                                                 233601
     C                   UPDATE    DLFHSTD5                                                   233601
     C                   ENDIF                                                                233601
     C                   EVAL      RCOUNT = RCOUNT + 1                                        233601
     C                   EVAL      RCOUNTF = RCOUNTF + 1                                      233601
     C                   ENDIF                                                                233601
     C     DLNO          READE     DLFEEDL5                                                   233601
     C                   ENDDO                                                                233601
                                                                                              233601
     C                   ENDSR
      *****************************************************************                     BUG13578
      *                                                               *                     BUG13578
      * SrConvert - Converts fee currency amount to deals currency    *                     BUG13578
      *             for reporting purposes                            *                     BUG13578
      *                                                               *                     BUG13578
      *****************************************************************                     BUG13578
     C     SRConvert     BEGSR                                                              BUG13578
     C                   IF        WkFeeFCCY <> CCY                                         BUG13578
     C     KFee          CHAIN     MMEIRAL3                                                 BUG13578
     C                   IF        %FOUND(MMEIRAL3)                                         BUG13578
     C                   SELECT                                                             BUG13578
     C                   WHEN      EAMDIN = 'M'                                             BUG13578
     C                   EVAL (H)  WkKeyAmt = WkKeyAmt * EAXRAT                             BUG13578
     C                   WHEN      EAMDIN = 'D'                                             BUG13578
     C                   EVAL (H)  WkKeyAmt = WkkeyAmt / EAXRAT                             BUG13578
     C                   ENDSL                                                              BUG13578
     C                   ENDIF                                                              BUG13578
     C                   ENDIF                                                              BUG13578
     C                   ENDSR                                                              BUG13578
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdAkey - Update DKEYSDP                                    *
      *                                                               *
      *****************************************************************

     C     SrUpdAkey     BEGSR
     C
     C                   EVAL      WkDtyp = DTYP
     C                   EVAL      WkDtst = DLST
     C                   EVAL      WkClas = CLAS                                             BUG9356
     C                   EVAL      DKRECI = 'D'
     C                   EVAL      DKAKEY = WkAkey
     C                   EVAL      DKDLNO = DLNO
     C                   EVAL      DKCNUM = CNUM
     C                   EVAL      DKBRCA = BRCA
     C                   IF        FREC = 'DEALSDCF' OR FREC = 'DLCHISD0'
     C                   EVAL      DKACSQ = CDAS
     C                   ELSE
     C                   EVAL      DKACSQ = IDAS
     C                   ENDIF
     C                   EVAL      DKEDAT = WkEvcd
     C                   EVAL      DKEAMT = WkKeyAmt
     C                   EVAL      DKECCY = CCY
     C                   EVAL      DKSETP = SDST
     C                   EVAL      DKOSAC = OSDA
     C                   EVAL      DKOTHA = *ZERO
     C                   EVAL      DKOTHC = *BLANK
     C                   EVAL      DKEXRT = *ZERO
     C                   EVAL      DKVDAT = *ZERO
     C                   EVAL      DKSLID = DFPSTD
     C                   EVAL      DKMDAT = *ZERO
     C                   EVAL      DKBRTT = *ZERO
     C                   EVAL      DKBRTE = *ZERO
     C                   EVAL      DKRTSP = *ZERO
     C                   EVAL      DKINTR = *ZERO
     C                   EVAL      DKFFVD = *ZERO
     C                   EVAL      DKYRAT = YRAT
     C                   EVAL      DKFFIN = *BLANK
     C                   EVAL      DKZZ002 = *BLANK
     C**********         EVAL      DKCHNACH = *ZERO                                           CSD027
     C                   EVAL      DKCHNACH = *BLANKS                                         CSD027
     C                   EVAL      DKFACO = FACO
     C                   EVAL      DKPRFC = PRFC
     C                   EVAL      DKOSBR = DFOSBR
     C                   EVAL      DKBOKC = BOKC
     C                   IF        RCDT = 'C'
     C                   EVAL      DKRBDN = RBDN
     C                   EVAL      DKPTFR = PTFR
     C                   EVAL      DKRTFC = RTFC
     C                   ELSE
     C                   EVAL      DKRBDN = *ZERO
     C                   EVAL      DKPTFR = *BLANK
     C                   EVAL      DKRTFC = *BLANK
     C                   ENDIF
     C                   EVAL      DKSTCY = DFSCCY
     C                   WRITE     DKEYSDPF
     C                   EXSR      SrWriteP2
      ** Update Totals

     C                   EVAL      ZZAMT = WkKeyAmt / 1000

     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

     C                   Z-ADD     WkVlInt       ZZTOTI
     C                   Z-ADD     WkVlDec       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        WkVlInt
     C                   Z-ADD     ZZTOTD        WkVlDec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAccKey1 - Generate Account Key  for Fee Reversal            *
      *                                                               *
      *****************************************************************

     C     SrAccKey1     BEGSR
     C
     C                   EVAL      WkDtyp = DTYP
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkDtst = DLST
     C                   EVAL      WkNlnr = 'N'
     C                   MOVE      DFFCOD        WkBlnk
     C                   EVAL      WkTyp2 = 'F'
     C                   EVAL      WkClas = CLAS                                             BUG9356
     C                   EVAL      DKRECI = 'D'
     C                   EVAL      DKAKEY = WkAkey
     C                   EVAL      DKDLNO = DLNO
     C                   EVAL      DKCNUM = CNUM
     C                   EVAL      DKBRCA = BRCA
     C                   IF        FREC = 'DEALSDCF' OR FREC = 'DLCHISD0'
     C                   EVAL      DKACSQ = CDAS
     C                   ELSE
     C                   EVAL      DKACSQ = IDAS
     C                   ENDIF
     C                   EVAL      DKEDAT = WkEvcd
     C                   EVAL      DKEAMT = WkKeyAmt
     C                   EVAL      DKECCY = CCY
     C                   EVAL      DKSETP = SDST
     C                   EVAL      DKOSAC = OSDA
     C                   EVAL      DKREVI = 1
     C                   EVAL      DKOTHA = 0
     C                   EVAL      DKOTHC = *BLANK
     C                   EVAL      DKEXRT = 0
     C                   EVAL      DKVDAT = 0
     C                   EVAL      DKSLID = DFPSTD
     C                   EVAL      DKMDAT = 0
     C                   EVAL      DKBRTT = 0
     C                   EVAL      DKBRTE = 0
     C                   EVAL      DKRTSP = 0
     C                   EVAL      DKINTR = 0
     C                   EVAL      DKFFVD = 0
     C                   EVAL      DKYRAT = YRAT
     C                   EVAL      DKFFIN = *BLANK
     C                   EVAL      DKZZ002 = *BLANK
     C**********         EVAL      DKCHNACH = 0                                               CSD027
     C                   EVAL      DKCHNACH = *BLANKS                                         CSD027
     C                   EVAL      DKFACO = FACO
     C                   EVAL      DKPRFC = PRFC
     C                   EVAL      DKOSBR = DFOSBR
     C                   EVAL      DKBOKC = BOKC
     C                   IF        RCDT = 'C'
     C                   EVAL      DKRBDN = RBDN
     C                   EVAL      DKPTFR = PTFR
     C                   EVAL      DKRTFC = RTFC
     C                   ELSE
     C                   EVAL      DKRBDN = 0
     C                   EVAL      DKPTFR = *BLANK
     C                   EVAL      DKRTFC = *BLANK
     C                   ENDIF
     C                   EVAL      DKSTCY = DFSCCY
     C                   WRITE     DKEYSDPF
      ** Update Totals

     C                   EVAL      ZZAMT = WkKeyAmt / 1000

     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

     C                   Z-ADD     WkVlInt       ZZTOTI
     C                   Z-ADD     WkVlDec       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        WkVlInt
     C                   Z-ADD     ZZTOTD        WkVlDec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAccKey2 - Generate Account Key  for Deal Reversal           *
      *                                                               *
      *****************************************************************

     C     SrAccKey2     BEGSR
     C
      ** Generate account key for Negotiable Assets Purchased Interest Bearing
     C                   IF        DTYP = 'C2' OR DTYP = 'BD' OR DTYP = 'BP'
     C
      **  Generate Account key for Non-Linear Amortised Discount/Premium
      **  not yet posted.
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      WkTyp1 = 'A'
     C**********         IF        WkKeyAmt < 0                                               231708
     C                   IF        DISA < 0                                                   231708
     C                   EVAL      WkTyp2 = 'C'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'D'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
      **  Generate Account key for Outstanding Non-Linear Discount/Premium
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      WkTyp1 = 'R'
     C                   EVAL      WkKeyAmt = DISA - AMDS
     C                   EVAL      WkKeyAmtSav = WkKeyAmt
     C**********         IF        WkKeyAmt < 0                                               231708
     C                   IF        DISA < 0                                                   231708
     C                   EVAL      WkTyp2 = 'C'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'D'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
      **  Generate Account key for Sale Non-Linear Profit/Loss
     C                   TESTB     '3'           ACEI                     53                BUG13441
     C                   IF        *IN53 = *OFF    AND                                      BUG13441
     C                             SADT  <> 0      AND                                      BUG13441
     C                             SADT  <= WkEVCD                                          BUG13441
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      WkTyp1 = 'S'
     C                   EVAL      WkKeyAmt1 = *ZERO
     C                   EVAL      WkKeyAmt1 = WkKeyAmtSav + SAPR
     C                   EVAL      WkKeyAmt = WkKeyAmt1 - FVAL
     C                   IF        WkKeyAmt < 0
     C                   EVAL      WkTyp2 = 'L'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
     C                   ENDIF                                                              BUG13441
     C                   ENDIF
      ** Generate account key for Negotiable Assets Purchased Non-Interest Bearing
     C                   IF        DTYP = 'DA' OR DTYP = 'TA' OR DTYP = 'TB'
      **  Generate Account key for Non-Linear Amortised Discount not yet posted.
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C**********         EVAL      WkKeyAmt = WWAMDS                                        BUG13145
     C                   EVAL      WkKeyAmt = DSAM                                          BUG13145
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkTyp2 = 'D'
     C                   EXSR      SrUpdAkey
      **  Generate Account key for Discount Non-Linear Amortised to date.
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C**********         EVAL      WkKeyAmt = DPTD                                          BUG13145
     C**********         EVAL      WkKeyAmt = AMDS                                 BUG13145 BUG13476
     C                   EVAL      WkKeyAmt = WkAmorToti                                    BUG13476
     C                   EVAL      WkTyp1 = 'S'
     C                   EVAL      WkTyp2 = 'D'
     C                   EXSR      SrUpdAkey
      **  Generate Account key for Outstanding Non-Linear Discount
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C**********         EVAL      WkKeyAmt = DISA - DPTD                                   BUG13145
     C                   EVAL      WkKeyAmt = DISA - AMDS                                   BUG13145
     C                   EVAL      WkKeyAmtSav = WkKeyAmt
     C                   EVAL      WkTyp1 = 'R'
     C                   EVAL      WkTyp2 = 'C'
     C                   EXSR      SrUpdAkey
      **  Generate Account key for Sale Non-Linear Profit/Loss
     C                   TESTB     '3'           ACEI                     53                BUG13441
     C                   IF        *IN53 = *OFF    AND                                      BUG13441
     C                             SADT  <> 0      AND                                      BUG13441
     C                             SADT  <= WkEVCD                                          BUG13441
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   EVAL      RCOUNTD = RCOUNTD + 1
     C                   EVAL      WkTyp1 = 'S'
     C                   EVAL      WkKeyAmt1 = *ZERO
     C                   EVAL      WkKeyAmt1 = WkKeyAmtSav + SAPR
     C                   EVAL      WkKeyAmt = WkKeyAmt1 - FVAL
     C                   IF        WkKeyAmt < 0
     C                   EVAL      WkTyp2 = 'L'
     C                   Z-SUB     WkKeyAmt      WkKeyAmt
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   ENDIF
     C                   EXSR      SrUpdAkey
     C                   ENDIF                                                              BUG13441
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAccKey3 - Generate Account Key  for amortisation            *
      *                                                               *
      *****************************************************************

     C     SrAccKey3     BEGSR
     C
     C                   EVAL      WkDtyp = DTYP
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkDtst = DLST
     C                   EVAL      WkNlnr = 'N'
     C**********         MOVE      DFFCOD        WkBlnk                                     BUG13047
     C                   EVAL      WkTyp2 = 'F'
     C                   EVAL      WkClas = CLAS                                             BUG9356
     C                   EVAL      DKRECI = 'D'
     C                   EVAL      DKAKEY = WkAkey
     C                   EVAL      DKDLNO = DLNO
     C                   EVAL      DKCNUM = CNUM
     C                   EVAL      DKBRCA = BRCA
     C                   IF        FREC = 'DEALSDCF' OR FREC = 'DLCHISD0'
     C                   EVAL      DKACSQ = CDAS
     C                   ELSE
     C                   EVAL      DKACSQ = IDAS
     C                   ENDIF
     C                   EVAL      DKEDAT = WkEvcd
     C                   EVAL      DKEAMT = WkKeyAmt
     C                   EVAL      DKECCY = CCY
     C                   EVAL      DKSETP = SDST
     C                   EVAL      DKOSAC = OSDA
     C                   EVAL      DKREVI = 0
     C                   EVAL      DKOTHA = 0
     C                   EVAL      DKOTHC = *BLANK
     C                   EVAL      DKEXRT = 0
     C                   EVAL      DKVDAT = 0
     C                   EVAL      DKSLID = DFPSTD
     C                   EVAL      DKMDAT = 0
     C                   EVAL      DKBRTT = 0
     C                   EVAL      DKBRTE = 0
     C                   EVAL      DKRTSP = 0
     C                   EVAL      DKINTR = 0
     C                   EVAL      DKFFVD = 0
     C                   EVAL      DKYRAT = YRAT
     C                   EVAL      DKFFIN = *BLANK
     C                   EVAL      DKZZ002 = *BLANK
     C**********         EVAL      DKCHNACH = 0                                               CSD027
     C                   EVAL      DKCHNACH = *BLANKS                                         CSD027
     C                   EVAL      DKFACO = FACO
     C                   EVAL      DKPRFC = PRFC
     C                   EVAL      DKOSBR = DFOSBR
     C                   EVAL      DKBOKC = BOKC
     C                   IF        RCDT = 'C'
     C                   EVAL      DKRBDN = RBDN
     C                   EVAL      DKPTFR = PTFR
     C                   EVAL      DKRTFC = RTFC
     C                   ELSE
     C                   EVAL      DKRBDN = 0
     C                   EVAL      DKPTFR = *BLANK
     C                   EVAL      DKRTFC = *BLANK
     C                   ENDIF
     C                   EVAL      DKSTCY = DFSCCY
     C                   WRITE     DKEYSDPF
      ** Update Totals

     C                   EVAL      ZZAMT = WkKeyAmt / 1000

     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

     C                   Z-ADD     WkVlInt       ZZTOTI
     C                   Z-ADD     WkVlDec       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        WkVlInt
     C                   Z-ADD     ZZTOTD        WkVlDec
     C                   ENDSR
     C
      *****************************************************************
      /EJECT                                                                                  233601
      *****************************************************************                       233601
      *                                                               *                       233601
      * SrAccKey4 - Generate Account Key Fee amount to be amortised   *                       233601
      *                                                               *                       233601
      *****************************************************************                       233601
                                                                                              233601
     C     SrAccKey4     BEGSR                                                                233601
                                                                                              233601
     C                   EVAL      WkDtyp = DTYP                                              233601
     C                   EVAL      WkTyp1 = 'E'                                               233601
     C                   EVAL      WkDtst = DLST                                              233601
     C                   EVAL      WkNlnr = 'N'                                               233601
     C                   IF        FEEREC = 'DLFEEDD5'                                      BUG13006
     C                   MOVE      DFFCOD        WkBlnk                                       233601
     C                   ELSE                                                               BUG13006
     C                   MOVE      HIFCOD        WkBlnk                                     BUG13006
     C                   ENDIF                                                              BUG13006
     C                   EVAL      WkTyp2 = 'F'                                               233601
     C                   EVAL      WkClas = CLAS                                             BUG9356
     C                   EVAL      DKRECI = 'D'                                               233601
     C                   EVAL      DKAKEY = WkAkey                                            233601
     C                   EVAL      DKDLNO = DLNO                                              233601
     C                   EVAL      DKCNUM = CNUM                                              233601
     C                   EVAL      DKBRCA = BRCA                                              233601
     C                   IF        FREC = 'DEALSDCF' OR FREC = 'DLCHISD0'                     233601
     C                   EVAL      DKACSQ = CDAS                                              233601
     C                   ELSE                                                                 233601
     C                   EVAL      DKACSQ = IDAS                                              233601
     C                   ENDIF                                                                233601
     C                   EVAL      DKEDAT = WkEvcd                                            233601
     C                   EVAL      DKEAMT = WkKeyAmt                                          233601
     C                   EVAL      DKECCY = CCY                                               233601
     C                   EVAL      DKSETP = SDST                                              233601
     C                   EVAL      DKOSAC = OSDA                                              233601
     C                   EVAL      DKOTHA = 0                                                 233601
     C                   EVAL      DKOTHC = *BLANK                                            233601
     C                   EVAL      DKEXRT = 0                                                 233601
     C                   EVAL      DKVDAT = 0                                                 233601
     C**********         EVAL      DKSLID = DFPSTD                                   233601 BUG13006
     C                   EVAL      DKMDAT = 0                                                 233601
     C                   EVAL      DKBRTT = 0                                                 233601
     C                   EVAL      DKBRTE = 0                                                 233601
     C                   EVAL      DKRTSP = 0                                                 233601
     C                   EVAL      DKINTR = 0                                                 233601
     C                   EVAL      DKFFVD = 0                                                 233601
     C                   EVAL      DKYRAT = YRAT                                              233601
     C                   EVAL      DKFFIN = *BLANK                                            233601
     C                   EVAL      DKZZ002 = *BLANK                                           233601
     C**********         EVAL      DKCHNACH = 0                                        233601 CSD027
     C                   EVAL      DKCHNACH = *BLANKS                                         CSD027
     C                   EVAL      DKFACO = FACO                                              233601
     C                   EVAL      DKPRFC = PRFC                                              233601
     C**********         EVAL      DKOSBR = DFOSBR                                   233601 BUG13006
     C                   EVAL      DKBOKC = BOKC                                              233601
     C                   IF        RCDT = 'C'                                                 233601
     C                   EVAL      DKRBDN = RBDN                                              233601
     C                   EVAL      DKPTFR = PTFR                                              233601
     C                   EVAL      DKRTFC = RTFC                                              233601
     C                   ELSE                                                                 233601
     C                   EVAL      DKRBDN = 0                                                 233601
     C                   EVAL      DKPTFR = *BLANK                                            233601
     C                   EVAL      DKRTFC = *BLANK                                            233601
     C                   ENDIF                                                                233601
     C                   IF        FEEREC = 'DLFEEDD5'                                      BUG13006
     C                   EVAL      DKSLID = DFPSTD                                          BUG13006
     C                   EVAL      DKOSBR = DFOSBR                                          BUG13006
     C                   EVAL      DKSTCY = DFSCCY                                            233601
     C                   ELSE                                                               BUG13006
     C                   EVAL      DKSLID = HIHDAT                                          BUG13006
     C                   EVAL      DKOSBR = HIOSBR                                          BUG13006
     C                   EVAL      DKSTCY = HIFCCY                                          BUG13006
     C                   ENDIF                                                              BUG13006
     C                   WRITE     DKEYSDPF                                                   233601
      ** Update Totals                                                                        233601
                                                                                              233601
     C                   EVAL      ZZAMT = WkKeyAmt / 1000                                    233601
                                                                                              233601
     C                   IF        ZZAMT < 0                                                  233601
     C                   Z-SUB     ZZAMT         ZZAMT                                        233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   Z-ADD     WkVlInt       ZZTOTI                                       233601
     C                   Z-ADD     WkVlDec       ZZTOTD                                       233601
     C                   EXSR      GLZADD                                                     233601
     C                   Z-ADD     ZZTOTI        WkVlInt                                      233601
     C                   Z-ADD     ZZTOTD        WkVlDec                                      233601
                                                                                              233601
     C                   ENDSR                                                                233601
                                                                                              233601
      *****************************************************************                       233601
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteP1 - Write the fee amortisation report.               *
      *                                                               *
      *****************************************************************
     C     SrWriteP1     BEGSR
     C                   IF        RCDT = 'C'
     C                   MOVE      CNUM          RCNUM
     C                   ELSE
     C                   MOVE      ISCN          RCNUM
     C                   ENDIF
     C                   MOVE      DLNO          RDEAL
     C                   MOVEL     DFFSEQ        RFSEQ
     C                   EVAL      RAKEY = WkAKey
     C                   EVAL      ZFLD15 = WkKeyAmt
     C                   EXSR      ZSEdit
     C                   EVAL      RAMNT  = ZOUT21
     C                   EVAL      RCCY = CCY
     C                   EVAL      RRIND = '1'

      ** Write P1 Header if required

     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write P1

     C                   WRITE     DETAIL11
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteP2 - Write the deal amortisation report.              *
      *                                                               *
      *****************************************************************
     C     SrWriteP2     BEGSR
     C                   IF        RCDT = 'C'
     C                   MOVE      CNUM          RCNUM
     C                   ELSE
     C                   MOVE      ISCN          RCNUM
     C                   ENDIF
     C                   MOVE      DLNO          RDLNO
     C                   MOVEL     DFFSEQ        RFSEQ
     C                   EVAL      RAKEY = WkAKey
     C                   EVAL      ZFLD15 = WkKeyAmt
     C                   EXSR      ZSEdit
     C                   EVAL      RAMNT  = ZOUT21
     C                   EVAL      RCCY = CCY

      ** Write P2 Header if required

     C                   Z-ADD     2             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF

      ** Write P2

     C                   WRITE     DETAIL21
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteP3 - Write the fee amortisation report.               *
      *                                                               *
      *****************************************************************
     C     SrWriteP3     BEGSR
     C                   IF        RCDT = 'C'
     C                   MOVE      CNUM          RCNUM
     C                   ELSE
     C                   MOVE      ISCN          RCNUM
     C                   ENDIF
     C                   MOVE      DLNO          RDEAL
     C                   IF        FEEREC = 'DLFEEDD5' OR                                   BUG13006
     C                             FEEREC = 'DLFEEDDG'                                      BUG13006
     C                   MOVEL     DFFSEQ        RFSEQ
     C                   ELSE                                                               BUG13006
     C                   MOVEL     HIFSEQ        RFSEQ                                      BUG13006
     C                   ENDIF                                                              BUG13006
     C                   EVAL      RAKEY = WkAKey
     C                   EVAL      ZFLD15 = WkKeyAmt
     C                   EXSR      ZSEdit
     C                   EVAL      RAMNT  = ZOUT21
     C                   EVAL      RCCY = CCY
     C                   EVAL      RRIND = '0'

      ** Write P1 Header if required

     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write P1

     C                   WRITE     DETAIL11
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBranch - Call to  AOBRCHR1                                 *
      *                                                               *
      *****************************************************************

     C     SrBranch      BEGSR

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        (PRtCd <> *BLANKS)

      ** Data base error in file SDBRCHPD

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBRCHPD'
     C                   EVAL      DBKEY  =  PBRCA
     C                   EVAL      DBASE  =  002
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ClsP1 - Close P1 Processing.                                 *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     ClsP1         BEGSR

     C                   IF        RCOUNTF = *ZERO
     C                   WRITE     DETAIL13
     C                   ELSE
      ** Check that sufficient lines remain for the Totals. If not,
      ** write out the Header on a new page.

     C                   Z-ADD     6             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      ** Write Total
     C                   WRITE     DETAIL12
     C                   ENDIF
      ** Check that sufficient lines remain for the footer. If not,
      ** write out the header on a new page
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      ** Write Footer
     C                   WRITE     TRAILP1
      ** Close the spool file
      *
     C     P1OPEN        IFEQ      'Y'
     C                   CLOSE     MM004650P1
     C                   MOVE      'N'           P1OPEN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ClsP2 - Close P2 Processing.                                 *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     ClsP2         BEGSR

     C                   IF        RCOUNTF = *ZERO
     C                   WRITE     DETAIL23
     C                   ELSE
      ** Check that sufficient lines remain for the Totals. If not,
      ** write out the Header on a new page.

     C                   Z-ADD     6             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF

      ** Write Total
     C                   WRITE     DETAIL22
     C                   ENDIF
      ** Check that sufficient lines remain for the footer. If not,
      ** write out the header on a new page
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP2
     C                   ENDIF
      ** Write Footer

     C                   WRITE     TRAILP2

      ** Close the spool file

     C     P2OPEN        IFEQ      'Y'
     C                   CLOSE     MM004650P2
     C                   MOVE      'N'           P2OPEN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  OpnP1  - Open P1 processing.                                 *
      *                                                               *
      *****************************************************************

     C     OpnP1         BEGSR

     C                   IF        P1OPEN = 'N'
     C                   OPEN      MM004650P1
     C                   EVAL      P1OPEN = 'Y'
     C                   EVAL      RCOUNTF = *ZERO
     C                   ENDIF

      ** Ensure Report Spool File recorded by RCF.

     C                   Z-ADD     SFNUM1        ZSNUM             6 0

     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF

      ** Write Header

     C                   WRITE     HEADP1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  OpnP2  - Open P2 processing.                                 *
      *                                                               *
      *****************************************************************

     C     OpnP2         BEGSR

     C                   IF        P2OPEN = 'N'
     C                   OPEN      MM004650P2
     C                   EVAL      P2OPEN = 'Y'
     C                   EVAL      RCOUNTD = *ZERO
     C                   ENDIF

      ** Ensure Report Spool File recorded by RCF.

     C                   Z-ADD     SFNUM2        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF

      ** Write Header

     C                   WRITE     HEADP2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZADD - Subroutine to add an amount to the total             *
      *                                                               *
      *****************************************************************
      *
     C     GLZADD        BEGSR

     C                   Z-ADD     ZZAMT         ZZAMT                    91

     C                   IF        *IN91 = *ON
     C                   GOTO      ZZAEND
     C                   ENDIF

      ** Split ZZAMT into integer and decimal fields

     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD

      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now

     C                   EXSR      GLZSUM

     C     ZZAEND        ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
      *                                                               *
      *****************************************************************

     C     GLZSUM        BEGSR

     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF

      ** Determine sign of ZZAMTI & D, 92 if neg.

     C     ZZAMTI        COMP      0                                    9293

     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      0                                    9293
     C                   ENDIF

     C                   IF        *IN93 = *ON
     C                   GOTO      ZZSEND
     C                   ENDIF

      ** Determine sign of ZZTOTI & D, 91 if neg.

     C     ZZTOTI        COMP      0                                    9193

     C                   IF        *IN93 = *ON
     C     ZZTOTD        COMP      0                                    9193
     C                   ENDIF

      ** If ZZTOTAL is zero, return ZZAMOUNT.

     C                   IF        *IN93 = *ON
     C                   Z-ADD     ZZAMTI        ZZTOTI
     C                   Z-ADD     ZZAMTD        ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF

      ** If signs differ bypass overflow checks.

     C                   IF        *IN91 = *ON AND
     C                             *IN92 = *OFF OR
     C                             *IN91 = *OFF AND
     C                             *IN92 = *ON
     C                   GOTO      ZZOFPS
     C                   ENDIF

     C     ZZAMTD        ADD       ZZTOTD        ZZWk2
     C     ZZWk2         COMP      999                                93

     C                   IF        *IN93 = *OFF
     C     ZZWk2         COMP      -999                                 93
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *OFF
     C     ZZAMTI        ADD       1             ZZWk3
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *ON
     C     ZZAMTI        SUB       1             ZZWk3
     C                   ENDIF

     C                   IF        *IN93 = *ON
     C     ZZTOTI        ADD       ZZWk3         ZZWk3
     C                   ENDIF

     C                   IF        *IN93 = *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWk3
     C                   ENDIF

      ** If the modulus of ZZWk3 is lt mod. ZZTOTI then O/F has occurred

     C                   IF        *IN92 = *OFF
     C     ZZWk3         COMP      ZZTOTI                               99
     C                   ENDIF

     C                   IF        *IN92 = *ON
     C     ZZWk3         COMP      ZZTOTI                             99
     C                   ENDIF

     C                   IF        *IN99 = *OFF
     C                   Z-ADD     ZZWk2         ZZTOTD
     C                   Z-ADD     ZZWk3         ZZTOTI
     C                   ENDIF

      ** If O/F zeroise ZZAMT, ind '99' set and ZZTOT fields left intact

     C                   IF        *IN99 = *ON
     C                   Z-ADD     0             ZZAMT
     C                   ENDIF

     C                   GOTO      ZZSEND

      ** The 'SIGNS' are different

     C     ZZOFPS        TAG

      ** If ZZAMT was negative, make it pos. to comp with ZZTOT

     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF

      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.

     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF

      ** Both ZZAMT and ZZTOT are noe positive

     C     ZZTOTI        COMP      ZZAMTI                             93  95

     C                   IF        *IN95 = *ON
     C     ZZTOTD        COMP      ZZAMTD                             93  95
     C                   ENDIF

      ** If ZZTOT eq. ZZAMT return zero.

     C                   IF        *IN95 = *ON
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF

      ** If ZZTOT gt. ZZAMT.

     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      ZZTOTD                             94
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWk2
     C                   ENDIF

     C                   IF        *IN93 = *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZAMTD        ZZTOTD
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *OFF
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF

      ** If ZZAMT gt. ZZTOT.

     C                   IF        *IN93 = *OFF
     C     ZZTOTD        COMP      ZZAMTD                             94
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZAMTI        SUB       1             ZZWk3
     C     ZZAMTD        ADD       1000          ZZWk2
     C     ZZWk3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZTOTD        ZZTOTD
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF

      ** Reverse sign of ZZTOT if larger I/P fields were negative

     C                   EVAL      *IN94 = *OFF

     C                   IF        *IN93 = *ON AND
     C                             *IN91 = *ON OR
     C                             *IN93 = *OFF AND
     C                             *IN92 = *ON
     C                   EVAL      *IN94 = *ON
     C                   ENDIF

     C                   IF        *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF

      ** Restore sign of ZZAMTI & ZZAMTD If It was reversed.

     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF

     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.

     C                   EVAL      *IN96 = *OFF

     C     ZZTOTD        COMP      0                                      91

     C                   IF        *IN91 = *ON
     C     ZZTOTI        COMP      0                                    96
     C                   ENDIF

     C                   IF        *IN96 = *ON
     C                   MOVE      '.000-'       ZZNEGD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZINTDY - Compute number of days between 2 dates            *
      *****************************************************************
     C     SrZINTDY      BEGSR

     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeOut       10
     C                   PARM                    PZINDY            5 0
     C                   PARM                    PZBEG             5 0
     C                   PARM                    PZEND             5 0
     C                   PARM                    PZCALC            1
     C**********         PARM                    INT6DY           15 7                        242286
     C                   PARM                    INT6DY           15 9                        242286

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       232928
      ***SrGetYearNo*-*Get number of days in a year********************                       232928
      *****************************************************************                       232928
     C*****SrGetYearNo***BEGSR                                                                232928
      **********                                                                              232928
     C**********         SELECT                                                               232928
     C**********         WHEN      WkICBS = '2' OR WkICBS = '3'                               232928
     C**********                   OR WkICBS = '5'                                            232928
     C**********                                                                              232928
     C**********         Z-ADD     360           WDaysInYear                                  232928
     C**********         WHEN      WkICBS = '1' OR                                            232928
     C**********                   WkICBS = '4'                                               232928
     C**********         Z-ADD     365           WDaysInYear                                  232928
     C**********         WHEN      WkICBS = '6'                                               232928
     C**********         Z-ADD     366           WDaysInYear                                  232928
     C**********         ENDSL                                                                232928
      **********                                                                              232928
     C**********         ENDSR                                                                232928
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurr - Call to AOCCURR0                                     *
      *                                                               *
      *****************************************************************

     C     SrCurr        BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDCURRPD'
     C                   EVAL      Dbase = 3
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Print Audit Report                                  *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

      ** Ensure Report Spool File recorded by RCF.

     C                   Z-ADD     SFNUMU        ZSNUM             6 0

     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF

      ** Output Report Header.

     C                   WRITE     HEADAU

     C                   SELECT

      ** If there is a DB Error, output the DB Error Information.

     C                   WHEN      (*INU7 = *ON)
     C                   WRITE     DBERROR

      ** If no records read, Output "No Details" message.

     C                   WHEN      (RCOUNT = 0)
     C                   WRITE     NODTLS

      ** If records are read, Output the details information

     C                   WHEN      (RCOUNT > 0)
     C                   WRITE     CONTROL

     C                   ENDSL

      ** End Program and Return.

     C                   SETON                                        LR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdTrl - Update Trailer File                                *
      *                                                               *
      *****************************************************************

     C     SRUpdTrl      BEGSR

     C                   EVAL      DZNORE = RCOUNT + WRCOUNT
     C                   EVAL      DZHRWN = WkVlInt
     C                   EVAL      DZHRDC = WkVlDec
     C                   UPDATE    DKEYSZZF
     C                   MOVE      RCOUNT        RNOREC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZSEdit - Call to 'ZSEDIT'                                    *
      *                                                               *
      *****************************************************************

     C     ZSEdit        BEGSR

     C                   EXSR      AOCURR
     C                   EVAL      ZDECS = A6NBDP

     C**********         CALLB     'ZSEDIT'                                                 BUG13306
     C                   CALL      'ZSEDIT'                                                 BUG13306
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AOCURR - Call to 'AOCURRR0                                   *
      *                                                               *
      *****************************************************************

     C     AOCURR        BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        (PRtCd <> *BLANKS)

      ** Data base error in file SDCURRPD

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  CCY
     C                   EVAL      DBASE  =  003
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Init - Subroutine to do Program Initialisation.              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************

     C     Init          BEGSR

     C                   MOVE      'N'           P1OPEN            1
     C                   MOVE      'N'           P2OPEN            1

      ** Report Work fields.

     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1

     C                   Z-ADD     0             RQDLN2
     C                   Z-ADD     0             DIFLN2

     C                   Z-ADD     0             RCOUNT
     C                   Z-ADD     0             RCOUNTF
     C                   Z-ADD     0             RCOUNTD

     C                   MOVE      *BLANKS       SvBRCA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
      ** Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey = *BLANKS
     C                   EVAL      DbPGM = *BLANKS
     C                   EVAL      DbPGM = 'MM004650'
     C                   EVAL      Dbase = *ZERO
     C                   OUT       LDA

     C     DTSTKY        KLIST
     C                   KFLD                    DTYP
     C                   KFLD                    DLST
     C     DLFEKEY       KLIST
     C                   KFLD                    WkDLNO
     C                   KFLD                    WkFSEQ
     C                   KFLD                    WkSdat

      ** Key list for MMEIRAL3 keyed on loan number and fee sequence                          232928
     C     KFee          KLIST                                                                232928
     C                   KFLD                    KTran                                        232928
     C                   KFLD                    KFeeSeq                                      232928
                                                                                              232928
      ** Key list for MMCFSFL0                                                                232928
     C     KCashFlow     KLIST                                                                232928
     C                   KFLD                    DLNO                                         232928
     C                   KFLD                    KDate                                        232928
                                                                                              232928
     C     *LIKE         DEFINE    DFRECI        WkFeeRECI                                    232928
     C     *LIKE         DEFINE    DFDLNO        WkFeeDLNO                                    232928
     C     *LIKE         DEFINE    DFFSEQ        WkFeeFSEQ                                    232928
     C     *LIKE         DEFINE    DFFCCY        WkFeeFCCY                                    232928
     C     *LIKE         DEFINE    DFFAMT        WkFeeFAMT                                    232928
     C     *LIKE         DEFINE    DFAMTD        WkFeeAMTD                                    232928
     C     *LIKE         DEFINE    DFADJY        WkFeeADJY                                    232928
     C     *LIKE         DEFINE    DFUAFA        WkFeeUAFA                                    232928
                                                                                              232928
      ** Get Bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Access the General Ledger ICD file
     C**********         CALL      'AOGELRR0'                                                 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSSDY

     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Determine if Amortisation is Non-Linear or Linear or Both.
     C                   READ      SDHEDGPD
      ** Determine the interest calculation basis.
     C                   EVAL      WkICBSH = 0                                                232928
     C                   SELECT                                                               232928
     C                   WHEN      FSNDYR = '360'                                             232928
     C                   EVAL      WkICBSH = 3                                                232928
     C                   WHEN      FSNDYR = '365'                                             232928
     C                   EVAL      WkICBSH = 4                                                232928
     C                   WHEN      FSNDYR = '366'                                             232928
     C                   EVAL      WkICBSH = 6                                                232928
     C                   OTHER                                                                232928
     C                   EVAL      WkICBSH = 0                                                232928
     C                   ENDSL                                                                232928
                                                                                              232928
     C**********         EVAL      WkICBSH = *BLANKS                                          232928
     C**********         SELECT                                                               232928
     C**********         WHEN      FSNDYR = '360'                                             232928
     C**********         EVAL      WkICBSH = '3'                                              232928
     C**********         WHEN      FSNDYR = '365'                                             232928
     C**********         EVAL      WkICBSH = '4'                                              232928
     C**********         WHEN      FSNDYR = '366'                                             232928
     C**********         EVAL      WkICBSH = '6'                                              232928
     C**********         OTHER                                                                232928
     C**********         EVAL      WkICBSH = *BLANK                                           232928
     C**********         ENDSL                                                                232928

      ** Access the Midas Modules

     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSSDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check System if Multi-Branch environment

     C                   IF        BGMBIN = 'Y'
     C                   SETON                                        32
     C                   ENDIF

      ** Determine N.A. accrual indiccator from DL ICD
     C                   READ      SDDEALPD

      ** Read Trailer file of DKEYSZZ

     C                   READ      DKEYSZZ

     C                   IF        %EOF(DKEYSZZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DKEYSZZ'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  012
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WRCOUNT = DZNORE
     C                   EVAL      WkVlInt = DZHRWN
     C                   EVAL      WkVlDec = DZHRDC
     C                   ENDIF
     C                   EVAL      P1OPEN = 'N'
     C                   EVAL      P2OPEN = 'N'
     C                   EVAL      WkEvcd = BJDNWD - 1
     C                   IF        BKAPDT < WkEvcd
     C                   EVAL      WkEvcd = BKAPDT
     C                   ENDIF

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
** ##OVR                                                                                      232928
OVRDBF FILE(ZAAMRTL0) TOFILE(MMAMRTL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAAMRTL0)
OVRDBF FILE(HISTSL0) TOFILE(MMHISTL0) SEQONLY(*YES 500)
DLTOVR FILE(HISTSL0)
