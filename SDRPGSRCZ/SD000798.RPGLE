     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Limit Utilisation Report')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000798 - Midas SD Limit Utilisation Report                 *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CER070             Date 25Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CER069             Date 03Jul14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CRE075             Date 06Dec10               *
      *                 AR745921           Date 16Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26718           Date 12Nov09               *
      *                 BUG25075           Date 28Jul09               *
      *                 BUG24935           Date 17Jul09               *
      *                 BUG24941           Date 16Jul09               *
      *                 BUG24615           Date 01Jul09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG24212           Date 05Jun09               *
      *                 BUG24125           Date 02Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23123B          Date 17Apr09               *
      *                 BUG23691           Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG23319           Date 16Mar09               *
      *                 CER048A            Date 19May08               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CER069 - German Tax Enhancement                              *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR745921 - Include Non-Account holders members               *
      *             (Child: AR745922)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26718 - SD000798P1 contains '11.44' value on most of the  *
      *             clients                                           *
      *  BUG25075 - Correct interest period printed on report         *
      *  BUG24935 - Limit Utilisation Report shows a minus            *
      *             figure/incorrect Threshold Excess                 *
      *  BUG24941 - Joint customers should show member transactions   *
      *  BUG24615 - Display Program Messages Error during Limit       *
      *             Utilisation Report Request                        *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG24212 - Incorrect Date on 'Interest Period'               *
      *  BUG24125 - SD000798 Limit Utilisation needs leading zeros    *
      *             on Deal Number                                    *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER054 - German Feature - Church Tax                         *
      *  BUG23123B - Inaccurate Dates are being printed               *
      *  BUG23691 - CPF5004 overflow error in SD000798P1              *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *  BUG23319 - Report: Calculated threshold excess is incorrect  *
      *  CER048A- German Features - Taxes                             *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N    O F   I N D I C A T O R S                 *
      *                                                               *
      *  *IN40  -  ND To-Interest-Date                                *
      *  *IN50  -  Display join's informations                        *
      *  *IN51  -  CCY not equal withholding tax ICD ccy              *
      *  *IN98  -  date format= DDMMYY                                *
      *  *IN98  -  date format= MMDDYY                                *
      *  *INLR  -  END OF PROGRAM                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInit    Subroutine to do Program Initialisation.           *
      *  SRJsum    Joined customer, Sum utilisat., Sum Thresh.,       *
      *            -Excess cust.header                                *
      *  SRDetai   Customer details                                   *
      *  SRCuste   Customer ende                                      *
      *  SRRcfau   Subroutine to register the AU Printer File via RCF.*
      *  SRRcfp1   Subroutine to register the P1 Printer File via RCF.*
      *  SRAudit   Subroutine to Output Audit report and End Program. *
      *  SRZsEdit  Convert amount from file format to screen format   *
      *  SRZDate2  Convert date from file format to screen format     *
      *  *PSSR     Error control subroutine                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Selected Customers for limit utilisation File
      *
     FSDLMUTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(K:1)
      *
      ** Interest History Header File
      *
     FSDINPHL1  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                     BUG24935
      ** Interest Payment History for Joint Accounts                                        BUG24935
      *                                                                                     BUG24935
     FSDINPHL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG24935
     F                                     RENAME(SDINPHD0:SDINPHD3)                        BUG24935
      *
      ** Join Customer detail and extension File
      *
     FSDCUATJ0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Joint Account Member file
      *
     F***SDJACCL4  IF   E           K DISK    INFSR(*PSSR)                                  BUG23732
     FSDJACCLB  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
      *
      ** Midas SD Customer Income File
      *
     F***SDCSINL2  IF   E           K DISK    INFSR(*PSSR)                                 BUG23123B
     FSDCSINLI  IF   E           K DISK    INFSR(*PSSR)                                    BUG23123B
      *                                                                                     AR745921
      ** Midas SD Customer Income File                                                      AR745921
      *                                                                                     AR745921
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR)                                     AR745921
     F                                     RENAME(SDCSIND0:SDCSIND3)                        AR745921
      *
      ** Midas SD Tax basket details - retrieve
      *
     FACCNTBXC  IF   E           K DISK    INFSR(*PSSR)
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
      ** Print File
      *
     FSD000798P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      *
     FSD000798AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      *
      *****************************************************************
     F/EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
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
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
     D ArrSet          S             30A   DIM(6)
     D                                     PERRCD(2)
     D                                     CTDATA
      *
      ** Define details from parameters received
      *
     D PRparm          DS           246
     D  PCust                  1      6A
     D  PCustf                 7     12A
     D  PCustt                13     18A
     D  PJref                 19     22A
     D  PTaxt                 23     24A
     D  PAcof                 25     26A
     D  PBrca                 27     29A
     D  PAll                  30     30A
     D  PYear                 31     34A
      *
      ** Printer INFDS(File Information Data Structure for SD000798P1)
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File Information Data Structure for SD000798AU.
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** Dummy Data Structures used by Access Programs.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   AR745921
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Location details                                       BUG24935
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24935
      *                                                                                     BUG24935
      ** Externally described DS for country details                                        BUG24935
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG24935
      *                                                                                     BUG24935
      ** External data structures for Currency Details
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      *
      ** Data Structure for Additional Customer Details
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *                                                                                     AR745921
      ** External DS for Non-Account Holders                                                AR745921
      *                                                                                     AR745921
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                AR745921
      *
      ** External DS for SAR Details                                                          CER054
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER054
     D  WLCD         E                     EXTFLD(LCD)                                        CER054
      *                                                                                       CER054
     D SDACTX        E DS                  EXTNAME(SDACTXPD)                                  CER069
      **  External DS for customer details by country of tax                                  CER069
                                                                                              CER069
      ** Parameters
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PRetl           S             10A
     D PCnum           S              6A
     D PCucd           S              3A
     D*PAccd****       S              4A                                                    BUG23123
     D PAccd           S             10A                                                    BUG23123
     D PAcsq           S              2A
     D PpBrca          S              3A
      *
     D PKey            S              3A
      *
     D PSeq            S              5A
     D PSenty          S              3A
     D PZsnum          S              6P 0
     D PZserr          S              1A
      *
     D PRseq           S              5A
      *
     D PSard           S              6A
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
     D PZDayNo         S              5P 0
     D PZDate          S              6P 0
     D PZADate         S              7A
      *
      ** Paramater AOACUSR0
      *
     D PAcus           S              6A
     D PCnst           S              7A
      *
      ** Work Variables
      *
     D WTexce          S             17P 0
     D WUtil           S             15P 0
     D WTutil          S             17P 0
     D WUthr           S             15P 0
     D WTuthr          S             17P 0
     D WCext           S             15P 0
     D*WCext#***       S             17P 2                                         BUG23319 BUG24935
     D*WCextJ***       S             17P 0                                         BUG23319 BUG24935
     D WTcext          S             10P 0
     D WRun            S              1A
     D WSet            S              1A
     D WCounter        S              3P 0
      *
     D WfPrt1          S              1A
      *
     D WP1rcf          S              1A
     D WCount          S              6P 0
     D WRqdln1         S              3P 0
     D WDifln1         S              3P 0
     D WkCusf          S              6A
     D WkCust          S              6A
     D WkCus           S              6A
     D WkTax           S              2A
     D WkAcof          S              2A
     D WkBran          S              3A
     D WkCustn         S              6A
      *
     D WkCusn          S              6A
     D WkMult          S              4P 0
     D WkA002          S              2A
     D*WkA004***       S              4A                                                    BUG23123
     D WkA004          S             10A                                                    BUG23123
     D WkBcdc          S              1P 0
     D WD1Dat          S              6A
     D WItd1           S              6A                                                    BUG24212
      *
     D*KCum*****       S              6S 0                                                    CER059
     D KCum            S              6A                                                      CER059
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A
      *                                                                                     BUG23732
     D WGint           S             15P 0                                                  BUG23732
     D WTtax           S             15P 0                                                  BUG23732
     D WTttax          S             17P 0                                                  BUG23732
     D WTgint          S             17P 0                                                  BUG23732
      *
     D*Date*****       DS             6                                           BUG23123B BUG24212
     D Date            DS             8                                                     BUG24212
     D DD                             2  0                                                 BUG23123B
     D MM                             2  0                                                 BUG23123B
     D*YY*******                      2  0                                        BUG23123B BUG24212
     D YY                             4  0                                                  BUG24212
      *                                                                                    BUG23123B
     D WStaxYr         S              6P 0                                                  BUG24280
     D WStaxYrA        S              6A                                                    BUG24280
     D WDdMm           S              4A                                                    BUG24280
     D WEtaxYr         S              6P 0                                                  BUG24280
     D WSYear          S              5P 0                                                  BUG24280
     D WEYear          S              5P 0                                                  BUG24280
     D TYear           S              4P 0                                                  BUG24280
     D WYear           S              2P 0                                                  BUG24280
     D WJeyd           S              5P 0                                                  BUG24280
     D WWYeaR          S              2P 0                                                  BUG24280
     D WwYr            S              2P 0                                                  BUG24280
      *                                                                                     BUG24280
     D PDayNo          S              6P 0                                                  BUG24280
     D PDayNo1         S              5P 0                                                  BUG24280
     D PErr            S              1A                                                    BUG24280
      *                                                                                     BUG24280
     D CER054          S              1A                                                      CER054
      *                                                                                       CER054
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Read first record in file SDLMUTPD
      *
     C     *LOVAL        SETLL     SDLMUTD0
     C                   READ      SDLMUTD0
      *
     C                   DOW       NOT %EOF(SDLMUTL1)
     C                   EVAL      WCounter = 0
     C                   MOVEL     *BLANKS       RefInst          34                       BUG23123B
     C                   MOVEL     *BLANKS       RefModi           1                       BUG23123B
     C                   Z-ADD     *ZEROS        RefAcod          10 0                     BUG23123B
     C**********         MOVEL     *BLANKS       RefDate           6              BUG23123B BUG25075
      *
      ** Check if the customer exists in the interest header file
      ** If does not exist, process next selected customer
      *
     C                   EVAL      WkCustn = KCUST
     C     WkCustn       CHAIN     SDINPHL1
     C                   IF        NOT %FOUND(SDINPHL1)
     C                   GOTO      NEXT
     C                   ENDIF
      *
     C*****WkCustn       SETLL     SDCSINL2                           88                   BUG23123B
     C     WkCustn       SETLL     SDCSINLI                           88                   BUG23123B
      *
      ** If the selection criteria is 'Joint Customer' or
      ** 'Individual customer', show the customer even though
      ** there is no interest detail for the customer
      ** In other cases, process next selected customer
      *
     C                   IF        *IN88 = *OFF AND
     C                             WkCustn = *BLANKS
     C                   GOTO      NEXT
     C                   ENDIF
      *
      ** RCF Processing
      *
     C                   IF        WP1rcf = 'N'
     C                   EXSR      SRRcfp1
     C                   EVAL      WP1rcf = 'Y'
     C                   ENDIF
      *
      ** Calculate the 'Total Threshold' 'Total Utilisation' and
      ** 'Threshold Excess'
      *
     C                   EXSR      SRJsum
      *
      ** Retrieve the interest posting details
      *
     C*****WkCustn       READE     SDCSINL2                               87               BUG23123B
     C     WkCustn       READE     SDCSINLI                               87               BUG23123B
      *
     C                   DOW       *IN87 = *OFF
      *                                                                                     BUG24280
     C                   IF        TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear                                         BUG24280
      *
     C                   EXSR      SRDetail
      *                                                                                     BUG24280
     C                   ENDIF                                                              BUG24280
      *
     C*****WkCustn       READE     SDCSINL2                               87               BUG23123B
     C     WkCustn       READE     SDCSINLI                               87               BUG23123B
     C                   ENDDO
      *                                                                                     BUG24941
      ** Display joint customer member transactions                                         BUG24941
      *                                                                                     BUG24941
     C                   IF        KJATP = 'Y'                                              BUG24941
      *                                                                                     BUG24941
     C     KCUST         SETLL     SDJACCLB                                                 BUG24941
     C     KCUST         READE     SDJACCLB                                                 BUG24941
      *                                                                                     BUG24941
     C                   DOW       NOT %EOF(SDJACCLB)                                       BUG24941
      *                                                                                     BUG24941
     C                   IF        JCCUST <> *BLANKS                                        AR745921
     C     JCCUST        SETLL     SDCSINLI                                                 BUG24941
     C     JCCUST        READE     SDCSINLI                                                 BUG24941
      *                                                                                     BUG24941
     C                   DOW       NOT %EOF(SDCSINLI)                                       BUG24941
      *                                                                                     BUG24941
     C                   IF        TSRDNB >= WSYear AND                                     BUG24941
     C                             TSRDNB <= WEYear                                         BUG24941
     C                   EXSR      SRDETAIL                                                 BUG24941
     C                   ENDIF                                                              BUG24941
      *                                                                                     BUG24941
     C     JCCUST        READE     SDCSINLI                                                 BUG24941
     C                   ENDDO                                                              BUG24941
      *                                                                                     AR745921
     C                   ELSE                                                               AR745921
      *                                                                                     AR745921
     C     JCNAHO        SETLL     SDCSINL3                                                 AR745921
     C     JCNAHO        READE     SDCSINL3                                                 AR745921
      *                                                                                     AR745921
     C                   DOW       NOT %EOF(SDCSINL3)                                       AR745921
      *                                                                                     AR745921
     C                   IF        TSRDNB >= WSYear AND                                     AR745921
     C                             TSRDNB <= WEYear                                         AR745921
     C                   EXSR      SRDETAIL                                                 AR745921
     C                   ENDIF                                                              AR745921
      *                                                                                     AR745921
     C     JCNAHO        READE     SDCSINL3                                                 AR745921
     C                   ENDDO                                                              AR745921
      *                                                                                     AR745921
     C                   ENDIF                                                              AR745921
      *                                                                                     BUG24941
     C     KCUST         READE     SDJACCLB                                                 BUG24941
     C                   ENDDO                                                              BUG24941
     C                   ENDIF                                                              BUG24941
      *
      ** End Customer
      *
     C                   EXSR      SRCuste
      *
     C     NEXT          TAG
     C                   READ      SDLMUTD0
     C                   ENDDO
      *
      ** Write 'End of Report'
      *
     C                   IF        WCount = 0
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJsum - Joined customer, Sum utilisation, Sum Thresh.,      *
      *           Excess cust.header                                  *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZsEdit                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRJsum        BEGSR
      *
      ** Reset work fields
      *
     C                   Z-ADD     0             WUtil
     C                   Z-ADD     0             WTutil
     C                   Z-ADD     0             WUthr
     C                   Z-ADD     0             WTuthr
     C                   Z-ADD     0             WCext
     C                   Z-ADD     0             WTcext
     C                   Z-ADD     0             WTexce
     C                   Z-ADD     0             WGint                                      BUG23732
     C                   Z-ADD     0             WTgint                                     BUG23732
     C                   Z-ADD     0             WTtax                                      BUG23732
     C                   Z-ADD     0             WTttax                                     BUG23732
      *
      ** Reset report fields
      *
     C                   EVAL      RCTAX = *BLANKS
     C                   EVAL      RCNAM = *BLANKS
     C                   EVAL      RCEXT = *BLANKS
     C                   EVAL      ROCUS = '------'
      *
      ** Retrieve customer details
      *
     C     KCUST         CHAIN     SDCUATJ0
     C                   IF        NOT %FOUND(SDCUATJ0)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUATJ0'
     C                   Z-ADD     004           DBASE
     C                   EVAL      DBKEY  = '*BLANKS'
     C                   EVAL      DBPGM = 'SD000798'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      ROCUSM = BBCUST
     C                   EVAL      RCTAXM = AXETXS
     C                   EVAL      RCNAMM = BBCRNM
      *
     C                   Z-ADD     TITOUT        WUtil
     C                   Z-ADD     TIUTTH        WUthr
     C                   Z-ADD     TICUTH        WCext
     C                   Z-ADD     TIGSIN        WGint                                      BUG23732
     C                   Z-ADD     TITTAX        WTtax                                      BUG23732
                                                                                            BUG23319
      ** Format Current Threshold for Threshold Excess calculation                          BUG23319
     C**********         Z-ADD     TICUTH        WCext#                            BUG23319 BUG24935
     C**********         MOVE      WCext#        WCextJ                            BUG23319 BUG24935
     C                   Z-ADD     TICUTH        WCext                                      BUG24935
     C                   IF        TIJOIN <> *BLANKS                                        BUG24935
     C                             AND TIJOIN <> WkCustn                                    BUG24935
     C                   MOVE      TIJOIN        WJCustN           6                        BUG24935
     C                   Z-ADD     *ZERO         WUthr                                      BUG24935
     C                   Z-ADD     *ZERO         WCext                                      BUG24935
     C     WJCustN       SETLL     SDINPHL3                                                 BUG24935
     C     WJCustN       READE     SDINPHL3                                                 BUG24935
      *                                                                                     BUG24935
     C                   DOW       NOT %EOF(SDINPHL3)                                       BUG24935
     C                   ADD       TIUTTH        WUthr                                      BUG24935
     C                   ADD       TICUTH        WCext                                      BUG24935
     C     WJCustN       READE     SDINPHL3                                                 BUG24935
     C                   ENDDO                                                              BUG24935
      *                                                                                     BUG24935
     C                   ENDIF                                                              BUG24935
      *                                                                                     BUG24935
     C                   IF        WkMult > 0                                               BUG24935
     C                   EVAL      WCext = WCext * WkMult                                   BUG24935
     C                   ENDIF                                                              BUG24935
      *
      ** Calculate utilisation, threshold excess, sum threshold/join
      *
     C**********         EVAL      WTexce = WUthr - WCext                                   BUG23319
     C**********         EVAL      WTexce = WUthr - WCextJ                        BUG23319 BUG23123B
     C**********         EVAL      WTexce = WCextJ - WUthr                        BUG23123B BUG24935
     C                   EVAL      WTexce = WCext - WUthr                                   BUG24935
     C**********         IF        WTexce < 0                                     BUG23123B BUG24935
     C**********         Z-ADD     *ZEROS        WTexce                           BUG23123B BUG24935
     C**********         ENDIF                                                    BUG23123B BUG24935
     C                   Z-ADD     WUtil         WTutil
     C                   Z-ADD     WUthr         WTuthr
     C                   Z-ADD     WCext         WTcext
     C                   Z-ADD     WGint         WTgint                                     BUG23732
     C                   Z-ADD     WTtax         WTttax                                     BUG23732
      *
     C                   IF        WkMult > 0                                               BUG24935
     C                   EVAL      WCext = WCext / WkMult                                   BUG24935
     C                   ENDIF                                                              BUG24935
     C                   Z-ADD     WkBcdc        A6NBDP
     C                   Z-ADD     WCext         PZFld15
     C**********         Z-ADD     A6NBDP        PZDecs                                     CER048A
     C                   Z-ADD     *ZEROS        PZDecs                                     CER048A
     C                   EVALR     PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RCEXTM = %TRIM(PZout21)
      *
      ** Print Header 'selection' and 'selected year'
      ** Primary customer details
      *
     C                   EVAL      WCount = WCount + 1
     C                   WRITE     SD000798F0
      *
      ** If Customer with Tax type 'G' and with Join Acct. Type
      *
     C                   IF        KJATP = 'Y' AND
     C**********                   AXETXS = 'G'                                             BUG23732
     C**********                   AXETXS = 'T'                                               CER069
     C                             (AXETXS = 'T' or AXETXS = 'Y')                    BUG23732 CER069
      *
      ** Populate array for kust
      *
     C*****WkCustn       SETLL     SDJACCL4                                                 BUG23732
     C*****WkCustn       READE     SDJACCL4                                                 BUG23732
     C     WkCustn       SETLL     SDJACCLB                                                 BUG23732
     C     WkCustn       READE     SDJACCLB                                                 BUG23732
      *
     C                   EVAL      WCounter = 1
      *
     C**********         DOW       NOT %EOF(SDJACCL4)                                       BUG23732
     C                   DOW       NOT %EOF(SDJACCLB)                                       BUG23732
      *
      ** Retrieve Join Customer details
      *
     C                   CLEAR                   SD000798F1                                 AR745921
      *                                                                                     AR745921
     C                   IF        JCCUST <> *BLANKS                                        AR745921
     C*****JCJANO        CHAIN     SDCUATJ0                                                 BUG23732
     C     JCCUST        CHAIN     SDCUATJ0                                                 BUG23732
     C                   IF        %FOUND(SDCUATJ0)
      *
     C                   EVAL      ROCUS = BBCUST
     C                   EVAL      RCTAX = AXETXS
     C                   EVAL      RCNAM = BBCRNM
      *
      ** Join customer read utilisation
      *
     C                   MOVE      BBCUST        WkCusn
      *
     C     WkCusn        CHAIN     SDINPHL1
     C                   IF        %FOUND(SDINPHL1)
      *
     C                   Z-ADD     TITOUT        WUtil
     C                   Z-ADD     TIUTTH        WUthr
     C                   Z-ADD     TICUTH        WCext
     C                   Z-ADD     TIGSIN        WGint                                      BUG23732
     C                   Z-ADD     TITTAX        WTtax                                      BUG23732
      *
     C                   ENDIF
      *
      ** Calculate utilisation, threshold excess, sum threshold/join
      *
     C**********         EVAL      WTexce = WTexce + WUtil                                  BUG24935
     C**********         EVAL      WTexce = WTexce - WCext                                  BUG24935
     C                   IF        WkMult > 0                                               BUG24935
     C                   EVAL      WCext = WCext * WkMult                                   BUG24935
     C                   ENDIF                                                              BUG24935
     C                   EVAL      WTexce = WTexce - WUthr                                  BUG24935
     C                   EVAL      WTexce = WTexce + WCext                                  BUG24935
     C                   EVAL      WTutil = WTutil + WUtil
     C                   EVAL      WTuthr = WTuthr + WUthr
     C                   EVAL      WTcext = WTcext + WCext
     C                   EVAL      WTgint = WTgint + WGint                                  BUG23732
     C                   EVAL      WTttax = WTttax + WTtax                                  BUG23732
      *
     C                   IF        WkMult > 0                                               BUG24935
     C                   EVAL      WCext = WCext / WkMult                                   BUG24935
     C                   ENDIF                                                              BUG24935
     C                   Z-ADD     WkBcdc        A6NBDP
     C                   Z-ADD     WCext         PZFld15
     C**********         Z-ADD     A6NBDP        PZDecs                                     CER048A
     C                   Z-ADD     *ZEROS        PZDecs                                     CER048A
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RCEXT = %TRIM(PZout21)
     C                   ENDIF                                                              AR745921
     C                   ELSE                                                               AR745921
      *Non-Account holder                                                                   AR745921
     C                   MOVEL     JCNAHO        PNonAccnt                                  AR745921
     C                   EXSR      SRRtvNonAcc                                              AR745921
     C                   EVAL      ROCUS = JCNAHO                                           AR745921
     C                   EVAL      RCNAM = NHNARN                                           AR745921
      *                                                                                     AR745921
     C                   ENDIF                                                              AR745921
      *
      ** For printing the heading's only once
      *
     C                   IF        WCounter = 1
     C                   EVAL      *IN50 = *ON
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
      ** SD000798F1 needs at least 8  lines to print                                        BUG24615
     C*********          EVAL      WRqdln1 = 1                                              BUG24615
     C                   EVAL      WRqdln1 = 8                                              BUG24615
     C                   EVAL      WDifln1 = OFLLN1 - PRTLN1
      *
     C                   IF        WDifln1 <= WRqdln1
     C                   EVAL      *IN50 = *ON
     C                   WRITE     SD000798F0
     C                   ENDIF
      *
     C                   WRITE     SD000798F1
     C                   EVAL      WCounter = WCounter + 1
     C                   EVAL      *IN50 = *OFF
      *
     C**********         ENDIF                                                              AR745921
      *
     C*****WkCustn       READE     SDJACCL4                                                 BUG23732
     C     WkCustn       READE     SDJACCLB                                                 BUG23732
     C                   ENDDO
      *
     C                   ENDIF
      *                                                                                     BUG24935
     C                   IF        WTexce < 0                                               BUG24935
     C                   Z-ADD     *ZEROS        WTexce                                     BUG24935
     C                   ENDIF                                                              BUG24935
      *
      ** TOTALS
      *
     C                   IF        WkMult > 0                                               BUG24935
     C                   EVAL      WTcext = WTcext / WkMult                                 BUG24935
     C                   ENDIF                                                              BUG24935
     C                   Z-ADD     WkBcdc        A6NBDP
     C                   Z-ADD     WTcext        PZFld15
     C**********         Z-ADD     A6NBDP        PZDecs                                     CER048A
     C                   Z-ADD     *ZEROS        PZDecs                                     CER048A
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RTCEXT = %TRIM(PZout21)
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C**********         EVAL      WRqdln1 = 7                                              BUG24615
     C                   EVAL      WRqdln1 = 11                                             BUG24615
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      WRqdln1 = 9                                       CER054 BUG24615
     C                   EVAL      WRqdln1 = 15                                             BUG24615
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   EVAL      WDifln1 = OFLLN1 - PRTLN1
      *
     C                   IF        WDifln1 <= WRqdln1
     C                   WRITE     SD000798F0
     C                   ENDIF
      *
     C                   IF        WCounter > 1
     C                   EVAL      *IN50 = *ON
     C                   ENDIF
      *
      ** Customer Title
      *
     C                   WRITE     SD000798F2
      *
     C                   EVAL      *IN50 = *OFF
      *
      ** Reset flag > 0 cust detail printed
      *
     C                   EVAL      WfPrt1 = '0'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail - Customer detail                                   *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZDate2, SRZsEdit                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDetail      BEGSR
      *
      ** Account number/ Deal Ccy Cust
      *
     C                   EVAL      WSet = *BLANKS
      *
     C                   IF        TSDLLN = *ZEROS AND
     C                             (TSACOD = *ZEROS OR TSACSQ = *ZEROS)
      *
      ** If Manual Flag= Y : "CNUM CCY ADJUST"
      *
     C                   IF        TSMODI = 'M'
      *
     C                   EVAL      RA019 = TSCUST + '  ' + TSOCCY
     C                                    + '  ' + 'ADJUST'
      *
     C                   ENDIF
      *
      ** else: "CNUM-CCY-Acc.Code-Acc.Sequence"
      *
     C                   ELSE
      *
     C                   EVAL      PCnum  = TSCUST
     C                   EVAL      PCucd  = TSOCCY
     C                   EVAL      PpBrca = TSBRCA
     C                   MOVE      TSACOD        PAccd
     C                   MOVE      TSACSQ        PAcsq
     C                   EVAL      PRetl  = *BLANKS
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PRetl
     C                   PARM                    PCnum
     C                   PARM                    PCucd
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PpBrca
     C     ACCNT         PARM      ACCNT         DSSDY
      *
     C                   IF        PRtcd = *BLANKS
      *
     C                   EVAL      WSet = 'A'
                                                                                            BUG23123
     C                   SELECT                                                             BUG23123
     C                   WHEN      ACNO = *ZEROS                                            BUG23123
     C                   MOVE      ACOD          WkA004
     C                   MOVE      ACSQ          WkA002
     C**********         EVAL      RA019 = %CHAR(CNUM) + '-' +                              BUG24125
     C**********         EVAL      RA019 = %EDITC(CNUM:'X') + '-' +                  BUG24125 CER059
     C                   EVAL      RA019 = CNUM + '-' +                                       CER059
     C                             CCY + '-' + WkA004 + '-' +
     C                             WkA002
                                                                                            BUG23123
     C                   OTHER                                                              BUG23123
     C**********         EVAL      RA019 = %CHAR(ACNO) + ' ' + CCY                 BUG23123 BUG24125
     C                   EVAL      RA019 = %EDITC(ACNO:'X') + ' ' + CCY                     BUG24125
     C                   ENDSL                                                              BUG23123
                                                                                            BUG23123
     C                   ELSE
      *                                                                                     AR745921
     C                   IF        TSDLLN = *ZEROS                                          AR745921
      *                                                                                     AR745921
     C                   EVAL      WSet = 'N'                                               AR745921
     C                   IF        TSNAHO = *BLANKS                                         AR745921
     C                   EVAL      RA019 = TSCUST  + ' ' + TSOCCY                           AR745921
     C                   ELSE                                                               AR745921
     C                   EVAL      RA019 = TSNAHO  + ' ' + TSOCCY                           AR745921
     C                   ENDIF                                                              AR745921
     C                   ELSE                                                               AR745921
      *
     C                   EVAL      WSet = 'D'
      *
      ** else Deal No.><0:   "dealno CCY"
      *
     C**********         EVAL      RA019 = %CHAR(TSDLLN) + '  ' +                           BUG24125
     C                   EVAL      RA019 = %EDITC(TSDLLN:'X') + '  ' +                      BUG24125
     C                                    TSOCCY
     C                   ENDIF                                                              AR745921
      *
      ** If joinref # blanks "dealno CCY CNUM"
      *
     C                   IF        KJATP = 'Y'
     C                   EVAL      RA019 = RA019 + '  ' + KCUST
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Interest date
      *
     C                   IF        BJDFIN = 'M'
      *
     C                   EVAL      %SUBST(WD1Dat:1:2) =
     C                             %SUBST(TSIPDT:5:2)
     C                   EVAL      %SUBST(WD1Dat:3:2) =
     C                             %SUBST(TSIPDT:7:2)
     C                   EVAL      %SUBST(WD1Dat:5:2) =
     C                             %SUBST(TSIPDT:3:2)
      *
     C                   ELSE
      *
     C                   EVAL      %SUBST(WD1Dat:1:2)
     C                             = %SUBST(TSIPDT:7:2)
     C                   EVAL      %SUBST(WD1Dat:3:2)
     C                             = %SUBST(TSIPDT:5:2)
     C                   EVAL      %SUBST(WD1Dat:5:2)
     C                             = %SUBST(TSIPDT:3:2)
      *
     C                   ENDIF
      *
     C                   MOVE      WD1Dat        RINTD
      *
      ** If Manual Flag= Y or Retro Flag= Y: interest date= KEINTD
      *
     C                   IF        TSMODI = 'M'
      *
     C                   EVAL      *IN40 = *ON
     C                   EVAL      RTO = *BLANKS
     C                   MOVE      WD1Dat        RITD1
      *
      ** else: interest period +
      *
     C                   ELSE
      *
     C                   EVAL      *IN40 = *OFF
     C**********         EVAL      RTO = 'TO'                                               BUG23123
     C                   EVAL      RTO = '-'                                                BUG23123
     C**********         Z-ADD     TSRDNB        PZDayNo                                    BUG23123
     C                   Z-ADD     TSSLID        PZDayNo                                    BUG23123
     C                   EXSR      SRZDate2
     C                   EXSR      SrAddDate                                               BUG23123B
     C**********         Z-ADD     PZDate        RITD1                                     BUG23123B
     C**********         MOVE      WD1Dat        RITD2                                     BUG23123B
      *
     C                   ENDIF
      ** Store field values for reference                                                  BUG23123B
     C                   EXSR      SRStrRef                                                BUG23123B
      *
      ** Check Decimal Places
      *
     C                   IF        TSOCCY = BJCYCD
     C                   Z-ADD     WkBcdc        A6NBDP
      *
     C                   ELSE
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSOCCY        PKey
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   Z-ADD     005           DBASE
     C                   EVAL      DBKEY = TSOCCY
     C                   EVAL      DBPGM = 'SD000798'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** - capitalised (Gross) Interest  in CCY / DM
      ** - tax deducted  in CCY / DM
      ** - net interest  in CCY / DM
      ** - solid.zuschl. in CCY / DM
      *
     C     *LIKE         DEFINE    TSGINT        DdGinc
     C     *LIKE         DEFINE    TSGINC        DdGind
     C     *LIKE         DEFINE    TSTXSR        DdTxdc
     C     *LIKE         DEFINE    TSTXSC        DdTxdd
     C     *LIKE         DEFINE    TSNINT        DdNinc
     C     *LIKE         DEFINE    TSNINC        DdNind
     C     *LIKE         DEFINE    TSPTHU        DdTadc
     C     *LIKE         DEFINE    TSPTUT        DdTadd
     C     *LIKE         DEFINE    TSSTDO        DdSozc
     C     *LIKE         DEFINE    TSSTDT        DdSozd
      *
     C     *LIKE         DEFINE    TSTTDO        DDTHTC                                       CER054
     C     *LIKE         DEFINE    TSTTDT        DDTHTD                                       CER054
      *
     C                   Z-ADD     *ZEROS        DdTadc
     C                   Z-ADD     *ZEROS        DdTadd
      *
      ** Betrage
      *
     C                   IF        TSMODI <> 'M'
      *
     C                   Z-ADD     TSGINT        DdGinc
     C                   Z-ADD     TSGINC        DdGind
     C                   Z-ADD     TSTXSR        DdTxdc
     C                   Z-ADD     TSTXSC        DdTxdd
     C                   Z-ADD     TSNINT        DdNinc
     C                   Z-ADD     TSNINC        DdNind
     C                   Z-ADD     TSSTDO        DdSozc
     C                   Z-ADD     TSSTDT        DdSozd
     C                   Z-ADD     TSTTDO        DDTHTC                                       CER054
     C                   Z-ADD     TSTTDT        DDTHTD                                       CER054
      *
      ** Threshold adjustment
      *
     C                   Z-ADD     *ZEROS        DdTadc
     C                   Z-ADD     *ZEROS        DdTadd
      *
     C                   ELSE
      *
     C                   Z-ADD     *ZEROS        DdGinc
     C                   Z-ADD     *ZEROS        DdGind
     C                   Z-ADD     *ZEROS        DdTxdc
     C                   Z-ADD     *ZEROS        DdTxdd
     C                   Z-ADD     0             DdSozc
     C                   Z-ADD     0             DdSozd
     C                   Z-ADD     *ZEROS        DDTHTC                                       CER054
     C                   Z-ADD     *ZEROS        DDTHTD                                       CER054
      *
      ** Threshold adjustment
      *
     C                   Z-SUB     TSPTHU        DdTadc
     C                   Z-SUB     TSPTUT        DdTadd
      *
     C                   ENDIF
      *
      ** Format amounts with decimal places
      *
     C                   Z-ADD     DdGinc        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RGINC = %TRIM(PZout21)
      *
     C                   Z-ADD     DdTxdc        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RTXDC = %TRIM(PZout21)
      *
     C                   Z-ADD     DdNinc        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RNINC = %TRIM(PZout21)
      *
     C                   EVAL      RSOZC = *BLANKS
      *
     C                   Z-ADD     DdSozc        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RSOZC = %TRIM(PZout21)
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      RTHTC = *BLANKS                                            CER054
     C                   Z-ADD     DDTHTC        PZFld15                                      CER054
     C                   Z-ADD     A6NBDP        PZDecs                                       CER054
     C                   EVAL      PZeCode = 'J'                                              CER054
     C                   EXSR      SRZsEdit                                                   CER054
     C                   EVALR     RTHTC = %TRIM(PZout21)                                     CER054
     C                   ENDIF                                                                CER054
      *
     C                   IF        DdTadc < *ZEROS
      *
     C                   Z-ADD     DdTadc        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RTADC = %TRIM(PZout21)
      *
     C                   ELSE
     C                   EVAL      RTADC = *BLANKS
      *
     C                   ENDIF
      *
      ** Adjustment type
      *
     C                   EVAL      RADJT = *BLANKS
      *
      ** Threshold
      *
     C                   IF        WSet = 'D'
      *
     C     TSDLLN        CHAIN     DEALS
     C                   IF        %FOUND(DEALS)
      *
      ** If Tax value at Account level is 'A', this means the EU Tax                          CER069
      ** indicator at Customer level should be used to determine whether                      CER069
      ** the account is taxable.                                                              CER069
                                                                                              CER069
     C     TAXI          IFEQ      'A'                                                        CER069
                                                                                              CER069
     C                   EVAL      PCNUM = CNUM                                               CER069
     C                   EVAL      PPBRCA= BRCA                                               CER069
                                                                                              CER069
     C                   EXSR      SRACTX                                                     CER069
                                                                                              CER069
     C                   IF        PRTCD <> *BLANKS OR AXETXS = *BLANKS                       CER069
     C                             OR AXETXS = 'S' OR AXETXS = 'E'                            CER069
     C                             OR AXETXS = 'D'                                            CER069
     C                   EVAL      TAXI = 'N'                                                 CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      TAXI = AXETXS                                              CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDIF                                                                CER069
     C                   IF        TAXI = 'T'
     C                   EVAL      RADJT = 'T'
     C                   ELSEIF    TAXI = 'Y'
     C                   EVAL      RADJT = 'Y'
     C                   ELSEIF    TAXI = 'N'
     C                   EVAL      RADJT = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WSet = 'A'                                               AR745921
     C                   MOVE      TSCUST        KCum
     C                   ELSE                                                               AR745921
     C                   MOVE      TSJOIN        KCum                                       AR745921
     C                   ENDIF                                                              AR745921
      *                                                                                     AR745921
     C                   EVAL      KCcy = TSOCCY
     C                   EVAL      KAcod = TSACOD
     C                   EVAL      KAcsq = TSACSQ
     C                   EVAL      KBrca = TSBRCA
      *
     C     KLList        CHAIN     ACCNTBXC
      *
     C                   IF        %FOUND(ACCNTBXC)
      *
      ** If Tax value at Account level is 'A', this means the EU Tax                          CER069
      ** indicator at Customer level should be used to determine whether                      CER069
      ** the account is taxable.                                                              CER069
                                                                                              CER069
     C     ATITAX        IFEQ      'A'                                                        CER069
                                                                                              CER069
     C                   EVAL      PCNUM = ATCNUM                                             CER069
     C                   EVAL      PPBRCA= ATBRCA                                             CER069
                                                                                              CER069
     C                   EXSR      SRACTX                                                     CER069
                                                                                              CER069
     C                   IF        PRTCD <> *BLANKS OR AXETXS = *BLANKS                       CER069
     C                             OR AXETXS = 'S' OR AXETXS = 'E'                            CER069
     C                             OR AXETXS = 'D'                                            CER069
     C                   EVAL      ATITAX = 'N'                                               CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      ATITAX = AXETXS                                            CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDIF                                                                CER069
     C                   IF        ATITAX = 'T'
     C                   EVAL      RADJT = 'T'
     C                   ELSEIF    ATITAX = 'Y'
     C                   EVAL      RADJT = 'Y'
     C                   ELSEIF    ATITAX = 'N'
     C                   EVAL      RADJT = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Saving A/C
      *
     C                   IF        TSMODI = 'G'
     C                   EVAL      RADJT = 'S'
     C                   ENDIF
      *
      ** Retrospective flag
      *
     C                   IF        TSMODI = 'M'
     C                   EVAL      RADJT = 'H'
     C                   ENDIF
      *
      ** Set flag > 0 cust detail printed
      *
     C                   EVAL      WfPrt1 = '1'
      *
      ** Write detail
      ** If currency is Tax currency, don't print amounts in tax
      ** currency equiv.
      *
     C                   IF        TSOCCY =  BJCYCD
      *
      ** If Solidarity feature or reversed transaction,
      ** print corresponding line
      *
     C**********         IF        DdTadc < *ZEROS                                          BUG23691
      *
     C                   Z-ADD     3             WRqdln1
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      WRqdln1 = 4                                       CER054 BUG24615
     C                   EVAL      WRqdln1 = 5                                              BUG24615
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C**********         ELSE                                                               BUG23691
      **********                                                                            BUG23691
     C**********         Z-ADD     2             WRqdln1                                    BUG23691
     C**********         ENDIF                                                              BUG23691
      *
      ** If currency is not Tax currency, print amounts in
      ** tax currency equiv.
      *
     C                   ELSE
      *
      ** If Solidarity feature or reversed transaction,
      ** print corresponding line
      *
     C**********         IF        DdTadc < *ZEROS                                          BUG23691
      *
     C                   Z-ADD     5             WRqdln1
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      WRqdln1 = 7                                                CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C**********         ELSE                                                               BUG23691
      **********                                                                            BUG23691
     C**********         Z-ADD     3             WRqdln1                                    BUG23691
     C**********         ENDIF                                                              BUG23691
      *
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   EVAL      WDifln1 = OFLLN1 - PRTLN1
     C                   IF        WDifln1 <= WRqdln1
      *
     C                   WRITE     SD000798F0
     C                   EVAL      *IN50 = *OFF                                             BUG23691
     C                   WRITE     SD000798F2                                               BUG23691
      *
     C                   ENDIF
      *
     C                   EVAL      *IN51 = *OFF
     C                   IF        TSOCCY <> BJCYCD
     C                   EVAL      *IN51 = *ON
     C                   ENDIF
      *
     C                   WRITE     SD000798F3
      *
      ** CCY <> Withholding ICD Currency : Output base ccy line
      *
     C                   IF        TSOCCY <> BJCYCD
     C                   Z-ADD     WkBcdc        A6NBDP
      *
      ** Format amounts with decimal places
      *
     C                   Z-ADD     DdGind        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RGIND = %TRIM(PZout21)
      *
     C                   Z-ADD     DdTxdd        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVALR     PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RTXDD = %TRIM(PZout21)
      *
     C                   Z-ADD     DdNind        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RNIND = %TRIM(PZout21)
      *
     C                   EVAL      RSOZD = *BLANKS
      *
     C                   Z-ADD     DdSozd        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RSOZD = %TRIM(PZout21)
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      RTHTD = *BLANKS                                            CER054
     C                   Z-ADD     DDTHTD        PZFld15                                      CER054
     C                   Z-ADD     A6NBDP        PZDecs                                       CER054
     C                   EVAL      PZeCode = 'J'                                              CER054
     C                   EXSR      SRZsEdit                                                   CER054
     C                   EVALR     RTHTD = %TRIM(PZout21)                                     CER054
     C                   ENDIF                                                                CER054
      *
     C                   IF        DdTadd < *ZEROS
      *
     C                   Z-ADD     DdTadd        PZFld15
     C                   Z-ADD     A6NBDP        PZDecs
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RTADD = %TRIM(PZout21)
      *
     C                   ELSE
      *
     C                   EVAL      RTADD = *BLANKS
      *
     C                   ENDIF
      *
      ** Write detail2
      *
     C                   WRITE     SD000798F4
      *
     C                   ENDIF
      *
      ** Write detail3
      *
     C**********         IF        DdTadc < *ZEROS                                          BUG23123
     C                   WRITE     SD000798F5
     C                   EVAL      RTHTD = *BLANKS                                          BUG26718
     C**********         ENDIF                                                              BUG23123
      *
     C                   ENDSR
      *
      *****************************************************************                    BUG23123B
      /EJECT                                                                               BUG23123B
      *****************************************************************                    BUG23123B
      *                                                               *                    BUG23123B
      *  SRStrRef - Store values for reference                        *                    BUG23123B
      *                                                               *                    BUG23123B
      *  Called By: SrDetail                                          *                    BUG23123B
      *                                                               *                    BUG23123B
      *****************************************************************                    BUG23123B
     C     SRStrRef      BEGSR                                                             BUG23123B
                                                                                           BUG23123B
     C                   MOVEL     TSINST        RefInst                                   BUG23123B
     C                   MOVEL     TSMODI        RefModi                                   BUG23123B
     C**********         MOVEL     *BLANKS       RefDate                          BUG23123B BUG25075
     C                   MOVEL     TSACOD        RefAcod                                   BUG23123B
     C**********         EVAL      Refdate = WD1Dat                               BUG23123B BUG25075
                                                                                           BUG23123B
     C                   ENDSR                                                             BUG23123B
      *****************************************************************                    BUG23123B
      /EJECT                                                                               BUG23123B
      *****************************************************************                    BUG23123B
      *                                                               *                    BUG23123B
      *  SRAddDate                                                    *                    BUG23123B
      *                                                               *                    BUG23123B
      *  Called by: SrDetail                                          *                    BUG23123B
      *                                                               *                    BUG23123B
      *****************************************************************                    BUG23123B
     C     SrAddDate     BEGSR                                                             BUG23123B
                                                                                           BUG23123B
     C                   IF        TSMODI = RefModi and TSINST = RefInst                   BUG23123B
     C                             and TSACOD = RefAcod                                    BUG23123B
                                                                                           BUG23123B
     C**********         EVAL      %SUBST(Date:1:2) = %SUBST(RefDate:1:2)         BUG23123B BUG25075
     C**********         EVAL      %SUBST(Date:3:2) = %SUBST(RefDate:3:2)         BUG23123B BUG25075
     C**********         EVAL      %SUBST(Date:5:2) = %SUBST(RefDate:5:2)         BUG23123B BUG24212
     C**********         EVAL      %SUBST(Date:5:4) = %SUBST(TSIPDT:1:4)           BUG24212 BUG25075
      **********                                                                  BUG23123B BUG25075
      ***Check*Year                                                               BUG23123B BUG25075
     C*****YY***         DIV       4             LrYr              2 0            BUG23123B BUG25075
     C**********         MVR                     Leap              2 0            BUG23123B BUG25075
      ***Check*month                                                              BUG23123B BUG25075
     C**********         Select                                                   BUG23123B BUG25075
      ***If*30*day months                                                         BUG23123B BUG25075
     C**********         WHEN      MM = 4 OR MM = 6 OR MM = 9 or MM = 11          BUG23123B BUG25075
     C**********         IF        DD < 30                                        BUG23123B BUG25075
     C*****DD***         ADD       1             DD                               BUG23123B BUG25075
     C**********         ELSE                                                     BUG23123B BUG25075
     C*****MM***         ADD       1             MM                               BUG23123B BUG25075
     C**********         Z-ADD     1             DD                               BUG23123B BUG25075
     C**********         ENDIF                                                    BUG23123B BUG25075
      **********                                                                  BUG23123B BUG25075
     C**********         WHEN      MM = 2                                         BUG23123B BUG25075
     C**********         IF        DD < 28                                        BUG23123B BUG25075
     C*****DD***         ADD       1             DD                               BUG23123B BUG25075
     C**********         ELSE                                                     BUG23123B BUG25075
     C**********         IF        Leap =  0                                      BUG23123B BUG25075
      **********                                                                   BUG24212 BUG25075
     C**********         IF        DD < 29                                         BUG24212 BUG25075
     C*****DD***         ADD       1             DD                               BUG23123B BUG25075
     C**********         ELSE                                                      BUG24212 BUG25075
     C*****MM***         ADD       1             MM                                BUG24212 BUG25075
     C**********         Z-ADD     1             DD                                BUG24212 BUG25075
     C**********         ENDIF                                                     BUG24212 BUG25075
      **********                                                                   BUG24212 BUG25075
     C**********         ELSE                                                     BUG23123B BUG25075
     C*****MM***         ADD       1             MM                               BUG23123B BUG25075
     C**********         Z-ADD     1             DD                               BUG23123B BUG25075
     C**********         ENDIF                                                    BUG23123B BUG25075
     C**********         ENDIF                                                    BUG23123B BUG25075
      **********                                                                  BUG23123B BUG25075
     C**********         WHEN      MM = 12                                        BUG23123B BUG25075
     C**********         IF        DD < 31                                        BUG23123B BUG25075
     C*****DD***         ADD       1             DD                               BUG23123B BUG25075
     C**********         ELSE                                                     BUG23123B BUG25075
     C**********         Z-ADD     1             DD                               BUG23123B BUG25075
     C**********         Z-ADD     1             MM                               BUG23123B BUG25075
     C*****YY***         ADD       1             YY                               BUG23123B BUG25075
     C**********         ENDIF                                                    BUG23123B BUG25075
      **********                                                                  BUG23123B BUG25075
     C**********         OTHER                                                    BUG23123B BUG25075
     C**********         IF        DD < 31                                        BUG23123B BUG25075
     C*****DD***         ADD       1             DD                               BUG23123B BUG25075
     C**********         ELSE                                                     BUG23123B BUG25075
     C*****MM***         ADD       1             MM                               BUG23123B BUG25075
     C**********         Z-ADD     1             DD                               BUG23123B BUG25075
     C**********         ENDIF                                                    BUG23123B BUG25075
      **********                                                                  BUG23123B BUG25075
     C**********         ENDSL                                                    BUG23123B BUG25075
      **********                                                                  BUG23123B BUG25075
     C**********         MOVE      Date          RITD1                            BUG23123B BUG24212
     C**********         EVAL      WItd1 = %SUBST(Date:1:4) +                      BUG24212 BUG25075
     C**********                           %SUBST(Date:7:2)                        BUG24212 BUG25075
     C**********         MOVE      WItd1         RITD1                             BUG24212 BUG25075
     C     TSSLID        ADD       1             PZDayNo                                    BUG25075
     C                   EXSR      SRZDate2                                                 BUG25075
     C                   Z-ADD     PZDate        RITD1                                      BUG25075
     C                   MOVE      WD1Dat        RITD2                                     BUG23123B
     C                                                                                     BUG23123B
     C                   ELSE                                                              BUG23123B
     C                   Z-ADD     PZDate        RITD1                                     BUG23123B
     C                   MOVE      WD1Dat        RITD2                                     BUG23123B
     C                                                                                     BUG23123B
     C                   ENDIF                                                             BUG23123B
                                                                                           BUG23123B
     C                   ENDSR                                                             BUG23123B
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCuste - Customer ende                                      *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZsEdit                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCuste       BEGSR
      *
      ** Format amounts with decimal places
      *
     C                   Z-ADD     WkBcdc        A6NBDP
      *
     C                   Z-ADD     WTuthr        PZFld15
     C**********         Z-ADD     A6NBDP        PZDecs                                     CER048A
     C**********         Z-ADD     *ZEROS        PZDecs                             CER048A BUG23319
     C                   Z-ADD     A6NBDP        PZDecs                                     BUG23319
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RUUTHR = %TRIM(PZout21)
      *
     C                   Z-ADD     WTutil        PZFld15
     C**********         Z-ADD     A6NBDP        PZDecs                                     CER048A
     C**********         Z-ADD     *ZEROS        PZDecs                             CER048A BUG23319
     C                   Z-ADD     A6NBDP        PZDecs                                     BUG23319
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RUUTIL = %TRIM(PZout21)
      *
     C                   Z-ADD     WTexce        PZFld15
     C**********         Z-ADD     A6NBDP        PZDecs                                     CER048A
     C**********         Z-ADD     *ZEROS        PZDecs                             CER048A BUG23319
     C                   Z-ADD     A6NBDP        PZDecs                                     BUG23319
     C                   EVAL      PZeCode = 'J'
     C                   EXSR      SRZsEdit
     C                   EVALR     RUEXCE = %TRIM(PZout21)
      *                                                                                     BUG23732
     C                   Z-ADD     WTgint        PZFld15                                    BUG23732
     C                   Z-ADD     A6NBDP        PZDecs                                     BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   EVALR     RUGINT = %TRIM(PZout21)                                  BUG23732
      *                                                                                     BUG23732
     C                   Z-ADD     WTttax        PZFld15                                    BUG23732
     C                   Z-ADD     A6NBDP        PZDecs                                     BUG23732
     C                   EXSR      SRZsEdit                                                 BUG23732
     C                   EVALR     RUTTAX = %TRIM(PZout21)                                  BUG23732
      *
     C                   IF        WfPrt1 = '1'
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C**********         Z-ADD     7             WRqdln1                                    BUG24615
     C                   Z-ADD     13            WRqdln1                                    BUG24615
     C                   EVAL      WDifln1 =  OFLLN1 - PRTLN1
      *
     C                   IF        WDifln1 <= WRqdln1
     C                   WRITE     SD000798F0
     C                   ENDIF
      *
      ** if mindestens 1 cust detail printed: write cust.ende fmt
      *
     C                   WRITE     SD000798F6
      *
      ** else: write "no details"
      *
     C                   ELSE
     C                   WRITE     SD000798F8
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C**********         Z-ADD     4             WRqdln1                                    BUG24615
     C                   Z-ADD     5             WRqdln1                                    BUG24615
     C                   EVAL      WDifln1 = OFLLN1 - PRTLN1
      *
     C                   IF        WDifln1 <= WRqdln1
     C                   WRITE     SD000798F0
     C                   ENDIF
      *
     C                   WRITE     SD000798F7
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *  Called by: SRInit                                            *
      *                                                               *
      *  Calls: SRAudit                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
      *
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRRcfau                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** RCF Processing
      *
     C                   EXSR      SRRcfau
      *
      ** Output Report Header
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON OR
     C                             *INU8 = *ON
      *
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   WRITE     NODTLS
      *
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcfp1 - Subroutine to register the P1 Printer File via RCF.*
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRcfp1       BEGSR
      *
     C                   OPEN      SD000798P1
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        PZsnum
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PRseq         PSeq
     C                   PARM      *BLANKS       PSenty
     C                   PARM                    SFILE1
     C                   PARM                    PZsnum
     C                   PARM      *BLANK        PZserr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZserr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcfau - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
      *  Called by: SRAudit                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRcfau       BEGSR
      *
     C                   OPEN      SD000798AU
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        PZsnum
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PRseq         PSeq
     C                   PARM      *BLANKS       PSenty
     C                   PARM                    SFILEU
     C                   PARM                    PZsnum
     C                   PARM      *BLANK        PZserr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZserr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Receive parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRseq
     C                   PARM                    PRparm
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '*BLANKS'
     C                   EVAL      DBPGM = 'SD000798'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      ** MMDDYY (*IN98 on).
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
      ** Call Access Program for Currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCYCD        PKey
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = 'BJCYCD'
     C                   EVAL      DBPGM = 'SD000798'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** As the Exemption Threshold are defined in 'DEM' but with
      ** zero decimal place, to compare Exemption Threshold to
      ** Utilisation Up to Threshold, we have to add the decimal
      ** positions to Exemption Threshold.
      *
     C                   EVAL      WkMult = 1
     C     1             DO        A6NBDP
     C                   EVAL      WkMult = WkMult * 10
     C                   ENDDO
     C                   EVAL      WkBcdc = A6NBDP
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
     C                   EVAL      DBASE  = 008                                             BUG24935
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
     C                   EVAL      DBASE  = 009                                             BUG24935
     C                   OUT       LDA                                                      BUG24935
     C                   EXSR      *PSSR                                                    BUG24935
     C                   ELSE                                                               BUG24935
     C                   IF        A4ETXY <> *ZERO                                          BUG24935
      * Get current year                                                                    BUG24935
     C                   MOVE      BJMRDT        WWYear                                     BUG24935
     C                   MOVE      WWYear        PDayNo                                     BUG24935
     C                   MOVEL     A4ETXY        PDayNo                                     BUG24935
      *                                                                                     BUG24935
     C                   CALL      'ZDATE1'                                                 BUG24935
     C                   PARM      *BLANKS       PErr                                       BUG24935
     C                   PARM                    PDayNo                                     BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *ZEROS        PDayNo1                                    BUG24935
     C                   Z-ADD     PDayNo1       WETYear           5 0                      BUG24935
      *                                                                                     BUG24935
     C                   IF        WETYear <  BJRDNB                                        BUG24935
     C                   ADD       1             WWYear                                     BUG24935
     C                   MOVE      WWYear        PDayNo                                     BUG24935
     C                   MOVEL     A4ETXY        PDayNo                                     BUG24935
      *                                                                                     BUG24935
     C                   CALL      'ZDATE1'                                                 BUG24935
     C                   PARM      *BLANKS       PErr                                       BUG24935
     C                   PARM                    PDayNo                                     BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *ZEROS        PDayNo1                                    BUG24935
     C                   Z-ADD     PDayNo1       WETYear                                    BUG24935
     C                   ENDIF                                                              BUG24935
      *                                                                                     BUG24935
     C                   IF        PYear <> *BLANKS                                         BUG24935
     C                   MOVE      PYear         WWYeaR                                     BUG24935
     C                   ELSE                                                               BUG24935
     C                   MOVE      PDayNo        WWYeaR                                     BUG24935
     C                   ENDIF                                                              BUG24935
      *                                                                                     BUG24935
     C                   MOVE      WWYear        PDayNo                                     BUG24935
     C                   MOVEL     A4ETXY        PDayNo                                     BUG24935
      *                                                                                     BUG24935
     C                   CALL      'ZDATE1'                                                 BUG24935
     C                   PARM      *BLANKS       PErr                                       BUG24935
     C                   PARM                    PDayNo                                     BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *ZEROS        PDayNo1                                    BUG24935
     C                   Z-ADD     PDayNo1       WEYear                                     BUG24935
     C                   ENDIF                                                              BUG24935
     C                   ENDIF                                                              BUG24935
      *
     C                   EVAL      WP1rcf = 'N'
     C                   Z-ADD     0             WCount
     C                   Z-ADD     0             WRqdln1
     C                   Z-ADD     0             WDifln1
      *
      ** Report Title
      ** Identify Selected Year for Report Title from Filename
      ** parameter
      *
     C                   IF        PYear = *BLANKS
     C                   EVAL      RDYRD = 'Current'
     C                   ELSE
     C                   MOVEL     PYear         RDYRD
     C                   ENDIF
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      PZDayNo = BJEYD                                 BUG24280 BUG24935
     C**********         EXSR      SRZDate2                                        BUG24280 BUG24935
     C**********         MOVE      PZDate        WwYr                              BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         IF        PYear <> *BLANKS                                BUG24280 BUG24935
     C**********         MOVE      PYear         WWYeaR                            BUG24280 BUG24935
     C**********         ELSE                                                      BUG24280 BUG24935
     C**********         MOVE      WwYr          WWYeaR                            BUG24280 BUG24935
     C**********         ENDIF                                                     BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
      ***Get*the Start and End of Tax Year                                         BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         IF        WWYeaR <> WwYr                                  BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
      ***Convert the End of Year Date No. to DDMMYY format                         BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WEtaxYr = PZDate                                BUG24280 BUG24935
     C**********         MOVE      WWYeaR        WETaxYr                           BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
      ***Convert the End of Year in DDMMYY format into Day No                      BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         CALL      'ZDATE1'                                        BUG24280 BUG24935
     C**********         PARM      *BLANKS       PErr                              BUG24280 BUG24935
     C**********         PARM      WETaxYr       PDayNo                            BUG24280 BUG24935
     C**********         PARM                    BJDFIN                            BUG24280 BUG24935
     C**********         PARM      *ZEROS        PDayNo1                           BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WEYear = PDayNo1                                BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         ELSE                                                      BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WEYear = BJEYD                                  BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         ENDIF                                                     BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WJeyd = BJEYD + 1                               BUG24280 BUG24935
     C                   EVAL      WJeyd = WEYear + 1                                       BUG24935
      *                                                                                     BUG24280
      ** Convert the End of Year Date No. plus 1 to DDMMYY format                           BUG24280
      *                                                                                     BUG24280
     C                   EVAL      PZDayNo = WJeyd                                          BUG24280
     C                   EXSR      SRZDate2                                                 BUG24280
     C                   EVAL      WStaxYr = PZDate                                         BUG24280
     C                   MOVEL     WStaxYr       WStaxYrA                                   BUG24280
     C                   EVAL      WDdMm = %SUBST(WStaxYrA:1:4)                             BUG24280
      *                                                                                     BUG24280
     C                   IF        WWYeaR <= 39                                             BUG24280
     C                   MOVEL     20            TYear                                      BUG24280
     C                   ELSE                                                               BUG24280
     C                   MOVEL     19            TYear                                      BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      WWYeaR        TYear                                      BUG24280
      *                                                                                     BUG24280
     C**********         IF        WDdMm <> '0101'                                 BUG24280 BUG24935
     C                   IF        ((A4ETXY <> 3112 AND BJDFIN = 'D')                       BUG24935
     C                             OR (A4ETXY <> 1231 AND BJDFIN = 'M'))                    BUG24935
     C                             AND WETYear >= BJRDNB                                    BUG24935
     C                   EVAL      TYear = TYear - 1                                        BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      TYear         WYear                                      BUG24280
     C                   MOVE      WYear         WSTaxYr                                    BUG24280
      *                                                                                     BUG24280
      ** Convert the End of Year in DDMMYY format into Day No                               BUG24280
      *                                                                                     BUG24280
     C                   CALL      'ZDATE1'                                                 BUG24280
     C                   PARM      *BLANKS       PErr                                       BUG24280
     C                   PARM      WSTaxYr       PDayNo                                     BUG24280
     C                   PARM                    BJDFIN                                     BUG24280
     C                   PARM      *ZEROS        PDayNo1                                    BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WSYear = PDayNo1                                         BUG24280
      *
      ** Selection by single Customer
      *
     C                   IF        PCust <> *BLANKS
      *
     C                   EVAL      WkCus = PCust
     C     ArrSet(1)     CAT       WkCus:1       RSETX
      *
     C                   ENDIF
      *
      ** Selection by Customer 'From' 'To'
      *
     C                   IF        PCustf <> *BLANKS AND
     C                             PCustt <> *BLANKS
      *
     C                   EVAL      WkCusf = PCustf
     C                   EVAL      WkCust = PCustt
     C     ArrSet(2)     CAT       WkCusf:1      RSETX
     C     RSETX         CAT       'TO':1        RSETX
     C     RSETX         CAT       WkCust:1      RSETX
      *
     C                   ENDIF
      *
      ** Selection by Tax Type
      *
     C                   IF        PTaxt <> *BLANKS
      *
     C                   EVAL      WkTax = PTaxt
     C     ArrSet(4)     CAT       WkTax:1       RSETX
      *
     C                   ENDIF
      *
      ** Selection by Account Officer
      *
     C                   IF        PAcof <> *BLANKS
      *
     C                   EVAL      WkAcof = PAcof
     C     ArrSet(3)     CAT       WkAcof:1      RSETX
      *
     C                   ENDIF
      *
      ** Selection by Branch code
      *
     C                   IF        PBrca <> *BLANKS
      *
     C                   EVAL      WkBran = PBrca
     C     ArrSet(5)     CAT       WkBran:1      RSETX
      *
     C                   ENDIF
      *
      ** Selection by 'ALL'
      *
     C                   IF        PAll <> *BLANKS
     C                   EVAL      RSETX = ArrSet(6)
     C                   ENDIF
      *
     C     KLList        KLIST
     C                   KFLD                    KCum
     C                   KFLD                    KCcy
     C                   KFLD                    KAcod
     C                   KFLD                    KAcsq
     C                   KFLD                    KBrca
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRTCD                                        CER054
     C                   PARM      '*VERIFY'     POPTN                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   MOVE      'N'           CER054                                       CER054
     C                   MOVE      *OFF          *IN52                                        CER054
     C     PRTCD         IFEQ      *BLANKS                                                    CER054
     C                   MOVE      'Y'           CER054                                       CER054
     C                   MOVE      *ON           *IN52                                        CER054
     C                   ENDIF                                                                CER054
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZsEdit - Convert amount from file format to screen format  *
      *                                                               *
      *  Called by: SRJsum, SRDetai, SRCuste                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZSEdit      BEGSR
      *
     C                   CALL      'ZSEDIT'
      *
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM                    PZeCode
     C                   PARM                    PZout21
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert date from file format to screen format    *
      *                                                               *
      *  Called by: SRDetai                                           *
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
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                AR745921
      *****************************************************************                     AR745921
      *                                                               *                     AR745921
      *  SRRtvNonAcc - Access Non Account Holder details              *                     AR745921
      *                                                               *                     AR745921
      *  Called by: SRJsum                                            *                     AR745921
      *                                                               *                     AR745921
      *  Calls:                                                       *                     AR745921
      *                                                               *                     AR745921
      *****************************************************************                     AR745921
      *                                                                                     AR745921
     C     SRRtvNonAcc   BEGSR                                                              AR745921
                                                                                            AR745921
     C                   CALL      'AONAHOR0'                                               AR745921
     C                   PARM      *Blanks       PRtcd                                      AR745921
     C                   PARM      '*KEY   '     POptn                                      AR745921
     C                   PARM                    PNonAccnt        10                        AR745921
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      AR745921
                                                                                            AR745921
      ** No Record Found/ Error Encountered                                                 AR745921
                                                                                            AR745921
     C                   IF        PRtcd <> *BLANKS                                         AR745921
     C                   EVAL      NHNARN = *BLANKS                                         AR745921
     C                   ENDIF                                                              AR745921
                                                                                            AR745921
     C                   ENDSR                                                              AR745921
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
     C                   PARM                    PCNUM                                        CER069
     C                   PARM                    PPBRCA                                       CER069
     C     SDACTX        PARM      SDACTX        DSFDY                                        CER069
                                                                                              CER069
     C                   ENDSR                                                                CER069
      *****************************************************************                     AR745921
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
**  ArrSet (30)  Auswahl/Steuerung  (Report Text)
INDIVIDUAL CUSTOMER=          CUSTOMER:
ACCOUNT OFFICER=              TAX TYPE=
BRANCH CODE=                  ALL
