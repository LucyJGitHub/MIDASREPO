     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input Repair')                            *
      *****************************************************************
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMRPR - LE Fee Input Repair                              *
      *                                                               *
      *  Function:  This is the screens input repair function for     *
      *             Fee                                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD053607           Date 19Jul19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 30Mar07               *
      *                 245099             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG3760            Date 30Jul04               *
      *                 BUG2571            Date 13May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053607 - Matured Fee did not appear on fees screen.        *
      *           - Recompile due to changes in LEFHSTL1.             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244636 - If no settlement details for a fees are entered     *
      *           then default settlement details from related loan   *
      *  245099 - Pass CLE006 to LEFEEMAMD                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  BUG2571 - (CSC022) Commitment Control Changes for MidasPlus. *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
     FLEIFEEML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIFEEMD0 : LEIFEEMX0)
     FLEIFEEML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF1)
     FLEFHSTL1  IF   E           K DISK
      *
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ***  Hook to enable non-core files to be included
      *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      *  Array for job name                                                                  BUG2571
     D ARRJBNAM        S             10A   DIM(10)                                           BUG2571
     D @EI             S              1    DIM(60)
      *
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
      ***  Current Fee in File Format
     D***FeRec**              294    362                                                      CGL029
     D***FePay**              363    921                                                      CGL029
     D  FeRec                308    362                                                       CGL029
     D  FePay                377    921                                                       CGL029
     D  FeRecEx             1076   1093                                                       CGL029
     D  FePayEx             1094   1111                                                       CGL029
      *
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(@)
      ***  (Current) Fee in Screen Format
      *
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
     D QQOURS1       E                     EXTFLD(QQOURS)                                     CGL029
      ***  New Fee in File Format
     D***VFRec**              294    362                                                      CGL029
     D***VFPay**              363    921                                                      CGL029
     D  VFRec                308    362                                                       CGL029
     D  VFPay                377    921                                                       CGL029
     D  VFRecEx             1076   1093                                                       CGL029
     D  VFPayEx             1094   1111                                                       CGL029
      *
     D NwFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
      ***  New Fee in Screen Format
 
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
      ***  Customer Loans record CL in file Format
 
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
      *
     D F_REC         E DS                  EXTNAME(SDESFRPD)
      * File Receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
      * File Payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
      * File Fra/irs instructions
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current
 
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current
 
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current
 
 
     D S_REC         E DS                  EXTNAME(SDESSRPD)
      * Screen Receive instructions
 
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      * Screen Payment instructions
 
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
      * Screen Fra/irs instructions
 
      *
     D OKFee         E DS                  EXTNAME(LEEFEEMPD)
      ***  Error indicators Screen
      *                                                                                      BUG2571
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2571
      ** Midas SC Jobs handling commitment control data area                                 BUG2571
     D  COMITNOM               1      3S 0                                                   BUG2571
     D  COMITJOB               4    103                                                      BUG2571
      *                                                                                      BUG2571
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** External DS for Lending ICD Details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
     D ExtData       E DS                  EXTNAME(LEFEEXPD)
      ***  LE (FEEM) Extra Data - File (D/B) format
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D                 DS
     D  @SIFEER                1     19
     D  @SICSSN                1      6
     D  @SIFACT                7      9
     D  @SIFCNO               10     11
     D  @SILNRF               12     17
     D  @SIFSEQ               18     19
      *
      ** +--------------------------------------+                                            BUG2571
      ** ¦ Use of Indicator                     ¦                                            BUG2571
      ** ¦ ================                     ¦                                            BUG2571
      ** |                                      |                                            BUG2571
      ** | 17      Used by LOOKUP               |                                            BUG2571
      ** +--------------------------------------+                                            BUG2571
                                                                                             BUG2571
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D                 DS
      ** Data structure to set partial key
     D**WCNUM***               1      6  0                                                    CSD027
     D  WCNUM                  1      6A                                                      CSD027
     D  WFAC03                 7      9  0
     D  WFAC02                10     11  0
     D  WFACL                  7     11
     D  WFAC05                 7     11  0
     D**WLOAN***              12     17  0                                                    CLE148
     D  WLOAN                 12     17                                                       CLE148
     D  WFSEQ                 18     19  0
     D**WFPKEY**               1     19  0                                                    CSD027
     D  WFPKEY                 1     19A                                                      CSD027
 
     D CSC022          S              1A   INZ('N')                                          BUG2571
      ** Counter variable                                                                    BUG2571
     D WCMT01          S              1A                                                     BUG2571
      ** Commitment Flag                                                                     BUG2571
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S             26Z
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ***  -------------------------------------------------------------------
      ***  Fields for getting the starting field number from file (parameters
      ***  to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('LEFEEMPD')
      *
     D Field           S             10A   INZ('DDACTN')
      *
     D FieldNo         S              5P 0
      *
     D FldOffset       S              5P 0
      *
      ***  End of fields for getting starting field number
      ***  -------------------------------------------------------------------
                                                                                              244636
      ** Parameter for LEFEEMRTV                                                              244636
     D PRcvParm        S             92                                                       244636
                                                                                              244636
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WTRCcy          S              3A                                                     CSF011A
     D WTPCcy          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
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
      *
      ***  Do screen: Browse invalid Fee
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      *
      ***  Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      ***  Do while screen: Main details
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      *
      ***  Screen: Confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      ***  Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      ***  Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Fee
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LEFEEMRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Build subfile
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      *Blanks       @RDSFL            1
      *
      ***  Error in update of previous Fee
     C                   PARM                    @ERRUP            1
      *
      ***  Branch code
     C                   PARM                    @BRCA             3
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    @ERRMS            7
      *
      ***  Option selected
     C                   PARM                    @OPSEL            1
      *
      ***  Action selected
     C                   PARM                    @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Successful Insert Fee
      *
     C                   PARM                    @SIFEER          19
      *
      ***  If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANKS
     C                   MOVE      '1'           *INU6
     C                   END
      *
      ***  If CK/3 or CK/12 taken in browse, or error message
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      ***  Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record
      *****************************************************************
     C     RDNBRW        BEGSR
 
      ***  Read next subfile record
      *
     C                   CALLB     'LEFEEMRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Build subfile
     C                   PARM      *BLANKS       @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      'Y'           @RDSFL            1
      *
      ***  Error in update of previous Fee
     C                   PARM                    @ERRUP            1
      *
      ***  Branch code
     C                   PARM                    @BRCA
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    @ERRMS            7
      *
      ***  Option selected
     C                   PARM                    @OPSEL            1
      *
      ***  Action selected
     C                   PARM                    @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Successful Insert Fee
      *
     C                   PARM                    @SIFEER          19
      *
      ***  If CK/3 taken within invalid transaction deletion function,
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      ***  If invalid Fee read from subfile
      *
     C     @OPSEL        IFNE      *BLANK                                                    B1
      *
      ***  Blank all screens
      *
     C                   MOVEL     *BLANK        NwFeScnFmt
     C                   MOVEL     'Y'           WrkDftSettl       1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFee
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  Retrieve Fee details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      ***  Make sure Invalid transaction's  details are passed to 'Retrieve'
      ***  module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     LEIFEEMX0                          99
      *
      ***  Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ***  if insert
      ***  if not insert and Midas transaction ID is not present
      ***  Otherwise
      ***  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'                                                         2
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE                                                                  2
     C     DDCSSN        IFEQ      *BLANK                                                      3
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE                                                                  3
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF                                                                 3
     C                   ENDIF                                                                 2
      *
     C                   EXSR      RTVFee
      *
      ***  If Fee details were retrieved
      ***  Put the Fee on the detail screen
      *
     C     DDACTN        IFNE      'I'                                                          2
     C     Idx           ANDEQ     *ZERO
     C                   EXSR      PUTD@M
     C                   END                                                                    2
      *
      ***  Now overwite the fields on the main details screen with those
      ***  on the invalid Fee file (except for the Midas Fee number
      ***  and Midas associated Fee number retrieved above using the
      ***  front office transaction and associated transaction IDs).
      ***  Access invalid Fee with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDCSSN        ##DDCSSN         10
     C                   MOVEL     DDFACT        ##DDFACT          3
     C                   MOVEL     DDFCNO        ##DDFCNO          2
     C                   MOVEL     DDLNRF        ##DDLNRF          6
     C                   MOVEL     DDFSEQ        ##DDFSEQ          2
 
     C     ZATRNKX0      CHAIN     LEIFEEMX0                          99
     C     *IN99         IFEQ      *OFF                                                         2
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDCSSN      DDCSSN
     C                   MOVEL     ##DDFACT      DDFACT
     C                   MOVEL     ##DDFCNO      DDFCNO
     C                   MOVEL     ##DDLNRF      DDLNRF
     C                   MOVEL     ##DDFSEQ      DDFSEQ
     C                   END                                                                    2
      *
      * Access invalid deal settlement instructions
      *
     C                   CLEAR                   S_PAY
     C                   CLEAR                   S_REC
 
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *
      ***  If Fee details were retrieved and this is an amendment
      *
     C     *IN99         IFEQ      *OFF                                                         2
     C     DDACTN        ANDEQ     'A'
     C     *IN99         OREQ      *OFF                                                         2
     C     DDACTN        ANDEQ     'I'
      *
      ***  Data Substitution - Transaction Details
      *
     C     GHSUBS        IFNE      *blank                                                       3
     C     GHSUBS        SCAN      NwFeScnFmt                             99
     C     *IN99         IFEQ      *ON                                                          4
     C                   EXSR      TDtDtaSubs
     C                   END                                                                    4
     C                   END                                                                    3
 
      * Setup settlement instructions on amend
 
     C     DDACTN        IFEQ      'A'
     C                   EXSR      SetupAmend
 
      * Data Substitution - Settlement Details
 
     C     GHSUBS        ifne      *blank                                                       3
     C     GHSUBS        SCAN      S_PAY                                  99
     C  N99GHSUBS        SCAN      S_REC                                  99
     C     *IN99         IFEQ      *ON                                                          4
     C                   EXSR      SDtDtaSubs
     C                   END                                                                    4
     C                   END                                                                    3
 
     C                   END
     C                   END
      *
      ***  If action code, or Fee number were NOT OK
      ***  blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      ***  Send the Fee error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      ***  Go to main detail screen
      *
     C                   MOVE      'M'           @SCRN
      *
      ***  else if no invalid Fee read from subfile
      *
     C                   ELSE
      *
      ***  Go to browse screen
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - Send a message to main screen
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ***  If there are fundamental errors in this transaction
      ***  Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ***  Initialize error indicators
      *
     C                   MOVEA     OkFee         @EI
      *
      ***  Read error messages for Fee
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ***  Add error message to array passed to detail screen
      ***  and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           OkFee
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - Process screen
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      ***  Enable/disable detail fields on main details screen
      ***  if changes to the data are allowed
      ***  (key fields = action code & Fee   number; detail fields = rest)
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD            1
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      ***  KJ = Command kay 10 = Delete
      *
     C     DDACTN        IFEQ      'D'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      *
      ***  KK = Command kay 11 = Authorise
      *
     C     DDACTN        IFEQ      'X'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EINKK
     C                   ELSE
     C                   MOVEL     'N'           @EINKK
     C                   END
 
      ***  Write/read display screen
      *
     C                   CALLB     'LEFEEMDSP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fee (in screen format)
     C                   PARM                    NwFeScnFmt
      *
      ***  Fields in error
 
     C                   PARM                    OkFee
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKK            1
     C                   PARM                    @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFEER          19
      *
      ***  Feature
      *
     C                   PARM                    CLE006            1
      *
      ***  Profit Center amendable
      *
     C                   PARM                    BKPRCA            1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKK             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM                    WriteOnly         1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFee
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on screen
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      ***  Validate input to screen
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - Validate input to screen
      *****************************************************************
     C     VAL@M         BEGSR
      *
      ***  Retrieve Fee   details
      *
     C                   MOVEL     '      '      ModeofOp
     C                   EXSR      RTVFee
      *
      ***  If action code, or Fee number are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'D'
      *
      ***  Update Fee in File Format
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C     @INKN         IFEQ      *ON                                          See Settlement detai
     C                   MOVEL     'S'           @SCRN
     C                   Endif
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Fee in File Format
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
      ***  Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Fee in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OkFee
     C                   CLEAR                   ValidFeem
     C                   Z-ADD     *ZERO         VFRSTM
     C**********         Z-ADD     *ZERO         VFROBN                                       CSD027
     C**********         Z-ADD     *ZERO         VFROCN                                       CSD027
     C                   EVAL      VFROBN = *BLANKS                                           CSD027
     C                   EVAL      VFROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         VFPSTM
     C**********         Z-ADD     *ZERO         VFPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         VFPOCN                                       CSD027
     C                   EVAL      VFPOBN = *BLANKS                                           CSD027
     C                   EVAL      VFPOCN = *BLANKS                                           CSD027
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update Fee   in File Format
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
      ***  Validate whether non-amendable fields have been changed
      *
     C                   CALLB     'LEFEEMAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Fee in Screen Format
     C                   PARM                    NwFeScnFmt
      *
      * Current Fee in Screen Format
     C                   PARM                    CrFeScnFmt
      *
      * Fee in file format
     C                   PARM                    ValidFeem
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *                                                                                       245099
     C                   PARM                    CLE006                                       245099
      *
     C                   END
      *
      ***  Validate Fee details
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
 
     C                   CALLB     'LEFEEMVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
      ** Transaction Details
     C                   PARM                    NwFeScnFmt
      ** Settlement instructions
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_Fri
      ** Current Fee file
     C                   PARM                    CrFeFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      ** Loan CL file format
     C                   PARM                    ClilFilFmt
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
      * Expiry date
     C                   PARM                    WWDTEX            5 0
      * Facility amount
     C                   PARM                    WWFAMT           13 0
      * CLE006
     C                   PARM                    CLE006            1
      * CEU004
     C                   PARM                    CEU004            1
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F3PCOB            3
     C                   PARM                    F3TNRF           15
     C                   PARM                    F3IUSR           10
     C                   PARM                    F3XUSR           10
     C                   PARM                    F3AUSR           10
     C                   PARM                    F3TRDS            8
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
 
      * OUTPUTS
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidFeem
     C                   Endif
      *
      ***  If errors returned
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C                   GOTO      EVAL@M
     C                   END
      *
      ***  Continue
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVFee  - Retrieve Fee
      *****************************************************************
     C     RTVFee        BEGSR
      *
      ***  Retrieve Fee
      *
     C                   CALLB     'LEFEEMRTV'
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C                   PARM                    DDCSSN           10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Loan number
     C                   PARM                    DDLNRF            6
      * (Midas) Fee Sequence
     C                   PARM                    DDFSEQ            2
      *
      * CSC011 processing date
     C                   PARM                    WRNDAY
 
      * OUTPUTS
      * (Current) Fee in file format
     C                   PARM                    CrFeFilFmt
      * Loan CL in file format
     C                   PARM                    ClilFilFmt
      * Fclty FM in file format
     C                   PARM                    FacmFilFmt
      * OK - Action code
     C                   PARM                    DDACTNOK          1
      * OK - Customer number
     C                   PARM                    DDCSSNOK          1
      * OK - Facility type
     C                   PARM                    DDFACTOK          1
      * OK - Facility number
     C                   PARM                    DDFCNOOK          1
      * OK - Loan number
     C                   PARM                    DDLNRFOK          1
      * OK - Fee sequence
     C                   PARM                    DDFSEQOK          1
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Expiry date
     C                   PARM                    WDTEX             5 0
      * Facility amount
     C                   PARM                    WFAMT            13 0
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
     C                   PARM                    PRcvParm                                     244636
      *
      ***  Retrieve Branch code of the transaction
      *
     C                   if        DDLNRF <>  *Blanks
     C                   MOVEL     CL_BRCA       @BRCA
     C                   Else
     C                   MOVEL     FA_BRCA       @BRCA
     C                   Endif
      *
      ***  if Only Warning, Refresh OK Flag
      *
     C                   if        IDX = 0
     c                   eval      Widx = 0
     C                   MOVE      *ALL'Y'       OkFee
     C                   MOVE      *BLANKS       WMsgidArr
     C                   MOVEL     *BLANKS       WFldNamArr
     C                   MOVEL     *BLANKS       WMsgIdArr
     C                   MOVEL     *BLANKS       WMsgDtaArr
     C                   endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a Fee on the detail screen                       *
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      ***  Call program to fill screen fields with data from LEFEED.
      *
     C                   CALLB     'LEFEEMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Fee in file formats
     C                   PARM                    CrFeFilFmt
      *
      * Loan in file formats
     C                   PARM                    ClilFilFmt
      *
      * Fclty in file formats
     C                   PARM                    FacmFilFmt
      *
      * CLE006
     C                   PARM                    CLE006            1
      *
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      *
      * Output parameters
      *
      * Fee in screen format
     C                   PARM                    NwFeScnFmt
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI
      *
      ***  Update 'Current' Fee with Fee in Screen Format
     C                   MOVEL     NwFeScnFmt    CrFeScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - Cancel on main screen
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details evoked for        *
      *          inserts, amends, enquiries & authorizations          *
      *****************************************************************
     C     SCRN@S        BEGSR
 
     C                   MOVE      *BLANKS       WWLNRF            6
 
     C     DDFACT        IFNE      *Zero
     C     DDFACT        ANDNE     *Blank
     C                   EVAL      WWLNRF = DDFACT + DDFCNO
     C                   ELSE
     C                   EVAL      WWLNRF = DDLNRF
     C                   END
      *
      ***  Determinate protect fields in settlement instructions
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
      *
      ***  Set up payment instructions from manual Repayment
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     FePay         F_PAY                                        CGL029
     C                   MOVEL     FePay         FLPAY                                        CGL029
     C                   MOVEL     FePayEx       FLPONS                                       CGL029
     C                   MOVEL     PSTM          FLPSTM                                       CGL029
     C                   MOVEL     CVMR          FLCVMR
     C                   MOVEL     FESCCY        FLPSCY
     C                   MOVEL     FEICCY        FLIC72
      *
      ***  Set up receive instructions from Manual Repayment
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     FeRec         F_REC                                        CGL029
     C                   MOVEL     FeRec         FLREC                                        CGL029
     C                   MOVEL     FeRecEx       FLRONS                                       CGL029
     C                   MOVEL     RSTM          FLRSTM                                       CGL029
     C                   MOVEL     FESCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FEREXR        FLREXR                                       CLE031
     C                   Z-ADD     FEPEXR        FLPEXR                                       CLE031
     C                   MOVE      FEREXI        FLREXI                                       CLE031
     C                   MOVE      FEPEXI        FLPEXI                                       CLE031
     C                   MOVE      FESCCY        FLRSCY                                       CLE031
     C                   MOVE      FEPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
      *
      ***  Settlement instructions input
      *
     C                   MOVE      *BLANKS       ##LNRF
     C     DDFACT        IFNE      *Zero
     C     DDFACT        ANDNE     *Blank
     C                   EVAL      ##LNRF = DDFACT + DDFCNO
     C                   ELSE
     C                   EVAL      ##LNRF = DDLNRF
     C                   END
      *
      *
      * If no changes are allowed, protect (but still validate)
      * all instructions by passing action code 'X' to ZASETINSIN
      *
     C     @OPSEL        IFEQ      'N'
     C                   MOVEL     'X'           ##ACTN
     C                   ELSE
     C                   MOVEL     DDACTN        ##ACTN
     C                   ENDIF
 
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        ##RTCD           10
      *
      ***  Action code
      *
     C                   PARM                    ##ACTN            1
      *
      ***  Loan number
      *
     C                   PARM      DDLNRF        ##LNRF            6
      *
      ***  Protect Payment
      *
     C                   PARM                    ##PPAY            1
      *
      ***  Protect Receive
      *
     C                   PARM                    ##PREC            1
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDECUR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDECUR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCSSN        ##CSSN           10
      *
      ***  Transaction Type
      *
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Booking branch
      *
     C                   PARM      FEBRCA        ##BRCA            3
      *
      ***  Receipt Date
      *
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
      *
     C                   PARM                    ##DATP            5 0
      *
      ***  Payment instructions
      *
     C                   PARM                    S_PAY
      *
      ***  Receive instructions
      *
     C                   PARM                    S_REC
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    S_FRI
      *
      ***  Outputs
      *
      ***  Payment instructions
      *
     C                   PARM                    F_Pay
      *
      ***  Receive instructions
      *
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    F_FRI
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
      *
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      *
      ***  Extra validation
      *
     C                   CALLB     'LEFEEMEVL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode
      * Fee detail file
     C                   PARM                    CrFeFilFmt
      * Fee detail screen
     C                   PARM                    NwFeScnFmt
      * Fee Valid file
     C                   PARM                    ValidFeem
      * CEU004
     C                   PARM                    CEU004
      * Payment instructions
     C                   PARM                    F_Pay
      *
      *  Receive instructions
     C                   PARM                    F_REC
      *
      *  FRA/IRS instructions
     C                   PARM                    F_FRI
 
      * OUTPUTS
 
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ***  Update Fee in file format
      *
     C**********         MOVEL     F_Pay         VfPay                                        CGL029
     C**********         MOVEL     F_Rec         VfRec                                        CGL029
     C                   MOVEL     FLRec         VfRec                                        CGL029
     C                   MOVEL     FLRONS        VfRecEx                                      CGL029
     C                   MOVEL     FLRSTM        VFRSTM                                       CGL029
     C                   MOVEL     FLPay         VfPay                                        CGL029
     C                   MOVEL     FLPONS        VfPayEx                                      CGL029
     C                   MOVEL     FLPSTM        VFPSTM                                       CGL029
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        VFFEREXR                                     CLE031
     C                   Z-ADD     FLPEXR        VFFEPEXR                                     CLE031
     C                   MOVE      FLREXI        VFFEREXI                                     CLE031
     C                   MOVE      FLPEXI        VFFEPEXI                                     CLE031
     C                   MOVE      FLRSCY        VFSCCY                                       CLE031
     C                   MOVE      FLPSCY        VFFEPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     ValidFeem     CrFeFilFmt
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on settlement details
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      ***  Exit from settlement details
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - Determine parameters for settlement details screen   *
      *****************************************************************
     C     DETP@S        BEGSR
 
     C                   MOVE      VFPSTD        ##DATR
     C                   MOVE      VFPSTD        ##DATP
      *
      ** Determine if pay settlement should be protected
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      'Y'           ##PREC
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
     C     WPTFI         IFEQ      'P'
     C     WPTFI         OREQ      'S'                                                        CLE106
     C     WPTFI         OREQ      'R'                                                        CLE106
     C                   MOVE      'N'           ##PPAY
     C                   MOVE      'Y'           ##PREC
     C                   ENDIF
      *
     C     WPTFI         IFEQ      *BLANK
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      'N'           ##PREC
     C                   ENDIF
      *
     C                   ENDIF
      *
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     S_PAY         IFNE      *blank
     C     S_REC         ORNE      *blank
     C                   GOTO      EDETP@S
     C                   END
      *
      ***  If amend, enquire, authorize or delete
      ***  move settlement file fields to screen fields
      ***  Else clear settlement screen fields
 
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'I'
     C     WrkDftSettl   ANDEQ     'N'
      *
      ***  SET UP PAYMENT INSTRUCTIONS
      *** (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     FePAY         F_Pay                                        CGL029
     C                   MOVEL     FePAY         FLPay                                        CGL029
     C                   MOVEL     FePAYEx       FLPONS                                       CGL029
     C                   MOVEL     PSTM          FLPSTM                                       CGL029
     C                   MOVE      FEOSBR        FLPOBR
     C                   if        CEU004 = 'Y'
     C                   MOVEL     FESCCY        FLPSCY
     C                   MOVEL     FEICCY        FLIC72
     C                   Endif
      *
      *** SET UP RECEIVE INSTRUCTIONS
      *** (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     FERec         F_Rec                                        CGL029
     C                   MOVEL     FERec         FLRec                                        CGL029
     C                   MOVEL     FERecEx       FLRONS                                       CGL029
     C                   MOVEL     RSTM          FLRSTM                                       CGL029
     C                   MOVE      FEOSBR        FLROBR
     C                   if        CEU004 = 'Y'
     C                   MOVEL     FESCCY        FLRSCY
     C                   endif
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FEREXR        FLREXR                                       CLE031
     C                   Z-ADD     FEPEXR        FLPEXR                                       CLE031
     C                   MOVE      FEREXI        FLREXI                                       CLE031
     C                   MOVE      FEPEXI        FLPEXI                                       CLE031
     C                   MOVE      FESCCY        FLRSCY                                       CLE031
     C                   MOVE      FEPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE                                                                    x1
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO                                                         b2
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDECUR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDECUR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCSSN        ##CSSN           10
      *
      ***  Ts Type
      *
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Version of ISDA Rules govern
      *
     C                   PARM                    BQISDA            4
      *
      ***  Type of ISDA agreement
      *
     C                   PARM                    BQAGTY            6
      *
      ***  Date of ISDA Agreement
      *
     C                   PARM                    BQAGDT            6
      *
      ***  Version of ISDA Agreement
      *
     C                   PARM                    BQAGVV            2
      *
      ***  Version of ISDA Agreement century
      *
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
      ***  Payment instructions
      *
     C                   PARM                    F_Pay
      *
      ***  Receive instructions
      *
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    F_FRI
      *
     C                   END                                                                      e2
     C                   END                                                                      e2
                                                                                             CSF011A
     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
      *
      ***  Convert settlement details from file to screen format
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      *
      ***  File Payment Settlement Instruction
      *
     C                   PARM                    F_Pay
      *
      ***  File Receipt Settlement Instruction
      *
     C                   PARM                    F_REC
      *
      ***  File FRA/IRS Settlement Instruction
      *
     C                   PARM      *BLANK        F_FRI
      *
      ***  Outputs
      ***  Screen Payment Settlement Instruction
      *
     C                   PARM      *BLANK        S_PAY
      *
      ***  Screen Receipt Settlement Instruction
      *
     C                   PARM      *BLANK        S_REC
      *
      ***  Screen FRA/IRS Settlement Instruction
      *
     C                   PARM      *BLANK        S_FRI
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
      *
 
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'C'           @SCRN
     C                   ELSE
     C                   MOVEL     'U'           @SCRN
     C                   END
      *
      * UPDATE VALID FEE: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         FEPAY
     C                   MOVEL     FLPONS        FEPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        PSTM                                         CGL029
     C                   MOVEL     FLCVMR        CVMR
      *
      * UPDATE VALID FEE: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         FEREC
     C                   MOVEL     FLRONS        FERECEx                                      CGL029
     C                   MOVEL     FLRSTM        RSTM                                         CGL029
      *
      * UPDATE VALID FEE: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLPSCY        FESCCY
     C                   MOVEL     FLIC72        FEICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        FEREXR                                       CLE031
     C                   Z-ADD     FLPEXR        FEPEXR                                       CLE031
     C                   MOVE      FLREXI        FEREXI                                       CLE031
     C                   MOVE      FLPEXI        FEPEXI                                       CLE031
     C                   MOVE      FLRSCY        FESCCY                                       CLE031
     C                   MOVE      FLPSCY        FEPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process screen: Confirmation of input                *
      *          evoked for inserts, amends & authorizations          *
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      ***  Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LER0350'     MsgIdArr(1)
 
      ***  Write/read display screen
      *
     C                   CALLB     'LEFEEMDSP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fee (in screen format)
     C                   PARM                    NwFeScnFmt
      *
      ***  Fields in error
      *
     C                   PARM                    OKFee
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFEER          19
      *
      ***  Feature
      *
     C                   PARM                    CLE006
      *
      ***  Feature
      *
     C                   PARM                    BKPRCA
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKK             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFee
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on confirmation screen
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      ***  Exit confirmation screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to second detail screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
     C     WIdx          ANDEQ     *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  Else, return to detail screen
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * IF SEQ NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE SEQ NUMBER
      *
     C     DDFSEQ        IFEQ      *BLANK
     C                   EXSR      SEQGEN
     C                   MOVEL     FEFSEQ        DDFSEQ
     C                   END
      *
      * UPDATE VALID FEE
      *
     C                   MOVEL     DDCSSN        @SICSSN
     C                   MOVEL     DDFACT        @SIFACT
     C                   MOVEL     DDFCNO        @SIFCNO
     C                   MOVEL     DDLNRF        @SILNRF
     C                   MOVEL     DDFSEQ        @SIFSEQ
      *
      ***  Update valid Fee  : Fee number
      *
     C                   MOVEL     DDCSSN        VFCNUM
     C                   MOVEL     DDFACT        VFFACL
     C                   MOVE      DDFCNO        VFFACL
     C                   MOVE      DDLNRF        VFLOAN
     C                   MOVE      DDFSEQ        VFFSEQ
      *
      ***  Update valid Fee  : Last action code
      *
     C                   MOVEL     DDACTN        VFLCHT
      *
      ***  Update valid loan: Front office transaction ID
      *
     C                   MOVEL     @FOTRANSEL    VFFRNT
      *
      ***  Fee updates
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C                   CALLB     'LEFEEMUPD'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      'B'           P#MODE            1
     C                   PARM                    ValidFeem
     C                   PARM                    CrFeFilFmt                                  BUG3760
     C                   PARM                    CLE002
     C                   PARM                    CSC011
      * Fees to be Authorised
     C                   PARM                    BPFEAU
      * Run date
     C                   PARM                    BJRDNB
      * TNLU of funding participant record on FEE file
     C                   PARM      FETNLU        H#TNLU            5 0
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    OkFee
      * Fee sequence
     C                   PARM                    WFSEQ             2 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
      *                                                                                     AR868380
     C     @@RTCD        IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) =  'LEL0817'                                 AR868380
     C                   EVAL      @RTCD = @@RTCD                                           AR868380
     C                   ENDIF                                                              AR868380
 
     C                   END
 
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     CSC022        IFEQ      'N'                                                       BUG2571
     C                   ROLBK
     C                   ELSE                                                                BUG2571
     C     WCMT01        IFNE      'Y'                                                       BUG2571
     C                   ROLBK                                                               BUG2571
     C                   ELSE                                                                BUG2571
     C                   SETON                                        U7U8                   BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C     @RTCD         IFNE      '*RECUPD'
     C     @RTCD         ANDNE     '*RECLCK'                                                AR868380
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     ZATRNKD0      CHAIN     LEIFEEMD0                          99
     C  N99              DELETE    LEIFEEMD0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *
      ***  Delete invalid record from the log file
      *
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
      *
     C                   EVAL      KMsgType = 'LEFEEM'
     C                   EVAL      KFrntOffID = DDFOTRANID
     C                   EVAL      KTimeStamp = DDTMESTMP
      *
     C     KAPLOG        CHAIN     APILOGL0                           99
      *
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CSC022        IFEQ      'N'                                                       BUG2571
     C     WCMT01        OREQ      'N'                                                       BUG2571
     C     CSC022        ANDEQ     'Y'                                                       BUG2571
     C                   COMMIT
     C                   ENDIF                                                               BUG2571
     C                   END
      *
      ***  If error occurred in updating last transaction set on flag to
      ***  display message on 'browse' screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C     @RTCD         OREQ      '*RECLCK'                                                AR868380
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SEQGEN - Subroutine to generate fee sequence number          *
      *****************************************************************
     C     SEQGEN        BEGSR                                                  *** SEQGEN ***
      *
     C                   MOVEL     DDCSSN        WCNUM
     C                   MOVE      DDFACT        WFAC02
     C                   MOVE      DDFCNO        WFAC03
     C                   MOVE      DDLNRF        WLOAN
     C                   Z-ADD     99            WFSEQ
      *
      **  Prevent pick up of details from previous fee
     C     KEY002        SETGT     LEFEEDF1
     C     KEY005        READPE    LEFEEDF1                               78
      *
     C     *IN78         IFEQ      '1'
     C                   MOVE      '01'          FEFSEQ
      *
     C                   ELSE
      *
     C     WCNUM         IFEQ      FECNUM
     C     WLOAN         ANDEQ     FELOAN
     C     WFAC05        ANDEQ     FEFACL
     C                   ADD       1             FEFSEQ
      *
     C                   ELSE
      *
      ** There are no existing fee records with the key fields input so
      ** put original values back in key fields ready for file update
      ** and allocate a fee sequence no. of 01.
      *
     C                   MOVE      WCNUM         FECNUM
     C**********         Z-ADD     WLOAN         FELOAN                                       CLE148
     C                   MOVEL     WLOAN         FELOAN                                       CLE148
     C                   Z-ADD     WFAC05        FEFACL
     C                   MOVE      '01'          FEFSEQ
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Having checked the live fees the matured fees need to be
      ** checked in the same way
      *
     C     KEY012        SETGT     LEFHSTF
     C     KEY015        READPE    LEFHSTF                                78
      *
     C     *IN78         IFEQ      '0'
      *
     C     WCNUM         IFEQ      HICNUM
     C     WLOAN         ANDEQ     HILNRF
     C     WFAC05        ANDEQ     HIFACL
     C                   ADD       1             HIFSEQ
      *
     C                   ELSE
     C                   MOVE      '01'          HIFSEQ
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  Store allocated sequence number for output
     C     FEFSEQ        IFGT      HIFSEQ
     C                   MOVE      FEFSEQ        @ALSEQ            2
     C                   ELSE
     C                   MOVE      HIFSEQ        @ALSEQ            2
     C                   ENDIF
      *
     C                   MOVE      @ALSEQ        FEFSEQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *****************************************************************
      *
     C     TDtDtaSubs    BEGSR
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode       10
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      *
      ***  Incoming Data
     C                   PARM      NwFeScnFmt    IncDATA        2000
      *
      ***  Current Data
     C                   PARM      CrFeScnFmt    CurDATA        2000
      *
     C                   MOVEL     IncDATA       NwFeScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupAmend - Setup Settlement Instructions on Amendment       *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
     C                   MOVEL     FEREC         FLREC
     C                   MOVEL     FERECEx       FLRONS                                       CGL029
     C                   MOVEL     RSTM          FLRSTM                                       CGL029
     C                   MOVEL     FESCCY        FLRSCY
     C                   MOVEL     FEPAY         FLPAY
     C                   MOVEL     FEPAYEx       FLPONS                                       CGL029
     C                   MOVEL     PSTM          FLPSTM                                       CGL029
     C                   MOVEL     CVMR          FLCVMR
     C                   MOVEL     FESCCY        FLPSCY
     C                   MOVEL     FEICCY        FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FEREXR        FLREXR                                       CLE031
     C                   Z-ADD     FEPEXR        FLPEXR                                       CLE031
     C                   MOVE      FEREXI        FLREXI                                       CLE031
     C                   MOVE      FEPEXI        FLPEXI                                       CLE031
     C                   MOVE      FESCCY        FLRSCY                                       CLE031
     C                   MOVE      FEPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
     C                   CALLB     'ZASETINCVT'
 
      ** Fee Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANK        F_FRI
 
      ** Current Settlement Instruction in input format
     C                   PARM      *BLANK        CrPaySttmt
     C                   PARM      *BLANK        CrRecSttmt
     C                   PARM      *BLANK        CrFRASttmt
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the Fee.
 
     C                   IF            (F_PAY = *blank)
     C                   EVAL      F_PAY = CrPaySttmt
     C                   ENDIF
 
     C                   IF            (F_REC = *blank)
     C                   EVAL      F_REC = CrRecSttmt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************
 
     C     SDtDtaSubs    BEGSR
 
      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      S_PAY         IncDATA
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA
 
     C                   MOVEL     IncDATA       S_PAY
 
      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      S_REC         IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA
 
     C                   MOVEL     IncDATA       S_REC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFEEMRPR'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
 
      *
      ***  Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
 
      ** Determine if CLE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
 
      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
 
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
 
      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
      *
      ** Determine if CLE014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CEU004 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU004            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU004
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
 
     C                   OPEN      APILOGL0
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C* Is the support system on?
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Determine if CEU013 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *
      ***  Key Lists
      *
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
 
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
      ** KLIST for file LEFEED
     C     KEY002        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *
      ** KLIST for file LEFEED
     C     KEY005        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
      *
      ** KLIST for file LEFHSTL1
     C     KEY012        KLIST
     C                   KFLD                    VFBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *
      ** KLIST for file LEFHSTL1
     C     KEY015        KLIST
     C                   KFLD                    VFBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C*
     C                   MOVEL     'LEFEEM'      @MSGTYPE
      *
      ***  Get the field number for the action code field; the screen fields
      ***  start from that number.  Subtract one from it to give the value
      ***  to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ***  If there was an error default the offset to 13
      *
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *
      ***  Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
      * Determine if CSC022 is switched on                                                   BUG2571
                                                                                             BUG2571
     C                   CALLB     'AOSARDR0'                                                BUG2571
     C                   PARM      *BLANKS       @RTCD                                       BUG2571
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2571
     C                   PARM      'CSC022'      @SARD                                       BUG2571
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2571
     C                   IF        @RTCD = *BLANK                                            BUG2571
     C                   EVAL      CSC022 ='Y'                                               BUG2571
     C                   EVAL      WCMT01 ='N'                                               BUG2571
      * SCCMTJOB data area                                                                   BUG2571
     C                   IN        SCCMTJOB                                                  BUG2571
      * Move data area to commitment array                                                   BUG2571
     C                   IF        COMITNOM > 0                                              BUG2571
     C                   MOVEA     COMITJOB      ARRJBNAM                                    BUG2571
      *                                                                                      BUG2571
      * Check if PSJOBNAME exist.                                                            BUG2571
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                 BUG2571
     C                   IF        *IN17 = *ON                                               BUG2571
     C                   EVAL      WCMT01= 'Y'                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
      *                                                                                      BUG2571
     C                   ELSE                                                                BUG2571
      * @rtcd not found                                                                      BUG2571
     C                   IF        @RTCD <> '*NRF'                                           BUG2571
     C     *LOCK         IN        LDA                                                       BUG2571
     C                   EVAL      DBPGM = 'LEFEEMRPR'                                       BUG2571
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2571
     C                   EVAL      DBFILE ='SCSARDPD'                                        BUG2571
     C                   EVAL      DBASE  = 005                                              BUG2571
     C                   OUT       LDA                                                       BUG2571
     C                   EXSR      *PSSR                                                     BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                             BUG2571
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
