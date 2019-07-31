     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedges with suspect items')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS001006 - Hedges with Suspect Items                         *
      *                                                               *
      *  Function:  This module reports all live hedges that have     *
      *             suspect items.                                    *
      *                                                               *
      *  Component of: ASC001006                                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 237063             Date 20Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CAS010             Date 09Feb05               *
      *                 229552             Date 12Oct04               *
      *                 229544             Date 15Sep04               *
      *                 229414             Date 15Sep04               *
      *                 229563             Date 14Sep04               *
      *                 228024             Date 27Jun04               *
      *                 226267  *CREATE    Date 23Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  229552 - Hedged securities with zero position not reported   *
      *           correctly in suspected item report.                 *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  229414 - FRA with interest rate is reported w/ zero rate.    *
      *  229563 - "NOT FOUND" status for SE hedge due to missing book *
      *           code.                                               *
      *  228024 - Undefined Link Deal Number causes DB Error          *
      *  226267 - Hedges with Suspect Items                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E  I N D E X                                *
      *                                                               *
      * SRPROCESS -                                                   *
      * SRINL1    - New Hedge Strategy Level Break                    *
      * SRINL3    - New Branch Level Break                            *
      * SRVAL1    - Check if Hedge Linkages Exist                     *
      * SRVAL2    - Search for Live Hedge Linkage Records             *
      * SRLINK    - Hedge Linkage Processing                          *
      * SRTRN1    - Hedge Transaction Processing                      *
      * SRTRN2    - Move data to work fields and print transaction    *
      *             report                                            *
      * SRCHKTRAN - Check Transactions if there are suspect items     *
      * SRDLNO    - Deal Processing                                   *
      * SRLEND    - Loan Processing                                   *
      * SRFHNO    - Forecast Transaction Processing                   *
      * SRSENO    - Securities Processing                             *
      * SRSDLNO   - Set Deals Detail for Reporting                    *
      * SRSLENO   - Set Loans Detail for Reporting                    *
      * SRSFHNO   - Set Forecast Transaction Detail for Reporting     *
      * SRSFFNO   - Set Futures and Options Detail for Reporting      *
      * SRSDLNO   - Set Securities Detail for Reporting               *
      * SRTRN3    - Load Workfields                                   *
      * SRAUDIT   - Subroutine to Output Audit Report and End Program *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDHGSTL2  IF   E           K DISK    INFSR(*PSSR)
      ** Hedge Strategy by Branch/Product Type/Short-name Index
 
     FSDHGSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:@HGSTD0)
      ** Hedge Strategy by Branch/Product Type/Short-name
 
     FASHGLKL2  IF   E           K DISK    INFSR(*PSSR)
      ** Hedge Linkage File Retrieval by Hedge Strategy
 
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)
      ** Hedge Transactions File Update by Hedge ID/Indicator
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:@HTRND0)
      ** Hedge Transaction file RTV by Hedge ID/Indicator
 
     FASFHTRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Forecast Transactions Retrieval Index
 
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
      ** Deals File including Historic
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Loans File
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      ** Securities File
 
     FBKPOSL2   IF   E           K DISK    INFSR(*PSSR)
      ** Book positions file
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
      ** FF Transaction details
 
     FPOSTNK5   IF   E           K DISK    INFSR(*PSSR)
      ** FF Postions file
 
     FDLDLBBL1  IF   E           K DISK    INFSR(*PSSR)
     ** FX Deals by DLNO
     F                                     RENAME(DEALSDBF:DEALDB)
     F                                     RENAME(DLBHISD0:DLBHIS)
     F                                     PREFIX(B)
 
     FDLDLHCL1  IF   E           K DISK    INFSR(*PSSR)
     ** DL Money Market Transactions by DLNO
     F                                     RENAME(DEALSDCF:DEALDC)
     F                                     RENAME(DLCHISD0:DLCHIS)
     F                                     PREFIX(C)
     FDLFRARL4  IF   E           K DISK                                                       229414
     ** DL FRA Rates - Ccy/BRAT/VDAT                                                          229414
     FASHGLKL0  UF   E           K DISK    INFSR(*PSSR)                                       229552
     F                                     RENAME(ASHGLKD0:ASHGLKH1)                          229552
     F                                     PREFIX(H1:2)                                       229552
      ** Hedge Linkage File Retrieval by Hedge I.D.                                           229552
 
     FAS001006P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
      ** Printer file for Today's Expired Hedges Report
 
     FAS001006AUO    E             PRINTER INFDS(SPOOLU)
      ** Printer file for Today's Expired Hedges Report (Audit)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
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
 
      ** Data Area giving Installation Control Details
 
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Month sequence
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
     D NUM             S              2  0 DIM(12) ALT(MON)
 
      ** Field renames to prevent compile errors
     D TP              S              2    DIM(3) CTDATA PERRCD(1)
 
      ** File information data structure
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      ** File Information Data Structure for AS001006P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS001006AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** Work Level indicators
     D WLVLDS          DS
     D  WL3                    1      1
     D  WL2                    2      2
     D  WL1                    3      3
 
      ** Currency Codes Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for access programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External Data Structures for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
     D                 DS
     D  FSFPSE                 1     10
     D  INSKEY                 1      5
     D  INSFLD                 6     10
     D  INSMM@                 6      8
     D  INSYY@                 9     10
     D**FSBKC**               11     12                                                       229563
     D  FSBKCD                11     12                                                       229563
     D  FSBRCA                13     15
     D  FSPCAL                16     16
     D  FSMKTI                17     17
     D  FSBHTV                18     18
     D  FSKEY                  1     18
 
      /EJECT
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Fields used for standard programs
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZFLD15          S             15  0
     D ZOUT22          S             22
 
      ** Key fields
     D KBRCA           S              3
     D KPRTP           S              2
     D KHESN           S             10
     D KDERITEM        S              1
     D KLNKDN          S              6  0
 
      ** Work Fields for SDBANKPD fields
     D WTCount         S              7  0
     D WFore           S              1A
     D WExre           S              1A
     D WIHStrategy     S              1A
     D WIBranch        S              1A
     D X               S              1  0
     D WFirstRec       S              1A
 
      ** Work Fields for ZSFILE
     D PSeq            S              5A
     D PSenty          S              3A
     D PSNum           S              6  0
     D PSErr           S              1A
 
      ** Work Fields for SDBRCHPD fields
     D PDSNB           S              3A
 
      ** Work Fields for Standard Access Objects
     D PRtCd           S              7A
     D POption         S              7A
 
      ** Various Work Fields
     D WRKDLN          S             10A
     D WRKBKC          S              2A
     D*WRKCNU***       S              6  0                                                    CSD027
     D WRKCNU          S              6                                                       CSD027
     D WRKVAL          S              5  0
     D WRKMAT          S              5  0
     D WRKBOV          S              5  0
     D WRKCCY          S              3A
     D WRKPR$          S             13  0
     D WRKINT          S             11  0
     D WRKSTAT         S             15A
     D WRun            S              1A
     D WSuspect        S              1A
     D WRecNotFound    S              1A
     D WRecDelMatur    S              1A
     D WOPEN           S              1
     D WFRART          S             11  7                                                    229414
     D WFWRAT          S             11  7                                                    229414
     D WEINR           S             11  7                                                    229414
     D WRKBRTT         S              2  0                                                    229414
     D WCCY            S              3                                                       229414
     D WRKCBS          S              1  0                                                    229414
     D WRKNCD          S              5  0                                                    229414
     D OurDetl         S              1                                                       229414
                                                                                              229414
     D ZINDAT          S              5  0                                                    229414
     D ZIBDAT          S              5  0                                                    229414
     D ZIFDAT          S              5  0                                                    229414
     D ZINRAT          S             13  9                                                    229414
     D ZIFRAT          S             13  9                                                    229414
     D ZIBRAT          S             13  9                                                    229414
 
      ** Parameters for ZFRPED
     D ZOUT25          S             25
 
     ** Parameter for CAS003
     D PSard           S              6
     D CAS003          S              1
 
      ** Parameters for ZFWDT                                                                 229414
     D PDayNo          S              5  0                                                    229414
     D PNRdys          S              2  0                                                    229414
     D PDyNbr          S              5  0                                                    229414
     D PCurCd          S              3                                                       229414
     D PLoc3           S              3                                                       229414
     D WSPDT           S              5  0                                                    229414
                                                                                              229414
      ** Parameters for DLZFWR                                                                229414
     D ZFWRTC          S              5                                                       229414
     D ZFWCCY          S              3                                                       229414
     D ZFWINC          S              1                                                       229414
     D ZFWSDT          S              5  0                                                    229414
     D ZFWNDT          S              5  0                                                    229414
     D ZFWFDT          S              5  0                                                    229414
     D ZFWOUT          S             11  7                                                    229414
     D WRKYLC          S              5                                                       229414
                                                                                              229414
      /EJECT
     I@HGSTD0
     I              FSEFUP                      SFSEFUP
     ISDHGSTD0
     I              FSEFUP                      SFSEFUP
     IASFHTRD0
     I              FSMOD                       SFSMOD
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *LOVAL        SETLL     SDHGSTL2
     C                   READ      SDHGSTL2
 
      ** Audit Report if end of file
 
     C                   IF        %EOF(SDHGSTL2)
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
      ** Do while not End of file
 
     C                   DOW       NOT %EOF(SDHGSTL2)
 
     C                   SELECT
 
     C                   WHEN      KBRCA <> FSBRCA
     C                   EVAL      WLVLDS = 'YYY'
 
     C                   WHEN      KPRTP <> FSPRTP
     C                   EVAL      WLVLDS = 'NYY'
 
     C                   WHEN      KHESN <> FSHESN
     C                   EVAL      WLVLDS = 'NNY'
 
     C                   ENDSL
 
      ** If change in Branch
 
     C                   IF        WL3 = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SRINL3
     C                   EVAL      *IN03 = *OFF
     C                   ENDIF
 
     C                   EXSR      SRPROCESS
 
     C                   READ      SDHGSTL2
 
      ** At end of Branch print trailer and close printer file if open
 
     C                   IF        %EOF(SDHGSTL2)
     C                             AND WOPEN = 'Y'
     C                   IF        *IN66 = *ON
     C                   WRITE     AS001006D1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     AS001006D4
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRAUDIT
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROCESS                                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPROCESS     BEGSR
 
      ** If Hedge Linkages exist for Branch's Hedge Strategies
 
     C                   IF        WIBranch = 'Y'
 
      ** If new Hedge Strategy
 
     C                   IF        WL1 = 'Y'
     C                   EVAL      *IN01 = *ON
     C                   EXSR      SRINL1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF
 
      ** If Hedge Linkages exist for Branch's Hedge Strategies
 
     C                   IF        WIHStrategy = 'Y'
 
      ** Count total number of Hedge Strategy records.
 
     C                   ADD       1             SCOUNT
 
      ** Process Hedge Linkage records for a given Hedge Strategy
      ** record
 
     C                   EXSR      SRLINK
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINL1 - New Hedge Strategy Level Break                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRVAL1                                                *
      *                                                               *
      *****************************************************************
 
     C     SRINL1        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      WIHStrategy = *BLANKS
 
     C                   EXSR      SRVAL1
 
      ** If Hedge Linkage records to print -first print new headings
 
     C                   IF        *IN77 = *ON
 
      ** At end of Branch print trailer and close printer file if open
 
     C                   IF        PBRCD <> FSBRCA
     C                             AND WOPEN = 'Y'
     C                   IF        *IN66 = *ON
     C                   WRITE     AS001006D1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     AS001006D4
     C                   ENDIF
 
     C                   EVAL      WIHStrategy = 'Y'
     C                   EVAL      PBRCD = FSBRCA
     C                   EVAL      PBRNM = A8BRNM
     C                   EVAL      PHESN = FSHESN
     C                   EVAL      PHELD = FSHELD
 
      ** Product Type
 
     C                   EVAL      *IN55 = *OFF
     C                   MOVEA     '000'         *IN(25)
     C                   Z-ADD     1             X
     C     FSPRTP        LOOKUP    TP(X)                                  55
 
     C                   SELECT
 
     C                   WHEN      X = 1
     C                   MOVEA     '100'         *IN(25)
 
     C                   WHEN      X = 2
     C                   MOVEA     '010'         *IN(25)
 
     C                   WHEN      X = 3
     C                   MOVEA     '001'         *IN(25)
 
     C                   ENDSL
 
     C                   EVAL      *IN66 = *ON
 
     C                   IF        WOPEN <> 'Y'
     C                   OPEN      AS001006P1
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      FSBRCA        PSenty
     C                   PARM                    SFILE1
     C                   PARM      SFNUM1        PSNum
     C                   PARM                    PSErr
     C                   EVAL      WOPEN = 'Y'
     C                   ENDIF
 
     C                   WRITE     AS001006D1
     C                   EVAL      *IN66 = *OFF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINL3 - New Branch Level Break                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRVAL1, ZSFILE, AOBRCHR0                              *
      *                                                               *
      *****************************************************************
 
     C     SRINL3        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      WIBranch = *BLANKS
 
     C                   EXSR      SRVAL1
 
     C                   IF        *IN77 = *ON
     C                   EVAL      WIBranch = 'Y'
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C**********         CALL      'AOBRCHR0'                                                 CAS010
     C                   CALL      'AOBRCHR1'                                                 CAS010
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM      FSBRCA        PDSNB
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL1 - Check if Hedge Linkages Exist                       *
      *                                                               *
      *  Called By: SRINL1, SRINL3                                    *
      *                                                               *
      *  Calls: SRVAL2                                                *
      *                                                               *
      *****************************************************************
 
     C     SRVAL1        BEGSR
 
      ** Save Hedge Strategy fields of a currently read record
 
     C                   EVAL      KBRCA = FSBRCA
     C                   EVAL      KPRTP = FSPRTP
     C                   EVAL      KHESN = FSHESN
 
      ** Initialise indicators
 
     C                   EVAL      *IN77 = *OFF
     C                   EVAL      *IN89 = *OFF
 
      ** Position and read Hedge Strategy file based on break
 
     C                   IF        *IN03 = *ON
     C     KBRCA         SETLL     SDHGSTL3
     C                   ENDIF
     C                   IF        *IN01 = *ON
     C     KYHESN        SETLL     SDHGSTL3
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C     KBRCA         READE     SDHGSTL3                               89
     C                   ENDIF
 
     C                   IF        *IN01 = *ON
     C     KYHESN        READE     SDHGSTL3                               89
     C                   ENDIF
 
     C                   DOW       *IN89 =*OFF
 
      ** Read Hedge Linkage records
 
     C                   EXSR      SRVAL2
 
      ** If live Hedge Linkages exist, then OK to process
 
     C                   IF        *IN77 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C     KBRCA         READE     SDHGSTL3                               89
     C                   ENDIF
 
     C                   IF        *IN01 = *ON
     C     KYHESN        READE     SDHGSTL3                               89
     C                   ENDIF
 
     C                   ENDDO
 
      ** Restore Hedge Strategy fields of a currently read record
 
     C                   EVAL      FSBRCA = KBRCA
     C                   EVAL      FSPRTP = KPRTP
     C                   EVAL      FSHESN = KHESN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL2 - Search for Live Hedge Linkage Records               *
      *                                                               *
      *  Called By: SRVAL1                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRVAL2        BEGSR
 
      ** Initialise indicators
 
     C                   EVAL      *IN87 = *OFF
 
      ** Read Hedge Strategy's Hedge Linkage records
 
     C     FSHESN        SETLL     ASHGLKL2
     C     FSHESN        READE     ASHGLKL2                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If live Hedge Linkage record with suspect item found
 
     C                   IF        FSRECI = 'D'
                                                                                              228024
      ** Check if hedge is for forecast transactions                                          228024
                                                                                              228024
     C                   EVAL      WFore = *BLANKS                                            228024
     C                   EVAL      WExre = *BLANKS                                            228024
     C                   EVAL      KDERITEM = 'H'                                             228024
                                                                                              228024
     C     KYTRAN        CHAIN     ASHTRNL0                           87                      228024
     C                   IF        *IN87 = *OFF AND                                           228024
     C                             FSMOD = 'FH'                                               228024
                                                                                              228024
     C*****FSDLNO        CHAIN     ASFHTRL1                           87               228024 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           87                      CLE148
     C                   IF        *IN87 = *OFF                                               228024
     C                   EVAL      WFore = 'Y'                                                228024
     C                   EVAL      WExre = FSERIN                                             228024
     C                   ENDIF                                                                228024
     C                   ENDIF                                                                228024
                                                                                              228024
     C                   EXSR      SRCHKTRAN
     C                   IF        WSuspect = 'Y'
     C                   EVAL      *IN77 = *ON
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C     FSHESN        READE     ASHGLKL2                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLINK - Hedge Linkage Processing                            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRTRN1                                                *
      *                                                               *
      *****************************************************************
 
     C     SRLINK        BEGSR
 
      ** For each Hedge Strategy -read all live Hedge Linkage records
 
     C                   EVAL      *IN89 = *OFF
     C     FSHESN        SETLL     ASHGLKL2
 
     C     FSHESN        READE     ASHGLKL2                               89
 
     C                   DOW       *IN89 = *OFF
 
     C                   IF        FSRECI = 'D'
 
      ** Initialise Hedge Transaction count
 
     C                   Z-ADD     *ZEROS        WTCOUNT
 
      ** Check if hedge is for forecast transactions
 
     C                   EVAL      WFore = *BLANKS
     C                   EVAL      WExre = *BLANKS
     C                   EVAL      KDERITEM = 'H'
 
     C     KYTRAN        CHAIN     ASHTRNL0                           87
     C                   IF        *IN87 = *OFF AND
     C                             FSMOD = 'FH'
 
     C*****FSDLNO        CHAIN     ASFHTRL1                           87                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           87                      CLE148
     C                   IF        *IN87 = *OFF
     C                   EVAL      WFore = 'Y'
     C                   EVAL      WExre = FSERIN
     C                   ENDIF
     C                   ENDIF
 
      ** Check if there are suspect items for each linkage
 
     C                   EXSR      SRCHKTRAN
 
      ** Process and print applicable Derivative Transaction records
 
     C                   IF        WSuspect = 'Y'
     C                   EVAL      KDERITEM = 'D'
     C                   EXSR      SRTRN1
 
      ** Process and print applicable Hedged Transaction records
 
     C                   EVAL      KDERITEM = 'H'
     C                   EXSR      SRTRN1
     C                   ENDIF
 
     C                   IF        WTCOUNT > *ZEROS
 
     C                   IF        *IN66 = *ON
     C                   WRITE     AS001006D1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   WRITE     AS001006D3
     C                   ADD       1             ECOUNT
     C                   ENDIF
 
     C                   ENDIF
 
     C     FSHESN        READE     ASHGLKL2                               89
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN1 - Hedge Transaction Processing                        *
      *                                                               *
      *  Called By: SRLINK                                            *
      *                                                               *
      *  Calls: SRTRN2                                                *
      *                                                               *
      *****************************************************************
 
     C     SRTRN1        BEGSR
 
     C                   EVAL      WFirstRec = *BLANK
     C                   EVAL      *IN87 = *OFF
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               87
 
      ** First Derivative Record
 
     C                   IF        *IN87 = *OFF AND KDERITEM = 'D'
     C                   EVAL      WFirstRec = 'Y'
     C                   ENDIF
 
     C                   DOW       *IN87 = *OFF
 
      ** Move file fields to printer file fields and print details
 
     C                   EXSR      SRTRN2
 
     C                   EVAL      WFirstRec = *BLANK
 
     C     KYTRAN        READE     ASHTRNL0                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN2 - Move data to workfields and print Transaction       *
      *           Report                                              *
      *                                                               *
      *  Called By: SRTRN1                                            *
      *                                                               *
      *  Calls: SRTRN3                                                *
      *                                                               *
      *****************************************************************
 
     C     SRTRN2        BEGSR
 
      ** Clear workfields
 
     C                   EVAL      WRKDLN = *BLANKS
     C                   EVAL      WRKBKC = *BLANKS
     C**********         EVAL      WRKCNU = *ZEROS                                            CSD027
     C                   EVAL      WRKCNU = *BLANKS                                           CSD027
     C                   EVAL      WRKVAL = *ZEROS
     C                   EVAL      WRKMAT = *ZEROS
     C                   EVAL      WRKCCY = *BLANKS
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
     C                   EVAL      WRKSTAT = *BLANK
 
     C                   EVAL      WRecNotFound = *BLANKS
     C                   EVAL      WRecDelMatur = *BLANKS
 
      ** Retrieve Transaction details from pertinent files
 
     C                   SELECT
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SRSDLNO
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SRSLENO
 
     C                   WHEN      FSMOD = 'FH'
     C                   EXSR      SRSFHNO
 
     C                   WHEN      FSMOD = 'FF' AND CAS003 = 'Y'
     C                   EXSR      SRSFFNO
 
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SRSSENO
                                                                                              229552
     C                   IF        WSuspect ='Y'                                              229552
     C                             AND FSEFFD = BJRDNB                                        229552
     C     FSHEDI        CHAIN     ASHGLKH1                                                   229552
     C                   EVAL      H1RECI = 'T'                                               229552
     C                   EVAL      H1CHTP = 'T'                                               229552
     C                   EVAL      H1LCD  = BJRDNB                                            229552
     C                   UPDATE    ASHGLKH1                                                   229552
     C                   ENDIF                                                                229552
                                                                                              229552
     C                   ENDSL
 
      ** Load printer file fields
 
     C                   EXSR      SRTRN3
 
      ** Print Hedge Transaction details
 
     C                   IF        *IN66 = *ON
     C                   WRITE     AS001006D1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   WRITE     AS001006D2
 
      ** Increment count of processed records
 
     C                   ADD       1             WTCOUNT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKTRAN - Check Transactions if there are suspect items    *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRCHKTRAN     BEGSR
 
     C                   EVAL      WSuspect = *BLANK
 
      ** Derivatives
 
     C                   EVAL      KDERITEM = 'D'
     C                   EVAL      *IN87 = *OFF
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               87
 
     C                   DOW       *IN87 = *OFF AND WSuspect = *BLANK
 
      ** Retrieve Transaction details
 
     C                   SELECT
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SRDLNO
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SRLENO
 
     C                   WHEN      FSMOD = 'FH'
     C                   EXSR      SRFHNO
 
     C                   WHEN      FSMOD = 'FF' AND CAS003 = 'Y'
     C                   EXSR      SRFFNO
 
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SRSENO
     C                   ENDSL
 
     C     KYTRAN        READE     ASHTRNL0                               87
     C                   ENDDO
 
      ** Items
 
     C                   EVAL      KDERITEM = 'H'
     C                   EVAL      *IN87 = *OFF
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               87
 
     C                   DOW       *IN87 = *OFF AND WSuspect = *BLANK
 
      ** Retrieve Transaction details
 
     C                   SELECT
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SRDLNO
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SRLENO
 
     C                   WHEN      FSMOD = 'FH'
     C                   EXSR      SRFHNO
 
     C                   WHEN      FSMOD = 'FF' AND CAS003 = 'Y'
     C                   EXSR      SRFFNO
 
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SRSENO
     C                   ENDSL
 
     C     KYTRAN        READE     ASHTRNL0                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDLNO - Deal Processing                                     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDLNO        BEGSR
 
     C*****FSDLNO        CHAIN     DEALSALL                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALSALL                           55                      CLE148
 
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
 
     C                   IF        *IN55 = *OFF
 
     C                   SELECT
 
      ** Foreign Exchange Deals
 
     C                   WHEN      RCDFMT = 'DEALSDBF' OR
     C                             RCDFMT = 'DLBHISD0'
 
     C                   IF        WFore = 'Y'
     C                   IF        WExre = 'R'
     C                   EVAL      WRKPR$ = SLAM
     C                   ELSE
     C                   EVAL      WRKPR$ = PUAM
     C                   ENDIF
     C                   ELSE
 
     C                   EVAL      KLNKDN = LNKDN
     C                   IF        FSDHIN = 'D'
     C     KLNKDN        CHAIN     DLDLBBL1
 
     C                   IF        NOT %FOUND(DLDLBBL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLDLBBL1'
     C                   EVAL      DBASE = 3
     C                   MOVEL     KLNKDN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      KLNKDN = BLNKDN
     C                   ENDIF
 
     C     KLNKDN        CHAIN     DLDLHCL1
 
     C                   IF        NOT %FOUND(DLDLHCL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLDLHCL1'
     C                   EVAL      DBASE = 4
     C                   MOVEL     KLNKDN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        SLCY = CCCY
     C                   EVAL      WRKPR$ = SLAM
     C                   ELSE
     C                   EVAL      WRKPR$ = PUAM
     C                   ENDIF
     C                   ENDIF
 
      ** Money Market Deals
 
     C                   WHEN      RCDFMT = 'DEALSDCF' OR
     C                             RCDFMT = 'DLCHISD0'
     C                   EVAL      WRKPR$ =PCPL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** Negotiable Assets
 
     C                   WHEN      RCDFMT = 'DEALSDDF' OR
     C                             RCDFMT = 'DLDHISD0'
     C                   EVAL      WRKPR$ =FVAL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** Negotiable Assets
 
     C                   WHEN      RCDFMT = 'DEALSDEF' OR
     C                             RCDFMT = 'DLEHISD0'
     C                   EVAL      WRKPR$ = FVAL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** FRA/IRS
 
     C                   WHEN      RCDFMT = 'DEALSDGF' OR
     C                             RCDFMT = 'DLGHISD0'
     C                   EVAL      WRKPR$ = UPAMT
 
      ** Fair Value Interest Rate processing
 
     C                   SELECT
 
     C                   WHEN      FSPRTP = 'FV'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   EVAL      OurDetl = 'Y'                                              229414
     C                   ELSE
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   EVAL      OurDetl = 'N'                                              229414
     C                   ENDIF
 
      ** Cash Flow Interest Rate processing
 
     C                   WHEN      FSPRTP = 'CF'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   EVAL      OurDetl = 'N'                                              229414
     C                   ELSE
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   EVAL      OurDetl = 'Y'                                              229414
     C                   ENDIF
 
     C                   ENDSL
 
      ** Get Deal details                                                                     229414
     C                   EXSR      SRGETD                                                     229414
                                                                                              229414
      ** Get Market Rate for FRA and Forward Rate for IRS if rate not set                     229414
     C                   IF        WRKINT = *ZEROS  AND WRKBRTT <> *ZERO                      229414
     C                   IF        DTYP = 'FR'                                                229414
     C                   EXSR      SRFRAT                                                     229414
     C     10000000      MULT(H)   WFRART        WRKINT                                       229414
     C                   ELSE                                                                 229414
     C                   EXSR      SRFWRT                                                     229414
     C     10000000      MULT(H)   WFWRAT        WRKINT                                       229414
     C                   ENDIF                                                                229414
     C                   ENDIF                                                                229414
     C                   ENDSL
 
     C                   ENDIF
 
     C                   SELECT
 
      ** Deal not found
 
     C                   WHEN      *IN55 = *ON
     C                   EVAL      WSuspect = 'Y'
 
      ** Deal already matured, deleted, no principal or zero interest rate
 
     C                   WHEN      *IN55 = *OFF
     C                   IF        RECI = 'M' OR RECI = '*' OR
     C                             WRKPR$ = 0 OR WRKINT < 2
     C                   EVAL      WSuspect = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  229414
      *****************************************************************                       229414
      *                                                               *                       229414
      *  SRFWRT - Get Yeild Rate for IRS                              *                       229414
      *                                                               *                       229414
      *  Called By: SRSDLNO, SRDLNO                                   *                       229414
      *                                                               *                       229414
      *  Calls: AOCURRR0, ZFWDT, DLZFWR                               *                       229414
      *                                                               *                       229414
      *****************************************************************                       229414
                                                                                              229414
     C     SRFWRT        BEGSR                                                                229414
                                                                                              229414
     C                   CALL      'AOCURRR0'                                                 229414
     C                   PARM      *BLANKS       W0RTN                                        229414
     C                   PARM      '*KEY'        W0OPTN                                       229414
     C                   PARM      WCCY          PCCY                                         229414
     C     SDCURR        PARM      SDCURR        DSSDY                                        229414
                                                                                              229414
      ** Database Error                                                                       229414
     C                   IF        W0RTN    <> *BLANKS                                        229414
     C     *LOCK         IN        LDA                                                        229414
     C                   EVAL      DBFILE =  'SDCURRPD'                                       229414
     C                   EVAL      DBASE =  005                                               229414
     C                   EVAL      DBKEY =  WCCY                                              229414
     C                   OUT       LDA                                                        229414
     C                   EXSR      *PSSR                                                      229414
     C                   OUT       LDA                                                        229414
     C                   ENDIF                                                                229414
                                                                                              229414
     C                   CALLB     'ZFWDT'                                                    229414
     C                   PARM      BJRDNB        PDayNo                                       229414
     C                   PARM      A6SPDY        PNRdys                                       229414
     C                   PARM                    PDyNbr                                       229414
     C                   PARM      WCCY          PCurCd                                       229414
     C                   PARM      *BLANKS       PLoc3                                        229414
                                                                                              229414
     C                   MOVE      WRKCBS        ZFWINC                                       229414
     C                   Z-ADD     PDyNbr        WSPDT                                        229414
     C                   Z-ADD     VDAT          ZFWNDT                                       229414
     C                   Z-ADD     WRKNCD        ZFWFDT                                       229414
                                                                                              229414
     C                   IF        RSCY <> *BLANKS AND PSCY <> *BLANKS                        229414
     C                   MOVEL     RSCY          WCCY                                         229414
     C                   ENDIF                                                                229414
                                                                                              229414
     C                   CALL      'DLZFWR'                                                   229414
     C                   PARM      *BLANK        ZFWRTC                                       229414
     C                   PARM      WCCY          ZFWCCY                                       229414
     C                   PARM                    ZFWINC                                       229414
     C                   PARM      WSPDT         ZFWSDT                                       229414
     C                   PARM                    ZFWNDT                                       229414
     C                   PARM                    ZFWFDT                                       229414
     C                   PARM                    ZFWOUT                                       229414
     C                   PARM                    WRKYLC                                       229414
                                                                                              229414
     C                   Z-ADD     ZFWOUT        WFWRAT                                       229414
     C                   IF        ZFWRTC = '*ERR*'                                           229414
     C                   EXSR      *PSSR                                                      229414
     C                   ENDIF                                                                229414
                                                                                              229414
     C                   ENDSR                                                                229414
      *****************************************************************                       229414
      /EJECT                                                                                  229414
      *****************************************************************                       229414
      *                                                               *                       229414
      *  SRFRAT - Get Market Rate for FRA                             *                       229414
      *                                                               *                       229414
      *  Called By: SRSDLNO, SRDLNO                                   *                       229414
      *                                                               *                       229414
      *  Calls: ZAINTPL                                               *                       229414
      *                                                               *                       229414
      *****************************************************************                       229414
                                                                                              229414
     C     SRFRAT        BEGSR                                                                229414
                                                                                              229414
      ** Initialise Fields.                                                                   229414
     C                   Z-ADD     0             WFRART                                       229414
     C                   SETOFF                                       717273                  229414
                                                                                              229414
      ** First set Lower Limits using Currency/Base Rate/Value Date.                          229414
     C     KFRAR1        SETLL     DLFRARL4                           71                      229414
                                                                                              229414
      ** If not EOF, Read Equal the next record of the Currency/Base                          229414
      ** Rate.                                                                                229414
     C                   IF        *IN71 = '0'                                                229414
     C     KFRAR2        READE     DLFRARL4                               72                  229414
                                                                                              229414
      ** If a record was read and is the correct date, set up the FRA                         229414
      ** Rate and exit.                                                                       229414
     C                   IF        *IN72 = '0'  AND FRVMDN = VDAT                             229414
     C                   Z-ADD     FRRATE        WFRART                                       229414
     C                   GOTO      RATEND                                                     229414
     C                   ENDIF                                                                229414
      *                                                                                       229414
     C                   ENDIF                                                                229414
                                                                                              229414
      ** If a record has not yet been retrieved, reposition the file                          229414
      ** and read the last record of the Currency/Base Rate.                                  229414
     C                   IF        *IN71 = '1' OR *IN72 = '1'                                 229414
     C     KFRAR1        SETGT     DLFRARL4                                                   229414
                                                                                              229414
      ** If Record found then set up the FRA Rate, else the Currency/                         229414
      ** Base Rate is not on File (*IN73 returned).                                           229414
     C     KFRAR2        READPE    DLFRARL4                               73                  229414
     C                   IF        *IN73 = '0'                                                229414
     C                   Z-ADD     FRRATE        WFRART                                       229414
     C                   ENDIF                                                                229414
     C                   GOTO      RATEND                                                     229414
                                                                                              229414
     C                   ENDIF                                                                229414
                                                                                              229414
      ** If this point has been reached, a record has been found with                         229414
      ** a date greater than the one we want and it will probably be                          229414
      ** necessary to use interpolation, so set up Far Date and Far                           229414
      ** Rate fields (for PGM/ZAINTPL).                                                       229414
     C                   Z-ADD     FRVMDN        ZIFDAT                                       229414
     C                   Z-ADD     FRRATE        ZIFRAT                                       229414
                                                                                              229414
      ** Read the Previous record to get the Near Rate. If not found,                         229414
      ** (*IN71), then the record already retrieved is the first for                          229414
      ** this Currency/Base Rate and that FRA Rate should be used.                            229414
     C     KFRAR2        READPE    DLFRARL4                               71                  229414
                                                                                              229414
     C                   IF        *IN71 = '1'                                                229414
     C                   Z-ADD     ZIFRAT        WFRART                                       229414
     C                   ELSE                                                                 229414
                                                                                              229414
      ** Else set up Near Date, Near Rate and Broken Date and then                            229414
      ** interpolate the Rate.                                                                229414
     C                   Z-ADD     FRVMDN        ZINDAT                                       229414
     C                   Z-ADD     FRRATE        ZINRAT                                       229414
     C                   Z-ADD     VDAT          ZIBDAT                                       229414
     C                   Z-ADD     0             ZIBRAT                                       229414
                                                                                              229414
     C                   CALLB     'ZAINTPL'                                                  229414
     C                   PARM                    ZINDAT                                       229414
     C                   PARM                    ZIBDAT                                       229414
     C                   PARM                    ZIFDAT                                       229414
     C                   PARM                    ZINRAT                                       229414
     C                   PARM                    ZIFRAT                                       229414
     C                   PARM                    ZIBRAT                                       229414
     C                   Z-ADD     ZIBRAT        WFRART                                       229414
     C                   END                                                                  229414
                                                                                              229414
     C     RATEND        TAG                                                                  229414
                                                                                              229414
     C                   ENDSR                                                                229414
      *****************************************************************                       229414
      /EJECT                                                                                  229414
      *****************************************************************                       229414
      *                                                               *                       229414
      *  SRGETD - Get details of deals                                *                       229414
      *                                                               *                       229414
      *  Called By: SRSDLNO, SRDLNO                                   *                       229414
      *                                                               *                       229414
      *  Calls: None                                                  *                       229414
      *                                                               *                       229414
      *****************************************************************                       229414
                                                                                              229414
     C     SRGETD        BEGSR                                                                229414
                                                                                              229414
     C                   IF        OurDetl = 'Y'                                              229414
     C                   Z-ADD     UBRTT         WRKBRTT                                      229414
     C                   MOVEL     UCUCY         WCCY                                         229414
     C                   Z-ADD     UICBS         WRKCBS                                       229414
     C                   IF        UNICD <> *ZERO                                             229414
     C                   EVAL      WRKNCD  = UNICD                                            229414
     C                   ELSE                                                                 229414
     C                   EVAL      WRKNCD  = MDAT                                             229414
     C                   ENDIF                                                                229414
     C                   MOVEL     FSOFYC        WRKYLC                                       229414
     C                   ELSE                                                                 229414
     C                   Z-ADD     TBRTT         WRKBRTT                                      229414
     C                   MOVEL     TCUCY         WCCY                                         229414
     C                   Z-ADD     TICBS         WRKCBS                                       229414
     C                   IF        TNICD <> *ZERO                                             229414
     C                   EVAL      WRKNCD  = TNICD                                            229414
     C                   ELSE                                                                 229414
     C                   EVAL      WRKNCD  = MDAT                                             229414
     C                   ENDIF                                                                229414
     C                   MOVEL     FSTFYC        WRKYLC                                       229414
     C                   ENDIF                                                                229414
                                                                                              229414
     C                   ENDSR                                                                229414
      *****************************************************************                       229414
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLENO - Loan Processing                                     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLENO        BEGSR
 
     C                   EVAL      WRKINT = *ZEROS
 
     C     FSDLNO        CHAIN     CLOANCLF                           55
 
      **  Calculate the net treasury rate
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        MARG <> *ZERO
     C                   SUB       MARG          INTR
     C                   ENDIF
 
     C                   EVAL      WRKPR$ = CPAM
     C     10000000      MULT(H)   INTR          WRKINT
     C                   ENDIF
 
     C                   SELECT
 
      ** Loan not found
 
     C                   WHEN      *IN55 = *ON
     C                   EVAL      WSuspect = 'Y'
 
      ** Loan already matured, deleted, no principal or zero interest rate
 
     C                   WHEN      *IN55 = *OFF
     C                   IF        RECI = 'M' OR RECI = '*' OR
     C                             WRKPR$ = 0 OR WRKINT < 2
     C                   EVAL      WSuspect = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFHNO - Forecast Transaction Processing                     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRFHNO        BEGSR
 
     C                   MOVEL     FSDLNO        WRKDLN
 
     C*****FSDLNO        CHAIN     ASFHTRL1                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           55                      CLE148
 
     C                   SELECT
 
      ** Forecast not found
 
     C                   WHEN      *IN55 = *ON
     C                   EVAL      WSuspect = 'Y'
 
      ** Forecast already matured or deleted
 
     C                   WHEN      *IN55 = *OFF
     C                   IF        RECI = 'M' OR RECI = '*'
     C                   EVAL      WSuspect = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFFNO - Futures Position Processing                         *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRFFNO        BEGSR
 
      ** Futures Position Mode
 
     C                   EVAL      WRKINT = *ZEROS
 
     C**********         IF        FSDLNO = *ZEROS AND FSFPSE <> *BLANKS OR                   CLE148
     C                   IF        FSDLNO = *BLANKS AND FSFPSE <> *BLANKS OR                  CLE148
     C                             INSFLD <> *BLANKS
 
     C                   Z-ADD     1             M                 3 0
     C                   MOVE      *OFF          *IN66
     C     INSMM@        LOOKUP    MON(M)                                 66
 
     C     *IN66         IFEQ      *ON
     C                   Z-ADD     NUM(M)        INSMM
     C                   MOVE      INSYY@        INSYY
 
     C     KEYPST        CHAIN     POSTNK5                            55
 
     C                   IF        *IN55 = *OFF
     C                   Z-ADD     CUTV          WRKPR$
     C     100000000     MULT(H)   STRP          WRKINT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Futures Transaction Mode
 
     C**********         IF        FSDLNO <> *ZEROS                                           CLE148
     C                   IF        FSDLNO <> *BLANKS                                          CLE148
 
     C*****FSDLNO        CHAIN     TRANS2                             55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANS2                             55                      CLE148
     C                   IF        *IN55 = *OFF
     C                   Z-ADD     NUCO          WRKPR$
     C     100000000     MULT(H)   COPR          WRKINT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SELECT
 
      ** Transaction not found
 
     C                   WHEN      *IN55 = *ON
     C                   EVAL      WSuspect = 'Y'
 
      ** Transaction already matured or deleted
 
     C                   WHEN      *IN55 = *OFF
     C                   IF        RECI = 'M' OR RECI = '*' OR
     C                             WRKPR$ = 0 OR WRKINT < 2
     C                   EVAL      WSuspect = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSENO - Security Processing                                 *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSENO        BEGSR
 
     C     FSFPSE        CHAIN     SECTY                              55
 
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
 
     C                   IF        *IN55 = *OFF
 
     C*****KEYBKP        CHAIN     BKPOSL2                            55                      229552
     C     KEYBKP        SETGT     BKPOSL2                                                    229552
     C     KEYBKP        READPE    BKPOSL2                                55                  229552
 
     C                   IF        *IN55 = *OFF
     C                   Z-ADD     NPSN          WRKPR$
     C     100000000     MULT(H)   APPB          WRKINT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SELECT
 
      ** Transaction not found
 
     C                   WHEN      *IN55 = *ON
     C                   EVAL      WSuspect = 'Y'
 
      ** Transaction already matured or deleted
 
     C                   WHEN      *IN55 = *OFF
     C                   IF        RECI = 'M' OR RECI = '*' OR
     C                             WRKPR$ = 0 OR WRKINT < 2
     C                   EVAL      WSuspect = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDLNO - Set Deal Details for Reporting                     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSDLNO       BEGSR
 
     C                   MOVEL     FSDLNO        WRKDLN
 
     C*****FSDLNO        CHAIN     DEALSALL                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALSALL                           55                      CLE148
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   IF        RECI = 'M'
     C                   EVAL      WRecDelMatur = 'M'
     C                   ELSE
     C                   EVAL      WRecDelMatur = 'D'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WRKBKC = BOKC
     C**********         Z-ADD     CNUM          WRKCNU                                       CSD027
     C                   EVAL      WRKCNU=CNUM                                                CSD027
     C                   Z-ADD     VDAT          WRKVAL
     C                   Z-ADD     MDAT          WRKMAT
     C                   EVAL      WRKBOV = *ZEROS
 
     C                   SELECT
 
      ** Foreign Exchange Deals
 
     C                   WHEN      RCDFMT = 'DEALSDBF' OR
     C                             RCDFMT = 'DLBHISD0'
     C                   EVAL      WRKMAT = *ZEROS
     C                   EVAL      WRKCCY = *BLANKS
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
 
     C                   IF        WFore = 'Y'
     C                   IF        WExre = 'R'
     C                   EVAL      WRKCCY = SLCY
     C                   EVAL      WRKPR$ = SLAM
     C                   ELSE
     C                   EVAL      WRKCCY = PUCY
     C                   EVAL      WRKPR$ = PUAM
     C                   ENDIF
     C                   ELSE
 
     C                   EVAL      KLNKDN = LNKDN
     C                   IF        FSDHIN = 'D'
     C     KLNKDN        CHAIN     DLDLBBL1
     C                   EVAL      KLNKDN = BLNKDN
     C                   ENDIF
 
     C     KLNKDN        CHAIN     DLDLHCL1
 
     C                   IF        SLCY = CCCY
     C                   EVAL      WRKCCY = SLCY
     C                   EVAL      WRKPR$ = SLAM
     C                   ELSE
     C                   EVAL      WRKCCY = PUCY
     C                   EVAL      WRKPR$ = PUAM
     C                   ENDIF
     C                   ENDIF
 
      ** Money Market Deals
 
     C                   WHEN      RCDFMT = 'DEALSDCF' OR
     C                             RCDFMT = 'DLCHISD0'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = PCPL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** Negotiable Assets
 
     C                   WHEN      RCDFMT = 'DEALSDDF' OR
     C                             RCDFMT = 'DLDHISD0'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = FVAL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** Negotiable Assets
 
     C                   WHEN      RCDFMT = 'DEALSDEF' OR
     C                             RCDFMT = 'DLEHISD0'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = FVAL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** FRA/IRS
 
     C                   WHEN      RCDFMT = 'DEALSDGF' OR
     C                             RCDFMT = 'DLGHISD0'
     C                   EVAL      WRKBOV = BOVD
     C                   EVAL      WRKCCY = UCUCY
     C                   EVAL      WRKPR$ = UPAMT
 
      ** Fair Value Interest Rate processing
 
     C                   SELECT
 
     C                   WHEN      FSPRTP = 'FV'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   EVAL      OurDetl = 'Y'                                              229414
     C                   ELSE
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   EVAL      OurDetl = 'N'                                              229414
     C                   ENDIF
 
      ** Cash Flow Interest Rate processing
 
     C                   WHEN      FSPRTP = 'CF'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   EVAL      OurDetl = 'N'                                              229414
     C                   ELSE
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   EVAL      OurDetl = 'Y'                                              229414
     C                   ENDIF
 
     C                   ENDSL
 
      ** Get Deal details                                                                     229414
     C                   EXSR      SRGETD                                                     229414
                                                                                              229414
      ** Get Market Rate for FRA and Forward Rate for IRS if rate not set                     229414
     C                   IF        WRKINT = *ZEROS AND WRKBRTT <> *ZEROS                      229414
     C                   IF        DTYP = 'FR'                                                229414
     C                   EXSR      SRFRAT                                                     229414
     C     10000000      MULT(H)   WFRART        WRKINT                                       229414
     C                   ELSE                                                                 229414
     C                   EXSR      SRFWRT                                                     229414
     C     10000000      MULT(H)   WFWRAT        WRKINT                                       229414
     C                   ENDIF                                                                229414
     C                   ENDIF                                                                229414
     C                   ENDSL
 
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WRecNotFound = 'Y'
     C                   EVAL      WRKSTAT = 'NOT FOUND'
     C                   WHEN      WRecDelMatur = 'M'
     C                   EVAL      WRKSTAT = 'MATURED'
     C                   WHEN      WRecDelMatur = 'D'
     C                   EVAL      WRKSTAT = 'DELETED'
     C                   WHEN      WRKPR$ = 0
     C                   EVAL      WRKSTAT = 'ZERO PRINCIPAL'
     C                   WHEN      WRKINT < 2
     C                   EVAL      WRKSTAT = 'ZERO INTEREST '
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSLENO - Set Loan Details for Reporting                     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSLENO       BEGSR
 
     C                   MOVEL     FSDLNO        WRKDLN
 
     C     FSDLNO        CHAIN     CLOANCLF                           55
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   IF        RECI = 'M'
     C                   EVAL      WRecDelMatur = 'M'
     C                   ELSE
     C                   EVAL      WRecDelMatur = 'D'
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     BOKC          WRKBKC
     C**********         Z-ADD     CNUM          WRKCNU                                       CSD027
     C                   EVAL      WRKCNU=CNUM                                                CSD027
     C                   Z-ADD     VDAT          WRKVAL
     C                   Z-ADD     MDAT          WRKMAT
     C                   MOVE      CCY           WRKCCY
     C                   Z-ADD     CPAM          WRKPR$
 
      **  CALCULATE THE NET TREASURY RATE
 
     C                   IF        MARG <> *ZERO
     C                   SUB       MARG          INTR
     C                   ENDIF
 
     C     10000000      MULT(H)   INTR          WRKINT
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WRecNotFound = 'Y'
     C                   EVAL      WRKSTAT = 'NOT FOUND'
     C                   WHEN      WRecDelMatur = 'M'
     C                   EVAL      WRKSTAT = 'MATURED'
     C                   WHEN      WRecDelMatur = 'D'
     C                   EVAL      WRKSTAT = 'DELETED'
     C                   WHEN      WRKPR$ = 0
     C                   EVAL      WRKSTAT = 'ZERO PRINCIPAL'
     C                   WHEN      WRKINT < 2
     C                   EVAL      WRKSTAT = 'ZERO INTEREST '
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSFHNO - Set Forecast Transaction Details for Reporting     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSFHNO       BEGSR
 
     C                   MOVEL     FSDLNO        WRKDLN
 
     C*****FSDLNO        CHAIN     ASFHTRL1                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           55                      CLE148
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   IF        RECI = 'M'
     C                   EVAL      WRecDelMatur = 'M'
     C                   ELSE
     C                   EVAL      WRecDelMatur = 'D'
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     FSMDAT        WRKMAT
     C                   MOVE      FSCCY         WRKCCY
     C                   Z-ADD     FSAMNT        WRKPR$
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WRecNotFound = 'Y'
     C                   EVAL      WRKSTAT = 'NOT FOUND'
     C                   WHEN      WRecDelMatur = 'M'
     C                   EVAL      WRKSTAT = 'MATURED'
     C                   WHEN      WRecDelMatur = 'D'
     C                   EVAL      WRKSTAT = 'DELETED'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSFFNO - Set Futures & Option Details for Reporting         *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSFFNO       BEGSR
 
     C**********         IF        FSDLNO = *ZEROS                                            CLE148
     C                   IF        FSDLNO = *BLANKS                                           CLE148
     C                   MOVEL     FSFPSE        WRKDLN
     C                   ELSE
     C                   MOVEL     FSDLNO        WRKDLN
     C                   ENDIF
 
      ** Futures Position Mode
 
     C**********         IF        FSDLNO = *ZEROS AND FSFPSE <> *BLANKS OR                   CLE148
     C                   IF        FSDLNO = *BLANKS AND FSFPSE <> *BLANKS OR                  CLE148
     C                             INSFLD <> *BLANKS
 
     C                   Z-ADD     1             M                 3 0
     C                   MOVE      *OFF          *IN66
     C     INSMM@        LOOKUP    MON(M)                                 66
 
     C     *IN66         IFEQ      *ON
     C                   Z-ADD     NUM(M)        INSMM
     C                   MOVE      INSYY@        INSYY
 
     C     KEYPST        CHAIN     POSTNK5                            55
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   IF        RECI = 'M'
     C                   EVAL      WRecDelMatur = 'M'
     C                   ELSE
     C                   EVAL      WRecDelMatur = 'D'
     C                   ENDIF
     C                   ENDIF
 
     C**********         MOVEL     FSBKC         WRKBKC                                       229563
     C                   MOVEL     FSBKCD        WRKBKC                                       229563
     C                   MOVE      ISCY          WRKCCY
     C                   Z-ADD     CUTV          WRKPR$
     C     100000000     MULT(H)   STRP          WRKINT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Futures Transaction Mode
 
     C                   ELSE
 
     C*****FSDLNO        CHAIN     TRANS2                             55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANS2                             55                      CLE148
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   IF        RECI = 'M'
     C                   EVAL      WRecDelMatur = 'M'
     C                   ELSE
     C                   EVAL      WRecDelMatur = 'D'
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     BOKC          WRKBKC
     C**********         Z-ADD     CUSC          WRKCNU                                       CSD027
     C                   EVAL      WRKCNU=CUSC                                                CSD027
     C                   Z-ADD     VALD          WRKVAL
     C                   MOVE      ISCY          WRKCCY
     C                   Z-ADD     NUCO          WRKPR$
     C     100000000     MULT(H)   COPR          WRKINT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WRecNotFound = 'Y' OR WRecDelMatur <> *BLANK
     C                             OR WRKPR$ = 0 OR WRKINT < 2
     C                   EVAL      WSuspect = 'Y'
     C                   SELECT
     C                   WHEN      WRecNotFound = 'Y'
     C                   EVAL      WRKSTAT = 'NOT FOUND'
     C                   WHEN      WRecDelMatur = 'M'
     C                   EVAL      WRKSTAT = 'MATURED'
     C                   WHEN      WRecDelMatur = 'D'
     C                   EVAL      WRKSTAT = 'DELETED'
     C                   WHEN      WRKPR$ = 0
     C                   EVAL      WRKSTAT = 'ZERO PRINCIPAL'
     C                   WHEN      WRKINT < 2
     C                   EVAL      WRKSTAT = 'ZERO INTEREST '
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSSENO - Set Security Details for Reporting                 *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSSENO       BEGSR
 
     C                   MOVEL     FSFPSE        WRKDLN
 
     C     FSFPSE        CHAIN     SECTY                              55
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C*****KEYBKP        CHAIN     BKPOSL2                            55                      229552
     C     KEYBKP        SETGT     BKPOSL2                                                    229552
     C     KEYBKP        READPE    BKPOSL2                                55                  229552
 
     C                   IF        *IN55 = *ON
     C                   EVAL      WRecNotFound = 'Y'
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   IF        RECI = 'M'
     C                   EVAL      WRecDelMatur = 'M'
     C                   ELSE
     C                   EVAL      WRecDelMatur = 'D'
     C                   ENDIF
     C                   ENDIF
 
     C**********         MOVEL     FSBKC         WRKBKC                                       229563
     C                   MOVEL     FSBKCD        WRKBKC                                       229563
     C                   Z-ADD     MATY          WRKMAT
     C                   MOVE      NMCY          WRKCCY
     C                   Z-ADD     NPSN          WRKPR$
     C     100000000     MULT(H)   APPB          WRKINT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WRecNotFound = 'Y' OR WRecDelMatur <> *BLANK
     C                             OR WRKPR$ = 0 OR WRKINT < 2
     C                   EVAL      WSuspect = 'Y'
     C                   SELECT
     C                   WHEN      WRecNotFound = 'Y'
     C                   EVAL      WRKSTAT = 'NOT FOUND'
     C                   WHEN      WRecDelMatur = 'M'
     C                   EVAL      WRKSTAT = 'MATURED'
     C                   WHEN      WRecDelMatur = 'D'
     C                   EVAL      WRKSTAT = 'DELETED'
     C                   WHEN      WRKPR$ = 0
     C                   EVAL      WRKSTAT = 'ZERO PRINCIPAL'
     C                   WHEN      WRKINT < 2
     C                   EVAL      WRKSTAT = 'ZERO INTEREST '
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN3 - Load Workfields                                     *
      *                                                               *
      *  Called By: SRTRN2                                            *
      *                                                               *
      *  Calls: ZDATE2, AOCURRR0, ZFRPED                              *
      *                                                               *
      *****************************************************************
 
     C     SRTRN3        BEGSR
 
      ** Hedge Linkage ID
 
     C                   IF        WFirstRec = 'Y'
     C                   MOVE      FSHEDI        PHEDI
     C                   ELSE
     C                   MOVE      *BLANK        PHEDI
     C                   ENDIF
 
      ** Module
 
     C                   MOVEL     FSMOD         PMOD
 
      ** Deal/Loan/FPO/Sec
 
     C                   MOVEL     WRKDLN        PDLNO
 
      ** Book Code
 
     C                   MOVEL     WRKBKC        PBKC
 
      ** Customer Number
 
     C**********         IF        WRKCNU <> *ZEROS                                           CSD027
     C                   IF        WRKCNU <> *BLANKS                                          CSD027
     C                   MOVE      WRKCNU        PCNUM
     C                   ELSE
     C                   MOVE      *BLANKS       PCNUM
     C                   ENDIF
 
      ** Value Date
 
     C                   IF        WRKVAL <> *ZEROS
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    WRKVAL
     C                   PARM      BJDFIN        WQ0002            1
     C                   PARM      *ZEROS        @3VDAT            6 0
     C                   PARM      *BLANKS       PVALD
 
     C                   ELSE
     C                   MOVE      *BLANKS       PVALD
     C                   ENDIF
 
      ** Maturity Date
 
     C                   IF        WRKMAT <> *ZEROS
 
      ** If deal has been bought out, use buy out date as maturity date
 
     C                   IF        WRKBOV <> 0
     C                   EVAL      WRKMAT = WRKBOV
     C                   ENDIF
 
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    WRKMAT
     C                   PARM      BJDFIN        WQ0002            1
     C                   PARM      *ZEROS        @MATD             6 0
     C                   PARM      *BLANKS       PMATD
 
     C                   ELSE
     C                   MOVE      *BLANKS       PMATD
     C                   ENDIF
 
      ** Currency
 
     C                   IF        WRKCCY <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM      '*KEY   '     W0OPTN            7
     C                   PARM      WRKCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDIF
 
      ** Principal
 
     C                   Z-ADD     WRKPR$        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *Blanks       ZOUT22
     C                   PARM      *Blanks       ZOUT25
 
      ** Retain negative sign '-' in position 21.
 
     C                   MOVEL     ZOUT22        WRK21            21
     C                   MOVE      WRK21         PPRIN
 
      ** Interest Rate
 
     C                   Z-ADD     WRKINT        ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   MOVE      'L'           ZECODE
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *Blanks       ZOUT22
     C                   PARM      *Blanks       ZOUT25
 
      ** Strip out negative sign
 
     C                   MOVEL     ZOUT22        WRK20            20
     C                   MOVE      WRK20         PINTR
 
     C                   IF        WRKSTAT <> *BLANK
     C                   MOVEL     WRKSTAT       PSTAT
     C                   ELSE
     C                   MOVEL     *BLANK        PSTAT
     C                   ENDIF
 
      ** If no record found, blanked out details
 
     C                   IF        WRecNotFound = 'Y'
     C                   EVAL      PBKC   = *ALL' '
     C                   EVAL      PCNUM  = *ALL' '
     C                   EVAL      PVALD  = *ALL' '
     C                   EVAL      PMATD  = *ALL' '
     C                   EVAL      PCCY   = *ALL' '
     C                   EVAL      PPRIN  = *ALL' '
     C                   EVAL      PINTR  = *ALL' '
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT- Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
     C                   WRITE     HEADAU
 
     C                   WRITE     TOTAUD
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records written, output "No Details" message.
 
     C     SCOUNT        IFEQ      *ZEROS
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
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
 
      ** Strategy Key List.
 
     C     KYHESN        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KPRTP
     C                   KFLD                    KHESN
 
      ** FRA Rates File: Key1 - Full Key.                                                     229414
                                                                                              229414
     C     KFRAR1        KLIST                                                                229414
     C                   KFLD                    UCUCY                                        229414
     C                   KFLD                    WRKBRTT                                      229414
     C                   KFLD                    VDAT                                         229414
                                                                                              229414
      ** FRA Rates File: Key2 - Partial Key.                                                  229414
                                                                                              229414
     C     KFRAR2        KLIST                                                                229414
     C                   KFLD                    UCUCY                                        229414
     C                   KFLD                    WRKBRTT                                      229414
                                                                                              229414
      ** Linkage Key List.
 
     C     KYTRAN        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    KDERITEM
 
     C     KEYBKP        KLIST
     C                   KFLD                    FSFPSE
     C                   KFLD                    FSBRCA
     C**********         KFLD                    FSBKC                                        229563
     C                   KFLD                    FSBKCD                                       229563
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
 
     C     KEYPST        KLIST
     C                   KFLD                    FSBRCA
     C**********         KFLD                    FSBKC                                        229563
     C                   KFLD                    FSBKCD                                       229563
     C                   KFLD                    INSKEY
     C                   KFLD                    INSYY             2 0
     C                   KFLD                    INSMM             2 0
     C                   KFLD                    FSPCAL
 
      ** Access Local data Area (LDA) and retrieve values
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'AS001006'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
 
      ** Obtain default message file.
 
     C     *DTAARA       DEFINE    Y2MGFLA       PZADFMF          10
     C                   IN        PZADFMF
 
      ** Get Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Check multibranch function
 
     C                   IF        MBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PSenty
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        PSNum
     C                   PARM      *BLANK        PSErr
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Determine if switchable feature CAS003 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CAS003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Handle Database Error
 
     C                   IF        PRtcd <> *Blanks AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'CAS003 '     DBKEY
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CAS003 = 'Y'
     C                   ELSE
     C                   EVAL      CAS003 = 'N'
     C                   ENDIF
     C                   EVAL      WOPEN = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *INZSR, SRAudit                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRAudit
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA MON
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12
**CTDATA TP
FV
FX
CF
