     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Deducted Report - By Transaction')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD006667P - Tax Deducted Report - By Transaction             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 235045  *CREATE    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  235045 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *    01         End of file SDCSINL1                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR  - Program exception error routine                     *
      *  SRProcess - Process Records                                  *
      *  SRStrFld - Store Report Fields                               *
      *  SRRefNum - Store Reference Number for Validatio              *
      *  SRPrint - Print Report                                       *
      *  SRPrtCcyTot - Print Total for Currency                       *
      *  SRPrtCusTot - Print Total for Customer                       *
      *  SRZSEditF - Convert numeric field                            *
      *  SREnd - Write Trailer in Report                              *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Customer Income - Customer Number
     FWKETCSINL1IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Joint Account Members Audit List - Detail
     FSD006667P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** SD Joint Account Members Audit List - Audit
     FSD006667AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Customer Number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Non A/c Holder Reference
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for SD Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access objects - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for SD006666P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD006666AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PTaxYr                 1      4
 
      ** Interest Payt Date - variable for conversion
     D WIPDte          DS             8
     D  WIPYY                  3      4
     D  WIPMM                  5      6
     D  WIPDD                  7      8
 
      ** Interest Payt Date - 6A format
     D WIPDte6         DS             6
     D  WIPChr1                1      2
     D  WIPChr2                3      4
     D  WIPChr3                5      6
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PKey            S              7
     D PSARd           S              6
     D PCustNo         S             10
     D PCcy            S              3
 
      ** Parameters for ZSEDITF
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D PEChar          S              1
     D POut21          S             21
 
      ** Parameter list fields
     D PLev            S              1
     D PEnty           S              3
     D PACT            S              1
     D PCMD            S              1
 
      ** Total for Currency
     D WTPAM           S             15  0
     D WTGIN           S             15  0
     D WTTXS           S             15  0
     D WTTXC           S             15  0
 
      ** Total for Customer
     D WCPAM           S             15  0
     D WCGIN           S             15  0
     D WCTXS           S             15  0
     D WCTXC           S             15  0
 
      ** Other fields used / Flags
     D WRun            S              1
     D WDecs           S              1  0
     D WNoRec          S              5S 0 INZ(0)
     D WDlLN           S              6
     D WACod           S              4
     D WAcSq           S              2
     D WCcy            S              3
     D WCcyEdt         S              3
     D WTaxCcy         S              3
     D WRefNo          S              6
     D WChkNo          S             10
     D WTaxYr          S              4  0
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D*WJoint***       S              6  0                                                   CSD027A
     D WJoint          S              6A                                                     CSD027A
 
     D WCcyFlg         S              1
     D WFirst          S              1
     D WRecFnd         S              1
     D WPrinted        S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      *  Process Records
 
     C                   EVAL      WRecFnd = 'N'
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WPrinted = 'N'
 
     C     *LOVAL        SETLL     WKETCSINL1
     C                   READ      WKETCSINL1                             01
 
     C                   EVAL      WCcyFlg = 'Y'
     C                   EVAL      WCcy = TSSCCY
     C                   EVAL      RSCCY = TSSCCY
     C                   EVAL      WTaxCcy = TSTXCY
 
     C                   DOW       *IN01 = *OFF
 
      ***Select*record*with*status*=*'T'*(Taxable)************
 
     C*************      IF        TSSTAT = 'T'
 
     C                   EVAL      WRecFnd = 'Y'
 
      ** Check if there is a change on Transaction Reference
      ** If true, print total for transaction
 
     C                   MOVE      TSDLLN        WDlLN
 
     C                   IF        WPrinted = 'N'
     C                   EVAL      WRefNo = WDlLN
     C                   ENDIF
 
     C                   EVAL      RSREF = WDlLN
     C                   IF        WDlLN <> WRefNo
     C                             AND WPrinted = 'Y'
     C                   EVAL      WCcyFlg = 'Y'
     C                   EXSR      SRPrtCcyTot
     C                   EVAL      WRefNo = WDlLN
     C                   ENDIF
 
     C                   EXSR      SRStrFld
     C                   EVAL      WCcy = TSSCCY
 
      ** Compute number of total records printed.
 
     C                   EVAL      WNoRec = WNoRec + 1
 
     C*************      ENDIF
 
     C                   READ      WKETCSINL1                             01
 
     C                   ENDDO
 
     C                   IF        WRecFnd = 'Y'
     C                   EXSR      SRPrtCcyTot
     C                   ENDIF
 
      ** Print report trailer and audit report.
 
     C                   EXSR      SREnd
 
      ** Return.
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRStrFld - Store Report Fields                               *
      *****************************************************************
     C     SRStrFld      BEGSR
 
      ** Beneficiary/Customer Number.
 
      ** Currency Code/Name
 
     C                   EVAL      RSCCY = TSSCCY
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EXSR      SRGetCcyF
     C                   EVAL      RCYNM = A6CYNM
 
      ** Interest Payment Date
 
     C                   EVAL      WIPDte = TSIPDT
     C                   IF        BJDFIN = 'D'
     C                   EVAL      WIPChr1 = WIPDD
     C                   EVAL      WIPChr2 = WIPMM
     C                   EVAL      WIPChr3 = WIPYY
     C                   ELSE
     C                   EVAL      WIPChr1 = WIPMM
     C                   EVAL      WIPChr2 = WIPDD
     C                   EVAL      WIPChr3 = WIPYY
     C                   ENDIF
 
     C                   EVAL      RIPDT = WIPDte6
 
      ** Module Id
 
     C                   EVAL      RMODI =  TSMODI
 
      ** Transaction Type
 
     C                   SELECT
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDlLN
     C                   EVAL      RTTYP = TSTRTP + ' ' + TSTRST +
     C                                     ' ' + WDlLN
 
     C                   WHEN      TSMODI = 'R'
     C                   MOVE      TSACOD        WACod
     C                   MOVE      TSACSQ        WAcSq
     C                   EVAL      RTTYP =  WACod + ' ' + WAcSq
 
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      RTTYP =  TSSESN + ' ' + TSETYP
     C                   ENDSL
 
      ** Principal Amount
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EVAL      PFld15 =  TSPAMS
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RPAMS
 
     C                   EVAL      WTPAM = WTPAM + TSPAMS
     C                   EVAL      WCPAM = WCPAM + TSPAMB
 
     C                   EVAL      RTSCUST = TSCUST
     C                   EVAL      WJOINT = TSJOIN
     C                   MOVE      WJOINT        RTSJOIN
     C                   EVAL      RTSINVP = TSINVP
 
      ** Gross Interest Amount
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EVAL      PFLd15 =  TSGINS
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RGINS
 
     C                   EVAL      WTGIN = WTGIN + TSGINS
     C                   EVAL      WCGIN = WCGIN + TSGINB
 
      ** Tax Withheld at Source in Original Currency
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EVAL      PFLd15 =  TSTXSR
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTXSR
 
     C                   EVAL      WTTXS = WTTXS + TSTXSR
     C                   EVAL      WCTXS = WCTXS + TSTXSB
 
      ** Exchage Rate
 
     C                   EVAL      RXRST =  TSXRST
 
      ** Tax Withheld at Source in Tax Currency
 
     C                   EVAL      WTaxCcy = TSTXCY
     C                   EVAL      WCcyEdt = TSTXCY
     C                   EVAL      PFLd15 =  TSTXSC
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTXSC
 
     C                   EVAL      WTTXC = WTTXC + TSTXSC
 
      ** Print report
 
     C                   EXSR      SRPrint
 
      ** Clear report fields
 
     C                   EVAL      RIPDT = *BLANKS
     C                   EVAL      RMODI = *BLANKS
     C                   EVAL      RTTYP = *BLANKS
     C                   EVAL      RPAMS = *BLANKS
     C                   EVAL      RGINS = *BLANKS
     C                   EVAL      RTXSR = *BLANKS
     C                   EVAL      RTXSC = *BLANKS
     C                   EVAL      RXRST =  *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPrint - Print Report                                       *
      *****************************************************************
     C     SRPrint       BEGSR
 
     C                   IF        NOT %OPEN(SD006667P1)
     C                   OPEN      SD006667P1
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
      ** Print currency code and name
 
     C                   IF        WCcyFlg = 'Y'
     C                   EVAL      WCcyFlg = 'N'
     C                   WRITE     CCYDET
     C                   ENDIF
 
      ** Print report details
 
     C                   WRITE     DETAIL
 
     C                   EVAL      WPrinted = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPrtCcyTot - Print Total for Currency                       *
      *****************************************************************
     C     SRPrtCcyTot   BEGSR
 
     C                   EVAL      WCcyEdt = RSCCY
 
      ** Convert total Gross Interest Amount
 
     C                   EVAL      PFLd15 =  WTGIN
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTGIN
 
      ** Convert total Tax Withheld in Original Ccy
 
     C                   EVAL      PFLd15 =  WTTXS
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTTXS
 
      ** Convert total Tax Withheld in Tax Ccy
 
     C                   EVAL      WCcyEdt = WTaxCcy
     C                   EVAL      PFLd15 =  WTTXC
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTTXC
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** Print the Header of the report if overflow has occurred
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Print total for currency
 
     C                   WRITE     TOTCCY
 
      ** Clear totals
 
     C                   EVAL      RSCCY = *BLANKS
     C                   EVAL      WTPAM = *ZERO
     C                   EVAL      WTGIN = *ZERO
     C                   EVAL      WTTXS = *ZERO
     C                   EVAL      WTTXC = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRZSEditF - Convert numeric field                            *
      *****************************************************************
     C     SRZSEditF     BEGSR
 
     C                   EXSR      SRGetCcyF
 
     C                   EVAL      PECode = 'J'
     C                   EVAL      PEChar = *BLANKS
     C                   EVAL      POUT21 = *ZERO
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    PEChar
     C                   PARM                    POut21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGetCcyF - Get Currency Format                              *
      *****************************************************************
     C     SRGetCcyF     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WCcyEdt       PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WCcyEdt
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PDecs = A6NBDP
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnd - Write Trailer in Report                              *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Print detail report only if there are records to print
 
     C                   IF        %OPEN(SD006667P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
      ** Write audit report
 
     C                   EXSR      SRAudit
 
      ** Close printer files
 
     C                   IF        %OPEN(SD006667AU)
     C                   CLOSE     SD006667AU
     C                   ENDIF
 
     C                   IF        %OPEN(SD006667P1)
     C                   CLOSE     SD006667P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAudit - Write audit report                                 *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   IF        NOT %OPEN(SD006667AU)
     C                   OPEN      SD006667AU
 
     C                   ENDIF
 
      ** Print audit report if there is a DB error or no details to print
 
     C                   IF        *INU7 = *ON OR WNoRec = 0
     C                   WRITE     HEADAU
 
      ** Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
      ** No details to print.
 
     C                   IF        WNoRec = 0
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve base currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCYCD        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = BJCYCD
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WDecs = A6NBDP
     C                   ENDIF
 
      ** Report Work fields
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
