     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge SE A/C Key Generation Program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000016 - Hedge SE Account Key Generation Program           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD025453           Date 21Mar16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 229209             Date 24Aug04               *
      *                 229154             Date 24Aug04               *
      *                 228103             Date 22Jun04               *
      *                 225301             Date 27Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025453 - Truncation error on event amount in SE2450P3.     *
      *             Recompiled due to changes in PF/SEKEYD.           *
      *           - Applied for MD-37439.                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  229209 -  Partially remove fix 225301 and fixes attached     *
      *            to it as this fixes are not applicable to SE       *
      *            module, hence causing posting errors.              *
      *  229154 -  Avoid processing transactions whose securities     *
      *            position is zero by removing database error.       *
      *  228103 - Use net treasury instead of all in rate profit/loss *
      *           in generating effective/ineffective account keys.   *
      *  225301 - Wrong reversal amounts posted.                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Overflow Indicator                              *
      *    02         Account Key Summary Indicator                   *
      *    89         Look Up Indicator                               *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess   - Process each record read                       *
      *  SRLiveHdg   - Process Live Hedge Item                        *
      *  SRDelHdg    - Process Deleted Hedge Item                     *
      *  SRRevPost   - Generate a reversal posting for the remainder  *
      *  SRHedge     - Check if the position is a hedged item         *
      *  SRGenKeyEFV - Generate Account Key for Effective Fair Value  *
      *                Hedges                                         *
      *  SRGenKeyIFV - Generate Account Key for Ineffective Fair      *
      *                Value Hedges                                   *
      *  SRGenKeyECF - Generate Account Key for Effective Cash Flow   *
      *                Hedges                                         *
      *  SRGenKeyICF - Generate Account Key for Ineffective Cash Flow *
      *                Hedges                                         *
      *  SRWrite     - Write a record to SEKEYD                       *
      *  SRReport    - Write a Report                                 *
      *  SRSumAkey   - Generate Summary of Account Key                *
      *  SRUpdTrl    - Update Trailer File                            *
      *  SREndRep    - Write the End of the Report                    *
      *  SRBranch    - Access to AOBRCHR0                             *
      *  SRPosDet    - Access Positions Details                       *
      *  SRSecurity  - Access Security Details                        *
      *  SRInvest    - Access to Investment Types file                *
      *  SRProfitCtr - Access to Book-Profit Centre Matrix            *
      *  SRAudit     - Audit Report                                   *
      *  SRChkRCF    - Register the P1 Printer File via RCF           *
      *  SRChkRCFA   - Register the AU Printer File via RCF           *
      *                                                               *
      *  SRHASH - Subroutine to add an amount to the total            *
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
 
      ** Midas SE Book Positions Header File
     FBKPHD     UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Book Positions Header File
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PS)
 
      ** Midas SE Book Positions Profit Centre File
     FSEPCBD    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SN)
 
      ** Midas AS Hedge Linkage File Update by Hedge ID
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HL:2)
 
      ** Midas AS Hedge Transaction File Retrieval
     FASHTRNLG  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Hedge Strategy by Shortname
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SD:2)
 
      ** Midas Security Details by Security
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE)
 
      ** Midas SE Security Account Keys Detail
     FSEKEYD    O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(LK)
 
      ** Midas SE Security Account Keys Trailer
     FSEKEYA    UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LZ)
                                                                                              228103
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)                                       228103
 
     FAS000016P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN01)
 
     FAS000016AUO    E             PRINTER INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
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
 
      ** File Information Data Structure for AS000016P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS000016AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SE Trading ICD data
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Currency Data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for investment types
     D SDINVT        E DS                  EXTNAME(INVTPD) PREFIX(IN)
 
      ** External DS for Book-Profit Centre Matrix
     D SDBKPC        E DS                  EXTNAME(SDBKPCPD)
 
      ** External DS for Switchable Features File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY) PREFIX(DS)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSSDY) PREFIX(DF)
 
      ** Account Key Data Structure
     D WkAKeyDS        DS
     D  WkBRCA                 1      3
     D  WkCurr                 4      6
     D  WkInvt                 7      9
     D  WkBook                13     14
     D  WkAcky                 7     26
     D  WkRvrs                27     27
 
      ** Account Key
     D AKY             S              1A   DIM(20)
     D AKey            S              1A   DIM(27)
 
     D AKeyEFV         S             27A   DIM(500)
     D AKeyECF         S             27A   DIM(500)
     D AKeyIFV         S             27A   DIM(500)
     D AKeyICF         S             27A   DIM(500)
     D TAmtEFVL        S             13  0 DIM(500)
     D TAmtEFVP        S             13  0 DIM(500)
     D TAmtECFL        S             13  0 DIM(500)
     D TAmtECFP        S             13  0 DIM(500)
     D TAmtIFVL        S             13  0 DIM(500)
     D TAmtIFVP        S             13  0 DIM(500)
     D TAmtICFL        S             13  0 DIM(500)
     D TAmtICFP        S             13  0 DIM(500)
 
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
     D PSard           S              6
     D PCurr           S              3
     D PBook           S              2
     D PPsBook         S              2
     D PProfit         S              4
     D PInvest         S              3
     D PBranch         S              3
 
     D WkNoRec         S              5  0
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
     D WkNoRecB        S              5  0
 
     D WkAmt           S             15  0
     D WkEVCD          S              5  0
     D WkAkey          S             20
     D ChkKey          S             27
 
     D WRun            S              1
     D WkDelFlg        S              1
 
     D WkPAmtEFV       S             15  0
     D WkLAmtEFV       S             15  0
     D WkPAmtECF       S             15  0
     D WkLAmtECF       S             15  0
     D WkSumEFV        S             15  0
     D WkSumECF        S             15  0
     D WkPAmtIFV       S             15  0
     D WkLAmtIFV       S             15  0
     D WkPAmtICF       S             15  0
     D WkLAmtICF       S             15  0
     D WkSumIFV        S             15  0
     D WkSumICF        S             15  0
     D WkFSEFUP        S                   LIKE(FSEFUP)
     D WkFSECUP        S                   LIKE(FSECUP)
     D WkFSXFUP        S                   LIKE(FSXFUP)
     D WkFSXCUP        S                   LIKE(FSXCUP)
 
      ** Index for Fair Value Hedges and Cash Flow Hedges
     D WEFV            S              3  0 INZ(0)
     D WECF            S              3  0 INZ(0)
     D WIFV            S              3  0 INZ(0)
     D WICF            S              3  0 INZ(0)
 
     D Ix              S              3  0
 
      ** Key Fields
     D KMOD            S              2
     D KBHSC           S             10
     D KBHBA           S              3
     D KBHBK           S              2
     D KBHMK           S              1
     D KBHTV           S              1
     D KLPSD           S              5  0
 
     D PrBRCA          S              3
 
      ** Fields used in SRHASH
     D WHAMT           S             15  3
     D WHAMTI          S             15  0
     D WHAMTD          S              3  0
 
     D ZDATE           S              6  0
 
      ** Switchable Features
     D CAC005          S              1
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
 
      ** Read all records from Book Positions Header file
 
     C                   READ      BKPHD
 
      ** Check if End of file, produce audit report if end of file
      ** If not, ensure report spool file recorded by RCF
 
     C                   IF        %EOF(BKPHD)
     C                   EXSR      SRAudit
     C                   ELSE
 
     C                   EVAL      WkBRCA = BHBA
     C                   EXSR      SRBranch
     C                   EXSR      SRChkRCF
 
     C                   DOW       NOT %EOF(BKPHD)
 
     C                   EXSR      SRPosDet
     C                   EXSR      SRSecurity
     C                   EXSR      SRInvest
     C                   IF        BGN0ST = 'Y'
     C                   EXSR      SRProfitCtr
     C                   ENDIF
 
      ** Process each record
 
     C                   EXSR      SRProcess
 
     C                   READ      BKPHD
     C                   ENDDO
 
      ** Write End of Report
 
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
      *  SRProcess - Process each record read                         *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   EVAL      WkPAmtEFV = *ZEROS
     C                   EVAL      WKLAmtEFV = *ZEROS
     C                   EVAL      WkPAmtIFV = *ZEROS
     C                   EVAL      WKLAmtIFV = *ZEROS
     C                   EVAL      WkPAmtECF = *ZEROS
     C                   EVAL      WKLAmtECF = *ZEROS
     C                   EVAL      WkPAmtICF = *ZEROS
     C                   EVAL      WKLAmtICF = *ZEROS
     C                   EVAL      WkSumEFV  = *ZEROS
     C                   EVAL      WkSumECF  = *ZEROS
     C                   EVAL      WkSumIFV  = *ZEROS
     C                   EVAL      WkSumICF  = *ZEROS
     C                   EVAL      LKRVRS = '0'
     C                   EVAL      KBHSC = BHSC
     C                   EVAL      KBHBA = BHBA
     C                   EVAL      KBHBK = BHBK
     C                   EVAL      KBHMK = BHMK
     C                   EVAL      KBHTV = BHTV
     C                   EVAL      WKBrca = BHBA
     C                   EVAL      WkFSEFUP = FSEFUP
     C                   EVAL      WkFSECUP = FSECUP
     C                   EVAL      WkFSXFUP = FSXFUP
     C                   EVAL      WkFSXCUP = FSXCUP
 
      ** If Book position has matured RECI <> 'D', generate reversal a/c key
 
     C                   IF        RECI <> 'D'
 
      ** Set on the reversal indicator
 
     C                   EVAL      LKRVRS = '1'
 
      ** Effective Fair Value Hedge Unrealized Profit/Loss Posted, generate
      ** account key with positive value
 
     C                   IF        WkFSEFUP < 0
     C                   Z-SUB     WkFSEFUP      WkLAmtEFV
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > 0
     C                   Z-ADD     WkFSEFUP      WkPAmtEFV
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss in BKPHDD
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Effective Cash Flow Hedge Unrealized Profit/Loss Posted, generate
      ** account key with a positive value
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtECF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtECF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Loss in BKPHDD
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Ineffective Fair Value Hedge Unrealized Profit/Loss Posted, generate
      ** account key with positive value
 
     C                   IF        WkFSXFUP < 0
     C                   Z-SUB     WkFSXFUP      WkLAmtIFV
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        WkFSXFUP > 0
     C                   Z-ADD     WkFSXFUP      WkPAmtIFV
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ** Update the Ineffective Fair Value Hedge Unrealized Profit/Loss in BKPHDD
 
     C                   EVAL      FSXFUP = *ZEROS
 
      ** Ineffective Cash Flow Hedge Unrealized Profit/Loss Posted, generate
      ** account key with a positive value
 
     C                   IF        WkFSXCUP < 0
     C                   Z-SUB     WkFSXCUP      WkLAmtICF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        WkFSXCUP > 0
     C                   Z-ADD     WkFSXCUP      WkPAmtICF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit Loss in BKPHDD
 
     C                   EVAL      FSXCUP = *ZEROS
     C                   ENDIF
 
      ** If Book position is a live transaction
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      WkDelFlg = 'N'
 
      ** Check if the position was partially deleted or not
 
     C     KTranF        SETLL     ASHTRNLG
     C     KTranF        READE     ASHTRNLG
 
     C                   DOW       NOT %EOF(ASHTRNLG) AND WkDelFlg <> 'Y'
     C                   IF        FSHTCT = 'D' AND FSHTCD <= WkEVCD AND
     C                             FSHTCD >= BJRDNB
     C                   EVAL      WkDelFlg = 'Y'
     C                   ENDIF
     C     KTranF        READE     ASHTRNLG
     C                   ENDDO
 
      ** If position is not a deleted as a SE hedged item today
 
     C                   IF        WkDelFlg = 'N'
     C                   EXSR      SRLiveHdg
     C                   ENDIF
 
      ** If position or a portion of it was deleted today as a SE hedged item
 
     C                   IF        WkDelFlg = 'Y'
     C     KTranF        SETLL     ASHTRNLG
     C     KTranF        READE     ASHTRNLG
 
     C                   DOW       NOT %EOF(ASHTRNLG)
 
     C                   IF        FSHTCT = 'D' AND FSHTCD <= WkEVCD AND
     C                             FSHTCD >= BJRDNB
     C                   EXSR      SRDelHdg
     C                   ENDIF
 
     C     KTranF        READE     ASHTRNLG
 
      ** Generate Reversal posting for the remainder of the unrealized
      ** profit/loss posted
 
     C                   IF        %EOF(ASHTRNLG)
     C                   EXSR      SRRevPost
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** Generate the Hedge Portion
 
     C                   EXSR      SRHedge
     C                   ENDIF
 
      ** Update BKPHDD
 
     C                   EVAL      FSEFUP = WkSumEFV
     C                   EVAL      FSECUP = WkSumECF
     C                   EVAL      FSXFUP = WkSumIFV
     C                   EVAL      FSXCUP = WkSumICF
     C                   UPDATE    BKPHDDF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLiveHdg - Process Live Hedge Item                           *
      *                                                               *
      *****************************************************************
 
     C     SRLiveHdg     BEGSR
 
     C                   EVAL      LKRVRS = '0'
 
      ** Effective Fair Value Hedge Unrealized Profit/Loss Posted, generate
      ** account key with negative value
 
     C**********         IF        WkFSEFUP < 0                                               225301
     C**********         Z-ADD     WkFSEFUP      WkLAmtEFV                                    225301
     C                   IF        WkFSEFUP < 0                                               229209
     C                   Z-ADD     WkFSEFUP      WkLAmtEFV                                    229209
     C**********         IF        FSEFVP < 0                                          225301 229209
     C**********         Z-ADD     FSEFVP        WkLAmtEFV                             225301 229209
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C**********         IF        WkFSEFUP > 0                                               225301
     C**********         Z-SUB     WkFSEFUP      WkPAmtEFV                                    225301
     C                   IF        WkFSEFUP > 0                                               229209
     C                   Z-SUB     WkFSEFUP      WkPAmtEFV                                    229209
     C**********         IF        FSEFVP > 0                                          225301 229209
     C**********         Z-SUB     FSEFVP        WkPAmtEFV                             225301 229209
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*BKPHDD               225301
      **********                                                                              225301
     C**********         EVAL      FSEFUP = *ZEROS                                            225301
     C                   EVAL      FSEFUP = *ZEROS                                            229209
 
      ** Effective Cash Flow Hedge Unrealized Profit/Loss Posted, generate
      ** account key with a negative value
 
     C**********         IF        WkFSECUP < 0                                               225301
     C**********         Z-ADD     WkFSECUP      WkLAmtECF                                    225301
     C                   IF        WkFSECUP < 0                                               229209
     C                   Z-ADD     WkFSECUP      WkLAmtECF                                    229209
     C**********         IF        FSHECP < 0                                          225301 229209
     C**********         Z-ADD     FSHECP        WkLAmtECF                             225301 229209
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C**********         IF        WkFSECUP > 0                                               225301
     C**********         Z-SUB     WkFSECUP      WkPAmtECF                                    225301
     C                   IF        WkFSECUP > 0                                               229209
     C                   Z-SUB     WkFSECUP      WkPAmtECF                                    229209
     C**********         IF        FSHECP > 0                                          225301 229209
     C**********         Z-SUB     FSHECP        WkPAmtECF                             225301 229209
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*BKPHDD                225301
      **********                                                                              225301
     C**********         EVAL      FSECUP = *ZEROS                                            225301
     C                   EVAL      FSECUP = *ZEROS                                            229209
 
      ** Ineffective Fair Value Hedge Unrealized Profit/Loss Posted, generate
      ** account key with negative value
 
     C**********         IF        WkFSXFUP < 0                                               225301
     C**********         Z-ADD     WkFSXFUP      WkLAmtIFV                                    225301
     C                   IF        WkFSXFUP < 0                                               229209
     C                   Z-ADD     WkFSXFUP      WkLAmtIFV                                    229209
     C**********         IF        FSHXFP < 0                                          225301 229209
     C**********         Z-ADD     FSHXFP        WkLAmtIFV                             225301 229209
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C**********         IF        WkFSXFUP > 0                                               225301
     C**********         Z-SUB     WkFSXFUP      WkPAmtIFV                                    225301
     C                   IF        WkFSXFUP > 0                                               229209
     C                   Z-SUB     WkFSXFUP      WkPAmtIFV                                    229209
     C**********         IF        FSHXFP > 0                                          225301 229209
     C**********         Z-SUB     FSHXFP        WkPAmtIFV                             225301 229209
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
      ***Update*the*Ineffective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*BKPHDD             225301
      **********                                                                              225301
     C**********         EVAL      FSXFUP = *ZEROS                                            225301
     C                   EVAL      FSXFUP = *ZEROS                                            229209
 
      ** Ineffective Cash Flow Hedge Unrealized Profit/Loss Posted, generate
      ** account key with a negative value
 
     C**********         IF        WkFSXCUP < 0                                               225301
     C**********         Z-ADD     WkFSXCUP      WkLAmtICF                                    225301
     C                   IF        WkFSXCUP < 0                                               229209
     C                   Z-ADD     WkFSXCUP      WkLAmtICF                                    229209
     C**********         IF        FSHXCP < 0                                          225301 229209
     C**********         Z-ADD     FSHXCP        WkLAmtICF                             225301 229209
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C**********         IF        WkFSXCUP > 0                                               225301
     C**********         Z-SUB     WkFSXCUP      WkPAmtICF                                    225301
     C                   IF        WkFSXCUP > 0                                               229209
     C                   Z-SUB     WkFSXCUP      WkPAmtICF                                    229209
     C**********         IF        FSHXCP > 0                                          225301 229209
     C**********         Z-SUB     FSHXCP        WkPAmtICF                             225301 229209
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*BKPHDD                225301
      **********                                                                              225301
     C**********         EVAL      FSXCUP = *ZEROS                                            225301
     C                   EVAL      FSXCUP = *ZEROS                                            229209
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelHdg - Process Deleted Hedge Item                         *
      *                                                               *
      *****************************************************************
 
     C     SRDelHdg      BEGSR
 
     C                   EVAL      LKRVRS = '1'
 
      ** Generate the following account key with a positive amount for
      ** the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss
 
     C                   IF        FSEFVP < *ZEROS
     C                   Z-SUB     FSEFVP        WkLAmtEFV
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   IF        FSEFVP > *ZEROS
     C                   Z-ADD     FSEFVP        WkPAmtEFV
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
 
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
 
      ** Update the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSEFVP = *ZEROS
 
      ** Generate the following account key with a positive amount for
      ** the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss
 
     C                   IF        FSHECP  < *ZEROS
     C                   Z-SUB     FSHECP        WkLAmtECF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   IF        FSHECP  > *ZEROS
     C                   Z-ADD     FSHECP        WkPAmtECF
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
 
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
 
      ** Update the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHECP = *ZEROS
 
      ** Generate the following account key with a positive amount for
      ** the Hedge Transaction Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss
 
     C                   IF        FSHXFP < *ZEROS
     C                   Z-SUB     FSHXFP        WkLAmtIFV
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   IF        FSHXFP > *ZEROS
     C                   Z-ADD     FSHXFP        WkPAmtIFV
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
 
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
 
      ** Update the Hedge Transaction Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHXFP = *ZEROS
 
      ** Generate the following account key with a positive amount for
      ** the Hedge Transaction Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss
 
     C                   IF        FSHXCP  < *ZEROS
     C                   Z-SUB     FSHXCP        WkLAmtICF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   IF        FSHXCP  > *ZEROS
     C                   Z-ADD     FSHXCP        WkPAmtICF
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
 
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
 
      ** Update the Hedge Transaction Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHXCP = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevPost - Generate a reversal posting for the remainder     *
      *                                                               *
      *****************************************************************
 
     C     SRRevPost     BEGSR
 
      ** Generate the following account key with a negative amount
      ** Posting amount would be the Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSEFVP
 
     C                   IF        WkFSEFUP < *ZEROS
     C                   EVAL      WkLAmtEFV = WkFSEFUP - WkSumEFV
     C                   IF        WkLAmtEFV <> *ZEROS
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkFSEFUP > *ZEROS
     C                   EVAL      WkPAmtEFV = WkFSEFUP - WkSumEFV
     C                   Z-SUB     WkPAmtEFV     WkPAmtEFV
     C                   IF        WkPAmtEFV <> *ZEROS
     C                   EXSR      SRGenKeyEFV
     C                   ENDIF
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in BKPHDD
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate the following account key with a negative amount
      ** Posting amount would be the Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP
 
     C                   IF        WkFSECUP < *ZEROS
     C                   EVAL      WkLAmtECF = WkFSECUP - WkSumECF
     C                   IF        WkLAmtECF <> *ZEROS
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkFSECUP > *ZEROS
     C                   EVAL      WkPAmtECF = WkFSECUP - WkSumECF
     C                   Z-SUB     WkPAmtECF     WkPAmtECF
     C                   IF        WkPAmtECF <> *ZEROS
     C                   EXSR      SRGenKeyECF
     C                   ENDIF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in BKPHDD
 
     C                   EVAL      FSECUP = *ZEROS
 
      ** Generate the following account key with a negative amount
      ** Posting amount would be the Ineffective Fair Value Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHXFP
 
     C                   IF        WkFSXFUP < *ZEROS
     C                   EVAL      WkLAmtIFV = WkFSXFUP - WkSumIFV
     C                   IF        WkLAmtIFV <> *ZEROS
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkFSXFUP > *ZEROS
     C                   EVAL      WkPAmtIFV = WkFSXFUP - WkSumIFV
     C                   Z-SUB     WkPAmtIFV     WkPAmtIFV
     C                   IF        WkPAmtIFV <> *ZEROS
     C                   EXSR      SRGenKeyIFV
     C                   ENDIF
     C                   ENDIF
 
      ** Update the Ineffective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in BKPHDD
 
     C                   EVAL      FSXFUP = *ZEROS
 
      ** Generate the following account key with a negative amount
      ** Posting amount would be the Ineffective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHXCP
 
     C                   IF        WkFSXCUP < *ZEROS
     C                   EVAL      WkLAmtICF = WkFSXCUP - WkSumICF
     C                   IF        WkLAmtICF <> *ZEROS
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkFSXCUP > *ZEROS
     C                   EVAL      WkPAmtICF = WkFSXCUP - WkSumICF
     C                   Z-SUB     WkPAmtICF     WkPAmtICF
     C                   IF        WkPAmtICF <> *ZEROS
     C                   EXSR      SRGenKeyICF
     C                   ENDIF
     C                   ENDIF
 
      ** Update the Ineffective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in BKPHDD
 
     C                   EVAL      FSXCUP = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedge - Check if the position is a hedged item              *
      *                                                               *
      *****************************************************************
 
     C     SRHedge       BEGSR
 
     C                   EVAL      WkPAmtEFV = *ZEROS
     C                   EVAL      WKLAmtEFV = *ZEROS
     C                   EVAL      WkPAmtECF = *ZEROS
     C                   EVAL      WkLAmtECF = *ZEROS
     C                   EVAL      WkSumEFV  = *ZEROS
     C                   EVAL      WkSumECF  = *ZEROS
     C                   EVAL      WkPAmtIFV = *ZEROS
     C                   EVAL      WKLAmtIFV = *ZEROS
     C                   EVAL      WkPAmtICF = *ZEROS
     C                   EVAL      WkLAmtICF = *ZEROS
     C                   EVAL      WkSumIFV  = *ZEROS
     C                   EVAL      WkSumICF  = *ZEROS
     C                   EVAL      LKRVRS   = '0'
 
     C     KTranF        SETLL     ASHTRNLG
     C     KTranF        READE     ASHTRNLG
 
     C                   IF        %EOF(ASHTRNLG)
     C                   GOTO      EndSRHedge
     C                   ENDIF
 
      ** Check if Hedge is Effective
 
     C                   DOW       NOT %EOF(ASHTRNLG)
 
     C                   IF        FSHTID = 'D'
     C     FSHEDI        CHAIN     ASHGLKL1
     C                   IF        %FOUND(ASHGLKL1)
 
      ** Obtain the Hedge Product Type
 
     C     HLHGST        CHAIN     SDHGSTL1
 
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHGSTPD'
     C                   EVAL      DBKEY  =  HLHGST
     C                   EVAL      DBASE  =  7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if the position is partially hedge, calculate the hedge portion
 
      *                                                                                       228103
     C                   EVAL      SEURPL   = 0                                               229154
     C     KSEMKVL       CHAIN     SEMKVLL0                                                   228103
     C**********         IF        NOT %FOUND(SEMKVLL0)                                228103 229154
     C******LOCK         IN        LDA                                                 228103 229154
     C**********         EVAL      DBFILE =  'SEMKVLL0'                                228103 229154
     C**********         EVAL      DBKEY  =  BHSC + BHBA + BHBK + BHMK + BHTV          228103 229154
     C**********         EVAL      DBASE  =  8                                         228103 229154
     C**********         OUT       LDA                                                 228103 229154
     C**********         EXSR      *PSSR                                               228103 229154
     C**********         ENDIF                                                         228103 229154
      *                                                                                       228103
     C                   IF        FSPCTG < 100
     C**********         EVAL      WkAmt = UPPT * FSPCTG / 100                                228103
     C                   EVAL      WkAmt = SEURPL * FSPCTG / 100                              228103
     C                   ELSE
     C**********         EVAL      WkAmt = UPPT                                               228103
     C                   EVAL      WkAmt = SEURPL                                             228103
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is less than zero
 
     C**********         IF        UPPT < 0                                                   228103
     C                   IF        SEURPL < 0                                                 228103
 
      ** Generate Account Key and set the amount of FSEFUP/FSECUP/FSXFUP/FSXCUP
      ** in BKPHDD with negative amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
 
      ** Effective FV
 
     C                   IF        HLRECI = 'D'
     C                   Z-SUB     WkAmt         WkLAmtEFV
 
     C                   EXSR      SRGenKeyEFV
 
     C                   Z-SUB     WkAmt         FSEFVP
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
     C                   ENDIF
 
      ** Ineffective FV
 
     C                   IF        HLRECI = 'X'
     C                   Z-SUB     WkAmt         WkLAmtIFV
 
     C                   EXSR      SRGenKeyIFV
 
     C                   Z-SUB     WkAmt         FSHXFP
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
     C                   ENDIF
 
     C                   WHEN      SDPRTP = 'CF'
 
      ** Effective CF
 
     C                   IF        HLRECI = 'D'
     C                   Z-SUB     WkAmt         WkLAmtECF
 
     C                   EXSR      SRGenKeyECF
 
     C                   Z-SUB     WkAmt         FSHECP
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDIF
 
      ** Ineffective CF
 
     C                   IF        HLRECI = 'X'
     C                   Z-SUB     WkAmt         WkLAmtICF
 
     C                   EXSR      SRGenKeyICF
 
     C                   Z-SUB     WkAmt         FSHXCP
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C**********         IF        UPPT > 0                                                   228103
     C                   IF        SEURPL > 0                                                 228103
 
      ** Generate Account Key and set the amount of FSEFUP/FSECUP/FSXFUP/FSXCUP
      ** in BKPHDD with positive amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
 
      ** Effective FV
 
     C                   IF        HLRECI = 'D'
     C                   Z-ADD     WkAmt         WkPAmtEFV
 
     C                   EXSR      SRGenKeyEFV
 
     C                   Z-ADD     WkAmt         FSEFVP
     C                   EVAL      WkSumEFV = WkSumEFV + FSEFVP
     C                   ENDIF
 
      ** Ineffective FV
 
     C                   IF        HLRECI = 'X'
     C                   Z-ADD     WkAmt         WkPAmtIFV
 
     C                   EXSR      SRGenKeyIFV
 
     C                   Z-ADD     WkAmt         FSHXFP
     C                   EVAL      WkSumIFV = WkSumIFV + FSHXFP
     C                   ENDIF
 
     C                   WHEN      SDPRTP = 'CF'
 
      ** Effective CF
 
     C                   IF        HLRECI = 'D'
     C                   Z-ADD     WkAmt         WkPAmtECF
 
     C                   EXSR      SRGenKeyECF
 
     C                   Z-ADD     WkAmt         FSHECP
     C                   EVAL      WkSumECF = WkSumECF + FSHECP
     C                   ENDIF
 
      ** Ineffective CF
 
     C                   IF        HLRECI = 'X'
     C                   Z-ADD     WkAmt         WkPAmtICF
 
     C                   EXSR      SRGenKeyICF
 
     C                   Z-ADD     WkAmt         FSHXCP
     C                   EVAL      WkSumICF = WkSumICF + FSHXCP
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0
     C     KTranF        READE     ASHTRNLG
     C                   ENDDO
 
     C     EndSRHedge    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyEFV - Generate Account Key for Effective Fair Value   *
      *               Hedges                                          *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyEFV   BEGSR
 
      ** Set up account key
 
     C                   MOVEA     INVT          AKY(1)
     C                   MOVEA     'A'           AKY(4)
     C                   MOVEA     BHBK          AKY(7)
     C                   MOVEA     BHTV          AKY(9)
     C                   MOVEA     BHMK          AKY(13)
     C                   IF        BVCIAK = 'Y' AND SESCVI = 'Y'
     C                   MOVEA     SESCVI        AKY(14)
     C                   ELSE
     C                   MOVEA     *BLANK        AKY(14)
     C                   ENDIF
 
     C                   IF        PSNPSN >= 0 OR BVNPAC = 'N'
     C                   MOVEA     *BLANK        AKY(15)
     C                   ELSE
     C                   MOVEA     'N'           AKY(15)
     C                   ENDIF
 
     C                   IF        WkLAmtEFV <> *ZEROS
     C                   MOVEA     'FIL'         AKY(18)
     C                   Z-ADD     WkLAmtEFV     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtEFV <> *ZEROS
     C                   MOVEA     'FIP'         AKY(18)
     C                   Z-ADD     WkPAmtEFV     WkAmt
     C                   ENDIF
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per book position record
 
     C                   IF        BKAKSI <> 'Y'
 
     C                   MOVEA     AKY           WkAkey
 
      ** Write to Report
 
     C                   IF        WkLAmtEFV <> *ZEROS OR
     C                             WkPAmtEFV <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accrual Key Summary Required Indicator is on, store
      ** totals
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BHBA          AKEY(1)
     C                   MOVEA     NCRY          AKEY(4)
     C                   MOVEA     AKY           AKEY(7)
     C                   MOVEA     LKRVRS        AKEY(27)
 
     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyEFV(Ix)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtEFV     TAmtEFVL(Ix)
     C                   ADD       WkPAmtEFV     TAmtEFVP(Ix)
     C                   ELSE
     C                   EVAL      WEFV = WEFV + 1
     C                   MOVEA     AKey          AKeyEFV(WEFV)
     C                   Z-ADD     WkLAmtEFV     TAmtEFVL(WEFV)
     C                   Z-ADD     WkPAmtEFV     TAmtEFVP(WEFV)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyIFV - Generate Account Key for Ineffective Fair Value *
      *               Hedges                                          *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyIFV   BEGSR
 
      ** Setup account key
 
     C                   MOVEA     INVT          AKY(1)
     C                   MOVEA     'A'           AKY(4)
     C                   MOVEA     BHBK          AKY(7)
     C                   MOVEA     BHTV          AKY(9)
     C                   MOVEA     BHMK          AKY(13)
     C                   IF        BVCIAK = 'Y' AND SESCVI = 'Y'
     C                   MOVEA     SESCVI        AKY(14)
     C                   ELSE
     C                   MOVEA     *BLANK        AKY(14)
     C                   ENDIF
 
     C                   IF        PSNPSN >= 0 OR BVNPAC = 'N'
     C                   MOVEA     *BLANK        AKY(15)
     C                   ELSE
     C                   MOVEA     'N'           AKY(15)
     C                   ENDIF
 
     C                   IF        WkLAmtIFV <> *ZEROS
     C                   MOVEA     'FXL'         AKY(18)
     C                   Z-ADD     WkLAmtIFV     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtIFV <> *ZEROS
     C                   MOVEA     'FXP'         AKY(18)
     C                   Z-ADD     WkPAmtIFV     WkAmt
     C                   ENDIF
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per book position record
 
     C                   IF        BKAKSI <> 'Y'
 
     C                   MOVEA     AKY           WkAkey
 
      ** Write to Report
 
     C                   IF        WkLAmtIFV <> *ZEROS OR
     C                             WkPAmtIFV <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accrual Key Summary Required Indicator is on, store
      ** totals
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BHBA          AKEY(1)
     C                   MOVEA     NCRY          AKEY(4)
     C                   MOVEA     AKY           AKEY(7)
     C                   MOVEA     LKRVRS        AKEY(27)
 
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
      *               Hedges                                          *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyECF   BEGSR
 
      ** Setup account key
 
     C                   MOVEA     INVT          AKY(1)
     C                   MOVEA     'A'           AKY(4)
     C                   MOVEA     BHBK          AKY(7)
     C                   MOVEA     BHTV          AKY(9)
     C                   MOVEA     BHMK          AKY(13)
     C                   IF        BVCIAK = 'Y' AND SESCVI = 'Y'
     C                   MOVEA     SESCVI        AKY(14)
     C                   ELSE
     C                   MOVEA     *BLANK        AKY(14)
     C                   ENDIF
 
     C                   IF        PSNPSN >= 0 OR BVNPAC = 'N'
     C                   MOVEA     *BLANK        AKY(15)
     C                   ELSE
     C                   MOVEA     'N'           AKY(15)
     C                   ENDIF
 
     C                   IF        WkLAmtECF <> *ZEROS
     C                   MOVEA     'CIL'         AKY(18)
     C                   Z-ADD     WkLAmtECF     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtECF <> *ZEROS
     C                   MOVEA     'CIP'         AKY(18)
     C                   Z-ADD     WkPAmtECF     WkAmt
     C                   ENDIF
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per book position record
 
     C                   IF        BKAKSI <> 'Y'
 
     C                   MOVEA     AKY           WkAkey
 
      ** Write to Report
 
     C                   IF        WkLAmtECF <> *ZEROS OR
     C                             WkPAmtECF <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accrual Key Summary Required Indicator is on, store
      ** totals
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BHBA          AKEY(1)
     C                   MOVEA     NCRY          AKEY(4)
     C                   MOVEA     AKY           AKEY(7)
     C                   MOVEA     LKRVRS        AKEY(27)
 
     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyECF(Ix)                            89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtECF     TAmtECFL(Ix)
     C                   ADD       WkPAmtECF     TAmtECFP(Ix)
     C                   ELSE
     C                   EVAL      WECF = WECF + 1
     C                   MOVEA     AKey          AKeyECF(WECF)
     C                   Z-ADD     WkLAmtECF     TAmtECFL(WECF)
     C                   Z-ADD     WkPAmtECF     TAmtECFP(WECF)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyICF - Generate Account Key for Ineffective Cash Flow  *
      *               Hedges                                          *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyICF   BEGSR
 
      ** Setup account key
 
     C                   MOVEA     INVT          AKY(1)
     C                   MOVEA     'A'           AKY(4)
     C                   MOVEA     BHBK          AKY(7)
     C                   MOVEA     BHTV          AKY(9)
     C                   MOVEA     BHMK          AKY(13)
     C                   IF        BVCIAK = 'Y' AND SESCVI = 'Y'
     C                   MOVEA     SESCVI        AKY(14)
     C                   ELSE
     C                   MOVEA     *BLANK        AKY(14)
     C                   ENDIF
 
     C                   IF        PSNPSN >= 0 OR BVNPAC = 'N'
     C                   MOVEA     *BLANK        AKY(15)
     C                   ELSE
     C                   MOVEA     'N'           AKY(15)
     C                   ENDIF
 
     C                   IF        WkLAmtICF <> *ZEROS
     C                   MOVEA     'CXL'         AKY(18)
     C                   Z-ADD     WkLAmtICF     WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtICF <> *ZEROS
     C                   MOVEA     'CXP'         AKY(18)
     C                   Z-ADD     WkPAmtICF     WkAmt
     C                   ENDIF
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per book position record
 
     C                   IF        BKAKSI <> 'Y'
 
     C                   MOVEA     AKY           WkAkey
 
      ** Write to Report
 
     C                   IF        WkLAmtICF <> *ZEROS OR
     C                             WkPAmtICF <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accrual Key Summary Required Indicator is on, store
      ** totals
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BHBA          AKEY(1)
     C                   MOVEA     NCRY          AKEY(4)
     C                   MOVEA     AKY           AKEY(7)
     C                   MOVEA     LKRVRS        AKEY(27)
 
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
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Write a record to SEKEYD                            *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      LKRECI = 'D'
     C                   MOVE      WkAkey        LKACKY
     C                   EVAL      LKTRFR = *ZEROS
     C                   EVAL      LKCSTN = SEISSR
     C                   EVAL      LKISSR = SEISSR
     C                   EVAL      LKBRHA = BHBA
     C                   EVAL      LKASQN = 00
     C                   EVAL      LKEVDT = WkEVCD
     C                   EVAL      LKEVAM = WKAmt
     C                   EVAL      LKEVCY = NCRY
     C                   EVAL      LKSTLT = *ZEROS
     C                   EVAL      LKSTLA = *BLANK
     C                   EVAL      LKSEBR = *BLANK
     C**********         EVAL      LKKCUST = *ZEROS                                           CSD027
     C                   EVAL      LKKCUST = *BLANKS                                          CSD027
     C                   EVAL      LKKNCA = 0
     C                   EVAL      LKKCCY = NCRY
     C                   EVAL      LKKBCA = 0
     C                   EVAL      LKSESH = BHSC
 
      ** If CAC005 is installed, set the profit centre from AOBKPCR0
 
     C                   IF        CAC005 = 'Y'
     C                   EVAL      LKPRFC = PProfit
     C                   ELSE
 
      ** If Analytical Accounting is installed and book position
      ** profit centre is blank, set the profit centre to
      ** SE ICD default profit centre.
 
     C                   IF        BGN0ST = 'Y' AND SNPCBK = *BLANKS
     C                   EVAL      LKPRFC = BVSEPC
     C                   ELSE
     C                   EVAL      LKPRFC = SNPCBK
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      LKPTFR = *BLANK
 
     C                   EVAL      LKTNLU = 16
     C                   EVAL      LKPEV1 = *BLANK
 
     C                   WRITE     SEKEYDF
 
      ** Update Totals
 
     C                   EVAL      WkNoRec = WkNoRec + 1
     C                   EVAL      WHAMT = WkAmt
 
     C                   EXSR      SRHASH
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReport - Write a Report                                     *
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
 
     C                   MOVE      SEISSR        RCNUM
     C                   MOVEA     AKY           RAKEY
     C                   EVAL      RCURR = NCRY
     C                   EVAL      RSECU = BHSC
     C                   EVAL      RBOOK = BHBK
     C                   EVAL      RMARK = BHMK
     C                   EVAL      RTRVL = BHTV
 
      ** Retrieve the no. of decimal points
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      NCRY          PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = PCurr
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
 
     C                   MOVE      LKRVRS        RREVI
 
     C                   WRITE     DETAIL
 
     C                   EVAL      WkNoRecB = WkNoRecB + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSumAkey - Generate Summary of Account Key                   *
      *                                                               *
      *****************************************************************
 
     C     SRSumAkey     BEGSR
 
     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WEFV
 
      ** Generate Profit Account Key for Effective Fair Value Hedges
 
     C                   IF        TAmtEFVP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyEFV(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtEFVP(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Effective Fair Value Hedges
 
     C                   IF        TAmtEFVL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyEFV(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtEFVL(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WIFV
 
      ** Generate Profit Account Key for Ineffective Fair Value Hedges
 
     C                   IF        TAmtIFVP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyIFV(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtIFVP(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Ineffective Fair Value Hedges
 
     C                   IF        TAmtIFVL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyIFV(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtIFVL(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WECF
 
      ** Generate Profit Account Key for Effective Cash Flow Hedges
 
     C                   IF        TAmtECFP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyECF(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtECFP(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Effective Cash Flow Hedges
 
     C                   IF        TAmtECFL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyECF(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtECFL(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Profit Account Key for Ineffective Cash Flow Hedges
 
     C                   IF        TAmtICFP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyICF(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtICFP(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Ineffective Cash Flow Hedges
 
     C                   IF        TAmtICFL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyICF(Ix)   WkAKeyDS
     C                   MOVEA     WkAcky        AKY(1)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtICFL(Ix)  WkAmt
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
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
 
     C                   EVAL      LZNORE = WkNoRec
     C                   EVAL      LZHRWN = WkVlInt
     C                   EVAL      LZHRDC = WkVlDec
     C                   UPDATE    SEKEYAF
 
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
      * SRBranch - Access to AOBRCHR0                                 *
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
     C                   EVAL      DBASE  =  9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WkNoRecB = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPosDet - Access Positions Details                           *
      *                                                               *
      *****************************************************************
 
     C     SRPosDet      BEGSR
 
     C                   EVAL      KBHSC = BHSC
     C                   EVAL      KBHBA = BHBA
     C                   EVAL      KBHBK = BHBK
     C                   EVAL      KBHMK = BHMK
     C                   EVAL      KBHTV = BHTV
     C                   EVAL      KLPSD = LPSD
 
      ** Chain to BKPOS to get positions details
 
     C     KTranF2       CHAIN     BKPOS
 
      ** DB Error if not found
 
     C                   IF        NOT %FOUND(BKPOS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'BKPOSD'
     C                   EVAL      DBKEY  =  BHSC + BHBA + BHBK + BHMK + BHTV
     C                   EVAL      DBASE  =  10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSecurity - Access Security Details                          *
      *                                                               *
      *****************************************************************
 
     C     SRSecurity    BEGSR
 
      ** Chain to securities file to get the security details
 
     C     BHSC          CHAIN     SECTY
 
      ** DB Error if not found
 
     C                   IF        NOT %FOUND(SECTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SECTYD'
     C                   EVAL      DBKEY  =  BHSC
     C                   EVAL      DBASE  =  11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInvest - Access to Investment Types file                    *
      *                                                               *
      *****************************************************************
 
     C     SRInvest      BEGSR
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      INVT          PInvest
     C                   PARM      NCRY          PCurr
     C     SDINVT        PARM      SDINVT        DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'INVTPD'
     C                   EVAL      DBKEY  =  INVT + '/' + NCRY
     C                   EVAL      DBASE  =  12
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProfitCtr - Access to Book-Profit Centre Matrix             *
      *                                                               *
      *****************************************************************
 
     C     SRProfitCtr   BEGSR
 
      ** Get profit centre by calling AOBKPCR0 when CAC005 is installed
      ** otherwise get it from PF/SEPCBD
 
     C                   IF        CAC005 = 'Y'
     C                   CALL      'AOBKPCR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*USER  '     POption
     C                   PARM      *BLANK        PBook
     C                   PARM      *BLANK        PProfit
     C                   PARM      BHBK          PPsBook
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBKPCPD'
     C                   EVAL      DBKEY  =  BHBK
     C                   EVAL      DBASE  =  13
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
 
     C                   EVAL      KBHSC = BHSC
     C                   EVAL      KBHBA = BHBA
     C                   EVAL      KBHBK = BHBK
     C                   EVAL      KBHMK = BHMK
 
     C     KSepCB        CHAIN     SEPCBDF
 
     C                   IF        NOT %FOUND(SEPCBD) OR SNRECI <> 'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SEPCBD'
     C                   EVAL      DBKEY  =  BHBK
     C                   EVAL      DBASE  =  14
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Audit Report                                        *
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
      *  SRHASH - Subroutine to add an amount to the total            *
      *                                                               *
      *****************************************************************
      *
     C     SRHASH        BEGSR
 
      ** Set up fields to be hashed as positive
 
     C                   IF        WHAMT < 0
     C                   Z-SUB     WHAMT         WHAMT
     C                   ENDIF
 
      ** Split up the Hash Amount as Integer and Decimal parts
 
     C                   Z-ADD     WHAMT         WHAMTI
     C                   MOVE      WHAMT         WHAMTD
 
      ** Add to the DECIMAL HASH TOTAL part and check for carry
 
     C                   ADD       WHAMTD        WkVlDec
 
     C                   IF        WkVlDec < WHAMTD
     C                   EVAL      WHAMTI = WHAMTI + 1
     C                   ENDIF
 
      ** Add to the INTEGER HASH TOTAL part
 
     C                   ADD       WHAMTI        WkVlInt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkRCF - Register the P1 Printer File via RCF               *
      *                                                               *
      *****************************************************************
      *
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
      * SRChkRCFA -  Register the AU Printer File via RCF             *
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
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Securities Trading File
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDSTRDPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  2
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
     C                   EVAL      DBASE  =  3
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
     C                   EVAL      DBASE  =  4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set on Indicator for Multi-Branching process
 
     C                   IF        BGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
     C                   EVAL      CAC005 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CAC005'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CAC005 = 'Y'
     C                   ELSE
 
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SCSARDPD'
     C                   EVAL      DBKEY  =  'CAC005'
     C                   EVAL      DBASE  =  5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Get the Event Contorl Date as the lesser between (Next Working Day - 1)
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
 
      ** Read Trailer file of SEKEYD
 
     C                   READ      SEKEYA
 
     C                   IF        %EOF(SEKEYA)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SEKEYA'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WkNoRec = LZNORE
     C                   EVAL      WkVlInt = LZHRWN
     C                   EVAL      WkVlDec = LZHRDC
     C                   ENDIF
 
      ** RCF Processing for Audit File
 
     C                   EXSR      SRChkRCFA
 
      ** Key List
 
     C     KTranF        KLIST
     C                   KFLD                    KMOD
     C                   KFLD                    KBHSC
     C                   KFLD                    KBHBA
     C                   KFLD                    KBHBK
     C                   KFLD                    KBHMK
     C                   KFLD                    KBHTV
 
     C     KTranF2       KLIST
     C                   KFLD                    KBHSC
     C                   KFLD                    KBHBA
     C                   KFLD                    KBHBK
     C                   KFLD                    KBHMK
     C                   KFLD                    KBHTV
     C                   KFLD                    KLPSD
 
     C     KSEPCB        KLIST
     C                   KFLD                    KBHBK
     C                   KFLD                    KBHBA
     C                   KFLD                    KBHSC
     C                   KFLD                    KBHMK
                                                                                              228103
     C     KSEMKVL       KLIST                                                                228103
     C                   KFLD                    KBHSC                                        228103
     C                   KFLD                    KBHBA                                        228103
     C                   KFLD                    KBHBK                                        228103
     C                   KFLD                    KBHMK                                        228103
     C                   KFLD                    KBHTV                                        228103
 
     C                   EVAL      KMod = 'SE'
 
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
 
      ********************************************************************
