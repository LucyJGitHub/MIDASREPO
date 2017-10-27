     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      ****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Limit Utilisation Enquiry')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000796 - Midas SD Limit Utilisation Enquiry.               *
      *                                                               *
      *  Function:  This new enquiry shows the selected Customer's    *
      *             Tax Exemption Threshold and the Amount Utilised   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CER070             Date 24Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CER069             Date 03Jul14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR782319           Date 01Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 AR745790A          Date 20Apr11               *
      *                 AR745790           Date 15Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26992           Date 29Jan10               *
      *                 BUG26715           Date 11Nov09               *
      *                 BUG26206           Date 30Sep09               *
      *                 BUG24935           Date 17Jul09               *
      *                 BUG24574           Date 07Jul09               *
      *                 BUG24696           Date 09Jul09               *
      *                 BUG24579           Date 25Jun09               *
      *                 BUG23120B          Date 02Jun09               *
      *                 BUG24280A          Date 16Jun09               *
      *                 BUG24205           Date 16Jun09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG23120A          Date 02Jun09               *
      *                 BUG24018A          Date 28May09               *
      *                 BUG24032           Date 20May09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24018           Date 23May09               *
      *                 BUG23652           Date 19May09               *
      *                 BUG23120           Date 24Feb09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23308           Date 18Apr09               *
      *                 BUG23307A          Date 03Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG23306           Date 10Mar09               *
      *                 BUG23307           Date 10Mar09               *
      *                 BUG22593           Date 24Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22755           Date 10Jan09               *
      *                 BUG22714           Date 06Jan09               *
      *                 CER048A            Date 19May08               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CER069 - German Tax Enhancement                              *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR782319 - Non resident customers were enquired in Limit     *
      *             Utilisation Enquiry                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR745790A - Reverse AR745790 (Child: AR745791)               *
      *  AR745790 - Display all members of joint customer regardless  *
      *             of joint account management processing type       *
      *             (Child: AR745791)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26992 - Limit Utilisation Enquiry details does not show   *
      *             the details for the NAH-member                    *
      *  BUG26715 - Duplicating entries are shown on details screen   *
      *             for the member account when enquiry for the joint *
      *             account is done prior to the member account       *
      *  BUG26206 - Incorrect EU tax calculation                      *
      *  BUG24935 - Limit Utilisation Report shows a minus            *
      *             figure/incorrect Threshold Excess                 *
      *  BUG24574 - Withholding Tax - R4 vs M+                        *
      *  BUG24696 - Interest/Tax utilisation of a non-resident        *
      *             customer was posted                               *
      *  BUG24579 - Looping on access on Exemption Threshold History  *
      *             File                                              *
      *  BUG23120B - Limit Utilisation enquiry should show Retail     *
      *             number if retail is available.                    *
      *  BUG24280A - Value of Current Threshold is incorrect          *
      *  BUG24205 - DB error control when enquiring a customer with   *
      *             deleted ACUD details                              *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG23120A - Limit Utilisation enquiry should show Retail     *
      *             number.                                           *
      *  BUG24018A - Limit Utilisation enquiry displays incorrect rate*
      *  BUG24032 - Database Error upon pressing enter.               *
      *  BUG23732 - Joint Account Threshold                           *
      *  BUG24018 - Limit Utilisation enquiry displays incorrect rate *
      *  BUG23652 - Limit Utilisation Enquiry - Print Option          *
      *             Function Keys Validation                          *
      *  BUG23120 - Limit Utilisation enquiry is not showing Account  *
      *           number besides transaction details                  *
      *  CER054 - German Feature - Church Tax                         *
      *  BUG23308 - Limit Utilisation screens are confusing to read   *
      *  BUG23307A - Limit Utilisation - Interest period incorrect    *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG23306 - Limit Utilisation Shows duplicate TRNS            *
      *  BUG23307 - Limit Utilisation - Interest period incorrect     *
      *  BUG22593 - Limit Utilisation Enquiry error on screen and     *
      *           no invalid year validation                          *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22755 - The threshold amount should be in whole numbers   *
      *  BUG22714 - Filtered checking of Customer Details by Country  *
      *             of tax to avoid database error                    *
      *  CER048A- German Features - Taxes                             *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01 - 24    Fnn PRESSED                                     *
      *    31         SFLCLR                                          *
      *   N31         SFLCTLDSP                                       *
      *   N32         SFLDSP, SFLEND                                  *
      *****32*********ND*"Auswahl*5=*Detail"***************************                     BUG23308
      *    32         ND "Option 5= Detail"                           *                     BUG23308
      *****33*********PC*SFL-Auswahl*DSEL******************************                     BUG23308
      *    33         PC SFL-Option DSEL                              *                     BUG23308
      *    40         CUSTOMER DDCUST IN ERROR                        *
      *    41         CUSTOMER UTILISATION FIELDS                     *
      *    42         ERROR IN CUST.UTILISATION FIELDS                *
      *    43         ND "TO" & To-Interest-Period(D2DAT)             *
      *    44         SELECTED YEAR DDYEAR IN ERROR                   *
      *    48         ND 1.st JOIN                                    *
      *    49         ND 2.nd JOIN                                    *
      *    90         local                                           *
      *    LR         END OF PROGRAM                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRValFmt - Validate Format F1                                *
      ***SRRb0*-*Set*A006*Rechtsbundig*und*fuhrende*nullen*************                     BUG23308
      *  SRRb0 - Set A006 right-aligned and any zeros                 *                     BUG23308
      *  SRLoadFmt - Load DB-Fields --> Format F2                     *
      *  SRLoadSfl - Load DB --> SD000796S1                           *
      ***SRCtlFmt*-*SFL-Eingabe*auswerten******************************                     BUG23308
      *  SRCtlFmt - Do -Analyse the Input                             *                     BUG23308
      ***SRF4*-*Sfl-Sätze*-->*Format*F4********************************                     BUG23308
      *  SRF4 - Do-phrases --> Format F4                              *                     BUG23308
      *  SRCurr - Read Currency Decimals  --> FG                      *
      *  SRZaSnMs - Send message to program's message queue           *
      *  SRZDate1 - Validate & convert date to a day number           *
      *  SRZDate2 - Convert date from file format to screen format    *
      *  SRZsEdit - Convert amount from file format to screen format  *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR - Program Error Processing Subroutine                  *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Interest Payment History File
      *
     FSDINPHL1  IF   E           K DISK    INFSR(*PSSR) USROPN
      *
      ** CCTX by Customer File
      *
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Customer Income File
      *
     FSDCSINL2  IF   E           K DISK    INFSR(*PSSR) USROPN
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR) USROPN                              BUG26992
     F                                     RENAME(SDCSIND0:SDCSINR3)                        BUG26992
      *
      ** Midas SD Exemption Thrshld Hstry File by Cust& Actn
      *
     FSDTHRHL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas DL Deals file
      *
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
      *
      ** Joint Account Member file
      *
     F***SDJACCL4  IF   E           K DISK    INFSR(*PSSR)                                  BUG23732
     FSDJACCLB  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
      *
      *                                                                                     BUG24018
      * Midas RE Retail account file                                                        BUG24018
      *                                                                                     BUG24018
     FACCRACJ   IF   E           K DISK    INFSR(*PSSR)                                     BUG24018
      *                                                                                     BUG24018
      *                                                                                     BUG24018
      * Midas Interest Sub-Types File                                                       BUG24018
      *                                                                                     BUG24018
     FREINT     IF   E           K DISK    INFSR(*PSSR)                                     BUG24018
      *                                                                                     BUG24018
      ** Screens
      *
     FSD000796DFCF   E             WORKSTN INFDS(SFLDS)
     F                                     SFILE(SD000796S1:SflRrn)
     F                                     SFILE(SD000796S5:SflRrn1)
      *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
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
     D/COPY ZSRSRC,ZDATE2Z1LE
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Override history files
      *
     D***WOvrV1*         C                    'OVRDBF SDINPHL1 SDINPHL1'                    BUG24574
     D***WOvrV1*         C                    'OVRDBF SDINPHPD SDINPHPD'           BUG24574 BUG24935
     D WOvrV1          C                    'OVRDBF SDINPHL1 SDINPHL1 SDINPHL1'             BUG24935
      *
      ** Delete override history file
      *
     D WDlovr          C                    'DLTOVR *ALL'
      *
     D CNumbers        C                    '0123456789'                                    BUG22593
      *                                                                                     BUG22593
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ArrA12          S              1A   DIM(12)
      *
      ** CurrencyCode
      *
     D CCD             S              3A   DIM(10)
      *
      ** Curr.Dec.pl.
      *
     D CDP             S              1A   DIM(10)
      *
     D ZS1             S              1P 0 DIM(15)
      *
     D ZS2             S              1A   DIM(21)
      *
      ** Customer Array
      *
     D ArrCus          S              6A   DIM(500)
     D ArrNAH          S             10A   DIM(500)                                         BUG26992
      *
      ** siehe SRRb0
      *
     D                 DS
     D A12                     1     12
     D A012                    1     12    INZ('000000000000')
     D A006                    7     12
      *
      ** Workstn INFDS
      *
     D SFLDS           DS
     D  SflOrn               378    379  0
      *
      ** Workstn INFDS
      *
     D SAVLDA          DS          1024
     D  LDACUS                 1      6
     D  LDAYEA                 7      8
      *
      ** work S6.0
      *
     D                 DS
     D  S060                   1      6  0
     D  M020                   3      4  0
     D  Y040                   3      6  0
      *
      ** Used in ZSEDIT
      *
     D                 DS
     D  WORK15                 1     15  0
      *
      ** Short Access Object Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Dummy Data Structures used by Access Programs.
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *                                                                                     BUG26992
      ** External DS for Non-Account Holders                                                BUG26992
      *                                                                                     BUG26992
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                BUG26992
      *
      ** External data structures for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External data structures for Accounts by retail number
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      *
      ** Data Structure for Additional Customer Details
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** External data structures for Branch Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)
      *                                                                                     CER048A
      ** Externally described DS for Country code details                                   CER048A
      *                                                                                     CER048A
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                CER048A
      *
      ** External data structures for Location Details
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *                                                                                     BUG23308
      * FKDTA Data Area                                                                     BUG23652
     D FKDTA           DS                  DTAARA(FKDTA)                                    BUG23652
     D  FKey                   1      3                                                     BUG23652
      ** External DS for Country of Tax Code                                                BUG23308
      *                                                                                     BUG23308
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                BUG23308
      *                                                                                     BUG24018
      ** Externally described DS for Dealing Details                                        BUG24018
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                BUG24018
      *                                                                                     BUG24018
      ** External DS for Base Rate details                                                  BUG24018
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                BUG24018
      *                                                                                       CER054
      ** External DS for SAR Details                                                          CER054
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER054
     D WLCD          E                     EXTFLD(LCD)                                        CER054
                                                                                              CER069
     D SDACTX        E DS                  EXTNAME(SDACTXPD)                                  CER069
      **  External DS for customer details by country of tax                                  CER069
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Eop             S              1A
     D WSd             S              2A
      *                                                                                     BUG22593
     D CYrFlg          S              1S 0                                                  BUG22593
      *
      ** Parameter list variables
      *
     D PaPgmQ          S             10A
     D PaPgrl          S              5A
     D PCnum           S             10A
     D PBrch           S              3A
     D PLocn           S              3A
     D PCnst           S              7A
     D PNonAccnt       S                   LIKE(TSNAHO)                                     BUG26992
      *
      ** Parameter list variables for FCC0201A
      *
     D ParM01          S             10A
     D ParM02          S              5A
     D ParM03          S             10A
     D ParM04          S              5A
     D ParM05          S             10A
     D ParM06          S              1A
     D ParM07          S              1A
      *
     D WAufs1          S              5P 0
     D PBrnch          S              3A
     D PErrCd          S              1P 0
      *
     D WTesTY          S              2A
     D WWrtcD          S              1A
     D WWLen           S             15P 5
      *
     D I               S              3P 0
     D IM              S              3P 0
     D WIdx            S              3P 0
     D B006            S              6A
      *
      ** Declaration of work field
      *
     D WCpy2           S             80A
     D WUtiL           S             15P 0
     D WTutIL          S             17P 0
     D WUthR           S             15P 0
     D WTuthR          S             17P 0
     D WCexT           S              8P 0
     D WTcexT          S              8P 0
     D WWdlaC          S              6P 0
     D WWYr2           S              2P 0
     D WWYeaR          S              2P 0
     D WkYr2           S              2A
     D WTSipdt         S              5P 0
     D WkSGINB         S             17P 0                                                  BUG26992
     D WkSNINB         S             17P 0                                                  BUG26992
     D WkCTAX          S             17P 0                                                  BUG26992
      *                                                                                     BUG26992
      *
     D*WYr******       S              2A                                                     CER048A
     D*WHstDt***       S              6A                                                     CER048A
     D WActDt          S              5P 0
      *
     D*WZeCde          S              1A
     D*WZdecS          S              1P 0
     D*WZFld5          S             15P 0
     D*WWCmd****       S             30A                                                    BUG24935
     D WWCmd           S             40A                                                    BUG24935
     D WwJcu1          S              6A
     D WwJcu2          S              6A
      *
     D SflRrn          S              5P 0
     D SflRrn1         S              5P 0
      *
     D WFld06          S              6P 0
     D WFld11          S              2P 0
      *
      ** Parameter list for AOACCTR0
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PpRetL          S             10A
     D PpCnum          S              6A
     D PpCucD          S              3A
     D*PpAccD          S              4A                                                    BUG23120
     D PpAccD          S             10A                                                    BUG23120
     D PpAcsQ          S              2A
     D PpBrcA          S              3A
     D PCnCd           S              2A                                                    CER048A
      *
     D*D004*****       S              4A                                                    BUG23308
     D*D010*****       S              4A                                           BUG23308 BUG23120
     D D010            S             10A                                                    BUG23120
     D D002            S              2A
     D WFtrTp          S              4A
     D WSflNz          S              5P 0
      *
     D PKey1           S              3A
     D WwMult          S              4P 0
      *
      ** Prameter list for Y2SNMGC
      *
     D PAmsId          S              7A
     D PAMsgf          S             10A
     D PAMsda          S            132A
     D PAMstp          S              7A
      *
     D FDFMT2          S              1A
     D WSCUSTN         S              6A
     D KFCust          S              6A
     D KFCTxCd         S              2A
     D*SCUSTA***       S             10A                                                     CER048A
     D SCUSTA          S              6A                                                     CER048A
      *
     D WkDayn          S              5P 0
     D*WD1Dat***       S              6A                                                    BUG23308
     D*WD2Dat***       S              6A                                                    BUG23308
     D WZDate1         S              8A
     D KCrtt           S              2A
     D KTxBs           S              2A
      *
      ** Parameters for ZDATE9
      *
     D PZDayNo         S              5P 0
     D PZDate1         S              8S 0
     D PErrorFlag      S              1A
      *
      ** Parameters for ZDATE1
      *
     D PDateIn         S              6A
     D PDayNoOut       S              5P 0
      *
      ** Parametrs for ZSEDIT
      *
     D PZFld15         S             15P 0
     D PZDecs          S              1P 0
     D PZeCode         S              1A
     D PZout21         S             21A
      *
      ** Parameters for ZDATE2
      *
     D PZDayNo2        S              5P 0
     D PZDate          S              6P 0
     D PZADate         S              7A
     D PDtIn           S              8A                                                    BUG23308
     D WDlnum          S              6A                                                    BUG23308
     D PCtrT           S              2A                                                    BUG23308
     D PCtrR           S              2A                                                    BUG23308
      *                                                                                       CER054
     D CER054          S              1A                                                      CER054
     D PSard           S              6A                                                      CER054
      *
     D WGint           S             15P 0                                                  BUG23732
     D WTgint          S             17P 0                                                  BUG23732
     D WTtax           S             15P 0                                                  BUG23732
     D WTttax          S             17P 0                                                  BUG23732
      *                                                                                     BUG23732
     D FKeyOut         S              3A                                                    BUG23652
      *                                                                                     BUG23652
     D                 DS                                                                   BUG24018
     D RKey                    1     12                                                     BUG24018
     D R2TYP                   2      3                                                     BUG24018
     D R2STP                   4      8                                                     BUG24018
     D R2CCY                   9     11                                                     BUG24018
     D R2REC                  12     12                                                     BUG24018
      *                                                                                     BUG24018
     D RAT2            DS                                                                   BUG24018
     D R2RAT                         11P 7 DIM(11)                                          BUG24018
      *                                                                                     BUG24018
     D BAL2            DS                                                                   BUG24018
     D R2BAL                         15P 0 DIM(11)                                          BUG24018
      *                                                                                     BUG24018
     D WStaxYr         S              8A                                                    BUG24280
     D WEtaxYr         S              8A                                                    BUG24280
     D WSYear          S              5P 0                                                  BUG24280
     D WEYear          S              5P 0                                                  BUG24280
     D TYear           S              4P 0                                                  BUG24280
     D WYear           S              4A                                                    BUG24280
     D WMmDd           S              4A                                                    BUG24280
     D WJeyd           S              5P 0                                                  BUG24280
      *                                                                                     BUG24280
     D PDate           S              8S 0                                                  BUG24280
     D PDayNo          S              5P 0                                                  BUG24280
      *                                                                                     BUG24280
     D WYrEndD         S              6A                                                    BUG24935
     D WETYear         S              5P 0                                                  BUG24935
      *                                                                                     BUG24935
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the SRInit  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ***Bis*Eop=*'1'                                                                       BUG23308
      ** Until Eop= '1'                                                                     BUG23308
      *
     C                   DOU       Eop = '1'
      *
      ** Format F1  select cust
      ** if WSd = '10'
      *
     C                   IF        WSd = '10'
      *
      ** Refresh Format F1
      *
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDYEAR = *BLANKS
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN44 = *OFF
      *
      ** Next: exec format F1
      *
     C                   EVAL      WSd = '11'
     C                   EVAL      *IN05 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   ENDIF
      *
      ** While WSd = '11'
      *
     C                   DOW       WSd <= '11' AND
     C                             *IN03 = *OFF AND
     C                             *IN05 = *OFF
      *
      ** Exec format F1
      *
     C                   WRITE     SD000796F0
     C                   WRITE     SD000796C0
     C                   EXFMT     SD000796F1
      *
      ** Initialize program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         PaPgmQ
     C                   PARM      '*SAME'       PaPgrl
      *
      ** If F3: exit pgm
      *
     C                   IF        *IN03 = *OFF  AND
     C                             *IN05 = *OFF
      *
      ** Reset previous Error Indicators, no Utilisation fields
      *
     C                   MOVEA     '000'         *IN(40)
     C                   MOVEA     '0'           *IN(44)
      *
      ** If selection entered
      *
     C                   IF        DDCUST = '?   '
      *
      ** Customer must be live on SDCUSTPD
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUST        PCnum
     C                   PARM                    PCnst
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtcd = *BLANKS OR
     C                             PRtcd = '*NRF'
     C                   EVAL      DDCUST = BBCUST
     C                   ELSE
     C                   EVAL      DDCUST = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
      *                                                                                     BUG22593
      ** Validate Year entered                                                              BUG22593
     C                   EVAL      CYrFlg = 0                                               BUG22593
     C                   IF        DDYEAR <> *BLANKS                                        BUG22593
     C                   EVAL      CYrFlg = %CHECK(CNumbers : DDYEAR)                       BUG22593
      *                                                                                     BUG22593
     C                   IF        CYrFlg <> 0                                              BUG22593
     C                   EVAL      PAmsId = 'USR0822'                                       BUG22593
     C                   EVAL      PAMsgf = 'SDUSRMSG'                                      BUG22593
     C                   EVALR     *IN44 = *ON                                              BUG22593
     C                   EXSR      SRZaSnMs                                                 BUG22593
     C                   ENDIF                                                              BUG22593
     C                   ENDIF                                                              BUG22593
      *                                                                                     BUG22593
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUST        PCnum
     C     SDACUS        PARM      SDACUS        DSSDY
      *
     C                   IF        DDCUST <> *BLANKS
      *                                                                                     BUG24205
      ** Check if additional customer details has been deleted                              BUG24205
      *                                                                                     BUG24205
     C                   IF        PRtcd = '*CUSDEL'                                        BUG24205
     C                   EVAL      PAmsId = 'SDM0113'                                       BUG24205
     C                   EVAL      PAMsgf = 'SDUSRMSG'                                      BUG24205
     C                   EVAL      *IN40 = *ON                                              BUG24205
     C                   EXSR      SRZaSnMs                                                 BUG24205
     C                   ELSE                                                               BUG24205
      *
      ** Reset valid selection / customer utilisation
      *
     C                   EVAL      DMACNM = *BLANKS
     C                   EVAL      FDFMT2 = '0'
      *
      ** Validate format F1, set error indicators
      *
     C                   EXSR      SRValFmt
      *
      ** If no error: goto format F1
      *
     C                   IF        *IN40 = *OFF AND
     C                             *IN44 = *OFF
     C                   EVAL      WSd = '20'
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG24205
     C                   ENDIF
      *
      ** If F3 or F5 pressed
      *
     C                   ELSE
      *
      ** If F3 exit
      *
     C                   IF        *IN03 = *ON
     C                   EVAL      Eop = '1'
     C                   ENDIF
      *
      ** If F5: refresh
      *
     C                   IF        *IN05 = *ON
     C                   EVAL      FDFMT2 = '0'
     C                   EVAL      WSd = '10'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Format F2 cust utilisation fields
      ** If WSd = '20'
      *
     C                   IF        WSd = '20'
      *
      ** Reset previous Error - a.o. indicators
      *
     C                   MOVEA     '1100000'     *IN(48)
      *
      ** DB-fields --> DspF, set Error indicators
      *
     C                   EXSR      SRLoadFmt
      *
      ** Valid selection, display customer utilisation fields
      *
     C                   EVAL      FDFMT2 = '1'
      *
      ** Next: exec format F1
      *
     C                   EVAL      WSd = '60'
      *
     C                   ENDIF
      *
      ** While WSd = '60'
      *
     C                   DOW       WSd = '60' AND
     C                             *IN03 = *OFF AND
     C                             *IN05 = *OFF
      *
      ** Exec SF-Ctl format
      *
     C                   WRITE     SD000796F0
      *
      ** If sfl.rcd. exist (N32: SFLDSP, SFLEND)
      *
     C                   IF        *IN32 = *OFF
      *
     C                   WRITE     SD000796F6
     C                   WRITE     SD000796C0
     C                   EXFMT     SD000796C5
      *
      ** Initialize program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         PaPgmQ
     C                   PARM      '*SAME'       PaPgrl
      *
      ** Case F8: details
      *
     C                   IF        *IN08 = *ON
      *                                                                                     BUG24696
      ** F8 not allowed when customer is non-resident                                       BUG24696
      *                                                                                     BUG24696
     C                   EXSR      SrCusCtyTx                                               BUG26206
      *                                                                                     BUG26206
      **********                                                                            BUG26206
     C**********         CALL      'AOCTTXR0'                                      BUG24696 BUG26206
     C**********         PARM      *BLANKS       PRtcd                             BUG24696 BUG26206
     C**********         PARM      '*KEY   '     POptn                             BUG24696 BUG26206
     C**********         PARM      DVCNCD        PCtrT                             BUG24696 BUG26206
     C**********         PARM      *BLANKS       PCtrR                             BUG24696 BUG26206
     C*****SDCTTX        PARM      SDCTTX        DSFDY                             BUG24696 BUG26206
      **********                                                                   BUG24696 BUG26206
     C**********         IF        PRtcd <> *BLANKS                                BUG24696 BUG26206
     C******LOCK         IN        LDA                                             BUG24696 BUG26206
     C**********         EVAL      DBKEY = DVCNCD                                  BUG24696 BUG26206
     C**********         EVAL      DBFILE = 'SDCTTXPD'                             BUG24696 BUG26206
     C**********         EVAL      DBASE = 111                                     BUG24696 BUG26206
     C**********         OUT       LDA                                             BUG24696 BUG26206
     C**********         EXSR      *PSSR                                           BUG24696 BUG26206
     C**********         ENDIF                                                     BUG24696 BUG26206
      **********                                                                   BUG24696 BUG26206
     C**********         IF        BBCOLC <> EWCTRT                                BUG24696 BUG26206
     C                   If        WCOLc <> WCtryCde                                        BUG26206
     C                   EVAL      PAmsId = 'USR8420'                                       BUG24696
     C                   EVAL      PAMsgf = 'GBSDUSRMSG'                                    BUG24696
     C                   EXSR      SRZaSnMs                                                 BUG24696
     C                   ELSE                                                               BUG24696
     C                   EVAL      WSd = '30'
     C                   ENDIF                                                              BUG24696
     C                   ELSE
      *
      ** Case F24: Sbm Print Job
      *
     C                   IF        *IN24 = *ON
      *
      ** If *LDA is not empty do not show the prompt screen
      *
     C                   IN        SAVLDA
     C                   EVAL      LDACUS = *BLANKS
     C                   EVAL      LDACUS = DACNUM
     C                   EVAL      LDAYEA = *BLANKS
      *
     C                   IF        WWYeaR <> WWYr2
     C                   MOVE      WWYeaR        LDAYEA
     C                   ENDIF
      *
     C                   OUT       SAVLDA
      *
      ** Submit SD000798 with RCF
      *
      * First, Initialised Data Area (FKDTA)                                                BUG23652
      *                                                                                     BUG23652
     C     *LOCK         IN        FKDTA                                                    BUG23652
     C                   EVAL      FKEY = *Blanks                                           BUG23652
     C                   OUT       FKDTA                                                    BUG23652
      *                                                                                     BUG23652
     C                   CALL      'FCC0201A'                           90
     C                   PARM      'SDC000798'   ParM01
     C                   PARM      '10001'       ParM02
     C                   PARM      'SD000798'    ParM03
     C                   PARM      ' '           ParM04
     C                   PARM      'SD000797'    ParM05
     C                   PARM      'B'           ParM06
     C                   PARM      'I'           ParM07
      *
      ** Message: submit (un)successful
      *
     C**********         IF        *IN90 = *OFF                                             BUG23652
     C**********         EVAL      PAmsId = 'USR8249'                                       BUG23652
     C**********         ELSE                                                               BUG23652
     C**********         EVAL      PAmsId = 'USR8248'                                       BUG23652
     C**********         ENDIF                                                              BUG23652
      *
     C                   IN        FKDTA                                                    BUG23652
     C                   MOVEL     FKEY          FKEYOUT                                    BUG23652
      *                                                                                     BUG23652
     C                   IF        FKEYOUT = 'FOK'                                          BUG23652
     C                   EVAL      PAmsId = 'USR8249'                                       BUG23652
     C                   ELSE                                                               BUG23652
     C                   EVAL      PAmsId = 'USR8248'                                       BUG23652
     C                   ENDIF                                                              BUG23652
      *                                                                                     BUG23652
     C                   EVAL      PAMsgf = 'SDUSRMSG'
     C                   EXSR      SRZaSnMs
      *
      ** If F3 or F5 pressed
      *
     C                   ELSE
      *
      ** If F3 exit
      *
     C                   IF        *IN03 = *ON OR
     C                             Eop = '1'
     C                   EVAL      Eop = '1'
     C                   EVAL      *IN03 = *ON
     C                   ELSE
      *
      ** ELSE ENTER
      *
     C                   IF        *IN12 = *ON
     C                   EVAL      WSd = '10'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Subfile details
      ** If WSd = '30'
      *
     C                   IF        WSd = '30'
      *
      ***Sfl*von*DB*laden*(komplett)                                                        BUG23308
      ** Do DB load (complete)                                                              BUG23308
      *
     C                   EXSR      SRLoadSfl
      *
      ** Next: exec format CTL01
      *
     C                   EVAL      WSd = '31'
     C                   ENDIF
      *
      ** While WSd = '31'
      *
     C                   DOW       WSd = '31' AND
     C                             *IN03 = *OFF AND
     C                             *IN12 = *OFF
      *
      ** Exec SF-Ctl format
      *
     C                   WRITE     SD000796F0
     C                   WRITE     SD000796F3
     C                   WRITE     SD000796C3
      *
      ** If sfl.rcd. exist (N32: SFLDSP, SFLEND)
      *
     C                   IF        *IN32 = *OFF
      *
     C                   EXFMT     SD000796C1
      *
      ** If N_F03 & N_F12:  +
      ***+**SFL-Eingabe*auswerten                                                           BUG23308
      ** Do- Input analysis                                                                 BUG23308
      *
     C  N03              IF        *IN12 = *OFF
      *
      ***Vorläufig:*+                                                                       BUG23308
      ***Zum*erneuten*Aufsetzen*auf*lfd.*Seite:*+                                           BUG23308
      ***+*obersten*SFL-Satz*speichern*+                                                    BUG23308
      ** Temporarily Store the RRN Number                                                   BUG23308
      *
     C                   Z-ADD     SflOrn        WAufs1
      *
     C                   EXSR      SRCtlFmt
      *
      ***SFL-Anzeige*positionieren                                                          BUG23308
      ** Do-Display move                                                                    BUG23308
      *
     C                   IF        WAufs1 > 0
     C                   Z-ADD     WAufs1        DSFLPO
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
      ** Else message-fmt only:
      *
     C                   EXFMT     SD000796C2
     C                   ENDIF
      *
      ** If F3: exit Pgm
      *
     C                   IF        *IN03 = *ON OR
     C                             Eop = '1'
     C                   EVAL      Eop = '1'
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
      *
      ** If F12: previous
      *
     C                   IF        *IN12 = *ON
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      WSd = '60'
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDDO
      *
      ** EOP
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFmt - Validate Format F1                                *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRRb0, SRZaSnMs, *PSSR                                *
      *                                                               *
      *****************************************************************
      *
     C     SRValFmt      BEGSR
      *
      ** Keyfield prepare
      *
     C                   EVAL      A006 = DDCUST
     C                   EXSR      SRRb0
     C                   EVAL      DDCUST = A006
      *
      ** Validate customer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUST        PCnum
     C                   PARM                    PCnst
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PAmsId = 'SDM0113'
     C                   EVAL      PAMsgf = 'SDUSRMSG'
     C                   EXSR      SRZaSnMs
     C                   LEAVESR
     C                   ENDIF
      *
      ** Retrieve  Location Code
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBBRCD        PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     005           DBASE
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBrch
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Country Code
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8LCCD        PLocn
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     006           DBASE
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBKEY = PLocn
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     AR782319
      ** CALL access object for Cust Details by Ctry of Tax                                 AR782319
      ** to retrieve Country of Tax                                                         AR782319
      *                                                                                     AR782319
     C                   CALL      'AOCTTXR0'                                               AR782319
     C                   PARM      *BLANKS       PRtcd                                      AR782319
     C                   PARM      '*KEY   '     POptn                                      AR782319
     C                   PARM      DVCNCD        PCtrT                                      AR782319
     C                   PARM      BBCOLC        PCtrR                                      AR782319
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      AR782319
      *                                                                                     AR782319
     C                   IF        PRtcd <> *BLANKS                                         AR782319
      *                                                                                     AR782319
     C                   CALL      'AOCTTXR0'                                               AR782319
     C                   PARM      *BLANKS       PRtcd                                      AR782319
     C                   PARM      '*KEY   '     POptn                                      AR782319
     C                   PARM      DVCNCD        PCtrT                                      AR782319
     C                   PARM      *BLANKS       PCtrR                                      AR782319
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      AR782319
      *                                                                                     AR782319
     C                   IF        PRtcd <> *BLANKS                                         AR782319
     C     *LOCK         IN        LDA                                                      AR782319
     C                   EVAL      DBKEY = DVCNCD                                           AR782319
     C                   EVAL      DBFILE = 'SDCTTXPD'                                      AR782319
     C                   EVAL      DBASE = 112                                              AR782319
     C                   OUT       LDA                                                      AR782319
     C                   EXSR      *PSSR                                                    AR782319
     C                   ENDIF                                                              AR782319
      *                                                                                     AR782319
     C                   ENDIF                                                              AR782319
      *
      ** Set up Key to access Customer Details by Country of Tax
      *
     C                   IF        E5JATP = 'Y' OR E5JATP = 'I'                             BUG22714
      *                                                                                     BUG22714
     C                   EVAL      KFCust = DDCUST
     C                   EVAL      KFCTxCd = DVCNCD
      *
      ** Retrieve European Tax Status
      *
     C     KLAcTx        CHAIN     SDACTXL1
      *
     C                   IF        NOT %FOUND(SDACTXL1)
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE
     C                   EVAL      DBFILE = 'SDACTXL1'
     C                   EVAL      DBKEY = DDCUST
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     BUG22714
     C                   ENDIF                                                              BUG22714
      *
      ** Check if user has authority on the customer
      *
     C                   CALL      'ZVBBU'
     C                   PARM      BBBRCD        PBrnch
     C                   PARM      *ZERO         PErrCd
      *
     C                   IF        PErrCd <> 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PAmsId = 'USR8247'
     C                   EVAL      PAMsgf = 'SDUSRMSG'
     C                   EXSR      SRZaSnMs
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        *IN44 = *ON                                              BUG22593
     C                   LEAVESR                                                            BUG22593
     C                   ENDIF                                                              BUG22593
      *                                                                                     BUG22593
      ** Check selected year (if entered, history files must exist)
      ** Selected year : Default to current year
      *
     C                   IF        DDYEAR = *BLANKS
     C                   MOVE      WWYr2         DDYEAR
     C                   ENDIF
      *
     C                   MOVE      DDYEAR        WWYeaR
     C                   IF        WWYeaR <> WWYr2
     C                   EVAL      WTesTY = DDYEAR
     C                   CALL      'SDC000797'
     C                   PARM                    WTesTY
     C                   PARM      *BLANKS       WWrtcD
      *
     C                   IF        WWrtcD <> *BLANKS
     C                   EVAL      PAmsId = 'USR8252'
     C                   EVAL      PAMsgf = 'SDUSRMSG'
     C                   EVALR     *IN44 = *ON
     C                   EXSR      SRZaSnMs
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG24280
      ** Get the Start and End of Tax Year                                                  BUG24280
      *                                                                                     BUG24280
     C**********         IF        WWYeaR <> WWYr2                                 BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
      ***Convert the End of Year Date No. to YYYYMMDD format                       BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         CALLB     'ZDATE9'                                        BUG24280 BUG24935
     C**********         PARM      BJEYD         PZDayNo                           BUG24280 BUG24935
     C**********         PARM      *ZEROS        PZDate1                           BUG24280 BUG24935
     C**********         PARM      *BLANKS       PErrorFlag                        BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         MOVE      PZDate1       WEtaxYr                           BUG24280 BUG24935
     C**********         EVAL      %SUBST(WEtaxYr:3:2) = DDYEAR                    BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         MOVE      WETaxYr       PDate                             BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
      ***Convert the End of Year in YYYYMMDD format into Day No                    BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         CALLB     'ZDATE10'                                       BUG24280 BUG24935
     C**********         PARM                    PDate                             BUG24280 BUG24935
     C**********         PARM      *ZEROS        PDayNo                            BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WEYear = PDayNo                                 BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         ELSE                                                      BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WEYear = BJEYD                                  BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         ENDIF                                                     BUG24280 BUG24935
      *                                                                                     BUG24935
     C                   MOVE      WWYear        WYrEndD                                    BUG24935
     C                   MOVEL     WMmDd         WYrEndD                                    BUG24935
      *                                                                                     BUG24935
     C                   CALLB     'ZDATE1'                                                 BUG24935
     C                   PARM                    WYrEndD                                    BUG24935
     C                   PARM      *ZEROS        PZDAYNO           5 0                      BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *BLANKS       PERR              1                        BUG24935
     C                   Z-ADD     PZDAYNO       WEYear                                     BUG24935
      *                                                                                     BUG24280
     C**********         EVAL      WJeyd = BJEYD + 1                               BUG24280 BUG24935
     C                   EVAL      WJeyd = WEyear + 1                                       BUG24935
      *                                                                                     BUG24280
      ** Convert the End of Year Date No. plus 1 to YYYYMMDD format                         BUG24280
      *                                                                                     BUG24280
     C                   CALLB     'ZDATE9'                                                 BUG24280
     C                   PARM      WJeyd         PZDayNo                                    BUG24280
     C                   PARM      *ZEROS        PZDate1                                    BUG24280
     C                   PARM      *BLANKS       PErrorFlag                                 BUG24280
      *                                                                                     BUG24280
     C                   MOVE      PZDate1       WStaxYr                                    BUG24280
     C**********         EVAL      WMmDd = %SUBST(WStaxYr:5:4)                     BUG24280 BUG24935
      *                                                                                     BUG24280
     C                   IF        WWYear <= 39                                             BUG24280
     C                   MOVEL     20            TYear                                      BUG24280
     C                   ELSE                                                               BUG24280
     C                   MOVEL     19            TYear                                      BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      WWYeaR        TYear                                      BUG24280
      *                                                                                     BUG24280
     C**********         IF        WMmDd <> '0101'                                 BUG24280 BUG24935
     C                   IF        ((WMmDd <> '3112' AND BJDFIN = 'D')                      BUG24935
     C                             OR (WMmDd <> '1231' AND BJDFIN = 'M'))                   BUG24935
     C                             AND WETYear >= BJRDNB                                    BUG24935
     C                   EVAL      TYear = TYear - 1                                        BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      TYear         WYear                                      BUG24280
      *                                                                                     BUG24280
     C                   EVAL      %SUBST(WStaxYr:1:4) = WYear                              BUG24280
      *                                                                                     BUG24280
      ** Convert the End of Year in YYYYMMDD format into Day No                             BUG24280
      *                                                                                     BUG24280
     C                   MOVE      WSTaxYr       PDate                                      BUG24280
      *                                                                                     BUG24280
     C                   CALLB     'ZDATE10'                                                BUG24280
     C                   PARM                    PDate                                      BUG24280
     C                   PARM      *ZEROS        PDayNo                                     BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WSYear = PDayNo                                          BUG24280
      *
      ** The selected customer must be exist in the History
      ** header file
      ** Retrieve the history file
      *
     C                   IF        WWYeaR <> WWYr2
      *
     C     WOvrV1        CAT       WTesTY        WWCmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    WWCmd
     C**********         PARM      30            WWLen                                      BUG24935
     C                   PARM      40            WWLen                                      BUG24935
      *
     C                   ENDIF
      *
     C                   IF        *IN60 = *OFF
     C                   OPEN      SDINPHL1
     C                   EVAL      *IN60 = *ON
     C                   ENDIF
      *
     C                   IF        EWTHMD = 'Y'                                             AR782319
     C                   EVAL      WSCUSTN = DDCUST
     C     WSCUSTN       CHAIN     SDINPHL1
      *
     C                   IF        NOT %FOUND(SDINPHL1)
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PAmsId = 'USR8246'
     C                   EVAL      PAMsgf = 'SDUSRMSG'
     C                   EXSR      SRZaSnMs
     C                   ENDIF
                                                                                            AR782319
     C                   ELSE                                                               AR782319
     C                   EVAL      *IN40 = *ON                                              AR782319
     C                   EVAL      PAmsId = 'USR8420'                                       AR782319
     C                   EVAL      PAMsgf = 'SDUSRMSG'                                      AR782319
     C                   EXSR      SRZaSnMs                                                 AR782319
     C                   ENDIF                                                              AR782319
      *
     C                   IF        *IN60 = *ON
     C                   CLOSE     SDINPHL1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   IF        WWYeaR <> WWYr2
      *
     C                   EVAL      WWCmd = WDlovr
     C                   CALL      'QCMDEXC'
     C                   PARM                    WWCmd
     C**********         PARM      30            WWLen                                      BUG24935
     C                   PARM      40            WWLen                                      BUG24935
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ***SRRb0*-*SET*A006*RECHTSBÜNDIG*UND*FÜHRENDE*NULLEN*************                     BUG23308
      *  SRRb0 - Set A006 right-aligned and leading zeros             *                     BUG23308
      *                                                               *
      *  Called by: SRValFmt                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRb0         BEGSR
      *
     C                   Z-ADD     12            I
     C                   MOVEA     A12           ArrA12
     C                   DOW       ArrA12(I) = ' '
     C                   SUB       1             I
     C                   ENDDO
      *
     C                   SUB       5             I
     C                   MOVEA     ArrA12(I)     B006
     C                   EVAL      A006 = B006
      *
     C                   ENDSR
      *****************************************************************                     BUG26992
      /EJECT                                                                                BUG26992
      *****************************************************************                     BUG26992
      *                                                               *                     BUG26992
      *  SRRtvNonAcc - Access Non Account Holder details              *                     BUG26992
      *                                                               *                     BUG26992
      *  Called by: SRRTNAHD                                          *                     BUG26992
      *                                                               *                     BUG26992
      *  Calls:                                                       *                     BUG26992
      *                                                               *                     BUG26992
      *****************************************************************                     BUG26992
      *                                                                                     BUG26992
     C     SRRtvNonAcc   BEGSR                                                              BUG26992
                                                                                            BUG26992
     C                   CALL      'AONAHOR0'                                               BUG26992
     C                   PARM      *Blanks       PRtcd                                      BUG26992
     C                   PARM      '*KEY   '     POptn                                      BUG26992
     C                   PARM                    PNonAccnt                                  BUG26992
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG26992
                                                                                            BUG26992
      ** No Record Found/ Error Encountered                                                 BUG26992
                                                                                            BUG26992
     C                   IF        PRtcd <> *BLANKS                                         BUG26992
     C                   EVAL      NHNARN = *BLANKS                                         BUG26992
     C                   ENDIF                                                              BUG26992
                                                                                            BUG26992
     C                   ENDSR                                                              BUG26992
      *****************************************************************                     BUG26992
      /EJECT                                                                                BUG26992
      *****************************************************************                     BUG26992
      *                                                               *                     BUG26992
      *  SRRTNAHD - SR Load NAHO Member details in F2                 *                     BUG26992
      *                                                               *                     BUG26992
      *  Called by:                                                   *                     BUG26992
      *                                                               *                     BUG26992
      *  Calls:                                                       *                     BUG26992
      *                                                               *                     BUG26992
      *****************************************************************                     BUG26992
      *                                                                                     BUG26992
     C     SRRTNAHD      BEGSR                                                              BUG26992
      *                                                                                     BUG26992
     C                   EVAL      WkSGINB = 0                                              BUG26992
     C                   EVAL      WkSNINB = 0                                              BUG26992
     C                   EVAL      WkCTAX  = 0                                              BUG26992
      *                                                                                     BUG26992
     C                   EVAL      PNonAccnt = JCNAHO                                       BUG26992
     C                   EXSR      SRRtvNonAcc                                              BUG26992
     C                   EVAL      DMACNM    = JCNAHO                                       BUG26992
     C                   EVAL      DACRNM    = NHNARN                                       BUG26992
      **********                                                                  AR745790 AR745790A
     C**********         IF        A4JAMG <> '3'                                  AR745790 AR745790A
      *                                                                                     BUG26992
     C                   OPEN      SDCSINL3                                                 BUG26992
     C     JCNAHO        SETLL     SDCSINL3                                                 BUG26992
     C     JCNAHO        READE     SDCSINL3                                                 BUG26992
     C                   DOW       NOT %EOF(SDCSINL3)                                       BUG26992
      *                                                                                     BUG26992
     C                   IF        TSRDNB >= WSYear AND                                     BUG26992
     C                             TSRDNB <= WEYear                                         BUG26992
      *                                                                                     BUG26992
     C                   EVAL      WkSGINB = WkSGINB+ TSGINB                                BUG26992
     C                   EVAL      WkSNINB = WkSNINB+ TSNINB                                BUG26992
      *                                                                                     BUG26992
     C                   EVAL      WkCTAX  = WkCTAX + TSTXSB +                              BUG26992
     C                                       TSSTDB + TSTTDB                                BUG26992
      *                                                                                     BUG26992
     C                   ENDIF                                                              BUG26992
      *                                                                                     BUG26992
     C     JCNAHO        READE     SDCSINL3                                                 BUG26992
     C                   ENDDO                                                              BUG26992
      **********                                                                  AR745790 AR745790A
     C**********         CLOSE     SDCSINL3                                       AR745790 AR745790A
     C**********         ENDIF                                                    AR745790 AR745790A
      *                                                                                     BUG26992
     C                   MOVE      CDP(1)        PZDecs                                     BUG26992
     C                   Z-ADD     WkSNINB       PZFld15                                    BUG26992
     C                   EXSR      SRZsEdit                                                 BUG26992
     C                   MOVE      PZout21       DAUTIL                                     BUG26992
      *                                                                                     BUG26992
     C                   Z-ADD     0             PZFld15                                    BUG26992
     C                   EXSR      SRZsEdit                                                 BUG26992
     C                   MOVE      PZout21       DAUTHR                                     BUG26992
      *                                                                                     BUG26992
     C                   Z-ADD     WkSGINB       PZFld15                                    BUG26992
     C                   EXSR      SRZsEdit                                                 BUG26992
     C                   MOVE      PZout21       DAGINT                                     BUG26992
      *                                                                                     BUG26992
     C                   Z-ADD     WkCTAX        PZFld15                                    BUG26992
     C                   EXSR      SRZsEdit                                                 BUG26992
     C                   MOVE      PZout21       DATTAX                                     BUG26992
      *                                                                                     BUG26992
     C                   MOVE      'J'           PZeCode                                    BUG26992
     C                   Z-ADD     0             PZDecs                                     BUG26992
     C                   Z-ADD     0             PZFld15                                    BUG26992
     C                   EXSR      SRZsEdit                                                 BUG26992
     C                   MOVE      PZout21       DACEXT                                     BUG26992
      *                                                                                     BUG26992
     C                   EVAL      SflRrn1 = SflRrn1 +1                                     BUG26992
      *                                                                                     BUG26992
     C                   IF        FDFMT2 = '1'                                             BUG26992
     C                   WRITE     SD000796S5                                               BUG26992
     C                   ENDIF                                                              BUG26992
      *                                                                                     BUG26992
     C**********         CLOSE     SDCSINL3                                        BUG26992 AR745790
     C                   CLOSE     SDCSINL3                                                AR745790A
      *                                                                                     BUG26992
     C                   ENDSR                                                              BUG26992
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadFmt - LOAD DB-Fields --> Format F2                     *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRZsEdit, SRZDate1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadFmt     BEGSR
      *
      ** Reset work fields
      *
     C                   Z-ADD     0             WUtiL
     C                   Z-ADD     0             WTutIL
     C                   Z-ADD     0             WUthR
     C                   Z-ADD     0             WTuthR
     C                   Z-ADD     0             WCexT
     C                   Z-ADD     0             WTcexT
     C                   Z-ADD     0             WGint                                      BUG23732
     C                   Z-ADD     0             WTgint                                     BUG23732
     C                   Z-ADD     0             WTtax                                      BUG23732
     C                   Z-ADD     0             WTttax                                     BUG23732
      *
      ** Clear SFL
      *
     C                   EVAL      *IN31 = *ON
     C                   WRITE     SD000796C5
     C                   EVAL      *IN31 = *OFF
     C                   Z-ADD     0             SflRrn1
      *
     C                   IF        E5JATP <> *BLANKS
     C                   MOVEL     E5JATP        DDJATP
     C                   ELSE
     C                   MOVEL     *ALL'-'       DDJATP
     C                   ENDIF
      *
     C     *LIKE         DEFINE    E5JATP        DAJATP
     C                   MOVEL     E5JATP        DAJATP
      *
      ** Customer
      *
     C                   EVAL      DACNUM = DDCUST
     C                   EVAL      DMACNM = DDCUST
     C                   EVAL      D3ACNM = DDCUST
     C                   EVAL      DACRNM = BBCRNM
     C                   EVAL      D3CRNM = BBCRNM
     C                   EVAL      DACTAX = AXETXS
      *
     C                   Z-ADD     TITOUT        WUtiL
     C                   Z-ADD     TIUTTH        WUthR
     C*****TICUTH        DIV       WwMult        WCexT                                      BUG22755
     C                   Z-ADD     TICUTH        WCexT                                      BUG22755
     C                   Z-ADD     TIGSIN        WGint                                      BUG23732
     C                   Z-ADD     TITTAX        WTtax                                      BUG23732
      *
      ** Access Country Codes                                                               CER048A
      *                                                                                     CER048A
     C                   CALL      'AOCTRYR0'                                               CER048A
     C                   PARM      *BLANKS       PRtcd                                      CER048A
     C                   PARM      '*KEY'        POptn                                      CER048A
     C                   PARM      DVCNCD        PCnCd                                      CER048A
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      CER048A
      *                                                                                     CER048A
     C                   IF        PRtcd <> *BLANKS                                         CER048A
      *                                                                                     CER048A
     C     *LOCK         IN        LDA                                                      CER048A
     C                   EVAL      DBKEY = PCnCd                                            CER048A
     C                   EVAL      DBFILE = 'SDCTRYPD'                                      CER048A
     C                   Z-ADD     010           DBASE                                      CER048A
     C                   OUT       LDA                                                      CER048A
     C                   EXSR      *PSSR                                                    CER048A
      *                                                                                     CER048A
     C                   ENDIF                                                              CER048A
      *                                                                                     CER048A
      ** Get Current Threshold out of History File
      *
     C                   MOVE      WWYeaR        WkYr2                                     BUG24280A
     C**********         MOVE      WWYeaR        WYr                                        CER048A
     C**********'3112'        CAT       WYr           WHstDt                                CER048A
     C**********         MOVE      WHstDt        PDateIn                                    CER048A
      *
     C                   IF        A4ETXY = *ZEROS                                          CER048A
     C                   IF        BJDFIN = 'M'                                             CER048A
      *                                                                                     CER048A
     C                   EVAL      PDateIn = '1231' +                                       CER048A
     C**********                              %SUBST(BJMRDT:6:2)                   CER048A BUG24280A
     C                                        WkYr2                                        BUG24280A
     C                   ELSE                                                               CER048A
     C                   EVAL      PDateIn = '3112' +                                       CER048A
     C**********                              %SUBST(BJMRDT:6:2)                   CER048A BUG24280A
     C                                        WkYr2                                        BUG24280A
     C                   ENDIF                                                              CER048A
      *                                                                                     CER048A
     C                   ELSE                                                               CER048A
     C                   EVAL      PDateIn = %CHAR(A4ETXY) +                                CER048A
     C**********                              %SUBST(BJMRDT:6:2)                   CER048A BUG24280A
     C                                        WkYr2                                        BUG24280A
     C                   ENDIF                                                              CER048A
      *                                                                                     CER048A
     C                   EXSR      SRZDate1
      *
     C                   EVAL      SCUSTA = DDCUST
     C                   Z-ADD     *HIVAL        WActDt
      *
     C     KLThRs        SETLL     SDTHRHL3                           40
      *
     C                   READ      SDTHRHL3
     C                   IF        *IN40 = *OFF
     C                              AND WWYeaR = WWYr2                                    BUG24280A
      *
     C                   DOW       TECUST = SCUSTA
     C                             AND NOT %EOF(SDTHRHL3)                                   BUG24579
      *
     C                   IF        PDayNoOut <=  TETRMD AND
     C                             PDayNoOut >= TETRVD
     C                   Z-ADD     TECEXT        WCexT
     C                   GOTO      NXTCU1
     C                   ENDIF
      *
     C                   IF        PDayNoOut >= TETRVD AND
     C                             TETRMD = 0
     C                   Z-ADD     TECEXT        WCexT
     C                   GOTO      NXTCU1
     C                   ENDIF
      *
     C                   READ      SDTHRHL3
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     NXTCU1        TAG
      *
     C                   Z-ADD     WUtiL         WTutIL
     C                   Z-ADD     WUthR         WTuthR
     C                   Z-ADD     WCexT         WTcexT
     C                   Z-ADD     WGint         WTgint                                     BUG23732
     C                   Z-ADD     WTtax         WTttax                                     BUG23732
      *
     C                   MOVE      'J'           PZeCode
     C                   Z-ADD     0             PZDecs
     C                   Z-ADD     WCexT         PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DACEXT
      *
     C                   IF        A4JAMG <> '3' AND                                        BUG26992
     C                             E5JATP = 'Y'                                             BUG26992
      *                                                                                     BUG26992
     C                   MOVE      CDP(1)        PZDecs                                     BUG26992
     C                   Z-ADD     0             PZFld15                                    BUG26992
     C                   EXSR      SRZsEdit                                                 BUG26992
     C                   MOVE      PZout21       DAUTHR                                     BUG26992
     C                   MOVE      PZout21       DAGINT                                     BUG26992
     C                   MOVE      PZout21       DATTAX                                     BUG26992
     C                   MOVE      PZout21       DAUTIL                                     BUG26992
     C                   ELSE                                                               BUG26992
      *                                                                                     BUG26992
     C                   MOVE      CDP(1)        PZDecs
     C                   Z-ADD     WUtiL         PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DAUTIL
      *
     C                   Z-ADD     WUthR         PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DAUTHR
      *                                                                                     BUG23732
     C                   Z-ADD     WGint         PZFld15                                    BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   MOVE      PZout21       DAGINT                                     BUG23732
      *                                                                                     BUG23732
     C                   Z-ADD     WTtax         PZFld15                                    BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   MOVE      PZout21       DATTAX                                     BUG23732
      *                                                                                     BUG26992
     C                   ENDIF                                                              BUG26992
      *
     C                   EVAL      FDFMT2 = '1'
     C                   EVAL      SflRrn1 = SflRrn1 +1
      *
     C                   IF        FDFMT2 = '1'
     C                   WRITE     SD000796S5
     C                   ENDIF
      *
      ** If customer with tax type 'T' and with join reference
      *
     C                   IF        E5JATP = 'Y' AND
     C**********                   AXETXS = 'T'                                               CER069
     C                             (AXETXS = 'T' or AXETXS = 'Y')                             CER069
      *                                                                                     BUG26992
     C                   EVAL      DC5TXT1 = 'Customer/Member'                              BUG26992
      *
      ** Retrieve the history file if exist
      *
     C                   IF        WWYeaR <> WWYr2
     C     WOvrV1        CAT       WTesTY        WWCmd
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    WWCmd
     C**********         PARM      30            WWLen                                      BUG24935
     C                   PARM      40            WWLen                                      BUG24935
     C                   ENDIF
      *
     C                   IF        *IN60 = *OFF
     C                   OPEN      SDINPHL1
     C                   EVAL      *IN60 = *ON
     C                   ENDIF
      *
      ** Access 'all' Joint Account Member Details for the entered
      ** Customer
      *
     C*****DDCUST        SETLL     SDJACCL4                                                 BUG23732
     C*****DDCUST        READE     SDJACCL4                                                 BUG23732
     C     DDCUST        SETLL     SDJACCLB                                                 BUG23732
     C     DDCUST        READE     SDJACCLB                                                 BUG23732
      *
     C**********         DOW       NOT%EOF(SDJACCL4)                                        BUG23732
     C                   DOW       NOT%EOF(SDJACCLB)                                        BUG23732
      *
      * Only use Customer Number if not blanks.                                             BUG24032
      *                                                                                     BUG24032
     C                   IF        JCCUST <> *BLANKS                                        BUG24032
      *                                                                                     BUG24032
     C**********         EVAL      DACNUM = JCJANO                                          BUG23732
     C**********         EVAL      DMACNM = JCJANO                                          BUG23732
     C                   EVAL      DACNUM = JCCUST                                          BUG23732
     C                   EVAL      DMACNM = JCCUST                                          BUG23732
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DACNUM        PCnum
     C                   PARM                    PCnst
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     009           DBASE
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCnum
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      DACRNM = BBCRNM
      *
      ** Retrieve  Location Code
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBBRCD        PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     007           DBASE
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBrch
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Country Code
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8LCCD        PLocn
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     008           DBASE
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBKEY = PLocn
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up Key to access Customer Details by Country of Tax
      *
     C                   EVAL      KFCust = DACNUM
     C                   EVAL      KFCTxCd = DVCNCD
      *
     C     KLAcTx        CHAIN     SDACTXL1
      *
     C                   IF        NOT %FOUND(SDACTXL1)
      *
     C******LOCK         IN        LDA                                                      BUG23732
     C**********         Z-ADD     004           DBASE                                      BUG23732
     C**********         EVAL      DBFILE = 'SDACTXL1'                                      BUG23732
     C**********         EVAL      DBKEY = DACNUM                                           BUG23732
     C**********         EVAL      DBPGM = 'SD000796'                                       BUG23732
     C**********         EVAL      *INU7 = *ON                                              BUG23732
     C**********         EVAL      *INU8 = *ON                                              BUG23732
     C**********         OUT       LDA                                                      BUG23732
     C**********         EXSR      *PSSR                                                    BUG23732
     C     DDCUST        READE     SDJACCLB                                                 BUG23732
     C                   ITER                                                               BUG23732
      *
     C                   ELSE
     C                   EVAL      DACTAX = AXETXS
      *
     C                   ENDIF
      *
      ** Access Interest Payment History Details for the Customer
      *
     C     DACNUM        CHAIN     SDINPHL1
      *
     C                   IF        %FOUND(SDINPHL1)
     C                   Z-ADD     TITOUT        WUtiL
     C                   Z-ADD     TIUTTH        WUthR
     C*****TICUTH        DIV       WwMult        WCexT                                      BUG22755
     C                   Z-ADD     TICUTH        WCexT                                      BUG22755
     C                   Z-ADD     TIGSIN        WGint                                      BUG23732
     C                   Z-ADD     TITTAX        WTtax                                      BUG23732
     C                   ENDIF
      *
      ** Get Current Threshold out of History File
      *
     C                   EVAL      SCUSTA = DACNUM
     C                   Z-ADD     *HIVAL        WActDt
      *
     C     KLThRs        SETLL     SDTHRHL3                           40
     C                   READ      SDTHRHL3                               40
      *
     C                   IF        *IN40 = *OFF
     C                              AND WWYeaR = WWYr2                                    BUG24280A
      *
     C                   DOW       TECUST = SCUSTA
     C                             AND NOT %EOF(SDTHRHL3)                                   BUG24579
      *
     C                   IF        PDayNoOut <=  TETRMD AND
     C                             PDayNoOut >= TETRVD
     C                   Z-ADD     TECEXT        WCexT
     C                   GOTO      NXTCU2
     C                   ENDIF
      *
     C                   IF        PDayNoOut >= TETRVD AND
     C                             TETRMD = 0
     C                   Z-ADD     TECEXT        WCexT
     C                   GOTO      NXTCU2
     C                   ENDIF
      *
     C                   READ      SDTHRHL3                               40
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     NXTCU2        TAG
      *
     C                   EVAL      WTutIL = WTutIL + WUtiL
     C                   EVAL      WTuthR = WTuthR + WUthR
     C                   EVAL      WTcexT = WTcexT + WCexT
     C                   EVAL      WTgint = WTgint + WGint                                  BUG23732
     C                   EVAL      WTttax = WTttax + WTtax                                  BUG23732
      *
     C                   MOVE      'J'           PZeCode
     C                   Z-ADD     0             PZDecs
     C                   Z-ADD     WCexT         PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DACEXT
      *
     C                   MOVE      CDP(1)        PZDecs
     C                   Z-ADD     WUtiL         PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DAUTIL
      *
     C                   Z-ADD     WUthR         PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DAUTHR
      *                                                                                     BUG23732
     C                   Z-ADD     WGint         PZFld15                                    BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   MOVE      PZout21       DAGINT                                     BUG23732
      *                                                                                     BUG23732
     C                   Z-ADD     WTtax         PZFld15                                    BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   MOVE      PZout21       DATTAX                                     BUG23732
      *
     C                   EVAL      SflRrn1 = SflRrn1 +1
      *
     C                   IF        FDFMT2 = '1'
     C                   WRITE     SD000796S5
     C                   ENDIF
      *
     C                   ELSE                                                               BUG26992
      ** Populate table with NAHO members                                                   BUG26992
     C**********         IF        A4JAMG <> '3'                                   BUG26992 AR745790
     C                   IF        A4JAMG <> '3'                                           AR745790A
     C                   EXSR      SRRTNAHD                                                 BUG26992
     C                   ENDIF                                                             AR745790A
     C**********         ENDIF                                                     BUG26992 AR745790
      *
     C                   ENDIF                                                              BUG24032
                                                                                            BUG24032
     C*****DDCUST        READE     SDJACCL4                                                 BUG23732
     C     DDCUST        READE     SDJACCLB                                                 BUG23732
     C                   ENDDO
      *
      ** Close history files
      *
     C                   IF        *IN60 = *ON
     C                   CLOSE     SDINPHL1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   IF        WWYeaR <> WWYr2
     C                   EVAL      WWCmd = WDlovr
     C                   CALL      'QCMDEXC'
     C                   PARM                    WWCmd
     C**********         PARM      30            WWLen                                      BUG24935
     C                   PARM      40            WWLen                                      BUG24935
     C                   ENDIF
      *                                                                                     BUG26992
     C                   ELSE                                                               BUG26992
     C                   EVAL      DC5TXT1 = 'Customer'                                     BUG26992
      *
     C                   ENDIF
      *
     C                   MOVE      'J'           PZeCode
     C                   Z-ADD     0             PZDecs
     C                   Z-ADD     WTcexT        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DSCEXT
      *
     C                   MOVE      CDP(1)        PZDecs
     C                   Z-ADD     WTutIL        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DSUTIL
      *
     C                   Z-ADD     WTuthR        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DSUTHR
      *                                                                                     BUG23732
     C                   Z-ADD     WTgint        PZFld15                                    BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   MOVE      PZout21       DSGINT                                     BUG23732
      *                                                                                     BUG23732
     C                   Z-ADD     WTttax        PZFld15                                    BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   MOVE      PZout21       DSTTAX                                     BUG23732
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load DB --> SD000796S1                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRZDate2, SRZsEdit                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadSfl     BEGSR
      *
      ** Clear SFL
      *
     C                   EVAL      *IN31 = *ON
     C                   WRITE     SD000796C1
     C                   EVAL      *IN31 = *OFF
     C                   Z-ADD     0             SflRrn
     C                   EVAL      DSEL = ' '
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      DPC = *IN33
      *                                                                                     BUG26715
      ** Clear Customer array                                                               BUG26715
      *                                                                                     BUG26715
     C                   CLEAR                   ArrCus                                     BUG26715
     C                   CLEAR                   ArrNAH                                     BUG26992
      *
      ** Retrieve the history file
      *
     C                   OPEN      SDCSINL2
     C                   OPEN      SDCSINL3                                                 BUG26992
      *
     C                   EVAL      WIdx = 1
     C                   EVAL      ArrCus(WIdx) = DDCUST
      *
     C                   IF        DAJATP = 'Y'
      *
     C*****DDCUST        SETLL     SDJACCL4                                                 BUG23732
     C*****DDCUST        READE     SDJACCL4                                                 BUG23732
     C     DDCUST        SETLL     SDJACCLB                                                 BUG23732
     C     DDCUST        READE     SDJACCLB
      *
     C**********         DOU       %EOF(SDJACCL4)                                           BUG23732
     C                   DOU       %EOF(SDJACCLB)                                           BUG23732
     C                   EVAL      WIdx = WIdx + 1
     C**********         EVAL      ArrCus(WIdx) = JCJANO                                    BUG23732
     C                   EVAL      ArrCus(WIdx) = JCCUST                                    BUG23732
      *                                                                                     BUG26992
     C                   EVAL      ArrNAH(WiDx) = JCNAHO                                    BUG26992
      *                                                                                     BUG26992
     C*****DDCUST        READE     SDJACCL4                                                 BUG23732
     C     DDCUST        READE     SDJACCLB                                                 BUG23732
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Load SFL
      ***Aufsetzen/Erstlesen*taxable*interest*payments                                      BUG23308
      ** Touch down/Erstlesen taxable interest payments                                     BUG23308
      *
     C                   EVAL      WIdx = 1
     C                   DOW       ArrCus(WIdx) <> *BLANKS
     C                             OR ArrNAH(WIdx) <> *BLANKS                               BUG26992
      *                                                                                     BUG26992
     C                   IF        ArrCus(WIdx) <> *BLANKS                                  BUG26992
     C     ArrCus(WIdx)  CHAIN     SDCSINL2                           90
     C                   ELSE                                                               BUG26992
     C     ArrNAH(WIdx)  CHAIN     SDCSINL3                           90
     C                   ENDIF                                                              BUG26992
      *                                                                                     BUG26992
      *
      ***Alle*Sätze*lesen*while*Not_EOK                                                     BUG23308
      ** Read all records while NOT_EOK                                                     BUG23308
      *
     C                   DOW       *IN90 = *OFF
      *
     C                   IF        TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear                                         BUG24280
      *                                                                                     BUG24280
      ***Felder*aufbereiten*und*in*SFL*schreiben                                            BUG23308
      ** Prepare the fields and write in SFL                                                BUG23308
      ** - ACCOUNT NO. .... +
      ** - + oder DEAL//... "ADJUST"
      ** Iif Deal No.=0:
      *
     C                   IF        TSDLLN = *ZEROS  AND
     C                             (TSACOD = *ZEROS OR TSACSQ = *ZEROS)
      *
     C                   EVAL      DA018 = *BLANKS
      *
      ** If manual flag= Y : "CNUM CCY ADJUST"
      *
     C                   IF        TSMODI = 'M'
     C                   EVAL      DALBL1 = 'Customer - Currency CODE'                      BUG23308
     C                   EVAL      DA018 = *BLANKS
     C                   EVAL      DA018 = TICUST
     C     DA018         CAT       TSOCCY:1      DA018
     C     DA018         CAT       'ADJUST':1    DA018
     C                   ENDIF
      *
     C                   IF        TSDLLN = *ZEROS  AND
     C                             (TSACOD = *ZEROS OR TSACSQ = *ZEROS)
     C                   EVAL      DALBL1 = 'Customer - Currency CODE'                      BUG23308
     C                   EVAL      DA018 = *BLANKS
     C                   EVAL      DA018 = TICUST
     C     DA018         CAT       '-':0         DA018
     C     DA018         CAT       TSOCCY:0      DA018
      *
     C                   IF        TSMODI = 'M'
     C     DA018         CAT       'ADJUST':1    DA018
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Else: "CNUM-CCY-acc.code-acc.sequence"
      *
     C                   ELSE
      *
     C                   IF        TSCUST <> *BLANKS                                        BUG26992
      *                                                                                     BUG26992
     C                   EVAL      PpCnum = TSCUST
     C                   EVAL      PpCucD = TSOCCY
     C                   EVAL      PpBrcA = TSBRCA
     C                   MOVE      TSACOD        PpAccD
     C                   MOVE      TSACSQ        PpAcsQ
     C                   EVAL      PpRetL = *BLANKS
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PpRetL
     C                   PARM                    PpCnum
     C                   PARM                    PpCucD
     C                   PARM                    PpAccD
     C                   PARM                    PpAcsQ
     C                   PARM                    PpBrcA
     C     ACCNT         PARM      ACCNT         DSSDY
      *
     C                   IF        PRtcd = *BLANKS
      *
     C                   IF        TSRDNB > DACO AND
     C                             TSRDNB <= DACC OR
     C                             TSRDNB > DACO  AND
     C                             DACC = *ZEROS
      *
     C                   SELECT                                                            BUG23120B
     C                   WHEN      ACNO = *ZEROS                                           BUG23120B
     C                   EVAL      DALBL1 = 'Customer-Ccy-Acod-Acsq'                        BUG23308
     C                   EVAL      DA018 = *BLANKS
     C                   MOVEL     CNUM          DA018
     C     DA018         CAT       '-':0         DA018
     C     DA018         CAT       CCY:0         DA018
     C     DA018         CAT       '-':0         DA018
     C**********         MOVEL     ACOD          D004                                       BUG23308
      **********                                                                 BUG23120A BUG23120B
     C**********         IF        ACNO = *ZEROS                                 BUG23120A BUG23120B
     C                   MOVEL     ACOD          D010                                       BUG23308
     C**********         ELSE                                                    BUG23120A BUG23120B
     C**********         MOVEL     ACNO          D010                            BUG23120A BUG23120B
     C**********         ENDIF                                                   BUG23120A BUG23120B
      **********                                                                 BUG23120A BUG23120B
     C                   MOVEL     ACSQ          D002
     C*****DA018         CAT       D004:0        DA018                                      BUG23308
     C     DA018         CAT       D010:0        DA018                                      BUG23308
     C     DA018         CAT       '-':0         DA018
     C     DA018         CAT       D002:0        DA018
      *                                                                                    BUG23120B
     C                   OTHER                                                             BUG23120B
     C                   EVAL      DALBL1 = 'Retail number - Currency'                     BUG23120B
     C                   EVAL      DA018 =  %EDITC(ACNO:'X') + ' ' + CCY                   BUG23120B
     C                   ENDSL                                                             BUG23120B
      *                                                                                    BUG23120B
     C                   ELSE
     C                   EVAL      DALBL1 = 'Customer - Currency CODE'                      BUG23308
     C                   EVAL      DA018 = *BLANKS
     C                   EVAL      DA018 = TSCUST
     C     DA018         CAT       '-':0         DA018
     C     DA018         CAT       TSOCCY:0      DA018
     C                   ENDIF
      *                                                                                     BUG24018
     C                   Z-ADD     *ZERO         IARATE           11 7                      BUG24018
     C                   Z-ADD     *ZERO         IBRATE           11 7                      BUG24018
     C                   Z-ADD     *ZERO         ICRATE           11 7                      BUG24018
      *
     C                   IF        LDBL <> *ZERO                                           BUG24018A
      * Account rate                                                                        BUG24018
     C                   Z-ADD     *ZERO         IDCBR             2 0                      BUG24018
     C                   MOVE      TSOCCY        @AJCD                                      BUG24018
     C**********         IF        LDBL < 0                                       BUG24018 BUG24018A
     C                   IF        LDBL > 0                                                BUG24018A
     C                   ADD       DRIS          IARATE                                     BUG24018
     C                   Z-ADD     DRIB          IDCBR                                      BUG24018
     C                   ELSE                                                               BUG24018
     C                   ADD       CRIS          IARATE                                     BUG24018
     C                   Z-ADD     CRIB          IDCBR                                      BUG24018
     C                   ENDIF                                                              BUG24018
      * Base Rate                                                                           BUG24018
     C                   IF        IDCBR > *ZERO                                            BUG24018
     C                   MOVE      IDCBR         @DWND                                      BUG24018
     C                   EXSR      SRGetBsrt                                                BUG24018
     C                   ADD       BACBSR        IARATE                                     BUG24018
     C                   IF        IARATE < *ZERO                                           BUG24018
     C                   Z-ADD     *ZERO         IARATE                                     BUG24018
     C                   ENDIF                                                              BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                     BUG24018
     C                   MOVE      *BLANKS       @DWND                                      BUG24018
      *                                                                                     BUG24018
     C                   IF        TSMODI = 'G'                                             BUG24018
     C**********         MOVE      TSCUST        CCNUM             6 0               BUG24018 CER059
     C                   MOVE      TSCUST        CCNUM             6                          CER059
      * Interest type                                                                       BUG24018
     C     R1Key         CHAIN     ACCRACJ                                                  BUG24018
     C                   IF        %FOUND(ACCRACJ)                                          BUG24018
      ** Check for interest type                                                            BUG24018
     C                   MOVE      TSOCCY        R2CCY                                      BUG24018
     C                   MOVE      'D'           R2REC                                      BUG24018
     C                   MOVE      *BLANKS       @DWND                                      BUG24018
     C**********         IF        LDBL < 0                                       BUG24018 BUG24018A
     C                   IF        LDBL > 0                                                BUG24018A
     C                   MOVE      DICT          R2TYP                                      BUG24018
     C                   MOVE      DCST          R2STP                                      BUG24018
     C                   ELSE                                                               BUG24018
     C                   MOVE      CICT          R2TYP                                      BUG24018
     C                   MOVE      CCST          R2STP                                      BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                     BUG24018
     C     R2KEY         CHAIN     REINT                                                    BUG24018
     C                   IF        %FOUND(REINT)                                            BUG24018
     C                   IF        R2RAT(1) > *ZERO                                         BUG24018
     C                   Z-ADD     2             RCNTR             2 0                      BUG24018
     C                   IF        BRT > *ZERO                                              BUG24018
     C                   MOVE      R2CCY         @AJCD                                      BUG24018
     C                   MOVE      BRT           @DWND                                      BUG24018
     C                   EXSR      SRGetBsrt                                                BUG24018
     C                   Z-ADD     BACBSR        IBRATE                                     BUG24018
     C                   ENDIF                                                              BUG24018
     C                   Z-ADD     R2RAT(1)      ICRATE                                     BUG24018
     C                   DOW       RCNTR <= 11                                              BUG24018
     c                             AND R2BAL(RCNTR) <> *ZERO                                BUG24018
     C                             AND LDBL >= R2BAL(RCNTR)                                 BUG24018
     C                   EVAL      ICRATE = R2RAT(RCNTR)                                    BUG24018
     C                   ADD       1             RCNTR                                      BUG24018
     C                   ENDDO                                                              BUG24018
     C                   EVAL      IBRATE = IBRATE + ICRATE                                 BUG24018
     C                   IF        IBRATE < *ZERO                                           BUG24018
     C                   Z-ADD     *ZERO         IBRATE                                     BUG24018
     C                   ENDIF                                                              BUG24018
     C                   ENDIF                                                              BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                     BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                     BUG24018
     C     IARATE        ADD       IBRATE        IARATE                                     BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                    BUG24018A
     C                   ENDIF                                                             BUG24018A
      *                                                                                     BUG24018
     C                   EVAL      @@AMTW  = IARATE * 10000000                              BUG24018
      *                                                                                     BUG24018
     C                   EXSR      SRZCvtRte                                                BUG24018
     C                   MOVE      @@AMTD        D2RATE                                     BUG24018
      *                                                                                     BUG24018
     C                   ELSE
      *
      ** Else deal No.><0:   "dealno CCY"
      *
     C                   EVAL      DALBL1 = 'Deal number - Currency'                        BUG23308
     C                   EVAL      DA018 = *BLANKS
     C**********         EVAL      DA018 = %CHAR(TSDLLN) + '  ' +                           BUG23308
     C                   MOVEL     TSDLLN        WDlnum                                     BUG23308
     C                   EVAL      DA018 = WDLnum + '  ' +                                  BUG23308
     C                                    TSOCCY
      *
      ** If joinref =blanks: "dealno CCY"
      ** else: "dealno CCY CNUM"
      *
     C                   IF        DAJATP = 'Y'
     C                   EVAL      DALBL1 = 'Deal-Currency-Customer'                        BUG23308
     C**********         EVAL      DA018 = DA018 + '  ' + TSCUST                            BUG23308
     C                   EVAL      DA018 = %TRIM(DA018) + '  ' + TSCUST                     BUG23308
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     BUG26992
     C                   ELSE                                                               BUG26992
      *                                                                                     BUG26992
     C                   MOVE      '000000'      WDLLN             6                        BUG26992
     C                   MOVE      TSDLLN        WDLLN                                      BUG26992
     C                   IF        TSDLLN <> 0                                              BUG26992
     C                   EVAL      DALBL1 = 'Deal - Currency - NAH'                         BUG26992
     C                   EVAL      DA018 = WDLLN + ' ' + TSOCCY + ' ' +                     BUG26992
     C                                     %TRIM(TSNAHO)                                    BUG26992
     C                   ELSE                                                               BUG26992
     C                   EVAL      DALBL1 = 'Non Account Holder - Currency'                 BUG26992
     C                   EVAL      DA018 = %TRIM(TSNAHO) + ' ' +                            BUG26992
     C                                     TSOCCY                                           BUG26992
     C                   ENDIF                                                              BUG26992
      *                                                                                     BUG26992
     C                   ENDIF                                                              BUG26992
      *
     C                   ENDIF
      *
      ** - Posting Date .... +
      ***-*....*Datum*umrechnen*(P5.0*-->*S6.0)*+                                           BUG23308
      ** - .... Date conversion (P5.0 --> S6.0) +                                           BUG23308
      *
     C                   EVAL      PZDayNo2 = TSRDNB
     C                   EXSR      SRZDate2
     C**********         Z-ADD     PZDate        DPDT                                       BUG23308
     C                   EVAL      DPDT = PZADate                                           BUG23308
      *
      ** - If manual flag= Y or retro flag= Y: interest date= +
      ** +  KEINTD
      *
     C                   IF        TSMODI = 'M'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      DND2D = *IN43
     C**********         IF        BJDFIN = 'M'                                             BUG23308
     C**********         EVAL      %SUBST(WD1Dat:1:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:5:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD1Dat:3:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:7:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD1Dat:5:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:3:2)                                       BUG23308
     C**********         ELSE                                                               BUG23308
     C**********         EVAL      %SUBST(WD1Dat:1:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:7:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD1Dat:3:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:5:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD1Dat:5:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:3:2)                                       BUG23308
     C**********         ENDIF                                                              BUG23308
      *
     C                   EXSR      SRZDate10                                                BUG23308
     C                   EXSR      SRZDate2                                                 BUG23308
     C                   EVAL      D1DAT = PZADate                                          BUG23308
     C**********         MOVE      WD1Dat        D1DAT                             BUG23307 BUG23308
      *                                                                                     BUG23307
     C                   ELSE
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      DND2D = *IN43
      *
      ** - else: interest period +
      ***....*von*datum*umrechnen*(P5.0*-->*S6.0)                                          BUG23308
      ** .... convert from date (P5.0 --> S6.0)                                            BUG23308
      *
     C**********         Z-ADD     TSRDNB        PZDayNo2                                  BUG23307A
     C                   Z-ADD     TSSLID        PZDayNo2                                  BUG23307A
     C                   EXSR      SRZDate2
     C**********         Z-ADD     PZDate        D1DAT                                      BUG23308
     C                   EVAL      D1DAT = PZADate                                          BUG23308
      *
      ***....*bis*Datum*umrechnen*(P5.0*-->*S6.0)                                           BUG23308
      ** .... To date converter (P5.0 --> S6.0)                                             BUG23308
      *
     C**********         IF        BJDFIN = 'M'                                             BUG23308
     C**********         EVAL      %SUBST(WD2Dat:1:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:5:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD2Dat:3:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:7:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD2Dat:5:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:3:2)                                       BUG23308
     C**********         ELSE                                                               BUG23308
     C**********         EVAL      %SUBST(WD2Dat:1:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:7:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD2Dat:3:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:5:2)                                       BUG23308
     C**********         EVAL      %SUBST(WD2Dat:5:2) =                                     BUG23308
     C**********                   %SUBST(TSIPDT:3:2)                                       BUG23308
     C**********         ENDIF                                                              BUG23308
     C                   EXSR      SRZDate10                                                BUG23308
     C                   EXSR      SRZDate2                                                 BUG23308
     C                   EVAL      D2DAT = PZADate                                          BUG23308
      **********                                                                   BUG23307 BUG23308
     C**********         MOVE      WD2Dat        D2DAT                             BUG23307 BUG23308
      *                                                                                     BUG23307
     C                   ENDIF
      *
      ***Editcode*für*beträge                                                               BUG23308
      ** Editcode for amounts                                                               BUG23308
      *
     C                   EVAL      PZeCode = 'J'
      *
      ***Anzahl*dezimalstellen*feststellen                                                  BUG23308
      ** Determine the Number of decimal places                                             BUG23308
      *
     C                   MOVE      TSOCCY        KDCCY
     C                   Z-ADD     1             IM
     C     KDCCY         LOOKUP    CCD(IM)                                90
      *
     C     *IN90         CASEQ     '0'           SRCurr
     C                   END
     C                   MOVE      CDP(IM)       PZDecs
      *
      ** - Net interest in CCY / DM
      *
     C                   IF        TSMODI <> 'M'
     C                   Z-ADD     TSNINT        PZFld15
     C                   Z-ADD     TSNINC        D2NIND
     C                   ENDIF
      *
      ***Betrag*aufbereiten                                                                 BUG23308
      ** Prepare the amount                                                                 BUG23308
      *
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDNINC
      *
      ***-*Solid*zuschlag*in*CCY*/*DM                                                       BUG23308
      ** - Additional amount in CCY / DM                                                    BUG23308
      *
     C                   IF        TSMODI <> 'M'
     C                   Z-ADD     TSSTDO        D2SOZC
     C                   Z-ADD     TSSTDT        D2SOZD
     C                   IF        CER054 = 'Y'                                               CER054
     C                   Z-ADD     TSTTDO        D2THTC                                       CER054
     C                   Z-ADD     TSTTDT        D2THTD                                       CER054
     C                   ENDIF                                                                CER054
      *
     C                   ELSE
     C                   Z-ADD     0             D2SOZC
     C                   Z-ADD     0             D2SOZD
     C                   IF        CER054 = 'Y'                                               CER054
     C                   Z-ADD     0             D2THTC                                       CER054
     C                   Z-ADD     0             D2THTD                                       CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF
      *
      ** - Adjustment type
      *
     C                   EVAL      DDFLAG = *BLANKS
     C     TSDLLN        CHAIN     DEALS
      *                                                                                     BUG24018
     C                   IF        TSDLLN > *ZEROS                                          BUG24018
      *                                                                                     BUG24018
     C                   IF        BRTT <> 0                                                BUG24018
     C                   EVAL      @@AMTW  = (BRTE + RTSP) * 10000000                       BUG24018
     C                   ELSE                                                               BUG24018
     C                   EVAL      @@AMTW  = RTSP * 10000000                                BUG24018
     C                   ENDIF                                                              BUG24018
     C                   EXSR      SRZCvtRte                                                BUG24018
     C                   MOVE      @@AMTD        D2RATE                                     BUG24018
      *                                                                                     BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                     BUG24018
      ** If Tax value at Account level is 'A', this means the EU Tax                          CER069
      ** indicator at Customer level should be used to determine whether                      CER069
      ** the account is taxable.                                                              CER069
                                                                                              CER069
     C     TAXI          IFEQ      'A'                                                        CER069
                                                                                              CER069
     C                   EXSR      SRACTX                                                     CER069
                                                                                              CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   IF        TAXI = 'T'
     C                   EVAL      DDFLAG = 'T'
     C                   ENDIF
     C                   IF        TAXI = 'Y'
     C                   EVAL      DDFLAG = 'Y'
     C                   ENDIF
     C                   IF        TAXI = 'N'
     C                   EVAL      DDFLAG = 'N'
     C                   ENDIF
     C                   IF        TSMODI = 'G'
     C                   EVAL      DDFLAG = 'S'
     C                   ENDIF
     C                   IF        TSMODI = 'M'
     C                   EVAL      DDFLAG = 'M'
     C                   ENDIF
      *
      ** - Reversed deal DFRVIN
      ** - Gross interest in CCY / DM
      ** - Tax deducted in CCY / DM
      *
     C                   IF        TSMODI <> 'M'
     C                   Z-ADD     TSGINT        D2GINC
     C                   Z-ADD     TSGINC        D2GIND
     C                   Z-ADD     TSTXSR        D2TXDC
     C                   Z-ADD     TSTXSC        D2TXDD
     C                   ELSE
     C                   Z-ADD     *ZEROS        D2GINC
     C                   Z-ADD     *ZEROS        D2GIND
     C                   Z-ADD     *ZEROS        D2TXDC
     C                   Z-ADD     *ZEROS        D2TXDD
     C                   ENDIF
      *
      ** - Threshold adjustment
      *
     C                   Z-ADD     *ZEROS        D2TADC
     C                   Z-ADD     *ZEROS        D2TADD
      *
     C                   IF        TSMODI = 'M'
     C                   Z-ADD     *ZEROS        D2TADD
     C                   ENDIF
      *
      ** --> SD000796S1 schreiben                                                           BUG23308
      ** --> Write to SD000796S1                                                            BUG23308
      *
     C                   EVAL      SflRrn = SflRrn + 1
     C                   WRITE     SD000796S1
      *
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
      ***Nachlesen:                                                                         BUG23308
      ** Read                                                                               BUG23308
      *
     C                   IF        ArrCus(WIdx) <> *BLANKS                                  BUG26992
     C     ArrCus(WIdx)  READE     SDCSIND0                               90                BUG23306
      *                                                                                     BUG23306
     C                   ELSE                                                               BUG26992
     C     ArrNAH(WIdx)  READE     SDCSINR3                               90                BUG26992
     C                   ENDIF                                                              BUG26992
      *                                                                                     BUG26992
     C                   ENDDO
      *
     C                   EVAL      WIdx = WIdx + 1
     C*****ArrCus(WIdx)  READE     SDCSIND0                               90                BUG23306
      *
     C                   ENDDO
      *
      ***Anzahl*SFL-Sätze                                                                   BUG23308
      ** SFL record number                                                                  BUG23308
      *
     C                   Z-ADD     SflRrn        WSflNz
      *
      ** N32: SFLDSP, SFLEND
      *
     C     WSflNz        COMP      0                                    3232
      *
      ***SFL-seite*mit*dem*1.*satz*anzeigen                                                 BUG23308
      ** SFL page with the record details                                                   BUG23308
      *
     C                   Z-ADD     1             DSFLPO
      *
      ** Close file
      *
     C                   CLOSE     SDCSINL2
     C                   CLOSE     SDCSINL3                                                 BUG26992
      *
     C                   IF        WWYeaR <> WWYr2
     C                   EVAL      WWCmd = WDlovr
     C                   CALL      'QCMDEXC'
     C                   PARM                    WWCmd
     C**********         PARM      30            WWLen                                      BUG24935
     C                   PARM      40            WWLen                                      BUG24935
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ***SRCtlFmt*-*SFL-Eingabe*auswerten******************************                     BUG23308
      *  SRCtlFmt - Do-Analyse the Input                              *                     BUG23308
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRF4                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCtlFmt      BEGSR
      *
      ***Alle*SFL-Sätze*mit*auswahl*><*blank*und ....*+                                     BUG23308
      ** DO while all records are selected and                                              BUG23308
      *
     C                   Z-ADD     0             SflRrn
     C                   DOW       SflRrn < WSflNz AND
      *
      ***+*....*solange*(im*Fmt*F4)*N_Eop*&*N_F12:                                          BUG23308
      ** as long as (im Fmt F4) N_Eop & N_F12:                                              BUG23308
      *
     C                             Eop <> '1' AND
     C                             *IN12 <> *ON
      *
     C                   ADD       1             SflRrn
     C     SflRrn        CHAIN     SD000796S1                         90
     C                   IF        DSEL <> *BLANKS OR
     C                             DPC = '1'
      *
      ***If*F05:*refresh*SFL-Auswahl*only                                                   BUG23308
      ***else:*SFL-Auswahl*zum*Anzeigen*der*Details*getroffen!                              BUG23308
      ** If F05: refresh SFL-selection only                                                 BUG23308
      ** else: SFL-Selection to view the details have been taken                            BUG23308
      *
     C  N05DSEL          CASNE     *BLANKS       SRF4
     C                   END
      *
      ***Auswahlfeld*und*PC-indikator*löschen**+                                            BUG23308
      ** Selection field and PC indicator delete                                            BUG23308
      *
     C                   EVAL      DSEL = ' '
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      DPC = *IN33
      *
      ***+*ND*D2DAT*beibehalten!                                                            BUG23308
      ** ND D2DAT retain                                                                    BUG23308
      *
     C                   EVAL      *IN43 = DND2D
     C                   UPDATE    SD000796S1
      *
     C                   ENDIF
     C                   ENDDO
      *
      ***Cursor*auf*den*letzten*verarbeiteten*SFL-Satz*setzen                               BUG23308
      ** Cursor to the last processed record                                                BUG23308
      *
     C                   IF        WAufs1 > 0
     C     WAufs1        CHAIN     SD000796S1                         9091
     C                   EVAL      *IN33 = *ON
     C                   EVAL      DPC = *IN33
     C                   EVAL      *IN43 = DND2D
     C                   UPDATE    SD000796S1                           91
     C                   ENDIF
      *
      ***F12*(vom*Fmt*F4)*zurücksetzen                                                      BUG23308
      ** F12 (of Fmt F4) return                                                             BUG23308
      *
     C                   EVAL      *IN12 = *OFF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      ***SRF4*-*SFL-Satz*-->*Format*F4*********************************                     BUG23308
      *  SRF4 - Do-phrases---> Format F4                              *                     BUG23308
      *                                                               *
      *  Called by: SRCtlFmt                                          *
      *                                                               *
      *  Calls: SRZsEdit, SRZDate1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRF4          BEGSR
      *
      ***mit*letzter*verarbeiteter*Satzauswahl*SFL*positionieren                            BUG23308
      ** position to last processed record selection                                        BUG23308
      *
     C                   Z-ADD     SflRrn        WAufs1
      *
      ***Felder*aufbereiten                                                                 BUG23308
      ** Prepare fields                                                                     BUG23308
      ** - ACCOUNT NO. .... +
      ** - + oder DEAL etc.     DA018
      ** - Posting Date         DPDT
      ** - Adjustment type      DDFLAG
      ** - Reversed             DFRVIN
      *
     C                   EVAL      *IN43 = DND2D
      *                                                                                     BUG23308
      ** CALL access object for Cust Details by Ctry of Tax                                 BUG23308
      ** to retrieve Country of Tax                                                         BUG23308
      *                                                                                     BUG23308
     C                   CALL      'AOCTTXR0'                                               BUG23308
     C                   PARM      *BLANKS       PRtcd                                      BUG23308
     C                   PARM      '*KEY   '     POptn                                      BUG23308
     C                   PARM      DVCNCD        PCtrT                                      BUG23308
     C                   PARM      BBCOLC        PCtrR                                      BUG23308
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      BUG23308
      *                                                                                     BUG23308
     C                   IF        PRtcd <> *BLANKS                                         BUG23308
      *                                                                                     BUG23308
     C                   CALL      'AOCTTXR0'                                               BUG23308
     C                   PARM      *BLANKS       PRtcd                                      BUG23308
     C                   PARM      '*KEY   '     POptn                                      BUG23308
     C                   PARM      DVCNCD        PCtrT                                      BUG23308
     C                   PARM      *BLANKS       PCtrR                                      BUG23308
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      BUG23308
      *                                                                                     BUG23308
     C                   IF        PRtcd <> *BLANKS                                         BUG23308
     C     *LOCK         IN        LDA                                                      BUG23308
     C                   EVAL      DBKEY = DVCNCD                                           BUG23308
     C                   EVAL      DBFILE = 'SDCTTXPD'                                      BUG23308
     C                   EVAL      DBASE = 111                                              BUG23308
     C                   OUT       LDA                                                      BUG23308
     C                   EXSR      *PSSR                                                    BUG23308
     C                   ENDIF                                                              BUG23308
      *                                                                                     BUG23308
     C                   ENDIF                                                              BUG23308
      *                                                                                     BUG23308
      ** Check for Tax/Non Resident or Tax/resident                                         BUG23308
      *                                                                                     BUG23308
     C                   IF        BBCOLC <> EWCTRT                                         BUG23308
     C                   EVAL      *IN45 = *OFF                                             BUG23308
     C                   ELSE                                                               BUG23308
     C                   EVAL      *IN45 = *ON                                              BUG23308
     C                   ENDIF                                                              BUG23308
      *
      ***If ...=1,0:*Non-display*Geldkurs                                                   BUG23308
      ** If ...=1,0: Non-display Rate                                                       BUG23308
      *
     C                   IF        TSTXRT = 1
     C                   Z-ADD     0             TSTXRT
     C                   ENDIF
      *
      ***Editcode*für*beträge                                                               BUG23308
      ** Editcode For amounts                                                               BUG23308
      *
     C                   EVAL      PZeCode = 'J'
      *
      ***Anzahl*dezimalstellen*feststellen                                                  BUG23308
      ** Set Decimal Places                                                                 BUG23308
      *
     C                   MOVE      TSOCCY        KDCCY
     C                   Z-ADD     1             IM
     C     KDCCY         LOOKUP    CCD(IM)                                90
     C     *IN90         CASEQ     '0'           SRCurr
     C                   END
     C                   MOVE      CDP(IM)       PZDecs
      *
      ** - Gross Interest   in CCY
      ** - Taxable Interest in CCY
      ** - Tax deducted     in CCY
      ** - Net Interest     in CCY
      ** - Solid. Zuschl.   in CCY
      ***Beträge*aufbereiten                                                                BUG23308
      ** Prepare Amounts                                                                    BUG23308
      *
     C                   Z-ADD     D2GINC        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDGINC
     C                   Z-ADD     D2TXDC        PZFld15
      *
     C                   IF        D2TXDC = 0 AND
     C                             TSOCCY = BJCYCD
     C                   Z-ADD     D2TXDD        PZFld15
     C                   ENDIF
      *                                                                                     BUG23308
      ** IF Tax/Resident than add the Secondary Tax to Main Tax                             BUG23308
      *                                                                                     BUG23308
     C                   IF        *IN45 = *ON                                              BUG23308
      **********                                                                            BUG23308
     C**********         EXSR      SRZsEdit                                                 BUG23308
     C**********         MOVE      PZout21       DDTXDC                                     BUG23308
      *
      ***DDNINC*Net*Interest*in*CCY*siehe*SFL                                               BUG23308
      ** DDNINC Net Interest in CCY view SFL                                                BUG23308
      *
     C**********         Z-ADD     D2SOZC        PZFld15                                    BUG23308
     C                   ADD       D2SOZC        PZFld15                                    BUG23308
     C                   ADD       D2THTC        PZFld15                                      CER054
      *
     C                   IF        D2SOZC = 0 AND
     C                             TSOCCY = BJCYCD
     C**********         Z-ADD     D2SOZD        PZFld15                                    BUG23308
     C                   ADD       D2SOZD        PZFld15                                    BUG23308
     C                   ADD       D2THTD        PZFld15                                      CER054
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG23308
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDTXDC                                     BUG23308
     C**********         MOVE      PZout21       DDSOZC                                     BUG23308
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   ADD       D2THTC        PZFld15                                      CER054
      *                                                                                       CER054
     C                   IF        D2THTC = *ZEROS                                            CER054
     C                             AND TSOCCY = BJCYCD                                        CER054
     C                   ADD       D2THTD        PZFld15                                      CER054
     C                   EXSR      SRZsEdit                                                   CER054
     C                   MOVE      PZout21       DDTXDC                                       CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER054
      *
     C                   IF        D2TADC < *ZEROS
     C                   Z-ADD     D2TADC        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDTADC
     C                   ELSE
     C**********         MOVE      *BLANKS       DDTADC                                     BUG23308
     C                   Z-ADD     D2TADC        PZFld15                                    BUG23308
     C                   EXSR      SRZsEdit                                                 BUG23308
     C                   MOVE      PZout21       DDTADC                                     BUG23308
     C                   ENDIF
      *
     C                   MOVE      '    '        WFtrTp
      *
      ** - Gross Interest   in DM
      ** - Taxable Interest in DM
      ** - Tax deducted     in DM
      ** - Net Interest     in DM
      *
     C                   EVAL      PZeCode = 'J'
     C                   MOVE      CDP(1)        PZDecs
      *
     C                   IF        *IN43 = *ON
     C                   MOVE      D1DAT         PDateIn
     C                   EXSR      SRZDate1
     C                   MOVEL     PDayNoOut     WTSipdt
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      WTSipdt       PZDayNo
     C                   PARM      *ZEROS        PZDate1
     C                   PARM      *BLANKS       PErrorFlag
      *
     C                   IF        PErrorFlag = '0'
     C                   MOVEL     PZDate1       TSIPDT
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      D2DAT         PDateIn
     C                   EXSR      SRZDate1
     C                   MOVEL     PDayNoOut     WTSipdt
      *
     C                   CALLB     'ZDATE9'
     C                   PARM      WTSipdt       PZDayNo
     C                   PARM      *ZEROS        PZDate1
     C                   PARM      *BLANKS       PErrorFlag
      *
     C                   IF        PErrorFlag = '0'
     C                   MOVEL     PZDate1       TSIPDT
     C                   ENDIF
     C                   ENDIF
      *
      ** If TSOCCY = 'DM': Non-display Base_CCY_equiv.
      ***else:*aufbereiten*mit*EDTCDE(J)*und*anzeigen                                       BUG23308
      ** else: Prepare with EDTCDE(J) and show                                              BUG23308
      *
     C                   IF        TSOCCY = BJCYCD AND
     C                             WTSipdt >= 10959 OR
     C                             TSOCCY = 'DEM' AND
     C                             WTSipdt < 10959
      *
     C                   EVAL      DDGIND = *BLANKS
     C                   EVAL      DDTXDD = *BLANKS
     C                   EVAL      DDNIND = *BLANKS
      *
     C**********         EVAL      DDSOZD = *BLANKS                                         BUG23308
     C                   EVAL      DDTADD = *BLANKS
      *
     C                   ELSE
      *
     C                   Z-ADD     D2GIND        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDGIND
     C                   Z-ADD     D2TXDD        PZFld15
      *                                                                                     BUG23308
      ** IF Tax/Resident than add the Secondary Tax to Main Tax                             BUG23308
      *                                                                                     BUG23308
     C                   IF        *IN45 = *ON                                              BUG23308
     C                   ADD       D2SOZD        PZFld15                                    BUG23308
     C                   IF        CER054 = 'Y'                                               CER054
     C                   ADD       D2THTD        PZFld15                                      CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                              BUG23308
      *                                                                                     BUG23308
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDTXDD
     C                   Z-ADD     D2NIND        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDNIND
      *
     C**********         Z-ADD     D2SOZD        PZFld15                                    BUG23308
     C**********         EXSR      SRZsEdit                                                 BUG23308
     C**********         MOVE      PZout21       DDSOZD                                     BUG23308
      *
     C                   IF        D2TADD < *ZEROS
     C                   Z-ADD     D2TADD        PZFld15
     C                   EXSR      SRZsEdit
     C                   MOVE      PZout21       DDTADD
     C                   ELSE
     C**********         MOVE      *BLANKS       DDTADD                                     BUG23308
     C                   Z-ADD     D2TADD        PZFld15                                    BUG23308
     C                   EXSR      SRZsEdit                                                 BUG23308
     C                   MOVE      PZout21       DDTADD                                     BUG23308
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***Fmt F4*anzeigen,lesen                                                              BUG23308
      ** Fmt F4 Displayed                                                                   BUG23308
      *
     C                   EXFMT     SD000796F5
      *
     C                   IF        *IN03 = *ON
     C                   EVAL      Eop = '1'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurr - Read Currency Decimals  --> FG                      *
      *                                                               *
      *  Called by: SRLoadSfl, SRF4, *INZSR                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCurr        BEGSR
      *
      ** Input: KDCCY currency code
      ***Return:*IM,*CDP(IM)=*cnzahl*dez.stellen (C1!)                                      BUG23308
      ** Return: IM, CDP(IM)= Set Currency Dec.(C1!)                                        BUG23308
      *
     C     *LIKE         DEFINE    BJCYCD        KDCCY
      *
      ** Call access program for currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      KDCCY         PKey1
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   Z-ADD     003           DBASE
     C                   EVAL      DBKEY = KDCCY
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***Store*currency*code*und*dec.places*--> FG                                          BUG23308
      ** Store currency code and dec.places --> FG                                          BUG23308
      ** next free / if none: 10. array element
      *
     C                   Z-ADD     1             IM
     C                   DOW       CCD(IM) <> *BLANKS AND
     C                             IM < 10
     C                   ADD       1             IM
     C                   ENDDO
      *
     C                   MOVE      KDCCY         CCD(IM)
     C                   MOVE      A6NBDP        CDP(IM)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZaSnMs - Send message to program's message queue           *
      *                                                               *
      *  Called by: MAIN Processing, SRValFmt                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZaSnMs      BEGSR
      *
      ** If no message file specified, use the default message file
      *
     C                   IF        PaPgmQ = *BLANKS
     C                   EVAL      PaPgmQ = DDPGM
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PaPgmQ
     C                   PARM                    PaPgrl
     C                   PARM                    PAmsId
     C                   PARM                    PAMsgf
     C                   PARM                    PAMsda
     C                   PARM                    PAMstp
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   EVAL      PaPgmQ = *BLANKS
     C                   EVAL      PaPgrl = *BLANKS
     C                   EVAL      PAMsda = *BLANKS
     C                   EVAL      PAMstp = *BLANKS
     C                   EVAL      PAMsgf = *BLANKS
     C                   EVAL      PAmsId = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Validate & convert date to a day number           *
      *                                                               *
      *  Called by: SRLoadFmt, SRF4                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM                    PDayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert date from file format to screen format    *
      *                                                               *
      *  Called by: SRLoadSfl                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate2      BEGSR
      *
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
      *
     C                   CALL      'ZDATE2'
     C**********         PARM                    PZDayNo                                    BUG23307
     C                   PARM                    PZDayNo2                                   BUG23307
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
      *
     C                   IF        %SUBST(PZADate:1:1) = *BLANKS                            BUG23308
     C                   MOVEL     '0'           PZADate                                    BUG23308
     C                   ENDIF                                                              BUG23308
      *                                                                                     BUG23308
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZsEdit - Convert amount from file format to screen format  *
      *                                                               *
      *  Called by: SRLoadFmt, SRLoadSfl, SRF4                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZsEdit      BEGSR
      *
     C                   CALL      'ZSEDIT'
      *
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM                    PZeCode
     C                   PARM                    PZout21
      *
     C                   ENDSR
      *****************************************************************                     BUG26206
      /EJECT                                                                                BUG26206
      *****************************************************************                     BUG26206
      *                                                               *                     BUG26206
      *  SrCusCtyTx - Retrieve input customers' country of tax        *                     BUG26206
      *                                                               *                     BUG26206
      *  Called by: Main                                              *                     BUG26206
      *                                                               *                     BUG26206
      *  Calls: None                                                  *                     BUG26206
      *                                                               *                     BUG26206
      *****************************************************************                     BUG26206
      *                                                                                     BUG26206
     C     SrCusCtyTx    BEGSR                                                              BUG26206
      *                                                                                     BUG26206
     C                   MOVE      *BLANKS       WCtryCde          2                        BUG26206
     C                   MOVE      *BLANKS       WCOLc             2                        BUG26206
      *                                                                                     BUG26206
     C                   CALL      'AOCUSTR0'                                               BUG26206
     C                   PARM      *BLANKS       PRtcd                                      BUG26206
     C                   PARM      '*KEY   '     POptn                                      BUG26206
     C                   PARM      DDCUST        PCnum                                      BUG26206
     C                   PARM                    PCnst                                      BUG26206
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG26206
      *                                                                                     BUG26206
     C                   IF        PRtcd = *blanks                                          BUG26206
     C                   EVAL      WCOLc = BBCOLC                                           BUG26206
     C                   ENDIF                                                              BUG26206
      *                                                                                     BUG26206
      ** Retrieve  Location Code                                                            BUG26206
      *                                                                                     BUG26206
     C                   CALL      'AOBRCHR1'                                               BUG26206
     C                   PARM      *BLANKS       PRtcd                                      BUG26206
     C                   PARM      '*KEY   '     POptn                                      BUG26206
     C                   PARM      BBBRCD        PBrch                                      BUG26206
     C     SDBRCH        PARM      SDBRCH        DSSDY                                      BUG26206
      *                                                                                     BUG26206
     C                   IF        PRtcd <> *blanks                                         BUG26206
     C     *LOCK         IN        LDA                                                      BUG26206
     C                   Z-ADD     016           DBASE                                      BUG26206
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG26206
     C                   EVAL      DBKEY = PBrch                                            BUG26206
     C                   EVAL      DBPGM = 'SD000796'                                       BUG26206
     C                   EVAL      *INU7 = *ON                                              BUG26206
     C                   EVAL      *INU8 = *ON                                              BUG26206
     C                   OUT       LDA                                                      BUG26206
     C                   EXSR      *PSSR                                                    BUG26206
     C                   ENDIF                                                              BUG26206
      *                                                                                     BUG26206
      ** Retrieve Country Code                                                              BUG26206
      *                                                                                     BUG26206
     C                   CALL      'AOLOCNR0'                                               BUG26206
     C                   PARM      *BLANKS       PRtcd                                      BUG26206
     C                   PARM      '*KEY   '     POptn                                      BUG26206
     C                   PARM      A8LCCD        PLocn                                      BUG26206
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG26206
      *                                                                                     BUG26206
     C                   IF        PRtcd <> *blanks                                         BUG26206
     C     *LOCK         IN        LDA                                                      BUG26206
     C                   Z-ADD     017           DBASE                                      BUG26206
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG26206
     C                   EVAL      DBKEY = PLocn                                            BUG26206
     C                   EVAL      DBPGM = 'SD000796'                                       BUG26206
     C                   EVAL      *INU7 = *ON                                              BUG26206
     C                   EVAL      *INU8 = *ON                                              BUG26206
     C                   OUT       LDA                                                      BUG26206
     C                   EXSR      *PSSR                                                    BUG26206
     C                   ELSE                                                               BUG26206
     C                   EVAL      WCtryCde = DVCNCD                                        BUG26206
     C                   ENDIF                                                              BUG26206
      *                                                                                     BUG26206
     C                   ENDSR                                                              BUG26206
      *****************************************************************                     BUG23308
      /EJECT                                                                                BUG23308
      *****************************************************************                     BUG23308
      *                                                               *                     BUG23308
      *  SRZDate10 - Convert YYYYMMDD format to day number            *                     BUG23308
      *                                                               *                     BUG23308
      *  Called by: SRLoadSfl                                         *                     BUG23308
      *                                                               *                     BUG23308
      *  Calls: None                                                  *                     BUG23308
      *                                                               *                     BUG23308
      *****************************************************************                     BUG23308
      *                                                                                     BUG23308
     C     SRZDate10     BEGSR                                                              BUG23308
      *                                                                                     BUG23308
      ** Call ZDATE10 to convert YYYYMMDD format to day number                              BUG23308
      *                                                                                     BUG23308
     C                   CALLB     'ZDATE10'                                                BUG23308
     C                   PARM      TSIPDT        PDtIn                                      BUG23308
     C                   PARM                    PZDayNo2                                   BUG23308
      *                                                                                     BUG23308
     C                   ENDSR                                                              BUG23308
      *
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG24018
      *                                                               *                     BUG24018
      *  SRZCvtRte - Convert Rate from file format to screen format   *                     BUG24018
      *                                                               *                     BUG24018
      *  Called by: SRLoadSfl                                         *                     BUG24018
      *                                                               *                     BUG24018
      *  Calls: None                                                  *                     BUG24018
      *                                                               *                     BUG24018
      *****************************************************************                     BUG24018
      *                                                                                     BUG24018
     C     SRZCvtRte     BEGSR                                                              BUG24018
      *                                                                                     BUG24018
     C                   CALLB     'ZA0920'                                                 BUG24018
     C                   PARM      *BLANK        @@RETC           10                        BUG24018
     C                   PARM                    @@AMTW           13 0                      BUG24018
     C                   PARM      7             @@QECN            1 0                      BUG24018
     C                   PARM                    BNDCSP            1                        BUG24018
     C                   PARM      *BLANK        @@AMTD           14                        BUG24018
      *                                                                                     BUG24018
     C                   ENDSR                                                              BUG24018
      *****************************************************************                     BUG24018
      /EJECT                                                                                BUG24018
      *****************************************************************                     BUG24018
      *                                                               *                     BUG24018
      *  SRGetBsrt - Get Base Rate details                            *                     BUG24018
      *                                                               *                     BUG24018
      *  Called by: SRLoadSfl                                         *                     BUG24018
      *                                                               *                     BUG24018
      *  Calls: None                                                  *                     BUG24018
      *                                                               *                     BUG24018
      *****************************************************************                     BUG24018
      *                                                                                     BUG24018
     C     SRGetBsrt     BEGSR                                                              BUG24018
      *                                                                                     BUG24018
     C                   CALLB     'AOBSRTR0'                                               BUG24018
     C                   PARM      *BLANKS       @RTCD             7                        BUG24018
     C                   PARM      '*KEY   '     @OPTN             7                        BUG24018
     C                   PARM                    @AJCD             3                        BUG24018
     C                   PARM                    @DWND             2                        BUG24018
     C     SDBSRT        PARM      SDBSRT        DSSDY                                      BUG24018
      *                                                                                     BUG24018
     C     @RTCD         IFNE      *BLANK                                                   BUG24018
     C     *LOCK         IN        LDA                                                      BUG24018
     C                   Z-ADD     012           DBASE                                      BUG24018
     C                   EVAL      DBFILE = 'SDBSRTPD'                                      BUG24018
     C                   EVAL      DBKEY = *BLANKS                                          BUG24018
     C                   EVAL      DBPGM = 'SD000796'                                       BUG24018
     C                   EVAL      *INU7 = *ON                                              BUG24018
     C                   EVAL      *INU8 = *ON                                              BUG24018
     C                   OUT       LDA                                                      BUG24018
     C                   EXSR      *PSSR                                                    BUG24018
     C                   ENDIF                                                              BUG24018
      *                                                                                     BUG24018
     C                   ENDSR                                                              BUG24018
      *****************************************************************                       CER069
      /EJECT                                                                                  CER069
      *****************************************************************                       CER069
      * SRACTX - Check of EU Tax Value                                *                       CER069
      *****************************************************************                       CER069
     C     SRACTX        BEGSR                                                                CER069
                                                                                              CER069
     C                   CALL      'AOACTXR0'                                                 CER069
     C                   PARM      *BLANKS       PRTCD                                        CER069
     C                   PARM      '*KEY   '     POPTN                                        CER069
     C                   PARM      CNUM          PCNUM                                        CER069
     C                   PARM      BRCA          PPBRCA                                       CER069
     C     SDACTX        PARM      SDACTX        DSFDY                                        CER069
                                                                                              CER069
     C                   IF        PRTCD <> *BLANKS OR AXETXS = *BLANKS                       CER069
     C                             OR AXETXS = 'S' OR AXETXS = 'E'                            CER069
     C                             OR AXETXS = 'D'                                            CER069
     C                   EVAL      TAXI = 'N'                                                 CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      TAXI = AXETXS                                              CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   ENDSR                                                                CER069
      *****************************************************************                     BUG24018
      /EJECT                                                                                BUG24018
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: SRCurr, *PSSR                                         *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          WCpy2
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE    *LDA          SAVLDA
      *
     C                   EVAL      DDPGM = 'SD000796'
     C                   EVAL      DBMOD =  PSProcMod
      *
      ** Call access program for bank details - title, run date and
      ** run day number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     001           DBASE
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'SD000796'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Populate Screen Header Fields
      *
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDJOB = PSJObName
      *                                                                                     BUG24935
      ** Access Location Code Details                                                       BUG24935
      *                                                                                     BUG24935
     C                   CALL      'AOLOCNR0'                                               BUG24935
     C                   PARM      *BLANKS       PRtCd                                      BUG24935
     C                   PARM      '*KEY'        POptn                                      BUG24935
     C                   PARM      BJSLCD        PLoCod            3                        BUG24935
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG24935
      *                                                                                     BUG24935
     C                   IF        PRtCd <> *BLANKS                                         BUG24935
     C     *LOCK         IN        LDA                                                      BUG24935
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG24935
     C                   EVAL      DBKEY  = PLoCod                                          BUG24935
     C                   EVAL      DBASE  = 014                                             BUG24935
     C                   OUT       LDA                                                      BUG24935
     C                   EXSR      *PSSR                                                    BUG24935
     C                   ENDIF                                                              BUG24935
      *                                                                                     BUG24935
      ** Access Country Code Details                                                        BUG24935
      *                                                                                     BUG24935
     C                   CALL      'AOCTRYR0'                                               BUG24935
     C                   PARM      *BLANKS       PRtCd                                      BUG24935
     C                   PARM      '*KEY'        POptn                                      BUG24935
     C                   PARM      DVCNCD        PCtCod            2                        BUG24935
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG24935
      *                                                                                     BUG24935
     C                   IF        PRtCd <> *BLANKS                                         BUG24935
     C     *LOCK         IN        LDA                                                      BUG24935
     C                   EVAL      DBFILE = 'SDCTRYPD'                                      BUG24935
     C                   EVAL      DBKEY  = PCtCod                                          BUG24935
     C                   EVAL      DBASE  = 015                                             BUG24935
     C                   OUT       LDA                                                      BUG24935
     C                   EXSR      *PSSR                                                    BUG24935
     C                   ELSE                                                               BUG24935
     C                   IF        A4ETXY <> *ZERO                                          BUG24935
     C                   MOVE      A4ETXY        WMmDd                                      BUG24935
     C                   ENDIF                                                              BUG24935
     C                   ENDIF                                                              BUG24935
      *
      ** Calulate Current Year
      *
     C**********         EVAL      WkDayn = BJRDNB                                          BUG24280
     C**********         EVAL      WkDayn = BJEYD                                  BUG24280 BUG24935
     C**********         CALLB     'ZDATE9'                                                 BUG24935
     C**********         PARM      WkDayn        PZDayNo                                    BUG24935
     C**********         PARM      *ZEROS        PZDate1                                    BUG24935
     C**********         PARM      *BLANKS       PErrorFlag                                 BUG24935
      **********                                                                            BUG24935
     C**********         IF        PErrorFlag = '0'                                         BUG24935
     C**********         MOVE      PZDate1       WZDate1                                    BUG24935
     C**********         EVAL      WkYr2 = %SUBST(WZDate1:3:2)                              BUG24935
     C**********         MOVE      WkYr2         WWYr2                                      BUG24935
     C**********         ENDIF                                                              BUG24935
     C                   MOVE      BJMRDT        WkYr2                                      BUG24935
     C                   MOVE      BJMRDT        WWYr2                                      BUG24935
      *                                                                                     BUG24935
     C                   MOVE      WkYr2         WYrEndD                                    BUG24935
     C                   MOVEL     WMmDd         WYrEndD                                    BUG24935
      *                                                                                     BUG24935
     C                   CALLB     'ZDATE1'                                                 BUG24935
     C                   PARM                    WYrEndD                                    BUG24935
     C                   PARM      *ZEROS        PZDAYNO           5 0                      BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *BLANKS       PERR              1                        BUG24935
     C                   Z-ADD     PZDAYNO       WETYear                                    BUG24935
      *                                                                                     BUG24935
     C                   IF        WETYear <  BJRDNB                                        BUG24935
     C                   ADD       1             WWYr2                                      BUG24935
     C                   MOVE      WWYr2         WkYr2                                      BUG24935
     C                   MOVE      WkYr2         WYrEndD                                    BUG24935
      *                                                                                     BUG24935
     C                   CALLB     'ZDATE1'                                                 BUG24935
     C                   PARM                    WYrEndD                                    BUG24935
     C                   PARM      *ZEROS        PZDAYNO           5 0                      BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *BLANKS       PERR              1                        BUG24935
     C                   Z-ADD     PZDAYNO       WETYear                                    BUG24935
     C                   ENDIF                                                              BUG24935
      *
      ** Read SDCURRXX for withholding tax ICD ccy --> CCD,1 und CDP,1
      *
     C                   EVAL      KDCCY = BJCYCD
     C                   EXSR      SRCurr
      *
     C                   Z-ADD     1             WwMult
     C     1             DO        A6NBDP
     C                   MULT      10            WwMult
     C                   ENDDO
      *                                                                                     BUG24018
      * Access Dealing Details                                                              BUG24018
      *                                                                                     BUG24018
     C                   CALL      'AODEALR1'                                               BUG24018
     C                   PARM      *BLANKS       @RTCD             7                        BUG24018
     C                   PARM      '*FIRST '     @OPTN             7                        BUG24018
     C     SDDEAL        PARM      SDDEAL        DSSDY                                      BUG24018
      *
      ** Define Key for SDTHRHL3
      *
     C     KLThRs        KLIST
     C                   KFLD                    SCUSTA
     C                   KFLD                    WActDt
      *
      ** Define Key for SDACTXL1
      *
     C     KLAcTx        KLIST
     C                   KFLD                    KFCust
     C                   KFLD                    KFCTxCd
      *
      ** Define Key for ACCRACJ                                                             BUG24018
     C     R1Key         KLIST                                                              BUG24018
     C                   KFLD                    TSBRCA                                     BUG24018
     C                   KFLD                    CCNUM                                      BUG24018
     C                   KFLD                    TSOCCY                                     BUG24018
     C                   KFLD                    TSACOD                                     BUG24018
     C                   KFLD                    TSACSQ                                     BUG24018
      *                                                                                     BUG24018
      ** Define Key for REINT                                                               BUG24018
     C     R2Key         KLIST                                                              BUG24018
     C                   KFLD                    RKEY                                       BUG24018
      *                                                                                     BUG24018
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRTCD                                        CER054
     C                   PARM      '*VERIFY'     POPTN                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
      *                                                                                       CER054
     C                   MOVE      'N'           CER054                                       CER054
     C     PRTCD         IFEQ      *BLANKS                                                    CER054
     C                   MOVE      'Y'           CER054                                       CER054
     C                   MOVE      *ON           *IN51                                        CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Error Processing Subroutine                  *
      *                                                               *
      *  Called by: *INZSR, SRCurr, SRValFmt                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2008
