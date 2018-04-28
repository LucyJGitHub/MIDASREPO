     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge LE a/c key generation program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000011 - Hedge LE Account Key Generation Program           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR1056323          Date 14Nov12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAS009             Date 16May05               *
      *                 225301             Date 27Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 221416             Date 17Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004  *CREATE    Date 26Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  225301 - Wrong reversal amounts posted.                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  221416 - Extra reversals posted due to ineffective hedge     *
      *           reactivated.                                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Account Key Summary Indicator                   *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRAudit    - Audit Report                                     *
      * SRBranch   - Access to AOBRCHR0                               *
      * SRDelHdg   - Process Deleted Hedge Item                       *
      * SREndRep   - Write the End of the Report                      *
      * SRGenKeyCF - Generate Account Key for Effective Cash Flow     *
      *              Hedges                                           *
      * SRGenKeyFV - Generate Account Key for Effective Fair Value    *
      *              Hedges                                           *
      * SRHedge    - Check if the loan is a hedged item               *
      * SRLiveHdg  - Process Live Hedge Item                          *
      * SRProcess  - Process each record read                         *
      * SRReport   - Write a Report                                   *
      * SRRevPost  - Generate a reversal posting for the remainder    *
      * SRSumAkey  - Generate Summary of Account Key                  *
      * SRUpdTrl   - Update Trailer File                              *
      * SRWrite    - Write a record to LKEY1DP                        *
      *                                                               *
      *  GLZADD - Subroutine to add an amount to the total            *
      *  GLZSUM - Subroutine to carry out the additon for subroutine  *
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
 
      ** Midas LE Loans File
     FCLOANLB   UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas AS Hedge Linkage File Update by Hedge ID
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HL:2)
 
      ** Midas AS Hedge Transaction File Retrieval
     FASHTRNLA  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Hedge Strategy by Shortname
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SD:2)
 
      ** Midas LE Loan Account Keys Detail
     FLKEY1DP   O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(LK)
 
      ** Midas LE Loan Account Keys Trailer
     FLKEY1ZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LZ)
 
     FAS000011P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN01)
 
     FAS000011AUO    E             PRINTER INFDS(SPOOLU)
 
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
 
      ** File Information Data Structure for AS000011P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS000011AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Currency Data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Account Key Data Structure
     D WkAKeyDS        DS
     D  WkBRCA                 1      3
     D  WkBook                 4      5
     D  WkLTYP                 6      7
     D  WkSUTP                 8      9
     D  WkCurr                10     12
     D  WkClas                13     16                                                       CLE042
 
      ** Account Key
     D AKY             S              1A   DIM(14)                                            CLE042
     D AKey            S              1A   DIM(16)                                            CLE042
                                                                                              CLE042
     D AKeyFV          S             16A   DIM(999)                                           CLE042
     D AKeyCF          S             16A   DIM(999)                                           CLE042
     D TAmtFVL         S             13  0 DIM(999)                                           CLE042
     D TAmtFVP         S             13  0 DIM(999)                                           CLE042
     D TAmtCFL         S             13  0 DIM(999)                                           CLE042
     D TAmtCFP         S             13  0 DIM(999)                                           CLE042
                                                                                              CLE042
     D*AKY*************S**************1A   DIM(10)                                            CLE042
     D*AKey************S**************1A   DIM(12)                                            CLE042
 
     D*AKeyFV**********S*************12A   DIM(500)                                           CLE042
     D*AKeyCF**********S*************12A   DIM(500)                                           CLE042
     D*TAmtFVL*********S*************13  0 DIM(500)                                           CLE042
     D*TAmtFVP*********S*************13  0 DIM(500)                                           CLE042
     D*TAmtCFL*********S*************13  0 DIM(500)                                           CLE042
     D*TAmtCFP*********S*************13  0 DIM(500)                                           CLE042
 
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
 
     D WkNoRec         S              5  0
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
     D WkNoRecB        S              5  0
 
     D WkAmt           S             15  0
     D WkEVCD          S              5  0
     D WkAkey          S             14                                                       CLE042
     D*WkAkey**********S*************10                                                       CLE042
     D*WkCNUM***       S              6  0                                                    CSD027
     D WkCNUM          S              6                                                       CSD027
     D*WkLNRF***       S              6  0                                                    CLE148
     D WkLNRF          S              6                                                       CLE148
     D ChkKey          S             16                                                       CLE042
     D*ChkKey**********S*************12                                                       CLE042
 
     D WRun            S              1
     D WkDelFlg        S              1
 
     D WkPAmtFV        S             15  0
     D WkLAmtFV        S             15  0
     D WkPAmtCF        S             15  0
     D WkLAmtCF        S             15  0
     D WkSumFV         S             15  0
     D WkSumCF         S             15  0
     D WkFSEFUP        S                   LIKE(FSEFUP)
     D WkFSECUP        S                   LIKE(FSECUP)
 
      ** Index for Fair Value Hedges and Cash Flow Hedges
     D WFV             S              3  0 INZ(0)
     D WCF             S              3  0 INZ(0)
 
     D Ix              S              3  0
 
      ** Key Fields
     D KMod            S              2
     D*KLnRf****       S              6  0                                                    CLE148
     D KLnRf           S              6                                                       CLE148
 
     D PrBRCA          S              3
 
      ** Fields used in GLZADD/GLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZNEGD          S              5
 
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
 
      ** Read all records from Customer Loans File
 
     C                   READ      CLOANLB
 
      ** Check if End of file, produce audit report if end of file
      ** If not, ensure report spool file recorded by RCF
 
     C                   IF        %EOF(CLOANLB)
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EVAL      WkBRCA = BRCA
     C                   EXSR      SRBranch
     C                   EXSR      SRChkRCF
 
     C                   DOW       NOT %EOF(CLOANLB)
 
      ** Process each record
 
     C                   EXSR      SRProcess
 
     C                   READ      CLOANLB
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
 
     C                   EVAL      WkPAmtFV = *ZEROS
     C                   EVAL      WKLAmtFV = *ZEROS
     C                   EVAL      WkPAmtCF = *ZEROS
     C                   EVAL      WKLAmtCF = *ZEROS
     C                   EVAL      WkSumFV  = *ZEROS
     C                   EVAL      WkSumCF  = *ZEROS
     C                   EVAL      LKREVI = 0
     C                   EVAL      KLnRf = LNRF
     C                   EVAL      WkFSEFUP = FSEFUP
     C                   EVAL      WkFSECUP = FSECUP
 
      ** If Loan has matured, RECI <> 'D'
 
     C                   IF        RECI <> 'D'
 
      ** Set on the reversal indactor
 
     C                   EVAL      LKREVI = 1
 
      ** Effective Fair Value Hedge Unrealized Profit/Loss Posted, generate
      ** account key with positive value
 
     C                   IF        WkFSEFUP < 0
     C                   Z-SUB     WkFSEFUP      WkLAmtFV
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
 
     C                   IF        WkFSEFUP > 0
     C                   Z-ADD     WkFSEFUP      WkPAmtFV
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss in CLOANCL
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Effective Cash Flow Hedge Unrealized Profit/Loss Posted, generate
      ** account key with a positive value
 
     C                   IF        WkFSECUP < 0
     C                   Z-SUB     WkFSECUP      WkLAmtCF
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
 
     C                   IF        WkFSECUP > 0
     C                   Z-ADD     WkFSECUP      WkPAmtCF
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit Loss in CLOANCL
 
     C                   EVAL      FSECUP = *ZEROS
 
     C                   ENDIF
 
      ** If Loan is a live transaction
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      WkDelFlg = 'N'
 
      ** Check if the loan was partially deleted or not
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   DOW       NOT %EOF(ASHTRNLA)
     C                   IF        FSHTCT = 'D' AND FSHTCD <= WkEVCD AND
     C                             FSHTCD >= BJRDNB
     C                   EVAL      WkDelFlg = 'Y'
     C                   ENDIF
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
 
      ** If loan is not a deleted as a LE hedged item today
 
     C                   IF        WkDelFlg = 'N'
     C     KTranF        SETLL     ASHTRNLA                                                  221416
     C     KTranF        READE     ASHTRNLA                                                  221416
     C*****KTranF        CHAIN     ASHTRNLA                                                  221416
                                                                                             221416
     C                   DOW       NOT %EOF(ASHTRNLA)                                        221416
     C                   IF        FSHTID = 'D'                                              221416
                                                                                             221416
     C                   EXSR      SRLiveHdg
     C                   EVAL      FSEFVP = *ZEROS                                           221416
     C                   EVAL      FSHECP = *ZEROS                                           221416
                                                                                             221416
     C                   UPDATE    ASHTRND0                                                  221416
     C                   ENDIF                                                               221416
                                                                                             221416
     C     KTranF        READE     ASHTRNLA                                                  221416
     C                   ENDDO                                                               221416
                                                                                             221416
     C                   ENDIF
 
      ** If loan or a portion of it was deleted today as a LE hedged item
 
     C                   IF        WkDelFlg = 'Y'
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   DOW       NOT %EOF(ASHTRNLA)
 
     C                   IF        FSHTCT = 'D' AND FSHTCD <= WkEVCD AND
     C                             FSHTCD >= BJRDNB
     C                   EXSR      SRDelHdg
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0                                                   221416
     C     KTranF        READE     ASHTRNLA
 
      ** Generate Reversal posting for the remainder of the unrealized
      ** profit/loss posted
 
     C                   IF        %EOF(ASHTRNLA)
     C                   EXSR      SRRevPost
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** Generate the Hedge Portion
 
     C                   EXSR      SRHedge
     C                   ENDIF
 
      ** Update CLOANCL
 
     C                   EVAL      FSEFUP = WkSumFV
     C                   EVAL      FSECUP = WkSumCF
     C                   UPDATE    CLOANCLF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLiveHdg - Process Live Hedge Item                           *
      *                                                               *
      *****************************************************************
 
     C     SRLiveHdg     BEGSR
 
     C                   EVAL      LKREVI = 0
 
      ** Effective Fair Value Hedge Unrealized Profit/Loss Posted, generate
      ** account key with negative value
 
     C**********         IF        WkFSEFUP < 0                                               225301
     C**********         Z-ADD     WkFSEFUP      WkLAmtFV                                     225301
     C                   IF        FSEFVP < 0                                                 225301
     C                   Z-ADD     FSEFVP        WkLAmtFV                                     225301
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
 
     C**********         IF        WkFSEFUP > 0                                               225301
     C**********         Z-SUB     WkFSEFUP      WkPAmtFV                                     225301
     C                   IF        FSEFVP > 0                                                 225301
     C                   Z-SUB     FSEFVP        WkPAmtFV                                     225301
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
 
      ***Update*the*Effective*Fair*Value*Hedge*Unrealized*Profit/Loss*in*CLOANCL              225301
      **********                                                                              225301
     C**********         EVAL      FSEFUP = *ZEROS                                            225301
 
      ** Effective Cash Flow Hedge Unrealized Profit/Loss Posted, generate
      ** account key with a negative value
 
     C**********         IF        WkFSECUP < 0                                               225301
     C**********         Z-ADD     FSHECP        WkLAmtCF                                     225301
     C                   IF        FSHECP < 0                                                 225301
     C                   Z-ADD     FSHECP        WkLAmtCF                                     225301
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
 
     C**********         IF        WkFSECUP > 0                                               225301
     C**********         Z-SUB     WkFSECUP      WkPAmtCF                                     225301
     C                   IF        FSHECP > 0                                                 225301
     C                   Z-SUB     FSHECP        WkPAmtCF                                     225301
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
 
      ***Update*the*Effective*Cash*Flow*Hedge*Unrealized*Profit*Lost*in*CLOANCL               225301
      **********                                                                              225301
     C**********         EVAL      FSECUP = *ZEROS                                            225301
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelHdg - Process Deleted Hedge Item                         *
      *                                                               *
      *****************************************************************
 
     C     SRDelHdg      BEGSR
 
     C                   EVAL      LKREVI = 1
 
      ** Generate the following account key with a positive amount for
      ** the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss
 
     C                   IF        FSEFVP < *ZEROS
     C                   Z-SUB     FSEFVP        WkLAmtFV
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
 
     C                   IF        FSEFVP > *ZEROS
     C                   Z-ADD     FSEFVP        WkPAmtFV
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
 
     C                   EVAL      WkSumFV = WkSumFV + FSEFVP
 
      ** Update the Hedge Transaction Effective Fair Value Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSEFVP = *ZEROS
 
      ** Generate the following account key with a positive amount for
      ** the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss
 
     C                   IF        FSHECP  < *ZEROS
     C                   Z-SUB     FSHECP        WkLAmtCF
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
 
     C                   IF        FSHECP  > *ZEROS
     C                   Z-ADD     FSHECP        WkPAmtCF
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
 
     C                   EVAL      WkSumCF = WkSumCF + FSHECP
 
      ** Update the Hedge Transaction Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted in ASHTRNPD
 
     C                   EVAL      FSHECP = *ZEROS
 
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
     C                   EVAL      WkLAmtFV = WkFSEFUP - WkSumFV
     C                   IF        WkLAmtFV <> *ZEROS
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkFSEFUP > *ZEROS
     C                   EVAL      WkPAmtFV = WkFSEFUP - WkSumFV
     C                   Z-SUB     WkPAmtFV      WkPAmtFV
     C                   IF        WkPAmtFV <> *ZEROS
     C                   EXSR      SRGenKeyFV
     C                   ENDIF
     C                   ENDIF
 
      ** Update the Effective Fair Value Hedge Unrealized Profit/Loss
      ** Posted in CLOANCL
 
     C                   EVAL      FSEFUP = *ZEROS
 
      ** Generate the following account key with a negative amount
      ** Posting amount would be the Effective Cash Flow Hedge Unrealized
      ** Profit/Loss Posted less the accumulated reversed FSHECP
 
     C                   IF        WkFSECUP < *ZEROS
     C                   EVAL      WkLAmtCF = WkFSECUP - WkSumCF
     C                   IF        WkLAmtCF <> *ZEROS
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkFSECUP > *ZEROS
     C                   EVAL      WkPAmtCF = WkFSECUP - WkSumCF
     C                   Z-SUB     WkPAmtCF      WkPAmtCF
     C                   IF        WkPAmtCF <> *ZEROS
     C                   EXSR      SRGenKeyCF
     C                   ENDIF
     C                   ENDIF
 
      ** Update the Effective Cash Flow Hedge Unrealized Profit/Loss
      ** Posted in CLOANCL
 
     C                   EVAL      FSECUP = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedge - Check if the loan is a hedged item                  *
      *                                                               *
      *****************************************************************
 
     C     SRHedge       BEGSR
 
     C                   EVAL      WkPAmtFV = *ZEROS
     C                   EVAL      WKLAmtFV = *ZEROS
     C                   EVAL      WkPAmtCF = *ZEROS
     C                   EVAL      WkLAmtCF = *ZEROS
     C                   EVAL      WkSumFV  = *ZEROS
     C                   EVAL      WkSumCF  = *ZEROS
     C                   EVAL      LKREVI   = 0
 
     C     KTranF        SETLL     ASHTRNLA
     C     KTranF        READE     ASHTRNLA
 
     C                   IF        %EOF(ASHTRNLA)
     C                   GOTO      EndSRHedge
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
     C                   EVAL      DBASE  =  006
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
 
      ** Generate Account Key and set the amount of FSEFUP/FSECUP in CLOANCL with
      ** negative amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-SUB     WkAmt         WkLAmtFV
     C                   EXSR      SRGenKeyFV
     C                   Z-SUB     WkAmt         FSEFVP
     C                   EVAL      WkSumFV = WkSumFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-SUB     WkAmt         WkLAmtCF
     C                   EXSR      SRGenKeyCF
     C                   Z-SUB     WkAmt         FSHECP
     C                   EVAL      WkSumCF = WkSumCF + FSHECP
     C                   ENDSL
 
     C                   ENDIF
 
      ** If Unrealized Profit/Loss is greater than zero
 
     C                   IF        FSURPL > 0
 
      ** Generate Account Key and set the amount of FSEFUP/FSECUP in CLOANCL with
      ** Positive amount
 
     C                   SELECT
     C                   WHEN      SDPRTP = 'FV'
     C                   Z-ADD     WkAmt         WkPAmtFV
     C                   EXSR      SRGenKeyFV
     C                   EVAL      FSEFVP = WkAmt
     C                   EVAL      WkSumFV = WkSumFV + FSEFVP
 
     C                   WHEN      SDPRTP = 'CF'
     C                   Z-ADD     WkAmt         WkPAmtCF
     C                   EXSR      SRGenKeyCF
     c                   EVAL      FSHECP = WkAmt
     C                   EVAL      WkSumCF = WkSumCF + FSHECP
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    ASHTRND0
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
 
     C     EndSRHedge    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyFV - Generate Account Key for Effective Fair Value    *
      *              Hedges                                           *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyFV    BEGSR
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per loan
 
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     LTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     SUTP          AKY(4)
     C                   MOVEA     CLAS          AKY(11)                                      CLE042
 
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF
 
     C                   IF        WkLAmtFV <> *ZEROS
     C                   MOVEA     'FIL'         AKY(8)
     C                   Z-ADD     WkLAmtFV      WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtFV <> *ZEROS
     C                   MOVEA     'FIP'         AKY(8)
     C                   Z-ADD     WkPAmtFV      WkAmt
     C                   ENDIF
 
     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkLNRF = LNRF
     C                   EVAL      WkCurr = CCY
     C                   EVAL      WkCNUM = CNUM
     C                   EVAL      WkBRCA = BRCA
 
      ** Write to Report
 
     C                   IF        WkLAmtFV <> *ZEROS
     C                             OR WkPAmtFV <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accural Key Summary Required Indicator is on, store
      ** totals by loan type/sub-type and book code if book on
      ** account key is set to 'Y'
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BRCA          AKEY(1)
 
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     BOKC          AKEY(4)
     C                   ENDIF
 
     C                   MOVEA     LTYP          AKEY(6)
     C                   MOVEA     SUTP          AKEY(8)
     C                   MOVEA     CLAS          AKEY(13)                                     CLE042
     C                   MOVEA     CCY           AKEY(10)
 
     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyFV(Ix)                             89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtFV      TAmtFVL(Ix)
     C                   ADD       WkPAmtFV      TAmtFVP(Ix)
     C                   ELSE
     C                   EVAL      WFV = WFV + 1
     C                   MOVEA     AKey          AKeyFV(WFV)
     C                   Z-ADD     WkLAmtFV      TAmtFVL(WFV)
     C                   Z-ADD     WkPAmtFV      TAmtFVP(WFV)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenKeyCF - Generate Account Key for Effective Cash Flow     *
      *              Hedges                                           *
      *                                                               *
      *****************************************************************
 
     C     SRGenKeyCF    BEGSR
 
      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per loan
 
     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     LTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     SUTP          AKY(4)
     C                   MOVEA     CLAS          AKY(11)                                      CLE042
 
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF
 
     C                   IF        WkLAmtCF <> *ZEROS
     C                   MOVEA     'CIL'         AKY(8)
     C                   Z-ADD     WkLAmtCF      WkAmt
     C                   ENDIF
 
     C                   IF        WkPAmtCF <> *ZEROS
     C                   MOVEA     'CIP'         AKY(8)
     C                   Z-ADD     WkPAmtCF      WkAmt
     C                   ENDIF
 
     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkLNRF = LNRF
     C                   EVAL      WkCurr = CCY
     C                   EVAL      WkCNUM = CNUM
     C                   EVAL      WkBRCA = BRCA
 
      ** Write to Report
 
     C                   IF        WkLAmtCF <> *ZEROS
     C                             OR WkPAmtCF <> *ZEROS
     C                   EXSR      SRReport
 
      ** Write to File
 
     C                   EXSR      SRWrite
     C                   ENDIF
     C                   ENDIF
 
      ** If Accural Key Summary Required Indicator is on, store
      ** totals by loan type/sub-type and book code if book on
      ** account key is set to 'Y'
 
     C                   IF        BKAKSI = 'Y'
 
     C                   MOVEA     *BLANKS       AKEY
     C                   MOVEA     BRCA          AKEY(1)
 
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     BOKC          AKEY(4)
     C                   ENDIF
 
     C                   MOVEA     LTYP          AKEY(6)
     C                   MOVEA     SUTP          AKEY(8)
     C                   MOVEA     CLAS          AKEY(13)                                     CLE042
     C                   MOVEA     CCY           AKEY(10)
 
     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    AKeyCF(Ix)                             89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmtCF      TAmtCFL(Ix)
     C                   ADD       WkPAmtCF      TAmtCFP(Ix)
     C                   ELSE
     C                   EVAL      WCF = WCF + 1
     C                   MOVEA     AKey          AKeyCF(WCF)
     C                   Z-ADD     WkLAmtCF      TAmtCFL(WCF)
     C                   Z-ADD     WkPAmtCF      TAmtCFP(WCF)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Write a record to LKEY1DP                           *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      LKRECI = 'D'
     C*******************MOVE      WkAkey        LKAKEY                                       CLE042
     C                   MOVEL     WkAkey        LKAKEY                                       CLE042
     C                   EVAL      LKLNNO = WkLNRF
     C                   EVAL      LKCNUM = WkCNUM
     C                   EVAL      LKBRCA = WkBRCA
     C                   EVAL      LKACSQ = LASQ
     C                   EVAL      LKEDAT = WkEVCD
     C                   EVAL      LKEAMT = WkAmt
     C                   EVAL      LKECCY = WkCurr
     C                   EVAL      LKSTDT = VDAT
     C                   EVAL      LKSLID = SLID
     C                   EVAL      LKMDAT = MDAT
     C                   EVAL      LKBRTT = BRTT
     C                   EVAL      LKBRTE = BRTE
     C                   EVAL      LKRTSP = RTSP
     C                   EVAL      LKINTR = INTR
     C                   EVAL      LKCPAM = CPAM
     C                   EVAL      LKACOF = ACOF
     C                   EVAL      LKFACO = FACO
     C                   EVAL      LKPRFC = PRFC
     C                   EVAL      LKBOKC = BOKC
     C                   EVAL      LKORED = ORED
     C                   EVAL      LKOLNO = OLNO
     C                   EVAL      LKPTFR = PTFR
 
     C                   WRITE     LKEY1DPF
 
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
 
     C                   MOVE      WkCNUM        RCNUM
     C                   MOVE      WkLNRF        RLOAN
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
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = WkCurr
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
 
     C                   MOVE      LKREVI        RREVI
 
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
     C                   DOW       Ix <= WFV
 
      ** Generate Profit Account Key for Fair Value Hedges
 
     C                   IF        TAmtFVP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyFV(Ix)    WkAKeyDS
     C                   MOVEA     WkLTYP        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkSUTP        AKY(4)
     C                   MOVEA     WkCLAS        AKY(11)                                      CLE042
 
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'FIP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtFVP(Ix)   WkAmt
     C**********         EVAL      WkLNRF = *ZEROS                                            CLE148
     C                   EVAL      WkLNRF = *BLANKS                                           CLE148
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
 
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Fair Value Hedges
 
     C                   IF        TAmtFVL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyFV(Ix)    WkAKeyDS
     C                   MOVEA     WkLTYP        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkSUTP        AKY(4)
     C                   MOVEA     WkCLAS        AKY(11)                                      CLE042
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'FIL'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtFVL(Ix)   WkAmt
     C**********         EVAL      WkLNRF = *ZEROS                                            CLE148
     C                   EVAL      WkLNRF = *BLANKS                                           CLE148
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WCF
 
      ** Generate Profit Account Key for Cash Flow Hedges
 
     C                   IF        TAmtCFP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyCF(Ix)    WkAKeyDS
     C                   MOVEA     WkLTYP        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkSUTP        AKY(4)
     C                   MOVEA     WkCLAS        AKY(11)                                      CLE042
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'CIP'         AKY(8)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtCFP(Ix)   WkAmt
     C**********         EVAL      WkLNRF = *ZEROS                                            CLE148
     C                   EVAL      WkLNRF = *BLANKS                                           CLE148
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
     C                   EXSR      SRWrite
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Generate Loss Account Key for Cash Flow Hedges
 
     C                   IF        TAmtCFL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     AKeyCF(Ix)    WkAKeyDS
     C                   MOVEA     WkLTYP        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkSUTP        AKY(4)
     C                   MOVEA     WkCLAS        AKY(11)                                      CLE042
 
     C                   IF        BPBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
 
     C                   MOVEA     'CIL'         AKY(8)
 
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtCFL(Ix)   WkAmt
     C**********         EVAL      WkLNRF = *ZEROS                                            CLE148
     C                   EVAL      WkLNRF = *BLANKS                                           CLE148
     C**********         EVAL      WkCNUM = *ZEROS                                            CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027
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
     C                   EVAL      LZVLRF = WkVlInt
     C                   EVAL      LZVLRL = WkVlDec
     C                   UPDATE    LKEY1ZZF
 
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
     C                   EVAL      DBASE  =  008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WkNoRecB = *ZEROS
 
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
      *  GLZADD - Subroutine to add an amount to the total            *
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
      *  GLZSUM - Subroutine to carry out the additon for subroutine  *
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
 
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
 
     C                   IF        *IN93 = *OFF
     C     ZZWK2         COMP      -999                                 93
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *OFF
     C     ZZAMTI        ADD       1             ZZWK3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *ON
     C     ZZAMTI        SUB       1             ZZWK3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        ADD       ZZWK3         ZZWK3
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWK3
     C                   ENDIF
 
      ** If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occurred
 
     C                   IF        *IN92 = *OFF
     C     ZZWK3         COMP      ZZTOTI                               99
     C                   ENDIF
 
     C                   IF        *IN92 = *ON
     C     ZZWK3         COMP      ZZTOTI                             99
     C                   ENDIF
 
     C                   IF        *IN99 = *OFF
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
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
     C     ZZTOTD        ADD       1000          ZZWK2
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZWK2         SUB       ZZAMTD        ZZTOTD
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
     C     ZZAMTI        SUB       1             ZZWK3
     C     ZZAMTD        ADD       1000          ZZWK2
     C     ZZWK3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZWK2         SUB       ZZTOTD        ZZTOTD
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
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Lending ICD file
 
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDCLND        PARM      SDCLND        DSSDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCLNDPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  002
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
     C                   EVAL      DBASE  =  003
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
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set on Indicator for Multi-Branching process
 
     C                   IF        BGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
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
 
      ** Read Trailer file of LKEY1DP
 
     C                   READ      LKEY1ZZ
 
     C                   IF        %EOF(LKEY1ZZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'LKEY1ZZ'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WkNoRec = LZNORE
     C                   EVAL      WkVlInt = LZVLRF
     C                   EVAL      WkVlDec = LZVLRL
     C                   ENDIF
 
      ** RCF Processing for Audit File
 
     C                   EXSR      SRChkRCFA
 
      ** Key List
 
     C     KTranF        KLIST
     C                   KFLD                    KMod
     C                   KFLD                    KLnRf
 
     C                   EVAL      KMod = 'LE'
 
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
 
      ********************************************************************
