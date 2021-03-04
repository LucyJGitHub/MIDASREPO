     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Todays expired hedges report')                *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS001005 - Today's Expired Hedges Report                     *
      *                                                               *
      *  Function:  This program will be run each day during COB,     *
      *             after the Hedge Expiry processing.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
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
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 237063             Date 20Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 229544             Date 15Sep04               *
      *                 224985             Date 18Feb04               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 224116             Date 05Jan04               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 07Jan03               *
      *                 212432             Date 26Sep02               *
      *                 212431             Date 26Sep02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003             Date 14Jan02               *
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     * 
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
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  224985 - Report is showing additional headers/footers for    *
      *           'No Details to Report'                              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224116 - Hedge report should show buy out date as maturity   *
      *           date if deal has been bought out                    *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  212432 - FX deals does not show currency code and principal  *
      *           amount. It should show the hedged side of the deal  *
      *  212431 - Reports show 'Fair Value' heading while the hedges  *
      *           in the report are 'Cash Flow' hedges.               *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    XX         Function of indicator                           *
      *    01         Hedge Strategy Level Break (to supplement WL1)  *
      *    03         Branch Level Break (to supplement WL3)          *
      *    25         Fair Value Product Type                         *
      *    26         Foreign Exchange Product Type                   *
      *    27         Cash Flow Product Type                          *
      *    37         Multibranch active yes/no                       *
      *    54         Record in file found (to supplement *IN55)      *
      *    55         Record in file found/array element found        *
      *    66         Overflow/print headings                         *
      *    77         Expired Hedge Linkages exist on a Hedge Strategy*
      *    87         End of file (auxiliary)                         *
      *    89         End of file (main)                              *
      *                                                               *
      *    U7         External indicators use for error processing    *
      *    U8         External indicators use for error processing    *
      *    L1         Hedge Strategy Level Break                      *
      *    L3         Branch Level Break                              *
      *    LR         Last record                                     *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR         -  Error handling subroutine                   *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRLINK        -  Hedge Linkage Processing                    *
      *  SRTRN1        -  Hedge Transaction Processing                *
      *  SRTRN2        -  Move Data to workfields and print           *
      *                   Transaction Report                          *
      *  SRTRN3        -  Load workfields                             *
      *  SRINL1        -  New Hedge Strategy Level Break              *
      *  SRINL3        -  New Branch Level Break                      *
      *  SRVAL1        -  Check if Hedge Linkages exist               *
      *  SRVAL2        -  Search for live Hedge Linkage records       *
      *  SRDLNO        -  Deal processing                             *
      *  SRFFNO        -  Futures Position processing                 *
      *  SRFHNO        -  Forecast Transaction processing             *
      *  SRLENO        -  Loan processing                             *
      *  SRSENO        -  Security processing                         *
      *  SRAudit       -  Print Audit Report                          *
      *  SRSNMS        -  Retrieve messages from message file         *
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
 
     FFFNPVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Re-valued FF Positions File
 
     F***SENPVLL0  IF   E           K DISK    INFSR(*PSSR)                                    CAS006
      ***Re-valued*Security*Positions*File****************************                        CAS006
 
     FSEMKVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Market Values Using All-In-Rate                                                      CAS006
                                                                                              CAS006
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
 
     FMLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:MLOANCLF)
     F                                     RENAME(CLOANHHF:MATHHF)
     F                                     RENAME(CLOANCKF:MATCKF)
     F                                     RENAME(CLOANZ1F:MATZ1F)
      ** New Matured Loans File
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      ** Securities File
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)                                       CAS003
      ** FF Transaction details                                                               CAS003
                                                                                              CAS003
     FDLDLBBL1  IF   E           K DISK    INFSR(*PSSR)                                       212432
     ** FX Deals by DLNO                                                                      212432
     F                                     RENAME(DEALSDBF:DEALDB)                            212432
     F                                     RENAME(DLBHISD0:DLBHIS)                            212432
     F                                     PREFIX(B)                                          212432
                                                                                              212432
     FDLDLHCL1  IF   E           K DISK    INFSR(*PSSR)                                       212432
     ** DL Money Market Transactions by DLNO                                                  212432
     F                                     RENAME(DEALSDCF:DEALDC)                            212432
     F                                     RENAME(DLCHISD0:DLCHIS)                            212432
     F                                     PREFIX(C)                                          212432
                                                                                              212432
     FAS001005P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFDS(SPOOL1)
     F                                     USROPN                                             224985
      ** Printer file for Today's Expired Hedges Report
 
     FAS001005AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
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
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
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
 
      ** Message data for 'Database Error (ICD)'
     D                 DS
     D  PZAMSDA                1    132
     D  PZA0001                1     10
 
      ** File Information Data Structure for AS001005P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS001005AU
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
 
      ** DS for SC Switchable Features                                                        CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
                                                                                              CAS003
      ** DS for access programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External Data Structures for General Ledger Details                                  CAS004
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAS004
                                                                                              CAS004
     D                 DS
     D  FSFPSE                 1     10
     D  INSKEY                 1      5
     D  INSFLD                 6     10
     D  INSMM@                 6      8
     D  INSYY@                 9     10
     D  FSBKC                 11     12
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
 
      ** Work Fields for SDBANKPD fields
     D WRunDay         S              5  0
     D WRunDate        S              7A
     D WSCount         S              7  0
     D WTCount         S              7  0
     D WECount         S              7  0
     D WFore           S              1A
     D WExre           S              1A
     D INHESN          S              1A
     D INBRCA          S              1A
     D X               S              1  0
 
      ** Work Fields for SDBANKPD fields
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
     D WRKTYP          S              2A
     D WRKSTP          S              2A
     D*WRKCNU***       S              6  0                                                    CSD027
     D WRKCNU          S              6A                                                      CSD027
     D WRKVAL          S              5  0
     D WRKMAT          S              5  0
     D WRKBOV          S              5  0                                                    224116
     D WRKCCY          S              3A
     D WRKPR$          S             13  0
     D WRKINT          S             11  0
     D WRun            S              1A
 
      ** Parameters for ZFRPED
     D ZOUT25          S             25
 
      ** Parameters for SRSNMS
     D PZAPGM          S             10
     D PZAPGRL         S              5
     D PZAMSID         S              7
     D PZAMSGF         S             10
     D PZAMSTP         S              7
 
     ** Parameter for CAS003                                                                  CAS003
     D PSard           S              6                                                       CAS003
     D CAS003          S              1                                                       CAS003
                                                                                              CAS003
     D WEvCtlDt        S              5  0                                                    CAS004
     D WRKEVT          S              5  0                                                    CAS004
     D WEVCD           S              6  0                                                    CAS004
     D KLNKDN          S              6  0                                                    212432
     D WOPEN           S              1                                                       224985
                                                                                              CAS004
      /EJECT
 
     IMATCKF
     I              NLRA                        CKNLRA
     IMATZ1F
     I              NLRA                        Z1NLRA
     I@HGSTD0                                                                                 CAS004
     I              FSEFUP                      SFSEFUP                                       CAS004
     ISDHGSTD0                                                                                CAS004
     I              FSEFUP                      SFSEFUP                                       CAS004
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *LOVAL        SETLL     SDHGSTL2
     C                   READ      SDHGSTL2
 
      ** Audit Report if end of file
 
     C                   IF        %EOF(SDHGSTL2)
     C                   EXSR      SRAudit
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
 
     C                   EXSR      SRProcess
 
     C                   READ      SDHGSTL2
 
      ** At end of Branch print trailer and close printer file if open
 
     C**********         IF        KBRCA <> FSBRCA                                            224985
     C                   IF        %EOF(SDHGSTL2)                                             224985
     C                             AND WOPEN = 'Y'                                            224985
     C                   IF        *IN66 = *ON                                                224985
     C                   WRITE     AS001005D1                                                 224985
     C                   EVAL      *IN66 = *OFF                                               224985
     C                   ENDIF                                                                224985
     C                   WRITE     AS001005D4
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess                                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** If Hedge Linkages exist for Branch's Hedge Strategies
 
     C                   IF        INBRCA = 'Y'
 
      ** If new Hedge Strategy
 
     C                   IF        WL1 = 'Y'
     C                   EVAL      *IN01 = *ON
     C                   EXSR      SRINL1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF
 
      ** If Hedge Linkages exist for Branch's Hedge Strategies
 
     C                   IF        INHESN = 'Y'
 
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
 
     C                   EVAL      INHESN = *BLANKS
 
     C                   EXSR      SRVAL1
 
      ** If Hedge Linkage records to print -first print new headings
 
     C                   IF        *IN77 = *ON
                                                                                              224985
      ** At end of Branch print trailer and close printer file if open                        224985
                                                                                              224985
     C                   IF        PBRCD <> FSBRCA                                            224985
     C                             AND WOPEN = 'Y'                                            224985
     C                   IF        *IN66 = *ON                                                224985
     C                   WRITE     AS001005D1                                                 224985
     C                   EVAL      *IN66 = *OFF                                               224985
     C                   ENDIF                                                                224985
     C                   WRITE     AS001005D4                                                 224985
     C                   ENDIF                                                                224985
 
     C                   EVAL      INHESN = 'Y'
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
                                                                                              224985
     C                   IF        WOPEN <> 'Y'                                               224985
     C                   OPEN      AS001005P1                                                 224985
                                                                                              224985
      ** Ensure Report Spool File recorded by RCF.                                            224985
                                                                                              224985
     C                   CALL      'ZSFILE'                                                   224985
     C                   PARM      *BLANKS       PSeq                                         224985
     C                   PARM      FSBRCA        PSenty                                       224985
     C                   PARM                    SFILE1                                       224985
     C                   PARM      SFNUM1        PSNum                                        224985
     C                   PARM                    PSErr                                        224985
     C                   EVAL      WOPEN = 'Y'                                                224985
     C                   ENDIF                                                                224985
                                                                                              224985
     C                   WRITE     AS001005D1
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
 
     C                   EVAL      INBRCA = *BLANKS
 
     C                   EXSR      SRVAL1
 
     C                   IF        *IN77 = *ON
     C                   EVAL      INBRCA = 'Y'
      **********                                                                              224985
      ***Ensure*Report*Spool*File*recorded*by*RCF.*********************                       224985
      **********                                                                              224985
     C**********         CALL      'ZSFILE'                                                   224985
     C**********         PARM      *BLANKS       PSeq                                         224985
     C**********         PARM      FSBRCA        PSenty                                       224985
     C**********         PARM                    SFILE1                                       224985
     C**********         PARM      SFNUM1        PSNum                                        224985
     C**********         PARM                    PSErr                                        224985
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C     MBIN          IFEQ      'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM      FSBRCA        PDSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
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
 
      ** If expired Hedge Linkages exist, then OK to process
 
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
 
      ** If expired Hedge Linkage record found
 
     C                   IF        FSRECI = 'E' AND FSCHTP = 'E'
     C                             AND FSLCD = WRunDay
     C                   EVAL      *IN77 = *ON
     C                   LEAVE
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
 
      ** For each Hedge Strategy -read all Hedge Linkage records
 
     C                   EVAL      *IN89 = *OFF
     C     FSHESN        SETLL     ASHGLKL2
 
     C     FSHESN        READE     ASHGLKL2                               89
 
     C                   DOW       *IN89 = *OFF
 
      ** If Hedge Linkage has expired today
 
     C                   IF        FSRECI = 'E' AND FSCHTP = 'E'
     C                             AND FSLCD = WRunDay
 
      ** Initialise Hedge Transaction count
 
     C                   Z-ADD     *ZEROS        WTCOUNT
 
      ** Check if hedge is for forecast transactions
 
     C                   EVAL      WFore = *BLANKS
     C                   EVAL      WExre = *BLANKS
     C                   EVAL      HGHDIN = 'H'
 
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
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      HGHDIN = 'D'
     C                   EXSR      SRTRN1
 
      ** Process and print applicable Hedged Transaction records
 
     C                   EVAL      HGHDIN = 'H'
     C                   EXSR      SRTRN1
 
      ** If live Hedge Transaction Details exist -print blank line,
      ** increment number of Hedge Linkages processed by 1 and attempt
      ** to flag Hedge Linkage record as expired (if qualifies)
 
     C                   IF        WTCOUNT > *ZEROS
 
     C                   IF        *IN66 = *ON
     C                   WRITE     AS001005D1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   WRITE     AS001005D3
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
 
     C                   EVAL      *IN97 = *OFF
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               87
 
     C     *IN87         DOWEQ     *OFF
 
      ** Move file fields to printer file fields and print details
 
     C                   EXSR      SRTRN2
 
     C     KYTRAN        READE     ASHTRNL0                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN2 - Move data to workfields and print Transaction Report*
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
     C                   EVAL      WRKTYP = *BLANKS
     C                   EVAL      WRKSTP = *BLANKS
     C**********         EVAL      WRKCNU = *ZEROS                                            CSD027
     C                   EVAL      WRKCNU = *BLANKS                                           CSD027
     C                   EVAL      WRKVAL = *ZEROS
     C                   EVAL      WRKMAT = *ZEROS
     C                   EVAL      WRKCCY = *BLANKS
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
 
      ** Retrieve Transaction details from pertinent files
 
     C                   SELECT
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SRDLNO
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SRLENO
 
     C                   WHEN      FSMOD = 'FH'
     C                   EXSR      SRFHNO
 
     C                   WHEN      FSMOD = 'FF' AND CAS003 = 'Y'                              CAS003
     C                   EXSR      SRFFNO                                                     CAS003
 
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SRSENO
     C                   ENDSL
 
      ** If record found in file
 
     C                   IF        *IN55 = *OFF
 
      ** Load printer file fields
 
     C                   EXSR      SRTRN3
 
      ** Print Hedge Transaction details
 
     C                   IF        *IN66 = *ON
     C                   WRITE     AS001005D1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   WRITE     AS001005D2
 
      ** Increment count of processed records
 
     C                   ADD       1             WTCOUNT
 
     C                   ENDIF
 
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
 
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDHIN        IFEQ      'D'
 
     C*****FSDLNO        CHAIN     DEALSDBF                           55                      CLE148
     C***55FSDLNO        CHAIN     DEALSDGF                           55                      CLE148
     C***55FSDLNO        CHAIN     DLBHISD0                           55                      CLE148
     C***55FSDLNO        CHAIN     DLGHISD0                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDBF                           55                      CLE148
     C   55FSDLNO2       CHAIN     DEALSDGF                           55                      CLE148
     C   55FSDLNO2       CHAIN     DLBHISD0                           55                      CLE148
     C   55FSDLNO2       CHAIN     DLGHISD0                           55                      CLE148
 
     C                   ELSE
 
     C     FSDHIN        IFEQ      'H'
     C*****FSDLNO        CHAIN     DEALSDBF                           55                      CLE148
     C***55FSDLNO        CHAIN     DEALSDCF                           55                      CLE148
     C***55FSDLNO        CHAIN     DEALSDDF                           55                      CLE148
     C***55FSDLNO        CHAIN     DEALSDEF                           55                      CLE148
     C***55FSDLNO        CHAIN     DLBHISD0                           55                      CLE148
     C***55FSDLNO        CHAIN     DLCHISD0                           55                      CLE148
     C***55FSDLNO        CHAIN     DLDHISD0                           55                      CLE148
     C***55FSDLNO        CHAIN     DLEHISD0                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDBF                           55                      CLE148
     C   55FSDLNO2       CHAIN     DEALSDCF                           55                      CLE148
     C   55FSDLNO2       CHAIN     DEALSDDF                           55                      CLE148
     C   55FSDLNO2       CHAIN     DEALSDEF                           55                      CLE148
     C   55FSDLNO2       CHAIN     DLBHISD0                           55                      CLE148
     C   55FSDLNO2       CHAIN     DLCHISD0                           55                      CLE148
     C   55FSDLNO2       CHAIN     DLDHISD0                           55                      CLE148
     C   55FSDLNO2       CHAIN     DLEHISD0                           55                      CLE148
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSDLNO        WRKDLN
     C                   EVAL      WRKBKC = BOKC
     C                   EVAL      WRKTYP = DTYP
     C                   EVAL      WRKSTP = DLST
     C**********         Z-ADD     CNUM          WRKCNU                                       CSD027
     C                   EVAL      WRKCNU = CNUM                                              CSD027
     C                   Z-ADD     VDAT          WRKVAL
     C                   Z-ADD     MDAT          WRKMAT
     C                   EVAL      WRKBOV = *ZEROS                                            224116
 
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
     C                   ELSE                                                                 212432
                                                                                              212432
     C                   EVAL      KLNKDN = LNKDN                                             212432
     C                   IF        FSDHIN = 'D'                                               212432
     C     KLNKDN        CHAIN     DLDLBBL1                                                   212432
                                                                                              212432
     C                   IF        NOT %FOUND(DLDLBBL1)                                       212432
     C     *LOCK         IN        LDA                                                        212432
     C                   EVAL      DBFILE = 'DLDLBBL1'                                        212432
     C                   EVAL      DBASE = 3                                                  212432
     C                   MOVEL     KLNKDN        DBKEY                                        212432
     C                   OUT       LDA                                                        212432
     C                   EXSR      *PSSR                                                      212432
     C                   ENDIF                                                                212432
     C                   EVAL      KLNKDN = BLNKDN                                            212432
     C                   ENDIF                                                                212432
                                                                                              212432
     C     KLNKDN        CHAIN     DLDLHCL1                                                   212432
                                                                                              212432
     C                   IF        NOT %FOUND(DLDLHCL1)                                       212432
     C     *LOCK         IN        LDA                                                        212432
     C                   EVAL      DBFILE = 'DLDLHCL1'                                        212432
     C                   EVAL      DBASE = 4                                                  212432
     C                   MOVEL     KLNKDN        DBKEY                                        212432
     C                   OUT       LDA                                                        212432
     C                   EXSR      *PSSR                                                      212432
     C                   ENDIF                                                                212432
                                                                                              212432
     C                   IF        SLCY = CCCY                                                212432
     C                   EVAL      WRKCCY = SLCY                                              212432
     C                   EVAL      WRKPR$ = SLAM                                              212432
     C                   ELSE                                                                 212432
     C                   EVAL      WRKCCY = PUCY                                              212432
     C                   EVAL      WRKPR$ = PUAM                                              212432
     C                   ENDIF                                                                212432
     C                   ENDIF
 
      ** Money Market Deals
 
     C                   WHEN      RCDFMT = 'DEALSDCF' OR
     C                             RCDFMT = 'DLCHISD0'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ =PCPL
     C     10000000      MULT(H)   INTR          WRKINT
 
      ** Negotiable Assets
 
     C                   WHEN      RCDFMT = 'DEALSDDF' OR
     C                             RCDFMT = 'DLDHISD0'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ =FVAL
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
     C                   EVAL      WRKBOV = BOVD                                              224116
     C                   EVAL      WRKCCY = UCUCY
     C                   EVAL      WRKPR$ = UPAMT
 
      ** Fair Value Interest Rate processing
 
     C                   SELECT
 
     C                   WHEN      FSPRTP = 'FV'
 
     C*****UBRTT         IFEQ      *ZEROS                                                     CSD103
     C     UBRTT         IFEQ      *BLANKS                                                    CSD103
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   ELSE
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   ENDIF
 
      ** Cash Flow Interest Rate processing
 
     C     FSPRTP        WHENEQ    'CF'
 
     C*****UBRTT         IFEQ      *ZEROS                                                     CSD103
     C     UBRTT         IFEQ      *BLANKS                                                    CSD103
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   ELSE
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
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
 
     C     FSDLNO        CHAIN     CLOANCLF                           55
     C   55FSDLNO        CHAIN     MLOANCLF                           55
 
     C     *IN55         IFEQ      *OFF
 
     C                   MOVEL     FSDLNO        WRKDLN
     C                   MOVEL     BOKC          WRKBKC
     C                   MOVEL     LTYP          WRKTYP
     C                   MOVEL     SUTP          WRKSTP
     C**********         Z-ADD     CNUM          WRKCNU                                       CSD027
     C                   EVAL      WRKCNU = CNUM                                              CSD027
     C                   Z-ADD     VDAT          WRKVAL
     C                   Z-ADD     MDAT          WRKMAT
     C                   MOVE      CCY           WRKCCY
     C                   Z-ADD     CPAM          WRKPR$
 
      **  CALCULATE THE NET TREASURY RATE
 
     C     MARG          IFNE      *ZERO
     C                   SUB       MARG          INTR
     C                   ENDIF
 
     C     10000000      MULT(H)   INTR          WRKINT
     C                   ENDIF
 
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
 
     C*****FSDLNO        CHAIN     ASFHTRL1                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           55                      CLE148
 
     C     *IN55         IFEQ      *OFF
     C                   MOVEL     FSDLNO        WRKDLN
     C                   MOVEL     'FH'          WRKTYP
     C                   MOVEL     FSSUBT        WRKSTP
     C                   Z-ADD     FSMDAT        WRKMAT
     C                   MOVE      FSCCY         WRKCCY
     C                   Z-ADD     FSAMNT        WRKPR$
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRFFNO - Futures Position Processing                         *                       CAS003
      *                                                               *                       CAS003
      *  Called By: SRTRN2                                            *                       CAS003
      *                                                               *                       CAS003
      *  Calls: None                                                  *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
                                                                                              CAS003
     C     SRFFNO        BEGSR                                                                CAS003
                                                                                              CAS003
      ** Futures Position Mode                                                                CAS003
                                                                                              CAS003
     C*****FSDLNO        IFEQ      *ZEROS                                              CAS003 CLE148
     C     FSDLNO        IFEQ      *BLANKS                                                    CLE148
     C     FSFPSE        ANDNE     *BLANKS                                                    CAS003
     C     INSFLD        ANDNE     *BLANKS                                                    CAS003
                                                                                              CAS003
     C                   Z-ADD     1             M                 3 0                        CAS003
     C                   MOVE      *OFF          *IN66                                        CAS003
     C     INSMM@        LOOKUP    MON(M)                                 66                  CAS003
                                                                                              CAS003
     C     *IN66         IFEQ      *ON                                                        CAS003
     C                   Z-ADD     NUM(M)        INSMM                                        CAS003
     C                   MOVE      INSYY@        INSYY                                        CAS003
                                                                                              CAS003
     C     KEYPST        KLIST                                                                CAS003
     C                   KFLD                    FSBRCA                                       CAS003
     C                   KFLD                    FSBKC                                        CAS003
     C                   KFLD                    INSKEY                                       CAS003
     C                   KFLD                    INSYY             2 0                        CAS003
     C                   KFLD                    INSMM             2 0                        CAS003
     C                   KFLD                    FSPCAL                                       CAS003
                                                                                              CAS003
     C     KEYPST        CHAIN     FFNPVLL0                           55                      CAS003
                                                                                              CAS003
     C     *IN55         IFEQ      *OFF                                                       CAS003
     C                   MOVEL     FSFPSE        WRKDLN                                       CAS003
     C                   MOVEL     FSBKC         WRKBKC                                       CAS003
     C                   MOVEL     FSPCAL        WRKTYP                                       CAS003
     C                   MOVE      FFCCY         WRKCCY                                       CAS003
     C                   Z-ADD     FFCUTV        WRKPR$                                       CAS003
     C     100000000     MULT(H)   FFSTRP        WRKINT                                       CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
      ** Futures Transaction Mode                                                             CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
     C*****FSDLNO        CHAIN     TRANSDF                            55               CAS003 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANSDF                            55                      CLE148
                                                                                              CAS003
     C                   IF        *IN55 = *OFF                                               CAS003
     C                   MOVEL     FSDLNO        WRKDLN                                       CAS003
     C                   MOVEL     BOKC          WRKBKC                                       CAS003
     C                   MOVEL     ISTT          WRKTYP                                       CAS003
     C**********         Z-ADD     CUSC          WRKCNU                                CAS003 CSD027
     C                   EVAL      WRKCNU = CUSC                                              CSD027
     C                   Z-ADD     VALD          WRKVAL                                       CAS003
     C                   MOVE      ISCY          WRKCCY                                       CAS003
     C                   Z-ADD     NUCO          WRKPR$                                       CAS003
     C     100000000     MULT(H)   COPR          WRKINT                                       CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
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
 
     C     FSFPSE        CHAIN     SECTYDF                            55
 
     C                   IF        *IN55 = *OFF
 
     C     KEYBKP        KLIST
     C                   KFLD                    FSFPSE
     C                   KFLD                    FSBRCA
     C                   KFLD                    FSBKC
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
 
     C*****KEYBKP        CHAIN     SENPVLL0                           55                      CAS006
     C     KEYBKP        CHAIN     SEMKVAL0                           55                      CAS006
 
     C                   IF        *IN55 = *OFF
     C                   MOVEL     FSFPSE        WRKDLN
     C                   MOVEL     FSBKC         WRKBKC
     C                   MOVEL     FSBHTV        WRKTYP
     C                   Z-ADD     MATY          WRKMAT
     C**********         MOVE      SECCY         WRKCCY                                       CAS006
     C**********         Z-ADD     SENAMT        WRKPR$                                       CAS006
     C*****100000000     MULT(H)   SEAVPR        WRKINT                                       CAS006
     C                   MOVE      SACCY         WRKCCY                                       CAS006
     C                   Z-ADD     SANAMT        WRKPR$                                       CAS006
     C     100000000     MULT(H)   SAAVPR        WRKINT                                       CAS006
     C                   ENDIF
 
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
 
     C                   MOVE      FSHEDI        PHEDI
 
      ** Module
 
     C                   MOVEL     FSMOD         PMOD
 
      ** Deal/Loan/FPO/Sec
 
     C                   MOVEL     WRKDLN        PDLNO
 
      ** Book Code
 
     C                   MOVEL     WRKBKC        PBKC
 
      ** Type
 
     C                   MOVEL     WRKTYP        PDTYP
 
      ** Subtype
 
     C                   MOVEL     WRKSTP        PDLST
 
      ** Dash
 
     C     PDLST         IFNE      *BLANKS
     C                   MOVE      '-'           PDASH
     C                   ENDIF
 
      ** Customer Number
 
     C*****WRKCNU        IFNE      *ZEROS                                                     CSD027
     C     WRKCNU        IFNE      *BLANKS                                                    CSD027
     C                   MOVE      WRKCNU        PCNUM
     C                   ELSE
     C                   MOVE      *BLANKS       PCNUM
     C                   ENDIF
 
      ** Value Date
 
     C     WRKVAL        IFNE      *ZEROS
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    WRKVAL
     C                   PARM      BJDFIN        WQ0002            1
     C                   PARM      *ZEROS        @3VDAT            6 0
     C                   PARM      *BLANKS       PVALD
 
     C                   ELSE
     C                   MOVE      *BLANKS       PVALD
     C                   ENDIF
 
      ** Maturity Date
 
     C     WRKMAT        IFNE      *ZEROS
                                                                                              224116
      ** If deal has been bought out, use buy out date as maturity date                       224116
                                                                                              224116
     C                   IF        WRKBOV <> 0                                                224116
     C                   EVAL      WRKMAT = WRKBOV                                            224116
     C                   ENDIF                                                                224116
                                                                                              224116
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    WRKMAT
     C                   PARM      BJDFIN        WQ0002            1
     C                   PARM      *ZEROS        @MATD             6 0
     C                   PARM      *BLANKS       PMATD
 
     C                   ELSE
     C                   MOVE      *BLANKS       PMATD
     C                   ENDIF
 
      ** Currency
 
     C     WRKCCY        IFNE      *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM      '*KEY   '     W0OPTN            7
     C                   PARM      WRKCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDIF
 
      ** Principal
 
     C     WRKPR$        IFNE      *ZEROS
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
 
     C                   ELSE
     C                   MOVE      *BLANKS       PPRIN
     C                   ENDIF
 
      ** Interest Rate
 
     C     WRKINT        IFNE      *ZEROS
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
 
     C                   ELSE
     C                   MOVE      *BLANKS       PINTR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit- Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   MOVE      WRunDate      ORPTDT
 
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
      *  SRSNMS - Retrieve Messages from Message File                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRVAL1                                                *
      *                                                               *
      *****************************************************************
 
     C     SRSNMS        BEGSR
 
      ** Send message to program's message queue
 
     C     PZAPGM        IFEQ      *BLANK
     C                   MOVEL     DBPGM         PZAPGM
     C                   ENDIF
 
      ** If no message file specified use default.
 
     C     PZAMSGF       IFEQ      *BLANK
     C                   MOVEL     PZADFMF       PZAMSGF
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZAPGM
     C                   PARM                    PZAPGRL
     C                   PARM                    PZAMSID
     C                   PARM                    PZAMSGF
     C                   PARM                    PZAMSDA
     C                   PARM                    PZAMSTP
 
      ** Clear all fields for default mechanism next time.
 
     C                   MOVEL     *BLANK        PZAPGM
     C                   MOVEL     *BLANK        PZAPGRL
     C                   MOVEL     *BLANK        PZAMSID
     C                   MOVEL     *BLANK        PZAMSGF
     C                   MOVEL     *BLANK        PZAMSDA
     C                   MOVEL     *BLANK        PZAMSTP
 
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
 
      ** Linkage Key List.
 
     C     KYTRAN        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    HGHDIN            1
 
      ** Access Local data Area (LDA) and retrieve values
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'AS001005'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
 
      ** Obtain default message file.
 
     C     *DTAARA       DEFINE    Y2MGFLA       PZADFMF          10
     C                   IN        PZADFMF
 
      ** Get Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Check multibranch function
 
     C     MBIN          IFEQ      'Y'
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
 
      ** Determine if switchable feature CAS003 is installed                                  CAS003
                                                                                              CAS003
     C                   CALL      'AOSARDR0'                                                 CAS003
     C                   PARM      *Blanks       PRtCd                                        CAS003
     C                   PARM      '*VERIFY'     POption                                      CAS003
     C                   PARM      'CAS003'      PSard                                        CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
      ** Handle Database Error                                                                CAS003
                                                                                              CAS003
     C                   IF        PRtcd <> *Blanks AND                                       CAS003
     C                             PRtcd <> '*NRF   '                                         CAS003
     C     *LOCK         IN        LDA                                                        CAS003
     C                   MOVEL     'CAS003 '     DBKEY                                        CAS003
     C                   MOVE      'SCSARDPD'    DBFILE                                       CAS003
     C                   Z-ADD     002           DBASE                                        CAS003
     C                   OUT       LDA                                                        CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   IF        PRtcd = *Blanks                                            CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      CAS003 = 'N'                                               CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   EVAL      WRunDay = BJRDNB
     C                   EVAL      WRunDate = BJMRDT
     C                   EVAL      WOPEN = 'N'                                                224985
                                                                                              CAS004
      ** Call access program for General Ledger details                                       CAS004
                                                                                              CAS004
     C**********         CALL      'AOGELRR0'                                          CAS004 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRTCD                                        CAS004
     C                   PARM      '*FIRST '     POption                                      CAS004
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS004
                                                                                              CAS004
      ** Database Error                                                                       CAS004
                                                                                              CAS004
     C                   IF        PRTCD <> *BLANKS                                           CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SDGELRPD'                                        CAS004
     C                   EVAL      DBASE = 3                                                  CAS004
     C                   EVAL      DBKEY = POption                                            CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   EVAL      WEvCtlDt = BJDNWD - 1                                      CAS004
     C                   IF        BKAPDT < WEvCtlDt                                          CAS004
     C                   EVAL      WEvCtlDt = BKAPDT                                          CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      WRKEVT = WEvCtlDt                                          CAS004
                                                                                              CAS004
     C                   CALL      'ZDATE2'                                                   CAS004
     C                   PARM                    WRKEVT                                       CAS004
     C                   PARM      BJDFIN        WQ0002                                       CAS004
     C                   PARM      *ZEROS        WEVCD                                        CAS004
     C                   PARM      *BLANKS       PEVCD                                        CAS004
 
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
FV                                                                                            212431
FX                                                                                            212431
CF                                                                                            212431
