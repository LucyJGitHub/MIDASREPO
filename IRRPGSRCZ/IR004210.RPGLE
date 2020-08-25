     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRA/IRS Revaluation Account Key Generation')     *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IR004210 - Revaluation Account Key Generation                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS008             Date 16Jun04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004  *CREATE    Date 26Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *           Generation of Unrealised P/L account keys           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Account Key Summary Indicator                   *
      *    31         Record Found Indicator (ASHTRNL1)               *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrProcess  - Process each record read                         *
      * SrSetRvrsK - Setup Reversal Account Key                       *
      * SrSetRvluK - Set Up Revaluation Account Key                   *
      * SrProcCross - Process Cross Currency Deals                    *                       CAS005
      * SrSetRvluKC - Set Up Revaluation Account Key for Cross Ccy    *                       CAS005
      * SrGenKey   - Generate Account Key                             *
      * SrWrite    - Write a Record to PF/DKEYSDP                     *
      * SrReport   - Writes a Record in the Printer File              *
      * SrSumAkey  - Generate Summary by Account Key                  *
      * SrUpdTrl   - Update Trailer File PF/DKEYSZZ                   *
      * SrEndRep   - Write the End of the Report                      *
      * SrBranch   - Calls Access object AOBRCHR0                     *
      * SrAudit    - Write Audit Report                               *
      * SrChkRCF   - Register the P1 Printer File via RCF             *
      * SrChkRCFA  - Register the AU Printer File via RCF             *
      *                                                               *
      * GLZADD - Subroutine to add an amount to the total             *
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
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
     FDEALSL2   UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)

      ** Midas AS Hedge Linkage File Retrieval by Hedge ID
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas AS Hedge Transaction File Retrieval
     FASHTRNLA  IF   E           K DISK    INFSR(*PSSR)

      ** Midas DL Deals Generated Account Keys - Detail
     FDKEYSDP   O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(DK)

      ** Midas DL Deals Generated Account Keys - Trailer
     FDKEYSZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DZ)

     FIR004210P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN01)

     FIR004210AUO    E             PRINTER INFDS(SPOOLU)

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

      ** File Information Data Structure for IR004210P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File Information Data Structure for IR004210AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
                                                                                              CAS005
      ** External DS for Switchable Features File                                             CAS005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS005

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS for Currency Data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Account Key Data Structure
     D WkAKeyDS        DS
     D  WkBrca                 1      3
     D  WkBook                 4      5
     D  WkDTyp                 6      7
     D  WkSTyp                 8      9
     D  WkCurr                10     12
     D  WkClas                13     16                                                       CDL038

     D  WCCY           S              3A

      ** Array for Account Key
     D AKY             S              1A   DIM(10)
     D AKey            S              1A   DIM(16)                                            CDL038
     D*AKey************S**************1A***DIM(12)                                            CDL038

     D*TAkey***********S*************12A***DIM(500)                                           CDL038
     D TAkey           S             16A   DIM(500)                                           CDL038
     D TAmtUP          S             13  0 DIM(500)
     D TAmtUL          S             13  0 DIM(500)
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
     D PRtCd           S              7
     D POptn           S              7
     D PCurr           S              3
     D PBranch         S              3
     D PSard           S              6                                                       CAS005

     D CAS005          S              1                                                       CAS005
                                                                                              CAS005
     D CAS006          S              1                                                       CAS006
                                                                                              CAS006
     D WkNoRec         S              5  0
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
     D WkNoRecB        S              5  0

     D WkAmt           S             15  0
     D WkNewA          S             15  0
     D WkPctg          S              6  2
     D WkUnhg          S              6  2
     D WkEvCD          S              5  0
     D WkAkey          S             10
     D*WkCNum***       S              6  0                                                    CSD027
     D WkCNum          S              6A                                                      CSD027
     D WkDlNo          S              6  0
     D*ChkKey**********S*************12                                                       CDL038
     D ChkKey          S             16                                                       CDL038

     D WRun            S              1

     D WkPAmt          S             15  0
     D WkLAmt          S             15  0
     D WkUNRL          S                   LIKE(UNRL)                                         CAS005
     D WkHgSd          S                   LIKE(FSHSID)                                       CAS005

      ** Index for Array
     D WIx             S              3  0 INZ(0)
     D Ix              S              3  0

      ** Key Fields
     D KModu           S              2
     D*KDlNo****       S              6  0                                                    CLE148
     D KDlNo           S              6                                                       CLE148

     D PrBRCA          S              3

     D PDate           S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

      ** Fields used in GLZADD/GLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZNEGD          S              5

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

     C                   READ      DEALSL2

      ** Check if End of file, produce audit report if end of file
      ** If not, ensure report spool file recorded by RCF

     C                   IF        %EOF(DEALSL2)
     C                   EXSR      SrAudit
     C                   ELSE
     C                   EVAL      WkBRCA = BRCA
     C                   EXSR      SrBranch
     C                   EXSR      SrChkRCF

     C                   DOW       NOT %EOF(DEALSL2)

      ** Process each record

     C                   EXSR      SrProcess

     C                   READ      DEALSL2
     C                   ENDDO

      ** Write End of Report

     C                   IF        BKAKSI <> 'Y'
     C                   EXSR      SrEndRep
     C                   ENDIF

      ** Update Trailer File

     C                   EXSR      SrUpdTrl

     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Process each record read                          *
      *                                                               *
      *****************************************************************

     C     SrProcess     BEGSR

      ** When a swap is a single currency swap, generate te UP/UL account keys

     C**********         EVAL      KDlNo = DLNO                                               CLE148
     C                   MOVEL     DLNO          KDlNo                                        CLE148

     C                   IF        DTYP = 'RX'
     C                   EVAL      WkCurr = BJCYCD
     C                   EVAL      WCCY   = BJCYCD
     C                   ELSE
     C                   EVAL      WkCurr = UCUCY
     C                   EVAL      WCCY   = UCUCY
     C                   ENDIF

     C                   EVAL      *IN31 = *ON

     C                   IF        DTYP = 'RS'
     C                             OR (CAS005 = 'Y' AND DTYP = 'RX')                          CAS005
     C                             OR (CAS006 = 'Y' AND DTYP = 'FR')                          CAS006

      ** Check if a swap is a hedge item

     C     KTranF        CHAIN     ASHTRNLA                           31
     C                   ENDIF

      ** Call subroutine that generates reversal account key if necessary

     C                   EXSR      SrSetRvrsK


      ** If deal is not yet matured AND is not reversed, then call
      ** subroutine that generates revalution account key

     C                   IF        MDAT > WkEvCd AND RECI <> 'R'
                                                                                              CAS005
     C                   IF        DTYP <> 'RX' OR CAS005 = 'N'                               CAS005
     C                   EXSR      SrSetRvluK
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        DTYP = 'RX' AND CAS005 = 'Y'                               CAS005
     C                   EXSR      SrProcCross                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF

      ** Update DEALS

     C                   UPDATE    DEALSDGF

     C                   ENDSR
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SrProcCross - Process Cross Currency Deals                    *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
     C     SrProcCross   BEGSR                                                                CAS005
                                                                                              CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   EVAL      WkPAmt = *ZEROS                                            CAS005
     C                   EVAL      WKLAmt = *ZEROS                                            CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
                                                                                              CAS005
     C                   WHEN      *IN31 = *OFF                                               CAS005
                                                                                              CAS005
      ** First call is for 'Our' Side                                                         CAS005
                                                                                              CAS005
     C                   EVAL      WkHgSd = 'U'                                               CAS005
     C                   EVAL      WkUNRL = FSUURL                                            CAS005
     C                   EXSR      SrSetRvluKC                                                CAS005
                                                                                              CAS005
      ** Second call is for 'Their' Side, reposition file pointer                             CAS005
                                                                                              CAS005
     C     *LOVAL        SETLL     ASHTRNLA                                                   CAS005
     C     KTranF        CHAIN     ASHTRNLA                                                   CAS005
     C                   EVAL      WkHgSd = 'T'                                               CAS005
     C                   EVAL      WkUNRL = FSTURL                                            CAS005
     C                   EXSR      SrSetRvluKC                                                CAS005
                                                                                              CAS005
     C                   WHEN      *IN31 = *ON                                                CAS005
                                                                                              CAS005
      ** If the swap is never designated as a hedge transaction (not found                    CAS005
      ** in Hedge Transactions File), post full amount                                        CAS005
                                                                                              CAS005
     C                   IF        UNRL < 0                                                   CAS005
     C                   Z-SUB     UNRL          WkLAmt                                       CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     UNRL          UNRLP                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        UNRL > 0                                                   CAS005
     C                   Z-ADD     UNRL          WkPAmt                                       CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     UNRL          UNRLP                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetRvrsK - Setup Reversal Account Key                       *
      *                                                               *
      *****************************************************************
     C     SrSetRvrsK    BEGSR

     C                   EVAL      WkPAmt = *ZEROS
     C                   EVAL      WKLAmt = *ZEROS

      ** If found in Hedge Transactions File, check Hedge Transaction Id

     C                   IF        *IN31 = *OFF

      ** If live transaction in hedge linkage or deleted but not yet dropped,
      ** generate account keys as per value of Trading Unrealised P/L Posted

     C                   IF        FSHTID = 'D' OR FSHTID = '*'

     C                   SELECT

      ** If Trading Unrealised P/L Posted is negative generate loss account key

     C                   WHEN      FSTRUP < 0
     C                             AND DTYP <> 'RX'                                           CAS005
     C                   IF        RECI <> 'R'
     C                   Z-ADD     FSTRUP        WkLAmt
     C                   EVAL      DKREVI = 0
     C                   ELSE
     C                   Z-SUB     FSTRUP        WkLAmt
     C                   EVAL      DKREVI = 1
     C                   ENDIF

     C                   EXSR      SrGenKey
     C                   Z-ADD     0             FSTRUP

      ** If Trading Unrealised P/L Posted is positive generate profit account key

     C                   WHEN      FSTRUP > 0
     C                             AND DTYP <> 'RX'                                           CAS005
     C                   IF        RECI <> 'R'
     C                   Z-SUB     FSTRUP        WkPAmt
     C                   EVAL      DKREVI = 0
     C                   ELSE
     C                   Z-ADD     FSTRUP        WkPAmt
     C                   EVAL      DKREVI = 1
     C                   ENDIF

     C                   EXSR      SrGenKey
     C                   Z-ADD     0             FSTRUP
                                                                                              CAS005
      ** If 'Our' Trading Unrealised P/L Posted is negative generate loss account key         CAS005
                                                                                              CAS005
     C                   WHEN      FSUURP < 0 AND DTYP = 'RX'                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-ADD     FSUURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-SUB     FSUURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSUURP                                       CAS005
                                                                                              CAS005
      ** Reverse 'Their' UNRL as well                                                         CAS005
                                                                                              CAS005
     C                   IF        FSTURP < 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-ADD     FSTURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-SUB     FSTURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSTURP > 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-SUB     FSTURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSTURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSTURP <> 0                                                CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSTURP                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If 'Our' Trading Unrealised P/L Posted is positive generate profit account key       CAS005
                                                                                              CAS005
     C                   WHEN      FSUURP > 0 AND DTYP = 'RX'                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-SUB     FSUURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSUURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSUURP                                       CAS005
                                                                                              CAS005
      ** Reverse 'Their' UNRL as well                                                         CAS005
                                                                                              CAS005
     C                   IF        FSTURP < 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-ADD     FSTURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-SUB     FSTURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSTURP > 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-SUB     FSTURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSTURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSTURP <> 0                                                CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSTURP                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If 'Their' Trading Unrealised P/L Posted is negative, generate loss a/c key          CAS005
                                                                                              CAS005
     C                   WHEN      FSTURP < 0 AND DTYP = 'RX'                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-ADD     FSTURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-SUB     FSTURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSTURP                                       CAS005
                                                                                              CAS005
      ** Reverse 'Our' UNRL as well                                                           CAS005
                                                                                              CAS005
     C                   IF        FSUURP < 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-ADD     FSUURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-SUB     FSUURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSUURP > 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-SUB     FSUURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSUURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSUURP <> 0                                                CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSUURP                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If 'Their' Trading Unrealised P/L Posted is positive, generate profit a/c key        CAS005
                                                                                              CAS005
     C                   WHEN      FSTURP > 0 AND DTYP = 'RX'                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-SUB     FSTURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSTURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSTURP                                       CAS005
                                                                                              CAS005
      ** Reverse 'Our' UNRL as well                                                           CAS005
                                                                                              CAS005
     C                   IF        FSUURP < 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-ADD     FSUURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-SUB     FSUURP        WkLAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSUURP > 0                                                 CAS005
     C                   IF        RECI <> 'R'                                                CAS005
     C                   Z-SUB     FSUURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 0                                                 CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     FSUURP        WkPAmt                                       CAS005
     C                   EVAL      DKREVI = 1                                                 CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        FSUURP <> 0                                                CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   Z-ADD     0             FSUURP                                       CAS005
     C                   ENDIF                                                                CAS005

      ** If this point is reached, it means Trading Unrealised P/L Posted
      ** is 0, check Unrealised P/L Posted instead

     C                   WHEN      UNRLP < 0
     C                   IF        RECI <> 'R' AND MDAT > WkEvCd
     C                   Z-ADD     UNRLP         WkLAmt
     C                   EVAL      DKREVI = 0
     C                   EXSR      SrGenKey
     C                   Z-ADD     0             UNRLP
     C                   ENDIF

     C                   WHEN      UNRLP > 0
     C                   IF        RECI <> 'R' AND MDAT > WkEvCd
     C                   Z-SUB     UNRLP         WkPAmt
     C                   EVAL      DKREVI = 0
     C                   EXSR      SrGenKey
     C                   Z-ADD     0             UNRLP
     C                   ENDIF

     C                   ENDSL

     C                   ENDIF

      ** Else, swap is never designated as hedge transaction

     C                   ELSE

      ** If not deleted and maturity date is less that event control date,
      ** generate account keys.

     C                   IF        RECI <> 'R' AND MDAT > WkEvCd

     C                   IF        UNRLP < 0
     C                   Z-ADD     UNRLP         WkLAmt
     C                   EVAL      DKREVI = 0
     C                   EXSR      SrGenKey
     C                   Z-ADD     0             UNRLP
     C                   ENDIF

     C                   IF        UNRLP > 0
     C                   Z-SUB     UNRLP         WkPAmt
     C                   EVAL      DKREVI = 0
     C                   EXSR      SrGenKey
     C                   Z-ADD     0             UNRLP
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SrSetRvluKC - Set Up Revaluation Account Key for Cross        *                       CAS005
      *               Currency Deals                                  *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
     C     SrSetRvluKC   BEGSR                                                                CAS005
                                                                                              CAS005
     C                   DOW       (FSHTID <> 'D' OR FSHSID <> WkHgSd) AND                    CAS005
     C                             NOT %EOF(ASHTRNLA)                                         CAS005
     C     KTranF        READE     ASHTRNLA                                                   CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
      ** If live transaction in hedge linkage, check percentage                               CAS005
                                                                                              CAS005
     C                   IF        NOT %EOF(ASHTRNLA)                                         CAS005
                                                                                              CAS005
     C                   EVAL      WkPctg = *ZEROS                                            CAS005
                                                                                              CAS005
      ** Sum up all percentages for the swap as a live hedge transaction                      CAS005
                                                                                              CAS005
     C                   DOW       NOT %EOF(ASHTRNLA)                                         CAS005
     C     FSHEDI        CHAIN     ASHGLKL1                                                   CAS005
                                                                                              CAS005
      ** Accumulate percentage for both effective and ineffective hedges                      CAS005
      ** and hedge linkages in trading status                                                 CAS005
                                                                                              CAS005
     C                   IF        FSHTID = 'D' AND (FSRECI = 'D' OR                          CAS005
     C                             FSRECI = 'X' OR FSRECI = 'T') AND                          CAS005
     C                             FSHSID = WkHgSd                                            CAS005
     C                   EVAL      WkPctg = FSPCTG + WkPctg                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C     KTranF        READE     ASHTRNLA                                                   CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
      ** Check if the deal is partially hedge, only the unhedged portion will                 CAS005
      ** be posted                                                                            CAS005
                                                                                              CAS005
     C                   EVAL      WkNewA = 0                                                 CAS005
                                                                                              CAS005
     C                   IF        WkPctg < 100                                               CAS005
     C     100           SUB       WkPctg        WkUnhg                                       CAS005
     C                   EVAL      WkNewA = (WkUNRL * (WkUnhg / 100))                         CAS005
                                                                                              CAS005
     C                   IF        WkUNRL < 0                                                 CAS005
     C                   Z-SUB     WkNewA        WkLAmt                                       CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   IF        WkHgSd = 'U'                                               CAS005
     C                   Z-ADD     WkNewA        FSUURP                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     WkNewA        FSTURP                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkUNRL > 0                                                 CAS005
     C                   Z-ADD     WkNewA        WkPAmt                                       CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   IF        WkHgSd = 'U'                                               CAS005
     C                   Z-ADD     WkNewA        FSUURP                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     WkNewA        FSTURP                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** End of If WkPctg < 100                                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
      ** If deleted transaction in hedge linkage, or leg is not hedged, post                  CAS005
      ** full amount                                                                          CAS005
                                                                                              CAS005
     C                   IF        WkUNRL < 0                                                 CAS005
     C                   Z-SUB     WkUNRL        WkLAmt                                       CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   IF        WkHgSd = 'U'                                               CAS005
     C                   Z-ADD     WkUNRL        FSUURP                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     WkUNRL        FSTURP                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        WkUNRL > 0                                                 CAS005
     C                   Z-ADD     WkUNRL        WkPAmt                                       CAS005
     C                   EXSR      SrGenKey                                                   CAS005
     C                   IF        WkHgSd = 'U'                                               CAS005
     C                   Z-ADD     WkUNRL        FSUURP                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     WkUNRL        FSTURP                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
      *****************************************************************                       CAS005
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetRvluK - Set Up Revaluation Account Key                   *
      *                                                               *
      *****************************************************************
     C     SrSetRvluK    BEGSR

     C                   EVAL      DKREVI = 0
     C                   EVAL      WkPAmt = *ZEROS
     C                   EVAL      WKLAmt = *ZEROS

     C                   SELECT

      ** If found in Hedge Transactions File, check Hedge Transaction Id

     C                   WHEN      *IN31 = *OFF

     C                   DOW       FSHTID <> 'D' AND NOT %EOF(ASHTRNLA)
     C     KTranF        READE     ASHTRNLA
     C                   ENDDO
     C

      ** If live transaction in hedge linkage, check percentage

     C                   IF        NOT %EOF(ASHTRNLA)

     C                   EVAL      WkPctg = *ZEROS

      ** Sum up all percentages for the swap as a live hedge transaction

     C                   DOW       NOT %EOF(ASHTRNLA)
     C     FSHEDI        CHAIN     ASHGLKL1

      ** Accumulate percentage for both effective and ineffective hedges
      ** and hedge linkages in trading status                                                 CAS005

     C                   IF        (FSHTID = 'D') AND
     C**********                   (FSRECI = 'D' OR FSRECI = 'X')                             CAS005
     C                             (FSRECI = 'D' OR FSRECI = 'X' OR                           CAS005
     C                             (FSRECI = 'T' AND CAS005 = 'Y'))                           CAS005
     C                   EVAL      WkPctg = FSPCTG + WkPctg
     C                   ENDIF

     C     KTranF        READE     ASHTRNLA
     C                   ENDDO

      ** Check if the deal is partially hedge, only the unhedged portion will
      ** be posted

     C                   EVAL      WkNewA = 0

     C                   IF        WkPctg < 100
     C     100           SUB       WkPctg        WkUnhg
     C                   EVAL      WkNewA = (UNRL * (WkUnhg / 100))

     C                   IF        UNRL < 0
     C                   Z-SUB     WkNewA        WkLAmt
     C                   EXSR      SrGenKey
     C                   Z-ADD     WkNewA        FSTRUP
     C                   ENDIF

     C                   IF        UNRL > 0
     C                   Z-ADD     WkNewA        WkPAmt
     C                   EXSR      SrGenKey
     C                   Z-ADD     WkNewA        FSTRUP
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

      ** If deleted transaction in hedge linkage, disregard percentages, post
      ** full amount

     C                   IF        UNRL < 0
     C                   Z-SUB     UNRL          WkLAmt
     C                   EXSR      SrGenKey
     C                   Z-ADD     UNRL          UNRLP
     C                   ENDIF

     C                   IF        UNRL > 0
     C                   Z-ADD     UNRL          WkPAmt
     C                   EXSR      SrGenKey
     C                   Z-ADD     UNRL          UNRLP
     C                   ENDIF

     C                   ENDIF

     C                   WHEN      *IN31 = *ON

      ** If the swap is never designated as a hedge transaction (not found
      ** in Hedge Transactions File), post full amount

     C                   IF        UNRL < 0
     C                   Z-SUB     UNRL          WkLAmt
     C                   EXSR      SrGenKey
     C                   Z-ADD     UNRL          UNRLP
     C                   ENDIF

     C                   IF        UNRL > 0
     C                   Z-ADD     UNRL          WkPAmt
     C                   EXSR      SrGenKey
     C                   Z-ADD     UNRL          UNRLP
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGenKey - Generate Account Key                               *
      *                                                               *
      *****************************************************************
     C     SRGenKey      BEGSR

      ** If Account Key Summary Required Indicator is set off, generate
      ** account key per loan

     C                   IF        BKAKSI <> 'Y'
     C                   MOVEA     DTYP          AKY(1)
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     DLST          AKY(4)

     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     BOKC          AKY(6)
     C                   ENDIF

     C                   IF        WkLAmt <> *ZEROS
     C                   MOVEA     'UL'          AKY(9)
     C                   Z-ADD     WkLAmt        WkAmt
     C                   ENDIF

     C                   IF        WkPAmt <> *ZEROS
     C                   MOVEA     'UP'          AKY(9)
     C                   Z-ADD     WkPAmt        WkAmt
     C                   ENDIF

     C                   MOVEA     AKY           WkAkey
     C                   EVAL      WkDlNo = DLNO
     C                   EVAL      WkClas = CLAS                                              CDL038

      ** For Cross currency, set event currency equal to base currency else
      ** set event currency equal to OUR Pay/Receive Currency

     C                   EVAL      WkCNum = CNUM
     C                   EVAL      WkBrca = BRCA

      ** Write to Report

     C                   EXSR      SrReport

      ** Write to File

     C                   EXSR      SrWrite
     C                   ENDIF

      ** If Accrual Key Summary Required Indicator is on, store
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
     C                   MOVEA     WCCY          AKEY(10)
     C                   MOVEA     CLAS          AKEY(13)                                     CDL038

     C                   Z-ADD     1             Ix
     C                   MOVEA     AKEY          ChkKey
     C     ChkKey        LOOKUP    TAkey(Ix)                              89
     C                   IF        *IN89 = *ON
     C                   ADD       WkLAmt        TAmtUL(Ix)
     C                   ADD       WkPAmt        TAmtUP(Ix)
     C                   ELSE
     C                   EVAL      WIx = WIx + 1
     C                   MOVEA     AKey          TAKey(WIx)
     C                   Z-ADD     WkLAmt        TAmtUL(WIx)
     C                   Z-ADD     WkPAmt        TAmtUP(WIx)
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWrite - Write a Record to PF/DKEYSDP                        *
      *                                                               *
      *****************************************************************

     C     SrWrite       BEGSR

     C                   EVAL      DKRECI = 'D'
     C*******************MOVE      WkAkey        DKAKEY                                       CDL038
     C                   MOVEL     WkAkey        DKAKEY                                       CDL038
     C                   MOVE      WkClas        DKAKEY                                       CDL038
     C                   EVAL      DKDLNO = WkDlNo
     C                   EVAL      DKCNUM = WkCNum
     C                   EVAL      DKBRCA = WkBrca
     C                   EVAL      DKACSQ = CDAS
     C                   EVAL      DKEDAT = WkEvCD
     C                   EVAL      DKEAMT = WkAmt
     C                   EVAL      DKECCY = WkCurr
     C                   EVAL      DKSETP = 0
     C                   EVAL      DKOTHA = *ZEROS
     C                   EVAL      DKEXRT = *ZEROS
     C                   EVAL      DKVDAT = VDAT
     C                   EVAL      DKSLID = 0
     C                   EVAL      DKMDAT = MDAT
     C                   EVAL      DKBRTT = UBRTT
     C                   EVAL      DKBRTE = UBRTE
     C                   EVAL      DKRTSP = URTSP
     C                   EVAL      DKINTR = UEINR
     C                   EVAL      DKFFVD = WkEvCd
     C                   EVAL      DKYRAT = UEINR
     C********           EVAL      DKCHNACH = 0                                               CSD027
     C                   EVAL      DKCHNACH = *Blanks                                         CSD027
     C                   EVAL      DKFACO = FACO
     C                   EVAL      DKPRFC = PRFC
     C                   EVAL      DKBOKC = BOKC

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
      * SrReport - Writes a Record in the Printer File                *
      *                                                               *
      *****************************************************************

     C     SrReport      BEGSR

     C                   IF        WkBRCA <> PrBRCA

     C                   IF        PrBRCA <> *Blanks
     C                   EXSR      SrEndRep
     C                   ENDIF

     C                   EXSR      SrBranch

     C                   EVAL      PrBRCA = WkBRCA

     C                   ENDIF

     C                   MOVE      WkCNum        RCNUM
     C                   MOVE      WkDlNo        RDLNO
     C                   MOVEA     AKY           RAKEY
     C                   MOVE      WkClas        RAKEY                                        CDL038
     C                   EVAL      RCURR = WkCurr

      ** Retrieve the no. of decimal points

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WkCurr        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database Error

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 006
     C                   EVAL      DBKEY  = WkCurr
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
      * SrSumAkey - Generate Summary by Account Key                   *
      *                                                               *
      *****************************************************************
     C     SrSumAkey     BEGSR

     C                   EVAL      Ix = 1
     C                   DOW       Ix <= WIx

      ** Generate Profit Account Key

     C                   IF        TAmtUP(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     TAKey(Ix)     WkAKeyDS
     C                   MOVEA     WkDTyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkSTyp        AKY(4)
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF

     C                   MOVEA     'UP'          AKY(9)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtUP(Ix)    WkAmt
     C                   EVAL      WkDlNo = *ZEROS
     C**********         EVAL      WkCNum = *ZEROS                                            CSD027
     C                   EVAL      WkCNum = *BLANKS                                           CSD027
     C                   EXSR      SrWrite
     C                   EXSR      SrReport
     C                   ENDIF

      ** Generate Loss Account Key

     C                   IF        TAmtUL(Ix) <> *ZEROS
     C                   MOVE      *BLANKS       WkAKeyDS
     C                   MOVEA     TAKey(Ix)     WkAKeyDS
     C                   MOVEA     WkDTyp        AKY(1)
     C                   MOVE      'A'           AKY(3)
     C                   MOVEA     WkSTyp        AKY(4)
     C                   IF        BNBCPL = 'Y'
     C                   MOVEA     WkBook        AKY(6)
     C                   ENDIF
     C                   MOVEA     'UL'          AKY(9)
     C                   MOVEA     AKY           WkAkey
     C                   Z-ADD     TAmtUL(Ix)    WkAmt
     C                   EVAL      WkDlNo = *ZEROS
     C**********         EVAL      WkCNum = *ZEROS                                            CSD027
     C                   EVAL      WkCNum = *BLANKS                                           CSD027
     C                   EXSR      SrWrite
     C                   EXSR      SrReport
     C                   ENDIF

     C                   EVAL      Ix = Ix + 1

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdTrl - Update Trailer File PF/DKEYSZZ                     *
      *                                                               *
      *****************************************************************

     C     SrUpdTrl      BEGSR

     C                   IF        BKAKSI = 'Y'
     C                   EXSR      SRSumAkey
     C                   EXSR      SrEndRep
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
      * SrEndRep - Write the End of the Report                        *
      *                                                               *
      *****************************************************************

     C     SrEndRep      BEGSR

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
      * SrBranch - Calls Access object AOBRCHR0                       *
      *                                                               *
      *****************************************************************

     C     SrBranch      BEGSR

     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WkBRCA        PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRtCd <> *Blanks
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
      * SrAudit - Write Audit Report                                  *
      *                                                               *
      *****************************************************************

     C     SrAudit       BEGSR

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
      * SrChkRCF - Register the P1 Printer File via RCF               *
      *                                                               *
      *****************************************************************
     C     SrChkRCF      BEGSR

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
      * SrChkRCFA -  Register the AU Printer File via RCF             *
      *                                                               *
      *****************************************************************

     C     SrChkRCFA     BEGSR

      ** Ensure Audit Spool File recorded by RCF

     C                   Z-ADD     SFNUMU        PZSNMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        SFILEU
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
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access the Dealing ICD file

     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access the General Ledger ICD file

     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access the Midas Modules

     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set on Indicator for Multi-Branching process

     C                   IF        BGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF

      ** Get Event Control Date as the lesser between (Next Working Day - 1)
      ** and Accrual Profit Date

     C                   EVAL      WkEvCD = BJDNWD - 1

     C                   IF        BKAPDT < WkEvCD
     C                   EVAL      WkEvCD = BKAPDT
     C                   ENDIF

      ** Convert the event control date to ddmmmyy format

     C                   EVAL      PDate = WkEvCD
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE

     C                   EVAL      REVCD = ZADATE

      ** Check for the Accrual Key Summary Indicator

     C                   IF        BKAKSI <> 'Y'
     C                   EVAL      *IN02 = *ON
     C                   ELSE
     C                   EVAL      *IN02 = *OFF
     C                   ENDIF

      ** Read Trailer file of DKEYSDP

     C                   READ      DKEYSZZ

     C                   IF        %EOF(DKEYSZZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DKEYSZZ'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WkNoRec = DZNORE
     C                   EVAL      WkVlInt = DZHRWN
     C                   EVAL      WkVlDec = DZHRDC
     C                   ENDIF
                                                                                              CAS005
      ** Check if Enhancements to CAS001, CAS002 and CAS004 is installed                      CAS005
                                                                                              CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRtCd                                        CAS005
     C                   PARM      '*VERIFY'     POptn                                        CAS005
     C                   PARM      'CAS005'      PSard                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
      ** Database error                                                                       CAS005
                                                                                              CAS005
     C                   IF        PRtCd = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   IF        PRtCd <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBKey  = POptn                                             CAS005
     C                   EVAL      DBase  = 008                                               CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS006
      ** Check if Hedge Accounting Phase B                                                    CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtCd                                        CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
      ** Database error                                                                       CAS006
                                                                                              CAS006
     C                   IF        PRtCd = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRtCd <> '*NRF   '                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKey  = POptn                                             CAS006
     C                   EVAL      DBase  = 009                                               CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006

      ** RCF Processing for Audit File

     C*                  EXSR      SrChkRCFA

      ** Key List

     C     KTranF        KLIST
     C                   KFLD                    KModu
     C                   KFLD                    KDlNo

     C                   EVAL      KModu = 'DL'

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
