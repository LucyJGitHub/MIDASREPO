     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge expiry for forecast transactions')      *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000006 - Hedge Expiry for Forecast Transactions            *
      *                                                               *
      *  Function:  This module expires cash flow hedges of Forecast  *
      *             Transactions if any of the following happens:     *
      *             a) The hedge linkage reaches its end date.        *
      *                Record Id will be set to 'E' for expired.      *
      *             b) All of the hedge components(i.e. forward       *
      *                commitments and forecast transactions) mature. *
      *                Record Id of the forecast transaction is set   *
      *                to 'M'.                                        *
      *                                                               *
      *  Component of: AS000006                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
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
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         Record Found Indicator (ASHTRNL1)               *
      *                                                               *
      *    LR         Last record indicator (program termination)     *
      *    U7 and U8  DB error processing indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMaturFH - Flags Forecast Transactions as Matured if        *
      *              Maturity Date is less than or equal to Rundate   *
      *  SRLstMDAT - Defines the Maturity Date of the Hedge Component,*
      *              which is the Last One to Mature                  *
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
     FASHGLKL0  UF   E           K DISK
      ** Midas AS Hedge Linkage File Update by Hedge ID
 
     F***ASHTRNL9  IF   E           K DISK                                                    CAS006
     FASHTRNL9  IF   E           K DISK    PREFIX(HT)                                         CAS006
      ** Midas AS Hedge Transaction File Retrieval by Hedge ID
                                                                                              CAS006
     FASHTRNLF  IF   E           K DISK    PREFIX(HF)                                         CAS006
     F                                     RENAME(ASHTRND0:ASHTRNDF)                          CAS006
      ** Midas AS Hedge Transaction File Retrieval by Module ID/HedgeId/HedgeInd              CAS006
 
     F***ASHTRNL1  IF   E           K DISK                                                    CAS006
     FASHTRNL1  IF   E           K DISK    PREFIX(HT)                                         CAS006
     F                                     RENAME(ASHTRND0:ASHTRND1)
      ** Midas AS Hedge Transaction File Retrieval by Hedge ID/Hedge
      ** Indicator
 
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F**********                           IGNORE(DEALSDCF)                                   CAS006
     F                                     IGNORE(DEALSDEF)                                   CAS006
     F                                     IGNORE(DEALSDFF)
     F**********                           IGNORE(DEALSDGF)                                   CAS006
      ** Midas DL Deals File
                                                                                              CAS006
     FCLOAN     IF   E           K DISK                                                       CAS006
     F                                     IGNORE(CLOANHHF)                                   CAS006
     F                                     IGNORE(CLOANCKF)                                   CAS006
     F                                     IGNORE(CLOANZ1F)                                   CAS006
      ** Midas LE Loans File                                                                  CAS006
                                                                                              CAS006
     FGLJENPL0  IF   E           K DISK                                                       CAS006
      ** Midas GL Journal Entry File                                                          CAS006
 
     F***ASFHTRL1  UF   E           K DISK                                                    CAS006
     FASFHTRL1  UF   E           K DISK    PREFIX(FH)                                         CAS006
      ** Midas AS Forecast Transaction Details Master File Retrieval
      ** Index
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CAS006
      ** External DS for Switchable Features Details                                          CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(S)                        CAS006
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CAS006
      ** Journal Entry key fields DS                                                          CAS006
     D BatchDS         DS                                                                     CAS006
     D  KBatch                 1      6  0                                                    CAS006
     D  KBatchNo               1      3A                                                      CAS006
     D  KBatchItem             4      6  0                                                    CAS006
                                                                                              CAS006
      ** Date DS 1 (DDMMMYY)                                                                  CAS006
     D DateDS1         DS                                                                     CAS006
     D  WDay1                  1      2                                                       CAS006
     D  WMonthYr1              3      7                                                       CAS006
                                                                                              CAS006
      ** Date DS 2 (DDMMMYY)                                                                  CAS006
     D DateDS2         DS                                                                     CAS006
     D  WDay2                  1      2                                                       CAS006
     D  WMonthYr2              3      7                                                       CAS006
                                                                                              CAS006
      ** Date DS 3 (DDMMMYY)                                                                  CAS006
     D DateDS3         DS                                                                     CAS006
     D  WDay3                  1      2                                                       CAS006
     D  WMonthYr3              3      7                                                       CAS006
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for AOBANKR0
     D PRetrnCde       S              7A
     D POption         S              7A
 
      ** Fields used to define Key List for Midas AS Hedge Transaction File
      ** Retrieval
     D KAShedi         S              6S 0
     D KASdhin         S              1A
     D KASmodF         S              2A                                                      CAS006
     D KAShediF        S              6S 0                                                    CAS006
     D KASdhinF        S              1A                                                      CAS006
 
     D WFSmdat         S              5P 0
     D WRun            S              1A
                                                                                              CAS006
     D WValidURN       S              1A                                                      CAS006
     D WInEffect       S              1A                                                      CAS006
     D WFRALive        S              1A                                                      CAS006
     D KRCDT           S              1A                                                      CAS006
     D***KLOAN**         S              6  0                                           CAS006 CLE148
     D KLOAN           S              6A                                                      CLE148
     D CAS006          S              1                                                       CAS006
     D PSard           S              6A                                                      CAS006
     D PDatFmt         S              1A                                                      CAS006
     D PMDAT           S              5  0                                                    CAS006
     D PMDAT6N         S              6  0                                                    CAS006
     D PMDAT7A         S              7A                                                      CAS006
 
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
 
     C                   EXSR      SRMaturFH
 
      ** Read all hedges in the system.
 
     C                   READ      ASHGLKL0
 
      ** Do while not end of file
 
     C                   DOW       NOT %EOF(ASHGLKL0)
 
     C                   IF        FSRECI = 'D' or FSRECI = 'T'
 
      ** Check if hedging forecast transactions
 
     C                   EVAL      KAShedi = FSHEDI
     C                   EVAL      KASdhin = 'H'
 
     C     KHTRNL1       CHAIN     ASHTRNL1                           25
 
     C**********         IF        *IN25 = *OFF and FSMOD = 'FH'                              CAS006
     C                   IF        *IN25 = *OFF AND HTFSMOD = 'FH'                            CAS006
                                                                                              CAS006
      ** Check if the forecast transaction has a valid underlying reference                   CAS006
      ** number                                                                               CAS006
                                                                                              CAS006
     C                   EVAL      WValidURN = 'N'                                            CAS006
     C                   EVAL      WInEffect = 'N'                                            CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRFHChk                                                    CAS006
     C                   ENDIF                                                                CAS006
 
      ** If end date is less than or equal to rundate
 
     C                   IF        FSENDT <= BJRDNB
 
     C                   IF        (CAS006 ='N') OR (WValidURN = 'Y')                         CAS006
     C                   EVAL      FSRECI = 'E'
     C                   EVAL      FSCHTP = 'E'
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WInEffect = 'Y'                                            CAS006
     C                   EVAL      FSRECI = 'X'                                               CAS006
     C                   EVAL      FSCHTP = 'X'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      FSLCD = BJRDNB
     C                   UPDATE    ASHGLKD0
 
     C                   ELSE
 
     C                   EXSR      SRLstMDAT
 
      ** Expire hedge if all components matured already.
 
     C                   IF        WFSmdat <= BJRDNB
     C                   IF        (CAS006 ='N') OR (WValidURN = 'Y')                         CAS006
     C                   EVAL      FSRECI = 'E'
     C                   EVAL      FSCHTP = 'E'
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WInEffect = 'Y'                                            CAS006
     C                   EVAL      FSRECI = 'X'                                               CAS006
     C                   EVAL      FSCHTP = 'X'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      FSLCD = BJRDNB
     C                   UPDATE    ASHGLKD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record on LF/ASHGLKL0
 
     C                   READ      ASHGLKL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMaturFH - Flags Forecast Transactions as Matured if        *
      *              Maturity Date is less than or equal to Rundate   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRMaturFH     BEGSR
 
     C                   READ      ASFHTRL1                               70
 
      ** Do while not end of file
 
     C                   DOW       NOT %EOF(ASFHTRL1)
                                                                                              CAS006
      ** Check for a valid underlying reference number                                        CAS006
                                                                                              CAS006
     C                   EVAL      WValidURN = 'N'                                            CAS006
                                                                                              CAS006
     C                   IF        (CAS006 = 'Y') AND (FHFSMDAT <= BJRDNB)                    CAS006
     C                   EXSR      SRUndRefChk                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** When Hedge Phase B (CAS006) is installed, forecast transaction                       CAS006
      ** will only be set to matured if a valid underlying reference has                      CAS006
      ** been entered                                                                         CAS006
 
     C**********         IF        FSRECI = 'D' and FSMDAT <= BJRDNB                          CAS006
     C                   IF        FHFSRECI = 'D' AND FHFSMDAT <= BJRDNB AND                  CAS006
     C                             CAS006 = 'N' OR                                            CAS006
     C                             FHFSRECI = 'D' AND WValidURN = 'Y'                         CAS006
     C**********         EVAL      FSRECI = 'M'                                               CAS006
     C                   EVAL      FHFSRECI = 'M'                                             CAS006
     C                   UPDATE    ASFHTRD0
     C                   ENDIF
      *
     C                   READ      ASFHTRL1
     C                   ENDDO
 
     C                   ENDSR
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRUndRefChk - Checks if the underlying reference number is   *                       CAS006
      *                valid                                          *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRUndRefChk   BEGSR                                                                CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
     C                   WHEN      FHFSMOD = 'DL'                                             CAS006
                                                                                              CAS006
     C**********         IF        FHFSUREF <> 0                                       CAS006 CLE148
     C*****FHFSUREF      CHAIN     DEALS                              30               CAS006 CLE148
     C                   IF        FHFSUREF <> *BLANKS                                        CLE148
     C                   MOVEL     FHFSUREF      FSUREF2           6 0                        CLE148
     C     FSUREF2       CHAIN     DEALS                              30                      CLE148
     C                   IF        (*IN30 = *OFF) AND (FHFSSUBT = DTYP)                       CAS006
     C                   EVAL      WValidURN = 'Y'                                            CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WValidURN = 'N'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   WHEN      FHFSMOD = 'LE'                                             CAS006
                                                                                              CAS006
     C**********         IF        FHFSUREF <> 0                                       CAS006 CLE148
     C                   IF        FHFSUREF <> *BLANKS                                        CLE148
     C                   EVAL      KRCDT = 'A'                                                CAS006
     C                   EVAL      KLOAN = FHFSUREF                                           CAS006
     C     KLOANList     CHAIN     CLOAN                              30                      CAS006
     C                   IF        (*IN30 = *OFF) AND (FHFSSUBT = LTYP)                       CAS006
     C                   EVAL      WValidURN = 'Y'                                            CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WValidURN = 'N'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   WHEN      FHFSMOD = 'GL'                                             CAS006
                                                                                              CAS006
     C**********         IF        FHFSUREF <> 0                                       CAS006 CLE148
     C**********         EVAL      KBatch = FHFSUREF                                   CAS006 CLE148
     C                   IF        FHFSUREF <> *BLANKS                                        CLE148
     C                   MOVEL     FHFSUREF      FSUREF2                                      CLE148
     C                   EVAL      KBatch = FSUREF2                                           CLE148
     C     KJENTList     CHAIN     GLJENPL0                           30                      CAS006
     C                   IF        *IN30 = *OFF                                               CAS006
     C                   EVAL      WValidURN = 'Y'                                            CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WValidURN = 'N'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRFHChk - Checks if the forecast transaction has a valid     *                       CAS006
      *            underlying reference number                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRFHChk       BEGSR                                                                CAS006
                                                                                              CAS006
      ** Initialise workfields and data structures                                            CAS006
                                                                                              CAS006
     C                   EVAL      WFRALive= 'N'                                              CAS006
                                                                                              CAS006
     C                   EVAL      DateDS1 = *BLANKS                                          CAS006
     C                   EVAL      DateDS2 = *BLANKS                                          CAS006
     C                   EVAL      DateDS3 = *BLANKS                                          CAS006
                                                                                              CAS006
     C                   EVAL      KASmodF = 'FH'                                             CAS006
     C                   EVAL      KAShediF = FSHEDI                                          CAS006
     C                   EVAL      KASdhinF = 'H'                                             CAS006
                                                                                              CAS006
      ** Retrieve each hedge transaction for this linkage and check against                   CAS006
      ** the forecast transaction                                                             CAS006
                                                                                              CAS006
     C     KHTRNLF       SETLL     ASHTRNLF                                                   CAS006
     C     KHTRNLF       READE     ASHTRNLF                               30                  CAS006
                                                                                              CAS006
     C                   DOW       (*IN30 = *OFF) AND (WInEffect = 'N')                       CAS006
                                                                                              CAS006
      ** Get corresponding forecast transaction                                               CAS006
                                                                                              CAS006
     C*****HFFSDLNO      CHAIN     ASFHTRL1                           31               CAS006 CLE148
     C                   MOVE      HFFSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           31                      CLE148
                                                                                              CAS006
     C                   IF        *IN31 = *OFF                                               CAS006
                                                                                              CAS006
      ** Validate against underlying reference number                                         CAS006
                                                                                              CAS006
     C                   EXSR      SRUndRefChk                                                CAS006
                                                                                              CAS006
      ** Set hedge to 'Ineffective' if underlying reference is not valid                      CAS006
                                                                                              CAS006
     C                   IF        WValidURN = 'N'                                            CAS006
     C                   EVAL      WInEffect = 'Y'                                            CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WValidURN = 'Y'                                            CAS006
                                                                                              CAS006
      ** Convert maturity day number to DDMMMYY (Underlying Ref Number)                       CAS006
                                                                                              CAS006
     C                   IF        (FHFSMOD = 'DL') OR (FHFSMOD = 'LE')                       CAS006
                                                                                              CAS006
     C                   CALLB     'ZDATE2'                                                   CAS006
     C                   PARM      MDAT          PMDAT                                        CAS006
     C                   PARM      BJDFIN        PDATFMT                                      CAS006
     C                   PARM      *ZERO         PMDAT6N                                      CAS006
     C                   PARM      *BLANK        PMDAT7A                                      CAS006
                                                                                              CAS006
     C                   EVAL      DateDS1 = PMDAT7A                                          CAS006
                                                                                              CAS006
      ** Check the maturity of the underlying reference                                       CAS006
                                                                                              CAS006
     C                   IF        DateDS2 = *BLANK                                           CAS006
     C                   EVAL      DateDS2 = DateDS1                                          CAS006
     C                   ELSE                                                                 CAS006
     C                   IF        WMonthYr1 <> WMonthYr2                                     CAS006
     C                   EVAL      WInEffect = 'Y'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Get next hedge transaction                                                           CAS006
                                                                                              CAS006
     C     KHTRNLF       READE     ASHTRNLF                               30                  CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** Access the derivative hedge transaction to check if the                              CAS006
      ** FRA is already matured or deleted and maturity of each derivative                    CAS006
      ** and underlying reference fall on the same month and year                             CAS006
                                                                                              CAS006
     C                   IF        DateDS2 <> *BLANK                                          CAS006
     C                   EVAL      KAShedi = FSHEDI                                           CAS006
     C                   EVAL      KASdhin = 'D'                                              CAS006
                                                                                              CAS006
     C     KHTRNL1       SETLL     ASHTRNL1                                                   CAS006
     C     KHTRNL1       READE     ASHTRNL1                               32                  CAS006
                                                                                              CAS006
     C                   DOW       *IN32 = *OFF                                               CAS006
                                                                                              CAS006
      ** Set live FRA record work field to 'Y' if the FRA                                     CAS006
      ** deal is not yet matured or not yet deleted                                           CAS006
                                                                                              CAS006
     C*****HTFSDLNO      CHAIN     DEALSDGF                           33               CAS006 CLE148
     C                   MOVE      HTFSDLNO      FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALSDGF                           33                      CLE148
                                                                                              CAS006
     C                   IF        (*IN33 = *OFF) AND (DTYP = 'FR')                           CAS006
                                                                                              CAS006
      ** Convert maturity day number to DDMMMYY (FRA deal)                                    CAS006
                                                                                              CAS006
     C                   CALLB     'ZDATE2'                                                   CAS006
     C                   PARM      MDAT          PMDAT                                        CAS006
     C                   PARM      BJDFIN        PDATFMT                                      CAS006
     C                   PARM      *ZERO         PMDAT6N                                      CAS006
     C                   PARM      *BLANK        PMDAT7A                                      CAS006
                                                                                              CAS006
     C                   EVAL      DateDS3 = PMDAT7A                                          CAS006
                                                                                              CAS006
     C                   IF        (MDAT > BJRDNB) AND (RECI = 'D')                           CAS006
     C                   EVAL      WFRALive = 'Y'                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Set hedge to 'Ineffective' if maturity dates do not fall to the same                 CAS006
      ** month and year for FRA and Underlying Reference                                      CAS006
                                                                                              CAS006
     C                   IF        WMonthYr1 <> WMonthYr3                                     CAS006
     C                   EVAL      WInEffect = 'Y'                                            CAS006
     C                   LEAVE                                                                CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Get next derivative                                                                  CAS006
                                                                                              CAS006
     C     KHTRNL1       READE     ASHTRNL1                               32                  CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   IF        (WValidURN = 'Y') AND (WFRALive = 'Y')                     CAS006
     C                   EVAL      WValidURN = 'N'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLstMDAT - Defines the Maturity Date of the Hedge Component,*
      *              which is the Last One to Mature                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLstMDAT     BEGSR
 
     C                   EVAL      WFSmdat = *ZERO
 
      **  Read all linked transactions
 
     C     FSHEDI        CHAIN     ASHTRNL9                           25
 
     C                   DOW       *IN25 = *OFF
 
      ** Retrieve transaction
 
     C                   SELECT
 
      ** Forecast Transactions
 
     C**********         WHEN      FSMOD = 'FH'                                               CAS006
     C                   WHEN      HTFSMOD = 'FH'                                             CAS006
 
      ** Validate against Forecast Transactions
 
     C*****FSDLNO        CHAIN     ASFHTRL1                                                   CAS006
     C*****HTFSDLNO      CHAIN     ASFHTRL1                                            CAS006 CLE148
     C                   MOVE      HTFSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                                                   CLE148
     C**********         IF        %FOUND(ASFHTRL1) and FSMDAT > WFSmdat                      CAS006
     C**********         EVAL      WFSmdat = FSMDAT                                           CAS006
     C                   IF        %FOUND(ASFHTRL1) AND FHFSMDAT > WFSmdat                    CAS006
     C                   EVAL      WFSmdat = FHFSMDAT                                         CAS006
     C                   ENDIF
 
      ** Foreign Exchange Deals
 
     C*********          WHEN      FSMOD = 'DL'                                               CAS006
     C                   WHEN      HTFSMOD = 'DL'                                             CAS006
 
     C*****FSDLNO        CHAIN     DEALS                                                      CAS006
     C*****HTFSDLNO      CHAIN     DEALS                                               CAS006 CLE148
     C                   MOVE      HTFSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALS                                                      CLE148
     C                   IF        %FOUND(DEALS) and VDAT > WFSmdat
     C                             AND RCDT = 'B' OR                                          CAS006
     C                             %FOUND(DEALS) and MDAT > WFSmdat                           CAS006
     C                             AND RCDT = 'G'                                             CAS006
     C                   IF        RCDT = 'C'                                                 CAS006
     C                   EVAL      WFSmdat = VDAT
     C                   ELSE                                                                 CAS006
     C                   EVAL      WFSmdat = MDAT                                             CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF
 
     C                   ENDSL
 
     C     FSHEDI        READE     ASHTRNL9                               25
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, *PSSR                                        *
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
     C                   EVAL      DBASE = 01
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS006
      ** Access SAR details file to determine if Hedge Accounting Phase B is                  CAS006
      ** installed                                                                            CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetrnCde                                    CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
      ** Database error                                                                       CAS006
                                                                                              CAS006
     C                   IF        (PRetrnCde <> *BLANKS) AND                                 CAS006
     C                             (PRetrnCde <> '*NRF   ')                                   CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 2                                                  CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CAS006
     C     PRetrnCde     IFEQ      *BLANKS                                                    CAS006
     C                   MOVEL     'Y'           CAS006                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'N'           CAS006                                       CAS006
     C                   ENDIF                                                                CAS006
 
      ** Key List for Midas AS Hedge Transaction File Retrieval by
      ** Hedge ID/Hedge Indicator
 
     C     KHTRNL1       KLIST
     C                   KFLD                    KAShedi
     C                   KFLD                    KASdhin
                                                                                              CAS006
      ** Key List for Midas AS Hedge Transaction File Retrieval by                            CAS006
      ** Module/Hedge ID/Hedge Indicator                                                      CAS006
                                                                                              CAS006
     C     KHTRNLF       KLIST                                                                CAS006
     C                   KFLD                    KASmodF                                      CAS006
     C                   KFLD                    KAShediF                                     CAS006
     C                   KFLD                    KASdhinF                                     CAS006
                                                                                              CAS006
     C     KLOANList     KLIST                                                                CAS006
     C                   KFLD                    KLOAN                                        CAS006
     C                   KFLD                    KRCDT                                        CAS006
                                                                                              CAS006
     C     KJENTList     KLIST                                                                CAS006
     C                   KFLD                    KBatchNo                                     CAS006
     C                   KFLD                    KBatchItem                                   CAS006
 
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
      * Called by: Main Processing, SRAccuAmt, SRCalcuHe, *INZSR          *
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
