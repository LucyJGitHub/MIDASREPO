     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Ded by Ctry of Res Det Rpt - Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000772P- SD Tax Deducted by Country of Residence           *
      *             Detailed Report                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG24940A          Date 26Aug09               *
      *                 BUG25403           Date 07Aug09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23148A          Date 07May09               *
      *                 BUG23148           Date 14Apr09               *
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
      *                 237338             Date 04Oct06               *
      *                 237337             Date 03Oct06               *
      *                 CSD027A            Date 05May06               *
      *                 232543             Date 14Mar05               *
      *                 CGL035             Date 01Mar05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24940A - Cannot produce Tax Deducted by Country of        *
      *              Residence Detailed/Summary                       *
      *  BUG25403 - Tax Deduction by Ctry of Res Detl Report printer  *
      *             overflow line detected                            *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23148A - Missing fields in report                         *
      *  BUG23148 - Report Layout Changes (Recompile)                 *
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
      *  237338 - I/O error CPF5004 was detected in file SD000772P1   *
      *  237337 - Avoid database error if customer deleted (ie,       *
      *           PRTCD = '*CUSDEL')                                  *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  232543 - Fix to CGL031                                       *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         End of file for SDCSINPD                        *
      *    27         Error while reading file SDCSINPD               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRAccHld - Process Records for Account Holders                *
      * SRNonAccHld - Process Records for Non-account Holders         *
      * SRProc - Read file and process details.                       *
      * SRPrnt - Print details.                                       *
      * SREnd - Write End of Report.                                  *
      * SRRtvCust - Retrieve Customer Details.                        *
      * SRRtvNaho - Retrieve Non-Account Holder Details.              *
      * SRRtvCurr - Get Currency Description.                         *
      * SRTrnTp - Get the transaction type.                           *
      * SRFmtH - Format the report header                             *
      * SRFmtD1- Format details for output to detail1                 *
      * SRFmtD2- Format details for output to detail2                 *
      * SRAddTot - Sum-up total fields for trailer.                   *
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
     FSDCSINL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer Income by non-account holder#, Curr, Pymnt date
     FSDCSINL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCSIND0:SDCSIND5)
 
      ** Tax Self Declaration Statement - Detail
     FSD000772P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
 
      ** Tax Self Declaration Statement - Audit
     FSD000772AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
     D SPOOL1          DS
      *
      ***  File Information Data Structure for SD000772P1.
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
     D SPOOLU          DS
      *
      ***  File Information Data Structure for SD000772AU.
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
 
      ** Externally described DS for Location details                                      BUG24940A
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                               BUG24940A
      *                                                                                    BUG24940A
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access objects - long data structure                                        BUG23738
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23738
                                                                                            BUG23738
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      *                                                                                       CER048
     D PData           DS           100
     D   PTaxyr                1      4  0
     D   PCTRT                 5      6
     D   PRCTR                 7      8
 
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
     D PSccy           S              3
     D PBrch           S              3A
     D PCoun           S              2A
     D PSard           S              6A                                                      CER048
 
     D WRun            S              1
     D WCtr            S              1
     D WPrtFlg         S              1
     D WOpen           S              1    INZ('N')
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
     D XCUST           S             10
     D WDlLN           S              6
     D*WACod****       S              4                                                       CGL035
     D WACod           S             10                                                       CGL035
     D WAcSq           S              2
     D WSNBDP          S              1  0
     D WBNBDP          S              1  0
     D*TOTNINS**       S             15  0                                                    232543
     D*TOTNINB**       S             15  0                                                    232543
     D*TOTRNINB*       S             15  0                                                    232543
     D TOTTXSR         S             15  0                                                    232543
     D TOTTXSC         S             15  0                                                    232543
     D TOTRTXSC        S             15  0                                                    232543
 
      ** Parameters for ZSEDITF
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D PEChar          S              1
     D POut21          S             21
      *                                                                                       CER048
      ** Variable for feature CER048                                                          CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
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
      *                                                                                    BUG24940A
     D WYrEndD         S              6A                                                   BUG24940A
     D WYrEndP         S              5  0                                                 BUG24940A
 
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
     C                   EVAL      XCUST   = *Blanks
     C                   EVAL      TAXYR   = PTAXYR
     C                   EXSR      SRDatCal                                                 BUG24280
 
     C                   EXSR      SRAccHld
     C                   EXSR      SRNonAccHld
     C                   EXSR      SREND
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccHld - Process records for Account Holders               *
      *                                                               *
      *****************************************************************
     C     SRAccHld      BEGSR
 
     C     *LOVAL        SETLL     SDCSINL4
     C                   READ      SDCSINL4                               26
 
     C                   EVAL      WRCTR = *Blanks
     C                   EVAL      WSCCY = *Blanks
     C                   EVAL      XCUST = *Blanks
 
     C                   DOW       *IN26 = *Off
 
     C                   IF        TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear                                         BUG24280
      *                                                                                     BUG24280
     C*********          IF        TSTAXY = PTAXYR  AND                                     BUG24280
     C*********                    TSCTRT = PCTRT   AND                                     BUG24280
     C                   IF        TSCTRT = PCTRT   AND                                     BUG24280
     C                             TSSTAT = 'T'     AND
     C                             TSCUST <>*Blanks AND
     C                             PRCTR  = *Blanks
     C                             OR
     C                             PRCTR <> *Blanks AND
     c                             PRCTR  = TSRCTR  AND
     C*********                    TSTAXY = PTAXYR  AND                                     BUG24280
     C                             TSCTRT = PCTRT   AND
     C                             TSCUST <>*Blanks AND
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
      *  SRNonAccHld - Process Records for Non-account holders        *
      *                                                               *
      *****************************************************************
     C     SRNonAccHld   Begsr
 
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
     C                             TSNAHO <>*Blanks AND
     C                             PRCTR  = *Blanks
     C                             OR
     C                             PRCTR <> *Blanks AND
     c                             PRCTR  = TSRCTR  AND
     C*********                    TSTAXY = PTAXYR  AND                                     BUG24280
     C                             TSCTRT = PCTRT   AND
     C                             TSNAHO <>*Blanks AND
     C                             TSSTAT = 'T'
 
     C                   EVAL      RRCTR  = TSRCTR
 
     C                   EXSR      SRRTVNAHO
 
     C                   EXSR      SRPROC
 
     C                   ENDIF
 
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   READ      SDCSIND5                               26
     C                   ENDDO
 
      ** No records in SDCSINL4 and SDCSINL5
 
     C                   IF        WPRTFLG = 'N'
     C                   EXSR      SRAUDT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Read file and process details                       *
      *                                                               *
      *****************************************************************
     C     SRPROC        Begsr
 
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
     C                   OPEN      SD000772P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSNUM = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *Blanks       SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *Blank        ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDIF
 
     C**********         EVAL      RQDLN1 = 3                                                 CER048
     C**********         EVAL      RQDLN1 = 5                                       CER048 BUG23148A
     C**********         EVAL      RQDLN1 = 12                                      BUG23148A CER054
     C                   EVAL      RQDLN1 = 16                                                CER054
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
 
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
 
      ** If there's a change in Country or Currency
 
     C                   IF        WRCTR <> TSRCTR OR
     C                             WSCCY <> TSSCCY AND
     C                             WRCTR = RRCTR
 
      ** Write Total
 
     C                   IF        WSCCY <> *Blanks
     C                   EXSR      SRFmtTrail1
     C                   WRITE     TRAIL1
     C**********         EVAL      TOTNINS = *Zeros                                           232543
     C**********         EVAL      TOTNINB = *Zeros                                           232543
     C                   EVAL      TOTTXSR = *Zeros                                           232543
     C                   EVAL      TOTTXSC = *Zeros                                           232543
     C                   ENDIF
 
     C                   IF        WRCTR <> *Blanks AND
     C                             WRCTR <> TSRCTR
     C                   EXSR      SRFmtTrail2
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                   237338
     C                                                                                        237338
     C                   IF        DIFLN1 <= RQDLN1                                           237338
     C                   EVAL      RRCTR  = WRCTR                                             237338
     C                   EVAL      RSCCY  = WSCCY                                             237338
     C                   WRITE     HEAD1                                                      237338
     C                   EVAL      RRCTR  = TSRCTR                                            237338
     C                   EVAL      RSCCY = TSSCCY                                             237338
     C                   ENDIF                                                                237338
                                                                                              237338
     C                   WRITE     TRAIL2
     C**********         EVAL      TOTRNINB = *Zeros                                          232543
     C                   EVAL      TOTRTXSC = *Zeros                                          232543
     C                   EVAL      WSCCY = *Blanks
     C                   ENDIF
 
     C                   EVAL      WRCTR = TSRCTR
     C                   EVAL      WSCCY = TSSCCY
     C                   EXSR      SRFmtH
     C                   WRITE     HEAD1
     C
     C                   EVAL      XCUST = *Blanks
     C                   ENDIF
 
     C                   IF        XCUST <> WCUST
     C                   EXSR      SRFMTD1
     C                   WRITE     DETAIL1
     C                   EVAL      XCUST = WCUST
     C                   ENDIF
 
     C                   EXSR      SRFMTD2
 
      ***Accumulate*NINS and NINB for total                                                   232543
      ** Accumulate TXSR and TXSC for total                                                   232543
 
     C                   EXSR      SRAddTot
 
      ** Write Detail
 
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EXSR      SRSecTDet                                                  CER048
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EXSR      SRThdTDet                                                  CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   WRITE     DETAIL2
 
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
 
      ** Database error
 
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
 
     C*********          IF        PRTCD <> *Blanks                                   237337
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
 
      ** Database error.
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PNAHO
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
 
      ** Access country details file
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   Parm      '*KEY   '     POPTN
     C                   Parm      WRCTR         PCOUN
     C     SDCTRY        Parm      SDCTRY        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCOUN
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
     C                   PARM      TSSCCY        PSCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RSCCY = TSSCCY
     C                   EVAL      RCYNM = A6CYNM
     C                   EVAL      WSNBDP = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtH - Format Header for output.                           *
      *                                                               *
      *****************************************************************
     C     SRFmtH        BEGSR
 
      ** Get country name for country of residence.
 
     C                   EVAL      RCTRT = TSCTRT
     C                   EVAL      WRCTR = TSCTRT
     C                   EXSR      SRRTVCTRY
     C                   Eval      RCNNM = WCOUN
 
      ** Get country name for country of residence.
 
     C                   EVAL      WRCTR = RRCTR
     C                   EXSR      SRRTVCTRY
     C                   EVAL      RCNNMR = WCOUN
 
      ** Get Currency name
 
     C                   EXSR      SRRTVCURR
 
      ** Get Branch name
 
     C                   EXSR      SRRTVBRCH
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtD1- Format details for output to detail1                *
      *                                                               *
      *****************************************************************
     C     SRFmtD1       BEGSR
 
     C                   EVAL      RCUST = WCUST
     C                   EVAL      RTOWN = WTOWN
     C                   EVAL      RNAME = WNAME
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtD2- Format details for output to detail2                *
      *                                                               *
      *****************************************************************
     C     SRFmtD2       BEGSR
 
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
 
     C                   EVAL      RMODI = TSMODI
 
      ** Principal Amount
 
     C                   EVAL      PDecs = WSNBDP
     C                   EVAL      PFld15 = TSPAMS
     C                   EXSR      SREdit
     C                   EVAL      RPAMS = POut21
 
      ** Gross Interest Amount
 
     C                   EVAL      PDecs = WSNBDP
     C                   EVAL      PFld15 = TSGINS
     C                   EXSR      SREdit
     C                   EVAL      RGINS = POut21
 
      ** Tax Rate
 
     C                   EVAL      RTXRT = TSTXRT
 
      ** Net Interest Amount in Settlement Currency
 
     C                   EVAL      PDecs = WSNBDP
     C**********         EVAL      PFld15 = TSNINS                                            232543
     C                   EVAL      PFld15 = TSTXSR                                            232543
     C                   EXSR      SREdit
     C**********         EVAL      RNINS = POut21                                             232543
     C                   EVAL      RTXSR = POut21                                             232543
 
      ** Net Interest Amount in Base Currency
 
     C                   EVAL      PDecs = WBNBDP
     C**********         EVAL      PFld15 = TSNINB                                            232543
     C                   EVAL      PFld15 = TSTXSC                                            232543
     C                   EXSR      SREdit
     C**********         EVAL      RNINB = POut21                                             232543
     C                   EVAL      RTXSC = POut21                                             232543
 
      **   Get Transaction Type
 
     C                   EXSR      SRTrnTp
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrnTp- Get the transaction type based on the criteria      *
      *                                                               *
      *****************************************************************
     C     SRTrntp       Begsr
 
     C                   EVAL      RTRAN = *Blanks
 
     C                   SELECT
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDlLN
     C                   EVAL      RTRAN = %TRIM(TSTRTP) + %TRIM(TSTRST)
     C                                   + %TRIM(WDLLN)
 
     C                   WHEN      TSMODI = 'R'
     C                   MOVE      TSACOD        WACod
     C                   MOVE      TSACSQ        WAcSq
     C                   EVAL      RTRAN =  %TRIM(WACod) + %TRIM(WAcSq)
 
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      RTRAN =  %TRIM(TSSESN) + %TRIM(TSETYP)
 
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAddTot - Sum-up total fields for trailer                   *
      *                                                               *
      *****************************************************************
     C     SRAddTot      BEGSR
 
      **  Totals per Currency.
 
     C**********         ADD       TSNINS        TOTNINS                                      232543
     C**********         ADD       TSNINB        TOTNINB                                      232543
     C                   ADD       TSTXSR        TOTTXSR                                      232543
     C                   ADD       TSTXSC        TOTTXSC                                      232543
 
      **  Totals per country of residence.
 
     C**********         ADD       TSNINB        TOTRNINB                                     232543
     C                   ADD       TSTXSC        TOTRTXSC                                     232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREdit - Format Amounts to the right number of decimal place *
      *                                                               *
      *****************************************************************
     C     SREdit        BEGSR
 
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
      *                                                               *
      *  SRFmtTrail1 - Format Amounts for Trailer 1                   *
      *                                                               *
      *****************************************************************
     C     SRFmtTrail1   BEGSR
 
     C                   EVAL      PDecs = WSNBDP
     C**********         EVAL      PFld15 = TOTNINS                                           232543
     C                   EVAL      PFld15 = TOTTXSR                                           232543
     C                   EXSR      SREdit
     C**********         EVAL      RTNINS = POut21                                            232543
     C                   EVAL      RTTXSR = POut21                                            232543
 
     C                   EVAL      PDecs = WBNBDP
     C**********         EVAL      PFld15 = TOTNINB                                           232543
     C                   EVAL      PFld15 = TOTTXSC                                           232543
     C                   EXSR      SREdit
     C**********         EVAL      RTNINB = POut21                                            232543
     C                   EVAL      RTTXSC = POut21                                            232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtTrail2 - Format Amounts for Trailer 2                   *
      *                                                               *
      *****************************************************************
     C     SRFmtTrail2   BEGSR
 
     C                   EVAL      PDecs = WBNBDP
     C**********         EVAL      PFld15 = TOTRNINB                                          232543
     C                   EVAL      PFld15 = TOTRTXSC                                          232543
     C                   EXSR      SREdit
     C**********         EVAL      RTRNINB = POut21                                           232543
     C                   EVAL      RTRTXSC = POut21                                           232543
 
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
 
     C**********         EVAL      RQDLN1 = 6                                               BUG25403
     C                   EVAL      RQDLN1 = 10                                              BUG25403
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   EXSR      SRFmtTrail1
     C                   WRITE     TRAIL1
     C                   EXSR      SRFmtTrail2
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
 
     C                   OPEN      SD000772AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSNUMU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *Blanks       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *Blank        ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
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
      *  SRDatCal - Calculate Starting and End Date                   *                     BUG24280
      *                                                               *                     BUG24280
      * Called by: Main Processing                                    *                     BUG24280
      *                                                               *                     BUG24280
      * Calls: None                                                   *                     BUG24280
      *                                                               *                     BUG24280
      *****************************************************************                     BUG24280
     C     SRDatCal      BEGSR                                                              BUG24280
      **********                                                                  BUG24280 BUG24940A
      ***Get*the Current Date                                                     BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         CALLB     'ZDATE9'                                       BUG24280 BUG24940A
     C**********         PARM      BJEYD         PZDayNo                          BUG24280 BUG24940A
     C**********         PARM      *ZEROS        PZDate1                          BUG24280 BUG24940A
     C**********         PARM      *BLANKS       PErrorFlag                       BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         IF        PErrorFlag = '0'                               BUG24280 BUG24940A
     C**********         MOVEL     PZDate1       WWYr2                            BUG24280 BUG24940A
     C**********         ENDIF                                                    BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         IF        PTaxyr = *ZEROS                                BUG24280 BUG24940A
     C**********         MOVE      WWYr2         WWYeaR                           BUG24280 BUG24940A
     C**********         ELSE                                                     BUG24280 BUG24940A
     C**********         MOVE      PTaxyr        WWYeaR                           BUG24280 BUG24940A
     C**********         ENDIF                                                    BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
      ***Get*the Start and End of Tax Year                                        BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         IF        WWYeaR <> WWYr2                                BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
      ***Convert the End of Year Date No. to YYYYMMDD format                      BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         MOVE      PZDate1       WEtaxYr                          BUG24280 BUG24940A
     C**********         MOVE      WWYeaR        WKYeaRr                          BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         EVAL      %SUBST(WEtaxYr:1:4) = WKYeaRr                  BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         MOVE      WETaxYr       PDate                            BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
      ***Convert the End of Year in YYYYMMDD format into Day No                   BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         CALLB     'ZDATE10'                                      BUG24280 BUG24940A
     C**********         PARM                    PDate                            BUG24280 BUG24940A
     C**********         PARM      *ZEROS        PDayNo                           BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         EVAL      WEYear = PDayNo                                BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         ELSE                                                     BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         EVAL      WEYear = BJEYD                                 BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         ENDIF                                                    BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         EVAL      WJeyd = BJEYD + 1                              BUG24280 BUG24940A
     C                   EVAL      WEYear = WYrEndP                                        BUG24940A
     C                   EVAL      WJeyd = WYrEndP + 1                                     BUG24940A
      *                                                                                     BUG24280
      ** Convert the End of Year Date No. plus 1 to YYYYMMDD format                         BUG24280
      *                                                                                     BUG24280
     C                   CALLB     'ZDATE9'                                                 BUG24280
     C                   PARM      WJeyd         PZDayNo                                    BUG24280
     C                   PARM      *ZEROS        PZDate1                                    BUG24280
     C                   PARM      *BLANKS       PErrorFlag                                 BUG24280
      *                                                                                     BUG24280
     C                   MOVE      PZDate1       WStaxYr                                    BUG24280
     C**********         EVAL      WMmDd = %SUBST(WStaxYr:5:4)                    BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         MOVE      WWYear        WYear2                           BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         IF        WYear2 <= 39                                   BUG24280 BUG24940A
     C**********         MOVEL     20            TYear                            BUG24280 BUG24940A
     C**********         ELSE                                                     BUG24280 BUG24940A
     C**********         MOVEL     19            TYear                            BUG24280 BUG24940A
     C**********         ENDIF                                                    BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         MOVE      WYear2        TYear                            BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         IF        WMmDd <> '0101'                                BUG24280 BUG24940A
     C**********         EVAL      TYear = TYear - 1                              BUG24280 BUG24940A
     C**********         ENDIF                                                    BUG24280 BUG24940A
      **********                                                                  BUG24280 BUG24940A
     C**********         MOVE      TYear         WYear                            BUG24280 BUG24940A
     C                   IF        ((A4ETXY <> 3112 AND BJDFIN = 'D')                      BUG24940A
     C                             OR (A4ETXY <> 1231 AND BJDFIN = 'M'))                   BUG24940A
     C                             AND WETYear >= BJRDNB                                   BUG24940A
     C                   EVAL      PTaxyr = PTaxyr - 1                                     BUG24940A
     C                   ENDIF                                                             BUG24940A
     C                   MOVE      PTaxyr        WYear                                     BUG24940A
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
     C
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve the number of decimal place of Base currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BJCYCD        PSCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBNBDP = A6NBDP
     C                   ENDIF
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRTCD = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN36  = *ON                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN36  = *OFF                                              CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtCd <> '*NRF   '                                         CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 010                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                    BUG24940A
      ** Access Location Code Details                                                      BUG24940A
      *                                                                                    BUG24940A
     C                   CALL      'AOLOCNR0'                                              BUG24940A
     C                   PARM      *BLANKS       PRtCd                                     BUG24940A
     C                   PARM      '*KEY'        POptn                                     BUG24940A
     C                   PARM      BJSLCD        PLoCod            3                       BUG24940A
     C     SDLOCN        PARM      SDLOCN        DSFDY                                     BUG24940A
      *                                                                                    BUG24940A
     C                   IF        PRtCd <> *BLANKS                                        BUG24940A
     C     *LOCK         IN        LDA                                                     BUG24940A
     C                   EVAL      DBFILE = 'SDLOCNPD'                                     BUG24940A
     C                   EVAL      DBKEY  = PLoCod                                         BUG24940A
     C                   EVAL      DBASE  = 008                                            BUG24940A
     C                   OUT       LDA                                                     BUG24940A
     C                   EXSR      *PSSR                                                   BUG24940A
     C                   ENDIF                                                             BUG24940A
      *                                                                                    BUG24940A
      ** Access Country Code Details                                                       BUG24940A
      *                                                                                    BUG24940A
     C                   CALL      'AOCTRYR0'                                              BUG24940A
     C                   PARM      *BLANKS       PRtCd                                     BUG24940A
     C                   PARM      '*KEY'        POptn                                     BUG24940A
     C                   PARM      DVCNCD        PCtCod            2                       BUG24940A
     C     SDCTRY        PARM      SDCTRY        DSFDY                                     BUG24940A
      *                                                                                    BUG24940A
     C                   IF        PRtCd <> *BLANKS                                        BUG24940A
     C     *LOCK         IN        LDA                                                     BUG24940A
     C                   EVAL      DBFILE = 'SDCTRYPD'                                     BUG24940A
     C                   EVAL      DBKEY  = PCtCod                                         BUG24940A
     C                   EVAL      DBASE  = 009                                            BUG24940A
     C                   OUT       LDA                                                     BUG24940A
     C                   EXSR      *PSSR                                                   BUG24940A
     C                   ELSE                                                              BUG24940A
     C                   IF        A4ETXY <> *ZERO                                         BUG24940A
     C                   MOVE      BJMRDT        WYearP            2 0                     BUG24940A
     C                   MOVE      WYearP        WYrEndD                                   BUG24940A
     C                   MOVEL     A4ETXY        WYrEndD                                   BUG24940A
      *                                                                                    BUG24940A
     C                   CALLB     'ZDATE1'                                                BUG24940A
     C                   PARM                    WYrEndD                                   BUG24940A
     C                   PARM      *ZEROS        PZDAYNO           5 0                     BUG24940A
     C                   PARM                    BJDFIN                                    BUG24940A
     C                   PARM      *BLANKS       PERR              1                       BUG24940A
     C                   Z-ADD     PZDAYNO       WETYear           5 0                     BUG24940A
      *                                                                                    BUG24940A
     C                   IF        WETYear <  BJRDNB                                       BUG24940A
     C                   ADD       1             WYearP                                    BUG24940A
     C                   MOVE      WYearP        WYrEndD                                   BUG24940A
     C                   MOVEL     A4ETXY        WYrEndD                                   BUG24940A
      *                                                                                    BUG24940A
     C                   CALLB     'ZDATE1'                                                BUG24940A
     C                   PARM                    WYrEndD                                   BUG24940A
     C                   PARM      *ZEROS        PZDAYNO           5 0                     BUG24940A
     C                   PARM                    BJDFIN                                    BUG24940A
     C                   PARM      *BLANKS       PERR              1                       BUG24940A
     C                   Z-ADD     PZDAYNO       WETYear           5 0                     BUG24940A
     C                   ENDIF                                                             BUG24940A
      *                                                                                    BUG24940A
     C                   MOVE      PTaxyr        WYrEndD                                   BUG24940A
     C                   MOVEL     A4ETXY        WYrEndD                                   BUG24940A
      *                                                                                    BUG24940A
     C                   CALLB     'ZDATE1'                                                BUG24940A
     C                   PARM                    WYrEndD                                   BUG24940A
     C                   PARM      *ZEROS        PZDAYNO                                   BUG24940A
     C                   PARM                    BJDFIN                                    BUG24940A
     C                   PARM      *BLANKS       PERR              1                       BUG24940A
     C                   Z-ADD     PZDAYNO       WYrEndP                                   BUG24940A
     C                   ENDIF                                                             BUG24940A
     C                   ENDIF                                                             BUG24940A
 
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtCd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   EVAL      *IN37  = *OFF                                              CER054
      *                                                                                       CER054
     C                   IF        PRTCD = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   EVAL      *IN37  = *ON                                               CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> *BLANKS AND                                       CER054
     C                             PRtCd <> '*NRF   '                                         CER054
      *                                                                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBASE = 011                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Report Work fields.
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      OFLLN1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   ENDSR
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRSecTDet - Subroutine to populate secondary tax details      *                       CER048
      *                                                               *                       CER048
      * Called by: SRPRNT                                             *                       CER048
      *                                                               *                       CER048
      * Calls: None                                                   *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRSecTDet     BEGSR                                                                CER048
      *                                                                                       CER048
     C                   MOVEL     TSSTXB        RSTXB                                        CER048
     C                   MOVEL     TSSTAC        RSTAC                                        CER048
     C                   MOVEL     TSSTRA        RSTRT                                        CER048
      *                                                                                       CER048
      ** Populate secondary tax deducted at src in orig ccy                                   CER048
      *                                                                                       CER048
     C                   EVAL      PDecs = TSOCDP                                             CER048
     C                   EVAL      PFld15 = TSSTDO                                            CER048
     C                   EXSR      SREdit                                                     CER048
     C                   EVAL      RSTDO = POut21                                             CER048
      *                                                                                       CER048
      ** Populate secondary tax deducted at src in set ccy                                    CER048
      *                                                                                       CER048
     C                   EVAL      PDecs = TSSCDP                                             CER048
     C                   EVAL      PFld15 = TSSTDS                                            CER048
     C                   EXSR      SREdit                                                     CER048
     C                   EVAL      RSTDS = POut21                                             CER048
      *                                                                                       CER048
      ** Secondary tax deducted at src in tax ccy                                             CER048
      *                                                                                       CER048
     C                   EVAL      PDecs = TSSCDP                                             CER048
     C                   EVAL      PFld15 = TSSTDT                                            CER048
     C                   EXSR      SREdit                                                     CER048
     C                   EVAL      RSTDT = POut21                                             CER048
      *                                                                                       CER048
      ** Secondary tax deducted at src in base ccy                                            CER048
      *                                                                                       CER048
     C                   EVAL      PDecs = WBNBDP                                             CER048
     C                   EVAL      PFld15 = TSSTDB                                            CER048
     C                   EXSR      SREdit                                                     CER048
     C                   EVAL      RSTDB = POut21                                             CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      *                                                               *                       CER054
      * SRThdTDet - Subroutine to Populate Third Tax Details          *                       CER054
      *                                                               *                       CER054
      * Called by: SRPrnt                                             *                       CER054
      *                                                               *                       CER054
      * Calls: None                                                   *                       CER054
      *                                                               *                       CER054
      *****************************************************************                       CER054
     C     SRThdTDet     BEGSR                                                                CER054
      *                                                                                       CER054
     C                   MOVEL     TSTTXB        RSTTXB                                       CER054
     C                   MOVEL     TSTTAC        RSTTAC                                       CER054
     C                   MOVEL     TSTTRA        RSTTRA                                       CER054
      *                                                                                       CER054
      ** Populate third tax deducted at src in orig ccy                                       CER054
      *                                                                                       CER054
     C                   EVAL      PDecs = TSOCDP                                             CER054
     C                   EVAL      PFld15 = TSTTDO                                            CER054
     C                   EXSR      SREdit                                                     CER054
     C                   EVAL      RSTTDO = POut21                                            CER054
      *                                                                                       CER054
      ** Populate third tax deducted at src in set ccy                                        CER054
      *                                                                                       CER054
     C                   EVAL      PDecs = TSSCDP                                             CER054
     C                   EVAL      PFld15 = TSTTDS                                            CER054
     C                   EXSR      SREdit                                                     CER054
     C                   EVAL      RSTTDS = POut21                                            CER054
      *                                                                                       CER054
      ** Populate third tax deducted at src in tax ccy                                        CER054
      *                                                                                       CER054
     C                   EVAL      PDecs = TSTCDP                                             CER054
     C                   EVAL      PFld15 = TSTTDT                                            CER054
     C                   EXSR      SREdit                                                     CER054
     C                   EVAL      RSTTDT = POut21                                            CER054
      *                                                                                       CER054
      ** Populate third tax deducted at src in base ccy                                       CER054
      *                                                                                       CER054
     C                   EVAL      PDecs = WBNBDP                                             CER054
     C                   EVAL      PFld15 = TSTTDB                                            CER054
     C                   EXSR      SREdit                                                     CER054
     C                   EVAL      RSTTDB = POut21                                            CER054
      *                                                                                       CER054
     C                   ENDSR                                                                CER054
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
