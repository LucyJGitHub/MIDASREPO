     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Threshold Amt Reduction/Increase')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000814 - Threshold Amount Reduction/Increase               *
      *                                                               *
      *  Function:  This program updates the threshold amount for     *
      *             customers accounts(Individual/Joint)              *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24196B          Date 22Jul09               *
      *                 BUG24447A          Date 20Jul09               *
      *                 BUG24390           Date 19Jun09               *
      *                 BUG24196           Date 06Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24047           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23549           Date 25Mar09               *
      *                 BUG23517           Date 23Mar09               *
      *                 BUG22952           Date 20Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24196B - Correct processing of Increase/Decrease of       *
      *             Threshold                                         *
      *  BUG24447A - SDC000814 10001                                  *
      *  BUG24390 - Threshold field being updated even if ACUS field  *
      *             is 0                                              *
      *  BUG24196 - Correct processing of Increase/Decrease of        *
      *             Threshold                                         *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  BUG24047 - Printer overflow line error                       *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23549 - Thresholds update exceeds Country of Tax code     *
      *             limits                                            *
      *  BUG23517 - Exclude Certificate Thresholds in amount update   *
      *  BUG22952 - Limit Utilisation Does not match Additional       *
      *             Customer Details                                  *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRCalTH - Subroutine to calculate Threshold                  *
      *  SRWrtDet - Subroutine to write details                       *
      *  SRPrint - Print Detail Report                                *
      *  SRAudit - Print Audit Report                                 *
      *  SRZDate2 - Subroutine Format Date Fields                     *
      *  SRZsEdit - Convert amount from file format to screen format  *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR - Program exception error routine                      *
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
      *
      ** Midas SD Exemption Threshold History File by Cust & Actn
      *
     FSDTHRHL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD  Additional customer details retrieval
      *
     F**********SDACUSL1  IF   E           K DISK    INFSR(*PSSR)                           BUG22952
     FSDACUSL1  UF   E           K DISK    INFSR(*PSSR)                                     BUG22952
     F                                     COMMIT                                           BUG22952
      *                                                                                     BUG22952
      * Midas SD Customer details update                                                    BUG22952
      *                                                                                     BUG22952
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)                                     BUG22952
      *                                                                                     BUG22952
      * Midas SD Branch codes update                                                        BUG22952
      *                                                                                     BUG22952
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)                                     BUG22952
      *                                                                                     BUG22952
      * Midas SD Location codes                                                             BUG22952
      *                                                                                     BUG22952
     FSDLOCNL0  IF   E           K DISK    INFSR(*PSSR)                                     BUG22952
      *                                                                                     BUG22952
      * Midas SD Country of Tax Codes - Rtv Idx                                             BUG22952
      *                                                                                     BUG22952
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG22952
      *                                                                                     BUG23517
      * Midas SD Customer details by country of tax                                         BUG23517
      *                                                                                     BUG23517
     FSDACTXL0  IF   E           K DISK    INFSR(*PSSR)                                     BUG23517
      *
      ** Midas SD Interest Payment History File Update Ind.
      *
     FSDINPHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD Threshold Amt Reduction/Increase Report - Detail
      *
     FSD000814P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      *
      ** Midas SD Threshold Amt Reduction/Increase Report - Audit
      *
     FSD000814AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for Access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access programs - long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Externally described DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency details                                       BUG24196
      *                                                                                     BUG24196
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                BUG24196
      *                                                                                     BUG24196
      ** Externally described DS for Customer Deatils
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** File Information Data Structure for SD000814P1.
      *
     D SPOOL1          DS
     D  SFile1                83     92
     D  SFNum1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File Information Data Structure for SD000814AU.
      *
     D SPOOLU          DS
     D  SFileU                83     92
     D  SFNUMU               123    124B 0
      *
     D PParm           DS            17
     D  PRetcd                 1     10
     D  PThTu                 11     11
     D  PPerc                 12     16
     D  PInrd                 17     17
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter for AOCUSTR0
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PStKey          S              7A
      *
      ** Parameters for ZSFILE
      *
     D PSeq            S              5A
     D PSEnty          S              3A
     D PZSnum          S              6P 0
     D PZSnumU         S              6P 0
     D PZSerr          S              1A
      *
      ** Parameter for ZDATE2
      *
     D PDaynoIn        S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parametrs for ZSEDIT
      *
     D PZFld15         S             15P 0
     D PZDecs          S              1P 0
     D PZeCode         S              1A
     D PZout21         S             21A
      *
     D WPerc           S              5P 3
     D WRun            S              1A
     D WRqdLn1         S              3P 0
     D WDifLn1         S              3P 0
     D WRcf            S              1A   INZ(' ')
     D WCpy            S             80A
     D WNoRec          S              5P 0 INZ(0)
     D WFirst          S              1A   INZ('Y')
     D WFName          S             10A
     D WCust6          S              6A
     D WTeCExt         S                   LIKE(TECEXT)
     D WTMCExt         S              9P 3
     D Wtuth           S             20P 5                                                  BUG24196
      *
     D WBbbrCd         S              3A                                                    BUG22952
     D WBbColC         S              2A                                                    BUG22952
     D WA8lCcd         S              3A                                                    BUG22952
     D WDvcnCd         S              2A                                                    BUG22952
     D WE5JaTp         S              1A                                                    BUG22952
     D WEwInTh         S              6P 0 INZ(0)                                           BUG22952
     D WEwJtTH         S              6P 0 INZ(0)                                           BUG22952
     D                                                                                      BUG22952
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   IF        PRetcd = *BLANKS
     C                   MOVEL     PPerc         WPerc
      *
      ** Read Additional Customer file
      *
     C     *LOVAL        SETLL     SDACUSL1
     C                   READ      SDACUSL1
      *
     C                   DOW       NOT %EOF(SDACUSL1)
      *
      ** Read the Exemption Threshold History File
      *                                                                                     BUG24390
      ** If ACUS threshold is Zero, do not update                                           BUG24390
      *                                                                                     BUG24390
     C                   IF        E5EXTH = 0                                               BUG24390
     C                   READ      SDACUSL1                                                 BUG24390
     C                   ITER                                                               BUG24390
     C                   ENDIF                                                              BUG24390
      *
     C                   EVAL      WCust6 = E5CUST
     C                   EVAL      WE5JaTp = E5JATP                                         BUG22952
      *
     C*****WCust6        SETLL     SDTHRHL3                                                BUG24196B
     C*****WCust6        READE     SDTHRHL3                                                BUG24196B
      **********                                                                           BUG24196B
     C**********         IF        NOT %EOF(SDTHRHL3)                                      BUG24196B
      *                                                                                    BUG24196B
     C     WCust6        CHAIN     SDINPHL0                                                BUG24196B
     C                   IF        %FOUND(SDINPHL0)                                        BUG24196B
     C                             AND TICUTH > *ZERO                                      BUG24196B
      *
     C                   IF        (PThTu = 'I' AND E5JATP = 'I') OR
     C                             (PThTu = 'J' AND E5JATP = 'Y ') OR
     C                             (PThTu = 'B')
      *
     C                   EXSR      SRCalTH
     C                   EXSR      SRChkLmt                                                 BUG22952
     C                   EXSR      SRWrtDet
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SDACUSL1
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   IF        WRcf = 'Y'
      *
      ** Write Out Report Trailer
      *
     C                   EVAL      WRqdLn1 = 4                                              BUG24047
     C                   EVAL      WDifLn1 = OFLLN1 - PRTLN1                                BUG24047
      *                                                                                     BUG24047
     C                   IF        WDifLn1 <= WRqdLn1                                       BUG24047
     C                   WRITE     SD000814R0                                               BUG24047
     C                   ENDIF                                                              BUG24047
      *                                                                                     BUG24047
     C                   WRITE     SD000814R2
     C                   ENDIF
      *
      ** Write Audit Report
      *
     C                   IF        WNoRec = *ZEROS
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalTH - Subroutine to calculate Threshold                  *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCalTH       BEGSR
      *
      ** Increase in Threshold amount requested
      *
     C**********         EVAL      WTeCExt = TECEXT                                        BUG24196B
     C                   EVAL      WTeCExt = TICUTH                                        BUG24196B
     C                   EVAL      WTMCExt = *ZEROS
      *
     C                   IF        PInrd = 'I'
     C**********         EVAL      WTMCExt = TECEXT +                                      BUG24196B
     C**********                            ((WPerc/100)*TECEXT)                           BUG24196B
     C**********         Z-ADD     WTMCExt       TECEXT                                    BUG24196B
     C                   EVAL      WTMCExt = TICUTH +                                      BUG24196B
     C                                      ((WPerc/100)*TICUTH)                           BUG24196B
      *
     C                   ELSEIF    PInrd = 'R'
      *
      ** Decrease in Threshold amount requested
      *
     C**********         EVAL      WTMCExt = TECEXT -                                      BUG24196B
     C**********                            ((WPerc/100)*TECEXT)                           BUG24196B
     C**********         Z-ADD     WTMCExt       TECEXT                                    BUG24196B
     C                   EVAL      WTMCExt = TICUTH -                                      BUG24196B
     C                                      ((WPerc/100)*TICUTH)                           BUG24196B
     C                   ENDIF
      *                                                                                     BUG24196
     C*****WCust6        CHAIN     SDINPHL0                                       BUG24196 BUG24196B
     C**********         IF        %FOUND(SDINPHL0)                               BUG24196 BUG24196B
      *                                                                                     BUG24196
     C                   EVAL      Wtuth = TIUTTH                                           BUG24196
     C                   IF        A6NBDP > 0                                               BUG24196
     C                   EVAL      Wtuth = TIUTTH / (10 ** A6NBDP)                          BUG24196
     C                   ENDIF                                                              BUG24196
      *                                                                                     BUG24196
     C                   IF        WTuth > WTMCExt                                          BUG24196
     C**********         Z-ADD     WTuth         TECEXT                           BUG24196 BUG24196B
     C                   Z-ADD     WTuth         WTMCExt                                   BUG24196B
     C                   ENDIF                                                              BUG24196
      *                                                                                     BUG24196
     C**********         ENDIF                                                    BUG24196 BUG24196B
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG22952
      *                                                               *                     BUG22952
      *  SRChkLmt- Subroutine to Compare Computed Threshold Againts   *                     BUG22952
      *            Threshold Limit                                    *                     BUG22952
      *  Called by : Main Processing                                  *                     BUG22952
      *                                                               *                     BUG22952
      *  Calls: None                                                  *                     BUG22952
      *                                                               *                     BUG22952
      *****************************************************************                     BUG22952
      *                                                                                     BUG22952
     C     SRChkLmt      BEGSR                                                              BUG22952
      *                                                                                     BUG22952
      *  Get Branch Code / Location                                                         BUG22952
      *                                                                                     BUG22952
     C     WCust6        CHAIN     SDCUSTL0                                                 BUG22952
     C                   IF        %Found(SDCUSTL0)                                         BUG22952
     C                   EVAL      WBbbrCd =  BBBRCD                                        BUG22952
     C                   EVAL      WBbColC =  BBCOLC                                        BUG22952
      *                                                                                     BUG22952
     C                   ELSE                                                               BUG22952
      *                                                                                     BUG22952
     C     *LOCK         IN        LDA                                                      BUG22952
     C                   EVAL      DBFILE = 'SDCUSTL0'                                      BUG22952
     C                   EVAL      DBKEY  = WCust6                                          BUG22952
     C                   EVAL      DBASE  = 002                                             BUG22952
     C                   EVAL      DBPGM = 'SD000814'                                       BUG22952
     C                   EVAL      DBMOD =  PSProcMod                                       BUG22952
     C                   OUT       LDA                                                      BUG22952
     C                   EXSR      *PSSR                                                    BUG22952
      *                                                                                     BUG22952
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
      *  Get Branch Code / Location  Code                                                   BUG22952
      *                                                                                     BUG22952
     C     WBbbrCd       CHAIN     SDBRCHL0                                                 BUG22952
     C                   IF        %Found(SDBRCHL0)                                         BUG22952
     C                   EVAL      WA8lCcd = A8LCCD                                         BUG22952
      *                                                                                     BUG22952
     C                   ELSE                                                               BUG22952
      *                                                                                     BUG22952
     C     *LOCK         IN        LDA                                                      BUG22952
     C                   EVAL      DBFILE = 'SDBRCHL0'                                      BUG22952
     C                   EVAL      DBKEY  = WBbbrCd                                         BUG22952
     C                   EVAL      DBASE  = 003                                             BUG22952
     C                   EVAL      DBPGM = 'SD000814'                                       BUG22952
     C                   EVAL      DBMOD = PSProcMod                                        BUG22952
     C                   OUT       LDA                                                      BUG22952
     C                   EXSR      *PSSR                                                    BUG22952
      *                                                                                     BUG22952
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
      *  Get Country Code                                                                   BUG22952
      *                                                                                     BUG22952
     C     WA8lCcd       CHAIN     SDLOCNL0                                                 BUG22952
     C                   IF        %Found(SDLOCNL0)                                         BUG22952
     C                   EVAL      WDvcnCd = DVCNCD                                         BUG22952
      *                                                                                     BUG22952
     C                   ELSE                                                               BUG22952
      *                                                                                     BUG22952
     C     *LOCK         IN        LDA                                                      BUG22952
     C                   EVAL      DBFILE = 'SDLOCNL0'                                      BUG22952
     C                   EVAL      DBKEY  = WA8lCcd                                         BUG22952
     C                   EVAL      DBASE  = 004                                             BUG22952
     C                   EVAL      DBPGM = 'SD000814'                                       BUG22952
     C                   EVAL      DBMOD = PSProcMod                                        BUG22952
     C                   OUT       LDA                                                      BUG22952
     C                   EXSR      *PSSR                                                    BUG22952
      *                                                                                     BUG22952
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
      *                                                                                     BUG22952
      * Compare Calculated Threshold Againts Threshold Limit                                BUG22952
      *                                                                                     BUG22952
     C     Kcttxl1       CHAIN     SDCTTXL1                                                 BUG22952
     C                   IF        %Found(SDCTTXL1)                                         BUG22952
     C                   EVAL      WEwInTh = EWINTH                                         BUG22952
     C                   EVAL      WEwJtTH = EWJTTH                                         BUG22952
     C                                                                                      BUG22952
     C                   IF        WE5JaTp = 'I'                                            BUG22952
     C                                                                                      BUG22952
     C**********         IF        TECEXT    > WEwInTh                            BUG22952 BUG24196B
     C**********         EVAL      TECEXT  =  WEwInTh                             BUG22952 BUG24196B
     C                   IF        WTMCExt   > WEwInTh                                     BUG24196B
     C                   EVAL      WTMCExt =  WEwInTh                                      BUG24196B
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
     C**********         IF        WE5JaTp = 'J'                                   BUG22952 BUG23549
     C                   IF        WE5JaTp = 'Y'                                            BUG23549
     C                                                                                      BUG22952
     C**********         IF        TECEXT    > WEwJtTH                            BUG22952 BUG24196B
     C**********         EVAL      TECEXT  =  WEwJtTH                             BUG22952 BUG24196B
     C                   IF        WTMCExt   > WEwJtTH                                     BUG24196B
     C                   EVAL      WTMCExt =  WEwJtTH                                      BUG24196B
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
     C                   ELSE                                                               BUG22952
      *                                                                                     BUG22952
     C     *LOCK         IN        LDA                                                      BUG22952
     C                   EVAL      DBFILE = 'SDCTTXL1'                                      BUG22952
     C                   EVAL      DBKEY  = 'Kcttxl1'                                       BUG22952
     C                   EVAL      DBASE  = 005                                             BUG22952
     C                   EVAL      DBPGM = 'SD000814'                                       BUG22952
     C                   EVAL      DBMOD = PSProcMod                                        BUG22952
     C                   OUT       LDA                                                      BUG22952
     C                   EXSR      *PSSR                                                    BUG22952
      *                                                                                     BUG22952
     C                   ENDIF                                                              BUG22952
      *                                                                                     BUG22952
     C                   ENDSR                                                              BUG22952
      *****************************************************************                     BUG22952
      /EJECT                                                                                BUG22952
      *****************************************************************
      *                                                               *
      *  SRWrtDet - Subroutine to write details                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRPrint                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRWrtDet      BEGSR
      *                                                                                     BUG23517
      ** Check Customer by country of tax                                                   BUG23517
      *                                                                                     BUG23517
     C     Kactxl        CHAIN     SDACTXL0                                                 BUG23517
     C                   IF        %FOUND(SDACTXL0)                                         BUG23517
     C**********         IF        AXETXS <>  'T' OR                                 BUG23517 CER069
     C                   IF        (AXETXS <>  'T' and                                        CER069
     C                             AXETXS <> 'Y') OR                                          CER069
     C                             AXCRTP = *BLANKS                                         BUG23517
      *                                                                                    BUG24196B
     C                   Z-ADD     BJRDNB        WActdt                                    BUG24196B
     C     Kthrhl        CHAIN     SDTHRHL3                                                BUG24196B
      *                                                                                    BUG24196B
     C                   MOVE      WCust6        TECUST                                    BUG24196B
     C                   Z-ADD     WTMCExt       TECEXT                                    BUG24196B
     C                   Z-ADD     E5EADT        TETRAD                                    BUG24196B
     C                   Z-ADD     E5EVDT        TETRVD                                    BUG24196B
     C                   Z-ADD     E5ETXT        TETRMD                                    BUG24196B
      *
      ** If Action date is equal to run day number update file
      *
     C**********         IF        TEACTD = BJRDNB                                         BUG24196B
     C                   IF        %FOUND(SDTHRHL3)                                        BUG24196B
     C                   UPDATE    SDTHRHD0
     C                   ELSE
      *
      ** Add a new record to threshold value file
      *
     C                   EVAL      TEACTD = BJRDNB
     C                   WRITE     SDTHRHD0
     C                   ENDIF
      *
      *  Update Customer Details Threshold Value                                            BUG22952
     C                   Z-ADD     TECEXT        E5EXTH                                     BUG22952
     C                   UPDATE    @ACUSL1                                                  BUG22952
      *                                                                                     BUG22952
      ** Count the No. of Records Processed
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      TECUST        PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      BBCRNM = *BLANKS
     C                   ENDIF
      *
     C**********         EVAL      WCust6 = TECUST                                         BUG24196B
      *
     C*****WCust6        CHAIN     SDINPHL0                                                BUG24196B
      *
      ** Update Interest Payment History file
      *
     C**********         IF        %FOUND(SDINPHL0)                                        BUG24196B
     C                   EVAL      TICUTH = TECEXT
     C                   UPDATE    SDINPHD0
     C**********         ENDIF                                                             BUG24196B
      *
      ** Process Report Lines
      *
     C                   EXSR      SRPrint
                                                                                            BUG23517
     C                   ENDIF                                                              BUG23517
     C                   ENDIF                                                              BUG23517
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint - Print Detail Report                                *
      *                                                               *
      *  Called by: SRWrtDet                                          *
      *                                                               *
      *  Calls: SRZDate2, SRZsEdit                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRPrint       BEGSR
      *
      ** If first time, Ensure Detail Spool File recorded by RCF
      *
     C                   IF        WRcf = ' '
     C                   OPEN      SD000814P1
     C                   EVAL      WRcf = 'Y'
      *
     C                   EVAL      PZSnum = SFNum1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    SFile1
     C                   PARM                    PZSnum
     C                   PARM      *BLANKS       PZSerr
      *
      ** If Error occurs during ZSFILE processing, then return
      ** to the Calling Program
      *
     C                   IF        PZSerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      WRqdLn1 = 2
     C                   EVAL      WDifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        WDifLn1 <= WRqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     SD000814R0
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
      ** Write Details to Printer Fields
      *
     C                   EVAL      RCUST = TECUST
      *
     C                   EVAL      RCRNM = BBCRNM
      *
     C                   EVAL      PDaynoIn = TEACTD
     C                   EXSR      SRZDate2
     C                   EVAL      RACTD = PADateOut
      *
     C**********         MOVE      WTMCExt       PZFld15                                    BUG22952
     C                   MOVE      TECEXT        PZFld15                                    BUG22952
     C**********         EVAL      PZDecs  = 3                                              BUG22952
     C                   EXSR      SRZSEdit
     C                   EVALR     RCEXT = %TRIM(PZout21)
      *
     C                   EVAL      PDaynoIn = TETRAD
     C                   EXSR      SRZDate2
     C                   EVAL      RTRAD = PADateOut
      *
     C                   EVAL      PDaynoIn = TETRVD
     C                   EXSR      SRZDate2
     C                   EVAL      RTRVD = PADateOut
      *
     C                   EVAL      PDaynoIn = TETRMD
     C                   EXSR      SRZDate2
     C                   EVAL      RTRMD = PADateOut
      *
     C                   EVAL      PZFld15 = WTeCExt
     C                   EVAL      PZDecs  = *ZEROS
     C                   EXSR      SRZsEdit
     C                   EVALR     ROTAMT = %TRIM(PZout21)
      *
     C                   WRITE     SD000814R1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Print Audit Report                                 *
      *                                                               *
      *  Called by: Main Processing , *PSSR                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
      ** Ensure Audit Spool File Recorded by RCF
      *
     C                   MOVE      SFNUMU        PZSnumU
      *                                                                                    BUG24447A
     C                   IF        NOT %OPEN(SD000814AU)                                   BUG24447A
     C                   OPEN      SD000814AU                                              BUG24447A
     C                   ENDIF                                                             BUG24447A
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    SFileU
     C                   PARM                    PZSnumU
     C                   PARM      *BLANKS       PZSerr
      *
      ** If Error occurs during ZSFILE processing, then return
      ** to the Calling Program
      *
     C                   IF        PZSerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C**********         IF        NOT %OPEN(SD000814AU)                                   BUG24447A
     C**********         OPEN      SD000814AU                                              BUG24447A
     C**********         ENDIF                                                             BUG24447A
      *
     C                   WRITE     SD000814R3
      *
      ** If there is a DB Error, Output the DB Error Information
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     SD000814R6
     C                   ELSE
      *
      ** Or, If No records to read, Output "No Details" Msg
      *
     C                   WRITE     SD000814R5
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Subroutine Format Date Fields                     *
      *                                                               *
      *  Called by: SRPrint                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate2      BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    PDaynoIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut
     C                   PARM      *BLANKS       PADateOut
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZsEdit - Convert amount from file format to screen format  *
      *                                                               *
      *  Called by: SRPrint                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZsEdit      BEGSR
      *
     C                   CALL      'ZSEDIT'
      *
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZeCode
     C                   PARM                    PZout21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PParm
      *
      ** Initialize Copyright Array
      *
     C                   MOVEA     CPY@          WCpy
      *
     C                   EVAL      DBPGM = 'SD000814'
     C                   EVAL      DBMOD =  PSProcMod
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPGM = 'SD000814'
     C                   EVAL      DBMOD =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *                                                                                     BUG24196
      ** Access base currency details                                                       BUG24196
      *                                                                                     BUG24196
     C                   CALL      'AOCURRR0'                                               BUG24196
     C                   PARM      *BLANKS       PRtCd                                      BUG24196
     C                   PARM      '*KEY  '      POptn                                      BUG24196
     C                   PARM                    BJCYCD                                     BUG24196
     C     SDCURR        PARM      SDCURR        DSSDY                                      BUG24196
      *                                                                                     BUG24196
     C                   IF        PRtCd <> *BLANKS                                         BUG24196
      *                                                                                     BUG24196
     C     *LOCK         IN        LDA                                                      BUG24196
     C                   EVAL      DBFILE = 'SDCURRPD'                                      BUG24196
     C                   EVAL      DBKEY  = BJCYCD                                          BUG24196
     C                   EVAL      DBASE  = 006                                             BUG24196
     C                   EVAL      DBPGM = 'SD000814'                                       BUG24196
     C                   EVAL      DBMOD =  PSProcMod                                       BUG24196
     C                   OUT       LDA                                                      BUG24196
     C                   EXSR      *PSSR                                                    BUG24196
      *                                                                                     BUG24196
     C                   ENDIF                                                              BUG24196
      *
      ** Report Work Fields
      *
     C                   EVAL      WRqdLn1 = *ZEROS
     C                   EVAL      WDifLn1 = *ZEROS
     C                   EVAL      PRTLN1 = *ZEROS
      *
      * Key Feilds for SDCTTXL1                                                             BUG22952
      *                                                                                     BUG22952
     C     Kcttxl1       KLIST                                                              BUG22952
     C                   KFLD                    WDvcnCd                                    BUG22952
     C                   KFLD                    WBbColC                                    BUG22952
      *                                                                                     BUG22952
     C     Kactxl        KLIST                                                              BUG23517
     C                   KFLD                    WCust6                                     BUG23517
     C                   KFLD                    WDvcnCd                                    BUG23517
      *                                                                                    BUG24196B
     C     Kthrhl        KLIST                                                             BUG24196B
     C                   KFLD                    WCust6                                    BUG24196B
     C                   KFLD                    WActdt            5 0                     BUG24196B
      *                                                                                    BUG24196B
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
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: SRAudit                                                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Finastra International Limited 2008
