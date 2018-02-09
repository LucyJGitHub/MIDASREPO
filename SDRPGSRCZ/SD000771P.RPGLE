     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Deducted by Ctry of Residence Summary')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SD000771P- SD Tax Deducted by Country of Residence           *
      *             Summary Report                                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26875           Date 11Jan10               *
      *                 BUG24940           Date 15Jul09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23738A          Date 17Apr09               *
      *                 BUG23738           Date 15Apr09               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26875 - SDC000771 10002 Printer Overflow.                 *
      *  BUG24940 - Cannot produce Tax Deducted by Country of         *
      *             Residence Detailed/Summary                        *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23738A - CGC2050 00023                                    *
      *  BUG23738 - CGC2050 00023                                     *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER048 - German Features - Taxes                             *
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
      *    27         Error while READing file SDCSINPD               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRAccHlD - Read file by Customer Number                       *
      * SRNonAccHlD - Read file by Non Account Holder                 *
      * SRProc - Read file and process details                        *
      * SRPrnt - Print details                                        *
      * SREnd - Write End of Report                                   *
      * SRRtvCust - Retrieve Customer Details                         *
      * SRRtvNaho - Retrieve Non-Account Holder Details               *
      * SRRtvCurr - Get Currency Description                          *
      * SRFmtD - Format details for output                            *
      * SRFmtA - Format detail amount based on the currency           *
      * SRFmtTr1 - Format trailer total amount by Settl curr          *
      * SRFmtTr2 - Format trailer total amount by Country             *
      * SRAddTot - Sum-up total fields for trailer                    *
      * SRAudt - Write audit report                                   *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Income by Cust#, Curr, Pymnt date, Modid, Instr ref
     FSDCSINL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer Income by non-account holder#, Curr, Pymnt date
     FSDCSINL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCSIND0:SDCSIND5)
 
      ** Tax Self Declaration Statement - Detail
     FSD000771P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
 
      ** Tax Self Declaration Statement - Audit
     FSD000771AUO    E             PRINTER INFDS(SPOOLU)
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
 
      ***  File Information Data Structure for SD000771P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ***  File Information Data Structure for SD000771AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for country details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL035
 
      ** Externally described DS for customer details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Location details                                       BUG24940
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24940
      *                                                                                     BUG24940
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access objects - long data structure                                        BUG23738
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23738
                                                                                            BUG23738
     D PData           DS           100
     D   PTaxyr                1      4  0
     D   PCTRT                 5      6
     D   PRCTR                 7      8
 
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PPSeq           S              5
     D PLevel          S              1
     D PAct            S              1
     D PCmd            S              1
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
 
      ** Parameter list for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PNaho           S             10
     D PKySt           S              7
     D PSccy           S              3
     D PBrch           S              3A
     D PCoun           S              2A
     D PSard           S              6A                                                      CER048
 
      ** Parameter list for ZSEDITF
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21
      *                                                                                     BUG24280
     D WStaxYr         S              8A                                                    BUG24280
     D WEtaxYr         S              8A                                                    BUG24280
     D WMmDd           S              4A                                                    BUG24280
     D WSYear          S              5P 0                                                  BUG24280
     D WEYear          S              5P 0                                                  BUG24280
     D TYear           S              4P 0                                                  BUG24280
     D WWYeaR          S              4P 0                                                  BUG24280
     D WYear2          S              2P 0                                                  BUG24280
     D WYear           S              4A                                                    BUG24280
     D WKYeaRr         S              4A                                                    BUG24280
     D WWYr2           S              4P 0                                                  BUG24280
     D WJeyd           S              5P 0                                                  BUG24280
      *                                                                                     BUG24280
     D PZDate1         S              8S 0                                                  BUG24280
     D PZDayNo         S              5P 0                                                  BUG24280
     D PErrorFlag      S              1A                                                    BUG24280
     D PDate           S              8S 0                                                  BUG24280
     D PDayNo          S              5P 0                                                  BUG24280
      *                                                                                     BUG24940
     D WYrEndD         S              6A                                                    BUG24940
     D WYrEndP         S              5  0                                                  BUG24940
 
     D WRun            S              1
     D WCtr            S              1
     D WPrtFlg         S              1
     D WOPEN           S              1    INZ('N')
     D WPrnt           S              1    INZ('N')
     D RQDLN1          S              2  0
     D DIFLN1          S              2  0
     D SENTY           S              3
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D ZSNUMU          S              6  0
 
     D WSCCY           S              3
     D WCUST           S             10
     D WNAME           S             20
     D WTOWN           S             10
     D WCOUN           S             30
     D WRCTR           S              2
 
     D*WkRninB*****    S                   Like(TSNINB)                                       232543
     D*WkRninS*****    S                   Like(TSNINS)                                       232543
     D*WkTotNinS***    S                   Like(TSNINS)                                       232543
     D*WkTotNinB***    S                   Like(TSNINS)                                       232543
     D*WkTotRNinB**    S                   Like(TSNINS)                                       232543
     D WkRtxSC         S                   Like(TSTXSC)                                       232543
     D WkRtxSR         S                   Like(TSTXSR)                                       232543
     D WkTottxSR       S                   Like(TSTXSR)                                       232543
     D WkTottxSC       S                   Like(TSTXSC)                                       232543
     D WkTotRtxSC      S                   Like(TSTXSC)                                       232543
     D WBCcyPl         S                   Like(A6NBDP)
     D WSCcyPl         S                   Like(A6NBDP)
     D WkRSTDT         S                   LIKE(TSSTDT)                                       CER048
     D WkRSTDO         S                   LIKE(TSSTDO)                                       CER048
     D WkTotRSTDT      S                   LIKE(TSSTDT)                                       CER048
     D WkTotSTDO       S                   LIKE(TSSTDO)                                       CER048
     D WkTotSTDT       S                   LIKE(TSSTDT)                                       CER048
     D WkRTTDT         S                   LIKE(TSTTDT)                                       CER054
     D WkRTTDO         S                   LIKE(TSTTDO)                                       CER054
     D WkTotRTTDT      S                   LIKE(TSTTDT)                                       CER054
     D WkTotTTDO       S                   LIKE(TSTTDO)                                       CER054
     D WkTotTTDT       S                   LIKE(TSTTDT)                                       CER054
 
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
 
     C                   EVAL      WCTR    = 'N'
     C                   EVAL      WPRTFLG = 'N'
     C                   EVAL      WRCTR   = *Blanks
     C                   EVAL      WSCCY   = *Blanks
     C                   EVAL      TAXYR   = PTAXYR
     C                   EXSR      SRDatCal                                                 BUG24280
 
     C                   EXSR      SRAccHlD
     C                   EXSR      SRNonAccHlD
     C                   EXSR      SREND
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccHlD - READ file by Customer Number.                     *
      *                                                               *
      *****************************************************************
     C     SRAccHlD      BEGSR
 
     C     *LOVAL        SETLL     SDCSINL4
     C                   READ      SDCSINL4                               26
 
     C                   EVAL      WRCTR = *Blanks
     C                   EVAL      WSCCY = *Blanks
 
     C                   DOW       *IN26 = *OFF
 
     C                   IF        TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear                                         BUG24280
      *                                                                                     BUG24280
     C*********          IF        TSTAXY = PTAXYR  AND                                     BUG24280
     C*********                    TSCTRT = PCTRT   AND                                     BUG24280
     C                   IF        TSCTRT = PCTRT   AND                                     BUG24280
     C                             TSSTAT = 'T'     AND
     C                             PRCTR  = *Blanks
     C                             OR
     C                             PRCTR <> *Blanks AND
     c                             PRCTR  = TSRCTR  AND
     C*********                    TSTAXY = PTAXYR  AND                                     BUG24280
     C                             TSCTRT = PCTRT   AND
     C                             TSSTAT = 'T'
 
     C                   EVAL      RRCTR  = TSRCTR
 
     C                   EXSR      SRRTVCUST
     C                   EXSR      SRPROC
     C                   ENDIF
 
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   READ      SDCSINL4                               26
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNonAccHlD - READ file by Non Account Holder.               *
      *                                                               *
      *****************************************************************
     C     SRNonAccHlD   BEGSR
 
     C     *LOVAL        SETLL     SDCSIND5
     C                   READ      SDCSIND5                               26
 
     C                   DOW       *IN26 = *OFF
 
     C                   IF        TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear                                         BUG24280
      *                                                                                     BUG24280
     C*********          IF        TSTAXY = PTAXYR  AND                                     BUG24280
     C*********                    TSCTRT = PCTRT   AND                                     BUG24280
     C                   IF        TSCTRT = PCTRT   AND                                     BUG24280
     C                             TSSTAT = 'T'     AND
     C                             PRCTR  = *Blanks
     C                             OR
     C                             PRCTR <> *Blanks AND
     c                             PRCTR  = TSRCTR  AND
     C*********                    TSTAXY = PTAXYR  AND                                     BUG24280
     C                             TSCTRT = PCTRT   AND
     C                             TSSTAT = 'T'
 
     C                   EVAL      RRCTR  = TSRCTR
 
     C                   EXSR      SRRTVNAHO
     C                   EXSR      SRPROC
     C                   ENDIF
 
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   READ      SDCSIND5                               26
     C                   ENDDO
 
      ** No record IN SDCSINL2
 
     C                   IF        WPRTFLG = 'N'
     C                   EXSR      SRAUDT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - READ file and process details                       *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      WCTR = 'Y'
     C                   EVAL      WPRTFLG = 'Y'
 
      ** Process Report Lines.
 
     C                   EXSR      SRPRNT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
     C     SRPRNT        BEGSR
 
     C                   IF        WOPEN <> 'Y'
     C                   EVAL      WOPEN = 'Y'
     C                   OPEN      SD000771P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSNUM = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *Blanks       SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *Blank        ZSERR
 
      ** IF Error occurs during ZSFILE processing, then RETURN to the
      ** calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDIF
 
     C**********         EVAL      RQDLN1 = 3                                               BUG26875
     C                   EVAL      RQDLN1 = 6                                               BUG26875
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
 
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
 
     C                   EVAL      WPRNT = 'N'
 
      ** IF there's a change IN country.
 
     C                   IF        WRCTR <> TSRCTR OR
     C                             WSCCY <> TSSCCY AND
     C                             WRCTR = RRCTR
 
      ** Write Total
 
     C                   IF        WRCTR <> *Blanks and
     C                             WRCTR <> TSRCTR
     C                   EXSR      SRFmtTr1
     C                   WRITE     TRAIL1
     C                   EXSR      SRFmtTr2
     C                   WRITE     TRAIL2
     C**********         EVAL      WkTOTNINS  = *Zeros                                        232543
     C**********         EVAL      WkTOTNINB  = *Zeros                                        232543
     C**********         EVAL      WkTOTRNINB = *Zeros                                        232543
     C                   EVAL      WkTOTtxSR  = *Zeros                                        232543
     C                   EVAL      WkTOTtxSC  = *Zeros                                        232543
     C                   EVAL      WkTOTRtxSC = *Zeros                                        232543
     C                   EVAL      WPRNT = 'Y'
     C                   EVAL      WSCCY = *Blanks
     C                   ENDIF
 
     C                   IF        WSCCY <> *Blanks and
     C                             WPRNT = 'N'
     C                   EXSR      SRFmtTr1
     C                   WRITE     TRAIL1
     C**********         EVAL      WkTOTNINS = *Zeros                                         232543
     C**********         EVAL      WkTOTNINB = *Zeros                                         232543
     C                   EVAL      WkTOTtxSR = *Zeros                                         232543
     C                   EVAL      WkTOTtxSC = *Zeros                                         232543
     C                   ENDIF
 
     C                   EVAL      WRCTR = TSRCTR
     C                   EVAL      WSCCY = TSSCCY
     C                   EXSR      SRFmtH
     C                   WRITE     HEAD1
     C                   ENDIF
 
     C                   EXSR      SRFMTD
 
      ** Write Detail
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvBrch - Retrieve Branch Details.                         *
      *                                                               *
      *****************************************************************
     C     SRRtvBrch     BEGSR
 
      ** Access branch details file
 
     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      TSBRCA        PBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PRCTR
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Get Branch name
 
     C                   EVAL      RBRCA = TSBRCA
     C                   EVAL      RBRNM = A8BRNM
 
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
 
     C**********         CALL      'AOCUSTR0'                                               BUG23738
     C                   CALL      'AOCUSTR1'                                               BUG23738
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      TSCUST        PCUST
     C                   PARM                    PKYSt
     C*****SDCUST        PARM      SDCUST        DSSDY                                      BUG23738
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG23738
 
      ** Database error
 
     C*********          IF        PRtcd <> *Blanks                                   237337
     C**********         IF        BBCLST <> 'Y'                                  BUG23738 BUG23738A
     C                   IF        BBCLST <> 'Y' AND                                       BUG23738A
     C                             BBDTDL = 0                                              BUG23738A
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*CUSDEL'            237337
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCUST
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                              BUG23738
 
     C                   EVAL      WCUST = BBCUST
     C                   EVAL      WNAME = BBCRNM
     C                   EVAL      WTOWN = BBCRTN
 
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
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      TSNAHO        PNAHO
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PNAHO
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
 
     C                   EVAL      WCUST = NHNAHO
     C                   EVAL      WNAME = NHNARN
     C                   EVAL      WTOWN = NHNATW
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCtry - Get Country Details.                             *
      *                                                               *
      *****************************************************************
     C     SRRtvCtry     BEGSR
 
      ** Access currency details file
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WRCTR         PCOUN
     C     SDCTRY        PARM      SDCTRY        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSCCY
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WCOUN = A4CNNM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCurr - Get Currency Details.                            *
      *                                                               *
      *****************************************************************
     C     SRRtvCurr     BEGSR
 
      ** Access currency details file
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PSCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = PSCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtH - Format Header for output.                           *
      *                                                               *
      *****************************************************************
     C     SRFmtH        BEGSR
 
      ** Get country name for country of residence
 
     C                   EVAL      RCTRT = TSCTRT
     C                   EVAL      WRCTR = TSCTRT
     C                   EXSR      SRRTVCTRY
     C                   EVAL      RCNNM = WCOUN
 
      ** Get country name for country of residence
 
     C                   EVAL      WRCTR = RRCTR
     C                   EXSR      SRRTVCTRY
     C                   EVAL      RCNNMR = WCOUN
 
      ** Get Settlement currency detail.
 
     C                   EVAL      PSCCY = TSSCCY
     C                   EXSR      SRRtvCurr
     C                   EVAL      RSCCY = TSSCCY
     C                   EVAL      RCYNM = A6CYNM
     C                   EVAL      WSCcyPl = A6NBDP
 
      ** Get Branch name
 
     C                   EXSR      SRRTVBRCH
 
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
     C**********         PARM      *Blank        ZECODE                                       232543
     C                   PARM                    ZECODE                                       232543
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtD - Format details for output.                          *
      *                                                               *
      *****************************************************************
     C     SRFmtD        BEGSR
 
     C                   EVAL      RCUST = WCUST
     C                   EVAL      RTOWN = WTOWN
     C                   EVAL      RNAME = WNAME
 
      ***Format*amount*in settlement curr.                                                    232543
      **********                                                                              232543
     C**********         EVAL      WkRNinS = TSNINS                                           232543
     C**********         EVAL      ZFLD15  = TSNINS                                           232543
     C**********         EVAL      ZDECS   = WSCcyPl                                          232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        RNINS                                        232543
      **********                                                                              232543
      ***Format*amount in base curr.                                                          232543
      ***Retrieve decimal places for base currency.                                           232543
      **********                                                                              232543
     C**********         EVAL      PSCCY = BJCYCD                                             232543
     C**********         EXSR      SRRtvCurr                                                  232543
     C**********         EVAL      WBCcyPl = A6NBDP                                           232543
      **********                                                                              232543
     C**********         EVAL      WkRNinB = TSNINB                                           232543
     C**********         EVAL      ZFLD15  = TSNINB                                           232543
     C**********         EVAL      ZDECS   = A6NBDP                                           232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        RNINB                                        232543
      **********                                                                              232543
     ****Accumulate NINS and NINB for total                                                   232543
                                                                                              232543
      ** Format amount Tax Amount in Original Currency                                        232543
                                                                                              232543
     C                   EVAL      WkRtxSR = TSTXSR                                           232543
     C                   EVAL      ZFLD15  = TSTXSR                                           232543
     C                   EVAL      ZDECS   = WSCcyPl                                          232543
     C                   EXSR      SRFmtA                                                     232543
     C                   MOVE      ZOUT21        RTXSR                                        232543
                                                                                              232543
      ** Format Tax amount in Tax currency                                                    232543
      ** Retrieve decimal places for Tax currency.                                            232543
                                                                                              232543
     C                   EVAL      PSCCY = TSTXCY                                             232543
     C                   EXSR      SRRtvCurr                                                  232543
     C                   EVAL      WBCcyPl = A6NBDP                                           232543
                                                                                              232543
     C                   EVAL      WkRtxSC = TSTXSC                                           232543
     C                   EVAL      ZFLD15  = TSTXSC                                           232543
     C                   EVAL      ZDECS   = A6NBDP                                           232543
     C                   EXSR      SRFmtA                                                     232543
     C                   MOVE      ZOUT21        RTXSC                                        232543
      *                                                                                       CER048
      ** Format amount Secondary Tax Amount in Original Currency                              CER048
      *                                                                                       CER048
     C                   EVAL      WkRSTDO = TSSTDO                                           CER048
     C                   EVAL      ZFLD15  = TSSTDO                                           CER048
     C                   EVAL      ZDECS   = WSCcyPl                                          CER048
     C                   EXSR      SRFmtA                                                     CER048
     C                   MOVE      ZOUT21        RSTDO                                        CER048
      *                                                                                       CER048
      ** Format Secondary Tax amount in Tax currency                                          CER048
      *                                                                                       CER048
     C                   EVAL      WkRSTDT = TSSTDT                                           CER048
     C                   EVAL      ZFLD15  = TSSTDT                                           CER048
     C                   EVAL      ZDECS   = A6NBDP                                           CER048
     C                   EXSR      SRFmtA                                                     CER048
     C                   MOVE      ZOUT21        RSTDT                                        CER048
      *                                                                                       CER054
     C                   EVAL      WkRTTDO = TSTTDO                                           CER054
     C                   EVAL      ZFLD15  = TSTTDO                                           CER054
     C                   EVAL      ZDECS   = WSCcyPl                                          CER054
     C                   EXSR      SRFmtA                                                     CER054
     C                   MOVE      ZOUT21        RSTTDO                                       CER054
      *                                                                                       CER054
     C                   EVAL      WkRTTDT = TSTTDT                                           CER054
     C                   EVAL      ZFLD15  = TSTTDT                                           CER054
     C                   EVAL      ZDECS   = A6NBDP                                           CER054
     C                   EXSR      SRFmtA                                                     CER054
     C                   MOVE      ZOUT21        RSTTDT                                       CER054
                                                                                              232543
     **  Accumulate TINS and TINB for total                                                   232543
 
     C                   EXSR      SRADDTot
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtTr1 - Format Trailer amounts by currency.               *
      *                                                               *
      *****************************************************************
     C     SRFmtTr1      BEGSR
 
     C**********         EVAL      ZFLD15  = WkTotNinS                                        232543
     C**********         EVAL      ZDECS   = WSCcyPl                                          232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        TotNinS                                      232543
      **********                                                                              232543
     C**********         EVAL      ZFLD15  = WkTotNinB                                        232543
     C**********         EVAL      ZDECS   = WBCcyPl                                          232543
     C**********         EXSR      SRFmtA                                                     232543
     C**********         MOVE      ZOUT21        TotNinB                                      232543
                                                                                              232543
     C                   EVAL      ZFLD15  = WkTottxSR                                        232543
     C                   EVAL      ZDECS   = WSCcyPl                                          232543
     C                   EXSR      SRFmtA                                                     232543
     C                   MOVE      ZOUT21        TottxSR                                      232543
                                                                                              232543
     C                   EVAL      ZFLD15  = WkTottxSC                                        232543
     C                   EVAL      ZDECS   = WBCcyPl                                          232543
     C                   EXSR      SRFmtA                                                     232543
     C                   MOVE      ZOUT21        TottxSC                                      232543
      *                                                                                       CER048
     C                   EVAL      ZFLD15  = WkTotSTDO                                        CER048
     C                   EVAL      ZDECS   = WSCcyPl                                          CER048
     C                   EXSR      SRFmtA                                                     CER048
     C                   MOVE      ZOUT21        TotSTDO                                      CER048
      *                                                                                       CER048
     C                   EVAL      ZFLD15  = WkTotSTDT                                        CER048
     C                   EVAL      ZDECS   = WBCcyPl                                          CER048
     C                   EXSR      SRFmtA                                                     CER048
     C                   MOVE      ZOUT21        TotSTDT                                      CER048
 
     C                   EVAL      ZFLD15  = WkTotTTDO                                        CER054
     C                   EVAL      ZDECS   = WSCcyPl                                          CER054
     C                   EXSR      SRFmtA                                                     CER054
     C                   MOVE      ZOUT21        TotTTDO                                      CER054
      *                                                                                       CER054
     C                   EVAL      ZFLD15  = WkTotTTDT                                        CER054
     C                   EVAL      ZDECS   = WBCcyPl                                          CER054
     C                   EXSR      SRFmtA                                                     CER054
     C                   MOVE      ZOUT21        TotTTDT                                      CER054
      *                                                                                       CER054
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtTr2 - Format Trailer amounts by country of residence.   *
      *                                                               *
      *****************************************************************
     C     SRFmtTr2      BEGSR
 
     C**********         EVAL      ZFLD15  = WkTotRNinB                                       232543
     C                   EVAL      ZFLD15  = WkTotRtxSC                                       232543
     C                   EVAL      ZDECS   = WSCcyPl
     C                   EXSR      SRFmtA
     C**********         MOVE      ZOUT21        TotRNinB                                     232543
     C                   MOVE      ZOUT21        TotRtxSC                                     232543
     C                   EVAL      ZFLD15  = WkTotRSTDT                                       CER048
     C                   EVAL      ZDECS   = WSCcyPl                                          CER048
     C                   EXSR      SRFmtA                                                     CER048
     C                   MOVE      ZOUT21        TotRSTDT                                     CER048
 
     C                   EVAL      ZFLD15  = WkTotRTTDT                                       CER054
     C                   EVAL      ZDECS   = WSCcyPl                                          CER054
     C                   EXSR      SRFmtA                                                     CER054
     C                   MOVE      ZOUT21        TotRTTDT                                     CER054
      *                                                                                       CER054
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
 
     C**********         ADD       WkRNINS       WkTotNinS                                    232543
     C**********         ADD       WkRNINB       WkTotNinB                                    232543
     C                   ADD       WkRtxSR       WkTottxSR                                    232543
     C                   ADD       WkRtxSC       WkTottxSC                                    232543
     C                   ADD       WkRSTDO       WkTotSTDO                                    CER048
     C                   ADD       WkRSTDT       WkTotSTDT                                    CER048
 
     C                   ADD       WkRTTDO       WkTotTTDO                                    CER054
     C                   ADD       WkRTTDT       WkTotTTDT                                    CER054
      *                                                                                       CER054
      ** Totals per country of residence
 
     C**********         ADD       WkRNINB       WkTotRNinB                                   232543
     C                   ADD       WkRtxSC       WkTotRtxSC                                   232543
     C                   ADD       WkRSTDT       WkTotRSTDT                                   CER048
     C                   ADD       WkRTTDT       WkTotRTTDT                                   CER054
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write End of Report                                  *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Print total at the end of the report
 
     C                   EVAL      RQDLN1 = 6
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
 
      ** Write OUT report trailer.
 
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
 
     C                   OPEN      SD000771AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSNUMU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *Blanks       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *Blank        ZSERR
 
      ** IF Error occurs during ZSFILE processing, then RETURN to the
      ** calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** IF there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, IF no records READ, Output "No Details" message.
 
     C                   IF        WCtr ='N'
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************                     BUG24280
      /EJECT                                                                                BUG24280
      *****************************************************************                     BUG24280
      *                                                               *                     BUG24280
      *  SRDatCal - Claculate Starting and End Date                   *                     BUG24280
      *                                                               *                     BUG24280
      * Called by: Main Processing                                    *                     BUG24280
      *                                                               *                     BUG24280
      * Calls: None                                                   *                     BUG24280
      *                                                               *                     BUG24280
      *****************************************************************                     BUG24280
     C     SRDatCal      BEGSR                                                              BUG24280
      **********                                                                   BUG24280 BUG24940
      ***Get*the Current Date                                                      BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         CALLB     'ZDATE9'                                        BUG24280 BUG24940
     C**********         PARM      BJEYD         PZDayNo                           BUG24280 BUG24940
     C**********         PARM      *ZEROS        PZDate1                           BUG24280 BUG24940
     C**********         PARM      *BLANKS       PErrorFlag                        BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         IF        PErrorFlag = '0'                                BUG24280 BUG24940
     C**********         MOVEL     PZDate1       WWYr2                             BUG24280 BUG24940
     C**********         ENDIF                                                     BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         IF        PTaxyr = *ZEROS                                 BUG24280 BUG24940
     C**********         MOVE      WWYr2         WWYeaR                            BUG24280 BUG24940
     C**********         ELSE                                                      BUG24280 BUG24940
     C**********         MOVE      PTaxyr        WWYeaR                            BUG24280 BUG24940
     C**********         ENDIF                                                     BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
      ***Get*the Start and End of Tax Year                                         BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         IF        WWYeaR <> WWYr2                                 BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
      ***Convert the End of Year Date No. to YYYYMMDD format                       BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         MOVE      PZDate1       WEtaxYr                           BUG24280 BUG24940
     C**********         MOVE      WWYeaR        WKYeaRr                           BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         EVAL      %SUBST(WEtaxYr:1:4) = WKYeaRr                   BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         MOVE      WETaxYr       PDate                             BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
      ***Convert the End of Year in YYYYMMDD format into Day No                    BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         CALLB     'ZDATE10'                                       BUG24280 BUG24940
     C**********         PARM                    PDate                             BUG24280 BUG24940
     C**********         PARM      *ZEROS        PDayNo                            BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         EVAL      WEYear = PDayNo                                 BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         ELSE                                                      BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         EVAL      WEYear = BJEYD                                  BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         ENDIF                                                     BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         EVAL      WJeyd = BJEYD + 1                               BUG24280 BUG24940
     C                   EVAL      WEYear = WYrEndP                                         BUG24940
     C                   EVAL      WJeyd = WYrEndP + 1                                      BUG24940
      *                                                                                     BUG24280
      ** Convert the End of Year Date No. plus 1 to YYYYMMDD format                         BUG24280
      *                                                                                     BUG24280
     C                   CALLB     'ZDATE9'                                                 BUG24280
     C                   PARM      WJeyd         PZDayNo                                    BUG24280
     C                   PARM      *ZEROS        PZDate1                                    BUG24280
     C                   PARM      *BLANKS       PErrorFlag                                 BUG24280
      *                                                                                     BUG24280
     C                   MOVE      PZDate1       WStaxYr                                    BUG24280
     C**********         EVAL      WMmDd = %SUBST(WStaxYr:5:4)                     BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         MOVE      WWYear        WYear2                            BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         IF        WYear2 <= 39                                    BUG24280 BUG24940
     C**********         MOVEL     20            TYear                             BUG24280 BUG24940
     C**********         ELSE                                                      BUG24280 BUG24940
     C**********         MOVEL     19            TYear                             BUG24280 BUG24940
     C**********         ENDIF                                                     BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         MOVE      WYear2        TYear                             BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         IF        WMmDd <> '0101'                                 BUG24280 BUG24940
     C**********         EVAL      TYear = TYear - 1                               BUG24280 BUG24940
     C**********         ENDIF                                                     BUG24280 BUG24940
      **********                                                                   BUG24280 BUG24940
     C**********         MOVE      TYear         WYear                             BUG24280 BUG24940
     C                   IF        ((A4ETXY <> 3112 AND BJDFIN = 'D')                       BUG24940
     C                             OR (A4ETXY <> 1231 AND BJDFIN = 'M'))                    BUG24940
     C                             AND WETYear >= BJRDNB                                    BUG24940
     C                   EVAL      PTaxyr = PTaxyr - 1                                      BUG24940
     C                   ENDIF                                                              BUG24940
     C                   MOVE      PTaxyr        WYear                                      BUG24940
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
     C                   ENDSR                                                              BUG24280
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
     C                   PARM                    PDATA
 
      ** READ IN Installation Data
 
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
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
      *                                                                                       CER048
      **  Access Switchable features file                                                     CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN36 = *ON                                                CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN36 = *OFF                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Database error                                                                       CER048
      *                                                                                       CER048
     C                   IF        (PRtCd <> *BLANKS) and                                     CER048
     C                             (PRtCd <> '*NRF   ')                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 010                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                     BUG24940
      ** Access Location Code Details                                                       BUG24940
      *                                                                                     BUG24940
     C                   CALL      'AOLOCNR0'                                               BUG24940
     C                   PARM      *BLANKS       PRtCd                                      BUG24940
     C                   PARM      '*KEY'        POptn                                      BUG24940
     C                   PARM      BJSLCD        PLoCod            3                        BUG24940
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG24940
      *                                                                                     BUG24940
     C                   IF        PRtCd <> *BLANKS                                         BUG24940
     C     *LOCK         IN        LDA                                                      BUG24940
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG24940
     C                   EVAL      DBKEY  = PLoCod                                          BUG24940
     C                   EVAL      DBASE  = 008                                             BUG24940
     C                   OUT       LDA                                                      BUG24940
     C                   EXSR      *PSSR                                                    BUG24940
     C                   ENDIF                                                              BUG24940
      *                                                                                     BUG24940
      ** Access Country Code Details                                                        BUG24940
      *                                                                                     BUG24940
     C                   CALL      'AOCTRYR0'                                               BUG24940
     C                   PARM      *BLANKS       PRtCd                                      BUG24940
     C                   PARM      '*KEY'        POptn                                      BUG24940
     C                   PARM      DVCNCD        PCtCod            2                        BUG24940
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG24940
      *                                                                                     BUG24940
     C                   IF        PRtCd <> *BLANKS                                         BUG24940
     C     *LOCK         IN        LDA                                                      BUG24940
     C                   EVAL      DBFILE = 'SDCTRYPD'                                      BUG24940
     C                   EVAL      DBKEY  = PCtCod                                          BUG24940
     C                   EVAL      DBASE  = 009                                             BUG24940
     C                   OUT       LDA                                                      BUG24940
     C                   EXSR      *PSSR                                                    BUG24940
     C                   ELSE                                                               BUG24940
     C                   IF        A4ETXY <> *ZERO                                          BUG24940
     C                   MOVE      BJMRDT        WYearP            2 0                      BUG24940
     C                   MOVE      WYearP        WYrEndD                                    BUG24940
     C                   MOVEL     A4ETXY        WYrEndD                                    BUG24940
      *                                                                                     BUG24940
     C                   CALLB     'ZDATE1'                                                 BUG24940
     C                   PARM                    WYrEndD                                    BUG24940
     C                   PARM      *ZEROS        PZDAYNO           5 0                      BUG24940
     C                   PARM                    BJDFIN                                     BUG24940
     C                   PARM      *BLANKS       PERR              1                        BUG24940
     C                   Z-ADD     PZDAYNO       WETYear           5 0                      BUG24940
      *                                                                                     BUG24940
     C                   IF        WETYear <  BJRDNB                                        BUG24940
     C                   ADD       1             WYearP                                     BUG24940
     C                   MOVE      WYearP        WYrEndD                                    BUG24940
     C                   MOVEL     A4ETXY        WYrEndD                                    BUG24940
      *                                                                                     BUG24940
     C                   CALLB     'ZDATE1'                                                 BUG24940
     C                   PARM                    WYrEndD                                    BUG24940
     C                   PARM      *ZEROS        PZDAYNO           5 0                      BUG24940
     C                   PARM                    BJDFIN                                     BUG24940
     C                   PARM      *BLANKS       PERR              1                        BUG24940
     C                   Z-ADD     PZDAYNO       WETYear           5 0                      BUG24940
     C                   ENDIF                                                              BUG24940
      *                                                                                     BUG24940
     C                   MOVE      PTaxyr        WYrEndD                                    BUG24940
     C                   MOVEL     A4ETXY        WYrEndD                                    BUG24940
      *                                                                                     BUG24940
     C                   CALLB     'ZDATE1'                                                 BUG24940
     C                   PARM                    WYrEndD                                    BUG24940
     C                   PARM      *ZEROS        PZDAYNO                                    BUG24940
     C                   PARM                    BJDFIN                                     BUG24940
     C                   PARM      *BLANKS       PERR              1                        BUG24940
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24940
     C                   ENDIF                                                              BUG24940
     C                   ENDIF                                                              BUG24940
 
     C                   CALLB     'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtCd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   EVAL      *IN37 = *OFF                                               CER054
     C                   IF        PRtCd = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   EVAL      *IN37 = *ON                                                CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Database error                                                                       CER054
      *                                                                                       CER054
     C                   IF        (PRtCd <> *BLANKS) and                                     CER054
     C                             (PRtCd <> '*NRF   ')                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBASE = 011                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Report Work fields
 
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
      *          called automatically IF a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**Calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *Pssr         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
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
** CPY@
(c) Finastra International Limited 2004
