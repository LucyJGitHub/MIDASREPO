     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Allocations Update Function')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLAUPD - GL Collateral Allocation Update Function Module  *
      *                                                               *
      *  Function:  This API module will serve as the Update module   *
      *             of the complete API program and will be made      *
      *             switchable under enhancement number CGL011.       *
      *                                                               *
      *  Called By: GLCOLASIN (*Pgm)                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAS009             Date 16May05               *
      *                 CLE040             Date 05Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 07Nov03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP074             Date 08Aug02               *
      *                 CAP073             Date 08Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 25JUN02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Add processing for data area COALLO to automati-    *
      *           cally calculate Front Office Transaction Ref.       *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP068 - Recompiled for changes to FCLTYFM and FCLTYFN.      *
      *  CGL011 - Collateral Processing for Midas.                    *
      *                                                               *
      *****************************************************************

     FGLCOLAL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLAD3)
     FGLCOLAL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLAD4)
     FGLCOLAL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLAD5)
     FGLCOLAL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLAD6)
     FGLCOLLL2  IF   E           K DISK    INFSR(*PSSR)
     FGLCOLLL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD3)
     FGLCOLLL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD4)
     FGLCOLLL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD5)
     FGLCOLLL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD6)
     FFOCLT     UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDFOCSL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
     F                                     COMMIT
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     COMMIT
     FACCNT     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF:ACCNTACF)
     F                                     COMMIT
     FSDCLLML0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGLCOLAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** Collateral Allocation File Format
     D ValidRec      E DS                  EXTNAME(GLCOLAPD)

      ** CA Record format
     D RecToAmend    E DS                  EXTNAME(GLCOLAPD)
     D                                     PREFIX(@)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for Access Object Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CAP084
     D COALLO        E DS                  EXTNAME(COALLO)                                    CAP084
      ***  DS for calculating Front Office Transaction ID                                     CAP084

      ** Request to update
     D WAmendReq       S              1A

      ** Timestamp field
     D PtimeStamp      S               Z

      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Return if action code is not 'I','A', or 'D'

     C                   If        (CACHTP <> 'I') And
     C                             (CACHTP <> 'A') And
     C                             (CACHTP <> 'D')
     C                   Return
     C                   EndIf

      ** Insert

     C     CACHTP        CasEq     'I'           SRINS

      ** Amend

     C     CACHTP        CasEq     'A'           SRAMD

      ** Delete

     C     CACHTP        CasEq     'D'           SRDEL
     C                   EndCs

      ** Process according to secured module

     C                   Select

      ** Foreign Exchange or Money Market Module secured

     C     @CAMODS       WhenEq    'FX'
     C     @CAMODS       OrEq      'MM'
     C                   ExSr      SRLMTAMD

      ** Futures and Options Module secured

     C     @CAMODS       WhenEq    'FO'
     C                   ExSr      SRCLTAMD

      ** Lending Module secured and facility ref not blank

     C     @CAMODS       WhenEq    'LE'
     C*****@CAFCUS       AndNe     0                                                          CSD027
     C     @CAFCUS       AndNe     *BLANKS                                                    CSD027
     C     @CAFTYP       AndNe     0
     C     @CAFSEQ       AndNe     0
     C                   ExSr      SRFCTAMD

      ** Lending Module secured and Loan/Limit not blank

     C     @CAMODS       WhenEq    'LE'
     C*****@CALNLM       AndNe     0                                                          CLE148
     C     @CALNLM       AndNe     *Blanks                                                    CLE148
     C                   ExSr      SRLONAMD

      ** Retail Module secured

     C     @CAMODS       WhenEq    'RE'
     C                   ExSr      SRACTAMD

     C                   EndSl
     C                   Return

      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0   Access Object                                      *
      *                                                               *
      *****************************************************************

     C     *InzSr        BegSr

      ** Entry Parameters

     C     *Entry        PList
     C                   Parm                    PRetCode          7
     C                   Parm                    ValidRec
     C                   Parm                    PColCur           3

      ** Program Name

     C                   Eval      DbPgm = 'GLCOLAUPD'

      ** Access Bank Details via Access Object AOBANKR0

     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY

     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8                          ************
     C                   MoveL     'SDBANKPD'    DbFile                         * DBERR 01 *
     C                   Z-Add     001           Dbase                          ************
     C                   MoveL     @Optn         DbKey
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

      ** Key lists

     C     WKeyColaL0    Klist
     C                   Kfld                    @CACREF
     C                   Kfld                    @CABRCA
     C                   Kfld                    @CACNUM
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CAFCUS
     C                   Kfld                    @CAFTYP
     C                   Kfld                    @CAFSEQ
     C                   Kfld                    @CALNLM
     C                   Kfld                    @CASBRC
     C                   Kfld                    @CASCNM
     C                   Kfld                    @CASCCY
     C                   Kfld                    @CASACD
     C                   Kfld                    @CASSEQ

     C     WKeyCllmL0    Klist
     C                   Kfld                    WCacNum           6
     C                   Kfld                    WLevel            1
     C                   Kfld                    WEntity           3

     C     WKeyColaL3    Klist
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CABRCA
     C                   Kfld                    @CACNUM

     C     WKeyColaL4    Klist
     C                   Kfld                    @CAFCUS
     C                   Kfld                    @CAFTYP
     C                   Kfld                    @CAFSEQ

     C     WKeyColaL5    Klist
     C                   Kfld                    @CALNLM

     C     WKeyColaL6    Klist
     C                   Kfld                    @CASBRC
     C                   Kfld                    @CASCNM
     C                   Kfld                    @CASCCY
     C                   Kfld                    @CASACD
     C                   Kfld                    @CASSEQ

     C     WKeyAccnt     Klist
     C                   Kfld                    @CASCNM
     C                   Kfld                    @CASCCY
     C                   Kfld                    @CASACD
     C                   Kfld                    @CASSEQ
     C                   Kfld                    @CASBRC

     C     WKeyCollL2    Klist
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CACNUM

     C     WKeyCollL3    Klist
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CAFCUS
     C                   Kfld                    @CAFTYP
     C                   Kfld                    @CAFSEQ

     C     WKeyCollL4    Klist
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CALNLM

     C     WKeyCollL5    Klist
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CASACN

     C     WKeyCollL6    Klist
     C                   Kfld                    @CAMODS
     C                   Kfld                    @CASCNM
     C                   Kfld                    @CASCCY
     C                   Kfld                    @CASACD
     C                   Kfld                    @CASSEQ
     C                   Kfld                    @CASBRC

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRINS: Insert processing                                   *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZAGENTMSTM- Generate a timestamp                              *
      *                                                               *
      *****************************************************************

     C     SRINS         BegSr

      ***Copy*records*from*ValidRec*to*RecToAmend                                             CAP084
      *******************                                                                     CAP084
     C*******************Eval      RecToAmend = ValidRec                                      CAP084
                                                                                              CAP084
      ** Generate Front Office Transaction ID for this                                        CAP084
      ** Collateral Allocation.                                                               CAP084
                                                                                              CAP084
     C     *DTAARA       DEFINE                  COALLO                                       CAP084
     C     *LOCK         IN        COALLO                                                     CAP084
     C     PCLAST        ADD       1             PCNEXT           15 0                        CAP084
     C                   MOVE      PCNEXT        WORK20           20                          CAP084
     C                   MOVEL     'MIDAS'       WORK20                                       CAP084
     C                   Z-ADD     PCNEXT        PCLAST                                       CAP084
     C                   OUT       COALLO                                                     CAP084
                                                                                              CAP084
     C                   Eval      CAFRNT = WORK20                                            CAP084

      ** Generate timestamp

     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PtimeStamp

     C                   Movel     PtimeStamp    CATMST

      ** Write record to GLCOLAPD

     C                   Write     GLCOLAD0                             30

      ** Error writing record

     C                   If        *IN30 = *On
     C                   Z-Add     002           Dbase                          ************
     C                   MoveL     'GLCOLAPD'    DbFile                         * DBERR 02 *
     C                   MoveL     ValidRec      DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRAMD: Amend processing                                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZAGENTMSTM- Generate a timestamp                              *
      *                                                               *
      *****************************************************************

     C     SRAMD         BegSr

      ** Copy records from ValidRec to RecToAmend

     C                   Eval      RecToAmend = ValidRec

     C     WKeyColaL0    Chain     GLCOLAL0                           31

      ** Record not found

     C                   If        *IN31 = *On
     C                   Z-Add     003           Dbase                          ************
     C                   MoveL     'GLCOLAL0'    DbFile                         * DBERR 03 *
     C                   MoveL     RecToAmend    DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   Else
     C                   Movel     CAAMT         WOldAmt          15 0
     C                   Eval      ValidRec = RecToAmend

      ** Generate timestamp

     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PtimeStamp

     C                   Movel     PtimeStamp    CATMST

      ** Update Record

     C                   Eval      *IN30 = *Off

     C                   Update    GLCOLAD0                             30

      ** Error updating record

     C                   If        *IN30 = *On
     C                   Z-Add     004           Dbase                          ************
     C                   MoveL     'GLCOLAL0'    DbFile                         * DBERR 04 *
     C                   MoveL     ValidRec      DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf
     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRDEL: Delete processing                                   *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZAGENTMSTM- Generate a timestamp                              *
      *                                                               *
      *****************************************************************

     C     SRDEL         BegSr

      ** Copy records from ValidRec to RecToAmend

     C                   Eval      RecToAmend = ValidRec

     C     WKeyColaL0    Chain     GLCOLAL0                           31

      ** Record not found

     C                   If        *IN31 = *On
     C                   Z-Add     005           Dbase                          ************
     C                   MoveL     'GLCOLAL0'    DbFile                         * DBERR 05 *
     C                   MoveL     RecToAmend    DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   Else

      ** Delete Record

     C                   Eval      *IN30 = *Off

     C                   Delete    GLCOLAD0                             30

      ** Error updating record

     C                   If        *IN30 = *On
     C                   Z-Add     006           Dbase                          ************
     C                   MoveL     'GLCOLAL0'    DbFile                         * DBERR 06 *
     C                   MoveL     ValidRec      DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf
     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRLMTAMD: Amend Limit File processing                      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLMTAMD      BegSr

     C                   Eval      WAmendReq = 'Y'

      ** Build key to SDCLLML0

     C                   Movel     @CACNUM       WCacNum

     C                   If        @CABRCA = *Blank
     C                   Eval      WLevel = 'S'
     C                   Eval      WEntity = 'SYS'
     C                   Else
     C                   Eval      WLevel = 'B'
     C                   Eval      WEntity = @CABRCA
     C                   EndIf

      ** Delete

     C                   If        @CACHTP = 'D'

      ** Check if there exist any specific collaterals assigned against
      ** the customer limit


     C     WKeyColaL3    Chain     GLCOLAL3                           32

     C     WKeyCollL2    Chain     GLCOLLL2                           33

      ** Not found

     C                   If        (*IN32 = *On) And (*IN33 = *On) Or
     C                             (*IN32 = *On) And (*IN33 = *Off) And
     C                             (CDRECI = 'R')
     C                   Eval      WAmendReq = 'Y'
     C                   Else
     C                   Eval      WAmendReq = 'N'
     C                   EndIf
     C                   EndIf

     C                   If        WAmendReq = 'Y'

      ** Retrieve Limit record

     C     WKeyCllmL0    Chain     SDCLLML0                           34

     C                   If        *IN34 = *Off

      ** Money Market module

     C                   If        (@CAMODS = 'MM') And (DZMMAM > 0)
     C                   If        (@CACHTP = 'A') Or (@CACHTP = 'I')
     C                   Eval      DZMSEC = 'Y'
     C                   Else
     C                   Eval      DZMSEC = *Blank
     C                   EndIf
     C                   Eval      *IN30 = *Off
     C                   Update    @DZREHS                              30
     C                   EndIf

      ** Foreign Exchange module

     C                   If        (@CAMODS = 'FX') And (DZFLAM > 0)
     C                   If        (@CACHTP = 'A') Or (@CACHTP = 'I')
     C                   Eval      DZFLSC = 'Y'
     C                   Else
     C                   Eval      DZFLSC = *Blanks
     C                   EndIf
     C                   Eval      *IN30 = *Off
     C                   Update    @DZREHS                              30
     C                   EndIf

      ** Error during update

     C                   If        *IN30 = *On
     C                   Z-Add     007           Dbase                          ************
     C                   MoveL     'SDCLLML0'    DbFile                         * DBERR 07 *
     C                   MoveL     @CACNUM       DbKey7            7            ************
     C                   Move      WLevel        DbKey7
     C                   MoveL     DbKey7        DbKey10          10
     C                   Move      WEntity       DbKey10
     C                   MoveL     DbKey10       DbKey
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   EndIf
     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRCLTAMD: Amend FO Limit File Processing                   *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOCURRR0    Access Object                                     *
      * ZXRATE   -  Obtain x-ccy exchange rate                        *
      * ZCONVZ1  -  Convert amount from one currency to another       *
      *                                                               *
      *****************************************************************

     C     SRCLTAMD      BegSr

      ** Get currency  from Future and option client's file

     C     @CACNUM       Chain     FOCLT                              35

      ** Record found, Get exchange rate, mult/div and dec. of currency
      ** received from parameter and the currency retrieved from FOCLT
      ** by accessing AOCURRR0

     C                   If        (*IN35 = *Off)
      *
     C                   MOVE      @CACNUM       WWCNUM            6
     C     WWCNUM        CHAIN     @BHRED0                            35
      *
     C                   If        (*IN35 = *ON)
     C                   MOVEL     WWCNUM        DBKEY
     C                   MOVEL     'SDFOCSPD  '  DBFILE
     C                   Z-ADD     014           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   If        (CLCC <> *Blank)
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      PColCur       WAjcd             3
     C     SdCurr        Parm      SdCurr        Dssdy

     C     @Rtcd         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     008           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 08 *
     C                   MoveL     PCOlCur       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

      ** Save ex-rate, mul/div and decimal places of the currency
      ** received in parameter

     C                   Z-Add     A6SPRT        WSprt1           13 8
     C                   Movel     A6MDIN        WMDIn1            1
     C                   Z-Add     A6NBDP        WNbDp1            1 0

     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      CLCC          WAjcd
     C     SdCurr        Parm      SdCurr        Dssdy

     C     @Rtcd         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     009           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 09 *
     C                   MoveL     CLCC          DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

      ** Save ex-rate, mul/div and decimal places of the currency
      ** retrieved from FOCLT

     C                   Z-Add     A6SPRT        WSprt2           13 8
     C                   Movel     A6MDIN        WMDIn2            1
     C                   Z-Add     A6NBDP        WNbDp2            1 0

      ** Get Cross-Exchange rate

     C                   CallB     'ZXRATE'
     C                   Parm                    WSprt1
     C                   Parm                    WMDIn1
     C                   Parm                    WSprt2
     C                   Parm                    WMDIn2
     C                   Parm                    WRate            13 8
     C                   Parm                    WMDIn             1

      ** Convert Old Amount to FO collateral currency, if action is A

     C                   If        @CACHTP = 'A'
     C                   CallB     'ZCONVZ1'
     C                   Parm                    WOldAmt
     C                   Parm                    WRate
     C                   Parm                    WMDIn
     C                   Parm                    PColCur
     C                   Parm                    CLCC
     C                   Parm                    WNbDp1
     C                   Parm                    WNbDp2
     C                   Parm                    WOutAmt          15 0

     C                   Z-Add     WOutAmt       WOldAmt
     C                   EndIf

      ** Convert collateral amount of collateral allocation to FO

     C                   CallB     'ZCONVZ1'
     C                   Parm                    CAAMT
     C                   Parm                    WRate
     C                   Parm                    WMDIn
     C                   Parm                    PColCur
     C                   Parm                    CLCC
     C                   Parm                    WNbDp1
     C                   Parm                    WNbDp2
     C                   Parm                    WOutAmt

     C                   Z-Add     WOutAmt       WNewAmt          15 0
     C                   Else
     C                   Z-Add     CAAMT         WNewAmt
     C                   Eval      CLCC =  PColCur
     C                   Eval      BHCYCD =  PColCur
     C                   EndIf

      ** Calculate amount if insert

     C                   If        @CACHTP = 'I'
     C                   Add       WNewAmt       CLAM
     C                   Add       WNewAmt       BHCOAM
     C                   EndIf

      ** Calculate amount if amend

     C                   If        @CACHTP = 'A'
     C                   Sub       WOldAmt       CLAM
     C                   Add       WNewAmt       CLAM
     C                   Sub       WOldAmt       BHCOAM
     C                   Add       WNewAmt       BHCOAM

      ** Amount less than 0, zeroise the amount

     C                   If        CLAM < 0
     C                   Z-Add     0             CLAM
     C                   Z-Add     0             BHCOAM
     C                   EndIf
     C                   EndIf

      ** Calculate amount if delete

     C                   If        @CACHTP = 'D'
     C                   Sub       WNewAmt       CLAM
     C                   Sub       WNewAmt       BHCOAM

      ** Amount less than 0, zeroise the amount

     C                   If        CLAM < 0
     C                   Z-Add     0             CLAM
     C                   Z-Add     0             BHCOAM
     C                   EndIf
     C                   EndIf

     C                   Eval      *IN30 = *Off
     C                   Update    FOCLTDF                              30

      ** Error during update

     C                   If        *IN30 = *On
     C                   Z-Add     010           Dbase                          ************
     C                   MoveL     'FOCLT   '    DbFile                         * DBERR 10 *
     C                   MoveL     @CACNUM       DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   Update    @BHRED0                              30

      ** Error during update

     C                   If        *IN30 = *On
     C                   Z-Add     015           Dbase
     C                   MoveL     'SDFOCSPD  '  DbFile
     C                   MoveL     @CACNUM       DbKey
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRFCTAMD: Amend Facility File Processing                   *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRFCTAMD      BegSr

     C                   Eval      WAmendReq = 'Y'

      ** Delete

     C                   If        @CACHTP = 'D'

      ** Check if there exist any specific collaterals assigned against
      ** the facility


     C     WKeyColaL4    Chain     GLCOLAL4                           35

     C     WKeyCollL3    Chain     GLCOLLL3                           36

      ** Not found

     C                   If        (*IN35 = *On) And (*IN36 = *On) Or
     C                             (*IN35 = *On) And (*IN36 = *Off) And
     C                             (CDRECI = 'R')
     C                   Eval      WAmendReq = 'Y'
     C                   Else
     C                   Eval      WAmendReq = 'N'
     C                   EndIf
     C                   EndIf

     C                   If        WAmendReq = 'Y'

      ** Retrieve Facility

     C     WKeyColaL4    Chain     FCLTY                              37

     C                   If        (*IN37 = *Off) And (RECI = 'D')

      ** Action code is A or I

     C                   If        (@CACHTP = 'A') Or (@CACHTP = 'I')
     C                   Eval      SECI = 'Y'
     C                   Else

      ** Delete

     C                   Eval      SECI = 'N'
     C                   EndIf
     C                   Eval      *IN30 = *Off
     C                   Update    FCLTYFMF                             30
     C                   EndIf

      ** Error during update

     C                   If        *IN30 = *On
     C                   Z-Add     011           Dbase                          ************
     C                   MoveL     'FCLTY   '    DbFile                         * DBERR 11 *
     C                   MoveL     @CACNUM       DbKey9            9            ************
     C                   Move      @CAFTYP       DbKey9
     C                   MoveL     DbKey9        DbKey11          11
     C                   Move      @CAFSEQ       DbKey11
     C                   MoveL     DbKey11       DbKey
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRLONAMD: Amend Loans File Processing                      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLONAMD      BegSr

     C                   Eval      WAmendReq = 'Y'

      ** Delete

     C                   If        @CACHTP = 'D'

      ** Check if there exist any specific collaterals assigned against
      ** the facility


     C     WKeyColaL5    Chain     GLCOLAL5                           38

     C     WKeyCollL4    Chain     GLCOLLL4                           39

      ** Not found

     C                   If        (*IN38 = *On) And (*IN39 = *On) Or
     C                             (*IN38 = *On) And (*IN39 = *Off) And
     C                             (CDRECI = 'R')
     C                   Eval      WAmendReq = 'Y'
     C                   Else
     C                   Eval      WAmendReq = 'N'
     C                   EndIf
     C                   EndIf

     C                   If        WAmendReq = 'Y'

      ** Retrieve Loan

     C     WKeyColaL5    Chain     CLOAN                              40

     C                   If        (*IN40 = *Off) And (RECI = 'D')

      ** Action code is A or I

     C                   If        (@CACHTP = 'A') Or (@CACHTP = 'I')
     C                   BITON     '0'           RELI
     C                   Else

      ** Delete

     C                   BITOFF    '0'           RELI
     C                   EndIf
     C                   Eval      *IN30 = *Off
     C                   Update    CLOANCLF                             30
     C                   EndIf

      ** Error during update

     C                   If        *IN30 = *On
     C                   Z-Add     012           Dbase                          ************
     C                   MoveL     'CLOAN   '    DbFile                         * DBERR 12 *
     C                   MoveL     @CALNLM       DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   EndIf

     C                   EndSr

      *****************************************************************
      *                                                               *
      * SR/SRACTAMD: Amend Account File Processing                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRACTAMD      BegSr

     C                   Eval      WAmendReq = 'Y'

      ** Delete

     C                   If        @CACHTP = 'D'

      ** Check if there exist any specific collaterals assigned against
      ** the facility


     C     WKeyColaL6    Chain     GLCOLAL6                           41

     C                   If        @CASACN = 0
     C     WKeyCollL6    Chain     GLCOLLL6                           42
     C                   Else
     C     WKeyCollL5    Chain     GLCOLLL5                           42
     C                   EndIf

      ** Not found

     C                   If        (*IN41 = *On) And (*IN42 = *On) Or
     C                             (*IN41 = *On) And (*IN42 = *Off) And
     C                             (CDRECI = 'R')
     C                   Eval      WAmendReq = 'Y'
     C                   Else
     C                   Eval      WAmendReq = 'N'
     C                   EndIf
     C                   EndIf

     C                   If        WAmendReq = 'Y'

      ** Retrieve Account

     C     WKeyAccnt     Chain     ACCNT                              43

     C                   If        (*IN43 = *Off) And (RECI = 'D') And
     C                             (ACST = *Blank) And (ATYP = 'R')

      ** Action code is A or I

     C                   If        (@CACHTP = 'A') Or (@CACHTP = 'I')
     C                   Eval      ODSC = 'Y'
     C                   Else

      ** Delete

     C                   Eval      ODSC = 'N'
     C                   EndIf
     C                   Eval      *IN30 = *Off
     C                   Update    ACCNTABF                             30
     C                   EndIf

      ** Error during update

     C                   If        *IN30 = *On
     C                   Z-Add     013           Dbase                          ************
     C                   MoveL     'ACCNT   '    DbFile                         * DBERR 13 *
     C                   MoveL     @CASBRC       DbKey9                         ************
     C                   Move      @CASCNM       DbKey9
     C                   MoveL     DbKey9        DbKey12          12
     C                   Move      @CASCCY       DbKey12
     C                   MoveL     DbKey12       DbKey16          16
     C                   Move      @CASACD       DbKey16
     C                   MoveL     DbKey16       DbKey18          18
     C                   Move      @CASSEQ       DbKey18
     C                   MoveL     DbKey18       DbKey
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf

     C                   EndIf

     C                   EndSr

      ****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
