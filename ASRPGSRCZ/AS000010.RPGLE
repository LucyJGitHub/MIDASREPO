     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge DL A/C Key Generation Program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000010 - Hedge DL Account Key Generation Program           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSW212             Date 03May12               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 229304             Date 18Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9559            Date 10Dec05               *
      *                 CAS009             Date 16May05               *
      *                 CDL038             Date 10May05               *
      *                 228259             Date 07Jul04               *
      *                 225301             Date 27Feb04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 221416             Date 17Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004  *CREATE    Date 26Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  229304 - Incorrect details for branch.                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9559  - Deletion of hedge containing part of an IRS causes*
      *           incorrect accounting for hedge containing remaining *
      *           part                                                *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  228259 - DB Error due to non-existent forecast               *
      *  225301 - Wrong reversal amounts posted.                      *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  221416 - Extra reversals posted due to ineffective hedge     *
      *           reactivated.                                        *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Account Key Summary Indicator                   *
      *    03         Multi-branching Indicator                       *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcDB    - Process records from DEALSDB                    *
      * SRProcCD    - Process records from DEALSDC and DEALSDD        *
      * SRProcDG    - Process records from DEALSDG                    *
      * SRDeleteDB  - Deleted Transactions from DEALSDB               *
      * SRDeleteCD  - Deleted Transactions from DEALSDC/DEALSDD       *
      * SRDeleteDG  - Deleted Transactions from DEALSDG               *
      * SRLiveHdgDB - Live Transactions from DEASLDB                  *
      * SRLiveHdgCD - Live Transactions from DEASLDC/DEALSDD          *
      * SRLiveHdgDG - Live Transactions from DEASLDG                  *
      * SRDelHdgDB  - Generate Deletion Posting Reversal for DEALSDB  *
      * SRDelHdgCD  - Generate Deletion Posting Reversal for DEALSDC  *
      *               and DEALSDD                                     *
      * SRDelHdgDG  - Generate Deletion Posting Reversal for DEALSDG  *
      * SRRevPostDB - Generate a reversal posting for the remainder   *
      *               of Unrealized P/L posted not yet reversed       *
      * SRRevPostCD - Generate a reversal posting for the remainder   *
      *               of Unrealized P/L posted not yet reversed       *
      * SRRevPostDG - Generate a reversal posting for the remainder   *
      *               of Unrealized P/L posted not yet reversed       *
      * SRHedgeDB   - Generate Hedge Account Keys for DEALSDB         *
      * SRHedgeCD   - Generate Hedge Account Keys for DEALSDC/DEALSDD *
      * SRHedgeDG   - Generate Hedge Account Keys for DEALSDG         *
      * SRLiveTran  - Common Routines for Live Transactions           *
      * SRGenKeyEFV - Generate Account Key for Effective Fair Value   *
      * SRGenKeyIFV - Generate Account Key for Ineffective Fair Value *
      * SRGenKeyECF - Generate Account Key for Effective Cash Flow    *
      * SRGenKeyICF - Generate Account Key for Ineffective Cash Flow  *
      * SRGenKeyTFV - Generate Account Key for Fair Value in Trading  *                       CAS005
      *               Status                                          *                       CAS005
      * SRGenKeyTCF - Generate Account Key for Cash Flow in Trading   *                       CAS005
      *               Status                                          *                       CAS005
      * SRWrite     - Write details to PF/DKEYSDP                     *
      * SRReport    - Write report details                            *
      * SRSumAkey   - Account Key Summary                             *
      * SRUpdTrl    - Update Trailer File                             *
      * SREndRep    - Write the End of the Report                     *
      * SRBranch    - Acess Branch Details                            *
      * SRAudit     - Print Audit Report                              *
      * GLZADD      - Add an amount to the total                      *
      * GLZSUM      - Carry out the additon for subroutine            *
      * SRChkRCF    - Ensure spool file recorded by RCF               *
      * SRChkRCFA   - Ensure Audit spool file recorded by RCF         *
      * SRInitEWV   - Initialise Effective Work Variables             *
      * SRInitIWV   - Initialise Ineffective Work Variables           *
      * SRInitTWV   - Initialise Trading-Status Work Variables        *                       CAS005
      *                                                               *
      * *INZSR - Initialise                                           *
      * *PSSR - Error processing                                      *
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
 
      ** Midas DL Deals File
     FDLDLHGL1  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas DL Money Market Transactions by DLNO
     FDLDLDCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDCF:DEALSDCC)
     F                                     PREFIX(C)
 
      ** Midas FX Deals by DLNO
     FDLDLDBL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:DEALSDBC)
     F                                     PREFIX(B)
 
      ** Midas AS Hedge Transaction File Retrieval
     FASHTRNLA  UF   E           K DISK    INFSR(*PSSR)
                                                                                              CAS006
      ** Midas AS Hedge Transaction File Retrieval                                            CAS006
     F***ASHTRNLH  IF   E           K DISK    INFSR(*PSSR)                             CAS006 228259
     F**********                           RENAME(ASHTRND0:ASHTRNDH)                   CAS006 228259
     FASHTRNLI  IF   E           K DISK    INFSR(*PSSR)                                       228259
     F                                     RENAME(ASHTRND0:ASHTRNDI)                          228259
     F                                     PREFIX(HH)                                         CAS006
 
      ** Forecast transaction file retrieval index                                            CAS006
     FASFHTRL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(FH)                                         CAS006
                                                                                              CAS006
      ** Midas AS Hedge Linkage File Update by Hedge ID
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HL:2)
 
      ** Midas SD Hedge Strategy by Shortname
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SD:2)
 
      ** Midas DL Deals Generated Account Keys - Detail
     FDKEYSDP   O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(DK)
 
      ** Midas DL Deals Generated Account Keys - Trailer
     FDKEYSZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DZ)
 
      ** AS Hedge DL A/C Key Generation Detail Report
     FAS000010P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN01)
 
      ** AS Hedge DL A/C Key Generation Audit Report
     FAS000010AUO    E             PRINTER INFDS(SPOOLU)
 
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
 
      ** File Information Data Structure for AS000010P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS000010AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
                                                                                              CAS005
      ** External DS for Switchable Features File                                             CAS005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS005
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  GelrACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for Currency Code Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Account Key Data Structure
     D WkAKeyDS        DS
     D  WkBrca                 1      3
     D  WkBook                 4      5
     D  WkDtyp                 6      7
     D  WkDlst                 8      9
     D  WkCurr                10     12
     D  WkClas                13     16                                                       CDL038
 
      ** Arrays for Account Keys
     D AKY             S              1A   DIM(14)                                            CDL038
     D AKey            S              1A   DIM(16)                                            CDL038
     D AKeyEFV         S             16A   DIM(999)                                           CDL038
     D AKeyFV2         S             16A   DIM(999)                                           CDL038
     D AKeyECF         S             16A   DIM(999)                                           CDL038
     D AKeyCF2         S             16A   DIM(999)                                           CDL038
     D TAmtEFVL        S             13  0 DIM(999)                                           CDL038
     D TAmtFVL2        S             13  0 DIM(999)                                           CDL038
     D TAmtEFVP        S             13  0 DIM(999)                                           CDL038
     D TAmtFVP2        S             13  0 DIM(999)                                           CDL038
     D TAmtECFL        S             13  0 DIM(999)                                           CDL038
     D TAmtCFL2        S             13  0 DIM(999)                                           CDL038
     D TAmtECFP        S             13  0 DIM(999)                                           CDL038
     D TAmtCFP2        S             13  0 DIM(999)                                           CDL038
     D AKeyIFV         S             16A   DIM(999)                                           CDL038
     D AKeyICF         S             16A   DIM(999)                                           CDL038
                                                                                              CDL038
     D AKeyTFV         S             16A   DIM(999)                                           CDL038
     D AKeyTCF         S             16A   DIM(999)                                           CDL038
                                                                                              CDL038
     D TAmtIFVL        S             13  0 DIM(999)                                           CDL038
     D TAmtIFVP        S             13  0 DIM(999)                                           CDL038
     D TAmtICFL        S             13  0 DIM(999)                                           CDL038
     D TAmtICFP        S             13  0 DIM(999)                                           CDL038
                                                                                              CDL038
     D TAmtTFVL        S             13  0 DIM(999)                                           CDL038
     D TAmtTFVP        S             13  0 DIM(999)                                           CDL038
     D TAmtTCFL        S             13  0 DIM(999)                                           CDL038
     D TAmtTCFP        S             13  0 DIM(999)                                           CDL038
                                                                                              CDL038
     D*AKY*************S************* 1A   DIM(10)                                            CDL038
     D*AKey************S************* 1A   DIM(12)                                            CDL038
     D*AKeyEFV*********S*************12A   DIM(500)                                           CDL038
     D*AKeyFV2*********S*************12A   DIM(500)                                           CDL038
     D*AKeyECF*********S*************12A   DIM(500)                                           CDL038
     D*AKeyCF2*********S*************12A   DIM(500)                                           CDL038
     D*TAmtEFVL********S*************13  0 DIM(500)                                           CDL038
     D*TAmtFVL2********S*************13  0 DIM(500)                                           CDL038
     D*TAmtEFVP********S*************13  0 DIM(500)                                           CDL038
     D*TAmtFVP2********S*************13  0 DIM(500)                                           CDL038
     D*TAmtECFL********S*************13  0 DIM(500)                                           CDL038
     D*TAmtCFL2********S*************13  0 DIM(500)                                           CDL038
     D*TAmtECFP********S*************13  0 DIM(500)                                           CDL038
     D*TAmtCFP2********S*************13  0 DIM(500)                                           CDL038
     D*AKeyIFV*********S*************12A   DIM(500)                                           CDL038
     D*AKeyICF*********S*************12A   DIM(500)                                           CDL038
      *****************S*************                                                  CAS005 CDL038
     D*AKeyTFV*********S*************12A   DIM(500)                                    CAS005 CDL038
     D*AKeyTCF*********S*************12A   DIM(500)                                    CAS005 CDL038
      *****************S*************                                                  CAS005 CDL038
     D*TAmtIFVL********S*************13  0 DIM(500)                                           CDL038
     D*TAmtIFVP********S*************13  0 DIM(500)                                           CDL038
     D*TAmtICFL********S*************13  0 DIM(500)                                           CDL038
     D*TAmtICFP********S*************13  0 DIM(500)                                           CDL038
      *****************S*************                                                  CAS005 CDL038
     D*TAmtTFVL********S*************13  0 DIM(500)                                    CAS005 CDL038
     D*TAmtTFVP********S*************13  0 DIM(500)                                    CAS005 CDL038
     D*TAmtTCFL********S*************13  0 DIM(500)                                    CAS005 CDL038
     D*TAmtTCFP********S*************13  0 DIM(500)                                    CAS005 CDL038
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSEQ            S              5
     D PSENTY          S              3
     D PSFILE          S             10
     D PZSNMU          S              6  0
     D PZSERR          S              1
 
      ** Parameters for ZFRPED
     D PFLD15          S             15  0
     D PDECS           S              1  0
     D PECODE          S              1
     D POUT21          S             21
     D POUT22          S             22
     D POUT25          S             25
 
      ** Parameters for Access Objects
     D PRetCode        S              7
     D POption         S              7
     D PCurr           S              3
     D PBranch         S              3
     D PSard           S              6                                                       CAS005
 
     D CAS005          S              1                                                       CAS005
                                                                                              CAS005
     D CAS006          S              1                                                       CAS006
                                                                                              CAS006
      ** Fields used in GLZADD/GLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWk2           S              4  0
     D ZZWk3           S             15  0
     D ZZNEGD          S              5
 
     D WkNoRec         S              5  0
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
     D WkNoRecB        S              5  0
 
     D WkAmt           S             15  0
     D WkACSQ          S              2  0
     D WkEVCD          S              5  0
     D*WkAkey**********S*************10                                                       CDL038
     D WkAkey          S             14                                                       CDL038
     D*WkCNUM***       S              6  0                                                    CSD027
     D WkCNUM          S              6A                                                      CSD027
     D WkDLNO          S              6  0
     D ChkKey          S             16                                                       CDL038
     D*ChkKey**********S*************12                                                       CDL038
 
     D WRun            S              1
     D WkDelFlg        S              1
     D WkDHIN          S              1
     D WkFlInd         S              1
 
     D WkPAmtEFV       S             15  0
     D WkLAmtEFV       S             15  0
     D WkPAmtECF       S             15  0
     D WkLAmtECF       S             15  0
     D WkSumEFV        S             15  0
     D WkSumECF        S             15  0
     D WkFSEFUP        S                   LIKE(FSEFUP)
     D WkFSECUP        S                   LIKE(FSECUP)
     D WkPAmtIFV       S             15  0
     D WkLAmtIFV       S             15  0
     D WkPAmtICF       S             15  0
     D WkLAmtICF       S             15  0
                                                                                              CAS005
     D WkPAmtTFV       S             15  0                                                    CAS005
     D WkLAmtTFV       S             15  0                                                    CAS005
     D WkPAmtTCF       S             15  0                                                    CAS005
     D WkLAmtTCF       S             15  0                                                    CAS005
                                                                                              CAS005
     D WkSumIFV        S             15  0
     D WkSumICF        S             15  0
     D WkFSXFUP        S                   LIKE(FSXFUP)
     D WkFSXCUP        S                   LIKE(FSXCUP)
     D WkUNRL          S                   LIKE(FSURPL)
                                                                                              CAS005
     D WkSumTFV        S             15  0                                                    CAS005
     D WkSumTCF        S             15  0                                                    CAS005
     D WkFSTFUP        S                   LIKE(FSTFUP)                                       CAS005
     D WkFSTCUP        S                   LIKE(FSTCUP)                                       CAS005
 
      ** Index for Fair Value Hedges and Cash Flow Hedges
     D WEFV            S              3  0 INZ(0)
     D WFV2            S              3  0 INZ(0)
     D WECF            S              3  0 INZ(0)
     D WCF2            S              3  0 INZ(0)
     D WIFV            S              3  0 INZ(0)
     D WICF            S              3  0 INZ(0)
                                                                                              CAS005
     D WTFV            S              3  0 INZ(0)                                             CAS005
     D WTCF            S              3  0 INZ(0)                                             CAS005
 
     D Ex              S              3  0
     D Ix              S              3  0
 
      ** Key Fields
     D KMod            S              2
     D***KDeal**         S              6  0                                                  CLE148
     D KDeal           S              6A                                                      CLE148
 
     D KLNKDN          S              6  0
 
     D PrBRCA          S              3
 
     D ZDATE           S              6  0
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
 
      ** Read all records from Dealing File
 
     C                   READ      DLDLHGL1
 
      ** Check if End of file, produce audit report if end of file
      ** If not, ensure report spool file recorded by RCF
 
     C                   IF        %EOF(DLDLHGL1)
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EVAL      WkBRCA = BRCA
     C                   EVAL      PrBRCA = BRCA                                              229304
     C                   EXSR      SRBranch
     C                   EXSR      SRChkRCF
 
     C                   DOW       NOT %EOF(DLDLHGL1)
 
      ** Process each record
 
     C                   SELECT
     C                   WHEN      RCDT = 'B'
     C                   EXSR      SRProcDB
     C                   WHEN      RCDT = 'C' OR
     C                             RCDT = 'D'
     C                   EXSR      SRProcCD
     C                   WHEN      RCDT = 'G'
     C                   IF        DTYP = 'RS'
     C                             OR DTYP = 'RX' AND CAS005 = 'Y'                            CAS005
     C                             OR DTYP = 'FR' AND CAS006 = 'Y'                            CAS006
     C                   EXSR      SRProcDG
     C                   ENDIF
     C                   ENDSL
 
     C                   READ      DLDLHGL1
     C                   ENDDO
 
      ** Write end of report
 
     C                   IF        BKAKSI <> 'Y'
     C                   EXSR      SREndRep
     C                   ENDIF
 
      ** Update Trailer File
 
     C                   EXSR      SRUpdTrl
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcDB - Process records from DEALSDB                       *
      *                                                               *
      *****************************************************************
 
     C     SRProcDB      BEGSR
 
     C                   EXSR      SRInitEWV
     C                   EXSR      SRInitIWV
 
     C                   EVAL      WkFSEFUP = FSEFUP
     C                   EVAL      WkFSECUP = FSECUP
     C                   EVAL      WkFSXFUP = FSXFUP
     C                   EVAL      WkFSXCUP = FSXCUP
     C                   EVAL      WkACSQ = 01
     C                   EVAL      DKREVI = 0
     C**********         EVAL      KDeal = DLNO                                               CLE148
     C                   MOVEL     DLNO          KDeal                                        CLE148
 
     C     KTranF        CHAIN     ASHTRNLA
     C                   IF        NOT %FOUND(ASHTRNLA)
     C                   GOTO      EndSRDB
     C                   ELSE
     C                   EVAL      WkDHIN = FSDHIN
     C                   ENDIF
 
     C                   EVAL      KLNKDN = LNKDN
                                                                                              CAS006
     C*****FSHEDI        CHAIN     ASHTRNLH                                            CAS006 228259
     C     FSHEDI        CHAIN     ASHTRNLI                                                   228259
                                                                                              CAS006
      ** If linkage does not involved forecast transaction                                    CAS006
     C**********         IF        NOT %FOUND(ASHTRNLH)                                CAS006 228259
     C                   IF        NOT %FOUND(ASHTRNLI)                                       228259
 
      ** Access the hedged item of the derivative
     C                   IF        WkDHIN = 'D'
     C     KLNKDN        CHAIN     DLDLDBL1
     C                   IF        NOT %FOUND(DLDLDBL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DLDLDBL1'
     C                   MOVE      KLNKDN        DBKEY
     C                   EVAL      DBASE  =  013
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      KLNKDN = BLNKDN
     C                   ENDIF
     C                   ENDIF
 
      ** Access the money markey deals of the hedged item
     C     KLNKDN        CHAIN     DLDLDCL1
     C                   IF        NOT %FOUND(DLDLDCL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DLDLDCL1'
     C                   MOVE      KLNKDN        DBKEY
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CDTYP = 'IP' OR
     C                             CDTYP = 'TI' OR
     C                             CDTYP = 'CL' OR
     C                             CDTYP = 'DL' OR
     C                             CDTYP = 'FL' OR
     C                             CDTYP = 'DP' OR
     C                             CDTYP = 'LP'
 
     C                   EVAL      CCY = CCCY
     C                   IF        WkDHIN = 'H'
     C                   IF        CCCY = PUCY
     C                   EVAL      WkUNRL = FSURPL
     C                   ELSE
     C                   GOTO      EndSRDB
     C                   ENDIF
     C                   ELSE
     C                   IF        CCCY = SLCY
     C                   EVAL      WkUNRL = FSSUPL
     C                   ELSE
     C                   GOTO      EndSRDB
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CDTYP = 'IT' OR
     C                             CDTYP = 'TD' OR
     C                             CDTYP = 'CI' OR
     C                             CDTYP = 'CD' OR
     C                             CDTYP = 'FT' OR
     C                             CDTYP = 'DT' OR
     C                             CDTYP = 'LT'
 
     C                   EVAL      CCY = CCCY
     C                   IF        WkDHIN = 'H'
     C                   IF        CCCY = SLCY
     C                   EVAL      WkUNRL = FSSUPL
     C                   ELSE
     C                   GOTO      EndSRDB
     C                   ENDIF
     C                   ELSE
     C                   IF        CCCY = PUCY
     C                   EVAL      WkUNRL = FSURPL
     C                   ELSE
     C                   GOTO      EndSRDB
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   EXSR      SRForeTrn                                                  CAS006
     C                   ENDIF                                                                CAS006
 
      ** If Deal was deleted from the system, RECI <> 'D'
 
     C                   IF        RECI <> 'D'
 
     C                   EXSR      SRDeleteDB
 
     C                   ENDIF
 
      ** If Deal is a live transaction
 
     C                   IF        RECI = 'D'
 
     C                   EXSR      SRLiveTran
 
      ** Generate the Hedge Portion
 
     C                   EXSR      SRHedgeDB
 
     C                   ENDIF
 
      ** Update file
 
     C                   EVAL      FSEFUP = WkSumEFV
     C                   EVAL      FSECUP = WkSumECF
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
     C                   EVAL      FSXFUP = WkSumIFV
     C                   EVAL      FSXCUP = WkSumICF
     C                   ENDIF
 
     C                   UPDATE    DEALSDBF
 
     C     EndSRDB       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcCD - Process records from DEALSDC and DEALSDD           *
      *                                                               *
      *****************************************************************
 
     C     SRProcCD      BEGSR
 
     C                   EXSR      SRInitEWV
 
     C                   EVAL      WkFSEFUP = FSEFUP
     C                   EVAL      WkFSECUP = FSECUP
     C                   EVAL      DKREVI = 0
     C**********         EVAL      KDeal = DLNO                                               CLE148
     C                   MOVEL     DLNO          KDeal                                        CLE148
 
     C                   SELECT
     C                   WHEN      RCDT = 'C'
     C                   EVAL      WkACSQ = CDAS
     C                   WHEN      RCDT = 'D'
     C                   EVAL      WkACSQ = IDAS
     C                   ENDSL
 
      ** If Deal was deleted from the system, RECI <> 'D'
 
     C                   IF        RECI <> 'D'
 
     C                   EXSR      SRDeleteCD
 
     C                   ENDIF
 
      ** If Deal is a live transaction
 
     C                   IF        RECI = 'D'
 
     C                   EXSR      SRLiveTran
 
      ** Generate the Hedge Portion
 
     C                   EXSR      SRHedgeCD
 
     C                   ENDIF
 
      ** Update file
 
     C                   EVAL      FSEFUP = WkSumEFV
     C                   EVAL      FSECUP = WkSumECF
 
     C                   SELECT
     C                   WHEN      RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   WHEN      RCDT = 'D'
     C                   UPDATE    DEALSDDF
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcDG - Process records from DEALSDG                       *
      *                                                               *
      *****************************************************************
 
     C     SRProcDG      BEGSR
 
     C                   EXSR      SRInitEWV
     C                   EXSR      SRInitIWV
     C                   EXSR      SRInitTWV                                                  CAS005
 
     C                   EVAL      WkFSEFUP = FSEFUP
     C                   EVAL      WkFSECUP = FSECUP
     C                   EVAL      WkFSXFUP = FSXFUP
     C                   EVAL      WkFSXCUP = FSXCUP
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      WkFSTFUP = FSTFUP                                          CAS005
     C                   EVAL      WkFSTCUP = FSTCUP                                          CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        DTYP = 'RX'                                                CAS005
     C                   EVAL      CCY = BJCYCD                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CCY = UCUCY
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EVAL      DKREVI = 0
     C**********         EVAL      KDeal = DLNO                                               CLE148
     C                   MOVEL     DLNO          KDeal                                        CLE148
     C                   EVAL      WkACSQ = CDAS
 
      ** If Deal was deleted from the system, RECI <> 'D'
 
     C                   IF        RECI <> 'D'
 
     C                   EXSR      SRDeleteDG
 
     C                   ENDIF
 
      ** If Deal is a live transaction
 
     C                   IF        RECI = 'D'
 
     C                   EXSR      SRLiveTran
 
      ** Generate the Hedge Portion
 
     C                   EXSR      SRHedgeDG
 
     C                   ENDIF
 
      ** Update file
 
     C                   EVAL      FSEFUP = WkSumEFV
     C                   EVAL      FSECUP = WkSumECF
     C                   EVAL      FSXFUP = WkSumIFV
     C                   EVAL      FSXCUP = WkSumICF
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTFUP = WkSumTFV                                          CAS005
     C                   EVAL      FSTCUP = WkSumTCF                                          CAS005
     C                   ENDIF                                                                CAS005
 
     C                   UPDATE    DEALSDGF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeleteDB - Deleted Transactions from DEALSDB                *
      *                                                               *
      *****************************************************************
 
     C     SRDeleteDB    BEGSR
 
      ** Set on the reversal indicator
 
     C                   EVAL      DKREVI = 1
 
      ** Deal is a Hedged Item
 
     C                   IF        WkDHIN = 'H'
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSEFUP < 0
     C                   Z-SUB     WkFSEFUP      WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > 0
     C                   Z-ADD     WkFSEFUP      WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss in DEALSDB
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Lost in DEALSDB
 
     C                   EVAL      FSECUP = *ZEROS
 
     C                   ENDIF
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSEFUP < 0
     C                   Z-SUB     WkFSEFUP      WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > 0
     C                   Z-ADD     WkFSEFUP      WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss in DEALSDB
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate Ineffective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSXFUP < 0
     C                   Z-SUB     WkFSXFUP      WkLAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        WkFSXFUP > 0
     C                   Z-ADD     WkFSXFUP      WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ** Update the Ineffective Fair Value Hedge Unrealized Profit/Loss in DEALSDB
 
     C                   EVAL      FSXFUP = *ZEROS
 
     C                   ENDIF
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Lost in DEALSDB
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Lost in DEALSDB
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Generate Ineffective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSXCUP < 0
     C                   Z-SUB     WkFSXCUP      WkLAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        WkFSXCUP > 0
     C                   Z-ADD     WkFSXCUP      WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit Lost in DEALSDB
 
     C                   EVAL      FSXCUP = *ZEROS
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeleteCD - Deleted Transactions from DEALSDC/DEALSDD        *
      *                                                               *
      *****************************************************************
 
     C     SRDeleteCD    BEGSR
 
      ** Set on the reversal indicator
 
     C                   EVAL      DKREVI = 1
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSEFUP < 0
     C                   Z-SUB     WkFSEFUP      WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > 0
     C                   Z-ADD     WkFSEFUP      WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss in DEALSDC/DEALSDD
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Lost in DEALSDC/DEALSDD
 
     C                   EVAL      FSECUP = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeleteDG - Deleted Transactions from DEALSDG                *
      *                                                               *
      *****************************************************************
 
     C     SRDeleteDG    BEGSR
 
      ** Set on the reversal indicator
 
     C                   EVAL      DKREVI = 1
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSEFUP < 0
     C                   Z-SUB     WkFSEFUP      WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > 0
     C                   Z-ADD     WkFSEFUP      WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss in DEALSDG
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate Ineffective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSXFUP < 0
     C                   Z-SUB     WkFSXFUP      WkLAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        WkFSXFUP > 0
     C                   Z-ADD     WkFSXFUP      WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ** Update the Ineffective Fair Value Hedge Unrealized Profit/Loss in DEALSDG
 
     C                   EVAL      FSXFUP = *ZEROS
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Lost in DEALSDG
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Generate Ineffective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a positive amount
 
     C                   IF        WkFSXCUP < 0
     C                   Z-SUB     WkFSXCUP      WkLAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        WkFSXCUP > 0
     C                   Z-ADD     WkFSXCUP      WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit Lost in DEALSDG
 
     C                   EVAL      FSXCUP = *ZEROS
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      ** Generate Fair Value Hedge in Trading Status Unrealized Profit/Loss Posted            CAS005
      ** account key with a positive amount                                                   CAS005
                                                                                              CAS005
     C                   IF        WkFSTFUP < 0                                               CAS005
     C                   Z-SUB     WkFSTFUP      WkLAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkFSTFUP > 0                                               CAS005
     C                   Z-ADD     WkFSTFUP      WkPAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Update the Fair Value Hedge in Trading Status Unrealised Profit/Loss                 CAS005
      ** Posted in DEALSDG                                                                    CAS005
                                                                                              CAS005
     C                   EVAL      FSTFUP = *ZEROS                                            CAS005
                                                                                              CAS005
      ** Generate Cash Flow Hedge in Trading Status Unrealized Profit/Loss Posted             CAS005
      ** account key with a positive amount                                                   CAS005
                                                                                              CAS005
     C                   IF        WkFSTCUP < 0                                               CAS005
     C                   Z-SUB     WkFSTCUP      WkLAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkFSTCUP > 0                                               CAS005
     C                   Z-ADD     WkFSTCUP      WkPAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Update the Cash Flow Hedge in Trading Status Unrealised Profit/Loss                  CAS005
      ** Posted in DEALSDG                                                                    CAS005
                                                                                              CAS005
     C                   EVAL      FSTCUP = *ZEROS                                            CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLiveHdgDB - Live Transactions from DEALSDB                  *
      *                                                               *
      *****************************************************************
 
     C     SRLiveHdgDB   BEGSR
 
      ** Deal is a Hedge item
 
     C                   IF        WkDHIN = 'H'
 
     C                   EVAL      DKREVI = 0
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSEFUP < 0                                               225301
     C**********         Z-ADD     WkFSEFUP      WkLAmtEFV                                    225301
     C                   IF        FSEFVP < 0                                                 225301
     C                   Z-ADD     FSEFVP        WkLAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C**********         IF        WkFSEFUP > 0                                               225301
     C**********         Z-SUB     WkFSEFUP      WkPAmtEFV                                    225301
     C                   IF        FSEFVP > 0                                                 225301
     C                   Z-SUB     FSEFVP        WkPAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*DEALSDB              225301
      **********                                                                              225301
     C**********         EVAL      FSEFUP = *ZEROS                                            225301
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSECUP < 0                                               225301
     C**********         Z-ADD     WkFSECUP      WkLAmtECF                                    225301
     C                   IF        FSHECP < 0                                                 225301
     C                   Z-ADD     FSHECP        WkLAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C**********         IF        WkFSECUP > 0                                               225301
     C**********         Z-SUB     WkFSECUP      WkPAmtECF                                    225301
     C                   IF        FSHECP > 0                                                 225301
     C                   Z-SUB     FSHECP        WkPAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*DEALSDB               225301
      **********                                                                              225301
     C**********         EVAL      FSECUP = *ZEROS                                            225301
 
     C                   ENDIF
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
     C                   EVAL      DKREVI = 0
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSEFUP < 0                                               225301
     C**********         Z-ADD     WkFSEFUP      WkLAmtEFV                                    225301
     C                   IF        FSEFVP < 0                                                 225301
     C                   Z-ADD     FSEFVP        WkLAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C**********         IF        WkFSEFUP > 0                                               225301
     C**********         Z-SUB     WkFSEFUP      WkPAmtEFV                                    225301
     C                   IF        FSEFVP > 0                                                 225301
     C                   Z-SUB     FSEFVP        WkPAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*DEALSDB              225301
      **********                                                                              225301
     C**********         EVAL      FSEFUP = *ZEROS                                            225301
 
      ** Generate Ineffective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSXFUP < 0                                               225301
     C**********         Z-ADD     WkFSXFUP      WkLAmtIFV                                    225301
     C                   IF        FSHXFP < 0                                                 225301
     C                   Z-ADD     FSHXFP        WkLAmtIFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C**********         IF        WkFSXFUP > 0                                               225301
     C**********         Z-SUB     WkFSXFUP      WkPAmtIFV                                    225301
     C                   IF        FSHXFP > 0                                                 225301
     C                   Z-SUB     FSHXFP        WkPAmtIFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ***Update*the*Ineffective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*DEALSDB            225301
      **********                                                                              225301
     C**********         EVAL      FSXFUP = *ZEROS                                            225301
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSECUP < 0                                               225301
     C**********         Z-ADD     WkFSECUP      WkLAmtECF                                    225301
     C                   IF        FSHECP < 0                                                 225301
     C                   Z-ADD     FSHECP        WkLAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C**********         IF        WkFSECUP > 0                                               225301
     C**********         Z-SUB     WkFSECUP      WkPAmtECF                                    225301
     C                   IF        FSHECP > 0                                                 225301
     C                   Z-SUB     FSHECP        WkPAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*DEALSDB               225301
      **********                                                                              225301
     C**********         EVAL      FSECUP = *ZEROS                                            225301
 
      ** Generate Ineffective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSXCUP < 0                                               225301
     C**********         Z-ADD     WkFSXCUP      WkLAmtICF                                    225301
     C                   IF        FSHXCP < 0                                                 225301
     C                   Z-ADD     FSHXCP        WkLAmtICF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C**********         IF        WkFSXCUP > 0                                               225301
     C**********         Z-SUB     WkFSXCUP      WkPAmtICF                                    225301
     C                   IF        FSHXCP > 0                                                 225301
     C                   Z-SUB     FSHXCP        WkPAmtICF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ***Update*the*Ineffective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*DEALSDB             225301
      **********                                                                              225301
     C**********         EVAL      FSXCUP = *ZEROS                                            225301
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLiveHdgCD - Live Transactions from DEALSDC/DEALSDD          *
      *                                                               *
      *****************************************************************
 
     C     SRLiveHdgCD   BEGSR
 
     C                   EVAL      DKREVI = 0
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSEFUP < 0                                               225301
     C**********         Z-ADD     WkFSEFUP      WkLAmtEFV                                    225301
     C                   IF        FSEFVP < 0                                                 225301
     C                   Z-ADD     FSEFVP        WkLAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C**********         IF        WkFSEFUP > 0                                               225301
     C**********         Z-SUB     WkFSEFUP      WkPAmtEFV                                    225301
     C                   IF        FSEFVP > 0                                                 225301
     C                   Z-SUB     FSEFVP        WkPAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*DEALSDC/DEALSDD      225301
      **********                                                                              225301
     C**********         EVAL      FSEFUP = *ZEROS                                            225301
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSECUP < 0                                               225301
     C**********         Z-ADD     WkFSECUP      WkLAmtECF                                    225301
     C                   IF        FSHECP < 0                                                 225301
     C                   Z-ADD     FSHECP        WkLAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C**********         IF        WkFSECUP > 0                                               225301
     C**********         Z-SUB     WkFSECUP      WkPAmtECF                                    225301
     C                   IF        FSHECP > 0                                                 225301
     C                   Z-SUB     FSHECP        WkPAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*DEALSDC/DEALSDD       225301
      **********                                                                              225301
     C**********         EVAL      FSECUP = *ZEROS                                            225301
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLiveHdgDG - Live Transactions from DEALSDG                  *
      *                                                               *
      *****************************************************************
 
     C     SRLiveHdgDG   BEGSR
 
     C                   EVAL      DKREVI = 0
 
      ** Generate Effective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSEFUP < 0                                               225301
     C**********         Z-ADD     WkFSEFUP      WkLAmtEFV                                    225301
     C                   IF        FSEFVP < 0                                                 225301
     C                   Z-ADD     FSEFVP        WkLAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C**********         IF        WkFSEFUP > 0                                               225301
     C**********         Z-SUB     WkFSEFUP      WkPAmtEFV                                    225301
     C                   IF        FSEFVP > 0                                                 225301
     C                   Z-SUB     FSEFVP        WkPAmtEFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   EVAL      WkFlInd = 'DG'
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*DEALSDG              225301
      **********                                                                              225301
     C**********         EVAL      FSEFUP = *ZEROS                                            225301
 
      ** Generate Ineffective Fair Value Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSXFUP < 0                                               225301
     C**********         Z-ADD     WkFSXFUP      WkLAmtIFV                                    225301
     C                   IF        FSHXFP < 0                                                 225301
     C                   Z-ADD     FSHXFP        WkLAmtIFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C**********         IF        WkFSXFUP > 0                                               225301
     C**********         Z-SUB     WkFSXFUP      WkPAmtIFV                                    225301
     C                   IF        FSHXFP > 0                                                 225301
     C                   Z-SUB     FSHXFP        WkPAmtIFV                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*DEALSDG              225301
      **********                                                                              225301
     C**********         EVAL      FSXFUP = *ZEROS                                            225301
 
      ** Generate Effective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSECUP < 0                                               225301
     C**********         Z-ADD     WkFSECUP      WkLAmtECF                                    225301
     C                   IF        FSHECP < 0                                                 225301
     C                   Z-ADD     FSHECP        WkLAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C**********         IF        WkFSECUP > 0                                               225301
     C**********         Z-SUB     WkFSECUP      WkPAmtECF                                    225301
     C                   IF        FSHECP > 0                                                 225301
     C                   Z-SUB     FSHECP        WkPAmtECF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EVAL      WkFlInd = 'DG'
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*DEALSDG               225301
      **********                                                                              225301
     C**********         EVAL      FSECUP = *ZEROS                                            225301
 
      ** Generate Ineffective Cash Flow Hedge Unrealized Profit/Loss Posted
      ** account key with a negative amount
 
     C**********         IF        WkFSXCUP < 0                                               225301
     C**********         Z-ADD     WkFSXCUP      WkLAmtICF                                    225301
     C                   IF        FSHXCP < 0                                                 225301
     C                   Z-ADD     FSHXCP        WkLAmtICF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C**********         IF        WkFSXCUP > 0                                               225301
     C**********         Z-SUB     WkFSXCUP      WkPAmtICF                                    225301
     C                   IF        FSHXCP > 0                                                 225301
     C                   Z-SUB     FSHXCP        WkPAmtICF                                    225301
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ***Update*the*Ineffective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*DEALSDG             225301
      **********                                                                              225301
     C**********         EVAL      FSXCUP = *ZEROS                                            225301
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      ** Generate Fair Value Hedge in Trading Status Unrealised Profit/Loss                   CAS005
      ** Posted account key with a negative amount                                            CAS005
                                                                                              CAS005
     C**********         IF        WkFSTFUP < 0                                        CAS005 225301
     C**********         Z-ADD     WkFSTFUP      WkLAmtTFV                             CAS005 225301
     C                   IF        FSHTFP < 0                                                 225301
     C                   Z-ADD     FSHTFP        WkLAmtTFV                                    225301
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EVAL      WkFlInd = 'DG'                                             CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C**********         IF        WkFSTFUP > 0                                        CAS005 225301
     C**********         Z-SUB     WkFSTFUP      WkPAmtTFV                             CAS005 225301
     C                   IF        FSHTFP > 0                                                 225301
     C                   Z-SUB     FSHTFP        WkPAmtTFV                                    225301
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTP'         AKY(8)                                       CAS005
     C                   EVAL      WkFlInd = 'DG'                                             CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ***Update*the*Fair*Value*Hedge*in*Trading*Status*Unrealized*Profit/Loss          CAS005 225301
      ***in*DEALSDG                                                                    CAS005 225301
      **********                                                                       CAS005 225301
     C**********         EVAL      FSTFUP = *ZEROS                                     CAS005 225301
                                                                                              CAS005
      ** Generate Cash Flow Hedge in Trading Status Unrealised Profit/Loss                    CAS005
      ** Posted account key with a negative amount                                            CAS005
                                                                                              CAS005
     C**********         IF        WkFSTCUP < 0                                        CAS005 225301
     C**********         Z-ADD     WkFSTCUP      WkLAmtTCF                             CAS005 225301
     C                   IF        FSHTCP < 0                                                 225301
     C                   Z-ADD     FSHTCP        WkLAmtTCF                                    225301
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EVAL      WkFlInd = 'DG'                                             CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C**********         IF        WkFSTCUP > 0                                        CAS005 225301
     C**********         Z-SUB     WkFSTCUP      WkPAmtTCF                             CAS005 225301
     C                   IF        FSHTCP > 0                                                 225301
     C                   Z-SUB     FSHTCP        WkPAmtTCF                                    225301
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTP'         AKY(8)                                       CAS005
     C                   EVAL      WkFlInd = 'DG'                                             CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ***Update*the*Cash*Flow*Hedge*in*Trading*Status*Unrealized*Profit/Loss           CAS005 225301
      ***in*DEALSDG                                                                    CAS005 225301
      **********                                                                       CAS005 225301
     C**********         EVAL      FSTCUP = *ZEROS                                     CAS005 225301
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelHdgDB - Generate Deletion Posting Reversal for DEALSDB   *
      *                                                               *
      *****************************************************************
 
     C     SRDelHdgDB    BEGSR
 
     C                   EVAL      DKREVI = 1
 
      ** Deal is a Hedged Item
 
     C                   IF        WkDHIN = 'H'
 
      ** Generate Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss posted account key with a positive amount
 
     C                   IF        FSEFVP < *ZEROS
     C                   Z-SUB     FSEFVP        WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        FSEFVP > *ZEROS
     C                   Z-ADD     FSEFVP        WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
      ** Update the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSEFVP = *ZEROS
 
      ** Generate Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHECP  < *ZEROS
     C                   Z-SUB     FSHECP        WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        FSHECP  > *ZEROS
     C                   Z-ADD     FSHECP        WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
 
      ** Update the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHECP = *ZEROS
 
     C                   ENDIF
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
      ** Generate Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss posted account key with a positive amount
 
     C                   IF        FSEFVP < *ZEROS
     C                   Z-SUB     FSEFVP        WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        FSEFVP > *ZEROS
     C                   Z-ADD     FSEFVP        WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
      ** Update the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSEFVP = *ZEROS
 
      ** Generate Hedge Transaction Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHXFP < *ZEROS
     C                   Z-SUB     FSHXFP        WkLAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        FSHXFP > *ZEROS
     C                   Z-ADD     FSHXFP        WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
      ** Update the Hedge Transaction Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHXFP = *ZEROS
 
     C                   ENDIF
 
      ** Generate Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHECP  < *ZEROS
     C                   Z-SUB     FSHECP        WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        FSHECP  > *ZEROS
     C                   Z-ADD     FSHECP        WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
 
      ** Update the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHECP = *ZEROS
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
      ** Generate Hedge Transaction Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHXCP  < *ZEROS
     C                   Z-SUB     FSHXCP        WkLAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        FSHXCP  > *ZEROS
     C                   Z-ADD     FSHXCP        WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
 
      ** Update the Hedge Transaction Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHXCP = *ZEROS
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelHdgCD - Generate Deletion Posting Reversal for DEALSDC   *
      *              and DEALSDD                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDelHdgCD    BEGSR
 
     C                   EVAL      DKREVI = 1
 
      ** Generate Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSEFVP < *ZEROS
     C                   Z-SUB     FSEFVP        WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        FSEFVP > *ZEROS
     C                   Z-ADD     FSEFVP        WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
      ** Update the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSEFVP = *ZEROS
 
      ** Generate Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHECP  < *ZEROS
     C                   Z-SUB     FSHECP        WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        FSHECP  > *ZEROS
     C                   Z-ADD     FSHECP        WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
 
      ** Update the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHECP = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelHdgDG - Generate Deletion Posting Reversal for DEALSDG   *
      *                                                               *
      *****************************************************************
 
     C     SRDelHdgDG    BEGSR
 
     C                   EVAL      DKREVI = 1
 
      ** Generate Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSEFVP < *ZEROS
     C                   Z-SUB     FSEFVP        WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        FSEFVP > *ZEROS
     C                   Z-ADD     FSEFVP        WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
      ** Update the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSEFVP = *ZEROS
 
      ** Generate Hedge Transaction Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHXFP < *ZEROS
     C                   Z-SUB     FSHXFP        WkLAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        FSHXFP > *ZEROS
     C                   Z-ADD     FSHXFP        WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
      ** Update the Hedge Transaction Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHXFP = *ZEROS
 
      ** Generate Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHECP  < *ZEROS
     C                   Z-SUB     FSHECP        WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        FSHECP  > *ZEROS
     C                   Z-ADD     FSHECP        WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
 
      ** Update the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHECP = *ZEROS
 
      ** Generate Hedge Transaction Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted account key with a positive amount
 
     C                   IF        FSHXCP  < *ZEROS
     C                   Z-SUB     FSHXCP        WkLAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        FSHXCP  > *ZEROS
     C                   Z-ADD     FSHXCP        WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
 
      ** Update the Hedge Transaction Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHXCP = *ZEROS
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      ** Generate Hedge Transaction Fair Value Hedge in Trading Status                        CAS005
      ** Unrealised Profit/Loss Posted account key with a positive amount                     CAS005
                                                                                              CAS005
     C                   IF        FSHTFP  < *ZEROS                                           CAS005
     C                   Z-SUB     FSHTFP        WkLAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSHTFP  > *ZEROS                                           CAS005
     C                   Z-ADD     FSHTFP        WkPAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WkSumTFV = WkSumTFV + FSHTFP                               CAS005
                                                                                              CAS005
      ** Update the Hedge Transaction Fair Value Hedge in Trading Status                      CAS005
      ** Unrealised Profit/Loss Posted in ASHTRNPD                                            CAS005
                                                                                              CAS005
     C                   EVAL      FSHTFP = *ZEROS                                            CAS005
                                                                                              CAS005
      ** Generate Hedge Transaction Cash Flow Hedge in Trading Status                         CAS005
      ** Unrealised Profit/Loss Posted account key with a positive amount                     CAS005
                                                                                              CAS005
     C                   IF        FSHTCP  < *ZEROS                                           CAS005
     C                   Z-SUB     FSHTCP        WkLAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSHTCP  > *ZEROS                                           CAS005
     C                   Z-ADD     FSHTCP        WkPAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WkSumTCF = WkSumTCF + FSHTCP                               CAS005
                                                                                              CAS005
      ** Update the Hedge Transaction Cash Flow Hedge in Trading Status                       CAS005
      ** Unrealised Profit/Loss Posted in ASHTRNPD                                            CAS005
                                                                                              CAS005
     C                   EVAL      FSHTCP = *ZEROS                                            CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevPostDB - Generate a reversal posting for the remainder   *
      *               of Unrealized P/L posted not yet reversed       *
      *                                                               *
      *****************************************************************
 
     C     SRRevPostDB   BEGSR
 
      ** Reset reversal indicator in case this subroutine is called                           231247
      ** following process of deleted hedge                                                   231247
                                                                                              231247
     C                   EVAL      DKREVI = 0                                                 231247
                                                                                              231247
      ** Deal is a Hedged Item
 
     C                   IF        WkDHIN = 'H'
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP.
 
     C                   IF        WkFSEFUP < *ZEROS
     C                   EVAL      WkLAmtEFV = WkFSEFUP - WkSumEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > *ZEROS
     C                   EVAL      WkPAmtEFV = WkFSEFUP - WkSumEFV
     C                   Z-SUB     WkPAmtEFV     WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in DEALSDB
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP.
 
     C                   IF        WkFSECUP < *ZEROS
     C                   EVAL      WkLAmtECF = WkFSECUP - WkSumECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > *ZEROS
     C                   EVAL      WkPAmtECF = WkFSECUP - WkSumECF
     C                   Z-SUB     WkPAmtECF     WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in DEALSDB
 
     C                   EVAL      FSECUP = *ZEROS
 
     C                   ENDIF
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP.
 
     C                   IF        WkFSEFUP < *ZEROS
     C                   EVAL      WkLAmtEFV = WkFSEFUP - WkSumEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > *ZEROS
     C                   EVAL      WkPAmtEFV = WkFSEFUP - WkSumEFV
     C                   Z-SUB     WkPAmtEFV     WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in DEALSDB
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP.
 
     C                   IF        WkFSXFUP < *ZEROS
     C                   EVAL      WkLAmtIFV = WkFSXFUP - WkSumIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        WkFSXFUP > *ZEROS
     C                   EVAL      WkPAmtIFV = WkFSXFUP - WkSumIFV
     C                   Z-SUB     WkPAmtIFV     WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ** Update the Ineffective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in DEALSDB
 
     C                   EVAL      FSXFUP = *ZEROS
 
     C                   ENDIF
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP.
 
     C                   IF        WkFSECUP < *ZEROS
     C                   EVAL      WkLAmtECF = WkFSECUP - WkSumECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > *ZEROS
     C                   EVAL      WkPAmtECF = WkFSECUP - WkSumECF
     C                   Z-SUB     WkPAmtECF     WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in DEALSDB
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP.
 
     C                   IF        WkFSXCUP < *ZEROS
     C                   EVAL      WkLAmtICF = WkFSXCUP - WkSumICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        WkFSXCUP > *ZEROS
     C                   EVAL      WkPAmtICF = WkFSXCUP - WkSumICF
     C                   Z-SUB     WkPAmtICF     WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in DEALSDB
 
     C                   EVAL      FSXCUP = *ZEROS
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevPostCD - Generate a reversal posting for the remainder   *
      *               of Unrealized P/L posted not yet reversed       *
      *                                                               *
      *****************************************************************
 
     C     SRRevPostCD   BEGSR
 
      ** Reset reversal indicator in case this subroutine is called                           231247
      ** following process of deleted hedge                                                   231247
                                                                                              231247
     C                   EVAL      DKREVI = 0                                                 231247
                                                                                              231247
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP.
 
     C                   IF        WkFSEFUP < *ZEROS
     C                   EVAL      WkLAmtEFV = WkFSEFUP - WkSumEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > *ZEROS
     C                   EVAL      WkPAmtEFV = WkFSEFUP - WkSumEFV
     C                   Z-SUB     WkPAmtEFV     WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in DEALSDC/DEALSDD
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP.
 
     C                   IF        WkFSECUP < *ZEROS
     C                   EVAL      WkLAmtECF = WkFSECUP - WkSumECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > *ZEROS
     C                   EVAL      WkPAmtECF = WkFSECUP - WkSumECF
     C                   Z-SUB     WkPAmtECF     WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in DEALSDC/DEALSDD
 
     C                   EVAL      FSECUP = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevPostDG - Generate a reversal posting for the remainder   *
      *               of Unrealized P/L posted not yet reversed       *
      *                                                               *
      *****************************************************************
 
     C     SRRevPostDG   BEGSR
 
      ** Reset reversal indicator in case this subroutine is called                           231247
      ** following process of deleted hedge                                                   231247
                                                                                              231247
     C                   EVAL      DKREVI = 0                                                 231247
                                                                                              231247
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP.
 
     C                   IF        WkFSEFUP < *ZEROS
     C                   EVAL      WkLAmtEFV = WkFSEFUP - WkSumEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > *ZEROS
     C                   EVAL      WkPAmtEFV = WkFSEFUP - WkSumEFV
     C                   Z-SUB     WkPAmtEFV     WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in DEALSDG
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP.
 
     C                   IF        WkFSXFUP < *ZEROS
     C                   EVAL      WkLAmtIFV = WkFSXFUP - WkSumIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        WkFSXFUP > *ZEROS
     C                   EVAL      WkPAmtIFV = WkFSXFUP - WkSumIFV
     C                   Z-SUB     WkPAmtIFV     WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ** Update the Ineffective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in DEALSDG
 
     C                   EVAL      FSXFUP = *ZEROS
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP.
 
     C                   IF        WkFSECUP < *ZEROS
     C                   EVAL      WkLAmtECF = WkFSECUP - WkSumECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > *ZEROS
     C                   EVAL      WkPAmtECF = WkFSECUP - WkSumECF
     C                   Z-SUB     WkPAmtECF     WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in DEALSDG
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Generate the following account key with a negative amount.
      ** Posting amount would be the Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP,
 
     C                   IF        WkFSXCUP < *ZEROS
     C                   EVAL      WkLAmtICF = WkFSXCUP - WkSumICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        WkFSXCUP > *ZEROS
     C                   EVAL      WkPAmtICF = WkFSXCUP - WkSumICF
     C                   Z-SUB     WkPAmtICF     WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in DEALSDG
 
     C                   EVAL      FSXCUP = *ZEROS
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      ** Generate the following account key with a negative amount.                           CAS005
      ** Posting amount would be the Fair Value Hedge in Trading Status                       CAS005
      ** Unrealised Profit/Loss Posted less the accumulated reversed FSHTFP.                  CAS005
                                                                                              CAS005
     C                   IF        WkFSTFUP < *ZEROS                                          CAS005
     C                   EVAL      WkLAmtTFV = WkFSTFUP - WkSumTFV                            CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkFSTFUP > *ZEROS                                          CAS005
     C                   EVAL      WkPAmtTFV = WkFSTFUP - WkSumTFV                            CAS005
     C                   Z-SUB     WkPAmtTFV     WkPAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Update the Fair Value Hedge in Trading Status Unrealized Profit/Loss                 CAS005
      ** Posted in DEALSDG                                                                    CAS005
                                                                                              CAS005
     C                   EVAL      FSTFUP = *ZEROS                                            CAS005
                                                                                              CAS005
      ** Generate the following account key with a negative amount.                           CAS005
      ** Posting amount would be the Cash Flow Hedge in Trading Status                        CAS005
      ** Unrealised Profit/Loss Posted less the accumulated reversed FSHTCP,                  CAS005
                                                                                              CAS005
     C                   IF        WkFSTCUP < *ZEROS                                          CAS005
     C                   EVAL      WkLAmtTCF = WkFSTCUP - WkSumTCF                            CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkFSTCUP > *ZEROS                                          CAS005
     C                   EVAL      WkPAmtTCF = WkFSTCUP - WkSumTCF                            CAS005
     C                   Z-SUB     WkPAmtTCF     WkPAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit/Loss                        CAS005
      ** Posted in DEALSDG                                                                    CAS005
                                                                                              CAS005
     C                   EVAL      FSTCUP = *ZEROS                                            CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedgeDB - Generate Hedge Account Keys for DEALSDB           *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeDB     BEGSR
 
     C                   EXSR      SRInitEWV
     C                   EXSR      SRInitIWV
 
     C                   EVAL      DKREVI   = 0
     C                   EVAL      KLNKDN = LNKDN
                                                                                              CAS006
     C*****FSHEDI        CHAIN     ASHTRNLH                                            CAS006 228059
     C     FSHEDI        CHAIN     ASHTRNLI                                                   228259
                                                                                              CAS006
      ** If linkage does not involved forecast transaction                                    CAS006
     C**********         IF        NOT %FOUND(ASHTRNLH)                                CAS006 228259
     C                   IF        NOT %FOUND(ASHTRNLI)                                       228259
 
      ** Access the hedged item of the derivative
     C                   IF        WkDHIN = 'D'
     C     KLNKDN        CHAIN     DLDLDBL1
     C                   IF        NOT %FOUND(DLDLDBL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DLDLDBL1'
     C                   MOVE      KLNKDN        DBKEY
     C                   EVAL      DBASE  =  013
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      KLNKDN = BLNKDN
     C                   ENDIF
     C                   ENDIF
 
      ** Access the money markey deals of the hedged item
     C     KLNKDN        CHAIN     DLDLDCL1
     C                   IF        NOT %FOUND(DLDLDCL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DLDLDCL1'
     C                   MOVE      KLNKDN        DBKEY
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CDTYP = 'IP' OR
     C                             CDTYP = 'TI' OR
     C                             CDTYP = 'CL' OR
     C                             CDTYP = 'DL' OR
     C                             CDTYP = 'FL' OR
     C                             CDTYP = 'DP' OR
     C                             CDTYP = 'LP'
 
     C                   EVAL      CCY = CCCY
     C                   IF        WkDHIN = 'H'
     C                   IF        CCCY = PUCY
     C                   EVAL      WkUNRL = FSURPL
     C                   ELSE
     C                   GOTO      EndSRHedgeDB
     C                   ENDIF
     C                   ELSE
     C                   IF        CCCY = SLCY
     C                   EVAL      WkUNRL = FSSUPL
     C                   ELSE
     C                   GOTO      EndSRHedgeDB
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CDTYP = 'IT' OR
     C                             CDTYP = 'TD' OR
     C                             CDTYP = 'CI' OR
     C                             CDTYP = 'CD' OR
     C                             CDTYP = 'FT' OR
     C                             CDTYP = 'DT' OR
     C                             CDTYP = 'LT'
 
     C                   EVAL      CCY = CCCY
     C                   IF        WkDHIN = 'H'
     C                   IF        CCCY = SLCY
     C                   EVAL      WkUNRL = FSSUPL
     C                   ELSE
     C                   GOTO      EndSRHedgeDB
     C                   ENDIF
     C                   ELSE
     C                   IF        CCCY = PUCY
     C                   EVAL      WkUNRL = FSURPL
     C                   ELSE
     C                   GOTO      EndSRHedgeDB
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   EXSR      SRForeTrn                                                  CAS006
     C                   ENDIF                                                                CAS006
 
      ** Deal is a Hedged Item
 
     C                   IF        WkDHIN = 'H'
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   IF        %EOF(ASHTRNLA)
     C                   GOTO      EndSRHedgeDB
     C                   ENDIF
 
      ** Check if Hedge is Effective
 
     C                   DOW       NOT %EOF(ASHTRNLA)
 
     C                   IF        FSHTID = 'D'
     C     FSHEDI        CHAIN     ASHGLKL1
     C                   IF        HLRECI = 'D'
 
      ** Obtain the Hedge Product Type
 
     C     HLHGST        CHAIN     SDHGSTL1
 
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHGSTPD'
     C                   EVAL      DBKEY  =  HLHGST
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if the deal is partially hedge, calculate the hedge portion
 
     C                   IF        FSPCTG < 100
     C                   EVAL      WkAmt = WkUNRL * FSPCTG / 100
     C                   ELSE
     C                   EVAL      WkAmt = WkUNRL
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is less than zero
 
     C                   IF        WkUNRL < 0
 
      ** Generate Effective Hedge Account Key and set the amount of
      ** FSEFUP/FSECUP in DEALSDB with negative amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   Z-SUB     WkAmt         FSEFVP
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   Z-SUB     WkAmt         FSHECP
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        WkUNRL > 0
 
      ** Generate Effective Hedge Account Key and set the amount of
      ** FSEFUP/FSECUP in DEALSDB with Positive amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   EVAL      FSEFVP = WkAmt
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     c                   EVAL      FSHECP = WkAmt
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
 
     C                   ENDIF
 
      ** Deal is a Hedge Derivative
 
     C                   IF        WkDHIN = 'D'
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   IF        %EOF(ASHTRNLA)
     C                   GOTO      EndSRHedgeDB
     C                   ENDIF
 
      ** Check if Hedge is Effective
 
     C                   DOW       NOT %EOF(ASHTRNLA)
 
     C                   IF        FSHTID = 'D'
     C     FSHEDI        CHAIN     ASHGLKL1
     C                   IF        HLRECI = 'D' OR
     C                             HLRECI = 'X'
 
      ** Obtain the Hedge Product Type
 
     C     HLHGST        CHAIN     SDHGSTL1
 
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHGSTPD'
     C                   EVAL      DBKEY  =  HLHGST
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if the deal is partially hedge, calculate the hedge portion
 
     C                   IF        FSPCTG < 100
     C                   EVAL      WkAmt = WkUNRL * FSPCTG / 100
     C                   ELSE
     C                   EVAL      WkAmt = WkUNRL
     C                   ENDIF
 
      ** Generate Effective Hedge Account Keys for Effective Hedges
 
     C                   IF        HLRECI = 'D'
 
      ** If Unrealized Profit/Loss is less than zero
 
     C                   IF        WkUNRL < 0
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   Z-SUB     WkAmt         FSEFVP
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   Z-SUB     WkAmt         FSHECP
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        WkUNRL > 0
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   EVAL      FSEFVP = WkAmt
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     c                   EVAL      FSHECP = WkAmt
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Generate Ineffective Hedge Account Keys for Discontinued Hedges
 
     C                   IF        HLRECI = 'X'
 
      ** If Unrealized Profit/Loss is less than zero
 
     C                   IF        WkUNRL < 0
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   Z-SUB     WkAmt         FSHXFP
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   Z-SUB     WkAmt         FSHXCP
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        WkUNRL > 0
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   EVAL      FSHXFP = WkAmt
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     c                   EVAL      FSHXCP = WkAmt
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
     C                   ENDIF
 
     C     EndSRHedgeDB  ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedgeCD - Generate Hedge Account Keys for DEALSDC/DEALSDD   *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeCD     BEGSR
 
     C                   EXSR      SRInitEWV
 
     C                   EVAL      DKREVI   = 0
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   IF        %EOF(ASHTRNLA)
     C                   GOTO      EndSRHedgeCD
     C                   ENDIF
 
      ** Check if Hedge is Effective
 
     C                   DOW       NOT %EOF(ASHTRNLA)
 
     C                   IF        FSHTID = 'D'
     C     FSHEDI        CHAIN     ASHGLKL1
     C                   IF        HLRECI = 'D'
 
      ** Obtain the Hedge Product Type
 
     C     HLHGST        CHAIN     SDHGSTL1
 
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHGSTPD'
     C                   EVAL      DBKEY  =  HLHGST
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if the deal is partially hedge, calculate the hedge portion
 
     C                   IF        FSPCTG < 100
     C                   EVAL      WkAmt = FSURPL * FSPCTG / 100
     C                   ELSE
     C                   EVAL      WkAmt = FSURPL
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is less than zero
 
     C                   IF        FSURPL < 0
 
      ** Generate Effective Hedge Account Key and set the amount of
      ** FSEFUP/FSECUP in DEALSDS/DEALSDD with negative amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   Z-SUB     WkAmt         FSEFVP
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   Z-SUB     WkAmt         FSHECP
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        FSURPL > 0
 
      ** Generate Effective Hedge Account Key and set the amount of
      ** FSEFUP/FSECUP in DEALSDC/DEALSDD with Positive amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   EVAL      FSEFVP = WkAmt
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CIP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     c                   EVAL      FSHECP = WkAmt
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
 
     C     EndSRHedgeCD  ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedgeDG - Generate Hedge Account Keys for DEALSDG           *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeDG     BEGSR
 
     C                   EXSR      SRInitEWV
     C                   EXSR      SRInitIWV
     C                   EXSR      SRInitTWV                                                  CAS005
 
     C                   EVAL      DKREVI   = 0
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   IF        %EOF(ASHTRNLA)
     C                   GOTO      EndSRHedgeDG
     C                   ENDIF
 
      ** Check if Hedge is Effective
 
     C                   DOW       NOT %EOF(ASHTRNLA)
 
     C                   IF        FSHTID = 'D'
     C     FSHEDI        CHAIN     ASHGLKL1
     C                   IF        HLRECI = 'D' OR
     C                             HLRECI = 'X'
     C                             OR HLRECI = 'T' AND CAS005 = 'Y'                           CAS005
 
      ** Obtain the Hedge Product Type
 
     C     HLHGST        CHAIN     SDHGSTL1
 
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHGSTPD'
     C                   EVAL      DBKEY  =  HLHGST
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if the deal is partially hedge, calculate the hedge portion
 
     C                   IF        FSPCTG < 100
                                                                                              CAS005
      ** If deal is a cross currency swap, use the corresponding UNRL side in                 CAS005
      ** computing the hedged amount                                                          CAS005
                                                                                              CAS005
     C                   IF        DTYP = 'RX'                                                CAS005
     C                   IF        FSHSID = 'U'                                               CAS005
     C                   EVAL      WkAmt = FSUURL * FSPCTG / 100                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WkAmt = FSTURL * FSPCTG / 100                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WkAmt = UNRL * FSPCTG / 100
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Else, deal is 100% hedged, therefore, post the full amount                           CAS005
                                                                                              CAS005
     C                   ELSE
                                                                                              CAS005
      ** If cross currency deal, full amount of the hedged leg's UNRL                         CAS005
     C                   IF        DTYP = 'RX'                                                CAS005
     C                   IF        FSHSID = 'U'                                               CAS005
     C                   Z-ADD     FSUURL        WkAmt                                        CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSTURL        WkAmt                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Else, full amount of the UNRL                                                        CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WkAmt = UNRL
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF
 
      ** Generate Effective Hedge Account Keys for Effective Hedges
 
     C                   IF        HLRECI = 'D'
 
      ** If Unrealized Profit/Loss is less than zero
 
     C                   IF        UNRL < 0
     C                             AND DTYP <> 'RX' OR (DTYP = 'RX' AND                       CAS005
     C                             (FSHSID = 'U' AND FSUURL < 0)  OR                          CAS005
     C                             (FSHSID = 'T' AND FSTURL < 0))                             CAS005
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   Z-SUB     WkAmt         FSEFVP
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     C                   Z-SUB     WkAmt         FSHECP
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        UNRL > 0
     C                             AND DTYP <> 'RX' OR (DTYP = 'RX' AND                       CAS005
     C                             (FSHSID = 'U' AND FSUURL > 0)  OR                          CAS005
     C                             (FSHSID = 'T' AND FSTURL > 0))                             CAS005
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtEFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyEFV
     C                   EVAL      FSEFVP = WkAmt
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtECF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CDP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyECF
     c                   EVAL      FSHECP = WkAmt
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Generate Ineffective Hedge Account Keys for Discontinued Hedges
 
     C                   IF        HLRECI = 'X'
 
      ** If Unrealized Profit/Loss is less than zero
 
     C                   IF        UNRL < 0
     C                             AND DTYP <> 'RX' OR (DTYP = 'RX' AND                       CAS005
     C                             (FSHSID = 'U' AND FSUURL < 0)  OR                          CAS005
     C                             (FSHSID = 'T' AND FSTURL < 0))                             CAS005
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   Z-SUB     WkAmt         FSHXFP
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXL'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     C                   Z-SUB     WkAmt         FSHXCP
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        UNRL > 0
     C                             AND DTYP <> 'RX' OR (DTYP = 'RX' AND                       CAS005
     C                             (FSHSID = 'U' AND FSUURL > 0)  OR                          CAS005
     C                             (FSHSID = 'T' AND FSTURL > 0))                             CAS005
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtIFV
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'FXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyIFV
     C                   EVAL      FSHXFP = WkAmt
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtICF
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     'CXP'         AKY(8)
     C                   ENDIF
     C                   EXSR      SRGenKeyICF
     c                   EVAL      FSHXCP = WkAmt
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS005
      ** Generate Trading-Status Hedge Account Keys                                           CAS005
                                                                                              CAS005
     C                   IF        HLRECI = 'T'                                               CAS005
                                                                                              CAS005
      ** If Unrealized Profit/Loss is less than zero                                          CAS005
                                                                                              CAS005
     C                   IF        UNRL < 0                                                   CAS005
     C                             AND DTYP <> 'RX' OR (DTYP = 'RX' AND                       CAS005
     C                             (FSHSID = 'U' AND FSUURL < 0)  OR                          CAS005
     C                             (FSHSID = 'T' AND FSTURL < 0))                             CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      SDPRTP = 'FV'                                              CAS005
     C                   Z-SUB     WkAmt         WkLAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   Z-SUB     WkAmt         FSHTFP                                       CAS005
     C                   EVAL      WkSumTFV = WkSumTFV + FSHTFP                               CAS005
                                                                                              CAS005
     C                   WHEN      SDPRTP = 'CF'                                              CAS005
     C                   Z-SUB     WkAmt         WkLAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTL'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     C                   Z-SUB     WkAmt         FSHTCP                                       CAS005
     C                   EVAL      WkSumTCF = WkSumTCF + FSHTCP                               CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If Unrealized Profit/Loss is greater than zero                                       CAS005
                                                                                              CAS005
     C                   IF        UNRL > 0                                                   CAS005
     C                             AND DTYP <> 'RX' OR (DTYP = 'RX' AND                       CAS005
     C                             (FSHSID = 'U' AND FSUURL > 0)  OR                          CAS005
     C                             (FSHSID = 'T' AND FSTURL > 0))                             CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      SDPRTP = 'FV'                                              CAS005
     C                   Z-ADD     WkAmt         WkPAmtTFV                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'FTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTFV                                                CAS005
     C                   EVAL      FSHTFP = WkAmt                                             CAS005
     C                   EVAL      WkSumTFV = WkSumTFV + FSHTFP                               CAS005
                                                                                              CAS005
     C                   WHEN      SDPRTP = 'CF'                                              CAS005
     C                   Z-ADD     WkAmt         WkPAmtTCF                                    CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     'CTP'         AKY(8)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRGenKeyTCF                                                CAS005
     c                   EVAL      FSHTCP = WkAmt                                             CAS005
     C                   EVAL      WkSumTCF = WkSumTCF + FSHTCP                               CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
 
     C     EndSRHedgeDG  ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLiveTran - Common Routines for Live Transactions            *
      *                                                               *
      *****************************************************************
 
     C     SRLiveTran    BEGSR
 
     C                   EVAL      WkDelFlg = 'N'
 
      ** Check if deal was partially deleted or not
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   DOW       NOT %EOF(ASHTRNLA)
     C                   IF        FSHTCT = 'D' AND FSHTCD <= WkEVCD AND
     C                             FSHTCD >= BJRDNB
     C                   EVAL      WkDelFlg = 'Y'
     C                   ENDIF
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
 
      ** If deal is not deleted as a DL hedged item today
 
     C                   IF        WkDelFlg = 'N'
     C     KTranF        SETLL     ASHTRNLA                                                   221416
     C     KTranF        READE     ASHTRNLA                                                   221416
     C*****KTranF        CHAIN     ASHTRNLA                                                   221416
                                                                                              221416
     C                   DOW       NOT %EOF(ASHTRNLA)                                         221416
     C                   IF        FSHTID = 'D'                                               221416
                                                                                              221416
     C     FSHEDI        CHAIN     ASHGLKL1                                                   221416
     C                   IF        HLRECI = 'D' OR                                            221416
     C                             HLRECI = 'X' OR                                            221416
     C                             HLRECI = 'E' AND HLLCD <= WkEVCD AND                       221416
     C                             HLLCD >= BJRDNB                                            221416
     C                             OR HLRECI = 'T' AND CAS005 = 'Y'                           221416
                                                                                              221416
     C                   SELECT
     C                   WHEN      RCDT = 'B'
     C                   EXSR      SRLiveHdgDB
     C                   WHEN      RCDT = 'C' OR
     C                             RCDT = 'D'
     C                   EXSR      SRLiveHdgCD
     C                   WHEN      RCDT = 'G'
     C                   EXSR      SRLiveHdgDG
     C                   ENDSL
                                                                                              221416
     C                   EVAL      FSEFVP = *ZEROS                                            221416
     C                   EVAL      FSHXFP = *ZEROS                                            221416
     C                   EVAL      FSHECP = *ZEROS                                            221416
     C                   EVAL      FSHXCP = *ZEROS                                            221416
     C                   EVAL      FSHTFP = *ZEROS                                            221416
     C                   EVAL      FSHTCP = *ZEROS                                            221416
                                                                                              221416
     C                   UPDATE    ASHTRND0                                                   221416
     C                   ENDIF                                                                221416
                                                                                              221416
     C                   ENDIF                                                                221416
                                                                                              221416
     C     KTranF        READE     ASHTRNLA                                                   221416
     C                   ENDDO                                                                221416
                                                                                              221416
     C                   ENDIF
 
      ** If deal or a portion of it was deleted today as a DL hedged item
 
     C                   IF        WkDelFlg = 'Y'
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   DOW       NOT %EOF(ASHTRNLA)
 
     C                   IF        FSHTCT = 'D' AND FSHTCD <= WkEVCD AND
     C                             FSHTCD >= BJRDNB
     C                   SELECT
     C                   WHEN      RCDT = 'B'
     C                   EXSR      SRDelHdgDB
     C                   WHEN      RCDT = 'C' OR
     C                             RCDT = 'D'
     C                   EXSR      SRDelHdgCD
     c                   WHEN      RCDT = 'G'
     C                   EXSR      SRDelHdgDG
     C                   ENDSL
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0                                                   221416
     C     KTranF        READE     ASHTRNLA
 
      ** Generate Reversal posting for the remainder of the unrealized
      ** profit/loss posted not yet reversed.
 
     C                   IF        %EOF(ASHTRNLA)
     C                   SELECT
     C                   WHEN      RCDT = 'B'
     C                   EXSR      SRRevPostDB
     C                   WHEN      RCDT = 'C' OR
     C                             RCDT = 'D'
     C                   EXSR      SRRevPostCD
     c                   WHEN      RCDT = 'G'
     C                   EXSR      SRRevPostDG
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyEFV - Generate Account Key for Effective Fair Value   *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyEFV   BEGSR
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per deal
 
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     DTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     DLST          AKY(4)
     C                   MOVEA     CLAS          AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF
 
     C                   IF        WkLAmtEFV <> *ZEROS
     C                   Z-ADD     WkLAmtEFV     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtEFV <> *ZEROS
     C                   Z-ADD     WkPAmtEFV     WkAmt
     C                   ENDIF
 
     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkDLNO = DLNO
     C                   EVAL      WkCurr = CCY
     C                   EVAL      WkCNUM = CNUM
     C                   EVAL      WkBrca = BRCA
 
      ** Write to Report
 
     C                   IF        WkPAmtEFV <> *ZEROS
     C                             OR WkLAmtEFV <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accural Key Summary Required Indicator is on, store
      ** totals by deal type/sub-type and book code if book on
      ** account key is set to 'Y'
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BRCA          AKEY(1)
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKEY(4)
     C                   ENDIF
 
     C                   MOVEA     DTYP          AKEY(6)
     C                   MOVEA     DLST          AKEY(8)
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038
     C                   MOVEA     CCY           AKEY(10)
 
     C                   IF        WkFlInd = 'BG'
 
     C                   Z-ADD     1             Ex
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyFV2(Ex)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtEFV     TAmtFVL2(Ex)
     C                   ADD       WkPAmtEFV     TAmtFVP2(Ex)
     C                   ELSE
     C                   EVAL      WFV2 = WFV2 + 1
     C                   MOVEA     AKey          AKeyFV2(WFV2)
     C                   Z-ADD     WkLAmtEFV     TAmtFVL2(WFV2)
     C                   Z-ADD     WkPAmtEFV     TAmtFVP2(WFV2)
     C                   ENDIF
 
     C                   EVAL      WkFlInd = *BLANKS
 
     C                   ELSE
 
     C                   Z-ADD     1             Ex
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyEFV(Ex)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtEFV     TAmtEFVL(Ex)
     C                   ADD       WkPAmtEFV     TAmtEFVP(Ex)
     C                   ELSE
     C                   EVAL      WEFV = WEFV + 1
     C                   MOVEA     AKey          AKeyEFV(WEFV)
     C                   Z-ADD     WkLAmtEFV     TAmtEFVL(WEFV)
     C                   Z-ADD     WkPAmtEFV     TAmtEFVP(WEFV)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyIFV - Generate Account Key for Ineffective Fair Value *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyIFV   BEGSR
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per deal
 
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     DTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     DLST          AKY(4)
     C                   MOVEA     CLAS          AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF
 
     C                   IF        WkLAmtIFV <> *ZEROS
     C                   Z-ADD     WkLAmtIFV     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtIFV <> *ZEROS
     C                   Z-ADD     WkPAmtIFV     WkAmt
     C                   ENDIF
 
     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkDLNO = DLNO
     C                   EVAL      WkCurr = CCY
     C                   EVAL      WkCNUM = CNUM
     C                   EVAL      WkBrca = BRCA
 
      ** Write to Report
 
     C                   IF        WkPAmtIFV <> *ZEROS
     C                             OR WkLAmtIFV <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accural Key Summary Required Indicator is on, store
      ** totals by deal type/sub-type and book code if book on
      ** account key is set to 'Y'
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BRCA          AKEY(1)
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKEY(4)
     C                   ENDIF
 
     C                   MOVEA     DTYP          AKEY(6)
     C                   MOVEA     DLST          AKEY(8)
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038
     C                   MOVEA     CCY           AKEY(10)
 
     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyIFV(Ix)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtIFV     TAmtIFVL(Ix)
     C                   ADD       WkPAmtIFV     TAmtIFVP(Ix)
     C                   ELSE
     C                   EVAL      WIFV = WIFV + 1
     C                   MOVEA     AKey          AKeyIFV(WIFV)
     C                   Z-ADD     WkLAmtIFV     TAmtIFVL(WIFV)
     C                   Z-ADD     WkPAmtIFV     TAmtIFVP(WIFV)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyECF - Generate Account Key for Effective Cash Flow    *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyECF   BEGSR
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per deal
 
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     DTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     DLST          AKY(4)
     C                   MOVEA     CLAS          AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF
 
     C                   IF        WkLAmtECF <> *Zeros
     C                   Z-ADD     WkLAmtECF     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtECF <> *ZEROS
     C                   Z-ADD     WkPAmtECF     WkAmt
     C                   ENDIF
 
     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkDLNO = DLNO
     C                   EVAL      WkCurr = CCY
     C                   EVAL      WkCNUM = CNUM
     C                   EVAL      WkBRCA = BRCA
 
      ** Write to Report
 
     C                   IF        WkPAmtECF <> *ZEROS
     C                             OR WkLAmtECF <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accural Key Summary Required Indicator is on, store
      ** totals by deal type/sub-type and book code if book on
      ** account key is set to 'Y'
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BRCA          AKEY(1)
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKEY(4)
     C                   ENDIF
 
     C                   MOVEA     DTYP          AKEY(6)
     C                   MOVEA     DLST          AKEY(8)
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038
     C                   MOVEA     CCY           AKEY(10)
 
     C                   IF        WkFlInd = 'BG'
 
     C                   Z-ADD     1             Ex
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyCF2(Ex)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtECF     TAmtCFL2(Ex)
     C                   ADD       WkPAmtECF     TAmtCFP2(Ex)
     C                   ELSE
     C                   EVAL      WCF2 = WCF2 + 1
     C                   MOVEA     AKey          AKeyCF2(WCF2)
     C                   Z-ADD     WkLAmtECF     TAmtCFL2(WCF2)
     C                   Z-ADD     WkPAmtECF     TAmtCFP2(WCF2)
     C                   ENDIF
 
     C                   EVAL      WkFlInd = *BLANKS
 
     C                   ELSE
 
     C                   Z-ADD     1             Ex
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyECF(Ex)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtECF     TAmtECFL(Ex)
     C                   ADD       WkPAmtECF     TAmtECFP(Ex)
     C                   ELSE
     C                   EVAL      WECF = WECF + 1
     C                   MOVEA     AKey          AKeyECF(WECF)
     C                   Z-ADD     WkLAmtECF     TAmtECFL(WECF)
     C                   Z-ADD     WkPAmtECF     TAmtECFP(WECF)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyICF - Generate Account Key for Ineffective Cash Flow  *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyICF   BEGSR
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per deal
 
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     DTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     DLST          AKY(4)
     C                   MOVEA     CLAS          AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF
 
     C                   IF        WkLAmtICF <> *Zeros
     C                   Z-ADD     WkLAmtICF     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtICF <> *ZEROS
     C                   Z-ADD     WkPAmtICF     WkAmt
     C                   ENDIF
 
     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkDLNO = DLNO
     C                   EVAL      WkCurr = CCY
     C                   EVAL      WkCNUM = CNUM
     C                   EVAL      WkBRCA = BRCA
 
      ** Write to Report
 
     C                   IF        WkPAmtICF <> *ZEROS
     C                             OR WkLAmtICF <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accural Key Summary Required Indicator is on, store
      ** totals by deal type/sub-type and book code if book on
      ** account key is set to 'Y'
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BRCA          AKEY(1)
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKEY(4)
     C                   ENDIF
 
     C                   MOVEA     DTYP          AKEY(6)
     C                   MOVEA     DLST          AKEY(8)
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038
     C                   MOVEA     CCY           AKEY(10)
 
     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyICF(Ix)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtICF     TAmtICFL(Ix)
     C                   ADD       WkPAmtICF     TAmtICFP(Ix)
     C                   ELSE
     C                   EVAL      WICF = WICF + 1
     C                   MOVEA     AKey          AKeyICF(WICF)
     C                   Z-ADD     WkLAmtICF     TAmtICFL(WICF)
     C                   Z-ADD     WkPAmtICF     TAmtICFP(WICF)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRGenKeyTFV - Generate Account Key for Trading-Status Fair    *                       CAS005
      *               Value                                           *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRGenKeyTFV   BEGSR                                                                CAS005
                                                                                              CAS005
      ** If Account Key Summary Required Indicator is set off, generate                       CAS005
      ** account key per deal                                                                 CAS005
                                                                                              CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     DTYP          AKY(1)                                       CAS005
     C                   EVAL      AKY(3) = 'A'                                               CAS005
     C                   MOVEA     DLST          AKY(4)                                       CAS005
     C                   MOVEA     CLAS          AKY(11)                                      CDL038
                                                                                              CAS005
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     BOKC          AKY(6)                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkLAmtTFV <> *Zeros                                        CAS005
     C                   Z-ADD     WkLAmtTFV     WkAmt                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkPAmtTFV <> *ZEROS                                        CAS005
     C                   Z-ADD     WkPAmtTFV     WkAmt                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   MOVEA     AKY           WkAkey                                       CAS005
     C                   EVAL      WkDLNO = DLNO                                              CAS005
     C                   EVAL      WkCurr = CCY                                               CAS005
     C                   EVAL      WkCNUM = CNUM                                              CAS005
     C                   EVAL      WkBRCA = BRCA                                              CAS005
                                                                                              CAS005
      ** Write to Report                                                                      CAS005
                                                                                              CAS005
     C                   IF        WkPAmtTFV <> *ZEROS                                        CAS005
     C                             OR WkLAmtTFV <> *ZEROS                                     CAS005
     C                   EXSR      SRReport                                                   CAS005
                                                                                              CAS005
      ** Write to File                                                                        CAS005
                                                                                              CAS005
     C                   EXSR      SRWrite                                                    CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If Accrual Key Summary Required Indicator is on, store                               CAS005
      ** totals by deal type/sub-type and book code if book on                                CAS005
      ** account key is set to 'Y'                                                            CAS005
                                                                                              CAS005
     C                   IF        BKAKSI = 'Y'                                               CAS005
                                                                                              CAS005
     C                   MOVEA     *BLANKS       AKEY                                         CAS005
     C                   MOVEA     BRCA          AKEY(1)                                      CAS005
                                                                                              CAS005
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     BOKC          AKEY(4)                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   MOVEA     DTYP          AKEY(6)                                      CAS005
     C                   MOVEA     DLST          AKEY(8)                                      CAS005
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038
     C                   MOVEA     CCY           AKEY(10)                                     CAS005
                                                                                              CAS005
     C                   Z-ADD     1             Ix                                           CAS005
     C                   MOVEA     AKEY          ChkKey                                       CAS005
     C     ChkKey        LOOKUP    AKeyTFV(Ix)                            89                  CAS005
     C                   IF        *IN89 = *ON                                                CAS005
     C                   ADD       WkLAmtTFV     TAmtTFVL(Ix)                                 CAS005
     C                   ADD       WkPAmtTFV     TAmtTFVP(Ix)                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WTFV = WTFV + 1                                            CAS005
     C                   MOVEA     AKey          AKeyTFV(WTFV)                                CAS005
     C                   Z-ADD     WkLAmtTFV     TAmtTFVL(WTFV)                               CAS005
     C                   Z-ADD     WkPAmtTFV     TAmtTFVP(WTFV)                               CAS005
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
      * SRGenKeyTCF - Generate Account Key for Trading-Status Cash    *                       CAS005
      *               Flow                                            *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRGenKeyTCF   BEGSR                                                                CAS005
                                                                                              CAS005
      ** If Account Key Summary Required Indicator is set off, generate                       CAS005
      ** account key per deal                                                                 CAS005
                                                                                              CAS005
     C                   IF        BKAKSI <> 'Y'                                              CAS005
     C                   MOVEA     DTYP          AKY(1)                                       CAS005
     C                   EVAL      AKY(3) = 'A'                                               CAS005
     C                   MOVEA     DLST          AKY(4)                                       CAS005
     C                   MOVEA     CLAS          AKY(11)                                      CDL038
                                                                                              CAS005
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     BOKC          AKY(6)                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkLAmtTCF <> *Zeros                                        CAS005
     C                   Z-ADD     WkLAmtTCF     WkAmt                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkPAmtTCF <> *ZEROS                                        CAS005
     C                   Z-ADD     WkPAmtTCF     WkAmt                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   MOVEA     AKY           WkAkey                                       CAS005
     C                   EVAL      WkDLNO = DLNO                                              CAS005
     C                   EVAL      WkCurr = CCY                                               CAS005
     C                   EVAL      WkCNUM = CNUM                                              CAS005
     C                   EVAL      WkBRCA = BRCA                                              CAS005
                                                                                              CAS005
      ** Write to Report                                                                      CAS005
                                                                                              CAS005
     C                   IF        WkPAmtTCF <> *ZEROS                                        CAS005
     C                             OR WkLAmtTCF <> *ZEROS                                     CAS005
     C                   EXSR      SRReport                                                   CAS005
                                                                                              CAS005
      ** Write to File                                                                        CAS005
                                                                                              CAS005
     C                   EXSR      SRWrite                                                    CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If Accrual Key Summary Required Indicator is on, store                               CAS005
      ** totals by deal type/sub-type and book code if book on                                CAS005
      ** account key is set to 'Y'                                                            CAS005
                                                                                              CAS005
     C                   IF        BKAKSI = 'Y'                                               CAS005
                                                                                              CAS005
     C                   MOVEA     *BLANKS       AKEY                                         CAS005
     C                   MOVEA     BRCA          AKEY(1)                                      CAS005
                                                                                              CAS005
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     BOKC          AKEY(4)                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   MOVEA     DTYP          AKEY(6)                                      CAS005
     C                   MOVEA     DLST          AKEY(8)                                      CAS005
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038
     C                   MOVEA     CCY           AKEY(10)                                     CAS005
                                                                                              CAS005
     C                   Z-ADD     1             Ix                                           CAS005
     C                   MOVEA     AKEY          ChkKey                                       CAS005
     C     ChkKey        LOOKUP    AKeyTCF(Ix)                            89                  CAS005
     C                   IF        *IN89 = *ON                                                CAS005
     C                   ADD       WkLAmtTCF     TAmtTCFL(Ix)                                 CAS005
     C                   ADD       WkPAmtTCF     TAmtTCFP(Ix)                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WTCF = WTCF + 1                                            CAS005
     C                   MOVEA     AKey          AKeyTCF(WTCF)                                CAS005
     C                   Z-ADD     WkLAmtTCF     TAmtTCFL(WTCF)                               CAS005
     C                   Z-ADD     WkPAmtTCF     TAmtTCFP(WTCF)                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Write details to PF/DKEYSDP                         *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      DKRECI = 'D'
     C*******************MOVE      WkAkey        DKAKEY                                       CDL038
     C                   MOVEL     WkAkey        DKAKEY                                       CDL038
     C                   EVAL      DKDLNO = WkDLNO
     C                   EVAL      DKCNUM = WkCNUM
     C                   EVAL      DKBRCA = WkBRCA
     C                   EVAL      DKACSQ = WkACSQ
     C                   EVAL      DKEDAT = WkEVCD
     C                   EVAL      DKEAMT = WkAmt
     C                   EVAL      DKECCY = WkCurr
     C                   EVAL      DKSETP = *ZEROS
     C                   EVAL      DKOSAC = *BLANKS
     C                   EVAL      DKOTHA = *ZEROS
     C                   EVAL      DKOTHC = *BLANKS
     C                   EVAL      DKEXRT = *ZEROS
     C                   EVAL      DKVDAT = VDAT
     C                   EVAL      DKSLID = SLID
     C                   EVAL      DKMDAT = MDAT
     C                   EVAL      DKBRTT = BRTT
     C                   EVAL      DKBRTE = BRTE
     C                   EVAL      DKRTSP = RTSP
     C                   EVAL      DKINTR = INTR
     C                   EVAL      DKFFVD = *ZEROS
     C                   EVAL      DKYRAT = INTR
     C                   EVAL      DKFFIN = *BLANKS
     C                   EVAL      DKCHNACH = CHNA
     C                   EVAL      DKFACO = *BLANKS
     C                   EVAL      DKPRFC = PRFC
     C                   EVAL      DKOSBR = *BLANKS
     C                   EVAL      DKBOKC = BOKC
     C                   EVAL      DKRBDN = RBDN
     C                   EVAL      DKPTFR = PTFR
 
     C                   WRITE     DKEYSDPF
 
      ** Update Totals
 
     C                   EVAL      WkNoRec = WkNoRec + 1
     C                   EVAL      ZZAMT = WkAmt / 1000
 
     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
     C                   Z-ADD     WkVlInt       ZZTOTI
     C                   Z-ADD     WkVlDec       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        WkVlInt
     C                   Z-ADD     ZZTOTD        WkVlDec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReport - Write report details                               *
      *                                                               *
      *****************************************************************
 
     C     SRReport      BEGSR
 
     C                   IF        WkBRCA <> PrBRCA
 
     C                   IF        PrBRCA <> *Blanks
     C                   EXSR      SREndRep
     C                   ENDIF
 
     C                   EXSR      SRBranch
 
     C                   EVAL      PrBRCA = WkBRCA
 
     C                   ENDIF
 
     C                   MOVE      WkCNUM        RCNUM
     C                   MOVE      WkDLNO        RDEAL
     C                   MOVEA     AKY           RAKEY
     C                   EVAL      RCURR = WkCurr
 
      ** Retrieve the no. of decimal points
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WkCurr        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBASE =  006
     C                   EVAL      DBKEY =  WkCurr
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
 
      ** Format Amount
 
     C                   Z-ADD     WkAmt         PFLD15
     C                   Z-ADD     A6NBDP        PDECS
     C                   EVAL      PECODE = 'J'
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT22
     C                   PARM                    POUT25
     C                   EVAL      RAMNT = POut22
 
     C                   IF        *IN01 = *On
     C                   WRITE     HEADP1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF
 
     C                   MOVE      DKREVI        RREVI
 
     C                   WRITE     DETAIL
 
     C                   EVAL      WkNoRecB = WkNoRecB + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSumAkey - Account Key Summary                               *
      *                                                               *
      *****************************************************************
 
     C     SRSumAkey     BEGSR
 
     C                   EVAL      Ex = 1
     C                   DOW       Ex <= WEFV
 
      ** Generate Profit Account Key for Effective Fair Value Hedges
 
     C                   IF        TAmtEFVP(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyEFV(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'FIP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtEFVP(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
 
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Effective Fair Value Hedges
 
     C                   IF        TAmtEFVL(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyEFV(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'FIL'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtEFVL(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ex = Ex + 1
 
     C                   ENDDO
 
      ** Generate Profit Account Key for Effective Fair Value Hedges
 
     C                   EVAL      Ex = 1
     C                   DOW       Ex <= WFV2
 
     C                   IF        TAmtFVP2(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyFV2(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'FDP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtFVP2(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
 
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Effective Fair Value Hedges
 
     C                   IF        TAmtFVL2(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyFV2(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'FDL'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtFVL2(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ex = Ex + 1
 
     C                   ENDDO
 
     C                   EVAL      Ex = 1
     C                   DOW       Ex <= WECF
 
      ** Generate Profit Account Key for Effective Cash Flow Hedges
 
     C                   IF        TAmtECFP(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyECF(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'CIP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtECFP(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Effective Cash Flow Hedges
 
     C                   IF        TAmtECFL(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyECF(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'CIL'         AKY(8)
 
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtECFL(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ex = Ex + 1
 
     C                   ENDDO
 
      ** Generate Profit Account Key for Effective Cash Flow Hedges
 
     C                   EVAL      Ex = 1
     C                   DOW       Ex <= WCF2
 
     C                   IF        TAmtCFP2(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyCF2(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'CDP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtCFP2(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Effective Cash Flow Hedges
 
     C                   IF        TAmtCFL2(Ex) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyCF2(Ex)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'CDL'         AKY(8)
 
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtCFL2(Ex)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ex = Ex + 1
 
     C                   ENDDO
 
     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WIFV
 
      ** Generate Profit Account Key for Ineffective Fair Value Hedges
 
     C                   IF        TAmtIFVP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyIFV(Ix)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'FXP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtIFVP(Ix)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
 
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Ineffective Fair Value Hedges
 
     C                   IF        TAmtIFVL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyIFV(Ix)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'FXL'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtIFVL(Ix)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WICF
 
      ** Generate Profit Account Key for Ineffective Cash Flow Hedges
 
     C                   IF        TAmtICFP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyICF(Ix)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'CXP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtICFP(Ix)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Ineffective Cash Flow Hedges
 
     C                   IF        TAmtICFL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyICF(Ix)   WkAKeyDS
     C                   MOVEA     WkDtyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkDlst        AKY(4)
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
 
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'CXL'         AKY(8)
 
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtICFL(Ix)  WkAmt
     C                   EVAL      WkDLNO = *ZEROS
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
     C                   EVAL      Ix = 1                                                     CAS005
     C                   DOW       Ix <= WTFV                                                 CAS005
                                                                                              CAS005
      ** Generate Profit Account Key for Trading-Status Fair Value Hedges                     CAS005
                                                                                              CAS005
     C                   IF        TAmtTFVP(Ix) <> *ZEROS                                     CAS005
     C                   MOVE      *BLANKS       WkAKeyDS                                     CAS005
     C                   MOVEA     AKeyTFV(Ix)   WkAKeyDS                                     CAS005
     C                   MOVEA     WkDtyp        AKY(1)                                       CAS005
     C                   MOVE      'A'           AKY(3)                                       CAS005
     C                   MOVEA     WkDlst        AKY(4)                                       CAS005
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     WkBook        AKY(6)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   MOVEA     'FTP'         AKY(8)                                       CAS005
     C                   MOVEA     AKY           WkAkey                                       CAS005
     C                   Z-ADD     TAmtTFVP(Ix)  WkAmt                                        CAS005
     C                   EVAL      WkDLNO = *ZEROS                                            CAS005
     C**********         EVAL      WkCNUM = *ZEROS                                     CAS005 CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite                                                    CAS005
     C                   EXSR      SRReport                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Generate Loss Account Key for Trading-Status Fair Value Hedges                       CAS005
                                                                                              CAS005
     C                   IF        TAmtTFVL(Ix) <> *ZEROS                                     CAS005
     C                   MOVE      *BLANKS       WkAKeyDS                                     CAS005
     C                   MOVEA     AKeyTFV(Ix)   WkAKeyDS                                     CAS005
     C                   MOVEA     WkDtyp        AKY(1)                                       CAS005
     C                   MOVE      'A'           AKY(3)                                       CAS005
     C                   MOVEA     WkDlst        AKY(4)                                       CAS005
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
                                                                                              CAS005
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     WkBook        AKY(6)                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   MOVEA     'FTL'         AKY(8)                                       CAS005
                                                                                              CAS005
     C                   MOVEA     AKY           WkAkey                                       CAS005
     C                   Z-ADD     TAmtTFVL(Ix)  WkAmt                                        CAS005
     C                   EVAL      WkDLNO = *ZEROS                                            CAS005
     C**********         EVAL      WkCNUM = *ZEROS                                     CAS005 CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite                                                    CAS005
     C                   EXSR      SRReport                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EVAL      Ix = Ix + 1                                                CAS005
                                                                                              CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
     C                   EVAL      Ix = 1                                                     CAS005
     C                   DOW       Ix <= WTCF                                                 CAS005
                                                                                              CAS005
      ** Generate Profit Account Key for Trading-Status Cash Flow Hedges                      CAS005
                                                                                              CAS005
     C                   IF        TAmtTCFP(Ix) <> *ZEROS                                     CAS005
     C                   MOVE      *BLANKS       WkAKeyDS                                     CAS005
     C                   MOVEA     AKeyTCF(Ix)   WkAKeyDS                                     CAS005
     C                   MOVEA     WkDtyp        AKY(1)                                       CAS005
     C                   MOVE      'A'           AKY(3)                                       CAS005
     C                   MOVEA     WkDlst        AKY(4)                                       CAS005
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     WkBook        AKY(6)                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   MOVEA     'CTP'         AKY(8)                                       CAS005
     C                   MOVEA     AKY           WkAkey                                       CAS005
     C                   Z-ADD     TAmtTCFP(Ix)  WkAmt                                        CAS005
     C                   EVAL      WkDLNO = *ZEROS                                            CAS005
     C**********         EVAL      WkCNUM = *ZEROS                                     CAS005 CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite                                                    CAS005
     C                   EXSR      SRReport                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Generate Loss Account Key for Trading-Status Fair Value Hedges                       CAS005
                                                                                              CAS005
     C                   IF        TAmtTCFL(Ix) <> *ZEROS                                     CAS005
     C                   MOVE      *BLANKS       WkAKeyDS                                     CAS005
     C                   MOVEA     AKeyTCF(Ix)   WkAKeyDS                                     CAS005
     C                   MOVEA     WkDtyp        AKY(1)                                       CAS005
     C                   MOVE      'A'           AKY(3)                                       CAS005
     C                   MOVEA     WkDlst        AKY(4)                                       CAS005
     C                   MOVEA     WkClas        AKY(11)                                      CDL038
                                                                                              CAS005
     C                   IF        BNBCPL = 'Y'                                               CAS005
     C                   MOVEA     WkBook        AKY(6)                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   MOVEA     'CTL'         AKY(8)                                       CAS005
                                                                                              CAS005
     C                   MOVEA     AKY           WkAkey                                       CAS005
     C                   Z-ADD     TAmtTCFL(Ix)  WkAmt                                        CAS005
     C                   EVAL      WkDLNO = *ZEROS                                            CAS005
     C**********         EVAL      WkCNUM = *ZEROS                                     CAS005 CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite                                                    CAS005
     C                   EXSR      SRReport                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EVAL      Ix = Ix + 1                                                CAS005
                                                                                              CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdTrl - Update Trailer File                                *
      *                                                               *
      *****************************************************************
 
     C     SRUpdTrl      BEGSR
 
     C                   IF        BKAKSI = 'Y'
     C                   EXSR      SRSumAkey
     C                   EXSR      SREndRep
     C                   ENDIF
 
     C                   EVAL      DZNORE = WkNoRec
     C                   EVAL      DZHRWN = WkVlInt
     C                   EVAL      DZHRDC = WkVlDec
     C                   UPDATE    DKEYSZZF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndRep - Write the End of the Report                        *
      *                                                               *
      *****************************************************************
 
     C     SREndRep      BEGSR
 
      ** Format no. of records
 
     C                   Z-ADD     WkNoRecB      PFLD15
     C                   Z-ADD     0             PDECS
     C                   EVAL      PECODE = 'J'
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT22
     C                   PARM                    POUT25
     C                   MOVE      POut22        RNOREC
 
     C                   IF        *IN01 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
     C                   EVAL      *IN01 = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBranch - Acess Branch Details                               *
      *                                                               *
      *****************************************************************
 
     C     SRBranch      BEGSR
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WkBRCA        PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBRCHPD'
     C                   EVAL      DBKEY  =  WkBRCA
     C                   EVAL      DBASE  =  007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WkNoRecB = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Print Audit Report                                  *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZADD - Subroutine to add an amount to the total             *
      *                                                               *
      *****************************************************************
      *
     C     GLZADD        BEGSR
 
     C                   Z-ADD     ZZAMT         ZZAMT                    91
 
     C                   IF        *IN91 = *ON
     C                   GOTO      ZZAEND
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now
 
     C                   EXSR      GLZSUM
 
     C     ZZAEND        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
      *                                                               *
      *****************************************************************
 
     C     GLZSUM        BEGSR
 
     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
      ** Determine sign of ZZAMTI & D, 92 if neg.
 
     C     ZZAMTI        COMP      0                                    9293
 
     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      0                                    9293
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** Determine sign of ZZTOTI & D, 91 if neg.
 
     C     ZZTOTI        COMP      0                                    9193
 
     C                   IF        *IN93 = *ON
     C     ZZTOTD        COMP      0                                    9193
     C                   ENDIF
 
      ** If ZZTOTAL is zero, return ZZAMOUNT.
 
     C                   IF        *IN93 = *ON
     C                   Z-ADD     ZZAMTI        ZZTOTI
     C                   Z-ADD     ZZAMTD        ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** If signs differ bypass overflow checks.
 
     C                   IF        *IN91 = *ON AND
     C                             *IN92 = *OFF OR
     C                             *IN91 = *OFF AND
     C                             *IN92 = *ON
     C                   GOTO      ZZOFPS
     C                   ENDIF
 
     C     ZZAMTD        ADD       ZZTOTD        ZZWk2
     C     ZZWk2         COMP      999                                93
 
     C                   IF        *IN93 = *OFF
     C     ZZWk2         COMP      -999                                 93
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *OFF
     C     ZZAMTI        ADD       1             ZZWk3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *ON
     C     ZZAMTI        SUB       1             ZZWk3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        ADD       ZZWk3         ZZWk3
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWk3
     C                   ENDIF
 
      ** If the modulus of ZZWk3 is lt mod. ZZTOTI then O/F has occurred
 
     C                   IF        *IN92 = *OFF
     C     ZZWk3         COMP      ZZTOTI                               99
     C                   ENDIF
 
     C                   IF        *IN92 = *ON
     C     ZZWk3         COMP      ZZTOTI                             99
     C                   ENDIF
 
     C                   IF        *IN99 = *OFF
     C                   Z-ADD     ZZWk2         ZZTOTD
     C                   Z-ADD     ZZWk3         ZZTOTI
     C                   ENDIF
 
      ** If O/F zeroise ZZAMT, ind '99' set and ZZTOT fields left intact
 
     C                   IF        *IN99 = *ON
     C                   Z-ADD     0             ZZAMT
     C                   ENDIF
 
     C                   GOTO      ZZSEND
 
      ** The 'SIGNS' are different
 
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it pos. to comp with ZZTOT
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Both ZZAMT and ZZTOT are noe positive
 
     C     ZZTOTI        COMP      ZZAMTI                             93  95
 
     C                   IF        *IN95 = *ON
     C     ZZTOTD        COMP      ZZAMTD                             93  95
     C                   ENDIF
 
      ** If ZZTOT eq. ZZAMT return zero.
 
     C                   IF        *IN95 = *ON
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** If ZZTOT gt. ZZAMT.
 
     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      ZZTOTD                             94
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWk2
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *OFF
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZAMT gt. ZZTOT.
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTD        COMP      ZZAMTD                             94
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZAMTI        SUB       1             ZZWk3
     C     ZZAMTD        ADD       1000          ZZWk2
     C     ZZWk3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN91 = *ON OR
     C                             *IN93 = *OFF AND
     C                             *IN92 = *ON
     C                   EVAL      *IN94 = *ON
     C                   ENDIF
 
     C                   IF        *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore sign of ZZAMTI & ZZAMTD If It was reversed.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C     ZZSEND        TAG
 
      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
 
     C                   EVAL      *IN96 = *OFF
 
     C     ZZTOTD        COMP      0                                      91
 
     C                   IF        *IN91 = *ON
     C     ZZTOTI        COMP      0                                    96
     C                   ENDIF
 
     C                   IF        *IN96 = *ON
     C                   MOVE      '.000-'       ZZNEGD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkRCF - Ensure spool file recorded by RCF                  *
      *                                                               *
      *****************************************************************
 
     C     SRChkRCF      BEGSR
 
      ** Ensure Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM1        PZSNMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNMU
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkRCFA - Ensure Audit spool file recorded by RCF           *
      *                                                               *
      *****************************************************************
 
     C     SRChkRCFA     BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   Z-ADD     SFNUMU        PZSNMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNMU
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitEWV - Initialise Effective Work Variables               *
      *                                                               *
      *****************************************************************
 
     C     SRInitEWV     BEGSR
 
     C                   EVAL      WkPAmtEFV = *ZEROS
     C                   EVAL      WkLAmtEFV = *ZEROS
     C                   EVAL      WkSumEFV  = *ZEROS
     C                   EVAL      WkPAmtECF = *ZEROS
     C                   EVAL      WkLAmtECF = *ZEROS
     C                   EVAL      WkSumECF  = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitIWV - Initialise Ineffective Work Variables             *
      *                                                               *
      *****************************************************************
 
     C     SRInitIWV     BEGSR
 
     C                   EVAL      WkPAmtIFV = *ZEROS
     C                   EVAL      WkLAmtIFV = *ZEROS
     C                   EVAL      WkSumIFV  = *ZEROS
     C                   EVAL      WkPAmtICF = *ZEROS
     C                   EVAL      WkLAmtICF = *ZEROS
     C                   EVAL      WkSumICF  = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRInitTWV - Initialise Trading-Status Work Variables          *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRInitTWV     BEGSR                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WkPAmtTFV = *ZEROS                                         CAS005
     C                   EVAL      WkLAmtTFV = *ZEROS                                         CAS005
     C                   EVAL      WkSumTFV  = *ZEROS                                         CAS005
     C                   EVAL      WkPAmtTCF = *ZEROS                                         CAS005
     C                   EVAL      WkLAmtTCF = *ZEROS                                         CAS005
     C                   EVAL      WkSumTCF  = *ZEROS                                         CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      * SRForeTrn - Access Forecast transactions details file         *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRForeTrn     BEGSR                                                                CAS006
                                                                                              CAS006
     C*****HHFSDLNO      CHAIN     ASFHTRL1                                            CAS006 CLE148
     C                   MOVEL     HHFSDLNO      FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                                                   CLE148
                                                                                              CAS006
     C                   IF        %FOUND(ASFHTRL1)                                           CAS006
                                                                                              CAS006
     C                   EVAL      CCY = FHFSCCY                                              CAS006
     C                   IF        FHFSCCY = PUCY                                             CAS006
     C                   EVAL      WkUNRL = FSURPL                                            CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WkUNRL = FSSUPL                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Database Error Processing                                                            CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE =  'ASFHTRL1'                                       CAS006
     C                   MOVE      HHFSDLNO      DBKEY                                        CAS006
     C                   EVAL      DBASE  =  016                                              CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
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
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Dealing ICD file
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDDEALPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  009
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the General Ledger ICD file
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  010
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Midas Modules
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  011
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set on Indicator for Multi-Branching process
 
     C                   IF        BGMBIN = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
 
      ** Get the Event Control Date as the lesser between (Next Working Day - 1)
      ** and Accrual Profit Date
 
     C                   EVAL      WkEVCD = BJDNWD - 1
 
     C                   IF        BKAPDT < WkEVCD
     C                   EVAL      WkEVCD = BKAPDT
     C                   ENDIF
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    WkEVCD
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       REVCD
 
      ** Check for the Accrual Key Summary Indicator
 
     C                   IF        BKAKSI <> 'Y'
     C                   EVAL      *IN02 = *ON
     C                   ELSE
     C                   EVAL      *IN02 = *OFF
     C                   ENDIF
 
      ** Read Trailer file of DKEYSZZ
 
     C                   READ      DKEYSZZ
 
     C                   IF        %EOF(DKEYSZZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DKEYSZZ'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  012
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WkNoRec = DZNORE
     C                   EVAL      WkVlInt = DZHRWN
     C                   EVAL      WkVlDec = DZHRDC
     C                   ENDIF
                                                                                              CAS005
      ** Check if Enhancements for CAS001, CAS002 & CAS004 is installed                       CAS005
                                                                                              CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRetCode                                     CAS005
     C                   PARM      '*VERIFY'     POption                                      CAS005
     C                   PARM      'CAS005'      PSard                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRetCode = *BLANKS                                         CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   IF        PRetCode <> '*NRF   '                                      CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFile =  'SCSARDPD'                                       CAS005
     C                   EVAL      DBKey  =  'CAS005'                                         CAS005
     C                   EVAL      DBase  =  014                                              CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS006
      ** Check if Hedge Accounting Phase B is installed                                       CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRetCode = *BLANKS                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRetCode <> '*NRF   '                                      CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFile =  'SCSARDPD'                                       CAS006
     C                   EVAL      DBKey  =  'CAS006'                                         CAS006
     C                   EVAL      DBase  =  015                                              CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      ** RCF Processing for Audit File
 
     C*                  EXSR      SRChkRCFA
 
      ** Key List
 
     C     KTranF        KLIST
     C                   KFLD                    KMod
     C                   KFLD                    KDeal
 
     C                   EVAL      KMod = 'DL'
 
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
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
