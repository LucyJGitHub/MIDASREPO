     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Reports Management - Print')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL000662P - Midas GL Reports Management - Print              *
      *                                                               *
      *  Function:  This is a new program to print Reports Management *
      *             for both Customer and Non-Account Holder          *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD043131           Date 14Dec16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043131 - Incorrect Document Type being displayed in the    *
      *             printed report                                    *
      *  CGL154 - FATCA Reporting                                     *
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
      *  SrCloseP1 - Close printer file GL000662P1                    *
      *  *Pssr     - Error Handling Subroutine                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
 
      ** Customer Details File
     FSDFTCSL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Non-Account Holders File
     FSDFTNHL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Exception Management Detail
     FSDEXMAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Excluded Account Records File
     FGLRMIEL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Reports Management - Account Report
     FGLRMDTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT02)
     FGLRMDTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT03)
     FGLRMDTL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT04)
     FGLRMDTL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT07)
 
      ** RPT: FATCA Due Diligence Report Control
     FGL000662P1O    E             PRINTER INFDS(Spool1)
     F                                     INFSR(*Pssr)
     F                                     USROPN
 
      ** RPT: FATCA Due Diligence Report Audit
     FGL000662AUO    E             PRINTER INFDS(SpoolU)
     F                                     INFSR(*Pssr)
      ** Midas GL Reports Management
     FGLRMDTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Reports Management
     FGLRMDTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTD1)
 
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
 
      ** Reporting group / Pool report details array
     D                 DS
     D  MPoolDetl                    77A   DIM(MaxRecd) DESCEND
     D  MType                         8A   OVERLAY(MPoolDetl:1)
     D  MCount                        9A   OVERLAY(MPoolDetl:9)
     D  MBalance                     22A   OVERLAY(MPoolDetl:18)
     D  MCurrCd                       3A   OVERLAY(MPoolDetl:40)
     D  MDocrefID                    35A   OVERLAY(MPoolDetl:43)
 
      ** Reporting group / Pool report Customer sorting array
     D                 DS
     D ARNAHL                        26A   DIM(MaxRecd) DESCEND
 
      ** Reporting group / Pool report Non-account holder array
     D                 DS
     D ARCUSL                        26A   DIM(MaxRecd) DESCEND
 
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
     D DsAcEnd         S             26A
     D WxPACC          S              3A
     D WxPSTA          S             15A
     D DpAHStr         S             10A
     D DpAcEnd         S             26A
     D PayCount        S              6  0 INZ(0)
     D Leave           S              1A   INZ('N')
     D LeaveFI         S              1A   INZ('N')
     D InitHdr         S              1A   INZ('Y')                                         MD043131
 
      ** Work variables for Report Group - Account Report
     D KmgCUST         S             10A
     D KmgACNO         S             26A
     D RxACBL          S             15A
     D RxABCC          S              3A
 
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
      *             Controls Set-up of GL000662P1 Details             *
      *             Outputs GL000662P1 Details                        *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SrPrint                                            *
      *                                                               *
      *****************************************************************
     C     SrMainExp     BEGSR
 
      ** Perform read to check for empty file
 
     C     PMsgrID       SETLL     GLRMIEL0                               99
 
      ** Continue processing records if file is not empty
 
     C                   IF        *IN99 = *ON
 
     C     PMsgrID       READE     GLRMIEL0
     C                   DOW       NOT %EOF(GLRMIEL0)
 
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
 
     C     PMsgrID       READE     GLRMIEL0
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
 
     C     BBCUST        CHAIN     SDFTCSL0
 
     C                   IF        %FOUND(SDFTCSL0)
     C                   EVAL      Result = *BLANKS
 
      ** Check if exception ID is present
 
     C                   IF        FAEXID <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WExidC = *BLANKS
     C                   EVAL      XstrPos = 1
     C                   EVAL      XLength = 1
 
      ** Read through exception ID string
 
     C                   DOW       XstrPos <= 30
 
     C                   EVAL      WExidC=%TRIM(%SUBST(FAEXID:XstrPos:XLength))
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
 
     C                   IF        FAEXID = *BLANKS
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
 
     C     NHNAHO        CHAIN     SDFTNHL0
 
     C                   IF        %FOUND(SDFTNHL0)
     C                   EVAL      Result = *BLANKS
 
      ** Check if exception ID is present
 
     C                   IF        FNEXID <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WExidC = *BLANKS
     C                   EVAL      XstrPos = 1
     C                   EVAL      XLength = 1
 
      ** Read through exception ID string
 
     C                   DOW       XstrPos <= 30
 
     C                   EVAL      WExidC=%TRIM(%SUBST(FNEXID:XstrPos:XLength))
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
 
     C                   IF        FNEXID = *BLANKS
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
 
      ** Write detail record to GL000662P1 - Exception List
     C                   WRITE     GL000661D5
 
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
     C                   WRITE     GL000661R5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCloseP1 - Close printer file GL000662P1                     *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SrCloseP1     BEGSR
 
     C                   IF        %OPEN (GL000662P1)
     C                   CLOSE     GL000662P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open printer file GL000662P1                       *
      *                                                               *
      * Called by: SrInit                                             *
      *                                                               *
      * Calls    : ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SrOpenP1      BEGSR
 
      ** Open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        NOT %OPEN (GL000662P1)
     C                   OPEN      GL000662P1
 
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
 
      ** Process Pool report
     C                   EXSR      SrPoolRC
 
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
 
      ** Retrieve 'FATCA Schema Version'
 
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'Root'
 
     C     KeyOECD       SETLL     GLRMDTL0
     C     KeyOECD       READE     GLRMDTL0
     C
     C                   IF        MGELMT = 'FATCA_OECD'
     C                   EVAL      RROECD = MGDATA
     C                   ENDIF
 
      ** Report Message Header
 
     C     PMsgRId       SETLL     GLRMDTL2
     C     PMsgRId       READE     GLRMDTL2
     C                   DOW       NOT %EOF(GLRMDTL2) AND
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
 
     C                   WHEN      MGELMT = 'CorrMessageRefId'
     C                   EVAL      R7CMID = MGDATA
 
     C                   WHEN      MGELMT = 'ReportingPeriod'
     C                   EVAL      R7RPTP = MGDATA
 
     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      R7TSMP = MGDATA
     C                   EVAL      Leave  = 'Y'
 
     C                   ENDSL
 
     C     PMsgRId       READE     GLRMDTL2
 
     C                   ENDDO
 
      ** Reporting Financial Institution
 
     C     PMsgRId       SETLL     GLRMDTL2
     C     PMsgRId       READE     GLRMDTL2
     C                   DOW       NOT %EOF(GLRMDTL2) AND
     C                             LeaveFI = 'N'
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'TIN'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7TINO = MGDATA
     C                   EVAL      R7TNIB = MGDAT2
 
     C                   WHEN      MGELMT = 'ResCountryCode'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7RESC = MGDATA
 
     C                   WHEN      MGELMT = 'Name'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7NAME = MGDATA
 
     C                   WHEN      MGELMT = 'CountryCode'
     C                             AND MGTPMT = 'ReportingFI'
     C                   EVAL      R7CTRY = MGDATA
 
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
     C**********         EVAL      RRDTIN = MGDATA                                          MD043131
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
 
     C     PMsgRId       READE     GLRMDTL2
 
     C                   ENDDO
 
      ** Write Message Header and Reporting FI Main Header
     C                   WRITE     GL000663R6
 
      ** Write Message Header and Reporting FI Details
     C                   WRITE     GL000663R7
 
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
 
     C     KRGACKY       KLIST
     C                   KFLD                    KPMsgID
     C                   KFLD                    KTopElm
 
      ** Write Header Record Format
     C**********         WRITE     GL000663R0                                               MD043131
     C                   EVAL      InitHdr = 'Y'                                            MD043131
 
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
 
     C     PMsgRId       SETLL     GLRMDTL2
     C     PMsgRId       READE     GLRMDTL2
     C                   DOW       NOT %EOF(GLRMDTL2)
     C                             AND PMsgRId = MGMSID
 
     C                   SELECT
                                                                                            MD043131
     C                   WHEN      MGELMT = 'DocTypeIndic'                                  MD043131
     C                             AND MGTPMT = 'AccountReport'                             MD043131
     C                   EVAL      RRDTIN = MGDATA                                          MD043131
     C                   IF        InitHdr = 'Y'                                            MD043131
     C                   WRITE     GL000663R0                                               MD043131
     C                   EVAL      InitHdr = 'N'                                            MD043131
     C                   ENDIF                                                              MD043131
 
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      R1DRID = MGDATA
 
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      R1CRID = MGDATA
 
     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      R1ACNO = MGDATA
 
     C                   WHEN      MGELMT = 'AcctHolder'
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
     C                   EVAL      R1RPTN = RCNRPN
 
     C                   WHEN      MGELMT = 'AcctHolderType'
     C                   EVAL      R1ACHT = MGDATA
     C                   EXSR      SrAcctBal
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 6
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000663R0
     C                   ENDIF
 
      ** Write detail record to Account Report Header
     C                   WRITE     GL000663R1
 
      ** Process detail record for Account Report Detail
     C                   EXSR      SrPrRGAHD
 
     C                   ENDSL
 
     C                   READ      GLRMDTL2
 
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
 
     C     KeyACBL       SETLL     GLRMDTL9
     C     KeyACBL       READE     GLRMDTL9
     C
     C                   DOW       NOT %EOF(GLRMDTL9)
     C                   IF        MGELMT = 'AccountBalance'
     C                             AND MGACNO = R1ACNO
     C                   EVAL      RxACBL = MGDATA
     C                   EVAL      RxABCC = MGDAT2
     C                   LEAVE
     C                   ENDIF
     C                   READ      GLRMDTL9
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
 
     C     PMsgRId       SETLL     GLRMDTL7
     C     PMsgRId       READE     GLRMDTL7
     C                   DOW       NOT %EOF(GLRMDTL7)
     C                             AND PMsgRId = MGMSID
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'AcctHolder'
     C                   EVAL      AcnoEnd = MGDATA
 
     C                   WHEN      MGELMT = 'TIN' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'TIN' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      MGDataTIN = MGDATA
     C                   EVAL      R2TIN1 = WxMGTIN1
     C                   EVAL      MGDataCOT = MGDAT2
     C                   EVAL      R2COT1 = WxMGCOT1
 
     C                   WHEN      MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      R2RECO = MGDATA
 
     C                   WHEN      MGELMT = 'FirstName' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      R2FNME = MGDATA
 
     C                   WHEN      MGELMT = 'LastName' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      R2LNME = MGDATA
 
     C                   WHEN      MGELMT = 'Name' AND
     C                             MGTPMT = 'Organisation'
     C                   EVAL      R2FNME = MGDATA
     C                   EVAL      R2LNME = *BLANKS
 
     C                   WHEN      MGELMT = 'CountryCode' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'CountryCode' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      R2COCO = MGDATA
 
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
     C                             AND AcnoEnd = R1CNNH
     C                             AND MGACNO = R1ACNO
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 7
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000663R0
     C                   ENDIF
 
     C                   WRITE     GL000663R2
 
      ** Process detail record for Account Report - Substantial Owner
     C                   EXSR      SrPrRGASO
     C                   LEAVE
     C                   ENDIF
 
     C                   WHEN      MGELMT = 'BirthDate' AND
     C                             MGTPMT = 'Individual'
     C                   IF        MGTPMT = 'Individual'
     C                             AND AcnoEnd = R1CNNH
     C                             AND MGACNO = R1ACNO
 
     C                   EVAL      R2BRTD = %SUBST(MGDATA:1:4)
     C                                      + '-' + %SUBST(MGDATA:5:2)
     C                                      + '-' + %SUBST(MGDATA:7:2)
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 7
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000663R0
     C                   ENDIF
 
     C                   WRITE     GL000663R2
 
      ** Process detail record for Account Report - Substantial Owner
     C                   EXSR      SrPrRGASO
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   READ      GLRMDTL7
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrRGASO - Print Reporting Group - Account Report            *
      *             Substantial Owners detail                         *
      *                                                               *
      *****************************************************************
     C     SrPrRGASO     BEGSR
 
     C                   EVAL      KPMsgID = PMsgRId
     C                   EVAL      KTopElm = 'SubstantialOwner'
 
     C     KRGACKY       SETLL     GLRMDTL3
     C     KRGACKY       READE     GLRMDTL3
     C                   DOW       NOT %EOF(GLRMDTL3)
     C                             AND PMsgRId = MGMSID
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      DsAcEnd = MGDATA
 
     C                   WHEN      MGELMT = 'TIN'
     C                   EVAL      MSDataTIN = MGDATA
     C                   EVAL      R3TIN1 = WxMSTIN1
     C                   EVAL      MSDataCOT = MGDAT2
     C                   EVAL      R3COT1 = WxMSCOT1
 
     C                   WHEN      MGELMT = 'ResCountryCode'
     C                   EVAL      R3RECO = MGDATA
 
     C                   WHEN      MGELMT = 'FirstName'
     C                   EVAL      R3FNME = MGDATA
 
     C                   WHEN      MGELMT = 'LastName'
     C                   EVAL      R3LNME = MGDATA
 
     C                   WHEN      MGELMT = 'CountryCode'
     C                   EVAL      R3COCO = MGDATA
 
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
     C                   IF        DsAcEnd = R1ACNO
     C                             AND MGACNO = R1ACNO
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 7
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
      ** Write Header Record Format
     C                   WRITE     GL000663R0
     C                   ENDIF
 
     C                   WRITE     GL000663R3
     C                   ENDIF
 
     C                   ENDSL
 
     C                   READ      GLRMDTL3
 
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
 
     C     KRGACKY       SETLL     GLRMDTL3
     C     KRGACKY       READE     GLRMDTL3
     C                   DOW       NOT %EOF(GLRMDTL3)
     C                             AND PMsgRId = MGMSID
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'AcctHolder'
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
     C                   WRITE     GL000663R0
     C                   ENDIF
 
     C                   IF        WxPSTA <> '0'
      ** Write Account Balance / Payment details
     C                   WRITE     GL000663R5
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   READE     GLRMDTL3
 
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
 
     C                   WRITE     GL000661N5
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
      * SrPoolRC - Control the program flow of reporting group pool   *
      *            report                                             *
      *                                                               *
      *****************************************************************
     C     SrPoolRC      BEGSR
 
      ** Initialise pool variables
 
     C                   EXSR      SrPoolIn
 
     C     KPoolRP1      SETLL     GLRMDTL0
 
      ** Continue processing records if file is not empty
 
     C                   IF        %EQUAL(GLRMDTL0)
     C                   EXSR      SrPDetEx
 
      ** Arrange array in ascending order
 
     C                   SORTA     MPoolDetl
     C                   EVAL      PtypIdx = SRtypIdx
 
      ** Get pool type from the array to use as driver for pool
      ** Cust/Nah list
 
     C                   DOW       PtypIdx > 0
 
      ** Execute header routine
     C                   CLEAR                   ARNAHL
     C                   CLEAR                   ARCUSL
     C                   EXSR      SrPoolHd
 
      ** Execute customer/naho list details extract
     C                   EXSR      SrCsNhEx
 
      ** Populate and write Customer/Naho list details
     C                   EXSR      SrPoolWdt
 
      ** Get next pool type
     C                   EVAL      PtypIdx = PtypIdx - 1
     C                   ENDDO
 
     C                   Eval      Rqdln1 = 3
     C                   EXSR      SrCheckL
 
     C                   ELSE
      ** No record to process
     C                   WRITE     GL000662R0
 
     C                   ENDIF
 
      ** End of Pool Report
     C                   WRITE     GL000661N5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPoolIn - Initialise pool report working variables and keys  *
      *                                                               *
      *****************************************************************
     C     SrPoolIn      BEGSR
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
 
     C                   EVAL      KMgTpEl = 'PoolReport'
     C                   EVAL      KMsgRID = PMsgRId
 
     C     KPoolRP1      KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KMgTpEl
 
     C     KPoolRP2      KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KMgElmt
     C                   KFLD                    KMgTpEl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPDetEx - Extract the header pool details                    *
      *                                                               *
      *****************************************************************
     C     SrPDetEx      BEGSR
 
     C     KPoolRP1      READE     GLRMDTL0
 
     C                   EVAL      PtypIdx = 0
     C                   DOW       *IN94 = *OFF
 
     C                   IF        MGELMT = 'AccountPoolReportType'
     C                   EVAL      PtypIdx = PtypIdx + 1
     C                   EVAL      MType(PtypIdx) = %TRIM(MGDATA)
     C                   ENDIF
 
 
     C                   SELECT
     C                   WHEN      MGELMT = 'AccountCount'
     C                   EVAL      MCount(PtypIdx) = %TRIM(MGDATA)
 
     C                   WHEN      MGELMT = 'PoolBalance'
     C                   EVAL      MBalance(PtypIdx) = %TRIM(MGDATA)
     C                   EVAL      MCurrCd(PtypIdx) = %TRIM(MGDAT2)
 
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      MDocRefId(PtypIdx) = %TRIM(MGDATA)
 
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      DwCDCRF = %TRIM(MGDATA)
 
     C                   ENDSL
 
     C     KPoolRP1      READE     GLRMDTL0                               94
 
     C                   ENDDO
 
     C                   EVAL      SRtypIdx = PtypIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPoolHd - Subroutine to populate and write pool report header*
      *                                                               *
      *****************************************************************
     C     SrPoolHd      BEGSR
 
     C                   EVAL      RACPRPT = MType(PtypIdx)
     C                   EVAL      RRDRFID = MDocRefId(PtypIdx)
     C                   EVAL      RRCRFID = DwCDCRF
 
      ** Format Account Count for screen display
 
     C                   EVAL      PDECS = 0
     C                   EVAL      RRCNCNT = MCount(PtypIdx)
     C                   EVAL      PFLD15 = %DEC(RRCNCNT:9:0)
     C                   EXSR      SRCvtAmt
     C                   EVAL      RRCNCNT = %TRIM(POUT22)
 
 
      ** Get number of decimal places for the given currency
 
     C                   EVAL      PCcyCD = MCurrCd(PtypIdx)
     C                   EVAL      PDECS = 0
     C                   EXSR      SrCurrCd
 
      * Format amount before display
 
     C                   EVAL      RRCNBAL = MBalance(PtypIdx)
     C                   EVAL      PFLD15 = %DEC(RRCNBAL:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      RRCNBAL = %TRIM(POUT22)
     C                   EVAL      RRCNCCY = MCurrCd(PtypIdx)
 
     C                   WRITE     GL000662R0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCsNhEx - Customer/Naho record extract routine               *
      *                                                               *
      *****************************************************************
     C     SrCsNhEx      BEGSR
 
     C                   EVAL      ElmtIndx = 1
     C                   EVAL      WCount = %SUBST(RACPRPT:8:1)
 
     C                   DOU       ElmtIndx > MaxElmt
     C                   EVAL      KMgElmt = %TRIM(ElmtArr(ElmtIndx)) + WCount
 
     C     KPoolRP2      SETLL     GLRMDTL1
     C     KPoolRP2      READE     GLRMDTL1
 
     C                   DOW       NOT %EOF(GLRMDTL1)
 
      ** Save records in the array
 
     C                   EVAL      WNexPos = 0
     C                   EVAL      WstrTps = 1
     C                   EVAL      Wlength = 26
 
     C                   EVAL      WPoolCust = 'PoolListCust' + WCount
 
     C                   DOW       WstrTps < WMaxPos
 
     C                   EVAL      WTotIndx = WnahIdx + WcusIdx
     C                   IF        WTotIndx = MaxRecd
     C                   LEAVE
     C                   ENDIF
 
     C                   EVAL      WMsgDta = *BLANKS
     C                   EVAL      WMsgDta=%TRIM(%SUBST(MGDATA:WstrTps:Wlength))
 
     C                   IF        WMsgDta = *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   IF        MGELMT = WPoolCust
 
      ** Populate array for sorting
 
     C                   EVAL      WcusIdx = WcusIdx + 1
     C                   EVAL      ARCUSL(WcusIdx)  = WMsgDta
 
     C                   ELSE
 
      ** Populate array for sorting
 
     C                   EVAL      WnahIdx = WnahIdx + 1
     C                   EVAL      ARNAHL(WnahIdx) = WMsgDta
 
     C                   ENDIF
 
     C                   EVAL      WstrTps = WstrTps + Wlength
     C                   EVAL      WNexPos = WstrTps + Wlength
 
      ** If next position is greater than the maximum length of message data
      ** exit from the subfile wirting
 
     C                   IF        WNexPos > WMaxPos
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
      ** Save last customer/naho index
 
     C                   EVAL      WSaVCIx = WcusIdx
     C                   EVAL      WSavNIx = WnahIdx
 
     C     KPoolRP2      READE     GLRMDTL1
 
     C                   ENDDO
 
      ** Get next element
 
     C                   EVAL      ElmtIndx = ElmtIndx + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPoolWdt - Populate pool details field and write the customer*
      *            /Naho list details                                 *
      *                                                               *
      *****************************************************************
     C     SrPoolWdt     BEGSR
 
      ** Process customer list
     C                   SORTA     ARCUSL
     C                   DOW       WcusIdx > 0
 
     C                   EVAL      WMsgDta = ARCUSL(WcusIdx)
     C                   IF        WMsgDta = *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   EXSR      SRCallCS
     C                   EVAL      WcusIdx = WcusIdx - 1
 
      ** Convert amount to display format
     C                   EVAL      WBalance = *BLANKS
     C                   EVAL      WBalance = %TRIM(%SUBST(WMsgDta:12:15))
     C                   EVAL      PFLD15 = %DEC(WBalance:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      RTOTBL = POUT22
 
      ** Check for sufficient lines
     C                   Eval      Rqdln1 = 1
     C                   EXSR      SrCheckL
 
      ** Write details
     C                   WRITE     GL000662D0
 
     C                   ENDDO
 
      **Process Naho list
     C                   SORTA     ARNAHL
     C                   DOW       WnahIdx > 1
 
     C                   EVAL      WMsgDta = ARNAHL(WnahIdx)
 
     C                   IF        WMsgDta = *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   EXSR      SRCallNH
     C                   EVAL      WnahIdx = WnahIdx - 1
 
      ** Convert amount to display format
     C                   EVAL      WBalance = *BLANK
     C                   EVAL      WBalance = %TRIM(%SUBST(WMsgDta:12:15))
     C                   EVAL      PFLD15 = %DEC(WBalance:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      RTOTBL = POUT22
 
      ** Check for sufficient lines
     C                   Eval      Rqdln1 = 1
     C                   EXSR      SrCheckL
 
      ** Write details
     C                   WRITE     GL000662D0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCheckL - Check that sufficient lines remain for the Format *
      *             If not,  write out the Main Headings on a new page*
      *                                                               *
      *****************************************************************
     C     SrCheckL      BEGSR
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
     C                   WRITE     GL000662R0
     C                   ENDIF
 
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
 
     C                   EVAL      RCSNAH = *BLANKS
     C                   EVAL      RCSNAH =%TRIM(%SUBST(WMsgDta:1:6))
     C                   EVAL      WCusNah = RCSNAH
 
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
 
     C                   EVAL      RCNRPN = *BLANKS
     C                   EVAL      RRPTTW = *BLANKS
     C                   EVAL      RCNRPN = BBCRNM
     C                   EVAL      RRPTTW = BBCRTN
 
 
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
 
     c                   EVAL      RCSNAH = *BLANKS
     C                   EVAL      RCSNAH =%TRIM(%SUBST(WMsgDta:1:10))
     C                   EVAL      WCusNah = RCSNAH
 
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
 
     C                   EVAL      RRPTTW = *BLANKS
     C                   EVAL      RCNRPN = *BLANKS
     C                   EVAL      RCNRPN = NHNARN
     C                   EVAL      RRPTTW = NHNATW
 
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
     C                   EVAL      DBPGM = 'GL000662P'
 
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
