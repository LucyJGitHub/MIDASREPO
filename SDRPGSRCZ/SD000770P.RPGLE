     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Self Declaration Statement Summary')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SD000770P - SD Tax Self Declaration Statement Report         *
      *                                                               *
      *  Function:  This module will list out all the annual taxable  *
      *             income by customer.                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR787305           Date 13Jun11               *
      *                 AR782377           Date 04Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237337             Date 03Oct06               *
      *                 CSD027A            Date 05May06               *
      *                 232543             Date 14Mar05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787305 - Tax Self Declaration Statement usability issues   *
      *  AR782377 - Retail account's income not reflected on Tax      *
      *             Self-Declaration Statement                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  237337 - Avoid database error if customer deleted (ie,       *
      *           PRTCD = '*CUSDEL')                                  *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  232543 - Fix to CGL031                                       *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         End of file for SDCSINPD                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRAccHld - Read file by Customer Number.                      *
      * SRNonAccHld - Read file by Non Account Holder.                *
      * SRProc - Read file and process details.                       *
      * SRPrnt - Print details.                                       *
      * SREnd - Write End of Report.                                  *
      * SRRtvCust - Retrieve Customer Details.                        *
      * SRRtvNaho - Retrieve Non-Account Holder Details.              *
      * SRCurr - Get Currency Description.                            *
      * SRFmtD - Format details for output.                           *
      * SRFmtA - Format detail amount based on the currency.          *
      * SRFmtTr1 - Format trailer total amount in Settl curr.         *
      * SRFmtTr2 - Format trailer total amount in Base curr.          *
      * SRAddTot - Sum-up total fields for trailer.                   *
      * SRZeroT1 - Initialize Total per Currency to *Zeros.           *
      * SRZeroT2 - Initialize Total per Customer to *Zeros.           *
      * SRFmtTran - Format Transaction type field.                    *
      * SRAudt - Write audit report.                                  *
      * *PSSR - Error processing.                                     *
      * *INZSR - Initialise.                                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Income by Cust#, Curr, Pymnt date, Modid, Instr ref
     FSDCSINL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer Income by non-account holder#, Curr, Pymnt date
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCSIND0:SDCSIND3)
 
      ** Tax Self Declaration Statement - Detail
     FSD000770P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
 
      ** Tax Self Declaration Statement - Audit
     FSD000770AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ***  File Information Data Structure for SD000770P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ***  File Information Data Structure for SD000770AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for customer details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** DS for access objects - longt data structure                                       BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** Externally described DS for account master file                                    AR787305
     D ACCT          E DS                  EXTNAME(ACCNTAB)                                 AR787305
 
     D PData           DS           100
     D   PTaxyr                1      4  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PPSeq           S              5
     D PLevel          S              1
     D PAct            S              1
     D PCmd            S              1
 
      ** Parameter list for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PNaho           S             10
     D PKySt           S              7
     D PCurr           S              3
     D PBrch           S              3A
 
      ** Parameter list for ZDATE2
     D PVDat           S              5  0
     D PFDat           S              6  0
     D PZDat           S              7
 
      ** Parameter list for ZSEDITF
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21
 
     D WRun            S              1
     D Wctr            S              1
     D WPrtFlg         S              1
     D Wopen           S              1    INZ('N')
     D WPrnt           S              1    INZ('N')
     D Rqdln1          S              2  0
     D Difln1          S              2  0
     D Senty           S              3
     D ZSErr           S              1
     D ZSNum           S              6  0
     D ZSNuMu          S              6  0
 
     D WCurr           S              3
     D WCust           S             10
     D WDlln           S              6
     D*WAcod****       S              4                                                       CGL035
     D WAcod           S             10                                                       CGL035
     D WAcsq           S              2
     D WDateDD         S              2A   Inz
     D WDateMM         S              2A   Inz
     D WDateYY         S              2A   Inz
     D WIpdt           S              6A
 
     D WkRPamS         S                   Like(TSPAMS)
     D WkRGinS         S                   Like(TSGINS)
     D*WkRNinS***      S                   Like(TSNINS)                                       232543
     D WkR1PamS        S                   Like(TSPAMS)
     D WkR1GinS        S                   Like(TSGINS)
     D*WkR1NinS**      S                   Like(TSNINS)                                       232543
     D WkR2PamB        S                   Like(TSPAMB)
     D WkR2GinB        S                   Like(TSGINB)
     D*WkR2NinB**      S                   Like(TSNINB)                                       232543
     D WBCcyPl         S                   Like(A6NBDP)
     D WSCcyPl         S                   Like(A6NBDP)
 
      ** ZDATE10 fields                                                                     AR787305
     D PDateIn         S              8S 0                                                  AR787305
     D PMDNO           S              5P 0                                                  AR787305
                                                                                            AR787305
     D WDayNo          S              5P 0                                                  AR787305
                                                                                            AR787305
      ** ZDATE2 fields                                                                      AR787305
     D PzDayNo         S              5  0                                                  AR787305
     D PzDatFm         S              1                                                     AR787305
     D PzDate          S              6  0                                                  AR787305
     D PzADate         S              7                                                     AR787305
                                                                                            AR787305
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EVAL      Wctr    = 'N'
     C                   EVAL      WPrtFlg = 'N'
     C                   EVAL      WCurr   = *Blanks
     C                   EVAL      WCust   = *Blanks
     C                   EVAL      TAXYR   = PTaxYr
 
     C                   EXSR      SRAccHld
     C                   EXSR      SRNonAccHld
     C                   EXSR      SREnd
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccHld - Read file by Customer Number.                     *
      *                                                               *
      *****************************************************************
     C     SRAccHld      BEGSR
 
     C     *Loval        SETLL     SDCSINL2
     C                   READ      SDCSINL2                               26
 
     C                   EVAL      WCust = *Blanks
     C                   EVAL      WCurr = *Blanks
 
     C                   DOW       *IN26 = *OFF
 
     C                   IF        TSTAXY = PTaxYr and
     C                             TSSTAT = 'S'
     C                   EVAL      RCustN = TSCust
 
      **  IF Cust# changes, get details.
 
     C                   IF        WCust <> RCustN
     C                   EXSR      SRRtvCust
     C                   ENDIF
 
     C                   EXSR      SRProc
     C                   ENDIF
 
     C                   READ      SDCSINL2                               26
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNonAccHld - Read file by Non Account Holder.               *
      *                                                               *
      *****************************************************************
     C     SRNonAccHld   BEGSR
 
     C     *LOVAL        SETLL     SDCSIND3
     C                   READ      SDCSIND3                               26
 
      ** write trailer for total of the previous file.
 
     C                   IF        *IN26 = *OFF      AND
     C                             TSTAXY = PTaxYr   AND
     C                             TSSTAT = 'S'      AND
     C                             WCust <> *Blanks  AND
     C                             WPrnt = 'N'
     C                   EXSR      SRFmtTr1
     C                   WRITE     TRAIL1
     C                   EXSR      SRFmtTr2
     C                   WRITE     TRAIL2
     C                   EXSR      SRZeroT1
     C                   EXSR      SRZeroT2
     C                   ENDIF
 
     C                   EVAL      WCust = *Blanks
     C                   EVAL      WCurr = *Blanks
 
     C                   DOW       *IN26 = *OFF
 
     C                   IF        TSTAXY = PTaxYr and
     C                             TSSTAT = 'S'
     C                   EVAL      RCustN = TSNAHO
 
      **  IF Cust# changes, get details.
 
     C                   IF        WCust <> RCustN
     C                   EXSR      SRRtvNaho
     C                   ENDIF
 
     C                   EXSR      SRProc
     C                   ENDIF
 
     C                   READ      SDCSIND3                               26
     C                   ENDDO
 
      ** No record in SDCSINL2
 
     C                   IF        WPrtFlg = 'N'
     C                   EXSR      SRAudt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Read file and process details                       *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C                   EVAL      Wctr = 'Y'
     C                   EVAL      WPrtFlg = 'Y'
 
      ** Process Report Lines
 
     C                   EXSR      SRPrnt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
     C     SRPrnt        BEGSR
 
     C                   IF        Wopen <> 'Y'
     C                   EVAL      Wopen = 'Y'
     C                   OPEN      SD000770P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSNUM = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSeq
     C                   PARM      *Blanks       SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *Blank        ZSERR
 
      ** IF Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   EVAL      RQDLN1 = 5
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
      *
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
 
     C                   EVAL      WPRNT = 'N'
     C                   IF        WCust <> RCustN
 
     C                   IF        WCust <> *Blanks
     C                   EXSR      SRFmtTr1
     C                   WRITE     TRAIL1
     C                   EXSR      SRFmtTr2
     C                   WRITE     TRAIL2
     C                   EXSR      SRZeroT1
     C                   EXSR      SRZeroT2
     C                   EVAL      WPRNT = 'Y'
     C                   EVAL      WCurr = *Blanks
     C                   ENDIF
 
     C                   EVAL      WCust = RCustN
 
      ** Write Header
 
     C                   WRITE     HEAD1
     C                   ENDIF
 
      ** Change in Currency with the same customer.
 
     C                   IF        WCurr  <> TSSCCY  and
     C                             WCust = RCustN
 
      ** Write Total
 
     C                   IF        WCurr <> *Blanks and
     C                             WPRNT = 'N'
     C                   EXSR      SRFmtTr1
     C                   WRITE     TRAIL1
     C                   EXSR      SRZeroT1
     C                   ENDIF
 
      ** Get currency
 
     C                   EVAL      WCurr = TSSCCY
     C                   EVAL      PCurr = TSSCCY
     C                   EXSR      SRCurr
     C                   EVAL      RCYNM = A6CYNM
     C                   EVAL      RCYCD = A6CYCD
     C                   EVAL      WSCcyPl = A6NBDP
 
     C                   WRITE     HEAD2
     C                   ENDIF
 
     C                   EXSR      SRFmtD
 
      ** Write Detail
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCust - Retrieve Customer Details.                       *
      *                                                               *
      *****************************************************************
     C     SRRtvCust     BEGSR
 
      ** Access customer details file
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RCustN        PCust
     C                   PARM                    PKYSt
     C     SDCust        PARM      SDCust        DSSDY
 
      ** Database error
 
     C*********          IF        PRtcd <> *Blanks                                   237337
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*CUSDEL'            237337
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBFILE = 'SDCustPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
 
      **  Get Customer Details
 
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RCRTN = BBCRTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvNaho - Retrieve Non-Account Holder Details.             *
      *                                                               *
      *****************************************************************
     C     SRRtvNaho     BEGSR
 
      ** Access Non-Account holder details file.
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSNAHO        PNaho
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
      ** Database error
 
     C                   IF        PRtCd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
 
      **  Get Customer Details
 
     C                   EVAL      RCustN= NHNAHO
     C                   EVAL      RCRNM = NHNARN
     C                   EVAL      RCRTN = NHNATW
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurr - Get Currency Details.                               *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR
 
      ** Access currency details file
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCurr        PARM      SDCurr        DSSDY
 
      ** Database error
 
     C                   IF        PRtCd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = PCurr
     C                   EVAL      DBFILE = 'SDCurrPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtA - Format Amount for output.                          *
      *                                                               *
      *****************************************************************
     C     SRFmtA        BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *Blank        ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtD - Format details for output                           *
      *                                                               *
      *****************************************************************
     C     SRFmtD        BEGSR
 
      **   Interest payment date
 
     C**********         EVAL      WDateDD = %SubSt(TSIPDT:7:2)                             AR787305
     C**********         EVAL      WDateMM = %SubSt(TSIPDT:5:2)                             AR787305
     C**********         EVAL      WDateYY = %SubSt(TSIPDT:3:2)                             AR787305
 
     C**********         SELECT                                                             AR787305
     C**********         WHEN      BJDFIN = 'M'                                             AR787305
     C**********         EVAL      WIPDT  = WDateMM + WDateDD + WDateYY                     AR787305
     C**********         WHEN      BJDFIN = 'D'                                             AR787305
     C**********         EVAL      WIPDT  = WDateDD + WDateMM + WDateYY                     AR787305
     C**********         WHEN      BJDFIN = 'Y'                                             AR787305
     C**********         EVAL      WIPDT  = WDateYY + WDateMM + WDateDD                     AR787305
     C**********         ENDSL                                                              AR787305
 
      ** Convert interest date (YYYYMMDD) to Midas Day                                      AR787305
     C                   EVAL      PDateIn = %Dec(TSIPDT:8:0)                               AR787305
     C                   EXSR      SRZDate10                                                AR787305
     C                   Z-ADD     PMDNO         WDayNo                                     AR787305
                                                                                            AR787305
      ** Convert Midas day to printer/screen format                                         AR787305
     C                   EVAL      PzDayNo = WDayNo                                         AR787305
     C                   EVAL      PzDatFm = BJDFIN                                         AR787305
     C                   EVAL      PzDate  = *Zero                                          AR787305
     C                   EVAL      PzADate = *Blanks                                        AR787305
     C                   EXSR      SRZDate2                                                 AR787305
     C                   EVAL      RIPDT = PzADate                                          AR787305
 
     C**********         MOVE      WIPDT         RIPDT                                      AR787305
     C                   EVAL      RMODI = TSMODI
     C                   EXSR      SRFmtTran
 
      ** Format amount in settlement currency
 
     C                   EVAL      ZDECS   = WSCcyPl
 
      ** Principal amount
 
      ** Convert to absolute value                                                          AR787305
     C                   IF        TSPAMS < 0                                               AR787305
     C                   EVAL      TSPAMS = TSPAMS * -1                                     AR787305
     C                   ENDIF                                                              AR787305
                                                                                            AR787305
     C                   EVAL      WkRPamS = TSPAMS
     C                   EVAL      ZFLD15  = TSPAMS
     C                   EXSR      SRFmtA
     C                   MOVE      ZOUT21        Rpams
 
      ** Gross Interest
 
     C                   EVAL      WkRGinS = TSGINS
     C                   EVAL      ZFLD15  = TSGINS
     C                   EXSR      SRFmtA
     C                   MOVE      ZOUT21        RGinS
 
      ***Net*Interest                                                                         232543
      **********                                                                              232543
     C**********         EVAL      WkRNinS = TSNINS                                           232543
     C**********         EVAL      ZFLD15  = TSNINS                                           232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        RNinS                                        232543
      **********                                                                              232543
     ***Accumulate PAMS, GINS, NINS for total                                                 232543
      **********                                                                              232543
     ** Accumulate PAMS, GINS for total                                                       232543
 
     C                   EXSR      SRAddTot
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAddTot - Sum-up total fields for trailer                   *
      *                                                               *
      *****************************************************************
     C     SRAddTot      BEGSR
 
      ** Totals per Currency
 
     C                   ADD       WkRPamS       WkR1PamS
     C                   ADD       WkRGinS       WkR1GinS
     C**********         ADD       WkRNinS       WkR1NinS                                     232543
 
      ** Totals per customer
 
     C                   ADD       TSPAMB        WkR2PamB
     C                   ADD       TSGINB        WkR2GinB
     C**********         ADD       TSNINB        WkR2NinB                                     232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtTr1 - Format Trailer amounts by currency.               *
      *                                                               *
      *****************************************************************
     C     SRFmtTr1      BEGSR
 
     C                   EVAL      ZDECS   = WSCcyPl
 
      ** Principal amount
 
     C                   EVAL      ZFLD15  = WkR1PamS
     C                   EXSR      SRFmtA
     C                   MOVE      ZOUT21        R1PamS
 
      ** Gross Interest
 
     C                   EVAL      ZFLD15  = WkR1GinS
     C                   EXSR      SRFmtA
     C                   MOVE      ZOUT21        R1GinS
 
      ***Net*Interest                                                                         232543
      **********                                                                              232543
     C**********         EVAL      ZFLD15  = WkR1NinS                                         232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        R1NinS                                       232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtTr2 - Format Trailer amounts by country of residence.   *
      *                                                               *
      *****************************************************************
     C     SRFmtTr2      BEGSR
 
      ** Format amount in base currency
      ** Retrieve decimal places for base currency
 
     C                   EVAL      PCurr = BJCYCD
     C                   EXSR      SRCurr
     C                   EVAL      WBCcyPl = A6NBDP
     C                   EVAL      ZDECS   = WBCcyPl
 
      ** Principal amount
 
     C                   EVAL      ZFLD15  = WkR2PamB
     C                   EXSR      SRFmtA
     C                   MOVE      ZOUT21        R2PamB
 
      ** Gross Interest
 
     C                   EVAL      ZFLD15  = WkR2GinB
     C                   EXSR      SRFmtA
     C                   MOVE      ZOUT21        R2GinB
 
      ***Net*Interest.                                                                        232543
      **********                                                                              232543
     C**********         EVAL      ZFLD15  = WkR2NinB                                         232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        R2NinB                                       232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZeroT1 - Initialize Total per Currency to *Zeros.          *
      *                                                               *
      *****************************************************************
     C     SRZeroT1      BEGSR
 
     C                   EVAL      WkR1PamS = *Zeros
     C                   EVAL      WkR1GinS = *Zeros
     C**********         EVAL      WkR1NinS = *Zeros                                          232543
 
     C                   EVAL      R1PamS   = *Blanks
     C                   EVAL      R1GinS   = *Blanks
     C**********         EVAL      R1NinS   = *Blanks                                         232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZeroT2 - Initialize Total per Customer to *Zeros.          *
      *                                                               *
      *****************************************************************
     C     SRZeroT2      BEGSR
 
     C                   EVAL      WkR2PamB = *Zeros
     C                   EVAL      WkR2GinB = *Zeros
     C**********         EVAL      WkR2NinB = *Zeros                                          232543
 
     C                   EVAL      R2PAMB   = *Blanks
     C                   EVAL      R2GINB   = *Blanks
     C**********         EVAL      R2NINB   = *Blanks                                         232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtTran - Format Transaction type field.                   *
      *                                                               *
      *****************************************************************
     C     SRFmtTran     BEGSR
 
     C                   EVAL      RTRANT = *Blanks
 
     C                   SELECT
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDLLN
     C                   EVAL      RTRANT = WDLLN + '-' +
     C                                      TSTRTP + '/' + TSTRST
 
     C**********         WHEN      TSMODI = 'R'                                             AR782377
     C                   WHEN      TSMODI = 'G'                                             AR782377
     C                   MOVE      TSACOD        WAcod
     C                   MOVE      TSACSQ        WAcsq
     C**********         EVAL      RTRANT = WAcod + ' - ' +                                 AR787305
     C**********                            WAcsq                                           AR787305
      ** Get the account number                                                             AR787305
     C                   CALL      'AOACCTR0'                           90                  AR787305
     C                   PARM      *BLANK        P@RTCD            7                        AR787305
     C                   PARM      '*KEY   '     P@OPTN            7                        AR787305
     C                   PARM      *BLANK        P@RETL           10                        AR787305
     C                   PARM      TSCUST        P@CNUM            6                        AR787305
     C                   PARM      TSOCCY        P@CUCD            3                        AR787305
     C                   PARM      WAcod         P@ACCD           10                        AR787305
     C                   PARM      WAcsq         P@ACSQ            2                        AR787305
     C                   PARM      TSBRCA        P@BRCA            3                        AR787305
     C     ACCT          PARM      ACCT          DSSDY                                      AR787305
                                                                                            AR787305
     C     P@RTCD        IFEQ      *BLANK                                                   AR787305
     C     ATYP          ANDEQ     'R'                                                      AR787305
     C                   MOVEL     ACNO          RTRANT                                     AR787305
     C                   ENDIF                                                              AR787305
 
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      RTRANT = TSSESN + TSETYP
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write End of Report.                                 *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Print total at the end of the report
 
     C                   EVAL      RQDLN1 = 6
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   WRITE     HEAD2
     C                   ENDIF
 
      ** Write out report trailer
 
     C                   EXSR      SRFmtTr1
     C                   WRITE     TRAIL1
     C                   EXSR      SRFmtTr2
     C                   WRITE     TRAIL2
     C                   WRITE     ENDRPT
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudt - Write audit report                                  *
      *                                                               *
      *****************************************************************
     C     SRAudt        BEGSR
 
     C                   OPEN      SD000770AU
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      ZSNUMU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSeq
     C                   PARM      *Blanks       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *Blank        ZSERR
 
      ** IF Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** IF there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, IF no records read, Output "No Details" message.
 
     C                   IF        Wctr ='N'
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PPSEQ
     C                   PARM                    PLevel
     C                   PARM                    SEnty
     C                   PARM                    PData
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ELSE
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work fields.
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      OFLLN1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically IF a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudt
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                     AR787305
      *  SRZDate10 - Convert YYYYMMDD Format Date to Midas Day No.    *                     AR787305
      *                                                               *                     AR787305
      *****************************************************************                     AR787305
                                                                                            AR787305
     C     SRZDate10     BEGSR                                                              AR787305
                                                                                            AR787305
     C                   CALLB     'ZDATE10'                                                AR787305
     C                   PARM                    PDateIN                                    AR787305
     C                   PARM      *ZEROS        PMDNO                                      AR787305
                                                                                            AR787305
     C                   ENDSR                                                              AR787305
      *****************************************************************                     AR787305
      /EJECT                                                                                AR787305
      *****************************************************************                     AR787305
      *                                                               *                     AR787305
      * SrZDate2 - Convert date from file format to screen format     *                     AR787305
      *                                                               *                     AR787305
      *****************************************************************                     AR787305
                                                                                            AR787305
     C     SrZDate2      BEGSR                                                              AR787305
                                                                                            AR787305
     C                   CALL      'ZDATE2'                                                 AR787305
     C                   PARM                    PzDayNo                                    AR787305
     C                   PARM                    PzDatFm                                    AR787305
     C                   PARM                    PzDate                                     AR787305
     C                   PARM                    PzADate                                    AR787305
                                                                                            AR787305
     C                   ENDSR                                                              AR787305
                                                                                            AR787305
      *****************************************************************                     AR787305
      /EJECT                                                                                AR787305
      *****************************************************************                     AR787305
**  CPY@
(c) Finastra International Limited 2004
