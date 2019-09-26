     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUDUPD - Additional Customer Details Database Update      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 MD026854           Date 29May14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26917A          Date 27Jan10               *
      *                 BUG26917           Date 20Jan10               *
      *                 BUG26868           Date 12Jan10               *
      *                 262430             Date 05Nov09               *
      *                 BUG26505           Date 20Oct09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24294           Date 19Jun09               *
      *                 BUG24051A          Date 01Jun09               *
      *                 BUG24051           Date 28May09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23800           Date 22Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG23135           Date 27Feb09               *
      *                 BUG22578A          Date 17Feb09               *
      *                 BUG22529           Date 11Feb09               *
      *                 BUG22715           Date 10Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 06Jul07               *
      *                 BUG10069           Date 25Jan06               *
      *                 CSD029             Date 22Aug05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate                          *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *           (Recompile)                                         *
      *  BUG26917A - Reverse fix for bug26917                         *
      *  BUG26917 - COB error when customer is declared as taxable    *
      *           w/ German features installed and no additional      *
      *           customers information is set up                     *
      *  BUG26868 - Thresholds Application is Incorrect.              *
      *  262430 - DBErr on amend of additional customer details.      *
      *           Check customer shadow file.                         *
      *  BUG26505 - Inserted data in the State Code field disappeared *
      *             during enquiry                                    *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24294 - SDTHRHPD not getting updated when threshold is    *
      *             reverted to 0                                     *
      *  BUG24051A - Incorrect Threshold Utilisation Postings         *
      *  BUG24051 - Incorrect Threshold Utilisation Postings          *
      *  BUG23732 - Joint Account Threshold                           *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23800 - Current Threshold incorrectly updated in          *
      *             SDTHRHPD file due to incorrect logical file       *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG23135 - Set 'Statement Required Flag' to 'Y' for Taxable  *
      *             Customers                                         *
      *  BUG22578A - Amend screen flow for German Taxes               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22715 - Limit Utilisation Enquiry displaying incorrect    *
      *             data                                              *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  CER034 - German Features - New Fields and Enquiries          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  CSD029 - Customer Details Additional Fields.                 *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************


      * Midas SD Additional Customer Details File
     FSDACUSL0  UF A E           K DISK    COMMIT

      * Midas SD Standing Data Controls index
     FSDFCTLL0  UF A E           K DISK    COMMIT
                                                                                              CGL132
      ** FATCA Customer details file                                                          CGL132
     FSDFTCSL0  UF   E           K DISK    COMMIT                                             CGL132

      * Customer Details File - by Customer number
     FSDCUSTL1  IF   E           K DISK    PREFIX(C_)
                                                                                            BUG10069
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    PREFIX(C_)                                       BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
      *                                                                                    BUG22578A
      ** Midas SD Interest  Payment History File                                           BUG22578A
      *                                                                                    BUG22578A
     FSDINPHL0  UF A E           K DISK    COMMIT                                          BUG22578A
      *                                                                                    BUG22578A
      ** Midas SD Interest  Payment History File                                           BUG22578A
      *                                                                                    BUG22578A
     FSDACTXL1  IF A E           K DISK                                                    BUG22578A
      *                                                                                       CER034
      ** Midas SD Exemption Threshold History File                                            CER034
      *                                                                                       CER034
     F***SDTHRHL0  UF A E           K DISK    COMMIT                                 CER034 BUG23800
     FSDTHRHL3  UF A E           K DISK    COMMIT                                           BUG23800
      *                                                                                     BUG26868
      ** Midas SD Joint Account Member File                                                 BUG26868
      *                                                                                     BUG26868
     FSDJACCL4  IF A E           K DISK                                                     BUG26868


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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Rename fields for Timestamp checking
     D ChkACUDFmt    E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(CH)

      ** Externally desc'd DS for valid transactions Detail
     D SDVACUD       E DS                  EXTNAME(SDVACUDPD)
     D                                     PREFIX(A_)

      * Error indicators
     D OKTrnDets     E DS                  EXTNAME(SDEACUDPD)

      **  Externally described DS for 'BEFORE UPDATE' SDACUSPD
     D B_SDACUS      E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(B_)

      **  Transaction Details File
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Data Structures for use with access programs

      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CER034
      ** Long DS for access programs, long data structure                                     CER034
      *                                                                                       CER034
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CER034
      *                                                                                    BUG22578A
      ** External DS based on Customer                                                     BUG22578A
      *                                                                                    BUG22578A
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                               BUG22578A
      *                                                                                    BUG22578A
      ** External DS based on Country of Tax                                               BUG22578A
      *                                                                                    BUG22578A
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                               BUG22578A
      *                                                                                    BUG22578A
      ** External DS based on Branch file                                                  BUG22578A
      *                                                                                    BUG22578A
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                               BUG22578A
     D  WQQDFAC      E                     EXTFLD(QQDFAC)                                  BUG22578A
      *                                                                                    BUG22578A
      ** External DS based on Location Codes                                               BUG22578A
      *                                                                                    BUG22578A
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                               BUG22578A

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)

      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Midas SD Midas modules Data Structure                                                CSW207
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSW207
                                                                                              CSW207
     D SysVal1         C                   'FATCACountryofTax'                                CGL132
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Outward parameters
      ** RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      ** I :  File name
     D    PBFNME               1     10
      ** I :  Long Key
     D    PBLKEY              11     60
      ** I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      ** I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      ** I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      ** I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      ** I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      ** I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      ** I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      ** I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      ** I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      ** I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      ** I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      ** I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      ** I :  Last Change Date
     D    PBLCD             3061   3063P 0
      ** I :  Type of Last Change
     D    PBTYLC            3064   3064

     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000


      ** Parameter for *Entry
     D P@Rtcd          S              7A
     D DDACTN          S              1A

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A

      ** Parameter for SDACUDRTV
     D P@MODE          S              6A
     D P@RSMD          S              1A
     D FOTRID          S             20A
     D MidasTrNum      S              6A
     D PSDACUDENQ      S              1A
     D DDACTNOK        S              1A
     D DDCUSTOK        S              1A
     D Ix              S              3P 0
     D WIdx            S              3P 0                                                    CER034

      ** Parameter for ZARTVJOBA
     D PReturn         S              6A
     D PType           S              1A

      ** Parameter for ZAMSGTOOPR
     D MsgSndRtn       S             10A
     D DBError         S            132A


     D SValK1          S             20                                                       CGL132
     D SVal1           S            200                                                       CGL132
     D SValK2          S             20                                                       CGL132
     D SVal2           S            200                                                       CGL132
     D SValK3          S             20                                                       CGL132
     D SVal3           S            200                                                       CGL132
     D SValK4          S             20                                                       CGL132
     D SVal4           S            200                                                       CGL132
     D SValK5          S             20                                                       CGL132
     D SVal5           S            200                                                       CGL132
     D SValK6          S             20                                                       CGL132
     D SVal6           S            200                                                       CGL132
     D SValK7          S             20                                                       CGL132
     D SVal7           S            200                                                       CGL132
     D SValK8          S             20                                                       CGL132
     D SVal8           S            200                                                       CGL132
     D SValK9          S             20                                                       CGL132
     D SVal9           S            200                                                       CGL132
     D SValK0          S             20                                                       CGL132
     D SVal10          S            200                                                       CGL132
     D WCTAX           S              2A                                                      CGL132
                                                                                              CGL132
      ** Parameter for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A

      ** Parameter for ZAGENTMSTM
     D @Timestamp      S             26Z

      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0

      ** Work Variables
     D WDayMnt         S              4A
     D WCCYY           S              4A
     D WNCCYY          S              4P 0
     D WDay            S              2A
     D WMonth          S              2A
     D WYear           S              2A
     D WFlName         S              8A
     D WUNoRC          S              5P 0
     D WUNoAM          S              5P 0
     D WUNoDL          S              5P 0
     D WUNoIN          S              5P 0
     D W0RTN           S              7A

      ** Other Variables
     D C               S              2P 0

      ** Fields defined for Calling SDACUDLOG

     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PCustNum        S             18A
     D PACustNo        S             18A
     D PTimestamp      S             26A
     D PSard           S              6A
     D CSD029          S              1A                                                      CSD029
     D CGL132          S              1A                                                      CGL132
     D CGL133          S              1A                                                      CGL132

      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1A                                                      CSW207
     D CSD092          S              1A   INZ('N')                                           CSD092
     D PCUST           S              6A                                                      CSD092
     D PBefCUST        S           5000A                                                      CSD092
     D PAftCUST        S           5000A                                                      CSD092
     D PBefACUS        S           5000A                                                      CSD092
     D PAftACUS        S           5000A                                                      CSD092
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefJACC        S           5000A                                                      CSD092
     D PAftJACC        S           5000A                                                      CSD092
     D PBefCUAH        S           5000A                                                      CSD092
     D PAftCUAH        S           5000A                                                      CSD092
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PACRV           S              1A                                                      CSD092
     D PELEC           S              1A                                                      CGL132
                                                                                              CSD092
                                                                                              CSW207
     D CER034          S              1A                                                      CER034
     D CER038          S              1A                                                      CER034
     D CER041          S              1A                                                      CER034
     D CER047          S              1A                                                      CER034
     D CER048          S              1A                                                      CER034
     D CER054          S              1A                                                      CER054
     D CER045          S              1A                                                      CER045
     D CER069          S              1A                                                      CER069
     D CER050          S              1A                                                      CER050
     D PCusn           S             10A                                                      CER034
     D KFCust          S             10A                                                      CER034
     D PCntry          S              2A                                                   BUG22578A
     D PColc           S              2A                                                   BUG22578A
     D KFCusn          S              6A                                                   BUG22578A
     D KFCTax          S              2A                                                   BUG22578A
     D PKySt           S              7A                                                   BUG22578A
     D WUpdate         S              1A                                                   BUG22578A
      *                                                                                       CER034
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************

      *                                                                                    BUG22578A
      ** Do not update History files if first run                                          BUG22578A
      *                                                                                    BUG22578A
     C                   IF        P@Rtcd = '*NOUPD'                                       BUG22578A
     C                   EVAL      WUpdate = 'N'                                           BUG22578A
     C                   EVAL      P@Rtcd = *BLANKS                                        BUG22578A
     C                   ELSE                                                              BUG22578A
     C                   EVAL      WUpdate = 'Y'                                           BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.

     C                   EXSR      SRChkOthUpd

     C                   IF        P@Rtcd <> *Blanks
     C                   GOTO      EXIT
     C                   ENDIF

      ** Get Customer Details

     C                   EXSR      SRGetCust

      ** Insert, Amend or Delete the Customer

     C     A_ACTYLC      CASEQ     'I'           SRInsert
     C     A_ACTYLC      CASEQ     'A'           SRAmend
     C     A_ACTYLC      CASEQ     'D'           SRDelete
     C     A_ACTYLC      CASEQ     'C'           SRClose                                    BUG23518
     C     A_ACTYLC      CASEQ     'R'           SRRelease                                  BUG23518
     C                   ENDCS
      *                                                                                       CER034
      ** Check for the swithcable feature CER048                                              CER034
      *                                                                                       CER034
     C**********         IF        CER048 = 'Y'                                     CER034 BUG22578A
     C                   IF        CER048 = 'Y' AND                                        BUG22578A
     C                             WUpdate = 'Y'                                           BUG22578A
     C                   EXSR      SRWrThrh                                                   CER034
     C                   ENDIF                                                                CER034
    *                                                                                         CER034
      ** If 24x7 Midas Availability is installed
      ** and Support System is active

     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)

     C                   CALLB     'SDACUDLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    SDACUS
     C                   PARM                    TRANSDTL

      ** If there is no error, write the log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'SDACUD'
     C                   EVAL      APFOTRANID = A_ACFRNT
     C                   EVAL      APRPRLOCN  = A_ACREPA
     C                   EVAL      APUSERID   = PSUser
     C                   EVAL      APMIDUSR   = PSUser

     C                   MOVEL     A_ACCUST      PCustNum

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       PTimestamp
     C                   PARM                    PCustNum
     C                   PARM      *BLANKS       PACustNo

     C                   ENDIF

      ** If there is an error in either log file, end program

     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      P@RTCD = '*ERROR'
     C                   ENDIF

     C                   ENDIF
      ** Exit From Program

     C     EXIT          TAG

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkOthUpd - Check for update by another workstation         *
      *                                                               *
      *****************************************************************
     C     SRChkOthUpd   BEGSR

      ** Retrieve current Customer details

     C                   EVAL      MidasTrNum = A_ACCUST

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)

     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType

      ** Allow access to transaction record by Front-Office ID when in Repair
      ** mode for inserts . Set  *RTV module  parameter P@MODE  to   *FRONT
      ** if the pgm is:  a) running in Interactive mode - PType = 1  ~~~~~~
      **                 b) action code is Insert - 'I'
      **                 c) Front-Office Id is NOT Blank

     C                   IF        PType = '1' and
     C                             A_ACTYLC = 'I' and
     C                             A_ACFRNT <> *Blanks

     C                   EVAL      P@MODE = '*FRONT'

     C                   ELSE

      ** Otherwise, if running in batch use Front-Office ID
      **            (if insert)
      **            else, use Midas Deal Number

     C                   IF        PType = '0' and
     C                             A_ACTYLC = 'I'
     C                   EVAL      P@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      P@MODE = *Blanks
     C                   ENDIF

     C                   ENDIF

     C                   CALLB     'SDACUDRTV'

      ** Inputs
      ** Return code
     C                   PARM      *Blanks       RetCodeOut

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    P@MODE

      ** Response mode
     C                   PARM      *Blanks       P@RSMD

      ** Action Code
     C                   PARM      A_ACTYLC      DDACTN

      ** Front Office Transaction ID
     C                   PARM      A_ACFRNT      FOTRID

      ** Midas Transaction Number
     C                   PARM                    MidasTrNum

rgc   ** Value is 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
rgc  C                   PARM                    PSDACUDENQ


      ** Outputs
      ** Transaction Details in File Format
     C                   PARM                    ChkACUDFmt

      ** OK - Action code
     C                   PARM      *Blanks       DDACTNOK

      ** OK - Transaction Number
     C                   PARM                    DDCUSTOK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       FldNameArr
     C                   PARM      *Blanks       MsgIdArr
     C                   PARM      *Blanks       MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM      *Zeros        Ix

      *                                                                                       CER034
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
      *                                                                                       CER034
     C                   PARM                    WIdx                                         CER034
      *                                                                                       CER034
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C                   IF        PType = '1'

     C                   IF        A_ACTYLC <> 'I'  and
     C                             CHE5TMST <> A_ACTMST
     C                   EVAL      P@Rtcd = '*RECUPD'
     C                   ENDIF

      ** Batch mode:

     C                   ELSE
     C                   IF        DDACTNOK = 'N' or
     C                             DDCUSTOK = 'N'
     C                   EVAL      P@Rtcd = '*RECUPD'
     C                   Z-ADD     1             C

     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *Blanks
     C                   CLEAR                   DBError
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsert - Insert an Additional Customer details              *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR

      ** Access Transaction Details

     C     A_ACCUST      CHAIN     SDACUSL0                             99

      ** Database error

     C                   IF        %Found(SDACUSL0)
     C                   EVAL      DBKEY  = A_ACCUST
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      SRErr
     C                   ENDIF

      ** Initialize Transaction Detail

     C                   CLEAR                   SDACUS

      ** Store Old fields for comparisons

     C                   EVAL      B_SDACUS = SDACUS

      ** Set Transaction fields on insert

     C                   EVAL      E5CUST = A_ACCUST
     C                   EVAL      E5LCD  = A_ACLCD
     C                   EVAL      E5TYLC = A_ACTYLC
     C                   EVAL      E5ALTN = A_ACALTN
     C                   EVAL      E5IDNO = A_ACIDNO
     C                   EVAL      E5FXNB = A_ACFXNB
     C                   EVAL      E5TXNB = A_ACTXNB
     C                   EVAL      E5DOLV = A_ACDOLV
     C                   EVAL      E5PRVO = A_ACPRVO
     C                   EVAL      E5MDTL = A_ACMDTL
     C                   EVAL      E5CNA1 = A_ACCNA1
     C                   EVAL      E5CNA2 = A_ACCNA2
     C                   EVAL      E5CNA3 = A_ACCNA3
     C                   EVAL      E5CNA4 = A_ACCNA4
     C                   EVAL      E5CWL1 = A_ACCWL1
     C                   EVAL      E5CWL2 = A_ACCWL2
     C                   EVAL      E5CWL3 = A_ACCWL3
     C                   EVAL      E5CWL4 = A_ACCWL4
     C                   EVAL      E5CWL5 = A_ACCWL5
     C                   EVAL      E5CITY = A_ACCITY
     C                   EVAL      E5ZIPC = A_ACZIPC
     C                   EVAL      E5TINO = A_ACTINO
     C                   EVAL      E5IDTP = A_ACIDTP
     C                   EVAL      E5ISCT = A_ACISCT
     C                   EVAL      E5ISDT = A_ACISDT
     C                   EVAL      E5BTHC = A_ACBTHC
     C                   EVAL      E5BTHT = A_ACBTHT
     C                   EVAL      E5JATP = A_ACJATP
     C                   EVAL      E5REPI = A_ACREPI
     C                   EVAL      E5CSSN = C_BBCSSN

      ** Format Date of Birth

     C                   EVAL      E5DBTH = A_ACDBTH
     C                   MOVE      A_ACDBTH      WDayMnt
     C                   MOVEL     A_ACDBTH      WCCYY
     C                   MOVEL     WCCYY         E5BRT2
     C                   MOVE      WCCYY         WYear
     C                   MOVE      WCCYY         WNCCYY

     C                   MOVEL     WDayMnt       WMonth
     C                   MOVE      WDayMnt       WDay

     C                   IF        BJDFIN = 'M'
     C                   EVAL      E5BRT1 = WMonth + WDay + WYear
     C                   ELSE
     C                   EVAL      E5BRT1 = WDay + WMonth + WYear
     C                   ENDIF

     C                   IF        WNCCYY > 1972  and
     C                             WNCCYY < 2071

     C                   CALLB     'ZDATE1'
     C                   PARM      E5BRT1        DateIn
     C     E5BRTH        PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

     C                   ELSE
     C                   EVAL      E5BRTH = *Zeros
     C                   ENDIF

      ** Front Office ID

     C                   EVAL      E5FRNT = A_ACFRNT

      ** Repair Location

     C                   EVAL      E5REPA = A_ACREPA

      ** Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     E5TMST

      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.

     C                   IF        CSC011 = 'Y'
     C                   IF        E5FRNT = *BLANKS
     C                   EVAL      E5FRNT = 'MD' + A_ACCUST
     C                   ENDIF
     C                   ENDIF
                                                                                              CSD029
      ** Insert the Additional field details when CSD029 is on                                CSD029
     C     CSD029        IFEQ      'Y'                                                        CSD029
     C                   EVAL      E5FL01 = A_ACFL01                                          CSD029
     C                   EVAL      E5FL02 = A_ACFL02                                          CSD029
     C                   EVAL      E5FL03 = A_ACFL03                                          CSD029
     C                   EVAL      E5FL04 = A_ACFL04                                          CSD029
     C                   EVAL      E5FL05 = A_ACFL05                                          CSD029
     C                   EVAL      E5FL06 = A_ACFL06                                          CSD029
     C                   EVAL      E5FL07 = A_ACFL07                                          CSD029
     C                   EVAL      E5FL08 = A_ACFL08                                          CSD029
     C                   EVAL      E5FL09 = A_ACFL09                                          CSD029
     C                   EVAL      E5FL10 = A_ACFL10                                          CSD029
     C                   ENDIF                                                                CSD029

      ** Update the Additional field details when CSW207 is on                                CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EVAL      E5ISCD = A_ACISCD                                          CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Alternative Tax Identification Numbers                                               CGL132
     C                   EVAL      E5TIN2 = A_ACTIN2                                          CGL132
     C                   EVAL      E5TNC2 = A_ACTNC2                                          CGL132
     C                   EVAL      E5TIN3 = A_ACTIN3                                          CGL132
     C                   EVAL      E5TNC3 = A_ACTNC3                                          CGL132
     C                   EVAL      E5TIN4 = A_ACTIN4                                          CGL132
     C                   EVAL      E5TNC4 = A_ACTNC4                                          CGL132
     C                   EVAL      E5TIN5 = A_ACTIN5                                          CGL132
     C                   EVAL      E5TNC5 = A_ACTNC5                                          CGL132
      *                                                                                       CER034
      ** Update the Additional field details                                                  CER034
      *                                                                                       CER034
     C                   EXSR      SRPopDets                                                  CER034
      *                                                                                       CER045
      ** Move new SDVACUDPD fields to corresponding SDACUSPD file fields                      CER045
      ** when CER045 is ON                                                                    CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y'                                               CER045
     C                   MOVEL     A_ACBSCC      E5BSCC                                       CER045
     C                   EVAL      E5ECAC = A_ACECAC                                          CER045
     C                   MOVEL     A_ACBIST      E5BIST                                       CER045
     C                   EVAL      E5ABSK = A_ACABSK                                          CER045
     C                   EVAL      E5BEXT = A_ACBEXT                                          CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER034
     C                   If        CER050 = 'Y'                                               CER050
     C                   If        A_ACAPRC = *Blank                                          CER050
     C                   Eval      E5APRC = 'Y'                                               CER050
     C                   else                                                                 CER050
     C                   Eval      E5APRC = A_ACAPRC                                          CER050
     C                   Endif                                                                CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
      ** Write new Transaction Detail

     C                   WRITE     @ACUSL0
                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             CGL133 = 'N'                                               CGL132
     C     A_ACCUST      CHAIN     SDFTCSL0                             99                    CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C                   IF        NOT %FOUND(SDFTCSL0)                                       CGL132
     C                   EVAL      DBKEY  = A_ACCUST                                          CGL132
     C                   EVAL      DBFILE = 'SDFTCSPD'                                        CGL132
     C                   EVAL      DBASE  =  801                                              CGL132
     C                   EXSR      SRErr                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      WCTAX = SVal1                                              CGL132
     C                   IF        E5TNC5 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN5                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC4 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN4                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC3 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN3                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC2 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN2                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        C_BBCOLC = WCTAX                                           CGL132
     C                   EVAL      FAUTIN = E5TINO                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   UPDATE    SDFTCSD0                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      E5CUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      SDACUS        PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092

     C                   EVAL      WUNoRc = 1
     C                   EVAL      WUNoAm = 0
     C                   EVAL      WUNoDl = 0
     C                   EVAL      WUNoIn = 1
     C                   EXSR      SRSNCHRC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Amend an Additional Customer Details               *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR

      ** Access Transaction Detail record

     C     A_ACCUST      CHAIN     SDACUSL0                           99

      ** Database error

     C                   IF        Not %Found(SDACUSL0)
     C                   EVAL      DBKEY  = A_ACCUST
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBASE  =  002
     C                   EXSR      SRErr
     C                   ENDIF

      ** Update 'BEFORE' status

     C                   EVAL      B_SDACUS = SDACUS

      ** Set Transaction Detail fields on amend

     C                   EVAL      E5CUST = A_ACCUST
     C                   EVAL      E5LCD  = A_ACLCD
     C                   EVAL      E5TYLC = A_ACTYLC
     C                   EVAL      E5ALTN = A_ACALTN
     C                   EVAL      E5IDNO = A_ACIDNO
     C                   EVAL      E5FXNB = A_ACFXNB
     C                   EVAL      E5TXNB = A_ACTXNB
     C                   EVAL      E5DOLV = A_ACDOLV
     C                   EVAL      E5PRVO = A_ACPRVO
     C                   EVAL      E5MDTL = A_ACMDTL
     C                   EVAL      E5CNA1 = A_ACCNA1
     C                   EVAL      E5CNA2 = A_ACCNA2
     C                   EVAL      E5CNA3 = A_ACCNA3
     C                   EVAL      E5CNA4 = A_ACCNA4
     C                   EVAL      E5CWL1 = A_ACCWL1
     C                   EVAL      E5CWL2 = A_ACCWL2
     C                   EVAL      E5CWL3 = A_ACCWL3
     C                   EVAL      E5CWL4 = A_ACCWL4
     C                   EVAL      E5CWL5 = A_ACCWL5
     C                   EVAL      E5CITY = A_ACCITY
     C                   EVAL      E5ZIPC = A_ACZIPC
     C                   EVAL      E5TINO = A_ACTINO
     C                   EVAL      E5IDTP = A_ACIDTP
     C                   EVAL      E5ISCT = A_ACISCT
     C                   EVAL      E5ISDT = A_ACISDT
     C                   EVAL      E5BTHC = A_ACBTHC
     C                   EVAL      E5BTHT = A_ACBTHT
     C                   EVAL      E5JATP = A_ACJATP
     C                   EVAL      E5REPI = A_ACREPI
     C                   EVAL      E5CSSN = C_BBCSSN

      ** Format Date of Birth

     C                   EVAL      E5DBTH = A_ACDBTH
     C                   MOVE      A_ACDBTH      WDayMnt
     C                   MOVEL     A_ACDBTH      WCCYY
     C                   MOVEL     WCCYY         E5BRT2
     C                   MOVE      WCCYY         WYear
     C                   MOVE      WCCYY         WNCCYY

     C                   MOVEL     WDayMnt       WMonth
     C                   MOVE      WDayMnt       WDay

     C                   IF        BJDFIN = 'M'
     C                   EVAL      E5BRT1 = WMonth + WDay + WYear
     C                   ELSE
     C                   EVAL      E5BRT1 = WDay + WMonth + WYear
     C                   ENDIF

     C                   IF        WNCCYY > 1972  and
     C                             WNCCYY < 2071

     C                   CALLB     'ZDATE1'
     C                   PARM      E5BRT1        DateIn
     C     E5BRTH        PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

     C                   ELSE
     C                   EVAL      E5BRTH = *Zeros
     C                   ENDIF

      ** Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     E5TMST

      ** Front Office ID

     C                   EVAL      E5FRNT = A_ACFRNT

      ** Repair Location

     C                   EVAL      E5REPA = A_ACREPA
                                                                                              CSD029
      ** Update the Additional field details when CSD029 is on                                CSD029
     C     CSD029        IFEQ      'Y'                                                        CSD029
     C                   EVAL      E5FL01 = A_ACFL01                                          CSD029
     C                   EVAL      E5FL02 = A_ACFL02                                          CSD029
     C                   EVAL      E5FL03 = A_ACFL03                                          CSD029
     C                   EVAL      E5FL04 = A_ACFL04                                          CSD029
     C                   EVAL      E5FL05 = A_ACFL05                                          CSD029
     C                   EVAL      E5FL06 = A_ACFL06                                          CSD029
     C                   EVAL      E5FL07 = A_ACFL07                                          CSD029
     C                   EVAL      E5FL08 = A_ACFL08                                          CSD029
     C                   EVAL      E5FL09 = A_ACFL09                                          CSD029
     C                   EVAL      E5FL10 = A_ACFL10                                          CSD029
     C                   ENDIF                                                                CSD029

      ** Update the Additional field details when CSW207 is on                                CSW207
     C                   IF        CSW207 = 'Y' or BGN4ST = 'Y'                               CSW207
     C                   EVAL      E5ISCD = A_ACISCD                                          CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *                                                                                       CER034
      ** Update the Additional field details                                                  CER034
      *                                                                                       CER034
     C                   EXSR      SRPopDets                                                  CER034
      *                                                                                       CER045
      ** Move new SDVACUDPD fields to corresponding SDACUSPD file fields                      CER045
      ** when CER045 is ON                                                                    CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y'                                               CER045
     C                   MOVEL     A_ACBSCC      E5BSCC                                       CER045
     C                   EVAL      E5ECAC = A_ACECAC                                          CER045
     C                   MOVEL     A_ACBIST      E5BIST                                       CER045
     C                   EVAL      E5ABSK = A_ACABSK                                          CER045
     C                   EVAL      E5BEXT = A_ACBEXT                                          CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER034
      ** Alternative Tax Identification Numbers                                               CGL132
     C                   EVAL      E5TIN2 = A_ACTIN2                                          CGL132
     C                   EVAL      E5TNC2 = A_ACTNC2                                          CGL132
     C                   EVAL      E5TIN3 = A_ACTIN3                                          CGL132
     C                   EVAL      E5TNC3 = A_ACTNC3                                          CGL132
     C                   EVAL      E5TIN4 = A_ACTIN4                                          CGL132
     C                   EVAL      E5TNC4 = A_ACTNC4                                          CGL132
     C                   EVAL      E5TIN5 = A_ACTIN5                                          CGL132
     C                   EVAL      E5TNC5 = A_ACTNC5                                          CGL132
                                                                                              CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                   If        A_ACAPRC = *Blank                                          CER050
     C                   Eval      E5APRC = 'Y'                                               CER050
     C                   else                                                                 CER050
     C                   Eval      E5APRC = A_ACAPRC                                          CER050
     C                   Endif                                                                CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
      ** Update Record

     C                   UPDATE    @ACUSL0
                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             CGL133 = 'N'                                               CGL132
     C     A_ACCUST      CHAIN     SDFTCSL0                             99                    CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C                   IF        NOT %FOUND(SDFTCSL0)                                       CGL132
     C                   EVAL      DBKEY  = A_ACCUST                                          CGL132
     C                   EVAL      DBFILE = 'SDFTCSPD'                                        CGL132
     C                   EVAL      DBASE  =  801                                              CGL132
     C                   EXSR      SRErr                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      WCTAX = SVal1                                              CGL132
     C                   IF        E5TNC5 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN5                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC4 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN4                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC3 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN3                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC2 = WCTAX                                             CGL132
     C                   EVAL      FAUTIN = E5TIN2                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        C_BBCOLC = WCTAX                                           CGL132
     C                   EVAL      FAUTIN = E5TINO                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   UPDATE    SDFTCSD0                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      E5CUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      B_SDACUS      PBefACUS                                     CSD092
     C                   PARM      SDACUS        PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092

     C                   EVAL      WUNoRc = 0
     C                   EVAL      WUNoAm = 1
     C                   EVAL      WUNoDl = 0
     C                   EVAL      WUNoIn = 0
     C                   EXSR      SRSNCHRC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete an Additional Customer Detail               *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR

     C**********         IF        C_BBTAIN <> 'Y' AND                            BUG26917 BUG26917A
     C**********                   CER048 = 'Y'                                   BUG26917 BUG26917A
      ** Access Transaction Details

     C     A_ACCUST      CHAIN     SDACUSL0                           99

      ** Database error

     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_ACCUST
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBASE  =  003
     C                   EXSR      SRErr
     C                   ENDIF

      ** Update 'BEFORE' status

     C                   EVAL      B_SDACUS = SDACUS
      *                                                                                     BUG23518
      ** Set Additional Customer fields on Delete                                           BUG23518
      *                                                                                     BUG23518
     C                   EVAL      E5LCD = BJRDNB                                           BUG23518
     C                   EVAL      E5TYLC = 'D'                                             BUG23518
      *                                                                                     BUG23518
      ** Gernerate a Time Stamp                                                             BUG23518
      *                                                                                     BUG23518
     C                   CALLB     'ZAGENTMSTM'                                             BUG23518
     C                   PARM                    TimeStamp                                  BUG23518
      *                                                                                     BUG23518
     C                   MOVE      TimeStamp     E5TMST                                     BUG23518

      ** Delete record

     C**********         DELETE    @ACUSL0                                                  BUG23518
     C                   UPDATE    @ACUSL0                                                  BUG23518
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      E5CUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      B_SDACUS      PBefACUS                                     CSD092
     C                   PARM      SDACUS        PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092

     C**********         EVAL      WUNoRc = -1                                              BUG23518
     C                   EVAL      WUNoRc = 0                                               BUG23518
     C**********         EVAL      WUNoAm = 0                                               BUG23518
     C                   EVAL      WUNoAm = 1                                               BUG23518
     C**********         EVAL      WUNoDl = 1                                               BUG23518
     C                   EVAL      WUNoDl = 0                                               BUG23518
     C                   EVAL      WUNoIn = 0
     C                   EXSR      SRSNCHRC

     C**********         ELSEIF    CER048 = 'N'                                   BUG26917 BUG26917A
      ***Access*Transaction*Details*                                              BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C*****A_ACCUST      CHAIN     SDACUSL0                           99          BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
      ***Database*error*                                                          BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        *IN99 = *ON                                    BUG26917 BUG26917A
     C**********         EVAL      DBKEY  = A_ACCUST                              BUG26917 BUG26917A
     C**********         EVAL      DBFILE = 'SDACUSPD'                            BUG26917 BUG26917A
     C**********         EVAL      DBASE  =  003                                  BUG26917 BUG26917A
     C**********         EXSR      SRErr                                          BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
      ***Update*'BEFORE'*status*                                                  BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         EVAL      B_SDACUS = SDACUS                              BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
      ***Set*Additional*Customer*fields*on*Delete*                                BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         EVAL      E5LCD = BJRDNB                                 BUG26917 BUG26917A
     C**********         EVAL      E5TYLC = 'D'                                   BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
      ***Gernerate*a*Time*Stamp*                                                  BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         CALLB     'ZAGENTMSTM'                                   BUG26917 BUG26917A
     C**********         PARM                    TimeStamp                        BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         MOVE      TimeStamp     E5TMST                           BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
      ***Delete*record*                                                           BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         UPDATE    @ACUSL0                                        BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         EVAL      WUNoRc = 0                                     BUG26917 BUG26917A
     C**********         EVAL      WUNoAm = 1                                     BUG26917 BUG26917A
     C**********         EVAL      WUNoDl = 0                                     BUG26917 BUG26917A
     C**********         EVAL      WUNoIn = 0                                     BUG26917 BUG26917A
     C**********         EXSR      SRSNCHRC                                       BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                     BUG23518
      *  SRClose - Close Additional Details                           *                     BUG23518
      *                                                               *                     BUG23518
      *  Called By: MAIN Processing                                   *                     BUG23518
      *                                                               *                     BUG23518
      *  Calls: None                                                  *                     BUG23518
      *                                                               *                     BUG23518
      *****************************************************************                     BUG23518
     C     SRClose       BEGSR                                                              BUG23518
      *                                                                                     BUG23518
      ** Access Transaction Details                                                         BUG23518
      *                                                                                     BUG23518
     C     A_ACCUST      CHAIN     SDACUSL0                           99                    BUG23518
      *                                                                                     BUG23518
      ** Database error                                                                     BUG23518
      *                                                                                     BUG23518
     C                   IF        *IN99 = *ON                                              BUG23518
     C                   EVAL      DBKEY  = A_ACCUST                                        BUG23518
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23518
     C                   EVAL      DBASE = 004                                              BUG23518
     C                   EXSR      SRErr                                                    BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** Update 'BEFORE' status                                                             BUG23518
      *                                                                                     BUG23518
     C                   EVAL      B_SDACUS = SDACUS                                        BUG23518
      *                                                                                     BUG23518
      ** Set Additional Customer fields on Delete                                           BUG23518
      *                                                                                     BUG23518
     C                   EVAL      E5LCD = BJRDNB                                           BUG23518
     C                   EVAL      E5TYLC = 'C'                                             BUG23518
      *                                                                                     BUG23518
      ** Gernerate a Time Stamp                                                             BUG23518
      *                                                                                     BUG23518
     C                   CALLB     'ZAGENTMSTM'                                             BUG23518
     C                   PARM                    TimeStamp                                  BUG23518
      *                                                                                     BUG23518
     C                   MOVE      TimeStamp     E5TMST                                     BUG23518
      *                                                                                     BUG23518
      ** Update record                                                                      BUG23518
      *                                                                                     BUG23518
     C                   UPDATE    @ACUSL0                                                  BUG23518
      *                                                                                     BUG23518
     C                   EVAL      WUNoRc = 0                                               BUG23518
     C                   EVAL      WUNoAm = 1                                               BUG23518
     C                   EVAL      WUNoDl = 0                                               BUG23518
     C                   EVAL      WUNoIn = 0                                               BUG23518
     C                   EXSR      SRSNCHRC                                                 BUG23518
      *                                                                                     BUG23518
     C                   ENDSR                                                              BUG23518
      *****************************************************************                     BUG23518
      /EJECT                                                                                BUG23518
      *****************************************************************                     BUG23518
      *                                                               *                     BUG23518
      *  SRRelease - Release Additional Details                       *                     BUG23518
      *                                                               *                     BUG23518
      *  Called By: MAIN Processing                                   *                     BUG23518
      *                                                               *                     BUG23518
      *  Calls: None                                                  *                     BUG23518
      *                                                               *                     BUG23518
      *****************************************************************                     BUG23518
     C     SRRelease     BEGSR                                                              BUG23518
      *                                                                                     BUG23518
      ** Access Transaction Details                                                         BUG23518
      *                                                                                     BUG23518
     C     A_ACCUST      CHAIN     SDACUSL0                           99                    BUG23518
      *                                                                                     BUG23518
      ** Database error                                                                     BUG23518
      *                                                                                     BUG23518
     C                   IF        *IN99 = *ON                                              BUG23518
     C                   EVAL      DBKEY  = A_ACCUST                                        BUG23518
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23518
     C                   EVAL      DBASE = 004                                              BUG23518
     C                   EXSR      SRErr                                                    BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** Update 'BEFORE' status                                                             BUG23518
      *                                                                                     BUG23518
     C                   EVAL      B_SDACUS = SDACUS                                        BUG23518
      *                                                                                     BUG23518
      ** Set Additional Customer fields on Delete                                           BUG23518
      *                                                                                     BUG23518
     C                   EVAL      E5LCD = BJRDNB                                           BUG23518
     C                   EVAL      E5TYLC = *BLANKS                                         BUG23518
      *                                                                                     BUG23518
      ** Gernerate a Time Stamp                                                             BUG23518
      *                                                                                     BUG23518
     C                   CALLB     'ZAGENTMSTM'                                             BUG23518
     C                   PARM                    TimeStamp                                  BUG23518
      *                                                                                     BUG23518
     C                   MOVE      TimeStamp     E5TMST                                     BUG23518
      *                                                                                     BUG23518
      ** Update record                                                                      BUG23518
      *                                                                                     BUG23518
     C                   UPDATE    @ACUSL0                                                  BUG23518
      *                                                                                     BUG23518
     C                   EVAL      WUNoRc = 0                                               BUG23518
     C                   EVAL      WUNoAm = 1                                               BUG23518
     C                   EVAL      WUNoDl = 0                                               BUG23518
     C                   EVAL      WUNoIn = 0                                               BUG23518
     C                   EXSR      SRSNCHRC                                                 BUG23518
      *                                                                                     BUG23518
     C                   ENDSR                                                              BUG23518
      *****************************************************************                     BUG23518
      /EJECT                                                                                BUG23518
      *****************************************************************                     BUG23518
      * SRGetCust - Get Customer Details
      *****************************************************************
     C     SRGetCust     BEGSR

     C     A_ACCUST      CHAIN     SDCUSTL1

      ** Database Error

     C                   IF        Not %Found(SDCUSTL1)
                                                                                            BUG10069
      ** Check the shadow file.                                                             BUG10069
                                                                                            BUG10069
     C     A_ACCUST      CHAIN     SDCDSHL1                                                 BUG10069
                                                                                            BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C     *LOCK         IN        LDA                                                      BUG10069
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = A_ACCUST
     C                   OUT       LDA                                                      BUG10069
     C                   EXSR      SRErr
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNCHRC - Change Standing Data Controls                      *
      *                                                               *
      *****************************************************************
     C     SRSNCHRC      BEGSR

     C                   EVAL      W0RTN = *Blanks

      ** Move key fields to @AHREAU

     C                   EVAL      AHFLNM = WFlName

     C     KLCHSN        KLIST
     C                   KFLD                    AHFLNM
     C     KLCHSN        CHAIN     @AHREAU                            90

      ** Database Error

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = AHFLNM
     C                   EVAL      DBFILE = 'SDFCTLL0'
     C                   EVAL      DBASE = 005
     C                   EXSR      SRErr
     C                   END

      ** USER: Processing after Data read

     C                   ADD       AHNORC        WUNORC
     C                   ADD       AHNOIN        WUNOIN
     C                   ADD       AHNOAM        WUNOAM
     C                   ADD       AHNODL        WUNODL

      ** Move non-key fields to @AHREAU

     C                   EVAL      AHNORC = WUNORC
     C                   EVAL      AHNOIN = WUNOIN
     C                   EVAL      AHNOAM = WUNOAM
     C                   EVAL      AHNODL = WUNODL

      ** Update record

     C                   UPDATE    @AHREAU

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRPopDets - Populate New Additional Fields                   *                       CER034
      *                                                               *                       CER034
      *  Called by: SRInsert, SRAmend                                 *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRPopDets     BEGSR                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 or CER048 is enabled.                                                CER034
      *                                                                                       CER034
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                               CER034
      *                                                                                       CER034
     C                   EVAL      E5TITL = A_ACTITL                                          CER034
     C                   EVAL      E5MDNM = A_ACMDNM                                          CER034
     C                   EVAL      E5DCID = A_ACDCID                                          CER034
     C                   EVAL      E5DIPL = A_ACDIPL                                          CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER047 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   EVAL      E5EXDT = A_ACEXDT                                          CER034
     C                   EVAL      E5S24C = A_ACS24C                                          CER034
     C                   EVAL      E5REM1 = A_ACREM1                                          CER034
     C                   EVAL      E5REM2 = A_ACREM2                                          CER034
     C                   EVAL      E5REM3 = A_ACREM3                                          CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER048 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER048 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   EVAL      E5SHRF = A_ACSHRF                                          CER034
     C                   EVAL      E5PIND = A_ACPIND                                          CER034
     C                   EVAL      E5EXTH = A_ACEXTH                                          CER034
     C                   EVAL      E5EADT = A_ACEADT                                          CER034
     C                   EVAL      E5EVDT = A_ACEVDT                                          CER034
     C                   EVAL      E5ETXT = A_ACETXT                                          CER034
     C                   EVAL      E5CDCL = A_ACCDCL                                          CER034
     C                   EVAL      E5STCD = A_ACSTCD                                        BUG26505
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER034 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   EVAL      E5FXCU = A_ACFXCU                                          CER034
     C                   EVAL      E5SECU = A_ACSECU                                          CER034
     C                   EVAL      E5SMBR = A_ACSMBR                                          CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER038 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER038 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   EVAL      E5LNID = A_ACLNID                                          CER034
     C                   EVAL      E5CTYP = A_ACCTYP                                          CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER041 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER041 = 'Y'                                               CER034
     C                   EVAL      E5ZCFG = A_ACZCFG                                          CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER054
      ** Check if CER054 is enabled.                                                          CER054
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      E5STCD = A_ACSTCD                                 CER054 BUG26505
     C                   EVAL      E5RLAF = A_ACRLAF                                          CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                    BUG22578A
      *                                                               *                    BUG22578A
      *  SRRtvDet - Retrieve Country of Tax Details                   *                    BUG22578A
      *                                                               *                    BUG22578A
      *  Called by: Main Processing                                   *                    BUG22578A
      *                                                               *                    BUG22578A
      *  Calls: None                                                  *                    BUG22578A
      *                                                               *                    BUG22578A
      *****************************************************************                    BUG22578A
     C     SRRtvDet      BEGSR                                                             BUG22578A
      *                                                                                    BUG22578A
      ** Set up key for Country of Tax                                                     BUG22578A
      *                                                                                    BUG22578A
     C**********         CALL      'AOCUSTR0'                                       BUG22578A 262430
     C**********         PARM      *BLANKS       PRtCd                              BUG22578A 262430
     C**********         PARM      '*KEY'        POptn                              BUG22578A 262430
     C**********         PARM      A_ACCUST      PCusn                              BUG22578A 262430
     C**********         PARM                    PKySt                              BUG22578A 262430
     C*****SDCUST        PARM      SDCUST        DSSDY                              BUG22578A 262430
      *                                                                                    BUG22578A
     C**********         IF        PRtCd =  *BLANKS                                 BUG22578A 262430
     C**********         EVAL      PColc  = BBCOLC                                  BUG22578A 262430
     C**********         ENDIF                                                      BUG22578A 262430
     C                   EVAL      PColc  = C_BBCOLC                                          262430
      *                                                                                    BUG22578A
      ** Accessing the Branch Details of the Customer                                      BUG22578A
      *                                                                                    BUG22578A
     C                   CALL      'AOBRCHR1'                                              BUG22578A
     C                   PARM      *BLANKS       PRtCd                                     BUG22578A
     C                   PARM      '*KEY'        POptn                                     BUG22578A
     C**********         PARM                    BBBRCD                             BUG22578A 262430
     C                   PARM                    C_BBBRCD                                     262430
     C     SDBRCH        PARM      SDBRCH        DSSDY                                     BUG22578A
      *                                                                                    BUG22578A
      ** Accessing the Location Details from the Branch Location                           BUG22578A
      *                                                                                    BUG22578A
     C                   CALL      'AOLOCNR0'                                              BUG22578A
     C                   PARM      *BLANKS       PRtCd                                     BUG22578A
     C                   PARM      '*KEY'        POptn                                     BUG22578A
     C                   PARM                    A8LCCD                                    BUG22578A
     C     SDLOCN        PARM      SDLOCN        DSFDY                                     BUG22578A
      *                                                                                    BUG22578A
     C                   IF        PRtCd =  *BLANKS                                        BUG22578A
     C                   EVAL      PCntry = DVCNCD                                         BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
      ** Retrieve the Country of Tax Details for the Customer                              BUG22578A
      *                                                                                    BUG22578A
     C                   CALL      'AOCTTXR0'                                              BUG22578A
     C                   PARM      *BLANKS       PRtCd                                     BUG22578A
     C                   PARM      '*KEY'        POptn                                     BUG22578A
     C                   PARM                    PCntry                                    BUG22578A
     C                   PARM                    PColc                                     BUG22578A
     C     SDCTTX        PARM      SDCTTX        DSLDY                                     BUG22578A
      *                                                                                    BUG22578A
     C                   IF        PRtCd <> *BLANKS                                        BUG22578A
      *                                                                                    BUG22578A
     C                   CALL      'AOCTTXR0'                                              BUG22578A
     C                   PARM      *BLANKS       PRtCd                                     BUG22578A
     C                   PARM      '*KEY'        POptn                                     BUG22578A
     C                   PARM                    PCntry                                    BUG22578A
     C                   PARM      *BLANKS       PColc                                     BUG22578A
     C     SDCTTX        PARM      SDCTTX        DSLDY                                     BUG22578A
      *                                                                                    BUG22578A
     C                   IF        PRtCd <> *BLANKS                                        BUG22578A
     C     *LOCK         IN        LDA                                                     BUG22578A
     C                   EVAL      DBFILE = 'SDCTTXPD'                                     BUG22578A
     C                   EVAL      DBKEY = PCntry + PColc                                  BUG22578A
     C                   EVAL      DBase = 008                                             BUG22578A
     C                   OUT       LDA                                                     BUG22578A
     C                   EXSR      SRErr                                                   BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDSR                                                             BUG22578A
      *****************************************************************                    BUG22578A
      /EJECT                                                                               BUG22578A
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRWrThrh - Subroutine to write Details in SDTHRHPD file      *                       CER034
      *                                                               *                       CER034
      *  Called by: Main Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRWrThrh      BEGSR                                                                CER034
      *                                                                                    BUG22578A
     C                   EXSR      SRRtvDet                                                BUG22578A
      *                                                                                    BUG22578A
      ** Retrieve European Tax Status                                                      BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      KFCusn = A_ACCUST                                       BUG22578A
     C**********         EVAL      KFCTax = BBCOLC                                  BUG22578A 262430
     C                   EVAL      KFCTax = C_BBCOLC                                          262430
      *                                                                                    BUG22578A
     C     KLActx        CHAIN     SDACTXL1                                                BUG22578A
      *                                                                                       CER034
      ** Carry out further processing if Customer is Taxable                               BUG22578A
      *                                                                                    BUG22578A
     C                   IF        %FOUND(SDACTXL1)                                        BUG22578A
      *                                                                                       CER034
     C                   IF        AXETXS = 'S' OR AXETXS = 'D'                            BUG22578A
     C                             OR AXETXS = 'T'                                         BUG22578A
     C                             OR AXETXS = 'Y' AND CER069 = 'Y'                           CER069
      *                                                                                    BUG22578A
      ** Check record exist in Interest Payment History File                               BUG22578A
      *                                                                                    BUG22578A
     C     A_ACCUST      CHAIN     SDINPHL0                                                BUG22578A
     C**********         IF        A_ACTYLC  = 'I'                                  CER034 BUG22578A
      *                                                                                       CER034
     C                   IF        NOT %FOUND(SDINPHL0)                                    BUG22578A
      *                                                                                    BUG22578A
     C**********         EVAL      TIBRCA = BBBRCD                                  BUG22578A 262430
     C                   EVAL      TIBRCA = C_BBBRCD                                          262430
     C                   EVAL      TICUST = A_ACCUST                                       BUG22578A
     C                   EVAL      TILSSD = *ZEROS                                         BUG22578A
     C                   EVAL      TIPGNO = *ZEROS                                         BUG22578A
     C**********         EVAL      TISTRQ = *BLANKS                               BUG22578A BUG23135
      *                                                                                     BUG23135
      ** Set Statement Required Flag to 'Y' is Customer is 'T'axable                        BUG23135
      *                                                                                     BUG23135
     C                   IF        AXETXS = 'T'                                             BUG23135
     C                             OR AXETXS = 'Y'                                            CER069
     C                             AND CER069 = 'Y'                                           CER069
     C                   EVAL      TISTRQ = 'Y'                                             BUG23135
     C                   ELSE                                                               BUG23135
     C                   EVAL      TISTRQ = 'N'                                             BUG23135
     C                   ENDIF                                                              BUG23135
      *                                                                                     BUG23135
     C                   EVAL      TIUTTH = *ZEROS                                         BUG22578A
     C                   EVAL      TITOUT = *ZEROS                                         BUG22578A
     C                   EVAL      TICUTH = A_ACEXTH                                       BUG22578A
     C**********         EVAL      TIJOIN = *BLANKS                                BUG23732 BUG24051
     C                   IF        A_ACJATP = 'Y'                                          BUG24051A
     C                   EVAL      TIJOIN = A_ACCUST                                        BUG24051
     C                   ELSE                                                              BUG24051A
                                                                                            BUG26868
      * Check if customer is a joint account member                                         BUG26868
                                                                                            BUG26868
     C     A_ACCUST      CHAIN     SDJACCL4                                                 BUG26868
     C                   IF        NOT %FOUND(SDJACCL4)                                     BUG26868
     C                   EVAL      TIJOIN = *BLANKS                                        BUG24051A
     C                   ELSE                                                               BUG26868
     C                   EVAL      TIJOIN = JCJANO                                          BUG26868
     C                   ENDIF                                                              BUG26868
     C                   ENDIF                                                             BUG24051A
      *                                                                                     BUG23732
     C                   EVAL      TIGSIN = *ZEROS                                          BUG23732
     C                   EVAL      TITTAX = *ZEROS                                          BUG23732
      *                                                                                    BUG22578A
     C                   WRITE     SDINPHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C*****A_ACCUST      CHAIN     SDTHRHL0                                       BUG22578A BUG23800
     C     A_ACCUST      CHAIN     SDTHRHL3                                                 BUG23800
      *                                                                                    BUG22578A
     C**********         IF        NOT %FOUND(SDTHRHL0)                           BUG22578A BUG23800
     C                   IF        NOT %FOUND(SDTHRHL3)                                     BUG23800
      *                                                                                    BUG22578A
     C**********         IF        A_ACEXTH <> *ZEROS                               CER034 BUG22578A
     C**********         IF        TICUTH <> *ZEROS                               BUG22578A BUG24294
      *                                                                                       CER034
     C                   EVAL      TECUST = A_ACCUST                                          CER034
     C                   EVAL      TEACTD = BJRDNB                                            CER034
     C**********         EVAL      TECEXT = A_ACEXTH                                CER034 BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                          CER034
     C                   EVAL      TETRVD = A_ACEVDT                                          CER034
     C                   EVAL      TETRMD = A_ACETXT                                          CER034
     C                   WRITE     SDTHRHD0                                                   CER034
      *                                                                                       CER034
     C**********         ENDIF                                                       CER034 BUG24294
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                    BUG22578A
     C**********         IF        TICUTH <> *ZEROS AND                           BUG22578A BUG24294
     C**********                   TEACTD = BJRDNB                                BUG22578A BUG24294
     C                   IF        TEACTD = BJRDNB                                          BUG24294
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   UPDATE    SDTHRHD0                                                BUG22578A
      *                                                                                       CER034
     C**********         ELSEIF    TICUTH <> *ZEROS AND                           BUG22578A BUG24294
     C**********                   TEACTD <> BJRDNB                               BUG22578A BUG24294
     C                   ELSEIF    TEACTD <> BJRDNB                                         BUG24294
      *                                                                                    BUG22578A
     C                   EVAL      TECUST = A_ACCUST                                       BUG22578A
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   WRITE     SDTHRHD0                                                BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      TICUTH = A_ACEXTH                                       BUG22578A
      *                                                                                     BUG23135
      ** Set Statement Required Flag to 'Y' is Customer is 'T'axable                        BUG23135
      *                                                                                     BUG23135
     C                   IF        AXETXS = 'T'                                             BUG23135
     C                             OR AXETXS = 'Y'                                            CER069
     C                             AND CER069 = 'Y'                                           CER069
     C                   EVAL      TISTRQ = 'Y'                                             BUG23135
     C                   ELSE                                                               BUG23135
     C                   EVAL      TISTRQ = 'N'                                             BUG23135
     C                   ENDIF                                                              BUG23135
                                                                                           BUG24051A
     C                   IF        A_ACJATP = 'Y'                                          BUG24051A
     C                   EVAL      TIJOIN = A_ACCUST                                       BUG24051A
     C                   ELSE                                                              BUG24051A
                                                                                            BUG26868
      * Check if customer is a joint account member                                         BUG26868
                                                                                            BUG26868
     C     A_ACCUST      CHAIN     SDJACCL4                                                 BUG26868
     C                   IF        NOT %FOUND(SDJACCL4)                                     BUG26868
     C                   EVAL      TIJOIN = *BLANKS                                        BUG24051A
     C                   ELSE                                                               BUG26868
     C                   EVAL      TIJOIN = JCJANO                                          BUG26868
     C                   ENDIF                                                              BUG26868
     C                   ENDIF                                                             BUG24051A
      *                                                                                    BUG22578A
     C                   UPDATE    SDINPHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C*****A_ACCUST      CHAIN     SDTHRHL0                                       BUG22578A BUG23800
     C     A_ACCUST      CHAIN     SDTHRHL3                                                 BUG23800
      *                                                                                    BUG22578A
     C**********         IF        NOT %FOUND(SDTHRHL0)                           BUG22578A BUG23800
     C                   IF        NOT %FOUND(SDTHRHL3)                                     BUG23800
      *                                                                                    BUG22578A
     C**********         IF        TICUTH <> *ZEROS                               BUG22578A BUG24294
      *                                                                                    BU422578A
     C                   EVAL      TECUST = A_ACCUST                                       BUG22578A
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   WRITE     SDTHRHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C**********         ENDIF                                                    BUG22578A BUG24294
      *                                                                                    BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C**********         IF        TICUTH <> *ZEROS AND                           BUG22578A BUG24294
     C**********                   TEACTD = BJRDNB                                BUG22578A BUG24294
     C                   IF        TEACTD = BJRDNB                                          BUG24294
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   UPDATE    SDTHRHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C**********         ELSEIF    TICUTH <> *ZEROS AND                           BUG22578A BUG24294
     C**********                   TEACTD <> BJRDNB                               BUG22578A BUG24294
     C                   ELSEIF    TEACTD <> BJRDNB                                         BUG24294
      *                                                                                    BUG22578A
     C                   EVAL      TECUST = A_ACCUST                                       BUG22578A
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   WRITE     SDTHRHD0                                                BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C**********         IF        A_ACTYLC  = 'A'                                  CER034 BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C     A_ACCUST      CHAIN     SDINPHL0                                                BUG22578A
      *                                                                                    BUG22578A
     C                   IF        %FOUND(SDINPHL0)                                        BUG22578A
     C                   EVAL      TICUTH = *ZEROS                                         BUG22578A
     C                   EVAL      TISTRQ = 'N'                                             BUG23135
     C                   UPDATE    SDINPHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C*****A_ACCUST      CHAIN     SDTHRHL0                                       BUG22578A BUG23800
     C     A_ACCUST      CHAIN     SDTHRHL3                                                 BUG23800
      *                                                                                    BUG22578A
     C**********         IF        NOT %FOUND(SDTHRHL0)                           BUG22578A BUG23800
     C                   IF        NOT %FOUND(SDTHRHL3)                                     BUG23800
      *                                                                                    BUG22578A
     C                   EVAL      TECUST = A_ACCUST                                       BUG22578A
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   WRITE     SDTHRHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C                   IF        TEACTD = BJRDNB                                         BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   UPDATE    SDTHRHD0                                                BUG22578A
      *                                                                                    BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      TECUST = A_ACCUST                                       BUG22578A
     C                   EVAL      TEACTD = BJRDNB                                         BUG22578A
     C                   EVAL      TECEXT = TICUTH                                         BUG22578A
     C                   EVAL      TETRAD = A_ACEADT                                       BUG22578A
     C                   EVAL      TETRVD = A_ACEVDT                                       BUG22578A
     C                   EVAL      TETRMD = A_ACETXT                                       BUG22578A
     C                   WRITE     SDTHRHD0                                                BUG22578A
     C**********                                                                    CER034 BUG22578A
     C**********         CALL      'AOACUSR0'                                       CER034 BUG22578A
     C**********         PARM      *BLANKS       PRtcd                              CER034 BUG22578A
     C**********         PARM      '*KEY'        POptn                              CER034 BUG22578A
     C**********         PARM      A_ACCUST      PCusn                              CER034 BUG22578A
     C*****SDACUS        PARM      SDACUS        DSLDY                              CER034 BUG22578A
      *                                                                                       CER034
     C**********         IF        PRtcd <> *BLANKS                                 CER034 BUG22578A
     C**********         EVAL      DBKEY =  'DDCUST'                                CER034 BUG22578A
     C**********         EVAL      DBFILE = 'SDACUSPD'                              CER034 BUG22578A
     C**********         EVAL      DBASE = 007                                      CER034 BUG22578A
     C**********         EXSR      SRErr                                            CER034 BUG22578A
     C**********         ENDIF                                                      CER034 BUG22578A
      *                                                                                       CER034
     C**********         IF        A_ACEXTH <> E5EXTH OR A_ACEADT <> E5EADT          CER034 BUG22715
     C**********                   OR A_ACEVDT <> E5EVDT OR A_ACETXT <> E5ETXT       CER034 BUG22715
      *                                                                                       CER034
      ***Setup*Key*to*access*Threhold*History*File                                  CER034 BUG22578A
      *                                                                                       CER034
     C*****A_ACCUST      CHAIN     SDTHRHL0                                 CER034 CER034A BUG22578A
      *                                                                               CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      TECEXT = A_ACEXTH                                CER034 BUG22578A
     C**********         EVAL      TETRAD = A_ACEADT                                CER034 BUG22578A
     C**********         EVAL      TETRVD = A_ACEVDT                                CER034 BUG22578A
     C**********         EVAL      TETRMD = A_ACETXT                                CER034 BUG22578A
      *                                                                                       CER034
      ** If history has been already modify today                                             CER034
      *                                                                                       CER034
     C**********         IF        %FOUND(SDTHRHL0)                                 CER034 BUG22578A
      *                                                                                       CER034
     C**********         UPDATE    SDTHRHD0                                         CER034 BUG22578A
     C**********         ELSE                                                       CER034 BUG22578A
      *                                                                                       CER034
     C**********         EVAL      TECUST = A_ACCUST                                CER034 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER034 BUG22578A
     C**********         WRITE     SDTHRHD0                                         CER034 BUG22578A
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C**********         ENDIF                                                       CER034 BUG22715
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
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

     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    P@Rtcd

      ** Externally described DS for valid Transaction Detail
     C                   PARM                    SDVACUD
      *                                                                                       CER034
      ** Key field definition for Country of Tax file SDACTXL0                                CER034
      *                                                                                       CER034
     C     KLActx        KLIST                                                             BUG22578A
     C                   KFLD                    KFCusn                                    BUG22578A
     C                   KFLD                    KFCTax                                    BUG22578A
      *                                                                                    BUG22578A
     C*****KINTH         KLIST                                                      CER034 BUG22578A
     C**********         KFLD                    C_BBCUST                           CER034 BUG22578A
     C**********         KFLD                    C_BBCOLC                           CER034 BUG22578A
      *                                                                                       CER034

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  901
     C                   EXSR      SRErr
     C                   ENDIF
                                                                                              CSW207
      ** Check if Private Banking is switched on:                                             CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM      '*DBERR'      PRtCd                                        CSW207
     C                   PARM      '*FIRST '     POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBASE = 906                                                CSW207
     C                   EVAL      DBKEY  = POptn                                             CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      SRErr                                                      CSW207
     C                   ENDIF                                                                CSW207

      ** Initialise

     C                   EVAL      WFlName = 'SDACUSPD'

      ** Check if CSC011 is installed

     C                   EVAL      CSC011 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      SRERR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
                                                                                              CSD092
      ** Check if CSD092 is enabled.                                                          CSD092
                                                                                              CSD092
     C                   EVAL      CSD092 = 'N'                                               CSD092
     C                   CALL      'AOSARDR0'                                                 CSD092
     C                   PARM      *BLANKS       PRtCd                                        CSD092
     C                   PARM      '*VERIFY'     POptn                                        CSD092
     C                   PARM      'CSD092'      PSARD                                        CSD092
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD092
                                                                                              CSD092
     C                   IF        PRtCd = *BLANKS                                            CSD092
     C                   EVAL      CSD092 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   IF        PRtCd <> '*NRF   '                                         CSD092
     C     *LOCK         IN        LDA                                                        CSD092
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD092
     C                   EVAL      DBKey = PSARD                                              CSD092
     C                   EVAL      DBase = 006                                                CSD092
     C                   OUT       LDA                                                        CSD092
     C                   EXSR      SRERR                                                      CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDIF                                                                CSD092
      ** Check if CSD029 is enabled                                                           CSD029
                                                                                              CSD029
     C                   CALL      'AOSARDR0'                                                 CSD029
     C                   PARM      *Blanks       PRtcd                                        CSD029
     C                   PARM      '*VERIFY'     POptn                                        CSD029
     C                   PARM      'CSD029'      PSard                                        CSD029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD029
                                                                                              CSD029
     C                   EVAL      CSD029 = 'N'                                               CSD029
     C     PRTCD         IFEQ      *BLANKS                                                    CSD029
     C                   EVAL      CSD029 = 'Y'                                               CSD029
     C                   ELSE                                                                 CSD029
     C     PRTCD         IFNE      *BLANKS                                                    CSD029
     C     PRTCD         ANDNE     '*NRF   '                                                  CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD029
     C                   EVAL      DBKEY = 'CSD029'                                           CSD029
     C                   EVAL      DBASE = 901                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      SRERR                                                      CSD029
     C                   ENDIF                                                                CSD029
     C                   ENDIF                                                                CSD029

      *                                                                                       CER034
      ** Check if CER034 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER034'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER034'                                           CER034
     C                   EVAL      DBASE = 907                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      SRERR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER038 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER038'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER038'                                           CER034
     C                   EVAL      DBASE = 908                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      SRERR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER041 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER041'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER041'                                           CER034
     C                   EVAL      DBASE = 910                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      SRERR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER047'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER047'                                           CER034
     C                   EVAL      DBASE = 912                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      SRERR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER048 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER048'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER048'                                           CER034
     C                   EVAL      DBASE = 913                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      SRERR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CGL132 is enabled                                                           CGL132
                                                                                              CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *Blanks       PRtcd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
     C     PRTCD         IFEQ      *BLANKS                                                    CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ELSE                                                                 CGL132
     C     PRTCD         IFNE      *BLANKS                                                    CGL132
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL132
     C     *LOCK         IN        LDA                                                        CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBKEY = 'CGL132'                                           CGL132
     C                   EVAL      DBASE = 910                                                CGL132
     C                   OUT       LDA                                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if CGL133 is enabled                                                           CGL132
                                                                                              CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *Blanks       PRtcd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL133'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   EVAL      CGL133 = 'N'                                               CGL132
     C     PRTCD         IFEQ      *BLANKS                                                    CGL132
     C                   EVAL      CGL133 = 'Y'                                               CGL132
     C                   ELSE                                                                 CGL132
     C     PRTCD         IFNE      *BLANKS                                                    CGL132
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL132
     C     *LOCK         IN        LDA                                                        CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBKEY = 'CGL133'                                           CGL132
     C                   EVAL      DBASE = 911                                                CGL132
     C                   OUT       LDA                                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *                                                                                       CER050
      ** Check if CER050 is enabled                                                           CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'                                                 CER050
     C                   Parm      *BLANKS       PRtcd                                        CER050
     C                   Parm      '*VERIFY'     POptn                                        CER050
     C                   Parm      'CER050'      PSard                                        CER050
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER050
      *                                                                                       CER050
     C                   Eval      CER050 = 'N'                                               CER050
     C                   If        PRtcd = *BLANKS                                            CER050
     C                   Eval      CER050 = 'Y'                                               CER050
     C                   Endif                                                                CER050
                                                                                              CER050
      *                                                                                       CER054
      ** Check if CER054 is enabled                                                           CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER054
     C                             (PRtcd <> '*NRF   ')                                       CER054
      *                                                                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBASE = 914                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      SRERR                                                      CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
                                                                                              CER054
      *                                                                                       CER045
      ** Check if CER045 is enabled                                                           CER045
      *                                                                                       CER045
     C                   CALL      'AOSARDR0'                                                 CER045
     C                   PARM      *BLANKS       PRtcd                                        CER045
     C                   PARM      '*VERIFY'     POptn                                        CER045
     C                   PARM      'CER045'      PSard                                        CER045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'N'                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd = *BLANKS                                            CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'Y'                                               CER045
     C                   ELSE                                                                 CER045
      *                                                                                       CER045
      ** Handle Datebase Error.                                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd <> '*NRF   '                                         CER045
     C     *LOCK         IN        LDA                                                        CER045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER045
     C                   EVAL      DBKEY = 'CER045'                                           CER045
     C                   EVAL      DBASE = 103                                                CER045
     C                   OUT       LDA                                                        CER045
     C                   EXSR      SRERR                                                      CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
                                                                                              CER069
      ** Check if CER069 is enabled                                                           CER069
                                                                                              CER069
     C                   CALL      'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtcd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
      *                                                                                       CER069
     C                   EVAL      CER069 = 'N'                                               CER069
      *                                                                                       CER069
     C                   IF        PRtcd = *BLANKS                                            CER069
      *                                                                                       CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ELSE                                                                 CER069
      *                                                                                       CER069
      ** Handle Datebase Error.                                                               CER069
      *                                                                                       CER069
     C                   IF        PRtcd <> '*NRF   '                                         CER069
     C     *LOCK         IN        LDA                                                        CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   EVAL      DBASE = 104                                                CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      SRERR                                                      CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
     C                   CALL      'AOSVALR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtcd                                        CGL132
     C                   PARM      SysVal1       SValK1                                       CGL132
     C                   PARM                    SVal1                                        CGL132
     C                   PARM                    SValK2                                       CGL132
     C                   PARM                    SVal2                                        CGL132
     C                   PARM                    SValK3                                       CGL132
     C                   PARM                    SVal3                                        CGL132
     C                   PARM                    SValK4                                       CGL132
     C                   PARM                    SVal4                                        CGL132
     C                   PARM                    SValK5                                       CGL132
     C                   PARM                    SVal5                                        CGL132
     C                   PARM                    SValK6                                       CGL132
     C                   PARM                    SVal6                                        CGL132
     C                   PARM                    SValK7                                       CGL132
     C                   PARM                    SVal7                                        CGL132
     C                   PARM                    SValK8                                       CGL132
     C                   PARM                    SVal8                                        CGL132
     C                   PARM                    SValK9                                       CGL132
     C                   PARM                    SVal9                                        CGL132
     C                   PARM                    SValK0                                       CGL132
     C                   PARM                    SVal10                                       CGL132
                                                                                              CGL132
     C                   IF        PRtcd <> *Blanks  AND                                      CGL132
     C                             PRtcd <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CGL132
     C                   EVAL      DBKEY = SValK1                                             CGL132
     C                   EVAL      DBASE = 800                                                CGL132
     C                   EVAL      DBPGM = 'SDACUDUPD'                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      *****************************************************************
     C     SRErr         BEGSR

     C                   EVAL      P@Rtcd = '*ERROR '
     C                   EVAL      DBPGM = 'SDACUDUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      **  Terminate the Program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2004
