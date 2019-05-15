     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL CRS Reports Management - Print')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL000762P - Midas GL CRS Reports Management - Print          *
      *                                                               *
      *  Function:  This is a new program to print Reports Management *
      *             for both Customer and Non-Account Holder          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD040961           Date 09Sep16               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040961 - Issues in Printed Report in CRS                   *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80  - Data Base Error Indicator                            *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrMainExp - Main Processing for List of Cust/NAH Exception   *
      *  SrInit    - Initial Processing                               *
      *  SrTerm    - Termination Processing                           *
      *  SrFcp     - Produces Standard Totals Report                  *
      *  SrPrint   - Prints header and details of report              *
      *  SrHeader  - Prints header details                            *
      *  SrDetail  - Prints detail                                    *
      *  SrOpenP1  - Open printer file GL0000662P1                    *
      *  SrCloseP1 - Close printer file GL000762P1                    *
      *  *Pssr     - Error Handling Subroutine                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *

      ** Customer Details File
     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

      ** Non-Account Holders File
     FSDCRNHL0  IF   E           K DISK    INFSR(*PSSR)

      ** SD Exception Management Detail
     FSDEXMAL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Excluded Account Records File
     FGLCRMIL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Reports Management - Account Report
     FGLCRMDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD02)
     FGLCRMDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD03)
     FGLCRMDL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD04)
     FGLCRMDL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD07)

      ** RPT: CRS Due Diligence Report Control
     FGL000762P1O    E             PRINTER INFDS(Spool1)
     F                                     INFSR(*Pssr)
     F                                     USROPN

      ** RPT: CRS Due Diligence Report Audit
     FGL000762AUO    E             PRINTER INFDS(SpoolU)
     F                                     INFSR(*Pssr)
      ** Midas GL Reports Management
     FGLCRMDL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Reports Management
     FGLCRMDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMDD1)

      ** Midas GL Reports Management
     FGLCRMDLC  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMDDC)
     FGLCRMDLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD0B)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

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
     D ExcpLst         C                   CONST('ABCDEFGHIJKLMNOPQRS+
     D                                            TUVWXYZ')

      ** Declared contant for Pool report
     D WMaxPos         C                   CONST(200)
     D MaxElmt         C                   CONST(2)
     D MaxRecd         C                   CONST(32766)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS Based On SDCUSTPD
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS Based On SDNAHOPD
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Code Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** File Information Data Structure for printer file SD000718P1
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0

      ** File Information Data Structure for printer file SD000718AU
     D SpoolU          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameter  entry
     D PMsgRId         S             21A
     D PRepTyp         S             18A
     D PCaYear         S              4A

      ** AOBANKR0 Parameters
     D POptn           S              7
     D PRtcd           S              7

      ** List of Cust/NAH working variables
     D WrTcus          S              5  0
     D WrTnah          S              5  0
     D WRun            S              1
     D Result          S             80A   VARYING
     D PKeyST          S              7A
     D WfdCsnh         S             10A
     D WfdRpnm         S             20A
     D WfdRptn         S             10A
     D WfdExlt         S             60A
     D WfdFile         S              1A
     D XstrPos         S              3S 0
     D XPosition       S              3S 0
     D XLength         S              3S 0
     D WExidC          S              1A
     D WExidN          S              2P 0

     D WxDCOT          S             80A
     D WxDTIN          S            800A
     D WxDTIB          S             80A
     D CtrNum          S              5  0
     D CtryNo          S              5  0
     D TINNum          S              5  0
     D CtrLen          S              5  0 INZ(2)
     D TINLen          S              5  0 INZ(25)
     D WsFound         S              1A
     D WsCTRY          S              2A
     D WsTNIB          S              2A
     D WsTINN          S             25A
     D CtrNum2         S              5  0
     D TINNum2         S              5  0
     D WsResEqTIB      S              1A
     D WTN             S              4  0

      ** ZSFILE Parameters
     D PSeq            S              5
     D ZEnty           S              3
     D ZsErr           S              1
     D ZsNum           S              6  0

      ** Fields used to check that sufficient lines remain for the
      ** printer file record format
     D Difln1          S              2  0
     D Rqdln1          S              2  0

      ** Compile time Array for Pool report elements
     D ElmtArr         S             25A   DIM(MaxElmt) CTDATA

      ** Work variables for Report Group - Pool Report
     D KMsgRID         S             21A
     D KMgElmt         S             30A
     D KMgTpEl         S             40A
     D DwCDCRF         S             35A
     D PCcyCD          S              3A
     D PtypIdx         S              5S 0
     D SRtypIdx        S              5S 0
     D WCount          S              1A
     D WcusIdx         S              5  0
     D WnahIdx         S              5  0
     D WSavCIx         S              5  0
     D WSavNIx         S              5  0
     D Wlength         S              3S 0
     D WTotIndx        S              5  0
     D WMsgDta         S             26A
     D WstrTps         S              3S 0
     D WNexPos         S              3  0
     D WPoolCust       S             30A
     D WCusNah         S             10A
     D WBalance        S             26A
     D ElmtIndx        S              4S 0
     D WxARFlag        S              1A   INZ('N')
     D FinalAddress    S            200A
     D WSlash          S              5U 0
     D WTrim           S              5U 0
     D MsgDtaKey       S             26A
     D AcnoStr         S              1A
     D AcnoEnd         S             26A
     D KPMsgID         S             21A
     D KTopElm         S             40A
     D KTopDoc         S             40A
     D KElmDoc         S             30A
     D DsAcEnd         S             26A
     D WxPACC          S              3A
     D WxPSTA          S             15A
     D DpAHStr         S             10A
     D DpAcEnd         S             26A
     D PayCount        S              6  0 INZ(0)
     D Leave           S              1A   INZ('N')
     D LeaveFI         S              1A   INZ('N')

      ** Work variables for Report Group - Account Report
     D KmgCUST         S             10A
     D KmgACNO         S             26A
     D RxACBL          S             15A
     D RxABCC          S              3A
     D KTopElmName     S             40A
     D KMGSEQU         S              5  0
     D WxACNO          S             26A
     D WxCNNH          S             10A
     D WxMTYP          S             04A

      ** Parameters for ZFRPED - Pool Report
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PEcode          S              1
     D POut21          S             21
     D POut22          S             22
     D POut25          S             25

      ** Work DS for Tax Identification Numbers
     DMGDataTIN        DS           125
     D WxMGTIN1                1     25
     D WxMGTIN2               26     50
     D WxMGTIN3               51     75
     D WxMGTIN4               76    100
     D WxMGTIN5              101    125

      ** Work DS for TIN Issuing Country
     DMGDataCOT        DS            10
     D WxMGCOT1                1      2
     D WxMGCOT2                3      4
     D WxMGCOT3                5      6
     D WxMGCOT4                7      8
     D WxMGCOT5                9     10

      ** Work DS for Tax Identification Numbers
     DMSDataTIN        DS           125
     D WxMSTIN1                1     25
     D WxMSTIN2               26     50
     D WxMSTIN3               51     75
     D WxMSTIN4               76    100
     D WxMSTIN5              101    125

      ** Work DS for TIN Issuing Country
     DMSDataCOT        DS            10
     D WxMSCOT1                1      2
     D WxMSCOT2                3      4
     D WxMSCOT3                5      6
     D WxMSCOT4                7      8
     D WxMSCOT5                9     10

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      *                  M A I N  P R O C E S S I N G                     *
      *********************************************************************

      ** Initial Processing
     C                   EXSR      SrInit

      ** Main Processing for Exception List
     C                   EXSR      SrMainExp

      ** Termination Processing
     C                   EXSR      SrTerm

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMainExp - Main Processing for List of Exceptions Cust/NAH   *
      *             Controls Set-up of GL000762P1 Details             *
      *             Outputs GL000762P1 Details                        *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SrPrint                                            *
      *                                                               *
      *****************************************************************
     C     SrMainExp     BEGSR

      ** Perform read to check for empty file

     C     PMsgrID       SETLL     GLCRMIL0                               99

      ** Continue processing records if file is not empty

     C                   IF        *IN99 = *ON

     C     PMsgrID       READE     GLCRMIL0
     C                   DOW       NOT %EOF(GLCRMIL0)

      **  Check that sufficient lines remain for the Format
     C                   Eval      Rqdln1 = 1
     C                   Eval      Difln1 = Oflln1 - Prtln1

      ** If DB error has occured no more processing in this routine
     C                   IF        *IN80 = *ON
     C                   LEAVE
     C                   ENDIF

     C                   SELECT

     C                   WHEN      IECNFL = 'C'
     C                   IF        IEINEX <> 'I'
     C                   ADD       1             WrTcus
     C                   EXSR      SrCSprocX
     C                   ENDIF

     C                   WHEN      IECNFL = 'N'
     C                   IF        IEINEX <> 'I'
     C                   ADD       1             WrTnah
     C                   EXSR      SrNHprocX
     C                   ENDIF

     C                   ENDSL

     C     PMsgrID       READE     GLCRMIL0
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCSprocX    - Load customer records                          *
      *                                                               *
      * Called by:   SrLoadDrvX                                       *
      *                                                               *
      * Calls:       SrWrtDrvX                                        *
      *                                                               *
      *****************************************************************
     C     SrCSprocX     BEGSR

     C                   EVAL      WfdCsnh = IECREF

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WfdCsnh
     C                   PARM      *BLANKS       PKeyST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database error processing

     C                   IF        Prtcd <> *BLANKS
     C                             AND Prtcd <> '*CUSDEL'
     C                             AND Prtcd <> '*CUSCLS'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = WfdCsnh
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA

     C                   ELSE

     C                   IF        Prtcd = '*CUSDEL'
     C                             OR Prtcd = '*CUSCLS'
     C                   ELSE
     C                   EVAL      WfdRpnm = BBCRNM
     C                   EVAL      WfdRptn = BBCRTN

     C     BBCUST        CHAIN     SDCRSHL0

     C                   IF        %FOUND(SDCRSHL0)
     C                   EVAL      Result = *BLANKS

      ** Check if exception ID is present

     C                   IF        CREXMI <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WExidC = *BLANKS
     C                   EVAL      XstrPos = 1
     C                   EVAL      XLength = 1

      ** Read through exception ID string

     C                   DOW       XstrPos <= 30

     C                   EVAL      WExidC=%TRIM(%SUBST(CREXMI:XstrPos:XLength))
     C                   EVAL      WExidN=%SCAN(WExidC:ExcpLst)

     C                   IF        WExidN = 0
     C                   LEAVE
     C                   ENDIF

      ** Convert character exception ID to numeric counterpart

     C                   IF        XstrPos = 1
     C                   EVAL      Result=%CHAR(WExidN)
     C                   ELSE
     C                   EVAL      Result=%REPLACE(', '+
     C                             %CHAR(WExidN): Result: %LEN(Result)+1:0)
     C                   ENDIF

      ** Increment pointer position of string

     C                   EVAL      XstrPos = XstrPos + 1
     C                   ENDDO

     C                   EVAL      WfdExlt = Result
     C                   ENDIF

     C                   IF        IEINEX = 'O'
     C                   EVAL      WfdExlt = 'Manually excluded from ' +
     C                                         'report'
     C                   ENDIF

     C                   IF        CREXMI = *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WfdExlt = *BLANKS
     C                   ENDIF

     C                   EVAL      WfdFile = IECNFL
     C                   ENDIF

      ** Write to Printer File
     C                   EXSR      SrPrint
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNHprocX    - Load non-account holder records                *
      *                                                               *
      * Called by:     SrLoadDrvX                                     *
      *                                                               *
      * Calls:         SrWrtDrvX                                      *
      *                                                               *
      *****************************************************************
     C     SrNHprocX     BEGSR

     C                   EVAL      WfdCsnh = IECREF

     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WfdCsnh
     C     SDNAHO        PARM      SDNAHO        DSSDY

      ** Database error processing

     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY = WfdCsnh
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   OUT       LDA

     C                   ELSE
     C                   EVAL      WfdRpnm = NHNARN
     C                   EVAL      WfdRptn = NHNATW

      ** Insert exception list processing before write to table

     C     NHNAHO        CHAIN     SDCRNHL0

     C                   IF        %FOUND(SDCRNHL0)
     C                   EVAL      Result = *BLANKS

      ** Check if exception ID is present

     C                   IF        NREXMI <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WExidC = *BLANKS
     C                   EVAL      XstrPos = 1
     C                   EVAL      XLength = 1

      ** Read through exception ID string

     C                   DOW       XstrPos <= 30

     C                   EVAL      WExidC=%TRIM(%SUBST(NREXMI:XstrPos:XLength))
     C                   EVAL      WExidN=%SCAN(WExidC:ExcpLst)

     C                   IF        WExidN = 0
     C                   LEAVE
     C                   ENDIF

      ** Convert character exception ID to numeric counterpart

     C                   IF        XstrPos = 1
     C                   EVAL      Result=%CHAR(WExidN)
     C                   ELSE
     C                   EVAL      Result=%REPLACE(', '+
     C                             %CHAR(WExidN): Result: %LEN(Result)+1:0)
     C                   ENDIF

      ** Increment pointer position of string

     C                   EVAL      XstrPos = XstrPos + 1
     C                   ENDDO

     C                   EVAL      WfdExlt = Result
     C                   ENDIF

     C                   IF        IEINEX = 'O'
     C                   EVAL      WfdExlt = 'Manually excluded from ' +
     C                                         'report'
     C                   ENDIF

     C                   IF        NREXMI <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WfdExlt = *BLANKS
     C                   ENDIF
     C
     C                   EVAL      WfdFile = IECNFL
     C                   ENDIF

     C                   EXSR      SrPrint
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrint  - Prints header and details of report Exception List *
      *                                                               *
      * Called by: SrMainExp                                          *
      *                                                               *
      * Calls    : SrHeader, SrDetail                                 *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

      ** Prepare detail data for printing
     C                   EXSR      SrDetail

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 1
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
     C                   EXSR      SrHeader
     C                   ENDIF

      ** Write detail record to GL000762P1 - Exception List
     C                   WRITE     GL000761D5

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrHeader - Writes header details for List of Exception        *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrHeader      BEGSR

      ** Write header
     C                   WRITE     GL000761R5

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCloseP1 - Close printer file GL000762P1                     *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrCloseP1     BEGSR

     C                   IF        %OPEN (GL000762P1)
     C                   CLOSE     GL000762P1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open printer file GL000762P1                       *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SrOpenP1      BEGSR

      ** Open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF

     C                   IF        NOT %OPEN (GL000762P1)
     C                   OPEN      GL000762P1

      **  Force header format printing
     C                   Eval      Prtln1 =  Oflln1

      ** Error during ZSFILE processing, return to calling program

     C                   IF        ZsErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDetail - Prepare Details for Printing of List of Exception  *
      *                                                               *
      * Called by: SrMainExp - Main Processing List of Exceptions     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrDetail      BEGSR

     C                   EVAL      RRCSNH = WfdCsnh
     C                   EVAL      RRRPNM = WfdRpnm
     C                   EVAL      RRRPTN = WfdRptn
     C                   EVAL      RREXLT = WfdExlt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit   - Initial processing                                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : *Pssr, SrHeader, SrOpenP1, SrCloseP1               *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMsgRId
     C                   PARM                    PRepTyp
     C                   PARM                    PCaYear

      ** Access bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If access program fails call SR. *Pssr

     C                   IF        PRtcd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF

      ** if fails goto END

     C                   IF        *IN80 = *ON
     C                   GOTO      Iend
     C                   ENDIF

      ** load printer file fields with date and title

     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT

      ** set number of records read to Zero for Exception Audit Report

     C                   Z-ADD     0             WrTcus
     C                   Z-ADD     0             WrTnah

     C                   EXSR      SrCloseP1
     C                   EXSR      SrOpenP1

      ** Process Message Header / Reporting FI
     C                   EXSR      SrPrMHRFI

      ** Process Account Report
     C                   EXSR      SrPrRGACR

      ** Process exception list
     C                   EXSR      SrHeader

     C     Iend          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrMHRFI - Print Message Header / Reporting FI               *
      *                                                               *
      *****************************************************************
     C     SrPrMHRFI     BEGSR

     C     KeyOECD       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KTopElm

     C     KeyACBL       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KmgACNO

      ** Retrieve 'CRS Schema Version'

     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'Root'

     C     KeyOECD       SETLL     GLCRMDL0
     C     KeyOECD       READE     GLCRMDL0
     C
     C                   IF        MGELMT = 'CRS_OECD'
     C                   EVAL      RROECD = MGDATA
     C                   ENDIF

      ** Report Message Header

     C     PMsgRId       SETLL     GLCRMDL2
     C     PMsgRId       READE     GLCRMDL2
     C                   DOW       NOT %EOF(GLCRMDL2) AND
     C                             Leave = 'N'

     C                   SELECT

     C                   WHEN      MGELMT = 'SendingCompanyIN'
     C                   EVAL      R7SNDC = MGDATA

     C                   WHEN      MGELMT = 'TransmittingCountry'
     C                   EVAL      R7TRNC = MGDATA

     C                   WHEN      MGELMT = 'ReceivingCountry'
     C                   EVAL      R7RCVC = MGDATA

     C                   WHEN      MGELMT = 'MessageType'
     C                   EVAL      R7MSGT = MGDATA

     C                   WHEN      MGELMT = 'Warning'
     C                   EVAL      R7WARN = MGDATA

     C                   WHEN      MGELMT = 'MessageRefId'
     C                   EVAL      R7MRID = MGDATA

     C                   WHEN      MGELMT = 'CorrMessageRefID'
     C                   EVAL      R7CMID = MGDATA

     C                   WHEN      MGELMT = 'ReportingPeriod'
     C                   EVAL      R7RPTP = MGDATA

     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      R7TSMP = MGDATA
     C                   EVAL      Leave  = 'Y'

     C                   ENDSL

     C     PMsgRId       READE     GLCRMDL2

     C                   ENDDO

      ** Reporting Financial Institution

     C     PMsgRId       SETLL     GLCRMDL2
     C     PMsgRId       READE     GLCRMDL2
     C                   DOW       NOT %EOF(GLCRMDL2) AND
     C                             LeaveFI = 'N'

     C                   SELECT

     C                   WHEN      MGELMT = 'IN'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7TINO = MGDATA
     C                   EVAL      R7TNIB = MGDAT2

     C                   WHEN      MGELMT = 'ResCountryCode'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7RESC = MGDATA

     C                   WHEN      MGELMT = 'Name'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7NAME = MGDATA

     C                   WHEN      MGELMT = 'AddressFree'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      R7ADD1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      R7ADD1 = %TRIM(R7ADD1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      R7ADD2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      R7ADD2 = %TRIM(R7ADD2)

     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      RRDTIN = MGDATA
     C                   EVAL      RDOCTP = MGDATA
     C                   EVAL      RRRTYP = PRepTyp
     C                   EVAL      RRRYER = PCaYear
     C                   EVAL      RDRTYP = PRepTyp
     C                   EVAL      RDRYER = PCaYear

     C                   WHEN      MGELMT = 'DocRefId'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7DRID = MGDATA

     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7CRID = MGDATA
     C                   EVAL      LeaveFI  = 'Y'

     C                   ENDSL

     C     PMsgRId       READE     GLCRMDL2

     C                   ENDDO

      ** Write Message Header and Reporting FI Main Header
     C                   WRITE     GL000763R6

      ** Write Message Header and Reporting FI Details
     C                   WRITE     GL000763R7

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrRGACR - Print Reporting Group - Account Report            *
      *                                                               *
      *****************************************************************
     C     SrPrRGACR     BEGSR

     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      KTopDoc = 'AccountReport'
     C                   EVAL      KElmDoc = 'DocTypeIndic'

     C     KDocTyp       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KTopDoc
     C                   KFLD                    KElmDoc

     C     KDocTyp       CHAIN     GLCRMDLC
     C                   IF        %FOUND(GLCRMDLC)
     C                   EVAL      RRDTIN = MGDATA
     C                   ELSE
     C                   EVAL      RRDTIN = *BLANK
     C                   ENDIF

     C     KRGACKY       KLIST
     C                   KFLD                    KPMsgID
     C                   KFLD                    KTopElm

     C     KAcctN3       KLIST
     C                   KFLD                    KPMsgID
     C                   KFLD                    WxACNO
     C                   KFLD                    WxCNNH
     C                   KFLD                    WxMTYP
     C                   KFLD                    KTopElmName

      ** Write Header Record Format
     C                   WRITE     GL000763R0

     C                   EXSR      SrPrRGAMD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrRGAMD - Print Reporting Group - Account Report Main Detail*
      *                                                               *
      *****************************************************************

     C     SrPrRGAMD     BEGSR

     C                   EVAL      RxACBL = *BLANKS
     C                   EVAL      RxABCC = *BLANKS

     C     PMsgRId       SETLL     GLCRMDL2
     C     PMsgRId       READE     GLCRMDL2
     C                   DOW       NOT %EOF(GLCRMDL2)
     C                             AND PMsgRId = MGMSID

     C                   SELECT

     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      R1DRID = MGDATA

     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      R1CRID = MGDATA

     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      R1ACNO = MGDATA

     C                   WHEN      MGELMT = 'AccountNumber(DormantAccount)' AND
     C                             MGTPMT = 'AccountReport'
     C                   IF        MGDATA = *BLANKS
     C                   EVAL      R2DMAC = 'N'
     C                   ELSE
     C                   EVAL      R2DMAC = 'Y'
     C                   ENDIF

     C                   WHEN      MGELMT = 'AccountHolder'
     C                   IF        MGDAT2 = 'CUST'
     C                   EVAL      R1CNNH = MGDATA
     C                   EVAL      WxARFlag = 'Y'
     C                   EXSR      SRCallCS
     C                   ENDIF
     C                   IF        MGDAT2 = 'NAHO'
     C                   EVAL      R1CNNH = MGDATA
     C                   EVAL      WMsgDta = MGDATA
     C                   EVAL      WxARFlag = 'Y'
     C                   EXSR      SRCallNH
     C                   ENDIF
     C                   EVAL      WxARFlag = 'N'
     C                   EVAL      R1RPTN = RRRPNM

     C                   WHEN      MGELMT = 'AcctHolderType'
     C                   EVAL      R1ACHT = MGDATA
     C                   EXSR      SrAcctBal

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 6
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000763R0
     C                   ENDIF

      ** Write detail record to Account Report Header
     C                   WRITE     GL000763R1

      ** Process detail record for Account Report Detail
     C                   EXSR      SrPrRGAHD

     C                   ENDSL

     C                   READ      GLCRMDL2

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcctBal - Check Account Balance for the Account Record      *
      *                                                               *
      *****************************************************************
     C     SrAcctBal     BEGSR

      ** Retrieve Account Balance

     C                   EVAL      R1ACBL = *BLANKS
     C                   EVAL      R1ABCC = *BLANKS
     C                   EVAL      RxACBL = *BLANKS
     C                   EVAL      RxABCC = *BLANKS
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KmgACNO = R1ACNO

     C     KeyACBL       SETLL     GLCRMDL9
     C     KeyACBL       READE     GLCRMDL9
     C
     C                   DOW       NOT %EOF(GLCRMDL9)
     C                   IF        MGELMT = 'AccountBalance'
     C                             AND MGACNO = R1ACNO
     C                   EVAL      RxACBL = MGDATA
     C                   EVAL      RxABCC = MGDAT2
     C                   LEAVE
     C                   ENDIF
     C                   READ      GLCRMDL9
     C                   ENDDO

     C                   IF        RxACBL <> *BLANKS
     C                   EVAL      R1ACBL = RxACBL
     C                   EVAL      R1ABCC = RxABCC
     C                   EVAL      PCcyCD = R1ABCC
     C                   EVAL      PDECS = 0
     C                   EXSR      SrCurrCd
     C                   EVAL      PFLD15 = %DEC(R1ACBL:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      POUT22        R1ACBL
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrRGAHD - Print Reporting Group - Account Report Detail     *
      *                                                               *
      *****************************************************************
     C     SrPrRGAHD     BEGSR

     C                   EVAL      R2BRTD = *BLANKS
     C                   EVAL      R2COCO = *BLANKS
     C                   EVAL      R2CITY = *BLANKS
     C                   EVAL      WxDCOT = *BLANKS
     C                   EVAL      WxDTIN = *BLANKS
     C                   EVAL      WxDTIB = *BLANKS
     C                   EVAL      WTN = *ZEROS

     C     PMsgRId       SETLL     GLCRMDL7
     C     PMsgRId       READE     GLCRMDL7
     C                   DOW       NOT %EOF(GLCRMDL7)
     C                             AND PMsgRId = MGMSID

     C                   SELECT

     C                   WHEN      MGELMT = 'AccountHolder'
     C                   EVAL      AcnoEnd = MGDATA
     C                   EVAL      WxDCOT = *BLANKS
     C                   EVAL      WxDTIN = *BLANKS
     C                   EVAL      WxDTIB = *BLANKS
     C                   EVAL      WTN = *ZEROS

     C                   WHEN      MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Individual'
     C                   IF        WxDCOT = *BLANKS
     C                   EVAL      WxDCOT = %TRIM(MGDATA) + WxDCOT
     C                   ELSE
     C                   EVAL      WxDCOT = %TRIM(WxDCOT) + %TRIM(MGDATA)
     C                   ENDIF

     C                   WHEN      MGELMT = 'IN' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'TIN' AND
     C                             MGTPMT = 'Individual'
     C                   IF        WxDTIN = *BLANKS
     C                   EVAL      WTN = WTN + 200
     C                   EVAL      WxDTIN = %TRIM(MGDATA) + WxDTIN
     C                   EVAL      WxDTIB = %TRIM(MGDAT2) + WxDTIB
     C                   ELSE
     C                   EVAL      WxDTIN = %SUBST(WxDTIN:1:WTN) + %TRIM(MGDATA)
     C                   EVAL      WxDTIB = %TRIM(WxDTIB) + %TRIM(MGDAT2)
     C                   EVAL      WTN = WTN + 200
     C                   ENDIF

     C                   WHEN      MGELMT = 'FirstName' AND
     C                             MGTPMT = 'Individual' OR
     C                             MGELMT = 'FirstName' AND
     C                             MGTPMT = 'Name'
     C                   EVAL      R2FNME = MGDATA

     C                   WHEN      MGELMT = 'LastName' AND
     C                             MGTPMT = 'Individual' OR
     C                             MGELMT = 'LastName' AND
     C                             MGTPMT = 'Name'
     C                   EVAL      R2LNME = MGDATA

     C                   WHEN      MGELMT = 'Name' AND
     C                             MGTPMT = 'Organisation'
     C                   EVAL      R2FNME = MGDATA
     C                   EVAL      R2LNME = *BLANKS

     C                   WHEN      MGELMT = 'Name' AND                                      MD040961
     C                             MGTPMT = 'Individual'                                    MD040961
     C                   EVAL      R2FNME = MGDATA                                          MD040961
     C                   EVAL      WxACNO = R1ACNO                                          MD040961
     C                   EVAL      WxCNNH = R1CNNH                                          MD040961
     C                   EVAL      KPMsgID = PMsgRId                                        MD040961
     C                   EVAL      WxMTYP = R1ACHT                                          MD040961
     C                   EVAL      KTopElmName = 'Name'                                     MD040961
     C                   EVAL      KMGSEQU = MGSEQU                                         MD040961
     C                   EVAL      R2FNME = *BLANKS                                         MD040961
     C                   EVAL      R2LNME = *BLANKS                                         MD040961
                                                                                            MD040961
     C     KAcctN3       SETLL     GLCRMDLB                                                 MD040961
     C                   READ      GLCRMDLB                                                 MD040961
     C                   DOW       NOT %EOF(GLCRMDLB)                                       MD040961
                                                                                            MD040961
     C                   IF        MGELMT = 'CountryCode'                                   MD040961
     C                             AND MGTPMT = 'CountryInfo'                               MD040961
     C                             AND MGSEQU = KMGSEQU                                     MD040961
     C                   EVAL      R2COCO = MGDATA                                          MD040961
     C                   ENDIF                                                              MD040961
                                                                                            MD040961
     C                   IF        MGELMT = 'FirstName'                                     MD040961
     C                             AND MGSEQU = KMGSEQU                                     MD040961
     C                   EVAL      R2FNME = MGDATA                                          MD040961
     C                   ENDIF                                                              MD040961
                                                                                            MD040961
     C                   IF        MGELMT = 'LastName'                                      MD040961
     C                             AND MGSEQU = KMGSEQU                                     MD040961
     C                   EVAL      R2LNME = MGDATA                                          MD040961
     C                   LEAVE                                                              MD040961
     C                   ENDIF                                                              MD040961
                                                                                            MD040961
     C                   READ      GLCRMDLB                                                 MD040961
                                                                                            MD040961
     C                   ENDDO                                                              MD040961
                                                                                            MD040961
     C                   WHEN      MGELMT = 'AddressFree' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'AddressFree' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      R2ADD1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      R2ADD1 = %TRIM(R2ADD1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      R2ADD2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      R2ADD2 = %TRIM(R2ADD2)
     C                   IF        MGTPMT = 'Organisation'
     C                   EVAL      R2BRTD = *BLANKS
     C                   EVAL      R2CITY = *BLANKS
     C                   EVAL      R2COCO = *BLANKS
     C                   GOTO      RGAHDP
     C                   ENDIF

     C                   WHEN      MGELMT = 'BirthDate' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      R2BRTD = %SUBST(MGDATA:1:4)
     C                                      + '-' + %SUBST(MGDATA:5:2)
     C                                      + '-' + %SUBST(MGDATA:7:2)

     C                   WHEN      MGELMT = 'City' AND
     C                             MGTPMT = 'Individual'
     C                             AND AcnoEnd = R1CNNH
     C                             AND MGACNO = R1ACNO
     C                   EVAL      R2CITY = MGDATA

     C**********         WHEN      MGELMT = 'CountryCode' AND                               MD040961
     C**********                   MGTPMT = 'CountryInfo'                                   MD040961
     C                   WHEN      MGELMT = 'CountryInfo' AND                               MD040961
     C                             MGTPMT = 'Individual'                                    MD040961
     C**********         EVAL      R2COCO = MGDATA                                          MD040961
     C     RGAHDP        TAG
     C                   IF        AcnoEnd = R1CNNH
     C                             AND MGACNO = R1ACNO

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 8
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000763R0
     C                   ENDIF

     C                   WRITE     GL000763R2

      **  Insert processing and writing for List of Country here
     C                   EXSR      SrRGACS
      **  Insert processing and writing for List of Country here

     C                   IF        R1ACHT = 'CRS101'                                        MD040961
      ** Process detail record for Account Report - Controlling Person
     C                   EXSR      SrPrRGASO
     C                   LEAVE
     C                   ENDIF                                                              MD040961
      ** Process detail record for Account Report - Payment Details                         MD040961
     C                   EXSR      SrPrRGAPD                                                MD040961
     C                   ENDIF

     C                   ENDSL

     C                   READ      GLCRMDL7

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGACS - Account Report - Country List Subfile               *
      *                                                               *
      *****************************************************************

     C     SrRGACS       BEGSR
     C                   EVAL      CtrNum = 1
     C                   EVAL      TINNum = 1
     C                   EVAL      WsFound = 'Y'
     C                   EVAL      WsCTRY = *BLANKS

     C                   DOW       WsFound = 'Y'

      ** Check if WxDCOT has a ResCountryCode values
     C                   EVAL      WsCTRY=%TRIM(%SUBST(WxDCOT:CtrNum:CtrLen))
     C                   EVAL      R8CTRY = WsCTRY

     C                   IF        WsCTRY <> *BLANKS

     C                   EVAL      CtrNum2 = 1
     C                   EVAL      TINNum2 = 1
     C                   EVAL      WsTNIB = *BLANKS
     C                   EVAL      WsResEqTIB = 'N'

      ** If there's a ResCountryCode, loop and find the TIN/TIN Issued By Combo
     C                   DOW       WsResEqTIB = 'N'

     C                   EVAL      WsTNIB=%TRIM(%SUBST(WxDTIB:CtrNum2:CtrLen))

     C                   IF        WsCTRY = WsTNIB
     C                             OR WsTNIB = *BLANKS

      ** If the ResCountryCode = TIN Issued By, get the TIN and prep for write
     C                   EVAL      WsTINN=%TRIM(%SUBST(WxDTIN:TINNum2:TINLen))
     C                   EVAL      WsResEqTIB = 'Y'
     C                   EVAL      R8TINN = WsTINN
     C                   EVAL      R8TNIB = WsTNIB

     C                   ELSE
     C                   EVAL      CtrNum2 = CtrNum2 + 2
     C                   EVAL      TINNum2 = TINNum2 + 25
     C
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   IF        R8CTRY = *BLANKS
     C                   EVAL      WsFound = 'N'
     C                   ENDIF

     C                   EVAL      CtrNum = CtrNum + 2
     C                   EVAL      TINNum = TINNum + 25

     C                   IF        WsFound = 'Y'

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 1
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000763R0
     C                   ENDIF

      ** Write Account Report Country of List Details
     C                   WRITE     GL000763R8
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrRGASO - Print Reporting Group - Account Report            *
      *             Controlling Person detail                         *
      *                                                               *
      *****************************************************************
     C     SrPrRGASO     BEGSR

     C                   EVAL      KPMsgID = PMsgRId
     C                   EVAL      KTopElm = 'ControllingPerson'

     C     KRGACKY       SETLL     GLCRMDL3
     C     KRGACKY       READE     GLCRMDL3
     C                   DOW       NOT %EOF(GLCRMDL3)
     C                             AND PMsgRId = MGMSID

     C                   IF        MGCUST <> R1CNNH
     C                             AND MGACNO <> R1ACNO
     C                   GOTO      RGASO
     C                   ENDIF

     C                   SELECT

     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      DsAcEnd = MGDATA
     C                   EVAL      WxDCOT = *BLANKS
     C                   EVAL      WxDTIN = *BLANKS
     C                   EVAL      WxDTIB = *BLANKS

     C                   WHEN      MGELMT = 'ResCountryCode'
     C                   IF        WxDCOT = *BLANKS
     C                   EVAL      WxDCOT = %TRIM(MGDATA) + WxDCOT
     C                   ELSE
     C                   EVAL      WxDCOT = %TRIM(WxDCOT) + %TRIM(MGDATA)
     C                   ENDIF

     C                   WHEN      MGELMT = 'IN' OR
     C                             MGELMT = 'TIN'
     C                   IF        WxDTIN = *BLANKS
     C                   EVAL      WTN = WTN + 200
     C                   EVAL      WxDTIN = %TRIM(MGDATA) + WxDTIN
     C                   EVAL      WxDTIB = %TRIM(MGDAT2) + WxDTIB
     C                   ELSE
     C                   EVAL      WxDTIN = %SUBST(WxDTIN:1:WTN) + %TRIM(MGDATA)
     C                   EVAL      WxDTIB = %TRIM(WxDTIB) + %TRIM(MGDAT2)
     C                   EVAL      WTN = WTN + 200
     C                   ENDIF

     C                   WHEN      MGELMT = 'Name'
     C                   EVAL      R3FNME = MGDATA
     C                   EVAL      WxACNO = R1ACNO
     C                   EVAL      WxCNNH = R1CNNH
     C                   EVAL      KTopElmName = 'Name'
     C                   EVAL      KMGSEQU = MGSEQU
     C                   EVAL      R3FNME = *BLANKS
     C                   EVAL      R3LNME = *BLANKS

     C     KAcctN3       SETLL     GLCRMDLB
     C                   READ      GLCRMDLB
     C                   DOW       NOT %EOF(GLCRMDLB)
     C                   IF        MGELMT = 'FirstName'
     C                             AND MGSEQU = KMGSEQU
     C                   EVAL      R3FNME = MGDATA
     C                   ENDIF

     C                   IF        MGELMT = 'LastName'
     C                             AND MGSEQU = KMGSEQU
     C                   EVAL      R3LNME = MGDATA
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCRMDLB

     C                   ENDDO

     C                   WHEN      MGELMT = 'AddressFree'
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      R3ADD1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      R3ADD1 = %TRIM(R3ADD1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      R3ADD2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      R3ADD2 = %TRIM(R3ADD2)

     C                   WHEN      MGELMT = 'BirthDate'
     C                   EVAL      R3BRTD = %SUBST(MGDATA:1:4)
     C                                      + '-' + %SUBST(MGDATA:5:2)
     C                                      + '-' + %SUBST(MGDATA:7:2)

     C                   WHEN      MGELMT = 'City'
     C                   EVAL      R3CITY = MGDATA
     C                   EVAL      KPMsgID = PMsgRId
     C                   EVAL      WxACNO = R1ACNO
     C                   EVAL      WxCNNH = R1CNNH
     C                   EVAL      KTopElmName = 'CountryInfo'
     C                   EVAL      KMGSEQU = MGSEQU

     C     KAcctN3       SETLL     GLCRMDLB
     C                   READ      GLCRMDLB
     C                   DOW       NOT %EOF(GLCRMDLB)
     C                   IF        MGELMT = 'CountryCode'
     C                             AND MGTPMT = 'CountryInfo'
     C                             AND MGSEQU = KMGSEQU
     C                   EVAL      R3COCO = MGDATA
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCRMDLB

     C                   ENDDO

     C                   WHEN      MGELMT = 'CountryInfo'
     C                   IF        DsAcEnd = R1ACNO
     C                             AND MGACNO = R1ACNO

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 8
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000763R0
     C                   ENDIF

     C                   WRITE     GL000763R3

      **  Insert processing and writing for List of Country here
     C                   EXSR      SrRGACS
      **  Insert processing and writing for List of Country here
     C                   ENDIF

     C                   ENDSL

     C     RGASO         TAG
     C                   READ      GLCRMDL3

     C                   ENDDO

      ** Process detail record for Account Report - Payment Details
     C                   EXSR      SrPrRGAPD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrRGAPD - Print Reporting Group - Account Report            *
      *             Account Balance / Payment Details                 *
      *                                                               *
      *****************************************************************
     C     SrPrRGAPD     BEGSR

     C                   EVAL      KPMsgID = PMsgRId
     C                   EVAL      KTopElm = 'Payment'

     C     KRGACKY       SETLL     GLCRMDL3
     C     KRGACKY       READE     GLCRMDL3
     C                   DOW       NOT %EOF(GLCRMDL3)
     C                             AND PMsgRId = MGMSID

     C                   SELECT

     C                   WHEN      MGELMT = 'AccountHolder'
     C                   EVAL      DpAHStr = MGDATA

     C                   WHEN      MGELMT = 'Type'
     C                   EVAL      R4PAYT = MGDATA

     C                   WHEN      MGELMT = 'PaymentAmnt'
     C                   EVAL      WxPSTA = MGDATA
     C                   EVAL      R4PACC = MGDAT2
     C                   EVAL      WxPACC = MGDAT2
     C                   EVAL      PCcyCD = WxPACC
     C                   EVAL      PDECS = 0
     C                   EXSR      SrCurrCd
     C                   EVAL      PFLD15 = %DEC(WxPSTA:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      POUT22        R4PSTA

     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      DpAcEnd = MGDATA
     C                   IF        DpAcEnd = R1ACNO
     C                             AND MGACNO = R1ACNO
     C                             AND DpAHStr= R1CNNH

     C                   Eval      Rqdln1 = 1
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000763R0
     C                   ENDIF

     C                   IF        WxPSTA <> '0'
      ** Write Account Balance / Payment details
     C                   WRITE     GL000763R5
     C                   ENDIF
     C                   ENDIF

     C                   ENDSL

     C                   READE     GLCRMDL3

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTerm   - Termination processing                             *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SrFcp                                              *
      *                                                               *
      *****************************************************************
     C     SrTerm        BEGSR

      ** If database error has occured, output total report headings;
      ** print error message and exit program.

     C                   IF        *IN80 = *ON
     C                   WRITE     DBERROR
     C                   GOTO      Tend
     C                   ENDIF

      ** Produce standard totals report
     C                   EXSR      SrFcp

      ** if a database error has occured, bypass further processing

     C     *INU7         CABEQ     *ON           TEND

      ** prints 'END OF REPORT' if *IN54 ON
     C                   IF        *IN54 = *ON

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 3
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C                   IF        DifLn1 <= Rqdln1
     C                   EXSR      SrHeader
     C                   ENDIF

     C                   WRITE     GL000761N5
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN
     C     Tend          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFcp - Produces Standard Totals Report                       *
      *                                                               *
      * Called by: SrTerm                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrFcp         BEGSR

      ** Set-up calculated number of records fields
     C                   Z-ADD     WrTcus        RRTCUS
     C                   Z-ADD     WrTnah        RRTNAH

      ** Print standard totals report
     C                   EVAL      *IN54 = *ON
     C                   IF        WrTcus = 0
     C                             AND WrTnah = 0
     C                   EVAL      *IN54 = *OFF
     C                   ENDIF
     C                   WRITE     CONTROL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCallCS - Call access object to retrieve report name        *
      *                                                               *
      *****************************************************************
     C     SRCallCS      BEGSR

      ** Retrieve Customer Report Name

     C                   EVAL      RRCSNH = *BLANKS
     C                   EVAL      RRCSNH =%TRIM(%SUBST(WMsgDta:1:6))
     C                   EVAL      WCusNah = RRCSNH

     C                   IF        WxARFlag = 'Y'
     C                   EVAL      WCusNah = R1CNNH
     C                   ENDIF

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCusNah
     C                   PARM      *BLANKS       PKeyST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database error processing
     C                   IF        Prtcd <> *BLANKS
     C                             AND Prtcd <> '*CUSDEL'
     C                             AND Prtcd <> '*CUSCLS'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = WCusNah
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   IF        Prtcd = '*CUSDEL'
     C                             OR Prtcd = '*CUSCLS'
     C                   ENDIF

     C                   EVAL      RRRPNM = *BLANKS
     C                   EVAL      RRRPTN = *BLANKS
     C                   EVAL      RRRPNM = BBCRNM
     C                   EVAL      RRRPTN = BBCRTN


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCallNH - Call access object to retrieve report name        *
      *                                                               *
      *****************************************************************
     C     SRCallNH      BEGSR

      ** Get Non-account holder Report Name

     c                   EVAL      RRCSNH = *BLANKS
     C                   EVAL      RRCSNH =%TRIM(%SUBST(WMsgDta:1:10))
     C                   EVAL      WCusNah = RRCSNH

     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCusNah
     C     SDNAHO        PARM      SDNAHO        DSSDY

      ** Database error processing

     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY = WCusNah
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   EVAL      RRRPTN = *BLANKS
     C                   EVAL      RRRPNM = *BLANKS
     C                   EVAL      RRRPNM = NHNARN
     C                   EVAL      RRRPTN = NHNATW

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt - This subroutine calls the program that inserts a   *
      *            decimal point and sign into a numeric field,       *
      *            to blank out leading zeros and optionally inserting*
      *            commas                                             *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR

     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM      'J'           PECODE
     C                   PARM      *Blanks       POUT22
     C                   PARM      *Blanks       POUT25

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurrCd - Subroutine to get the number of decimals set for  *
      *             a given currency                                  *
      *                                                               *
      *****************************************************************
     C     SrCurrCd      BEGSR

     C     PCcyCD        IFNE      *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcyCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *Pssr    - Error handling subroutine                          *
      *            Executes whenever field or program exception       *
      *            error occurs                                       *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     *Pssr         BEGSR

     C                   IF        WRun  = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'GL000762P'

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

      ** set on database error indicator and dump

     C                   EVAL      *IN80 = *ON
     C                   DUMP

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA ElmtArr
PoolListCust
PoolListNaho
