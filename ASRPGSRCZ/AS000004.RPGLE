     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge effectiveness assessment FH trans')     *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000004 - Hedge Effectiveness Assessment FH Transactions    *
      *                                                               *
      *  Function:  This module will assess each hedge in the system. *
      *             Effectiveness can be achieved when the critical   *
      *             terms of the hedging instrument matches that of   *
      *             the hedged item.                                  *
      *
      *  Component of: ASC000004                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 228948             Date 27Sep04               *
      *                 229418             Date 02Sep04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229418 - Should add number of days for hedge effectiveness   *
      *           tolerance.                                          *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         Chain Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRFwdCommit - Subroutine to process derivatives - Forward     *
      *               Commitments                                     *
      **SRFCTran****-*Subroutine*to*process*Hedged*Items*-*Forecast****                       CAS006
      ****************Transactions*************************************                       CAS006
      * SRFwdCmtDLLE - Process derivatives-Forward Commitments (DL,LE)*                       CAS006
      * SRInitURPL - Set FSURPL in ASFHTRPD to zero.                  *                       CAS006
      * SREffective - Subroutine to calculate Hedge Effectiveness of  *
      *               Forecast Transactions                           *
      * SRDate - Subroutine to call ZDATE2                            *
      * *PSSR  - Program Exception Error Routine                      *
      * *INZSR - Initialise                                           *
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
 
     FASHGLKL0  UF A E           K DISK    INFSR(*PSSR)
      ** Hedge Linkage File Update by Hedge Id
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
      ** Hedge Transaction File RTV by Hedge Id/Indicator
 
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Hedge Strategy by Shortname Master File Update Index
 
     F***ASFHTRL1  IF   E           K DISK    INFSR(*PSSR)                                    CAS006
     FASFHTRL1  UF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                                                                        CAS006
      ** Forecast Transaction Details Master File Retrieval Index
 
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDDF)                                   CAS006
     F                                     IGNORE(DEALSDFF)
     F**********                           IGNORE(DEALSDGF)                                   CAS006
      ** Midas DL Deals File
 
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
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
                                                                                              229418
      ** External DS for Hedge ICD                                                            229418
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  229418
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for SAR Details                                              CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS006
                                                                                              CAS006
     D                 DS
     D WMatDate                1      7
     D WMatMonth               3      5
     D WMatYear                6      7                                                       CAS006
                                                                                              CAS006
     D                 DS                                                                     CAS006
     D WkMatD                  1      7                                                       CAS006
     D WkMMon                  3      5                                                       CAS006
     D WkMYer                  6      7                                                       CAS006
 
     D                 DS
     D WValDate                1      7
     D WValMonth               3      5
     D WValYear                6      7                                                       CAS006
 
     D                 DS
     D WHDate                  1      7
     D WHMonth                 3      5
     D WHYear                  6      7                                                       CAS006
 
     D WRun            S              1A
 
      ** Parameters for Standard Access Objects
     D PRtCd           S              7A
     D POption         S              7A
 
      ** Work Fields for SDBANKPD fields
     D WRunDay         S              5  0
     D PBankCurr       S              3A
     D PDateFormat     S              1A
 
      ** Fields used for standard programs
     D PFInput         S              5  0
     D PNOutput        S              6  0
     D PAOutput        S              7A
 
     D KHedgeInd       S              1A
     D WExpRec         S              1A
     D WCurrency       S              3A
     D*WEffect**       S              1A                                                      CAS006
     D WNotEffct       S              1A                                                      CAS006
     D WEMDate         S              5  0                                                    229418
     D WLMDate         S              5  0                                                    229418
     D WEDiffDays      S              3  0                                                    229418
     D WLDiffDays      S              3  0                                                    229418
     D WAmount         S             20  0
     D WHAmount        S             20  0
     D CAS006          S              1                                                       CAS006
     D WkAmnt          S             20  0                                                    CAS006
 
      ** Parameters for ZFREQB
     D PFrequency      S              1A
     D PDayNum         S              5  0
     D PDays           S              2  0
     D PLoc            S              3A                                                    AR702741
                                                                                              CAS006
      ** Parameters for AOSARDR0                                                              CAS006
     D PRtrnCode       S              7A                                                      CAS006
     D POptn           S              7A                                                      CAS006
     D PSard           S              6A                                                      CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      ** +--------------------------------------+                                             CAS006
      ** ¦ I-specs                              ¦                                             CAS006
      ** ¦ =======                              ¦                                             CAS006
      ** +--------------------------------------+                                             CAS006
                                                                                              CAS006
     ISDHGSTD0                                                                                CAS006
     I              FSEFUP                      FSEVUP                                        CAS006
                                                                                              CAS006
     IASFHTRD0                                                                                CAS006
     I              FSMOD                       FSMODE                                        CAS006
                                                                                              CAS006
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
 
      ** Read all the Hedges in the system
 
     C                   READ      ASHGLKL0
 
      ** Do while not end of file
 
     C                   DOW       NOT %EOF(ASHGLKL0)
 
      ** Assess hedge if effective date is equal to rundate
 
     C                   IF        FSRECI = 'D' AND FSEFFD = WRunDay
 
      ** Check if hedging forecast transactions
 
     C                   EVAL      WHAmount = *ZEROS                                          CAS006
     C                   EVAL      KHedgeInd = 'H'
 
     C     KHedgeTran    CHAIN     ASHTRNL1
 
     C                   IF        %FOUND(ASHTRNL1) AND FSMOD = 'FH'
 
      ** Retrieve Critical Terms:
      ** Transaction Currency and Maturity Date
 
     C*****FSDLNO        CHAIN     ASFHTRL1                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                                                   CLE148
     C                   IF        NOT %FOUND(ASFHTRL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 2
     C                   EVAL      DBFile = 'ASFHTRL1'
     C                   MOVEL     FSDLNO        DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   EVAL      WExpRec= FSERIN
     C                   EVAL      WCurrency = FSCCY
 
      ** Retrieve Maturity Month
 
     C**********         EVAL      PFInput = FSMDAT                                           229418
     C**********         EXSR      SRDate                                                     229418
     C**********         EVAL      WMatDate = PAOutput                                        229418
                                                                                              229418
      ** Set the earliest and latest maturity date work field                                 229418
                                                                                              229418
     C                   EVAL      WEMDate = FSMDAT                                           229418
     C                   EVAL      WLMDate = FSMDAT                                           229418
                                                                                              CAS006
      ** Get hedged portion of the amount                                                     CAS006
                                                                                              CAS006
     C                   EVAL      WkAmnt = FSAMNT * FSPCTG / 100                             CAS006
     C                   ADD       WkAmnt        WHAmount                                     CAS006
                                                                                              CAS006
      ** Continue on reading through the hedge transactions file                              CAS006
                                                                                              CAS006
     C                   EVAL      WNotEffct = *BLANKS                                        CAS006
     C     KHedgeTran    READE     ASHTRNL1                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(ASHTRNL1) AND WNotEffct = *BLANKS                 CAS006
                                                                                              CAS006
     C                   IF        FSMOD = 'FH'                                               CAS006
     C*****FSDLNO        CHAIN     ASFHTRL1                                            CAS006 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                                                   CLE148
                                                                                              CAS006
     C                   IF        NOT %FOUND(ASFHTRL1)                                       CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBase = 6                                                  CAS006
     C                   EVAL      DBFile = 'ASFHTRL1'                                        CAS006
     C                   MOVEL     FSDLNO        DBKey                                        CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Convert Maturity Date                                                                CAS006
                                                                                              CAS006
     C**********         EVAL      PFInput = FSMDAT                                    CAS006 229418
     C**********         EXSR      SRDate                                              CAS006 229418
     C**********         EVAL      WkMatD = PAOutput                                   CAS006 229418
                                                                                              229418
     C                   IF        FSMDAT < WEMDate                                           229418
     C                   EVAL      WEMDate = FSMDAT                                           229418
     C                   ENDIF                                                                229418
     C                   IF        FSMDAT > WLMDate                                           229418
     C                   EVAL      WLMDate = FSMDAT                                           229418
     C                   ENDIF                                                                229418
                                                                                              CAS006
     C**********         IF        WExpRec <> FSERIN OR WCurrency <> FSCCY OR          CAS006 229418
     C**********                   WMatMonth <> WkMMon OR WMatYear <> WkMYer           CAS006 229418
     C                   IF        WExpRec <> FSERIN OR WCurrency <> FSCCY                    229418
     C                   EVAL      WNotEffct = 'Y'                                            CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Accumulate the hedged portion of the amount                                          CAS006
                                                                                              CAS006
     C                   EVAL      WkAmnt = FSAMNT * FSPCTG / 100                             CAS006
     C                   ADD       WkAmnt        WHAmount                                     CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Read next live hedged forecast transaction record                                    CAS006
                                                                                              CAS006
     C     KHedgeTran    READE     ASHTRNL1                                                   CAS006
                                                                                              CAS006
     C                   ENDDO                                                                CAS006
 
     C                   ENDIF
 
     C**********         EVAL      WEffect = *BLANKS                                          CAS006
     C                   EVAL      WAmount = *ZEROS
     C**********         EVAL      WHAmount = *ZEROS                                          CAS006
 
      ** DERIVATIVES - Hedging Instruments
      ** Retrieve NPV Amounts
 
     C                   EVAL      KHedgeInd = 'D'
 
     C     KHedgeTran    CHAIN     ASHTRNL1                           26
 
     C                   DOW       *IN26 = *OFF
 
     C**********         IF        WEffect <> 'Y'                                             CAS006
     C                   IF        WNotEffct <> 'Y'                                           CAS006
                                                                                              CAS006
     ** If CAS006 is on, process also DL and LE transactions.                                 CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
     C                   WHEN      FSMODE = 'GL'                                              CAS006
     C                   EXSR      SRFwdCommit
                                                                                              CAS006
     C                   WHEN      (FSMODE = 'DL' OR FSMODE = 'LE')                           CAS006
     C                             AND CAS006 = 'Y'                                           CAS006
     C                   EXSR      SRFwdCmtDLLE                                               CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C     KHedgeTran    READE     ASHTRNL1                               26
     C                   ENDDO
 
     C**********         IF        WEffect = *BLANKS                                          CAS006
 
      ***Hedged*Items******************************************************                   CAS006
      ***Retrieve*NPV*Amounts**********************************************                   CAS006
 
     C**********         EVAL      KHedgeInd = 'H'                                            CAS006
 
     C*****KHedgeTran    CHAIN     ASHTRNL1                           26                      CAS006
 
     C**********         DOW       *IN26 = *OFF                                               CAS006
 
     C**********         IF        WEffect <> 'Y'                                             CAS006
     C**********         EXSR      SRFCTran                                                   CAS006
     C**********         ELSE                                                                 CAS006
     C**********         LEAVE                                                                CAS006
     C**********         ENDIF                                                                CAS006
 
     C*****KHedgeTran    READE     ASHTRNL1                               26                  CAS006
     C**********         ENDDO                                                                CAS006
 
     C**********         ENDIF                                                                CAS006
 
      ** Assess Effectiveness
 
     C                   EXSR      SREffective
 
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record on LF/ASHGLKL0
 
     C                   READ      ASHGLKL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      *  SRFwdCommit - Subroutine to process derivatives - Forward    *
      *                Commitments                                    *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRFwdCommit   BEGSR
 
      ** Hedging Forecast Transactions
 
     C*****FSDLNO        CHAIN     DEALS                                                      CAS006
     C*****FSDLNO        CHAIN     DEALSDBF                                            CAS006 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALSDBF                                                   CLE148
 
     C**********         IF        %FOUND(DEALS)                                              CAS006
     C                   IF        %FOUND                                                     CAS006
 
      ** Retrieve Value Date Month
 
     C**********         EVAL      PFInput = VDAT                                             229418
     C**********         EXSR      SRDate                                                     229418
     C**********         EVAL      WValDate = PAOutput                                        229418
                                                                                              229418
     C                   EVAL      WEDiffDays = %ABS(WEMDate - VDAT)                          229418
     C                   EVAL      WLDiffDays = %ABS(WLMDate - VDAT)                          229418
 
     C                   SELECT
 
      ** Expenditures
 
     C                   WHEN      WExpRec = 'E'
 
     C                   IF        PUCY <> WCurrency OR
     C                             WEDiffDays > FSHLTO AND                                    229418
     C                             CAS006 = 'Y' OR                                            229418
     C                             WLDiffDays > FSHLTO AND                                    229418
     C                             CAS006 = 'Y'                                               229418
     C**********                   WMatMonth <> WValMonth                                     229418
     C**********                   OR WMatYear <> WValYear                             CAS006 229418
     C**********                   AND CAS006 = 'Y'                                    CAS006 229418
     C**********         EVAL      WEffect = 'Y'                                              CAS006
     C                   EVAL      WNotEffct = 'Y'                                            CAS006
     C                   ELSE
     C**********         ADD       PUAM          WAmount                                      CAS006
                                                                                              CAS006
      ** Accumulate the hedged percentage of the derivative                                   CAS006
                                                                                              CAS006
     C                   EVAL      WkAmnt = PUAM * FSPCTG / 100                               CAS006
     C                   ADD       WkAmnt        WAmount                                      CAS006
     C                   ENDIF
 
      ** Receipts
 
     C                   WHEN      WExpRec = 'R'
     C                   IF        SLCY <> WCurrency OR
     C                             WEDiffDays > FSHLTO AND                                    229418
     C                             CAS006 = 'Y' OR                                            229418
     C                             WLDiffDays > FSHLTO AND                                    229418
     C                             CAS006 = 'Y'                                               229418
     C**********                   WMatMonth <> WValMonth                                     229418
     C**********                   OR WMatYear <> WValYear                             CAS006 229418
     C**********                   AND CAS006 = 'Y'                                    CAS006 229418
     C**********         EVAL      WEffect = 'Y'                                              CAS006
     C                   EVAL      WNotEffct = 'Y'                                            CAS006
     C                   ELSE
     C**********         ADD       SLAM          WAmount                                      CAS006
                                                                                              CAS006
      ** Accumulate the hedged percentage of the derivative                                   CAS006
                                                                                              CAS006
     C                   EVAL      WkAmnt = SLAM * FSPCTG / 100                               CAS006
     C                   ADD       WkAmnt        WAmount                                      CAS006
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRFwdCmtDLLE - Process derivatives - Forward Commitments (DL)*                       CAS006
      *                                                           (LE)*                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRFwdCmtDLLE  BEGSR                                                                CAS006
                                                                                              CAS006
      ** Hedging Forecast Transactions                                                        CAS006
                                                                                              CAS006
     C*****FSDLNO        CHAIN     DEALSDGF                                            CAS006 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALSDGF                                                   CLE148
                                                                                              CAS006
     C                   IF        %FOUND                                                     CAS006
                                                                                              CAS006
      ** Retrieve Value Date Month and Year                                                   CAS006
                                                                                              CAS006
     C**********         EVAL      PFInput = VDAT                                      CAS006 229418
     C**********         EXSR      SRDate                                              CAS006 229418
     C**********         EVAL      WValDate = PAOutput                                 CAS006 229418
                                                                                              229418
     C                   EVAL      WEDiffDays = %ABS(WEMDate - VDAT)                          229418
     C                   EVAL      WLDiffDays = %ABS(WLMDate - VDAT)                          229418
                                                                                              CAS006
     C                   IF        UCUCY <> WCurrency OR                                      CAS006
     C                             WEDiffDays > FSHLTO AND                                    229418
     C                             CAS006 = 'Y' OR                                            229418
     C                             WLDiffDays > FSHLTO AND                                    229418
     C                             CAS006 = 'Y' OR                                            229418
     C**********                   WMatMonth <> WValMonth OR                           CAS006 229418
     C**********                   WMatYear <> WValYear OR                             CAS006 229418
     C                             WExpRec = 'E' AND BYSL <> 'B' OR                           CAS006
     C                             WExpRec = 'R' AND BYSL <> 'S'                              CAS006
     C                   EVAL      WNotEffct = 'Y'                                            CAS006
     C                   ELSE                                                                 CAS006
     C**********         ADD       UPAMT         WAmount                                      CAS006
                                                                                              CAS006
      ** Accumulate the hedged percentage of the derivative                                   CAS006
                                                                                              CAS006
     C                   EVAL      WkAmnt = UPAMT * FSPCTG / 100                              CAS006
     C                   ADD       WkAmnt        WAmount                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      *EJECT***********************************************************                       CAS006
      *****************************************************************                       CAS006
      *****************************************************************                       CAS006
      ***SRFCTran*-*Subroutine*to*process*Hedge*Items*-*Forecast*******                       CAS006
      **************Transactions***************************************                       CAS006
      *****************************************************************                       CAS006
      ***Called*By:**Main*Processing***********************************                       CAS006
      *****************************************************************                       CAS006
      ***Calls****:**None**********************************************                       CAS006
      *****************************************************************                       CAS006
      *****************************************************************                       CAS006
      ****************************************************************                        CAS006
     C*****SRFCTran      BEGSR                                                                CAS006
      ****************************************************************                        CAS006
     C*****FSDLNO        CHAIN     ASFHTRL1                                                   CAS006
      ****************************************************************                        CAS006
     C**********         IF        %FOUND(ASFHTRL1)                                           CAS006
      ****************************************************************                        CAS006
      ***Retrieve*Maturity*Month**************************************                        CAS006
      ****************************************************************                        CAS006
     C**********         EVAL      PFInput = FSMDAT                                           CAS006
     C**********         EXSR      SRDate                                                     CAS006
     C**********         EVAL      WHDate = PAOutput                                          CAS006
      ****************************************************************                        CAS006
     C**********         IF        FSCCY <> WCurrency OR                                      CAS006
     C**********                   WMatMonth <> WHMonth                                       CAS006
     C**********                   OR CAS006 = 'Y' AND WMatYear <> WHYear                     CAS006
     C**********                   AND FSMODE <> 'GL'                                         CAS006
     C**********         EVAL      WEffect = 'Y'                                              CAS006
     C**********         EVAL      WNotEffct = 'Y'                                            CAS006
     C**********         ELSE                                                                 CAS006
     C**********         ADD       FSAMNT        WHAmount                                     CAS006
     C**********         ENDIF                                                                CAS006
     C**********         ENDIF                                                                CAS006
      ****************************************************************                        CAS006
     C**********         ENDSR                                                                CAS006
      ****************************************************************                        CAS006
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      *  SREffective - Subroutine to calculate Hedge Effectiveness of *
      *                Forecast Transactions                          *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
      *
     C     SREffective   BEGSR
 
      **  Retrieve Hedge Strategy details
 
     C     FSHGST        CHAIN     SDHGSTL1
 
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFile = 'SDHGSTL1'
     C                   EVAL      DBKEY = FSHGST
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  If there is a mismatch in the critical terms, flag hedge
      **  as ineffective.
 
     C**********         IF        WEffect = 'Y' OR WAmount <> WHAmount                       CAS006
     C**********         IF        WNotEffct = 'Y' OR WAmount <> WHAmount              CAS006 229418
     C                   IF        WNotEffct = 'Y' OR WAmount > WHAmount                      229418
     C                   EVAL      FSRECI = 'X'
     C                   EVAL      FSHEFP = *ZEROS
 
     C                   ELSE
 
      ** Set Next Assessment Date
 
     C                   Z-ADD     100           FSHEFP
     C                   EVAL      PFrequency = FSEFFQ
     C                   EVAL      PDayNum = FSEFFD
     C                   EVAL      PDays = 31
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PFrequency
     C                   PARM                    PDayNum
     C                   PARM                    PBankCurr
     C                   PARM      *BLANKS       PLoc                                       AR702741
     C                   PARM                    PDays
     C                   PARM                    PDateformat
     C     SDGELR        PARM                    SDGELR
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFile = 'ZFREQB'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      PDayNum       FSEFFD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   Z-ADD     WAmount       FSDAMT
     C                   Z-ADD     *ZERO         FSDUPL
     C                   Z-ADD     WHAmount      FSHAMT
     C                   Z-ADD     *ZERO         FSHUPL
     C                   Z-ADD     *ZERO         FSDYPL
     C                   Z-ADD     *ZERO         FSHYPL
      *
     C                   MOVE      WCurrency     FSCYCD
     C                   Z-ADD     WRunDay       FSLASD
                                                                                              CAS006
      ** Set Rate indicator to 'B' so that UNRL for FRA will always be taken                  CAS006
      ** from the net-treasury-rate file                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      FSRIND = 'B'                                               CAS006
     C                   ENDIF                                                                CAS006
 
     C                   UPDATE    ASHGLKD0
 
      ** If CAS006 is on, set Unrealised Profit/Loss in ASFHTRPD to zero.                     CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRInitURPL                                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR
 
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRInitURPL - Set FSURPL in ASFHTRPD to zero.                 *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRInitURPL    BEGSR                                                                CAS006
                                                                                              CAS006
     C                   EVAL      KHedgeInd = 'H'                                            CAS006
                                                                                              CAS006
     C     KHedgeTran    CHAIN     ASHTRNL1                           26                      CAS006
                                                                                              CAS006
     C                   DOW       *IN26 = *OFF                                               CAS006
                                                                                              CAS006
     C*****FSDLNO        CHAIN     ASFHTRL1                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                                                   CLE148
     C                   EVAL      FSURPL = *ZERO                                             CAS006
     C                   UPDATE    ASFHTRD0                                                   CAS006
                                                                                              CAS006
     C     KHedgeTran    READE     ASHTRNL1                               26                  CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate - Subroutine to call ZDATE2                            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDate        BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PFInput
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNOutput
     C                   PARM      *BLANKS       PAOutput
 
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
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WRunDay = BJRDNB
     C                   EVAL      PDateFormat = BJDFIN
     C                   EVAL      PBankCurr = BJCYCD
 
      ** Key Lists
 
     C     KHedgeTran    KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    KHedgeInd
 
      ** Determine if Hedge Accounting Phase B (CAS006) is installed.                         CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtrnCode                                    CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtrnCode = *BLANKS                                        CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
                                                                                              CAS006
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBASE = 5                                                  CAS006
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Access the Hedging ICD                                                               229418
                                                                                              229418
     C                   CALLB     'AOHEDGR0'                                                 229418
     C                   PARM      *BLANKS       PRtcd                                        229418
     C                   PARM      '*FIRST '     POption                                      229418
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        229418
                                                                                              229418
     C                   IF        PRtcd <> *Blanks                                           229418
     C     *LOCK         IN        LDA                                                        229418
     C                   EVAL      DBFILE =  'SDHEDGPD'                                       229418
     C                   EVAL      DBKEY  =  '*CALL'                                          229418
     C                   EVAL      DBASE  =  7                                                229418
     C                   OUT       LDA                                                        229418
     C                   EXSR      *PSSR                                                      229418
     C                   ENDIF                                                                229418
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
