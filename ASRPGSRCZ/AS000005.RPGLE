     H DEBUG
     H COPYRIGHT('(c) Misys Internatinal Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge expiry/matured program')                *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000005 - Hedge Expiry/Matured Program                      *
      *                                                               *
      *  Function:  This module expires a hedge if the end date of    *
      *             the Hedge Linkage has been reached or if any      *
      *             hedged items or hedging instruments have matured  *
      *             or have been deleted.                             *
      *                                                               *
      *  Component of: AS000005                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 237063             Date 20Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 229544             Date 15Sep04               *
      *                 228948             Date 27Sep04               *
      *                 229418             Date 02Sep04               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 224135             Date 30Dec03               *
      *                 223934             Date 06Dec03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003             Date 14Jan02               *
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229418 - Should add number of days for hedge effectiveness   *
      *           tolerance.                                          *
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
      *  224135 - Bought Out Derivatives not considered as matured.   *
      *  223934 - Expired Hedge not showing up in Report.             *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         Record Found Indicator (ASHTRNL9)               *
      *    26         'greater than indicator' for COMP operation     *                       CAS005
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRExpENDT - Expires Hedge Linkage if the End Date has been   *
      *              Reached                                          *
      *  SREMatDel   Expires Hedge Linkage if any Hedged Items or     *
      *              Hedging Instruments have matured or have been    *
      *              deleted                                          *
      *  SRExpirDL - Evaluates if any DL Hedged Items or Hedging      *
      *              Instruments have matured or have been deleted    *
      *  SRExpirLE - Evaluates if any LE Hedged Items have matured    *
      *              or have been deleted                             *
      *  SRExpirSE - Evaluates if any SE Hedged Items have matured    *
      *              or have been deleted                             *
      *  SRExpirFF - Evaluates if any FF Hedging/Derivative Items     *                       CAS003
      *              have matured or have been deleted                *                       CAS003
      *  SRCvtMnth - Convert MMM Month Format to MM                   *                       CAS003
      * SRDerv1 - Process Maturity Date of Hedge Derivatives          *                       CAS005
      * SRDerv2 - Process Maturity Date of Hedge Derivatives          *                       CAS005
      * SRItem1 - Process Maturity Date of Hedged Items               *                       CAS005
      * SRItem2 - Process Maturity Date of Hedged Items               *                       CAS005
      * SREffective - Determine if hedge should remain effective or   *                       CAS005
      *               ineffective.                                    *                       CAS005
      * SRZFREQB - Calls ZFREQB                                       *                       CAS005
      * *INZSR     - Initialise                                       *
      * *PSSR      - Error Processing                                 *
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
     FASHGLKL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas AS Hedge Linkage File Update by Hedge ID
 
     FASHTRNL9  IF   E           K DISK    INFSR(*PSSR)
      ** Midas AS Hedge Transaction File Retrieval by Hedge ID
 
     F***DEALALL   IF   E           K DISK    INFSR(*PSSR)                                    CAS005
     F**********                           IGNORE(DEALSDAF)                                   CAS005
     F**********                           IGNORE(DEALSDFF)                                   CAS005
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     IGNORE(MMDELDP0)                                   CAS005
     F                                     IGNORE(MMDENBP0)                                   CAS005
     F                                     IGNORE(MMDENSP0)                                   CAS005
     F                                     IGNORE(FXDEALP0)                                   CAS005
      ** Midas DL All deals
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Midas LE Loans File
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Book Position Headers
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       CAS005
      ** Midas Securities Details                                                             CAS005
                                                                                              CAS005
     FINTYP     IF   E           K DISK    INFSR(*PSSR)                                       CAS005
      ** Midas FF Instrument Types                                                            CAS005
                                                                                              CAS005
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     PREFIX(T)                                          CAS005
      ** Midas SD Hedge Strategy by Shortname Master File                                     CAS005
                                                                                              CAS005
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)                                       CAS003
      ** Midas FF Transaction details                                                         CAS003
                                                                                              CAS003
     FPOSTNK5   IF   E           K DISK    INFSR(*PSSR)                                       CAS003
      ** Midas FF Book Positions by Branch, Book, Instrument Type                             CAS003
                                                                                              CAS003
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CAS003
      ** External data structure for Switchable Features Details                              CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
                                                                                              CAS004
      ** External data structure for General ledger ICD Details                               CAS004
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAS004
                                                                                              229418
      ** External DS for Hedge ICD                                                            229418
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  229418
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D                 DS                                                                     CAS003
     D  WDSfpse                1     10                                                       CAS003
     D  WDSistt                1      5                                                       CAS003
     D  WDSmnth                6      8                                                       CAS003
     D  WDSyrno                9     10  0                                                    CAS003
                                                                                              CAS003
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for AOBANKR0
     D PRetrnCde       S              7A
     D POption         S              7A
                                                                                              CAS003
      ** Parameters for AOSARDR0                                                              CAS003
     D PRtrnCode       S              7A                                                      CAS003
     D POptn           S              7A                                                      CAS003
     D PSard           S              6A                                                      CAS003
 
      ** Parameters for ZFREQB                                                                CAS005
     D PRetCodeIn      S             10A                                                      CAS005
     D PZFreq          S              1A                                                      CAS005
     D PZDayNo         S              5  0                                                    CAS005
     D PZCcy           S              3A                                                      CAS005
     D PZLoc           S              3A                                                    AR702741
     D PZMday          S              2  0                                                    CAS005
     D PBJDFIN         S              1A                                                      CAS005
                                                                                              CAS005
      ** Fields used to define Key List for Midas SE Book Position
      ** Headers
     D KBKbhsc         S             10A
     D KBKbhba         S              3A
     D KBKbhbk         S              2A
     D KBKbhmk         S              1A
     D KBKbhtv         S              1A
 
      ** Fields used to define Key List for Midas FF Book Positions by                        CAS003
      ** Branch, Book and Instrument Type                                                     CAS003
     D KPObrca         S              3A                                                      CAS003
     D KPObokc         S              2A                                                      CAS003
     D KPOistt         S              5A                                                      CAS003
     D KPOyrno         S              2P 0                                                    CAS003
     D KPOmthn         S              2P 0                                                    CAS003
     D KPOpcal         S              1A                                                      CAS003
 
     D WDerivaLive     S              1A
     D WHedgedLive     S              1A
     D WRun            S              1A
     D Wmnth           S              2P 0                                                    CAS003
     D CAS003          S              1                                                       CAS003
     D CAS004          S              1                                                       CAS004
     D EVCD            S              5P 0                                                    CAS004
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D WNotAllMatd     S              1A                                                      CAS005
     D WDervNotLive    S              1A                                                      CAS005
     D WItemNotLive    S              1A                                                      CAS005
     D WDervMatured    S              1A                                                      CAS005
     D WItemMatured    S              1A                                                      CAS005
     D WDervLMatDt     S              5P 0                                                    CAS005
     D WItemLMatDt     S              5P 0                                                    CAS005
     D WLatestMDAT     S              5P 0                                                    CAS005
     D WDervEMatDt     S              5P 0                                                    CAS005
     D WItemEMatDt     S              5P 0                                                    CAS005
     D WErlistMDAT     S              5P 0                                                    CAS005
     D WkTSCD          S              5P 0                                                    CAS005
     D WkESCD          S              5P 0                                                    CAS005
     D WFSRECIOrig     S              1A                                                      CAS005
     D CAS006          S              1A                                                      229418
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read all hedges in the system.
 
     C                   READ      ASHGLKL0
 
      ** Do while not end of file
 
     C                   DOW       NOT %EOF(ASHGLKL0)
 
      ** Expires Hedge Linkage if the end date has been reached.
 
     C                   EXSR      SRExpENDT
 
     C**********         IF        FSRECI = 'D'                                               CAS005
     C                   IF        FSRECI = 'D' OR FSRECI = 'T'                               CAS005
     C                             OR FSRECI = 'X'                                            CAS005
                                                                                              CAS005
     C                   EVAL      WFSRECIOrig = FSRECI                                       CAS005
 
      ** Expires Hedge Linkage if any hedged items or hedging instruments
      ** have matured or have been deleted.
 
     C                   EXSR      SREMatDel
 
     C                   ENDIF
 
      ** Read next record on LF/ASHGLKL0
 
     C                   READ      ASHGLKL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExpENDT - Expires Hedge Linkage if the End Date has been   *
      *              Reached                                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRExpENDT     BEGSR
                                                                                              CAS004
      ** Determine Event Control Date for checking if hedge has expired or matured            CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      EVCD = BJDNWD - 1                                          CAS004
     C                   IF        BKAPDT < EVCD                                              CAS004
     C                   EVAL      EVCD = BKAPDT                                              CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
 
      ***If*end*date*is*less*than*or*equal*to*rundate                                         CAS004
      ** If end date is less than or equal to rundate when CAS004 if off                      CAS004
 
     C                   IF        CAS004 = 'N'                                               CAS004
     C                   IF        FSRECI = 'D' AND FSENDT <= BJRDNB
     C                             OR FSRECI = 'T' AND FSENDT <= BJRDNB
 
     C                   EVAL      FSRECI = 'E'
     C                   EVAL      FSCHTP = 'E'
     C                   EVAL      FSLCD = BJRDNB
     C                   UPDATE    ASHGLKD0
     C                   ENDIF
                                                                                              CAS004
     C                   ELSE                                                                 CAS004
                                                                                              CAS004
      ** If end date is less than or equal to event control date when CAS004 is on            CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   IF        FSRECI = 'D' AND FSENDT <= EVCD                            CAS004
     C                             OR FSRECI = 'T' AND FSENDT <= EVCD                         CAS004
     C                             OR FSRECI = 'X' AND FSENDT <= EVCD                         CAS004
     C                   EVAL      FSRECI = 'E'                                               CAS004
     C                   EVAL      FSCHTP = 'E'                                               CAS004
     C***********        EVAL      FSLCD = EVCD                                        CAS004 223934
     C                   EVAL      FSLCD = BJRDNB                                             223934
     C                   UPDATE    ASHGLKD0                                                   CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREMatDel - Expires Hedge Linkage if any Hedged Items or     *
      *              Hedging Instruments have matured or have been    *
      *              deleted                                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRExpirDL, SRExpirLE, SRExpirSE                       *
      *         SRExpirFF                                             *                       CAS003
      *                                                               *
      *****************************************************************
 
     C     SREMatDel     BEGSR
 
     C                   EVAL      WDerivaLive = *BLANKS
     C                   EVAL      WHedgedLive = *BLANKS
     C                   EVAL      WNotAllMatd  = *BLANKS                                     CAS005
     C                   EVAL      WLatestMDAT  = *ZEROS                                      CAS005
     C                   EVAL      WErlistMDAT  = *ZEROS                                      CAS005
     C                   EVAL      WDervNotLive = *BLANKS                                     CAS005
     C                   EVAL      WDervMatured = *BLANKS                                     CAS005
     C                   EVAL      WDervLMatDt  = *ZEROS                                      CAS005
     C                   EVAL      WDervEMatDt  = 99999                                       CAS005
     C                   EVAL      WItemNotLive = *BLANKS                                     CAS005
     C                   EVAL      WItemMatured = *BLANKS                                     CAS005
     C                   EVAL      WItemLMatDt  = *ZEROS                                      CAS005
     C                   EVAL      WItemEMatDt  = 99999                                       CAS005
 
      ** Read all linked transactions
 
     C     FSHEDI        CHAIN     ASHTRNL9                           25
 
     C                   DOW       *IN25 = *OFF
 
      ** Retrieve transaction
 
     C                   SELECT
 
      ** Money Market / Foreign Exchange
 
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SRExpirDL
 
      ** Customer Loans
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SRExpirLE
 
      ** Securities
 
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SRExpirSE
 
      ** Forecast Transactions
 
     C                   WHEN      FSMOD = 'FH'
 
      ** Forecast Transactions, Expiry of Forecast Transactions is done
      ** by AS000006, thus preserve the live record id.
 
     C                   EVAL      FSRECI = 'D'
     C                   LEAVE
 
     C                   ENDSL
                                                                                              CAS003
      ** If CAS003 is installed, evaluate if any FF Hedging/Derivative                        CAS003
      ** Items have matured or have been deleted.                                             CAS003
                                                                                              CAS003
      ** Futures / Options                                                                    CAS003
                                                                                              CAS003
     C                   IF        CAS003 = 'Y'                                               CAS003
     C                             AND FSMOD = 'FF'                                           CAS003
     C                   EXSR      SRExpirFF                                                  CAS003
     C                   ENDIF                                                                CAS003
 
     C     FSHEDI        READE     ASHTRNL9                               25
     C                   ENDDO
 
     C                   IF        FSRECI = 'E'
 
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSCHTP = 'E'                                               CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      WDervNotLive = 'Y' OR                                      CAS005
     C                             WNotAllMatd <> 'Y'                                         CAS005
                                                                                              CAS005
     C                   WHEN      WItemNotLive = 'Y'                                         CAS005
     C                   EVAL      FSRECI = 'T'                                               CAS005
     C                   EVAL      FSCHTP = 'T'                                               CAS005
                                                                                              CAS005
     C                   WHEN      WItemMatured = 'Y' or WDervMatured = 'Y'                   CAS005
     C                   IF        WFSRECIOrig = 'D'                                          CAS005
     C                   EVAL      FSRECI = 'D'                                               CAS005
     C**********         EVAL      FSCHTP = 'D'                                               CAS005
     C                   EVAL      *IN26 = *OFF                                               CAS005
                                                                                              CAS005
      ** Determine the Latest Maturity Date                                                   CAS005
                                                                                              CAS005
     C     WDervLMatDt   COMP      WItemLMatDt                        26                      CAS005
     C                   IF        *IN26 = *ON                                                CAS005
     C                   EVAL      WLatestMDAT = WDervLMatDt                                  CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WLatestMDAT = WItemLMatDt                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EVAL      *IN26 = *OFF                                               CAS005
     C     FSEFFD        COMP      WLatestMDAT                        26                      CAS005
     C                   IF        *IN26 = *ON                                                CAS005
     C                   EVAL      FSEFFD = WLatestMDAT                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   IF        FSEFFD <= EVCD AND                                         CAS005
     C                             FSRECI = 'D'                                               CAS005
                                                                                              CAS005
     C                   EVAL      *IN26 = *OFF                                               CAS005
                                                                                              CAS005
      ** Determine the Earliest Maturity Date                                                 CAS005
                                                                                              CAS005
     C     WDervEMatDt   COMP      WItemEMatDt                        26                      CAS005
     C                   IF        *IN26 = *OFF                                               CAS005
     C                   EVAL      WErlistMDAT = WDervEMatDt                                  CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WErlistMDAT = WItemEMatDt                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Get EffectiveNess Frequency(FSEFFD)                                                  CAS005
                                                                                              CAS005
     C     FSHGST        CHAIN     SDHGSTL1                                                   CAS005
     C                   IF        NOT %FOUND(SDHGSTL1)                                       CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE =  'SDHGSTL1'                                       CAS005
     C                   EVAL      DBKEY  =  FSHGST                                           CAS005
     C                   EVAL      DBASE  =  006                                              CAS005
     C                   EVAL      DBPROC =  'SR/SREMatDel'                                   CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   EXSR      SREffective                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
      ** Flag expired hedges
 
     C                   IF        WDerivaLive = ' '
     C                   EVAL      FSCHTP = 'E'
 
      ** Flag an expired hedged with a live derivative instrument
      ** as Trading
 
     C                   ELSE
     C                   IF        WHedgedLive = *BLANKS
     C                   EVAL      FSRECI = 'T'
     C                   EVAL      FSCHTP = 'T'
     C                   ELSE
     C                   EVAL      FSCHTP = 'E'
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
 
     C                   IF        FSRECI <> 'D'                                              CAS005
     C                   EVAL      FSLCD = BJRDNB
     C                   UPDATE    ASHGLKD0
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExpirDL - Evaluates if any DL Hedged Items or Hedging      *
      *              Instruments have matured or have been deleted    *
      *                                                               *
      *  Called by: SREMatDel                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRExpirDL     BEGSR
 
     C*****FSDLNO        CHAIN     DEALALL                                                    CAS005
     C*****FSDLNO        CHAIN     DEALSALL                                            CAS005 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALSALL                                                   CLE148
     C**********         IF        NOT %FOUND(DEALALL)                                        CAS005
     C**********                   OR %FOUND(DEALALL) AND RECI <> 'D'                         CAS005
     C                   IF        NOT %FOUND(DEALSALL)                                       CAS005
     C                             OR %FOUND(DEALSALL) AND RECI <> 'D'                        CAS005
     C                   EVAL      FSRECI = 'E'
 
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             %FOUND(DEALSALL)                                           CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      FSDHIN = 'D'                                               CAS005
     C                   EXSR      SRDerv1                                                    CAS005
     C                   WHEN      FSDHIN = 'H'                                               CAS005
     C                   EXSR      SRItem1                                                    CAS005
     C                   ENDSL                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
                                                                                              CAS005
     C                   IF        CAS005 <> 'Y'                                              CAS005
 
      ** Derivative Instrument is Live
 
     C                   IF        FSDHIN = 'D'
     C                   EVAL      WDerivaLive = 'Y'
     C                   ENDIF
 
      ** Hedged Item is Live
 
     C                   IF        FSDHIN = 'H'
     C                   EVAL      WHedgedLive = 'Y'
     C                   ENDIF
 
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      FSDHIN = 'D'                                               CAS005
     C                   EXSR      SRDerv2                                                    CAS005
     C                   WHEN      FSDHIN = 'H'                                               CAS005
     C                   EXSR      SRItem2                                                    CAS005
     C                   ENDSL                                                                CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExpirLE - Evaluates if any LE Hedged Items have matured    *
      *              or have been deleted                             *
      *                                                               *
      *  Called by: SREMatDel                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRExpirLE     BEGSR
 
     C     FSDLNO        CHAIN     CLOAN
     C                   IF        NOT %FOUND(CLOAN)
     C                             OR %FOUND(CLOAN) AND RECI <> 'D'
     C                   EVAL      FSRECI = 'E'
 
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             %FOUND(CLOAN)                                              CAS005
     C                   EXSR      SRItem1                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             NOT %FOUND(CLOAN)                                          CAS005
     C                   EVAL      WItemNotLive = 'Y'                                         CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
 
     C                   IF        CAS005 <> 'Y'                                              CAS005
                                                                                              CAS005
      ** Hedged Item is Live
 
     C                   EVAL      WHedgedLive = 'Y'
 
     C                   ELSE                                                                 CAS005
     C                   EXSR      SRItem2                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF
 
     C                   ENDSR
 
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExpirSE - Evaluates if any SE Hedged Items have matured    *
      *              or have been deleted                             *
      *                                                               *
      *  Called by: SREMatDel                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRExpirSE     BEGSR
 
      ** Validate against Midas SE Book Positions Header
 
     C                   EVAL      KBKbhsc = FSFPSE
     C                   EVAL      KBKbhba = FSBRCA
     C                   EVAL      KBKbhbk = FSBKCD
     C                   EVAL      KBKbhmk = FSMKTI
     C                   EVAL      KBKbhtv = FSBHTV
 
     C     KBKPHD        CHAIN     BKPHD
     C                   IF        NOT %FOUND(BKPHD)
     C                             OR %FOUND(BKPHD) AND RECI <> 'D'
     C                   EVAL      FSRECI = 'E'
 
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             %FOUND(BKPHD)                                              CAS005
     C                   EXSR      SRItem1                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
 
     C                   IF        CAS005 <> 'Y'                                              CAS005
                                                                                              CAS005
     C                   EVAL      WHedgedLive = 'Y'
 
     C                   ELSE                                                                 CAS005
     C                   EXSR      SRItem2                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRExpirFF - Evaluates if any FF Hedging/Derivative Items     *                       CAS003
      *              have matured or have been deleted                *                       CAS003
      *                                                               *                       CAS003
      *  Called by: SREMatDel                                         *                       CAS003
      *                                                               *                       CAS003
      *  Calls: SRCvtMnth                                             *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
                                                                                              CAS003
     C     SRExpirFF     BEGSR                                                                CAS003
                                                                                              CAS003
     C**********         IF        FSDLNO <> 0                                         CAS003 CLE148
     C                   IF        FSDLNO <> *BLANKS                                          CLE148
                                                                                              CAS003
      ** Validate against Midas FF Transactions File                                          CAS003
                                                                                              CAS003
     C*****FSDLNO        CHAIN     TRANS2                                              CAS003 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANS2                                                     CLE148
     C                   IF        NOT %FOUND(TRANS2)                                         CAS003
     C                             OR %FOUND(TRANS2) AND RECI <> 'D'                          CAS003
     C                   EVAL      FSRECI = 'E'                                               CAS003
                                                                                              CAS005
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             %FOUND(TRANS2)                                             CAS005
     C                   EXSR      SRDerv1                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS003
     C                   IF        CAS005 <> 'Y'                                              CAS005
     C                   EVAL      WDerivaLive = 'Y'                                          CAS003
     C                   ELSE                                                                 CAS005
     C                   EXSR      SRDerv2                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
      ** Validate against Midas FF Book Positions file                                        CAS003
                                                                                              CAS003
     C                   EVAL      KPObrca = FSBRCA                                           CAS003
     C                   EVAL      KPObokc = FSBKCD                                           CAS003
     C                   EVAL      KPOpcal = FSPCAL                                           CAS003
     C                   EVAL      WDSfpse = FSFPSE                                           CAS003
     C                   EVAL      KPOistt = WDSistt                                          CAS003
     C                   EVAL      KPOyrno = WDSyrno                                          CAS003
                                                                                              CAS003
     C                   EXSR      SRCvtMnth                                                  CAS003
                                                                                              CAS003
     C                   EVAL      KPOmthn = Wmnth                                            CAS003
                                                                                              CAS003
     C     KPOSTN        CHAIN     POSTNK5                                                    CAS003
     C                   IF        NOT %FOUND(POSTNK5)                                        CAS003
     C                             OR %FOUND(POSTNK5) AND RECI <> 'D'                         CAS003
     C                   EVAL      FSRECI = 'E'                                               CAS003
                                                                                              CAS003
     C                   IF        CAS005 = 'Y' AND                                           CAS005
     C                             %FOUND(POSTNK5)                                            CAS005
     C                   EXSR      SRDerv1                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
     C                   IF        CAS005 <> 'Y'                                              CAS005
     C                   EVAL      WDerivaLive = 'Y'                                          CAS003
     C                   ELSE                                                                 CAS005
     C                   EXSR      SRDerv2                                                    CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      **********************************************************************                  CAS003
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRCvtMnth - Convert MMM Month Format to MM                   *                       CAS003
      *                                                               *                       CAS003
      *  Called by: SRExpirFF                                         *                       CAS003
      *                                                               *                       CAS003
      *  Calls: None                                                  *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
                                                                                              CAS003
     C     SRCvtMnth     BEGSR                                                                CAS003
                                                                                              CAS003
     C                   SELECT                                                               CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'JAN'                                            CAS003
     C                   EVAL      Wmnth = 01                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'FEB'                                            CAS003
     C                   EVAL      Wmnth = 02                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'MAR'                                            CAS003
     C                   EVAL      Wmnth = 03                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'APR'                                            CAS003
     C                   EVAL      Wmnth = 04                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'MAY'                                            CAS003
     C                   EVAL      Wmnth = 05                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'JUN'                                            CAS003
     C                   EVAL      Wmnth = 06                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'JUL'                                            CAS003
     C                   EVAL      Wmnth = 07                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'AUG'                                            CAS003
     C                   EVAL      Wmnth = 08                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'SEP'                                            CAS003
     C                   EVAL      Wmnth = 09                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'OCT'                                            CAS003
     C                   EVAL      Wmnth = 10                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'NOV'                                            CAS003
     C                   EVAL      Wmnth = 11                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'DEC'                                            CAS003
     C                   EVAL      Wmnth = 12                                                 CAS003
                                                                                              CAS003
     C                   ENDSL                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      **********************************************************************                  CAS003
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRDerv1 - Process Maturity Date of Hedge Derivatives          *                       CAS005
      *                                                               *                       CAS005
      * Called by: SRExpirDL, SRexpirFF                               *                       CAS005
      *                                                               *                       CAS005
      * Calls: None                                                   *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRDerv1       BEGSR                                                                CAS005
                                                                                              CAS005
      ** At least one Derivative Instrument matured or                                        CAS005
      ** Not all hedge derivatives and hedged items matured                                   CAS005
                                                                                              CAS005
     C                   IF        RECI = 'M'                                                 CAS005
     C                   EVAL      WDervMatured = 'Y'                                         CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WNotAllMatd = 'Y'                                          CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Derivative Instrument is deleted                                                     CAS005
                                                                                              CAS005
     C                   IF        RECI = '*' OR                                              CAS005
     C                             RECI = 'R'                                                 CAS005
     C                   EVAL      WDervNotLive = 'Y'                                         CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   IF        FSMOD = 'FF'                                               CAS005
     C     ISTT          CHAIN     INTYPDF                                                    CAS005
     C                   EVAL      MDAT = SETD                                                CAS005
     C                   ELSE                                                                 224135
      *                                                                                       224135
      ** If a buy-out is due, set the maturity date to the buy-out                            224135
      ** value date.                                                                          224135
      *                                                                                       224135
     C     BOVD          IFNE      *ZEROS                                                     224135
     C                   Z-ADD     BOVD          MDAT                                         224135
     C                   END                                                                  224135
      *                                                                                       224135
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the earliest maturity date of undeleted derivatives                        CAS005
                                                                                              CAS005
     C                   IF        WDervEMatDt >= MDAT                                        CAS005
     C                   EVAL      WDervEMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the latest maturity date of the undeleted derivatives                      CAS005
                                                                                              CAS005
     C                   IF        WDervLMatDt <= MDAT                                        CAS005
     C                   EVAL      WDervLMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRDerv2 - Process Maturity Date of Hedge Derivatives          *                       CAS005
      *                                                               *                       CAS005
      * Called by: SRExpirDL, SRexpirFF                               *                       CAS005
      *                                                               *                       CAS005
      * Calls: None                                                   *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRDerv2       BEGSR                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WNotAllMatd = 'Y'                                          CAS005
                                                                                              CAS005
     C                   IF        FSMOD = 'FF'                                               CAS005
     C     ISTT          CHAIN     INTYPDF                                                    CAS005
     C                   EVAL      MDAT = SETD                                                CAS005
     C                   ELSE                                                                 224135
      *                                                                                       224135
      ** If a buy-out is due, set the maturity date to the buy-out                            224135
      ** value date.                                                                          224135
      *                                                                                       224135
     C     BOVD          IFNE      *ZEROS                                                     224135
     C                   Z-ADD     BOVD          MDAT                                         224135
     C                   END                                                                  224135
      *                                                                                       224135
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the latest maturity date of the hedge derivatives                          CAS005
                                                                                              CAS005
     C                   IF        WDervLMatDt <= MDAT                                        CAS005
     C                   EVAL      WDervLMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the earliest maturity date of the hedge derivatives                        CAS005
                                                                                              CAS005
     C                   IF        WDervEMatDt >= MDAT                                        CAS005
     C                   EVAL      WDervEMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** At least one hedge derivative or hedged item matured on or                           CAS005
      ** before Event Control Date but equal or greater than run date                         CAS005
                                                                                              CAS005
     C                   IF        MDAT <= EVCD AND                                           CAS005
     C                             MDAT >= BJRDNB                                             CAS005
     C                   EVAL      WDervMatured =  'Y'                                        CAS005
     C                   EVAL      FSRECI  = 'E'                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRItem1 - Process Maturity Date of Hedged Items               *                       CAS005
      *                                                               *                       CAS005
      * Called by: SRExpirDL, SRexpirLE, SRExpirSE                    *                       CAS005
      *                                                               *                       CAS005
      * Calls: None                                                   *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRItem1       BEGSR                                                                CAS005
                                                                                              CAS005
      ** At Least one Hedged Item matured  or                                                 CAS005
      ** Not all hedge derivatives and hedged items matured                                   CAS005
                                                                                              CAS005
     C                   IF        RECI = 'M'                                                 CAS005
     C                   EVAL      WItemMatured = 'Y'                                         CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WNotAllMatd = 'Y'                                          CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Hedged Item is deleted                                                               CAS005
                                                                                              CAS005
     C                   IF        RECI = '*' OR                                              CAS005
     C                             RECI = 'R'                                                 CAS005
     C                   EVAL      WItemNotLive = 'Y'                                         CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   IF        FSMOD = 'SE'                                               CAS005
     C     FSFPSE        CHAIN     SECTY                                                      CAS005
     C                   EVAL      MDAT = MATY                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the earliest maturity date of undeleted hedged items                       CAS005
                                                                                              CAS005
     C                   IF        WItemEMatDt >= MDAT                                        CAS005
     C                   EVAL      WItemEMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the latest maturity date of undeleted hedged items                         CAS005
                                                                                              CAS005
     C                   IF        WItemLMatDt <= MDAT                                        CAS005
     C                   EVAL      WItemLMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRItem2 - Process Maturity Date of Hedged Items               *                       CAS005
      *                                                               *                       CAS005
      * Called by: SRExpirDL, SRexpirLE, SRExpirSE                    *                       CAS005
      *                                                               *                       CAS005
      * Calls: None                                                   *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRItem2       BEGSR                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WNotAllMatd = 'Y'                                          CAS005
                                                                                              CAS005
     C                   IF        FSMOD = 'SE'                                               CAS005
     C     FSFPSE        CHAIN     SECTY                                                      CAS005
     C                   EVAL      MDAT = MATY                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the latest maturity date of the hedge items                                CAS005
                                                                                              CAS005
     C                   IF        WItemLMatDt <= MDAT                                        CAS005
     C                   EVAL      WItemLMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Determine the earliest maturity date of the hedged items                             CAS005
                                                                                              CAS005
     C                   IF        WItemEMatDt >= MDAT                                        CAS005
     C                   EVAL      WItemEMatDt =  MDAT                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** At least one hedge derivative or hedged item matured on or                           CAS005
      ** before Event Control Date but equal or greater than run date                         CAS005
                                                                                              CAS005
     C                   IF        MDAT <= EVCD AND                                           CAS005
     C                             MDAT >= BJRDNB                                             CAS005
     C                   EVAL      WItemMatured = 'Y'                                         CAS005
     C                   EVAL      FSRECI  = 'E'                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SREffective - Determine if hedge should remain effective or   *                       CAS005
      *               ineffective.                                    *                       CAS005
      *                                                               *                       CAS005
      * Called by: SREMatDel                                          *                       CAS005
      *                                                               *                       CAS005
      * Calls: SRZFREQB                                               *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SREffective   BEGSR                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WkTSCD = *ZEROS                                            CAS005
     C                   EVAL      WkESCD = *ZEROS                                            CAS005
                                                                                              CAS005
     C                   IF        WItemMatured = 'Y'                                         CAS005
                                                                                              CAS005
      ** Compute for the 'Trading Status Check Date'                                          CAS005
     C                   IF        WItemEMatDt < FSLASD                                       CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      TFSEFFQ = 'D'                                              CAS005
     C                   IF        CAS006 = 'Y'                                               229418
     C                   EVAL      WkTSCD  = WItemEMatDt + FSHLTO                             229418
     C                   ELSE                                                                 229418
     C                   EVAL      WkTSCD  = WItemEMatDt + 31                                 CAS005
     C                   ENDIF                                                                229418
                                                                                              CAS005
     C                   WHEN      TFSEFFQ = 'M'                                              CAS005
     C                   EVAL      WkTSCD  = FSEFFD                                           CAS005
                                                                                              CAS005
     C                   WHEN      TFSEFFQ = 'Q'                                              CAS005
     C                   EVAL      Pzfreq  = 'M'                                              CAS005
     C                   EVAL      PZDayNo = FSLASD                                           CAS005
     C                   EVAL      Pzmday  = 31                                               CAS005
     C                   EVAL      Pzccy   = BJCYCD                                           CAS005
     C                   EVAL      PBJDFIN = BJDFIN                                           CAS005
     C                   EXSR      SRZFREQB                                                   CAS005
     C                   EVAL      WkTSCD  = PZDayNo                                          CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      TFSEFFQ = 'D'                                              CAS005
     C                   IF        CAS006 = 'Y'                                               229418
     C                   EVAL      WkTSCD  = FSEFFD + FSHLTO                                  229418
     C                   ELSE                                                                 229418
     C                   EVAL      WkTSCD  = FSEFFD + 31                                      CAS005
     C                   ENDIF                                                                229418
                                                                                              CAS005
     C                   WHEN      TFSEFFQ = 'M' OR                                           CAS005
     C                             TFSEFFQ = 'Q'                                              CAS005
     C                   EVAL      Pzfreq  = 'M'                                              CAS005
     C                   EVAL      PZDayNo = FSEFFD                                           CAS005
     C                   EVAL      Pzmday  = 31                                               CAS005
     C                   EVAL      Pzccy   = BJCYCD                                           CAS005
     C                   EVAL      PBJDFIN = BJDFIN                                           CAS005
     C                   EXSR      SRZFREQB                                                   CAS005
     C                   EVAL      WkTSCD  = PZDayNo                                          CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Check for the latest maturity date of the Hedge Derivative/s                         CAS005
     C                   IF        WDervLMatDt > WkTSCD                                       CAS005
     C                   EVAL      FSRECI = 'T'                                               CAS005
     C                   EVAL      FSCHTP = 'T'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      FSEFFD = WDervLMatDt                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WDervMatured = 'Y'                                         CAS005
                                                                                              CAS005
      ** Compute for the 'Expiry Status Check Date'                                           CAS005
     C                   IF        WDervLMatDt < FSLASD                                       CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      TFSEFFQ = 'D'                                              CAS005
     C                   IF        CAS006 = 'Y'                                               229418
     C                   EVAL      WkESCD  = WErlistMDAT + FSHLTO                             229418
     C                   ELSE                                                                 229418
     C                   EVAL      WkESCD  = WErlistMDAT + 31                                 CAS005
     C                   ENDIF                                                                229418
                                                                                              CAS005
     C                   WHEN      TFSEFFQ = 'M'                                              CAS005
     C                   EVAL      WkESCD  = FSEFFD                                           CAS005
                                                                                              CAS005
     C                   WHEN      TFSEFFQ = 'Q'                                              CAS005
     C                   EVAL      Pzfreq  = 'M'                                              CAS005
     C                   EVAL      PZDayNo = FSLASD                                           CAS005
     C                   EVAL      Pzmday  = 31                                               CAS005
     C                   EVAL      Pzccy   = BJCYCD                                           CAS005
     C                   EVAL      PBJDFIN = BJDFIN                                           CAS005
     C                   EXSR      SRZFREQB                                                   CAS005
     C                   EVAL      WkESCD  = PZDayNo                                          CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      TFSEFFQ = 'D'                                              CAS005
     C                   IF        CAS006 = 'Y'                                               229418
     C                   EVAL      WkESCD  = FSEFFD + FSHLTO                                  229418
     C                   ELSE                                                                 229418
     C                   EVAL      WkESCD  = FSEFFD + 31                                      CAS005
     C                   ENDIF                                                                229418
                                                                                              CAS005
     C                   WHEN      TFSEFFQ = 'M' OR                                           CAS005
     C                             TFSEFFQ = 'Q'                                              CAS005
     C                   EVAL      Pzfreq  = 'M'                                              CAS005
     C                   EVAL      PZDayNo = FSEFFD                                           CAS005
     C                   EVAL      Pzmday  = 31                                               CAS005
     C                   EVAL      Pzccy   = BJCYCD                                           CAS005
     C                   EVAL      PBJDFIN = BJDFIN                                           CAS005
     C                   EXSR      SRZFREQB                                                   CAS005
     C                   EVAL      WkESCD  = PZDayNo                                          CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Check for the latest maturity date of the Hedge Derivative/s                         CAS005
     C                   IF        WDervLMatDt > WkESCD                                       CAS005
     C                   EVAL      FSRECI = 'E'                                               CAS005
     C                   EVAL      FSCHTP = 'E'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      FSEFFD = WDervLMatDt                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRZFREQB - Calls ZFREQB                                       *                       CAS005
      *                                                               *                       CAS005
      * Called by: SREffective                                        *                       CAS005
      *                                                               *                       CAS005
      * Calls: ZFREQB                                                 *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRZFREQB      BEGSR                                                                CAS005
                                                                                              CAS005
     C                   CALLB     'ZFREQB'                                                   CAS005
     C                   PARM      *BLANKS       PRetCodeIn                                   CAS005
     C                   PARM                    PZFreq                                       CAS005
     C                   PARM                    PZDayNo                                      CAS005
     C                   PARM                    PZCcy                                        CAS005
     C                   PARM      *BLANKS       PZLoc                                      AR702741
     C                   PARM                    PZMday                                       CAS005
     C                   PARM                    PBJDFIN                                      CAS005
     C     SDGELR        PARM                    SDGELR                                       CAS005
                                                                                              CAS005
     C                   IF        PRetCodeIn <> *BLANKS                                      CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE =  'ZFREQB'                                         CAS005
     C                   EVAL      DBKEY  =  '*CALL'                                          CAS005
     C                   EVAL      DBASE  =  005                                              CAS005
     C                   EVAL      DBPROC =  'SR/SRZFREQB'                                    CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, *PSSR                                        *
      *        AOSARDR0                                               *                       CAS003
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
 
      **  Use access program to read bank details file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetrnCde
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              229418
      ** Access the Hedging ICD                                                               229418
                                                                                              229418
     C                   CALLB     'AOHEDGR0'                                                 229418
     C                   PARM      *BLANKS       PRetrnCde                                    229418
     C                   PARM      '*FIRST '     POption                                      229418
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        229418
                                                                                              229418
     C                   IF        PRetrnCde <> *Blanks                                       229418
     C     *LOCK         IN        LDA                                                        229418
     C                   EVAL      DBFILE =  'SDHEDGPD'                                       229418
     C                   EVAL      DBKEY  =  '*CALL'                                          229418
     C                   EVAL      DBASE  =  7                                                229418
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      229418
     C                   OUT       LDA                                                        229418
     C                   EXSR      *PSSR                                                      229418
     C                   ENDIF                                                                229418
                                                                                              CAS003
      ** Check if enhancement CAS003 is switched on.                                          CAS003
                                                                                              CAS003
     C                   CALLB     'AOSARDR0'                                                 CAS003
     C                   PARM      *BLANKS       PRtrnCode                                    CAS003
     C                   PARM      '*VERIFY'     POptn                                        CAS003
     C                   PARM      'CAS003'      PSard                                        CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        PRtrnCode = *BLANKS                                        CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      CAS003 = 'N'                                               CAS003
                                                                                              CAS003
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS003
     C     *LOCK         IN        LDA                                                        CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBKEY = 'CAS003'                                           CAS003
     C                   EVAL      DBASE = 002                                                CAS003
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS003
     C                   OUT       LDA                                                        CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS004
      ** Call access program for General Ledger details.                                      CAS004
                                                                                              CAS004
     C**********         CALL      'AOGELRR0'                                          CAS004 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtrnCode                                    CAS004
     C                   PARM      '*FIRST '     POptn                                        CAS004
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CAS004 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
                                                                                              CAS004
      ** Database Error                                                                       CAS004
                                                                                              CAS004
     C     PRtrnCode     IFNE      *BLANK                                                     CAS004
     C                   EVAL      DBFILE = 'SDGELRPD'                                        CAS004
     C                   EVAL      DBASE = 003                                                CAS004
     C                   EVAL      DBKEY = POptn                                              CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Check if enhancement CAS004 is switched on.                                          CAS004
                                                                                              CAS004
     C                   CALLB     'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRtrnCode                                    CAS004
     C                   PARM      '*VERIFY'     POptn                                        CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtrnCode = *BLANKS                                        CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
                                                                                              CAS004
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBKEY = 'CAS004'                                           CAS004
     C                   EVAL      DBASE = 004                                                CAS004
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS005
      ** Check if enhancement CAS005 is switched on.                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRtrnCode                                    CAS005
     C                   PARM      '*VERIFY'     POptn                                        CAS005
     C                   PARM      'CAS005'      PSard                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRtrnCode = *BLANKS                                        CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
                                                                                              CAS005
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   EVAL      DBASE = 005                                                CAS005
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              229418
      ** Check if enhancement CAS006 is switched on.                                          229418
                                                                                              229418
     C                   CALLB     'AOSARDR0'                                                 229418
     C                   PARM      *BLANKS       PRtrnCode                                    229418
     C                   PARM      '*VERIFY'     POptn                                        229418
     C                   PARM      'CAS006'      PSard                                        229418
     C     SCSARD        PARM      SCSARD        DSFDY                                        229418
                                                                                              229418
     C                   IF        PRtrnCode = *BLANKS                                        229418
     C                   EVAL      CAS006 = 'Y'                                               229418
                                                                                              229418
     C                   ELSE                                                                 229418
     C                   EVAL      CAS006 = 'N'                                               229418
                                                                                              229418
     C                   IF        PRtrnCode <> '*NRF   '                                     229418
     C     *LOCK         IN        LDA                                                        229418
     C                   EVAL      DBFILE = 'SCSARDPD'                                        229418
     C                   EVAL      DBKEY = 'CAS006'                                           229418
     C                   EVAL      DBASE = 8                                                  229418
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      229418
     C                   OUT       LDA                                                        229418
     C                   EXSR      *PSSR                                                      229418
     C                   ENDIF                                                                229418
     C                   ENDIF                                                                229418
 
      ** Key List for Midas SE Book Position Headers
 
     C     KBKPHD        KLIST
     C                   KFLD                    KBKbhsc
     C                   KFLD                    KBKbhba
     C                   KFLD                    KBKbhbk
     C                   KFLD                    KBKbhmk
     C                   KFLD                    KBKbhtv
                                                                                              CAS003
      ** Key List for Midas FF Book Positions by Branch, Book and                             CAS003
      ** Instrument Type                                                                      CAS003
                                                                                              CAS003
     C     KPOSTN        KLIST                                                                CAS003
     C                   KFLD                    KPObrca                                      CAS003
     C                   KFLD                    KPObokc                                      CAS003
     C                   KFLD                    KPOistt                                      CAS003
     C                   KFLD                    KPOyrno                                      CAS003
     C                   KFLD                    KPOmthn                                      CAS003
     C                   KFLD                    KPOpcal                                      CAS003
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
