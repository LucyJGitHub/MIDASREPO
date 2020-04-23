     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Generate additional entries for CLS sched')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0296 - Generate Additional Entries for CLS Schedule.       *
      *                                                               *
      *  Function:  This program is called by DLC0606C to generate    *
      *      one posting entry per pay-in schedule to the CLS pay/    *
      *      receive nostro.                                          *
      *                                                               *
      *  Called By: DLC0606C - Generate accounting entries            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055440           Date 18Mar20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE098             Date 02Dec13               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244585             Date 01Feb05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG5671            Date 01Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL020             Date 08Nov02               *
      *                 CRE009             Date 27Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187923             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186804             Date 23Nov00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055440 - CLS accounting entries are generated with a blank *
      *             blank posting narrative.	                      *
      *             Reinstate codes that was removed by CER030 changes*
      *             and also deliver the missing message ID's.        *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE098 - User-Defined Retail Transaction Types on Postings   *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  244585 - Apply fix 235769.                                   *
      *         - If account not retail, move BJRDNB to PSTD.         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5671- Add Sequence number to detail record (recompile)    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information                                         *
      *  CRE009 - Projected Account Movements for Retail Accounts     *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *           (Recompiled over FXCLSPSHL1)                        *
      *  186804 - Distinguish if program was called from              *
      *           input cycle termination or initiation               *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file                                     *
      *    02         No record found                                 *
      *    03         CHAIN/READE fail for FXCLSPSDL0                 *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRDBErr - Database error processing                           *
      * SRPayRec - Process payment / receipt posting                  *
      * SRWrite  - Write record to generated entries dealing file.    *
      * SRNostro - Retrieve nostro details                            *
      * SRPayIBP - Interbranch postings for Pay                       *
      * SRRcvIBP - Interbranch postings for Receive                   *
      * SRUpdTrl - Update generated entries dealing trailer file.     *
      * SRAudit  - Generate audit report.                             *
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
      ** CLS pay schedule header file
     FFXCLSPSHL1UF   E           K DISK    INFSR(*PSSR)
      *
      ** GL general entries dealing trailer
     FGEDLZZ    UF A E             DISK    INFSR(*PSSR)
      *
      ** GL general entries dealing detail
     FGEDLPD    O    E             DISK    INFSR(*PSSR)
      *
      ** CLS pay-in schedule detail file
     FFXCLSPSDL0IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D_)
      *
      ** Generate additional entries for CLS schedule - audit
     FDL0296AU  O    E             PRINTER

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for UDC multi-language narrative
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)
      *
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External DS for account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D  SATYP        E                     EXTFLD(ATYP)
     D  SSTYP        E                     EXTFLD(STYP)
     D  SACNO        E                     EXTFLD(ACNO)
     D  SPRFC        E                     EXTFLD(PRFC)
     D  SRRNM        E                     EXTFLD(RRNM)
     D  SLCD         E                     EXTFLD(LCD)
      *
      ** External DS for account code details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACCX       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for general ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACCY       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** External DS for modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACCZ       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** External DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CER030
      ** DS for Narrative Codes Accessed Via Access Program                                   CER030
     D SDNARR        E DS                  EXTNAME(SDNARRPD)                                  CER030
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  NoRecFnd              02     02
      *
      ** Hash totalling fields
     D                 DS
     D  WWAmt                  1     15  3
     D  WWAmtI                16     30  0
     D  WWAmtD                31     33  0
     D  WWTotD                34     36  0
     D  WWTotI                37     51  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work parameters
     D PPNOI           S              1A
     D PAcSn           S              2A
     D PNoNb           S              2A
     D PBrCd           S              3A
     D PBrch           S              3A
     D PCyCd           S              3A
     D***PAccn***         S              4A                                                   CGL029
     D PAccn           S             10A                                                      CGL029
     D PCust           S              6A
     D PSARD           S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D P#RTN           S              7A
     D P#MGID          S              7A
     D P#PRM1          S              9A
     D PCsSn           S             10A
     D PRetl           S             10A
     D P#NARR          S             50A
      *
      ** Work variable
     D WRun            S              1A
     D DLPNAR          S              1A   INZ('N')
     D WDumNostro      S              1A
     D WInterB         S              1A
     D WDrCr           S              1S 0
     D WDecimal        S              4P 0 INZ(*ZEROS)
     D WDecSum         S              4P 0 INZ(*ZEROS)
     D WGenRec         S              5S 0 INZ(*ZEROS)
     D WControlDat     S              5P 0
     D WAmt            S             15P 3
     D WInteger        S             15P 0 INZ(*ZEROS)
     D WPostingAmt     S             17P 0
     D WNostroD        S              2A
     D WNostroR        S              2A
     D WBranchD        S              3A
     D WBranchR        S              3A
     D WCtr            S              1S 0
     D WBICN           S              6A
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))

     ** Work fields and parameters used in CGL020                                             CGL020
     D CGL020          S              1A                                                      CGL020
     D*WWROCN***       S              6S 0                                             CGL020 CSD027
     D*WWROBN***       S              6S 0                                             CGL020 CSD027
     D*WWPOCN***       S              6S 0                                             CGL020 CSD027
     D*WWPOBN***       S              6S 0                                             CGL020 CSD027
     D WWROCN          S              6A                                                      CSD027
     D WWROBN          S              6A                                                      CSD027
     D WWPOCN          S              6A                                                      CSD027
     D WWPOBN          S              6A                                                      CSD027
     D WWBENN          S              8A                                                      CGL020
     D WWBENA          S             35A                                                      CGL020
     D WWAWBN          S              8A                                                      CGL020
     D WWAWBA          S             35A                                                      CGL020
     D W1RACT          S             20A                                                      CGL020
     D W1RCTY          S              2A                                                      CGL020
     D W1RBNK          S             20A                                                      CGL020
     D W1RCDE          S             11A                                                      CGL020
     D W1PACT          S             20A                                                      CGL020
     D W1PCTY          S              2A                                                      CGL020
     D W1PBNK          S             20A                                                      CGL020
     D W1PCDE          S             11A                                                      CGL020
     D W1DACT          S             35A                                                      CGL020
     D W1DCTY          S              2A                                                      CGL020
     D W1DBNK          S             20A                                                      CGL020
                                                                                              CGL020
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
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *                                                                                       CRE009
      ** Check CRE009 is ON.                                                                  CRE009
      *                                                                                       CRE009
     C                   MOVE      'Y'           CRE009            1                          CRE009
      *                                                                                       CRE009
     C                   CALL      'AOSARDR0'                                                 CRE009
     C                   PARM      *BLANKS       PRtCd                                        CRE009
     C                   PARM      '*VERIFY'     POptn                                        CRE009
     C                   PARM      'CRE009'      PSARD                                        CRE009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE009
      *                                                                                       CRE009
      ** Database error.                                                                      CRE009
      *                                                                                       CRE009
     C                   IF        PRtCd <> *BLANKS AND                                       CRE009
     C                             PRtCd <> '*NRF   '                                         CRE009
     C     *LOCK         IN        LDA                                                        CRE009
     C                   EVAL      DBKEY = PSARD                                              CRE009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE009
     C                   EVAL      DBASE = 004                                                CRE009
     C                   OUT       LDA                                                        CRE009
     C                   EXSR      SRDBErr                                                    CRE009
     C                   ELSE                                                                 CRE009
     C                   EVAL      CRE009 = 'Y'                                               CRE009
     C                   ENDIF                                                                CRE009
      *                                                                                       CRE009
      ** Check if 'CER030' is switched 'ON'                                                   CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      '       '     PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER030'      PSARD             6                          CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C     PRTCD         IFNE      *BLANKS                                                    CER030
     C     PRTCD         ANDNE     '*NRF   '                                                  CER030
      *                                                                                       CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     'CER030'      DBKEY                                        CER030
     C                   MOVEL     '106'         DBASE                                        CER030
     C                   OUT       LDA                                                        CER030
      *                                                                                       CER030
     C                   EXSR      SRDBErr                                                    CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS                                                    CER030
     C                   MOVE      'Y'           CER030            1                          CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   MOVE      'N'           CER030                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if 'CGL013' is switched 'ON'                                                   CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      '       '     PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CGL013'      PSARD             6                          CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C     PRTCD         IFNE      *BLANKS                                                    CER030
     C     PRTCD         ANDNE     '*NRF   '                                                  CER030
      *                                                                                       CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     'CGL013'      DBKEY                                        CER030
     C                   MOVEL     '107'         DBASE                                        CER030
     C                   OUT       LDA                                                        CER030
      *                                                                                       CER030
     C                   EXSR      SRDBErr                                                    CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS                                                    CER030
     C                   MOVE      'Y'           CGL013            1                          CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   MOVE      'N'           CGL013                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CRE098
      ** Check if 'CRE098' is switched 'ON'                                                   CRE098
      *                                                                                       CRE098
     C                   CALL      'AOSARDR0'                                                 CRE098
     C                   PARM      '       '     PRTCD                                        CRE098
     C                   PARM      '*VERIFY'     POPTN                                        CRE098
     C                   PARM      'CRE098'      PSARD             6                          CRE098
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE098
      *                                                                                       CRE098
     C     PRTCD         IFNE      *BLANKS                                                    CRE098
     C     PRTCD         ANDNE     '*NRF   '                                                  CRE098
      *                                                                                       CRE098
     C     *LOCK         IN        LDA                                                        CRE098
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE098
     C                   MOVEL     'CRE098'      DBKEY                                        CRE098
     C                   MOVEL     '108'         DBASE                                        CRE098
     C                   OUT       LDA                                                        CRE098
      *                                                                                       CRE098
     C                   EXSR      SRDBErr                                                    CRE098
     C                   ENDIF                                                                CRE098
      *                                                                                       CRE098
     C     PRTCD         IFEQ      *BLANKS                                                    CRE098
     C                   MOVE      'Y'           CRE098            1                          CRE098
     C                   ELSE                                                                 CRE098
      *                                                                                       CRE098
     C                   MOVE      'N'           CRE098                                       CRE098
     C                   ENDIF                                                                CRE098
      *
      ** Position pointer to the first record.
      *
     C     *LOVAL        SETLL     FXCLSPSHL1
      *
      ** Read pay schedule header record.
      *
     C                   READ      FXCLSPSHL1                             01
      *
      ** Repeat while valid record.
      *
     C                   DOW       EndOfFile = False

     C                   IF        PYVALD <= WControlDat AND PYRECI = 'D'
      *
      ** Access nostro detail to retrieve CLS pay/receive nostro.
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      PYCCY         PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM      PYNOST        PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   IF        PRtCd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      SRDBErr

     C                   ELSE
     C                   MOVE      PYNOST        WNostroD
     C                   MOVE      A7LPR         WNostroR
     C                   MOVE      A7BRCD        WBranchD
      *                                                                                       CGL020
      ** When CGL020 is installed                                                             CGL020
      *                                                                                       CGL020
     C                   IF        CGL020 = 'Y'                                               CGL020
      *                                                                                       CGL020
     C**********         EVAL      WWROCN = *Zeros                                     CGL020 CSD027
     C                   EVAL      WWROCN = *Blanks                                           CSD027
     C                   MOVE      A7CLSM        WWROBN                                       CGL020
     C**********         EVAL      WWPOCN = *Zeros                                     CGL020 CSD027
     C**********         EVAL      WWPOBN = *Zeros                                     CGL020 CSD027
     C                   EVAL      WWPOCN = *Blanks                                           CSD027
     C                   EVAL      WWPOBN = *Blanks                                           CSD027
     C                   MOVE      A7CLSM        WWBENN                                       CGL020
     C                   EVAL      WWBENA = *Blanks                                           CGL020
     C                   MOVE      A7CLSC        WWAWBN                                       CGL020
     C                   EVAL      WWAWBA = *Blanks                                           CGL020
      *                                                                                       CGL020
     C                   CALL      'ZAAMLSETDL'                                               CGL020
     C                   PARM                    WWROCN                                       CGL020
     C                   PARM                    WWROBN                                       CGL020
     C                   PARM                    WWPOCN                                       CGL020
     C                   PARM                    WWPOBN                                       CGL020
     C                   PARM                    WWBENN                                       CGL020
     C                   PARM                    WWBENA                                       CGL020
     C                   PARM                    WWAWBN                                       CGL020
     C                   PARM                    WWAWBA                                       CGL020
     C                   PARM                    W1RACT                                       CGL020
     C                   PARM                    W1RCTY                                       CGL020
     C                   PARM                    W1RBNK                                       CGL020
     C                   PARM                    W1RCDE                                       CGL020
     C                   PARM                    W1PACT                                       CGL020
     C                   PARM                    W1PCTY                                       CGL020
     C                   PARM                    W1PBNK                                       CGL020
     C                   PARM                    W1PCDE                                       CGL020
     C                   PARM                    W1DACT                                       CGL020
     C                   PARM                    W1DCTY                                       CGL020
     C                   PARM                    W1DBNK                                       CGL020
      *                                                                                       CGL020
     C                   ENDIF                                                                CGL020
      *
      ** CLS RECEIPT
      ** ===========
     C                   IF        PYTOTR <> *ZEROS
      *
      ** Credit CLS dummy nostro with total receive.
     C                   Z-ADD     PYTOTR        WPostingAmt
     C                   EVAL      WDrCr = 1
     C                   EVAL      WDumNostro = 'Y'
     C                   EVAL      WInterB = 'N'
     C                   EXSR      SRPayRec
      *
      ** Write record to generated entries dealing details.
     C                   EXSR      SRWrite
      *
      ** Debit CLS pay/receive nostro with total receive.
     C                   EVAL      WDrCr = 0
     C                   EVAL      WDumNostro = 'N'
     C                   EVAL      WInterB = 'N'
     C                   EXSR      SRNostro
     C                   MOVE      A7BRCD        WBranchR
     C                   EXSR      SRPayRec
      *
      ** Write record to generated entries dealing details.
     C                   EXSR      SRWrite

      ** Determine if interbranch posings required for Receive
     C                   EXSR      SRRcvIBP

     C                   ENDIF
      *
      ** CLS PAYMENT
      ** ===========
     C                   IF        PYTOTP <> *ZEROS

      ** Generate as many postings as there are detailed records (for each
      ** header record):

     C     KEY1          CHAIN     FXCLSPSDL0                         03

      ** Debit CLS Dummy Nostro with the Pay amount

     C     *IN03         DOWEQ     *OFF
     C                   Z-ADD     D_PYAMT       WPostingAmt
     C                   EVAL      WDrCr = 0
     C                   EVAL      WDumNostro = 'Y'
     C                   EVAL      WInterB = 'N'
     C                   EXSR      SRNostro
     C                   MOVE      A7BRCD        WBranchD
     C                   EXSR      SRPayRec
      *
      ** Write record to generated entries dealing details.
     C                   EXSR      SRWrite
      *
      ** Credit CLS pay/receive nostro with the Pay amount
     C                   EVAL      WDrCr = 1
     C                   EVAL      WDumNostro = 'N'
     C                   EVAL      WInterB = 'N'
     C                   EXSR      SRNostro
     C                   MOVE      A7BRCD        WBranchR
     C                   EXSR      SRPayRec
      *
      ** Write record to generated entries dealing details.
     C                   EXSR      SRWrite

      ** Determine if interbranch posings required for Pay
     C                   EXSR      SRPayIBP

      ** Read next detail record for the same CLS schedule
     C     KEY1          READE     FXCLSPSDL0                             03

     C                   ENDDO

     C                   ENDIF
      *
      ** Set "Amount posted" flag to 'Y' and update record.
      ** only if program was called from IC termination DLC0606C.                             186804
      ** Dont update if called from IC initiation DLC10.                                      186804
      *                                                                                       186804
     C                   IF        P_UpdPost = 'Y'                                            186804
     C                   EVAL      PYPOST = 'Y'

     C                   UPDATE    FXCLPHD0
     C                   ENDIF                                                                186804

     C                   ENDIF
     C                   ENDIF
      *
      ** Read next pay schedule header record.
     C                   READ      FXCLSPSHL1                             01

     C                   ENDDO
      *
      ** Update generated entries trailer file.
      *
     C                   EXSR      SRUpdTrl
      *
      ** Write audit report
      *
     C                   EXSR      SRAudit
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPayRec - Process payment / receipt posting                 *
      *                                                               *
      *****************************************************************
     C     SRPayRec      BEGSR
      *
      ** Customer number
     C                   MOVE      A7CUST        CNUM
     C                   IF        WInterB = 'Y'
     C                   MOVE      WBICN         CNUM
     C                   ENDIF
      *
      ** Currency code
     C                   EVAL      CCY = PYCCY
      *
      ** Account code
     C                   MOVE      A7ACCD        ACOD
     C                   IF        WInterB = 'Y'
     C                   IF        WDrCr = 0
     C                   MOVE      A8DFAC        ACOD
     C                   ENDIF
     C                   IF        WDrCr = 1
     C                   MOVE      A8DTAC        ACOD
     C                   ENDIF
     C                   ENDIF
      *
      ** Account sequence number
     C                   EVAL      ACSQ = A7ACSN
      *
      ** Input document number
     C                   EVAL      IPDN = *BLANKS
      *
      ** Branch code
     C                   EVAL      BRCA = A7BRCD
     C                   IF        WInterB = 'Y'
     C                   EVAL      BRCA = A8BRCD
     C                   ENDIF
      *
      ** Retail account number
     C                   IF        WInterB = 'Y'
     C                   EVAL      ACNO = *ZEROS

     C                   ELSE
     C                   MOVE      *BLANKS       PAcSn
     C                   MOVE      A7ACSN        PAcSn
     C                   MOVE      CNUM          PCust
     C                   MOVE      BRCA          PBrCd
     C                   MOVE      ACOD          PAccn

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PRetl
     C                   PARM                    PCust
     C                   PARM      A7CYCD        PCyCd
     C                   PARM                    PAccn
     C                   PARM                    PAcSn
     C                   PARM                    PBrCd
     C     SDACCT        PARM      SDACCT        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PBrCd + PCust + PCyCd + PAccn + PAcSn
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE = 008
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   EVAL      ACNO = SACNO
     C                   ENDIF

     C                   ENDIF
      *
      ** If CRE009 is ON, pgm called by DLC10 & Account is Retail               CRE009
      ** & Deal not back valued                                                 CRE009
      ** Set Posting Date to Value Date                                         CRE009
      *                                                                         CRE009
     C                   IF        CRE009 = 'Y' AND P_UpdPost = 'N'             CRE009
     C                             AND SATYP = 'R'                              CRE009
     C                   EVAL      PSTD = PYVALD                                CRE009
     C                   IF        PYVALD < BJRDNB                              CRE009
      ** Posting date
     C                   EVAL      PSTD = BJRDNB
     C                   ENDIF                                                  CRE009
      *                                                                                       244585
     C                   ELSE                                                                 244585
     C                   EVAL      PSTD = BJRDNB                                              244585
     C                   ENDIF                                                  CRE009
      *
      ** Value date
     C                   EVAL      VALD = PYVALD
      *
      ** Transaction type
     C                   IF        SATYP = 'R' AND WInterB = 'N'
     C                   MOVE      '92000'       TRAT
     C                   ELSE
     C                   MOVE      *ZEROS        TRAT
     C                   ENDIF
      *                                                                                       CER030
      ** CLS total amount pay is not zero.                                                    CER030
      *                                                                                       CER030
     C                   IF        PYTOTP <> *ZEROS                                           CER030
     C                   EVAL      P#MGID = 'GB52000'                                         CER030
     C                   EVAL      MNNARR = 'CLS PAYMENT'                                     CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CLS total amount receive is not zero.                                                CER030
      *                                                                                       CER030
     C                   IF        PYTOTR <> *ZEROS                                           CER030
     C                   EVAL      P#MGID = 'GB53000'                                         CER030
     C                   EVAL      MNNARR = 'CLS RECEIPT'                                     CER030
     C                   ENDIF                                                                CER030
      *
     C     CGL013        IFEQ      'Y'                                                        CER030
     C     CER030        OREQ      'Y'                                                        CER030
     C     CRE098        OREQ      'Y'                                                        CRE098
      *                                                                                       CER030
     C     TRAT          IFEQ      92000                                                      CER030
     C                   EVAL      PNARC = %SUBST(P#MGID:3:2)                                 CER030
     C     PNARC         IFNE      *BLANKS                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AONARRR0'                                                 CER030
     C                   PARM      '       '     PRTCD             7                          CER030
     C                   PARM      '*KEY   '     POPTN             7                          CER030
     C                   PARM                    PNARC             2                          CER030
     C     SDNARR        PARM      SDNARR        DSFDY                                        CER030
      *                                                                                       CER030
     C     PRTCD         IFNE      *BLANKS                                                    CER030
      *                                                                                       CER030
     C                   MOVE      'SDNARRPD'    DBFILE                                       CER030
     C                   MOVE      POPTN         DBOPTN            7                          CER030
     C                   MOVE      PNARC         DBKEY                                        CER030
     C                   MOVE      '012'         DBASE                                        CER030
     C                   SETON                                        U7U8LR                  CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS                                                    CER030
     C     ALRTTY        ANDNE     *BLANKS                                                    CER030
     C                   MOVE      ALRTTY        TRAT                                         CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      ** Posting narrative
      *
      ** If the facility is switched off or UDC is not installed,
      ** default posting narrative.
      *
     C                   EVAL      PNAR = *BLANKS
     C                   IF        DLPNAR = 'Y'
      *
      ** Determine the value for the narrative using AOPNARR0:
     C                   CLEAR                   CGPNAR

     C                   MOVE      'DL'          MNMODI
     C                   MOVE      A7CYCD        MNCYCD
     C                   MOVE      ACOD          MNACCD
     C                   MOVE      A7ACSN        MNACSQ
     C                   MOVE      CNUM          MNCUST
     C                   MOVE      ACNO          MNRACN
      *
      ***CLS*total*amount*pay*is*not*zero.                                                    CER030
     C**********         IF        PYTOTP <> *ZEROS                                           CER030
     C**********         EVAL      P#MGID = 'GB52000'                                         CER030
     C**********         EVAL      MNNARR = 'CLS PAYMENT'                                     CER030
     C**********         ENDIF                                                                CER030
      *
      ***CLS*total*amount*receive*is*not*zero.                                                CER030
     C**********         IF        PYTOTR <> *ZEROS                                           CER030
     C**********         EVAL      P#MGID = 'GB53000'                                         CER030
     C**********         EVAL      MNNARR = 'CLS RECEIPT'                                     CER030
     C**********         ENDIF                                                                CER030
      *                                                                                     MD055440
      ** CLS total amount pay is not zero.                                                  MD055440
     C                   IF        PYTOTP <> *ZEROS                                         MD055440
     C                   EVAL      P#MGID = 'GB52000'                                       MD055440
     C                   EVAL      MNNARR = 'CLS PAYMENT'                                   MD055440
     C                   ENDIF                                                              MD055440
      *                                                                                     MD055440
      ** CLS total amount receive is not zero.                                              MD055440
     C                   IF        PYTOTR <> *ZEROS                                         MD055440
     C                   EVAL      P#MGID = 'GB53000'                                       MD055440
     C                   EVAL      MNNARR = 'CLS RECEIPT'                                   MD055440
     C                   ENDIF                                                              MD055440

     C                   CALL      'AOPNARR0'
     C                   PARM                    P#RTN
     C                   PARM                    P#MGID
     C                   PARM      *BLANKS       P#PRM1
     C     CGPNAR        PARM      CGPNAR        DSSDY
     C                   PARM                    P#NARR

     C                   IF        P#RTN <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = MNCUST
     C                   EVAL      DBFILE = 'CGPNARPD'
     C                   EVAL      DBASE = 009
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF

     C                   MOVEL(P)  P#NARR        PNAR

     C                   ELSE
      *
      ** CLS total amount pay is not zero.
     C                   IF        PYTOTP <> *ZEROS
     C                   EVAL      PNAR = 'CLS PAYMENT'
     C                   ENDIF
      ** CLS total amount receive is not zero.
     C                   IF        PYTOTR <> *ZEROS
     C                   EVAL      PNAR = 'CLS RECEIPT'
     C                   ENDIF

     C                   ENDIF
      *
      ** Posting amount
     C                   Z-ADD     WPostingAmt   PSTA
      *
      ** Debit/Credit indicator
     C                   EVAL      DRCR = WDrCr
      *
      ** Associated customer
     C**********         EVAL      ASOC = *ZEROS                                              CSD027
     C                   EVAL      ASOC = *BLANKS                                             CSD027
      *
      ** Cheque number
     C                   EVAL      CHQN = *ZEROS
      *
      ** Source of posting
     C                   EVAL      SPOS = '  GE-DL'
      *
      ** Retail indicator
     C                   IF        SATYP = 'R' AND WInterB = 'N'
     C                   EVAL      RIND = 1
     C                   ELSE
     C                   EVAL      RIND = 0
     C                   ENDIF
      *
      ** Reject code
     C                   EVAL      REJC = *ZEROS
      *
      ** Department code
     C                   EVAL      DPMT = *BLANKS
      *
      ** Relative record number on MEMOS
     C                   IF        WInterB = 'Y'
     C                   Z-ADD     *ZEROS        RRNM
     C                   ELSE
     C                   Z-ADD     SRRNM         RRNM
     C                   ENDIF
      *
      ** Account type
     C                   IF        WInterB = 'Y'
     C                   EVAL      ATYP = 'G'
     C                   ELSE
     C                   EVAL      ATYP = SATYP
     C                   ENDIF
      *
      ** Extract indicator for rc
     C                   EVAL      EXIN = *BLANK
      *
      ** Pay / receive indicator
     C                   BITOFF    '01234567'    PRIN
      *
      ** Generated entry type
     C                   EVAL      GETP = 'D'
      *
      ** Accumulator indicator
     C                   EVAL      ACUM = *ZERO
      *
      ** Profit centre
     C                   IF        WDumNostro = 'Y' AND WInterB = 'N'
     C                   IF        BGN0ST = 'Y'
     C                   EVAL      PRFC = SPRFC
     C                   ELSE
     C                   EVAL      PRFC = PYPRFC
     C                   ENDIF
     C                   ENDIF

     C                   IF        WDumNostro <> 'Y' OR WInterB = 'Y'
     C                   EVAL      PRFC = PYPRFC
     C                   ENDIF
      *
      ** Posting time
     C                   TIME                    PTIM
      *
      ** Void indicator
     C                   EVAL      VOIN = *ZERO
      *
      ** Message generation transaction
     C                   EVAL      MGTT = *BLANKS
      *
      ** Account section
      *
      ** Read account code details to retrieve account section.
     C                   MOVE      ACOD          PAccn
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAccn
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PAccn
     C                   EVAL      DBFILE = 'SDACODPD'
     C                   EVAL      DBASE = 010
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   EVAL      ACSC = A5ACSC
     C                   ENDIF
      *
      ** Late accrual indicator
     C                   EVAL      LTAI = *ZERO
      *
      ** Retail input number
     C                   EVAL      RINO = *BLANKS
      *
      ** Swift common reference
     C                   EVAL      SWCR = *BLANKS
      *
      ** Deal/loan reference
     C                   EVAL      DLREF = *BLANKS
      *
      ** For account of
     C                   EVAL      FACO = *BLANKS
      *
      ** Dealt/borrower customer no.
     C**********         EVAL      DBCNUM = *ZEROS                                            CSD027
     C                   EVAL      DBCNUM = *BLANKS                                           CSD027
      *
      ** Payment reference
     C                   EVAL      PREF = *BLANKS
      *
      ** Origional transaction reference
     C                   EVAL      OTRF = *BLANKS
      *
      ** Origional transaction sub-type
     C                   EVAL      OTST = *BLANKS
      *
      ** Origional transaction type
     C                   EVAL      OTTP = *BLANKS
      *
      ** Start of day cleared balance
     C                   EVAL      SDCB = *ZEROS
      *
      ** Start of day ledger balance
     C                   EVAL      SDLB = *ZEROS
      *
      ** Book code
     C                   EVAL      BOKC = *BLANKS
      *
      ** Number of items
     C                   EVAL      NITMS = 1
      *
      ** Rebatable indicator
     C                   EVAL      REBI = *BLANK
      *
      ** Charge amount
     C                   EVAL      CHGA = *ZEROS
      *
      ** Teller input indicator
     C                   EVAL      TLIN = *BLANK
      *
      ** Transaction currency
     C                   EVAL      TRCCY = *BLANKS
      *
      ** Account subtype
     C                   IF        WInterB = 'Y'
     C                   EVAL      STYP = *BLANK
     C                   ELSE
     C                   EVAL      STYP = SSTYP
     C                   ENDIF
      *
      ** Cheque indicator/reversal indicator
     C                   EVAL      CQRI = *BLANK
      *
      ** Passbook transaction type
     C                   EVAL      PBTT = *BLANKS
      *
      ** Originating branch
     C                   EVAL      ORBR = BRCA
      *
      ** Original Amt - Giro
     C                   EVAL      ORAMT = *ZEROS
      *
      ** Extension file reference id
     C                   EVAL      XRFI = *BLANKS
      *
      ** Extension file reference no.
     C                   EVAL      XRFN = *ZEROS
      *
      ** Trans sub-type
     C                   EVAL      TRST = *BLANKS
      *
      ** Record id
     C                   EVAL      RECI = 'P'

      ** When CGL020 is installed                                                             CGL020
                                                                                              CGL020
     C                   IF        CGL020 = 'Y'                                               CGL020
                                                                                              CGL020
     C                   IF        WDumNostro = 'N' AND WInterB = 'N'                         CGL020
     C                   EVAL      RORACT = W1RACT                                            CGL020
     C                   EVAL      RORCTY = W1RCTY                                            CGL020
     C                   EVAL      RORBNK = W1RBNK                                            CGL020
     C                   EVAL      RORCDE = W1RCDE                                            CGL020
     C                   EVAL      PORACT = W1PACT                                            CGL020
     C                   EVAL      PORCTY = W1PCTY                                            CGL020
     C                   EVAL      PORBNK = W1PBNK                                            CGL020
     C                   EVAL      PORCDE = W1PCDE                                            CGL020
     C                   EVAL      DSTACT = W1DACT                                            CGL020
     C                   EVAL      DSTCTY = W1DCTY                                            CGL020
     C                   EVAL      DSTBNK = W1DBNK                                            CGL020
     C                   EVAL      SETDAT = PYVALD                                            CGL020
     C                   ELSE                                                                 CGL020
     C                   EVAL      RORACT = *Blanks                                           CGL020
     C                   EVAL      RORCTY = *Blanks                                           CGL020
     C                   EVAL      RORBNK = *Blanks                                           CGL020
     C                   EVAL      RORCDE = *Blanks                                           CGL020
     C                   EVAL      PORACT = *Blanks                                           CGL020
     C                   EVAL      PORCTY = *Blanks                                           CGL020
     C                   EVAL      PORBNK = *Blanks                                           CGL020
     C                   EVAL      PORCDE = *Blanks                                           CGL020
     C                   EVAL      DSTACT = *Blanks                                           CGL020
     C                   EVAL      DSTCTY = *Blanks                                           CGL020
     C                   EVAL      DSTBNK = *Blanks                                           CGL020
     C                   EVAL      SETDAT = *Zeros                                            CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   EVAL      ACKEY = *Blanks                                            CGL020
     C                   EVAL      FEEFLG = *Blanks                                           CGL020
     C                   EVAL      FEEVAL = *Zeros                                            CGL020
     C                   EVAL      FEEPCT = *Zeros                                            CGL020
     C                   EVAL      TICKER = *Blanks                                           CGL020
     C                   EVAL      EXCHNG = *Blanks                                           CGL020
     C                   EVAL      NOMINL = *Zeros                                            CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record to generated entries dealing file.    *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
      ** Keep running total of records generated for trailer.
      *
     C                   EVAL      WGenRec = WGenRec + 1
      *
      ** Hash total
      *
     C                   EVAL      WAmt = 0
     C                   EVAL      WAmt = PSTA / 1000
     C                   EVAL      WWAmt = WAmt

     C                   Z-ADD     WInteger      WWTotI
     C                   Z-ADD     WDecimal      WWTotD

     C                   IF        WWAmt < 0
     C                   Z-SUB     WWAmt         WWAmt
     C                   ENDIF

     C                   Z-ADD     WWAmt         WWAmtI
     C                   MOVE      WWAmt         WWAmtD
     C                   ADD       WWAmtD        WWTotD

     C                   IF        WWTotD < WWAmtD
     C                   ADD       1             WWTotI
     C                   ENDIF

     C                   ADD       WWAmtI        WWTotI
     C                   Z-ADD     WWTotI        WInteger
     C                   Z-ADD     WWTotD        WDecimal
      *
      ** Write record to generated entries dealing detail file.
      *
     C                   WRITE     APOSTPDF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcvIBP - Inberbranch postings for Receive                  *
      *                                                               *
      *****************************************************************
     C     SRRcvIBP      BEGSR

     C                   IF        WBranchD <> WBranchR
     C                   EVAL      WInterB = 'Y'

      ** DEBIT BICN (Real Nostro)/Ccy/'Due From' account (Dummy Nostro)

     C                   EVAL      WDrCr = 0
     C                   EVAL      WDumNostro = 'Y'
     C                   EXSR      SRNostro
     C                   EVAL      PBrch = WBranchR
     C                   EXSR      SRBranch
     C                   EVAL      WBICN = A8BICN
     C                   EVAL      PBrch = WBranchD
     C                   EXSR      SRBranch

     C                   EXSR      SRPayRec
     C                   EXSR      SRWrite

      ** CREDIT BICN (Dummy Nostro)/Ccy/'Due To' account (Real Nostro)

     C                   EVAL      WDrCr = 1
     C                   EVAL      WDumNostro = 'N'
     C                   EXSR      SRNostro
     C                   EVAL      PBrch = WBranchD
     C                   EXSR      SRBranch
     C                   EVAL      WBICN = A8BICN
     C                   EVAL      PBrch = WBranchR
     C                   EXSR      SRBranch

     C                   EXSR      SRPayRec
     C                   EXSR      SRWrite

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPayIBP - Inberbranch postings for Pay                      *
      *                                                               *
      *****************************************************************
     C     SRPayIBP      BEGSR

     C                   IF        WBranchD <> WBranchR
     C                   EVAL      WInterB = 'Y'

      ** CREDIT BICN (Real Nostro)/Ccy/'Due To' account (Dummy Nostro)

     C                   EVAL      WDrCr = 1
     C                   EVAL      WDumNostro = 'Y'
     C                   EXSR      SRNostro
     C                   EVAL      PBrch = WBranchR
     C                   EXSR      SRBranch
     C                   EVAL      WBICN = A8BICN
     C                   EVAL      PBrch = WBranchD
     C                   EXSR      SRBranch

     C                   EXSR      SRPayRec
     C                   EXSR      SRWrite

      ** DEBIT BICN (Dummy Nostro)/Ccy/'Due From' account (Real Nostro)

     C                   EVAL      WDrCr = 0
     C                   EVAL      WDumNostro = 'N'
     C                   EXSR      SRNostro
     C                   EVAL      PBrch = WBranchD
     C                   EXSR      SRBranch
     C                   EVAL      WBICN = A8BICN
     C                   EVAL      PBrch = WBranchR
     C                   EXSR      SRBranch

     C                   EXSR      SRPayRec
     C                   EXSR      SRWrite

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNostro - Retrieve nostro details                           *
      *                                                               *
      *****************************************************************
     C     SRNostro      BEGSR

      ** Determine if Real or Dummy nostro details are to be retrieved

     C                   IF        WDumNostro = 'Y'
     C                   MOVE      WNostroD      PNoNb
     C                   ELSE
     C                   MOVE      WNostroR      PNoNb
     C                   ENDIF

      ** Access nostro details

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      PYCCY         PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM                    PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 007
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranch - Access branch details                             *
      *                                                               *
      *****************************************************************
     C     SRBranch      BEGSR

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PBrch
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTrl - Update generated entries dealing trailer file.    *
      *                                                               *
      *****************************************************************
     C     SRUpdTrl      BEGSR
      *
      ** Update trailer record if found, otherwise write record.
     C     1             CHAIN     GEDLZZ                             02

     C                   IF        NoRecFnd = False
     C                   EVAL      NORE1 = NORE1 + WGenRec
     C                   EVAL      HRWN  = HRWN  + WInteger
     C                   EVAL      WDecSum = HRDC + WDecimal
      *
      ** If decimal exceeds 1000, carry 1 to integer. Amount in
      ** excess of 1000 is moved back on decimal.
     C                   IF        WDecSum > 1000
     C                   EVAL      HRDC = WDecSum - 1000
     C                   EVAL      HRWN = HRWN + 1
     C                   ELSE
     C                   Z-ADD     WDecSum       HRDC
     C                   ENDIF
     C                   UPDATE    APOSTZZF
     C                   ELSE
     C                   EVAL      RECI = 'T'
     C                   Z-ADD     WGenRec       NORE1
     C                   ADD       2             NORE1
     C                   Z-ADD     WInteger      HRWN
     C                   Z-ADD     WDecimal      HRDC
     C                   WRITE     APOSTZZF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Generate audit report processing.                  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

     C                   IF        WGenRec <> 0
     C                   Z-ADD     WGenRec       RCOUNT
     C                   Z-ADD     WInteger      RINTEGER
     C                   Z-ADD     WDecimal      RDECIMAL
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
     C                   ENDIF

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

     C     *ENTRY        PLIST                                                                186804
     C                   PARM                    P_UpdPost         1                          186804

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access general ledger ICD details.
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** If UDC present
      *
     C                   IF        BGN1ST = 'Y'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'DLPNAR'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSARD
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   EVAL      DLPNAR = 'Y'
     C                   ENDIF
     C                   ENDIF
                                                                                              CGL020
      ** Determine if Midas Compliance Watch - Additional A/C Postings                        CGL020
      ** Information is installed                                                             CGL020
                                                                                              CGL020
     C                   EVAL      CGL020 = 'N'                                               CGL020
     C                   CALL      'AOSARDR0'                                                 CGL020
     C                   PARM      *Blanks       PRtcd                                        CGL020
     C                   PARM      '*VERIFY'     POptn                                        CGL020
     C                   PARM      'CGL020'      PSard                                        CGL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL020
                                                                                              CGL020
      ** Database error                                                                       CGL020
                                                                                              CGL020
     C                   IF        PRtcd <> *Blanks AND                                       CGL020
     C                             PRtcd <> '*NRF   '                                         CGL020
     C     *LOCK         IN        LDA                                                        CGL020
     C                   EVAL      DBKEY = PSard                                              CGL020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL020
     C                   EVAL      DBASE = 011                                                CGL020
     C                   OUT       LDA                                                        CGL020
     C                   EXSR      SRDBErr                                                    CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   IF        PRtcd = *Blanks                                            CGL020
     C                   EVAL      CGL020 = 'Y'                                               CGL020
     C                   ENDIF                                                                CGL020
      *
      ** Setup control date
      *
     C                   EVAL      WControlDat = BJDNWD - 1
     C                   IF        BKANWD = '2'
     C                   IF        BKAPDT <= WControlDat
     C                   Z-ADD     BKAPDT        WControlDat
     C                   ELSE
     C                   Z-ADD     BJRDNB        WControlDat
     C                   ENDIF
     C                   ENDIF

      ** Key lists

     C     KEY1          KLIST
     C                   KFLD                    PYCCY
     C                   KFLD                    PYNOST
     C                   KFLD                    PYVALD
     C                   KFLD                    PYSEQN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDBErr - Database error processing                          *
      *                                                               *
      *****************************************************************
     C     SRDBErr       BEGSR

     C                   WRITE     HEADAU
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   WRITE     DBERROR

     C                   EXSR      *PSSR

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
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
