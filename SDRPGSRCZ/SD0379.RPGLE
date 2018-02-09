     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Manual Input for Intermediary Clients')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD0379 - Manual input for intermediary clients               *
      *                                                               *
      *  Function:  This module maintains the intermediary clients    *
      *             details.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12405           Date 03Nov06               *
      *                 BG12368A           Date 30Oct06               *
      *                 BUG12368           Date 29Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185998             Date 08Nov00               *
      *                 185996             Date 08Nov00               *
      *                 185728             Date 24Oct00               *
      *                 CSE024  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  BUG12405 - Error occured when adding details for             *
      *             Intermediary Clients                              *
      *  BG12368A - Error when doing Manual Input for Intermediary    *
      *             Clients (Reopen)                                  *
      *  BUG12368 - Error when doing Manual Input for Intermediary    *
      *             Clients                                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE022 - Depository Definition Enhancement                   *
      *  185998 - Sub-file screen donot show allocation imbalance     *
      *           File changed to show total allocation holding       *
      *  185996 - Beneficial owner information should be protected.   *
      *  185728 - A Depot field doesn't accept a market customer      *
      *  CSE024 - Withholding Tax - Sub account processing            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         No record found in SDWTCSL1                     *
      *    03         No record found in SECTY                        *
      *    04         No record found in CDEPP                        *
      *    05         End of file for SDINTCLL1                       *
      *    06         No record found / no record found in SDBNFOL1   *
      *    07         No record found in SDTXBSL1                     *
      *    08         End of file for SDINTCLL0                       *
      *    09         No record found in SDFCTLL0                     *
      *                                                               *
      *    20-30      Error indicator                                 *
      *                                                               *
      *    80         Protect all input capable screen fields         *
      *****81*********Protect*beneficiary*detail*screen*fields*********         185996
      *    81         Protect Tax Basket field                        *                     BUG12405
      *    85         End of file for SDINTCLL1 (subfile read)        *
      *    86         Read changed record on subfile                  *
      *    87         Clear subfile                                   *
      *    88         RollupKey                                       *
      *    89         Subfile control for error message subfile       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR        - Error processing                               *
      * *INZSR       - Initialise                                     *
      * SRFirst      - Process first screen                           *
      * SRSecond     - Process second screen                          *
      * SRReview     - Process review screen                          *
      * SRRdNextE    - Read next change record (enquiry mode)         *
      * SRInvEntry   - Process invalid entry for enquiry mode         *
      * SRRdNextM    - Read next change record (maintenance mode)     *
      * SRRdIntCl    - Read intermediary client detail file           *
      * SRFmtDetI    - Format input fields for subfile display        *
      * SRFmtDetO    - Format fields for output                       *
      * SRBnfToInt   - Format fields from Beneficiary file to         *
      *                Intermediary file                              *
      * SRUpdate     - Update intermediary client detail file         *
      * SRRegenerate - Regenerate record from beneficiary to          *
      *                intermediary                                   *
      * SRGenerate   - Generate beneficiaries record to intermediary  *
      *                detail file                                    *
      * SRVScn1Det   - Validate first screen details                  *
      * SRVSECS      - Validate security shortname                    *
      * SRVCNUM      - Validate customer number                       *
      * SRVDEPT      - Validate Depot number                          *
      * SRVTOTH      - Format total holding                           *
      * SRVScn2Det   - Validate second screen details                 *
      * SRVUAHL      - Format unallocated holding for display         *
      * SRVTXBS      - Validate tax basket                            *
      * SRVBenefDet  - Validate beneficial owner detail               *
      * SRVCTRS      - Validate country of residence                  *
      * SRVHLDN      - Validate holding                               *
      * SRFmtAmtO    - Format amount for display                      *
      * SRSndM       - Handles the display of error messages          *
      * SRSndMDta    - Handles the display of error messages with data*
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
      ** Manual input for intermediary clients display file.
     FSD0379DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD0379S0:W_Rrn)
      *
      ** Intermediary client details - update
     FSDINTCLL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(SDINTCD0:@INTCL0)
      *
      ** Intermediary client details - update
     FSDINTCLL5 UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(SDINTCD0:@INTCL5)
      *
      ** Standing data controls by filename - update
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Intermediary client details - retrieve
     FSDINTCLL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDINTCD0:@INTCL1)
      *
      ** Intermediary client details - retrieve
     FSDINTCLL3 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDINTCD0:@INTCL3)
      *
      ** Intermediary client details - retrieve
     FSDINTCLL4 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDINTCD0:@INTCL4)
      *
      ** Withholding tax customer details - retrieve
     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Beneficial owner details - retrieve
     FSDBNFOL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Tax basket - retrieve
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Clients holdings
     FCDEPP     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Arrays for screen error indicators
     D WResetInd       S              1    DIM(50) CTDATA PERRCD(50)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for securities client
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** Externally described DS for country codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for current first screen details
     D WCurDet1        DS
     D  SCNUM                  1      6
     D  SSECS                  7     16
     D  SDEPT                 17     22
     D  STOTH                 23     40
      *
      ** DS for previous first screen details
     D WPrevDet1       DS
     D  WPrevCNUM              1      6
     D  WPrevSECS              7     16
     D  WPrevDEPT             17     22
     D  WPrevTOTH             23     40
      *
      ** DS for current second screen details
     D WCurDet2        DS
     D  STXBS                  1      2
     D  SBONI                  3     22
     D  SBONM                 23     57
     D  SBOA1                 58     92
     D  SBOA2                 93    127
     D  SBOA3                128    162
     D  SCTRS                163    164
     D  SCSTN                165    184
     D  SHLDN                185    199
      *
      ** DS for previous second screen details
     D WPrevDet2       DS
     D  WPrevTXBS              1      2
     D  WPrevBONI              3     22
     D  WPrevBONM             23     57
     D  WPrevBOA1             58     92
     D  WPrevBOA2             93    127
     D  WPrevBOA3            128    162
     D  WPrevCTRS            163    164
     D  WPrevCSTN            165    184
     D  WPrevHLDN            185    199
      *
      ** DS for old file detail
     D W_OldDet        DS
     D  S#RECI
     D  S#CNUM
     D  S#SECS
     D  S#DEPT
     D  S#TOTH
     D  S#TXBS
     D  S#BONO
     D  S#BONM
     D  S#BOA1
     D  S#BOA2
     D  S#BOA3
     D  S#CTRS
     D  S#CSTN
     D  S#HLDN
      *
      ** DS for newly retrieved file detail
     D W_NewDet        DS
     D  INRECI
     D  INCNUM
     D  INSECS
     D  INDEPT
     D  INTOTH
     D  INTXBS
     D  INBONO
     D  INBONM
     D  INBOA1
     D  INBOA2
     D  INBOA3
     D  INCTRS
     D  INCSTN
     D  INHLDN
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             85     85
     D  RollupKey             88     88
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D WRun            S              1A
      *
      ** Display file mode
     D PMode           S              1A
      *
      ** Index for arrays of error message IDs
     D ErrIdx          S              3P 0
      *
      ** Work variables
     D WAction         S              1A   INZ(*BLANK)
     D WErrFnd         S              1A   INZ(*BLANK)
     D WPrevScrn       S              1A   INZ(*BLANK)
     D WBuildSfl       S              1A   INZ(*BLANK)
     D WReadNext       S              1A   INZ(*BLANK)
     D WShortPos       S              1A   INZ(*BLANK)
     D WWarned         S              1A   INZ(*BLANK)
     D WKeyinF9        S              1A   INZ('N')
     D WScrn           S              1A   INZ('P')
     D WChgRecFnd      S              1A
     D S01510          S              1A
     D WError          S              1A
     D OptSelected     S              1A
     D WCountry        S              2A
     D WCOLC           S              2A
     D WBranch         S              3A
     D WCountIns       S              3P 0
     D WCountDel       S              3P 0
     D W_Cnt           S              3P 0
     D W_Rrn           S              5P 0
     D WE_Rrn          S              5P 0 INZ(*ZEROS)
     D WT_Rrn          S              5P 0
     D*WCustNo**       S              6P 0                                                    CSD027
     D WCustNo         S              6A                                                      CSD027
     D WDepotA         S              6A
     D*WDepot***       S              6P 0                                                    CSD027
     D WPctAlloc       S              7P 6
     D WSShortN        S             10A
     D WTotIndiv       S             15P 0
     D WUnalloc        S             15P 0
     D WTOTH           S             15P 0
     D W_TOTH          S             15P 0
     D WHolding        S             15P 0
     D WBenefNo        S             26A
     D CSE023          S              1A                                                    BUG12368
      *
      ** Work parameters
     D PCrtt           S              2A
     D PCust           S              6A
     D PSARd           S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D PKySt           S              7A
     D PKey1           S             10A
      *
      ** Parameter list for ZA0340 / ZA0350
     D P_MsgFile       S             10A
     D P_MsgID         S             10A
     D P_MsgDta        S             45A
      *
      ** Parameter list for ZALIGN
     D ZAlignok        S              1A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
     D ZAField         S             16A
      *
      ** Parameter list for ZASIGN
     D ZASIGNok        S              1A
     D ZFLD17          S             17A
     D ZSDIG           S              2P 0
     D ZSDEC           S              1P 0
     D ZSDCSP          S              1A
     D ZOUT15          S             15A
     D ZFSIGN          S              1A
      *
      ** Parameter list for ZSEDITF
     D ZFld15          S             15P 0
     D ZDecs           S              1P 0
     D ZECode          S              1A
     D ZEChar          S              1A
     D ZOut21          S             21A
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Main file key for standing data control file
     D MainFilNam      S             10A   INZ(*BLANKS)
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Process initial screen
      *
     C                   IF        WScrn = 'P'
     C                   EXSR      SRFirst
     C                   ENDIF
      *
      ** Process review screen
      *
     C                   IF        WScrn = 'R'
     C                   EXSR      SRReview
     C                   ENDIF
      *
      ** Process second screen
      *
     C                   IF        WScrn = 'S'
     C                   EXSR      SRSecond
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFirst - Process first screen                               *
      *                                                               *
      *****************************************************************
     C     SRFirst       BEGSR
      *
      ** Unprotect entry fields
      *
     C                   EVAL      *IN80 = *OFF
      *
      ** If processing mode is maintain, allow 'Insert' and 'Re-generate'.
      ** Otherwise, prohibit.
      *
     C                   IF        PMode = 'M'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
      *
      ** Write footer, subfile control for error messages and screen 1 detail.
      *
     C                   WRITE     SD0379F0
     C                   WRITE     SD0379C1
     C                   EXFMT     SD0379D0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WResetInd     *IN(20)
      *
      ** Initialise fileds for refresh
      *
     C                   CLEAR                   WPrevDet1
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      *INKC = *ON
     C                   ROLBK
     C                   EVAL      WScrn = 'T'
      *
      ** F5 - refresh first screen details.
     C                   WHEN      *INKE = *ON
     C                   EVAL      WCurDet1 = WPrevDet1
      *
      ** F9 - validate first screen entries and proceed to second screen
      ** if entries are valid.
     C                   WHEN      *INKI = *ON
     C                   EXSR      SRVScn1Det
      *
      ** Redisplay this screen until no more error exist.
     C                   IF        *IN20 = *ON OR
     C                             *IN21 = *ON OR
     C                             *IN31 = *ON
     C                   EVAL      WScrn = 'P'
     C                   ELSE
     C                   EVAL      WKeyinF9  = 'Y'
     C                   EVAL      WWarned   = 'N'
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WAction   = 'I'
     C                   EVAL      WScrn     = 'S'
      *
      ** Initialise screen fields for insert.
     C                   CLEAR                   WCurDet2
     C                   CLEAR                   WPrevDet2
     C                   ENDIF
      *
      ** F21 - validate first screen entries, regenerate and proceed to
      ** review screen.
     C                   WHEN      *INKV = *ON
     C                   EXSR      SRVScn1Det
      *
      ** Redisplay this screen until no more error exist.
     C                   IF        *IN20 = *ON OR
     C                             *IN21 = *ON OR
     C                             *IN31 = *ON
     C                   EVAL      WScrn = 'P'
     C                   ELSE
     C                   EXSR      SRRegenerate
     C                   EVAL      WKeyinF9  = 'N'
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WAction   = *BLANK
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
     C                   ENDIF
      *
      ** Enter key - validate first screen entries, generate beneficiaries
      ** record to intermediary file and proceed to review screen.
     C                   OTHER
     C                   EXSR      SRVScn1Det
      *
      ** Redisplay this screen until no more error exist.
     C                   IF        *IN20 = *ON OR
     C                             *IN21 = *ON OR
     C                             *IN31 = *ON
     C                   EVAL      WScrn = 'P'
     C                   ELSE
      *
      ** Generate beneficiaries record to intermediary detail file if
      ** currently no intermediary record exist.
     C     KCust_SecS    CHAIN     SDINTCLL1                          05
 
     C                   IF        *IN05 = *ON
 
     C                   EVAL      WCountIns = *ZERO
     C                   EXSR      SRGenerate
      *
      ** If a record was inserted update standing data control file
     C                   IF        WCountIns <> *ZERO
 
     C     MainFilNam    CHAIN     SDFCTLL0                           09
 
     C                   IF        *IN09 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = MainFilNam
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE  = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      AHNOIN = AHNOIN + WCountIns
     C                   EVAL      AHNORC = AHNORC + WCountIns
     C                   UPDATE    @AHREAU
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WKeyinF9  = 'N'
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WAction   = *BLANK
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSecond - Process second screen                             *
      *                                                               *
      *****************************************************************
     C     SRSecond      BEGSR
      *
      ** Format unallocated holding for display
      *
     C                   EXSR      SRVUAHL
      *
      ** If action is insert/amend enable fields for update and
      ** allow F5 key.
      *
     C                   IF        WAction = 'I' OR WAction = 'A'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
      *
      ** If action is enquire/delete disable fields for update and
      ** do not allow F5 key.
      *
     C                   IF        WAction = 'E' OR WAction = 'D'
     C                   EVAL      *IN70 = *OFF
     C                   EVAL      *IN80 = *ON
     C***********        EVAL      *IN81 = *ON                                  185996
     C                   ENDIF
      *
      ** Protect tax basket, beneficiary owner number in amend mode.
      *
     C                   IF        WAction = 'A'
     C                   EVAL      *IN82 = *ON
     C                   IF        WHINTS = 'QI'
     C                   EVAL      *IN83 = *ON
     C                   ELSE
     C                   EVAL      *IN83 = *OFF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   ENDIF
      *                                                                                     BUG12405
      ** Protect tax basket if CSE032 is OFF                                                BUG12405
      *                                                                                     BUG12405
     C                   Eval      *IN81  = *Off                                            BUG12405
     C                   If        CSE023 = 'Y'                                             BUG12405
     C                   Eval      *IN81  = *On                                             BUG12405
     C                   EndIf                                                              BUG12405
      *
      ** Write footer, subfile control for error messages and screen 2 details.
      *
     C                   WRITE     SD0379F1
     C                   WRITE     SD0379C1
     C                   EXFMT     SD0379D1
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WResetInd     *IN(20)
      *
      ***Unprotect*indicator*for*beneficiary*details.******************         185996
      ***********                                                               185996
     C***********        EVAL      *IN81 = *OFF                                 185996
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      *INKC = *ON
     C                   ROLBK
     C                   EVAL      WScrn = 'T'
      *
      ** If total for individual holdings does not add up to the total
      ** holding for the customer/security, send warning.
     C                   IF        WUnalloc <> *ZERO AND
     C                             WKeyinF9 = 'Y' AND WWarned <> 'Y'
     C                   EVAL      P_MsgID = 'USR7736'
     C                   EXSR      SRSndM
     C                   EVAL      WWarned = 'Y'
     C                   EVAL      WScrn   = 'S'
     C                   GOTO      ESRSecond
     C                   ENDIF
      *
      ** F5 - refresh first screen details.
     C                   WHEN      *INKE = *ON
     C                   EVAL      WCurDet2 = WPrevDet2
      *
      ** F12 - previous screen details.
     C                   WHEN      *INKL = *ON
      *
      ** If total for individual holdings does not add up to the total
      ** holding for the customer/security, send warning.
     C                   IF        WUnalloc <> *ZERO AND
     C                             WKeyinF9 = 'Y' AND WWarned <> 'Y'
     C                   EVAL      P_MsgID = 'USR7736'
     C                   EXSR      SRSndM
     C                   EVAL      WWarned = 'Y'
     C                   EVAL      WScrn   = 'S'
     C                   GOTO      ESRSecond
     C                   ENDIF
 
     C                   EVAL      WScrn = WPrevScrn
      *
      ** If previous screen was review screen, read subfile next change
      ** to check if there are pending option entered against subfile
      ** record.
     C                   IF        WScrn = 'R'
     C                   EVAL      WBuildSfl = 'N'
     C                   EVAL      WReadNext = 'Y'
     C                   ENDIF
      *
      ** Enter key was pressed, validate second screen entries.
     C                   OTHER
      *
      ** Validate second screen details only for insert and amend.
     C                   EVAL      ErrIdx = *ZEROS
     C                   IF        WAction = 'A' OR WAction = 'I'
     C                   EXSR      SRVScn2Det
     C                   ENDIF
 
     C                   IF        WAction = 'A' OR WAction = 'I' OR
     C                             WAction = 'D'
      *
      ** Update intermediary client detail file if detail entered
      ** are valid.
     C                   IF        ErrIdx = *ZEROS
     C                   EXSR      SRUpdate
      *
      ** Re-initialise input fields for the next record to be
      ** inserted/amended.
     C                   CLEAR                   WCurDet2
      *
      ***Unprotect*indicator*for*beneficiary*details.******************         185996
     C***********        EVAL      *IN81 = *OFF                                 185996
     C                   ENDIF
     C                   ENDIF
      *
      ** Loop on this screen untill no more error or if F9 was pressed
      ** from the previous screen.
     C                   IF        WAction = 'A' AND ErrIdx <> *ZEROS OR
     C                             WAction = 'I' AND ErrIdx <> *ZEROS OR
     C                             WKeyinF9 = 'Y'
     C                   EVAL      WScrn = 'S'
     C                   ELSE
     C                   EVAL      WBuildSfl = 'N'
     C                   EVAL      WReadNext = 'Y'
     C                   EVAL      WScrn     = 'R'
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRSecond     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReview - Process review screen                             *
      *                                                               *
      *****************************************************************
     C     SRReview      BEGSR
      *
      ** Build subfile page was requested.
      *
     C                   IF        WBuildSfl = 'Y'
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   EVAL      *IN87 = *ON
     C                   WRITE     SD0379C0
     C                   EVAL      *IN87 = *OFF
      *
      ** Position record pointer to the top record.
      *
     C     KClient       SETLL     SDINTCLL1
      *
      ** Read through intermediary clients details.
      *
     C                   EXSR      SRRdIntCl
      *
      ** If no record was read, send an error message "No intermediary clients
      ** to review".
      *
     C                   IF        EndOfFile = True
     C                   EVAL      P_MsgID = 'USR7730'
     C                   EXSR      SRSndM
     C                   EVAL      WScrn = 'P'
     C                   GOTO      ESRReview
     C                   ENDIF
      *
      ** If processing mode is maintain, allow 'Insert' and 'Re-generate'.
      ** Otherwise, prohibit.
      *
     C                   IF        PMode = 'M'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
      *
      ** Set on Rollup indicator to drive initial loop.
      *
     C                   EVAL      *IN88 = *ON
      *
      ** While Rollup, build a subfile page.
      *
     C                   DOW       RollupKey = True OR OptSelected <> 'Y'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 13
      *
      ** Increment the subfile record no. and records written counter.
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
     C                   Z-ADD     W_Rrn         WT_Rrn
      *
      ** Format input fields for display.
     C                   EXSR      SRFmtDetI
      *
      ** Write intermediary clients to subfile.
     C                   EVAL      SOPTN = *BLANK
     C                   Z-ADD     W_Rrn         SSFRN
     C                   WRITE     SD0379S0
      *
      ** Read next intermediary client.
     C                   EXSR      SRRdIntCl
 
     C                   ENDDO
      *
      ** Write screen footer for this screen.
     C                   WRITE     SD0379F2
      *
      ** Write message subfile for error messages
     C                   WRITE     SD0379C1
      *                                                                         185998
      ** Format the latest total allocated nominal                              185998
      *                                                                         185998
     C                   EXSR      SRVUAHL                                      185998
     C                   MOVEL     *BLANKS       ZFld15                         185998
     C                   MOVEL     WTotIndiv     ZFld15                         185998
     C                   EXSR      SRFmtAmtO                                    185998
     C                   MOVE      ZOut21        STALL                          185998
      *                                                                         185998
      *
      ** Write and read the subfile control.
     C                   EXFMT     SD0379C0
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      *INKC = *ON
     C                   ROLBK
     C                   EVAL      WScrn = 'T'
     C                   GOTO      ESRReview
      *
      ** F5 - refresh screen.
     C                   WHEN      *INKE = *ON
      *
      ** If processing mode is enquiry and refresh function was pressed,
      ** clear message subfile for possible error messages.
     C                   IF        PMode = 'E'
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
     C                   GOTO      ESRReview
      *
      ** F9 - goto add mode.
     C                   WHEN      *INKI = *ON
     C                   EVAL      WKeyinF9  = 'Y'
     C                   EVAL      WWarned   = 'N'
     C                   EVAL      WAction   = 'I'
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WScrn = 'S'
      *
      ** Initialise screen fields for insert.
     C                   CLEAR                   WCurDet2
     C                   CLEAR                   WPrevDet2
     C                   GOTO      ESRReview
      *
      ** F12 - previous screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      WScrn = 'P'
     C                   GOTO      ESRReview
      *
      ** F21 - regenerate and review.
     C                   WHEN      *INKV = *ON
     C                   EXSR      SRRegenerate
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
     C                   GOTO      ESRReview
 
     C                   OTHER
 
     C                   IF        RollupKey = False
      *
      ** Enter key - read subfile for option.
     C                   DOU       *IN86 = *ON OR SOPTN <> *BLANK
     C                   READC     SD0379S0                               86
     C                   ENDDO
      *
      ** An option has been entered.
     C                   IF        *IN86 = *OFF
      *
      ** Activate SFLNXTCHG for the record to be read in the
      ** read-next-changed operation.
     C                   EVAL      *IN84 = '1'
     C                   UPDATE    SD0379S0
     C                   EVAL      *IN84 = '0'
     C                   WRITE     SD0379C0
     C                   EVAL      OptSelected = 'Y'
 
     C                   ELSE
      *
      ** No option has been entered.
     C                   EVAL      OptSelected = 'N'
 
     C                   ENDIF
 
     C                   IF        OptSelected <> 'Y'
      *
      ** Clear message subfile.
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
     C                   MOVEA     WResetInd     *IN(20)
      *
      ** Position record pointer to the top record.
     C     KClient       SETLL     SDINTCLL1
      *
      ** Read through intermediary clients details.
     C                   EXSR      SRRdIntCl
 
     C                   IF        EndOfFile = False
      *
      ** Re-initialise subfile relative record number.
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active for the next subfile build.
     C                   EVAL      *IN87 = *ON
     C                   WRITE     SD0379C0
     C                   EVAL      *IN87 = *OFF
     C                   ENDIF
 
     C                   ELSE
      *
      ** An option was entered against a subfile record.
     C                   EVAL      WKeyinF9  = 'N'
     C                   EVAL      WPrevScrn = WScrn
     C                   EVAL      WReadNext = 'Y'
 
     C                   ENDIF
 
     C                   ELSE
      *
      ** Rollup key - putback current relative record number.
     C                   Z-ADD     WT_Rrn        W_Rrn
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDIF
      *
      ** Read next subfile record was requested.
      *
     C                   IF        WReadNext = 'Y'
 
     C                   IF        PMode = 'E'
     C                   EXSR      SRRdNextE
     C                   ENDIF
 
     C                   IF        PMode = 'M'
     C                   EXSR      SRRdNextM
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESRReview     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNextE - Read next change record (enquiry mode).          *
      *                                                               *
      *****************************************************************
     C     SRRdNextE     BEGSR
      *
      ** Read subfile until no more change record or an option is found
      ** or change record was found.
     C                   EVAL      WChgRecFnd = 'N'
     C                   DOU       *IN86 = *ON OR SOPTN <> *BLANK OR
     C                             WChgRecFnd = 'Y'
 
     C                   READC     SD0379S0                               86
 
     C                   IF        *IN86 = *OFF
     C                   EVAL      WChgRecFnd = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        *IN86 <> *ON
      *
      ** If (A)mend or (D)elete was requested on enquiry mode,
      ** send the error "Option entered is invalid".
     C                   IF        SOPTN = 'A' OR SOPTN = 'D'
     C                   EVAL      WErrFnd = 'Y'
      *
      ** Send appropriate error message.
     C                   EVAL      P_MsgID  = 'USR7739'
     C                   EVAL      P_MsgDta = SOPTN
     C                   EXSR      SRSndMDta
      *
      ** Position subfile to the record in error and highlight
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN84 = *ON
     C                   UPDATE    SD0379S0
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN84 = *OFF
      *
      ** Save record number of the first record in error.
     C                   IF        WE_Rrn = *ZERO
     C                   Z-ADD     W_Rrn         WE_Rrn
     C                   ENDIF
      *
      ** Do not allow rebuilding of subfile.
     C                   EVAL      WBuildSfl = 'N'
     C                   GOTO      ESRRdNextE
     C                   ENDIF
      *
      ** If previous option in error was blanked out.
     C                   IF        SOPTN = ' '
     C                   EVAL      WErrFnd = 'N'
      *
      ** Initialise number of record in error.
     C                   Z-ADD     *ZERO         WE_Rrn
      *
      ** Reset error indicator.
     C                   EVAL      *IN31 = *OFF
     C                   UPDATE    SD0379S0
      *
      ** Do not allow rebuilding of subfile.
     C                   EVAL      WBuildSfl = 'N'
     C                   GOTO      ESRRdNextE
     C                   ENDIF
 
     C                   IF        SOPTN = 'E'
     C                   EVAL      WErrFnd = 'N'
     C                   EVAL      WAction = SOPTN
      *
      ** Initialise number of record in error.
     C                   Z-ADD     *ZERO         WE_Rrn
      *
      ** Move on to second screen if an option was found.
     C                   EVAL      WScrn = 'S'
      *
      ** Move file field to screen fields.
     C                   EVAL      SBONI = %SUBST(S#BONO:7:20)
     C                   EVAL      SBONM = S#BONM
     C                   EVAL      SBOA1 = S#BOA1
     C                   EVAL      SBOA2 = S#BOA2
     C                   EVAL      SBOA3 = S#BOA3
     C                   EVAL      SCTRS = S#CTRS
     C                   EVAL      SCSTN = S#CSTN
      *
      ** Save screen details.
     C                   EVAL      WPrevDet2 = WCurDet2
      *
      ** Update processed record.
     C                   EVAL      SOPTN = *BLANK
     C                   UPDATE    SD0379S0
     C                   ENDIF
 
     C                   ELSE
      *
      ** Re-build subfile if no pending option/error was found.
     C                   IF        WErrFnd = 'N'
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
     C                   ELSE
     C                   EXSR      SRInvEntry
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESRRdNextE    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInvEntry - Process invalid entry for enquiry mode.         *
      *                                                               *
      *****************************************************************
     C     SRInvEntry    BEGSR
      *
      ** Write screen footer for this screen.
      *
     C                   WRITE     SD0379F2
      *
      ** Write message subfile for error messages
      *
     C                   WRITE     SD0379C1
      *
      ** Position subfile to first record in error.
      *
     C                   Z-ADD     WE_Rrn        SSFRN
 
     C                   EXFMT     SD0379C0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      *INKC = *ON
     C                   ROLBK
     C                   EVAL      WScrn = 'T'
      *
      ** F5 - refresh screen.
     C                   WHEN      *INKE = *ON
      *
      ** If refresh function was pressed, clear message subfile
      ** for possible error messages and rebuild subfile.
     C                   CALL      'ZA0250'
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
 
     C                   OTHER
      *
      ** Re-read invalid record corrected or read next changed
      ** record on the subfile.
     C                   EVAL      WBuildSfl = 'N'
     C                   EVAL      WReadNext = 'Y'
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNextM - Read next change record (maintenance mode).      *
      *                                                               *
      *****************************************************************
     C     SRRdNextM     BEGSR
      *
      ** Read subfile until no more change record or an option is found.
      *
     C                   DOU       *IN86 = *ON OR SOPTN <> *BLANK
     C                   READC     SD0379S0                               86
     C                   ENDDO
 
     C                   IF        *IN86 <> *ON AND SOPTN <> *BLANK
     C                   EVAL      WAction = SOPTN
      *
      ***Unprotect*indicator*for*beneficiary*details.******************         185996
     C***********        EVAL      *IN81 = *OFF                                 185996
      *
      ** Move on to second screen if an option was found.
     C                   EVAL      WScrn = 'S'
      *
      ** Move file field to screen fields.
     C                   EVAL      SBONI = %SUBST(S#BONO:7:20)
     C                   EVAL      SBONM = S#BONM
     C                   EVAL      SBOA1 = S#BOA1
     C                   EVAL      SBOA2 = S#BOA2
     C                   EVAL      SBOA3 = S#BOA3
     C                   EVAL      SCTRS = S#CTRS
     C                   EVAL      SCSTN = S#CSTN
      *
      ** Save screen details.
     C                   EVAL      WPrevDet2 = WCurDet2
      *
      ** Update processed record.
     C                   EVAL      SOPTN = *BLANK
     C                   UPDATE    SD0379S0
 
     C                   ELSE
      *
      ** Re-build subfile if no pending option was found.
     C                   EVAL      WBuildSfl = 'Y'
     C                   EVAL      WReadNext = 'N'
     C                   EVAL      WScrn     = 'R'
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdIntCl - Read intermediary client detail file.            *
      *                                                               *
      *****************************************************************
     C     SRRdIntCl     BEGSR
      *
      ** Read the file initially - if EndOfFile is set on, then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
      *
     C                   DOU       EndOfFile = True OR WError = *ZERO
      *
      ** Read intermediary client detail file.
     C     KClient       READE     SDINTCLL1                              85
 
     C                   IF        SCNUM = INCNUM AND SSECS = INSECS
     C                   EVAL      WError = '0'
     C                   ELSE
     C                   EVAL      WError = '1'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDetI - Format input fields for subfile display.         *
      *                                                               *
      *****************************************************************
     C     SRFmtDetI     BEGSR
      *
      ** Record Id.
      *
     C                   EVAL      S#RECI = INRECI
      *
      ** Customer number
      *
     C                   EVAL      S#CNUM = INCNUM
      *
      ** Security shortname
      *
     C                   EVAL      S#SECS = INSECS
      *
      ** Depot number
      *
     C                   EVAL      S#DEPT = INDEPT
      *
      ** Total holding
      *
     C                   Z-ADD     INTOTH        S#TOTH
      *
      ** Tax basket
      *
     C                   EVAL      S#TXBS = INTXBS
     C                   EVAL      STXBS  = INTXBS
      *
      ** Beneficial owner number
      *
     C                   IF        INBONO <> *BLANKS
     C                   MOVEL     INBONO        S#BONO
     C                   MOVEL     INBONO        SBONO
     C                   ELSE
     C                   MOVEL     *BLANKS       S#BONO
     C                   MOVEL     *BLANKS       SBONO
     C                   ENDIF
      *
      ** Beneficial owner name
      *
     C                   EVAL      S#BONM = INBONM
      *
      ** Beneficial owner address 1
      *
     C                   EVAL      S#BOA1 = INBOA1
      *
      ** Beneficial owner address 2
      *
     C                   EVAL      S#BOA2 = INBOA2
      *
      ** Beneficial owner address 3
      *
     C                   EVAL      S#BOA3 = INBOA3
      *
      ** Country of residence
      *
     C                   EVAL      S#CTRS = INCTRS
      *
      ** Customer TIN
      *
     C                   EVAL      S#CSTN = INCSTN
      *
      ** Holding
      *
     C                   Z-ADD     INHLDN        S#HLDN
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVEL     INHLDN        ZFld15
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        SHLDN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDetO - Format fields for output.                        *
      *                                                               *
      *****************************************************************
     C     SRFmtDetO     BEGSR
      *
      ** Record Id.
      *
     C                   EVAL      INRECI = 'D'
      *
      ** Customer number
      *
     C                   EVAL      INCNUM = SCNUM
      *
      ** Security shortname
      *
     C                   EVAL      INSECS = SSECS
      *
      ** Depot number
      *
     C                   EVAL      INDEPT = SDEPT
      *
      ** Total holding
      *
     C                   Z-ADD     WTOTH         INTOTH
      *
      ** Tax basket
      *
     C                   EVAL      INTXBS = STXBS
      *
      ** Beneficial owner number
      *
     C                   IF        SBONI <> *BLANKS
     C                   EVAL      INBONO = SCNUM + SBONI
     C                   ELSE
     C                   EVAL      INBONO = *BLANKS
     C                   ENDIF
      *
      ** Beneficial owner name
      *
     C                   MOVE      SBONM         INBONM
      *
      ** Beneficial owner address 1
      *
     C                   MOVE      SBOA1         INBOA1
      *
      ** Beneficial owner address 2
      *
     C                   MOVE      SBOA2         INBOA2
      *
      ** Beneficial owner address 3
      *
     C                   MOVE      SBOA3         INBOA3
      *
      ** Country of residence
      *
     C                   MOVE      SCTRS         INCTRS
      *
      ** Customer TIN
      *
     C                   MOVE      SCSTN         INCSTN
      *
      ** Holding
      *
     C                   Z-ADD     WHolding      INHLDN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBnfToInt - Format fields from Beneficiary file to          *
      *               Intermediary file.                              *
      *                                                               *
      *****************************************************************
     C     SRBnfToInt    BEGSR
      *
      ** Record Id.
      *
     C                   EVAL      INRECI = 'D'
      *
      ** Customer number
      *
     C                   EVAL      INCNUM = SCNUM
      *
      ** Security shortname
      *
     C                   EVAL      INSECS = SSECS
      *
      ** Depot number
      *
     C                   EVAL      INDEPT = SDEPT
      *
      ** Total holding
      *
     C                   Z-ADD     WTOTH         INTOTH
      *
      ** Tax basket
      *
     C                   EVAL      INTXBS = BNTXBS
      *
      ** Beneficial owner number
      *
     C                   MOVE      BNBONO        INBONO
      *
      ** Beneficial owner name
      *
     C                   MOVE      BNBONM        INBONM
      *
      ** Beneficial owner address 1
      *
     C                   MOVE      BNBOA1        INBOA1
      *
      ** Beneficial owner address 2
      *
     C                   MOVE      BNBOA2        INBOA2
      *
      ** Beneficial owner address 3
      *
     C                   MOVE      BNBOA3        INBOA3
      *
      ** Country of residence
      *
     C                   IF        BNCTRS = *BLANKS
     C                   MOVE      WCOLC         INCTRS
     C                   ELSE
     C                   MOVE      BNCTRS        INCTRS
     C                   ENDIF
      *
      ** Customer TIN
      *
     C                   MOVE      *BLANKS       INCSTN
      *
      ** Holding
      *
     C                   EVAL      WHolding = *ZEROS
      *
      ** If percentage allocation for holding does not exist zeroise holding.
      ** Otherwise, compute for its holding.
     C                   IF        BNPAHD = *ZERO
 
     C                   Z-ADD     *ZERO         INHLDN
 
     C                   ELSE
 
     C                   IF        WShortPos = 'Y'
 
     C                   Z-SUB     WTOTH         W_TOTH
     C                   Z-ADD     *ZEROS        WPctAlloc
     C     BNPAHD        DIV       100           WPctAlloc
 
     C                   EVAL      WHolding = W_TOTH * WPctAlloc
 
     C                   MOVEL     *BLANKS       ZAField
     C                   MOVEL     WHolding      ZAField
     C                   Z-ADD     0             ZADec
     C                   Z-ADD     15            ZADig
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZAField
     C                   PARM                    ZADec
     C                   PARM                    ZADig
 
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZAField       WHolding
     C                   ENDIF
 
     C                   Z-SUB     WHolding      INHLDN
 
     C                   ELSE
 
     C                   Z-ADD     WTOTH         W_TOTH
     C                   Z-ADD     *ZEROS        WPctAlloc
     C     BNPAHD        DIV       100           WPctAlloc
 
     C                   EVAL      WHolding = W_TOTH * WPctAlloc
 
     C                   MOVEL     *BLANKS       ZAField
     C                   MOVEL     WHolding      ZAField
     C                   Z-ADD     0             ZADec
     C                   Z-ADD     15            ZADig
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZAField
     C                   PARM                    ZADec
     C                   PARM                    ZADig
 
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZAField       WHolding
     C                   ENDIF
 
     C                   Z-ADD     WHolding      INHLDN
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update intermediary client detail file.           *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
      ** If record was amended or deleted, validate record.
      *
     C                   IF        WAction = 'A' OR WAction = 'D'
 
     C                   IF        SBONI <> *BLANKS
     C                   EVAL      WBenefNo = SCNUM + SBONI
     C                   ELSE
     C                   EVAL      WBenefNo = *BLANKS
     C                   ENDIF
 
     C                   IF        WHINTS = 'QI'
     C     KIntermed     SETLL     SDINTCLL0
     C     KIntermed     READE     SDINTCLL0                              08
     C                   ELSE
     C     KClientChk2   SETLL     SDINTCLL5
     C     KClientChk2   READE     SDINTCLL5                              08
     C                   ENDIF
      *
      ** If record was not found, send "Record missing on file."
     C                   IF        *IN08 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7733'
     C                   EXSR      SRSndM
     C                   GOTO      ESRUpdate
     C                   ENDIF
      *
      ** If record was found but is not equal with the newly
      ** retrieved record, send "Record has been updated by another
      ** workstation.".
     C                   IF        *IN08 = *OFF
 
     C                   IF        W_OldDet <> W_NewDet
 
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7734'
     C                   EXSR      SRSndM
     C                   GOTO      ESRUpdate
 
     C                   ELSE
      *
      ** If action is amend, update record.  Otherwise delete record.
     C                   IF        WAction = 'A'
 
     C                   EXSR      SRFmtDetO
 
     C                   IF        WHINTS = 'QI'
     C                   UPDATE    @INTCL0
     C                   ELSE
     C                   UPDATE    @INTCL5
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WHINTS = 'QI'
     C                   DELETE    @INTCL0
     C                   ELSE
     C                   DELETE    @INTCL5
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If record was inserted write a new record.
      *
     C                   IF        WAction = 'I'
     C                   EXSR      SRFmtDetO
     C                   WRITE     @INTCL0
     C                   ENDIF
      *
      ** Update standing data control file if no more error encountered.
      *
     C                   IF        ErrIdx = *ZEROS
 
     C     MainFilNam    CHAIN     SDFCTLL0                           09
 
     C                   IF        *IN09 = *ON
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = MainFilNam
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      WAction  = 'I'
     C                   EVAL        AHNOIN = AHNOIN + 1
     C                   EVAL        AHNORC = AHNORC + 1
     C                   WHEN      WAction  = 'A'
     C                   EVAL        AHNOAM = AHNOAM + 1
     C                   WHEN      WAction  = 'D'
     C                   EVAL        AHNORC = AHNORC - 1
     C                   EVAL        AHNODL = AHNODL + 1
     C                   ENDSL
 
     C                   UPDATE    @AHREAU
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If no pending error exist, commit changes. Otherwise,
      ** rollback.
      *
     C                   IF        ErrIdx = *ZEROS
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
     C     ESRUpdate     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRegenerate - Regenerate record from beneficiary to         *
      *                 intermediary.                                 *
      *                                                               *
      *****************************************************************
     C     SRRegenerate  BEGSR
      *
      ** If the customer has beneficiaries setup, delete intermediary
      ** records for this customer and generate a fresh record out of
      ** the benefiaciary details.
      *
     C                   EVAL      WDepotA = SDEPT
     C     KCustCntry    CHAIN     SDBNFOL1                           06
      *
      ** If no beneficiary was setup for the customer,country & depot
      ** combinations, use the generic beneficiary details.
      *
     C                   IF        *IN06 = *ON
     C                   EVAL      WDepotA = *BLANKS
     C     KCustCntry    CHAIN     SDBNFOL1                           06
     C                   ENDIF
 
     C                   IF        *IN06 = *OFF
      *
      ** Delete processing
     C     KCust_SecS    SETLL     SDINTCLL0
     C     KCust_SecS    READE     SDINTCLL0                              08
 
     C                   EVAL      WCountDel = *ZERO
     C                   DOW       *IN08 = *OFF
     C                   EVAL      WCountDel = WCountDel + 1
     C                   DELETE    @INTCL0
     C     KCust_SecS    READE     SDINTCLL0                              08
     C                   ENDDO
      *
      ** Regenerate processing
     C                   EVAL      WCountIns = *ZERO
     C                   EXSR      SRGenerate
      *
      ** Update standing data control file if there are records deleted and
      ** inserted.
     C                   IF        WCountDel <> *ZERO AND WCountIns <> *ZERO
 
     C     MainFilNam    CHAIN     SDFCTLL0                           09
 
     C                   IF        *IN09 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = MainFilNam
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE  = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      AHNODL = AHNODL + WCountDel
     C                   EVAL      AHNOIN = AHNOIN + WCountIns
     C                   EVAL      AHNORC = (AHNORC + WCountIns) - WCountDel
     C                   UPDATE    @AHREAU
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenerate - Generate beneficiaries record to intermediary   *
      *               detail file.                                    *
      *                                                               *
      *****************************************************************
     C     SRGenerate    BEGSR
      *
      ** Set pointer to the top record and read the first record.
      *
     C                   EVAL      WDepotA = SDEPT
     C     KCustCntry    SETLL     SDBNFOL1
     C     KCustCntry    READE     SDBNFOL1                               06
      *
      ** If no beneficiary was setup for the customer,country & depot
      ** combinations, use the generic beneficiary details.
      *
     C                   IF        *IN06 = *ON
     C                   EVAL      WDepotA = *BLANKS
     C     KCustCntry    SETLL     SDBNFOL1
     C     KCustCntry    READE     SDBNFOL1                               06
     C                   ENDIF
      *
      ** Generate record in intermediary file while a record in beneficiary
      ** file exist for the customer.
      *
     C                   DOW       *IN06 = *OFF
 
     C                   EVAL      WCountIns = WCountIns + 1
      *
      ** Format fields for output
     C                   EXSR      SRBnfToInt
 
     C                   WRITE     @INTCL0
 
     C     KCustCntry    READE     SDBNFOL1                               06
 
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScn1Det - Validate first screen details                   *
      *                                                               *
      *****************************************************************
     C     SRVScn1Det    BEGSR
      *
      ** Validate security shortname
      *
     C                   IF        SSECS = *BLANKS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7725'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   EXSR      SRVSECS
     C                   ENDIF
      *
      ** Validate customer number and Depot, only if a valid security
      ** was entered to make sure country of treaty is available for
      ** customer validation.
      *
     C                   IF        *IN21 = *OFF
      *
      ** Validate customer
     C                   IF        SCNUM = *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7720'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   EXSR      SRVCNUM
     C                   ENDIF
      *
      ** Validate depot
     C                   IF        SDEPT = *BLANKS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      P_MsgID = 'USR7742'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   EXSR      SRVDEPT
     C                   ENDIF
      *
      ** Format total holding for display, only if a valid customer
      ** and depot was entered.
     C                   IF        *IN20 = *OFF AND *IN31 = *OFF
     C                   EXSR      SRVTOTH
      *                                                                         185998
      ** Format the latest total allocated nominal                              185998
      *                                                                         185998
     C                   EXSR      SRVUAHL                                      185998
     C                   MOVEL     *BLANKS       ZFld15                         185998
     C                   MOVEL     WTotIndiv     ZFld15                         185998
     C                   EXSR      SRFmtAmtO                                    185998
     C                   MOVE      ZOut21        STALL                          185998
      *                                                                         185998
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSECS - Validate security shortname                        *
      *                                                               *
      *****************************************************************
     C     SRVSECS       BEGSR
 
     C     SSECS         CHAIN     SECTY                              03
      *
      ** If there is no valid record in securities file, it is an error.
      *
     C                   IF        *IN03 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7740'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
      ** If a valid record was found but country of tax is blank,
      ** it is an error.
      *
     C                   IF        *IN03 = *OFF AND CRTT = *BLANKS
      *                                                                                     BUG12368
      ** Country of tax cannot be blank only if CSE023 is on                                BUG12368
      *                                                                                     BUG12368
     C                   IF        CSE023 = 'Y'                                             BUG12368
     C                   EVAL      *IN21 = *ON
     C                   EVAL      P_MsgID = 'USR7724'
     C                   EXSR      SRSndM
     C                   ENDIF                                                              BUG12368
      *                                                                                     BUG12368
     C                   ELSE
      *
      ** Save country of treaty for customer and tax basket validation.
     C                   EVAL      WCountry = CRTT
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCNUM - Validate customer number                           *
      *                                                               *
      *****************************************************************
     C     SRVCNUM       BEGSR
      *
      ** Entry is not blank, must be a valid security customer.
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C     SCNUM         PARM      SCNUM         PCust
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** Entry is not a valid security customer
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7722'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Customer must only be safe custody or discretionary
      ** customers.
     C                   IF        BFCLAS <> 'S' AND BFCLAS <> 'D'
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7731'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Entry is a valid security customer, check against withholding
      ** tax customer details, only if CSE023 is on.                                        BG12368A
      ***tax*customer*details.*****************************************                     BG12368A
     C                   IF        CSE023 = 'Y'                                             BG12368A
     C     KTaxCust      CHAIN     SDWTCSL1                           02
 
     C                   IF        *IN02 = *ON
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7723'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   IF        WHDCRC <> 'I'
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'USR7723'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              BG12368A
      *                                                                                     BG12368A
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDEPT - Validate depot                                     *
      *                                                               *
      *****************************************************************
     C     SRVDEPT       BEGSR
      *
      ** Entry is not blank, must be a valid security customer.
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C     SDEPT         PARM      SDEPT         PCust
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** Entry is not a valid depot customer
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      P_MsgID = 'USR7743'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** Classification for depot customer must be: X - Depot, E - Euroclear
      ***C*-*Cedel*or*K*-*Kassenverein.********************************                       CSE022
      ** or C - Cedel.                                                                        CSE022
 
     C                   IF        BFCLAS <> 'X' AND BFCLAS <> 'E' AND
     C***********                  BFCLAS <> 'C' AND BFCLAS <> 'K'              185728
     C**********                   BFCLAS <> 'C' AND BFCLAS <> 'K' AND          185728        CSE022
     C**********                   BFCLAS <> 'M'                                185728        CSE022
     C                             BFCLAS <> 'C' AND BFCLAS <> 'M'                            CSE022
     C                   EVAL      *IN31 = *ON
     C                   EVAL      P_MsgID = 'USR7744'
     C                   EXSR      SRSndM
     C                   ELSE
     C                   EVAL      WDepotA = SDEPT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTOTH - Format total holding                               *
      *                                                               *
      *****************************************************************
     C     SRVTOTH       BEGSR
      *
      ** Setup key fields for customer positions file.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      SCNUM         PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** DB error if customer is not a live customer.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = PKey1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBranch = BBBRCD
     C                   EVAL      WCOLC   = BBCOLC
     C                   ENDIF
 
     C                   EVAL      WSShortN = SSECS
     C                   MOVEL     SCNUM         WCustNo
     C*****              MOVEL     SDEPT         WDepot                                       CSD027
     C                   MOVEL     SDEPT         WDepotA                                      CSD027
      *
      ** Retrive customer & security positions.
      *
     C     KCustDptPos   CHAIN     CDEPP                              04
      *
      ** If no record found in customer positions file, blank out
      ** total holding.
      *
     C                   Z-ADD     *ZEROS        WTOTH
     C                   IF        *IN04 = *ON
     C                   EVAL      STOTH = *BLANKS
     C                   ELSE
      *
      ** Positions was found and if feature "dividend payments based
      ** on ex-date" is installed, use trade date nominal.
     C                   IF        S01510 = 'Y'
     C                   Z-ADD     CDNT          WTOTH
     C                   ADD       SNPT          WTOTH
     C                   ADD       CDST          WTOTH
      *
      ** If customer position is a short position set flag to 'Y'.
      ** Otherwise, set to 'N'.
     C                   IF        WTOTH < *ZERO
     C                   EVAL      WShortPos = 'Y'
     C                   ELSE
     C                   EVAL      WShortPos = 'N'
     C                   ENDIF
     C                   ELSE
      *
      ** Otherwise, use value date nominal.
     C                   Z-ADD     CDNV          WTOTH
     C                   ADD       CNPV          WTOTH
     C                   ADD       CNSV          WTOTH
      *
      ** If customer position is a short position set flag to 'Y'.
      ** Otherwise, set to 'N'.
     C                   IF        WTOTH < *ZERO
     C                   EVAL      WShortPos = 'Y'
     C                   ELSE
     C                   EVAL      WShortPos = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Format total holding for screen output.
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVEL     WTOTH         ZFld15
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        STOTH
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScn2Det - Validate second screen details                  *
      *                                                               *
      *****************************************************************
     C     SRVScn2Det    BEGSR
      *
      ** Validate tax basket
      *
      ** Check tax basket details if CSE023 is ON                                           BUG12405
      *                                                                                     BUG12405
     C                   If        CSE023 = 'Y'                                             BUG12405
      *                                                                                     BUG12405
     C                   EXSR      SRVTXBS
      *                                                                                     BUG12405
     C                   EndIf                                                              BUG12405
      *
      ** Validate beneficial owner details
      *
     C                   EXSR      SRVBenefDet
      *
      ** Validate country of residence
      *
     C                   EXSR      SRVCTRS
      *
      ** Validate holding
      *
     C                   EXSR      SRVHLDN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVUAHL - Format unallocated holding for display             *
      *                                                               *
      *****************************************************************
     C     SRVUAHL       BEGSR
      *
      ** Position record pointer to the top record and read starting
      ** from the first picked record.
      *
     C     KClient       SETLL     SDINTCLL1
     C     KClient       READE     SDINTCLL1                              05
      *
      ** If no intermediary client has been entered for this customer,
      ** default unallocated holding to total holding.
      *
     C                   EVAL      WUnalloc = *ZERO
     C                   IF        *IN05 = *ON
     C                   MOVE      STOTH         SUAHL
     C                   Z-ADD     WTOTH         WUnalloc
     C                   ELSE
     C                   EVAL      WTotIndiv = *ZEROS
      *
      ** If an intermediary client already exist read through the individual
      ** details and sum up all the individual holdings.
     C                   DOW       *IN05 = *OFF
     C                   IF        INHLDN <> *ZEROS
     C                   EVAL      WTotIndiv = WTotIndiv + INHLDN
     C                   ENDIF
     C     KClient       READE     SDINTCLL1                              05
     C                   ENDDO
      *
      ** Derive unallocated holding
     C                   EVAL      WUnalloc = WTOTH - WTotIndiv
      *
      ** Format unallocated holding for display
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVEL     WUnalloc      ZFld15
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        SUAHL
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTXBS - Validate tax basket                                *
      *                                                               *
      *****************************************************************
     C     SRVTXBS       BEGSR
      *
      ** Tax basket is mandatory if customer is a qualified intermediary.
      *
     C                   IF        STXBS = *BLANKS
 
     C                   IF        WHINTS = 'QI' AND WAction = 'I'
     C                   EVAL      *IN22 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7737'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ELSE
      *
      ** Tax basket must be in tax basket table.
     C     KTaxBasket    CHAIN     SDTXBSL1                           07
 
     C                   IF        *IN07 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7728'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBenefDet - Validate beneficial owner detail               *
      *                                                               *
      *****************************************************************
     C     SRVBenefDet   BEGSR
      *
      ** Beneficiary owner number is mandatory for 'NQI' or 'FTE'
      ** customer.
      *
     C                   IF        WAction = 'I' AND SBONI = *BLANKS
 
     C                   IF        WHINTS = 'NQI' OR WHINTS = 'FTE'
     C                   EVAL      *IN23 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7738'
     C                   EXSR      SRSndM
     C                   ELSE
 
     C                   If        *IN81 = *On                                              BUG12405
     C                   EVAL      WBenefNo = *BLANKS
     C     KClientChk1   CHAIN     SDINTCLL3                          10
     C                   IF        *IN10 = *OFF
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7746'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   EndIf                                                              BUG12405
     C                   ENDIF
 
     C                   GOTO      EBenefDet
 
     C                   ENDIF
      *
      ** Validate beneficiary details if beneficiary number was entered.
      *
     C                   IF        SBONI <> *BLANKS
 
     C                   EVAL      WBenefNo = SCNUM + SBONI
     C                   EVAL      WDepotA = SDEPT
     C     KBenef        CHAIN     SDBNFOL1                           06
 
     C                   IF        *IN06 = *ON
     C                   EVAL      WDepotA = *BLANKS
     C     KBenef        CHAIN     SDBNFOL1                           06
      *
      ** Beneficial owner must be on beneficial owners table.
     C                   IF        *IN06 = *ON AND WAction = 'I'
     C                   EVAL      *IN23 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7726'
     C                   EXSR      SRSndM
     C                   GOTO      EBenefDet
     C                   ENDIF
     C                   ENDIF
      *
      ** If beneficial owner number exist in table, check if
      ** beneficiary already exist in intermediary table, error if
      ** it does.
     C                   IF        *IN06 = *OFF
 
     C                   IF        WHINTS = 'QI'
     C     KClientChk1   CHAIN     SDINTCLL3                          10
     C                   ELSE
     C     KClientChk2   CHAIN     SDINTCLL4                          10
     C                   ENDIF
 
     C                   IF        WAction = 'I'
     C                   IF        *IN10 = *OFF
     C                   EVAL      *IN23 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7745'
     C                   EXSR      SRSndM
     C                   GOTO      EBenefDet
     C***********        ELSE                                                   185996
     C***********        EVAL      *IN81 = *ON                                  185996
     C                   ENDIF
     C                   ENDIF
      *
      ** Beneficial owner name
      *
     C***********        IF        SBONM = *BLANKS                              185996
     C                   MOVEL     BNBONM        SBONM
     C***********        ENDIF                                                  185996
      *
      ** Beneficial address 1
      *
     C***********        IF        SBOA1 = *BLANKS                              185996
     C                   EVAL      SBOA1 = BNBOA1
     C***********        ENDIF                                                  185996
      *
      ** Beneficial address 2
      *
     C***********        IF        SBOA2 = *BLANKS                              185996
     C                   EVAL      SBOA2 = BNBOA2
     C***********        ENDIF                                                  185996
      *
      ** Beneficial address 3
      *
     C***********        IF        SBOA3 = *BLANKS                              185996
     C                   EVAL      SBOA3 = BNBOA3
     C***********        ENDIF                                                  185996
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EBenefDet     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCTRS - Validate country of residence                      *
      *                                                               *
      *****************************************************************
     C     SRVCTRS       BEGSR
      *
      ** Default country of residence if no entry has been made.
      *
     C                   IF        SCTRS = *BLANKS
 
     C                   IF        BNCTRS = *BLANKS
     C                   EVAL      SCTRS = WCOLC
     C                   ELSE
     C                   EVAL      SCTRS = BNCTRS
     C                   ENDIF
 
     C**********         ELSE
      **********
      ** Country of residence must be a live country code
      **********
     C**********         CALL      'AOCTRYR0'
     C**********         PARM      *BLANKS       PRtCd
     C**********         PARM      '*KEY   '     POptn
     C*****SCTRS         PARM      SCTRS         PCrtt
     C*****SDCTRY        PARM      SDCTRY        DSFDY
 
     C***********        IF        PRtcd <> *BLANKS
     C***********        EVAL      *IN28 = *ON
     C***********        EVAL      ErrIdx  = ErrIdx + 1
     C***********        EVAL      P_MsgID = 'USR7727'
     C***********        EXSR      SRSndM
     C***********        ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHLDN - Validate holding                                   *
      *                                                               *
      *****************************************************************
     C     SRVHLDN       BEGSR
      *
      ** If beneficial owner number was entered and percentage allocation
      ** of holding exist, compute holding base from percentage holding.
      ** Otherwise, holding = holding entered.
      *
     C                   EVAL      WHolding = *ZEROS
     C                   IF        SBONI <> *BLANKS AND *IN23 = *OFF
      *
      ** If percentage allocation of holding exist for beneficiary owner,
      ** compute holding from percentage holding.
     C                   IF        BNPAHD <> *ZERO
      *
      ** Overwrite computed holding if holding was entered.
     C                   IF        SHLDN <> *BLANKS
 
     C                   MOVEL     *BLANKS       ZFLD17
     C                   MOVEL     SHLDN         ZFLD17
 
     C                   EXSR      ZASIGN
 
     C                   IF        ZASIGNOk = 'Y'
     C                   MOVE      ZOUT15        WHolding
     C                   IF        ZFSIGN = '-'
     C                   Z-SUB     WHolding      WHolding
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7732'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     *ZEROS        WPctAlloc
     C     BNPAHD        DIV       100           WPctAlloc
 
     C                   EVAL      WHolding = WTOTH * WPctAlloc
     C                   MOVEL     *BLANKS       ZFLD17
     C                   MOVEL     WHolding      ZFLD17
 
     C                   EXSR      ZASIGN
 
     C                   IF        ZASIGNOk = 'Y'
     C                   MOVE      ZOUT15        WHolding
     C                   IF        ZFSIGN = '-'
     C                   Z-SUB     WHolding      WHolding
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WAction = 'I' AND WHolding <> *ZEROS
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVEL     WHolding      ZFld15
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        SHLDN
      *
      ** If holding computed is greater than the unallocated holding, error.
     C                   IF        WHolding > WUnalloc
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7741'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   GOTO      ESRVHLDN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
      *
      ** If percentage allocation holding does not exist, require entry for
      ** holding.
     C                   IF        SHLDN = *BLANKS
 
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7729'
     C                   EXSR      SRSndM
 
     C                   ELSE
 
     C                   MOVEL     *BLANKS       ZFLD17
     C                   MOVEL     SHLDN         ZFLD17
 
     C                   EXSR      ZASIGN
 
     C                   IF        ZASIGNOk = 'Y'
     C                   MOVE      ZOUT15        WHolding
     C                   IF        ZFSIGN = '-'
     C                   Z-SUB     WHolding      WHolding
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7732'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
      *
      ** Beneficiary number was not entered.
     C                   IF        SHLDN = *BLANKS
 
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7729'
     C                   EXSR      SRSndM
 
     C                   ELSE
 
     C                   MOVEL     *BLANKS       ZFLD17
     C                   MOVEL     SHLDN         ZFLD17
 
     C                   EXSR      ZASIGN
 
     C                   IF        ZASIGNOk = 'Y'
     C                   MOVE      ZOUT15        WHolding
     C                   IF        ZFSIGN = '-'
     C                   Z-SUB     WHolding      WHolding
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7732'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Reformat holding for display
      *
     C                   IF        WAction = 'I' AND WHolding <> *ZEROS
 
     C                   MOVEL     *BLANKS       ZFld15
     C                   MOVEL     WHolding      ZFld15
     C                   EXSR      SRFmtAmtO
     C                   MOVE      ZOut21        SHLDN
      *
      ** If holding entered is greater than the unallocated holding, error.
     C                   IF        WHolding > WUnalloc
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ErrIdx  = ErrIdx + 1
     C                   EVAL      P_MsgID = 'USR7735'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESRVHLDN      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZASIGN - Validate & Right Align a Signed Numeric Field        *
      *                                                               *
      *****************************************************************
     C     ZASIGN        BEGSR
 
     C                   Z-ADD     0             ZSDEC
     C                   Z-ADD     14            ZSDIG
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmtO - Format amount for display                        *
      *                                                               *
      *****************************************************************
     C     SRFmtAmtO     BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFld15
     C                   PARM      *ZERO         ZDecs
     C                   PARM      'L'           ZECode
     C                   PARM      *BLANKS       ZEChar
     C                   PARM      *BLANKS       ZOut21
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Handles the display of error messages.              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM      'GBSDUSRMSG'  P_MsgFile
     C                   PARM                    P_MsgID
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMDta - Handles the display of error messages with data. *
      *                                                               *
      *****************************************************************
     C     SRSndMDta     BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM      'GBSDUSRMSG'  P_MsgFile
     C                   PARM                    P_MsgID
     C                   PARM                    P_MsgDta
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, AOSARDR0                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
      *
      ** Read in installation data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if S01510 (Dividend payment
      ** based on ex-date) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01510'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKEY  = 'S01510'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      S01510 = 'Y'
     C                   ELSE
     C                   EVAL      S01510 = 'N'
     C                   ENDIF
      *                                                                                     BUG12368
      ** Access SAR file to determine if CSE023 (Treaty Withholding Tax)                    BUG12368
      ** is installed.                                                                      BUG12368
      *                                                                                     BUG12368
     C                   CALLB     'AOSARDR0'                                               BUG12368
     C                   PARM      *BLANKS       PRtcd                                      BUG12368
     C                   PARM      '*VERIFY'     POptn                                      BUG12368
     C                   PARM      'CSE023'      PSARd                                      BUG12368
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG12368
      *                                                                                     BUG12368
      ** An NRF (No Record Found) return code is valid.                                     BUG12368
      ** Issue database error only for error return codes.                                  BUG12368
      *                                                                                     BUG12368
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                  BUG12368
     C                   EVAL      DBKEY  = 'CSE023'                                        BUG12368
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG12368
     C                   EVAL      DBASE  = 006                                             BUG12368
     C                   EXSR      *PSSR                                                    BUG12368
     C                   ENDIF                                                              BUG12368
                                                                                            BUG12368
     C                   IF        PRtcd = *BLANKS                                          BUG12368
     C                   EVAL      CSE023 = 'Y'                                             BUG12368
     C                   ELSE                                                               BUG12368
     C                   EVAL      CSE023 = 'N'                                             BUG12368
     C                   ENDIF                                                              BUG12368
      *
      ** Initialise job information & message file to use.
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SRUNA = BJMRDT
     C                   EVAL      SWSID = PSJOBNAME
     C                   EVAL      P_MsgFile  = 'GBSDUSRMSG'
     C                   EVAL      MainFilNam = 'SDINTCLPD '
      *
      ** Key list for customer positions
      *
     C     KCustDptPos   KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCustNo
     C                   KFLD                    WSShortN
     C*****              KFLD                    WDepot                                       CSD027
     C                   KFLD                    WDepotA                                      CSD027
      *
      ** Key list for intermediary clients detail
      *
     C     KClient       KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    SSECS
     C                   KFLD                    SDEPT
 
     C     KCust_SecS    KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    SSECS
     C                   KFLD                    SDEPT
 
     C     KIntermed     KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    SSECS
     C                   KFLD                    SDEPT
     C                   KFLD                    WPrevTXBS
     C                   KFLD                    WBenefNo
 
     C     KClientChk1   KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    SSECS
     C                   KFLD                    SDEPT
     C                   KFLD                    WBenefNo
     C                   KFLD                    STXBS
 
     C     KClientChk2   KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    SSECS
     C                   KFLD                    SDEPT
     C                   KFLD                    WBenefNo
      *
      ** Key list for beneficial owner
      *
     C     KBenef        KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    WCountry
     C                   KFLD                    WDepotA
     C                   KFLD                    WBenefNo
 
     C     KCustCntry    KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    WCountry
     C                   KFLD                    WDepotA
      *
      ** Key list for withholding tax customer details
      *
     C     KTaxCust      KLIST
     C                   KFLD                    SCNUM
     C                   KFLD                    WCountry
      *
      ** Key list for tax basket details
      *
     C     KTaxBasket    KLIST
     C                   KFLD                    WCountry
     C                   KFLD                    STXBS
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN89 = *ON
     C                   EVAL      SPGMQ = '*'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
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
**  CPY@
(c) Finastra International Limited 2001
**  WResetInd
00000000000000000000000000000000000000000000000000
