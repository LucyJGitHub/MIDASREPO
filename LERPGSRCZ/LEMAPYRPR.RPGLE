     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid Manual Repayment - Repair')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYRPR - LE Invalid Manual Repayment - Repair             *
      *                                                               *
      *  Function:  This is the screens input repair function for     *
      *             Manual repayment                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246778             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 14Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 01Jul04               *
      *                 CLE025             Date 20May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 14Jan03               *
      *                 CAP077  *CREATE    Date 29Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
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
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246778 - Option 'N' in the browser (field @OPSEL) should     *
      *           work exactly in the same way than option 'U'.       *
      *           The only difference is that this 'N' option is      *
      *           to amend the database WITHOUT changing the data     *
      *           received from the external source (i.e. amend with  *
      *           No change).                                         *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005   Reservation ID                                      *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
     FLEIMAPYL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIMAPYD0 : LEIMAPYX0)
     FLEIMAPYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEMAPYR001
      *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
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
      ** Ê End of automatically included D-specsÊ
      ** Ê =====================================Ê
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
      *
     D @EI             S              1    DIM(60)
      *
     D CrMAPYFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Current manual repayment in File Format
     D                                     PREFIX(L)
     D***MRREC**              321    389                                                      CGL029
     D***MRPAY**              390    948                                                      CGL029
     D  MRREC                335    389                                                       CGL029
     D  MRPAY                404    948                                                       CGL029
     D  MRRECEx             1195   1212                                                       CGL029
     D  MRPAYEx             1213   1230                                                       CGL029
      *
     D CrMAPYScnFmt  E DS                  EXTNAME(LEMAPYPD)
      ***  Current manual repayment in Screen Format
     D                                     PREFIX(@)
      *
     D NwMAPYFilFmt  E DS                  EXTNAME(LEVMAPYPD)
      ***  New manual repayment in File Format
     D***NMRREC*              321    389                                                      CGL029
     D***NMRPAY*              390    948                                                      CGL029
     D  NMRREC               335    389                                                       CGL029
     D  NMRPAY               404    948                                                       CGL029
     D  NMRRECEx            1195   1212                                                       CGL029
     D  NMRPAYEx            1213   1230                                                       CGL029
      *
     D NwMAPYScnFmt  E DS                  EXTNAME(LEMAPYPD)
      ***  New manual repayment in Screen Format
      *
     D ErrorMAPY     E DS                  EXTNAME(LEEMAPYPD)
      ***  Error indicators Screen 1
      *
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ***  Midas API Message Header Format Definition
      *
      **********************************
      ** Settlement instructions part **
      **********************************
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** File payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS instructions

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen receive instructions

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen payment instructions

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS instructions
      *
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      ***  Pay Settlement Instructions - Current
      *
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      ***  Receive Settlement Instructions - Current
      *
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      ***  FRA/IRS Settlement Instructions - Current
      *
     D @SETIN          DS
      ***  Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D***@@RONS*                6     17                                                      CGL029
     D***@@PSCY*               18     20                                                      CGL029
     D***@@PSTM*               21     22  0                                                   CGL029
     D***@@PONS*               23     34                                                      CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer Lending ICD
      *
     D*ReadLoAm      E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format (From Caller)
     D****                                 PREFIX(ReadPD_)
      *
     D*ReadLoan      E DS                  EXTNAME(CLOANCL) Prefix(ReadCL)
     D**ReadLnLastChg        314    320
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
     D                                     PREFIX(PD_)
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ***  Midas SE Trading ICD accessed via access program
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Midas General Ledger ICD accessed via access program
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Midas Retail ICD accessed via access program
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
      ***  Loan PAyment/receipt instructions
     D***LoanRecInst          459    527                                                      CGL029
     D***LoanPayInst          528   1086                                                      CGL029
     D  LoanRecInst          473    527                                                       CGL029
     D  LoanPayInst          542   1086                                                       CGL029
     D  LoanRecInstEx       1597   1614                                                       CGL029
     D  LoanPayInstEx       1615   1632                                                       CGL029
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ** Second DS for access programs, long data structure                                   CGL029
                                                                                              CGL029
     D PassDtaDS       DS           512
      ***  Ds to pass details from caller
     D CLE002                  1      1A
     D CLE003                  2      2A
     D CLE004                  3      3A
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE009                  6      6A
     D CLE014                  7      7A
     D CLE023                  8      8A
     D CEU004                  9      9A
     D CDE001                 10     10A
     D WrkDDESEQ              11     13A
     D WrkDDPASD              14     14A
     D WrkCntrMR              15     15  0
     D WrkReactFacil          16     16
      *
     D  OldSettlDS     DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
      *
     D  NewSettlDS     DS
      ***  New settlement details
      *
     D  WTYP                   1      2
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***WSETT**                1     34                                                      CGL029
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  WSETT                  1     40                                                       CGL029
      *
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * LE (MAPY) Extra Data - File (D/B) format                                              CAP086
                                                                                              CAP086
     D ExtData       E DS                  EXTNAME(LEMAEXPD)
      ***  LE (MAPY) Extra Data - File (D/B) format
      *
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ***  -------------------------------------------------------------------
      ***  Fields for getting the starting field number from file (parameters
      ***  to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('LEMAPYPD')
      *
     D Field           S             10A   INZ('DDACTN    ')
      *
     D FieldNo         S              5P 0
      *
     D FldOffset       S              5P 0
      *
      ***  End of fields for getting starting field number
      ***  -------------------------------------------------------------------
      *
      ***  Message type field for chaining to APIDSETPD; defined in terms
      ***  of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
                                                                                              CGL029
     D WOSAC           S             18                                                       CGL029
      *
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
      ** Parameter for LERPSCRTV                                                              244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A
                                                                                              244636
     D CAP086          S              1A                                                      CAP086
                                                                                              CAP086
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** Ê Hook for non-core D-specs (all types)  Ê
      ** Ê also any I-specs (if necessary)        Ê
      ** Ê =====================================  Ê
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEMAPYR002
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LEMAPYR003
      ***  Do screen: Browse invalid Manual Repayments
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      /COPY WNCPYSRC,LEMAPYR004
      *
      ***  Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      /COPY WNCPYSRC,LEMAPYR005
      *
      ***  Do while screen: Screen details
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      /COPY WNCPYSRC,LEMAPYR006
      *
      ***  Do while screen: Settlement details
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      /COPY WNCPYSRC,LEMAPYR010
      *
      ***  Screen: Confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      /COPY WNCPYSRC,LEMAPYR011
      *
      ***  Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      /COPY WNCPYSRC,LEMAPYR012
      *
      ***  Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LEMAPYR013
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Manuals Repayments
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LEMAPYRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
      *
      ***  Branch code
     C                   PARM                    @BRCA             3
      *
      ***  Error in update of previous manual repayment
     C                   PARM                    @ERRUP            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS            7
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
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  Successful Insert manual repayment
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LSSQ             3
      *                                                                                       CSC022
      ***  Enhancements for CSC022                                                            CSC022
     C                   PARM                    CSC022                                       CSC022
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
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LEMAPYRPB'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Build subfile
     C                   PARM      *BLANK        @BDSFL
      *
      ***  Read subfile record
     C                   PARM      'Y'           @RDSFL
      *
      ***  Branch code
     C                   PARM                    @BRCA
      *
      ***  Error in update of previous manual repayment
     C                   PARM                    @ERRUP
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM      *BLANK        @ERRMS
      *
      ***  Option selected
     C                   PARM      *BLANK        @OPSEL
      *
      ***  Action selected
     C                   PARM      *BLANK        @ACSEL
      *
      ***  FO transaction ID selected
     C                   PARM      *BLANK        @FOTRANSEL
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ***  Successful Insert manual repayment
     C                   PARM                    @LNRF
     C                   PARM                    @VDAT
     C                   PARM                    @LSSQ
      *                                                                                       CSC022
      ***  Enhancements for CSC022                                                            CSC022
     C                   PARM                    CSC022                                       CSC022
      *
      ***  If CK/3 taken within invalid transaction deletion function,
      ***  End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      ***  If invalid manual repayment read from subfile
      *
     C     @OPSEL        IFNE      *BLANK
      *
      ***  Blank all screens
      *
     C                   MOVEL     *BLANK        NwMAPYScnFmt
     C                   MOVEL     'N'           @EIN67
     C                   MOVEL     'Y'           WrkDftSettl
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorMAPY
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  Retrieve Manual Repayment details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      ***  Make sure Invalid transaction's details are passed to 'Retreive'
      ***  module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     LEIMAPYX0                          99
      *
      ***  Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ***  if insert
      ***  if not insert and Midas transaction ID is not present
      ***  Otherwise
      ***  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C     DDLNRF        IFEQ      *BLANK
     C     DDVALD        OREQ      *BLANK
     C     DDSEQN        OREQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVMAPY
      *
      ***  If manual repayment details were retrieved
      ***  Put the manual repayment on the details screen
      *
      ***  execute LEMAPYCVT to Retrieve working fields needed in LEMAPYVAL
     C     Idx           IFEQ      *ZERO
     C                   EXSR      PUTD@M
      *
      ***  Save OUTPUT Details
      *
     C                   END
      *
      ***  Now overwite the fields on the main details screen with those
      ***  on the invalid manual repayment file
      ***  Access invalid manual repayment with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDLNRF        ##DDLNRF          6
     C                   MOVEL     DDVALD        ##DDVALD          6
     C                   MOVEL     DDSEQN        ##DDSEQN          3
     C     ZATRNKX0      CHAIN     LEIMAPYX0                          99
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDLNRF      DDLNRF
     C                   MOVEL     ##DDVALD      DDVALD
     C                   MOVEL     ##DDSEQN      DDSEQN
     C                   END
      *
      ***  Fill Output only fileds with loan details and or loan Amendments files
      *
     C                   MOVE      @DDCURP       DDCURP                         Current Principal
     C                   MOVE      @DDSCCY       DDSCCY                         Settlement Currency
     C                   MOVE      @DDINTD       DDINTD                         Outstanding Interest
      *                                                                                      BUG3114
     C                   If        CLE028 = 'Y'                                              BUG3114
     C                   MOVEL     @DDINRF       DDINRF                                      BUG3114
     C                   MOVEL     @DDCGRF       DDCGRF                                      BUG3114
     C                   Endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      @DDWTTP       DDWTTP                         W/hold Tax Indicator
     C                   MOVE      @DDEPRI       DDEPRI                         Expected Principal
     C                   MOVE      @DDEINT       DDEINT                         Expected Interest
     C                   MOVE      @DDETOT       DDETOT                         Expected Total
     C                   MOVE      @DDWHTX       DDWHTX                         Expected W/hold tax
     C                   MOVE      @DDEPEN       DDEPEN                         Expected Penalities
      *
      ***  Access invalid manual repayment settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *
      ***  If manual repayment details were retrieved and this is an amendment
      *
     C     *IN99         IFEQ      *OFF
     C     DDACTN        ANDEQ     'A'
     C     *IN99         OREQ      *OFF
     C     DDACTN        ANDEQ     'I'
      *
      ***  Data Substitution - Transaction Details
      *
     C     GHSUBS        IFNE      *blank
     C     GHSUBS        SCAN      NwMAPYScnFmt                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C                   END
      *
      ***  Setup settlement instructions on amend
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      SetupAmend
      *
      ***  Data Substitution - Settlement Details
      *
     C     GHSUBS        ifne      *BLANKS
     C     GHSUBS        SCAN      ##PAYS                                 99
     C  N99GHSUBS        SCAN      ##RECS                                 99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   END
     C                   END
     C                   Endif

     C                   END
      *
      ***  If action code, or loan number, or value date, or sequence were NOT OK
      ***  blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDVALDOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      ***  Send the manual repayment error messages to the details screen
      *
     C                   EXSR      SNDM@M
      *
      ***  Go to details screen
      *
     C                   MOVE      'M'           @SCRN
      *
      ***  else if no invalid manual repayment read from subfile
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
      * SNDM@M - Send a message to first screen
      *****************************************************************
     C     SNDM@M        BEGSR

     C                   Z-ADD     Idx           E                 3 0
      *
      ***  If there are fundamental errors in this transaction
      ***  Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ***  Initialize error indicators
      *
     C                   MOVEA     ErrorMAPY     @EI
      *
      ***  Read error messages for manual repayment
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ***  Add error message to array passed to detail screen
      ***  and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   if        ABMSGFILE = 'LERMSGF   '                     Only Lending API msg
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
      *
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   Endif
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           ErrorMAPY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - Process details screen
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      ***  Enable/disable detail fields on main details screen
      ***  if changes to the data are allowed
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD            1
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      ***  KJ = Command kay 10 = Delete
      *
     C     DDACTN        IFEQ      'R'
     C*****@OPSEL*****   ANDEQ     'U'                                                        246778
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
     C     DDACTN        IFEQ      'X'
     C*****@OPSEL*****   ANDEQ     'U'                                                        246778
     C     IDX           ifeq      0
     C     BPAURV        IFEQ      'Y'
     C                   MOVEL     'N'           @EINKQ
     C                   ELSE
     C                   MOVEL     'Y'           @EINKQ
     C                   ENDIF
      *
     C                   ELSE                                                  error,
     C                   MOVE      'N'           @EINKQ                        F16 not authorised
     C                   Endif
     C                   ELSE
     C                   MOVEL     'N'           @EINKQ
     C                   ENDIF
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LEMAPYDSP'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Manual Repayment (in screen format)
     C                   PARM                    NwMAPYScnFmt
      *
      ***  Fields in error
      *
     C                   PARM                    ErrorMAPY
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
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1
      *
      ***  Activated Features/Flags
     C                   PARM                    @EIN67            1            Cust Checked
     C                   PARM                    CLE005            1            Feature
     C                   PARM      CLE003        @EIN88            1            CLE003
     C                   PARM      CLE007        @EIN89            1            CLE007
      ***  Details from RTV module
     C                   PARM                    WrkExpAmdtp       2            PD/RE Amend Type
     C                   PARM                    WrkRepaytp        1 0          Loan Repay. Type
     C                   PARM                    WrkProcTypLoan    2 0          Loan Proc. Type
      *
      ***  Succesful insert
     C                   PARM                    @LSSQ             3
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1
      *
      ***  Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorMAPY
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
      ***  CK/12 - Cancel on first screen
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
      * VAL@M  - Validate input to main screen
      *****************************************************************
     C     VAL@M         BEGSR
      *
      ***  Retrieve manual repayment details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVMAPY
      *
      ***  If 1 of the key fields is not OK
      ***  ==> Re-Output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDVALDOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C     DDEVALOK      OREQ      'N'
     C     DDESEQOK      OREQ      'N'
     C                   Eval      @EIN67 = 'N'                                 Reset Cust. OK
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update manual repayment in File Format
      *
     C                   MOVEL     CrMAPYFilFmt  NwMAPYFilFmt
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   eval      NewSettlDS = OldSettlDS                      Settlement Instruct
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
      ***  Update Manual Repayment in File Format
      *
     C                   MOVEL     CrMAPYFilFmt  NwMAPYFilFmt
      *
      ***  Continue to settlements screen
      *
     C     @EINKQ        IFEQ      'Y'                                          F16 needed
      *
     C     @INKQ         IFEQ      *ON                                          F16 taken
     C                   MOVEL     'S'           @SCRN
     C                   Else
     C                   MOVE      'M'           @SCRN                          Redisplay
     C                   Endif
     C                   ELSE                                                   F16 not needed
      *
      ***  Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
     C                   Endif
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
      ***  and clear manual repayment in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       ErrorMAPY
     C                   CLEAR                   NwMAPYFilFmt
      *
      ***  If amend
      *
     C     DDACTN        IFEQ      'A'
      *
      ***  Update manual repayment in File Format
      *
     C                   MOVEL     CrMAPYFilFmt  NwMAPYFilFmt
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LEMAPYAMD'
      *
      ***  Inputs
      *
     C                   PARM      *BLANK        RetCodeOut                     Return Code
     C                   PARM                    NwMAPYScnFmt                   New MR in Screen fmt
     C                   PARM                    CrMAPYScnFmt                   Cur MR in Screen fmt
      *
      ***  Outputs
      *
     C                   PARM                    ErrorMAPY                      OK FLags
     C                   PARM                    FldNameArr                     Error Fields Array
     C                   PARM                    MsgIdArr                             Msg Ids
     C                   PARM                    MsgDtaArr                            Msg Data
     C                   PARM                    Idx                                  Idx
      *
     C                   PARM      'Y'           @@RSTE            1            Reset field in error
     C                   END
      *
      ***  Validate manual repayment details
      *
     C     DDACTN        IFEQ      'I'
     C*****@OPSEL*****   ANDEQ     'U'                                                        246778
      *
      ***  Validate Manual Repayment input details
      *
     C                   CALLB     'LEMAPYVAL'
      *
      ***  Inputs
      *
     C                   PARM                    RespMode                       Response mode
     C                   PARM                    NwMAPYScnFmt                   Nw MR in Screen Fmt
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan Details
     C                   PARM                    WrkReactFacil     1            Reactivated facility
     C                   PARM                    WrkOutPrinc      13 0          Outstanding Princ.
     C                   PARM                    WrkRemainInt     13 0          Loan Remaining int.
     C                   PARM                    WPTYP72           1            Expected on type 72
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
     C                   PARM                    ExtData                        Addtl Data
      *
      ***  Outputs
      *
     C                   PARM                    ErrorMAPY                      OK flags
     C                   PARM                    FldNameArr                     Error Fields Array
     C                   PARM                    MsgIdArr                             Msg Ids
     C                   PARM                    MsgDtaArr                            Msg Data
     C                   PARM                    Idx                                  Index
     C                   PARM                    WFldNamArr                     Warning Flds Array
     C                   PARM                    WMsgIdArr                              Msg Ids
     C                   PARM                    WMsgDtaArr                             Msg Data
     C                   PARM                    WIdx                                   Index
     C                   PARM                    NwMAPYFilFmt                   Nw MR in File Fmt
      *
      ***  Check if Customer is OK, For Display
      *
     C                   Eval      @EIN67 = DDCUSTOK
      *
     C                   Endif
      *
      ***  If errors returned
      *
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
                                                                                              CAP086
      * Setup Automatic Authorisation flag on the Valid file                                  CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      MRAUTH = DDAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVMAPY - Retrieve manual repayment
      *****************************************************************
     C     RTVMAPY       BEGSR
      *
     C                   Z-ADD     0             WrkCntrMR         1 0
      *
      ***  Retrieve manual repayment
      *
     C                   CALLB     'LEMAPYRTV'
      *
      ***  Inputs
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
     C                   PARM      'S'           @@RSMD            1            Response mode
     C                   PARM                    DDACTN                         Action Code
     C                   PARM                    FOTRID           20            Front Office ID
     C                   PARM                    DDLNRF                         Midas Loan Ref
     C                   PARM                    DDVALD                         Midas Value Date
     C                   PARM                    DDSEQN                         Midas Sequ. no
     C                   PARM                    DDEVAL                         Midas Expected Date
     C                   PARM                    DDESEQ                         Midas Expected Seq
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014
      *
      ***  Outputs
      *
      ***  (Current) Manual Repayment in file format
     C                   PARM      *blanks       CrMAPYFilFmt
     C                   PARM      *BLANK        DDACTNOK                       OK Actn code
     C                   PARM      *BLANK        DDLNRFOK                       OK Loan ref
     C                   PARM                    DDVALDOK                       OK Value Date
     C                   PARM                    DDSEQNOK                       OK Sequence
     C                   PARM                    DDEVALOK                       OK Expected Date
     C                   PARM                    DDESEQOK                       OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators for display
     C                   PARM                    WrkWHoldTaxRat   11 7          W/hold Tax Rate
     C                   PARM                    WrkExpectTyp      1            Expect Amend Loan tp
     C                   PARM                    WrkPTYP72         1            Expected on type 72
     C                   PARM                    WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM                    WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    WrkCntrMR                      Counter MR
     C                   PARM                    PDLoAmFilFmt                   PD/RE if exists
     C                   PARM                    WrkLnDetails                   Loan details
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         Widx
     C                   PARM                    PRcvParm                                     244636
      *
      ***  Save the settlement details for update (OLDSettlDS)
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
      *
      ***  if Only Warning, Refresh OK Flag
      *
     C                   if        IDX = 0
     c                   eval      Widx = 0
     C                   MOVE      *ALL'Y'       ErrorMAPY
     C                   MOVE      *BLANKS       WMsgidArr
     C                   MOVEL     *BLANKS       WFldNamArr
     C                   MOVEL     *BLANKS       WMsgIdArr
     C                   MOVEL     *BLANKS       WMsgDtaArr
      *
      ***  Seton *IN67 for display (DSP)
     C                   MOVE      WrklnCNUM     CNUMA6            6
     C                   if        CNUMA6 = DDCUST
     C                   MOVE      'Y'           @EIN67                         OK
     C                   Endif
     C                   endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a Manual Repayment on the details screen         *
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      ***  Call program to fill screen fields with data from LOAMSDK
      *
     C                   CALLB     'LEMAPYCVT'
      *
      ***  Inputs
      *
     C                   PARM      *BLANK        RetCodeOut                     Return Code
     C                   PARM                    CrMAPYFilFmt                   MR in File format
     C                   PARM                    PDLoAmFilFmt                   PD/RE in File format
     C                   PARM                    CLE005                         Feature
     C                   PARM                    CLE007                         Feature
     C                   PARM                    CLE023                         Feature
     C                   PARM                    WrkReactFacil                  Reactivated facility
      ***  Outputs
     C                   PARM                    NwMAPYScnFmt                   MR in screen format
     C                   PARM                    WrkProcTypLoan                 Loan Proc Type
     C                   PARM                    WrkOutPrinc      13 0          Outstanding Princ.
     C                   PARM                    WrkRemainInt     13 0          Loan Remaining int.
      *
      ***  Update 'Current' Manual Repayment with the Repayment in Screen Format
      *
     C                   MOVEL     NwMAPYScnFmt  CrMAPYScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - Cancel on details screen
      *****************************************************************
     C     CANC@M        BEGSR
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to the browse screen
      *
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      ***  Determinate protect fields in settlement instructions
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
      *
      ***  Set up payment instructions from manual Repayment
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     MRPAY         ##PAYF                                       CGL029
     C                   MOVEL     MRPAY         FLPAY                                        CGL029
     C                   MOVEL     MRPAYEx       FLPONS                                       CGL029
     C                   MOVEL     MRPSTM        FLPSTM                                       CGL029
     C                   MOVEL     MRCVMR        FLCVMR
     C                   MOVEL     MRSCCY        FLPSCY
     C                   MOVEL     MRICCY        FLIC72
      *
      ***  Set up receive instructions from Manual Repayment
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     MRREC         ##RECF                                       CGL029
     C                   MOVEL     MRREC         FLREC                                        CGL029
     C                   MOVEL     MRRECEx       FLRONS                                       CGL029
     C                   MOVEL     MRRSTM        FLRSTM                                       CGL029
     C                   MOVEL     MRSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     MRREXR        FLREXR                                       CLE031
     C                   Z-ADD     MRPEXR        FLPEXR                                       CLE031
     C                   MOVE      MRREXI        FLREXI                                       CLE031
     C                   MOVE      MRPEXI        FLPEXI                                       CLE031
     C                   MOVE      MRSCCY        FLRSCY                                       CLE031
     C                   MOVE      MRPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
      *
      ***  Settlement instructions input
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
     C                   PARM      *BLANK        ##RTCD           10            Return Code
     C                   PARM      DDACTN        ##ACTN            1            Action code
     C                   PARM      DDLNRF        ##LNRF            6            Loan number
     C                   PARM                    ##PPAY            1            Protect Payment
     C                   PARM                    ##PREC            1            Protect Receive
     C                   PARM      'LEND'        ##CALP            4            Calling program
     C                   PARM      DDSCCY        ##PCCY            3            Payment currency
     C                   PARM      DDSCCY        ##RCCY            3            Receive currency
     C                   PARM      DDCUST        ##CSNM           10            Customer Shortname
     C                   PARM                    ##TTYP            2            Transaction Type
     C                   PARM      *BLANK        ##FFND            1            Federal Funds Ind.
     C                   PARM                    ##BRCA            3            booking Branch
     C                   PARM      MRVDAT        ##DATR            5 0          Receipt Date
     C                   PARM      MRVDAT        ##DATP            5 0          Payment Date
      *
      ***  input Screen Fmt
      *
     C                   PARM                    ##PAYS                         Payment Instructions
     C                   PARM                    ##RECS                         Receipt Instructions
     C                   PARM                    ##FRIS                         FRA/IRS Instructions
      *
      ***  Outputs - File Fmt
      *
     C                   PARM                    ##PAYF                         Payment Instructions
     C                   PARM                    ##RECF                         Receipt Instructions
     C                   PARM                    ##FRIF                         FRA/IRS Instructions
      ***  Function keys
     C                   PARM      *OFF          @INKC             1
      *
     C                   PARM      *OFF          @INKK             1                        MD036070
     C                   PARM      *OFF          @INKL             1
      *
      ***  Save the new settlement details for update
      *
     C     MRPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
     C                   Endif
      *
     C                   MOVE      LSETP         WTYP
     C                   MOVE      LOSAC         WOURS
     C                   MOVE      LTSEN         WTHRS
     C                   MOVE      LFACO         WFACO
     C                   MOVE      NewSettlDS    OldSettlDS
     C                   MOVE      *BLANKS       NewSettlDS
     C                   MOVE      WSETP         WTYP
     C                   MOVEL     WOSAC         WOURS
     C                   MOVEL     WTSEN         WTHRS
     C                   MOVEL     FLBENN        WFACO
      *
      *
      ***  Update Manual Repayment in file format
      *
     C**********         MOVEL     ##PAYF        NMRPAY                                       CGL029
     C**********         MOVEL     ##RECF        NMRREC                                       CGL029
     C                   MOVEL     FLREC         NMRREC                                       CGL029
     C                   MOVEL     FLRONS        NMRRECEx                                     CGL029
     C                   MOVEL     FLRSTM        MRRSTM                                       CGL029
     C                   MOVEL     FLPAY         NMRPAY                                       CGL029
     C                   MOVEL     FLPONS        NMRPAYEx                                     CGL029
     C                   MOVEL     FLPSTM        MRPSTM                                       CGL029
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        MRREXR                                       CLE031
     C                   Z-ADD     FLPEXR        MRPEXR                                       CLE031
     C                   MOVE      FLREXI        MRREXI                                       CLE031
     C                   MOVE      FLPEXI        MRPEXI                                       CLE031
     C                   MOVE      FLRSCY        MRSCCY                                       CLE031
     C                   MOVE      FLPSCY        MRPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     NwMAPYFilFmt  CrMAPYFilFmt
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  CK/12 - Cancel on settlement details
      *
     C     @INKK         CASEQ     *ON           CANC@S                                     MD036070
     C     @INKL         CASEQ     *ON           CANC@S
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
      *
     C                   MOVE      DDACTN        WWACTN            1
      *
      ***  Determine if pay & receive settlement screen will be protected
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     @OPSEL        ORNE      'U'                                                        246778
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ELSE
     c     MRPTYP        Ifeq      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   Else
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   Endif
     C                   Endif
      *
      ***  IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      ***  DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C                   GOTO      EDETP@S
     C                   END
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Defaults settlement details
      *
     C                   IF        MRPTYP = 64 or MRPTYP = 65 or MRPTYP = 68
     C                             or MRPTYP = 71
     C                   MOVEL     WrkLnOLNO     ##CSNM
     C                   else
     C                   MOVEL     MRCNUM        ##CSNM
     C                   Endif
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
     C                   PARM      'LEND'        ##CALP            4            Calling program
     C                   PARM      DDSCCY        ##PCCY            3            Payment currency
     C                   PARM      DDSCCY        ##RCCY            3            Receive currency
     C                   PARM                    ##CSNM           10            Customer shortname
     C                   PARM      *BLANKS       ##TTYP            2            Loan Type
     C                   PARM      *BLANKS       ##FFND            1            Federal Funds Ind.
     C                   PARM                    BQISDA            4            Version of ISDA Rule
     C                   PARM                    BQAGTY            6            Type of ISDA agreeme
     C                   PARM                    BQAGDT            6            Date of ISDA Agreeme
     C                   PARM                    BQAGVV            2            Version ISDA Agreeme
     C                   PARM                    Blank2            2            ISDA Agree. century
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
     C                   PARM                    ##PAYF                         Payment instructions
     C                   PARM                    ##RECF                         Receive instructions
     C                   PARM      *blanks       ##FRIF                         FRA/IRS instructions
      *
      ***  Check details defaulted depending Proc.type
      *
     C                   if        MRPTYP = 66 or MRPTYP = 69 and CLE005 = 'Y'
     C                             or MRPTYP = 72 and CLE005 = 'Y'
      *
      ***  For Participation sold, Payment part
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C                   if        CEU004 = 'Y'
     C                   move      *BLANKS       FLRSCY
     C                   if        DDSCCY = BKEURO
     C                   MOVE      *BLANKS       FLPSCY
     C                   MOVE      WrkLnICCY     FLIC72
     C                   Else
     C                   MOVE      *BLANKS       FLPSCY
     C                   Endif
     C                   Endif
     C                   ELSE                                                                 CLE031
     C                   MOVEL     *BLANKS       FLPSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLRSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLPEXI                                       CLE031
     C                   MOVEL     *BLANKS       FLREXI                                       CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   Reset                   ##RECF
     C                   Move      *BLANKS       FLROBR
      *
      *** if no details, (check FLPSTM) setup with Loan details
      *
     C                   if        FLPSTM = 0  and DDACTN = 'I' and
     C                             WrkDftSettl <> 'N'
     C**********         Movel     LoanPayInst   ##PAYF                                       CGL029
     C                   Movel     LoanPayInst   FLPAY                                        CGL029
     C                   Movel     LoanPayInstEx FLPONS                                       CGL029
     C                   Movel     WrkLnPSTM     FLPSTM                                       CGL029
     C                   movel(p)  WrkLnOSDB     FLPOBR                         Our start Settl Brch
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     WrkLnPSCY     FLPSCY                                       CLE031
     C                   Z-ADD     WrkLnPEXR     FLPEXR                                       CLE031
     C                   MOVEL     WrkLnPEXI     FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   endif
      *
     C                   else
      *
      ***  for loans other than Participation sold,  Receipt Part
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C                   if        CEU004 = 'Y'
     C                   move      *BLANKS       FLPSCY
     C                   MOVE      *blanks       FLIC72
     C                   MOVE      *BLANKS       FLRSCY
     C                   Endif
     C                   ELSE                                                                 CLE031
     C                   MOVEL     *BLANKS       FLPSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLRSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLPEXI                                       CLE031
     C                   MOVEL     *BLANKS       FLREXI                                       CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   Reset                   ##PAYF
     C                   Move      *BLANKS       FLPOBR
      *
      *** if no details, (check FLRSTM) setup with Loan details
      *
     C                   if        FLRSTM = 0  and DDACTN = 'I' and
     C                             WrkDftSettl <> 'N'
     C**********         Movel     LoanRecInst   ##RECF                                       CGL029
     C                   Movel     LoanRecInst   FLREC                                        CGL029
     C                   Movel     LoanRecInstEx FLRONS                                       CGL029
     C                   Movel     WrkLnRSTM     FLRSTM                                       CGL029
     C                   movel(p)  WrkLnOMDB     FLROBR                         Our start Settl Brch
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     WrkLnSCCY     FLRSCY                                       CLE031
     C                   Z-ADD     WrkLnREXR     FLREXR                                       CLE031
     C                   MOVEL     WrkLnREXI     FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   endif
      *
     c                   MOVE      'N'           WrkDftSettl       1
     C                   ENDIF
     C                   Endif
      *
      *
      *** pay/receive branch setup when multi-branching is on.
      *
     C                   If        BGMBIN = 'Y'
     C                   if        FLRSTM <> 05 and ##PREC = 'N'
     C                   move      *BLANKS       FLROBR
     C                   endif
      *
     C                   if        FLPSTM <> 05 and ##PPAY = 'N'
     C                   move      *BLANKS       FLPOBR
     C                   endif
      *
     C                   Endif
      *
      ***  Convert settlement details from file to screen format
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      *
      ***  File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      ***  File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      ***  File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Outputs
      *
      ***  Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      ***  Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      ***  Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDSCCY        #TRCCY                                      CSF011A
     C                   PARM      DDSCCY        #TPCCY                                      CSF011A
      *
     C     EDETP@S       TAG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen
      *****************************************************************
     C     CANC@S        BEGSR
      *
      ***  Return to the details screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      ***  If settlement details invalid
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      ***  Return to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      ***  Continue
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'C'           @SCRN
     C                   ELSE
     C                   MOVEL     'U'           @SCRN
     C                   END
      *
      ***  Update valid Manual Repayment: payment settlement instructions
      *
     C                   MOVEL     FLPAY         MRPAY
     C                   MOVEL     FLPONS        MRPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        MRPSTM                                       CGL029
     C     MRPTYP        IFEQ      66
     C     MRPTYP        OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     MRPTYP        OREQ      72
     C     CLE005        ANDEQ     'Y'
     C                   MOVEL     FLPOBR        MROSBR
     C                   ELSE
     C                   MOVEL     FLROBR        MROSBR
     C                   ENDIF
      *
     C                   MOVEL     FLCVMR        MRCVMR
      *
      ***  Update valid Manual Repayment: receipt settlement instructions
      *
     C                   MOVEL     FLREC         MRREC
     C                   MOVEL     FLRSTM        MRRSTM                                       CGL029
     C                   MOVEL     FLRONS        MRRECEx                                      CGL029
     C                   MOVEL     FLROBR        MRROBR
      *
      ***  Update valid Manual Repayment: settlement currency & 'IN' ccy in field 72
      *
     C                   MOVEL     FLPSCY        MRSCCY
     C                   MOVEL     FLIC72        MRICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        MRREXR                                       CLE031
     C                   Z-ADD     FLPEXR        MRPEXR                                       CLE031
     C                   MOVE      FLREXI        MRREXI                                       CLE031
     C                   MOVE      FLPEXI        MRPEXI                                       CLE031
     C                   MOVE      FLRSCY        MRSCCY                                       CLE031
     C                   MOVE      FLPSCY        MRPSCY                                       CLE031
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
     C                   MOVEL     'LES0611'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LEMAPYDSP'
      *
      ***  Input parameters
      *
     C                   PARM      *BLANKS       RetCodeOut                     Ret code
     C                   PARM                    NwMAPYScnFmt                   Manual Repayment Sc
     C                   PARM                    ErrorMAPY                      Fields in error
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Enabled key & detail fields
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      ***  Enabled function keys
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKQ
      *
      ***  Activated Features/Flags
     C                   PARM                    @EIN67                         Cust Checked
     C                   PARM                    CLE005                         Feature
     C                   PARM      CLE003        @EIN88                         CLE003
     C                   PARM      CLE007        @EIN89                         CLE007
      ***  Details from RTV module
     C                   PARM                    WrkExpAmdtp                    PD/RE Amend Type
     C                   PARM                    WrkRepaytp                     Loan Repay. Type
     C                   PARM                    WrkProcTypLoan                 Loan Proc. Type
      *
      ***  Succesful insert
     C                   PARM                    @LSSQ
     C                   PARM                    @LNRF
     C                   PARM                    @VDAT
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      '0'           @INKQ
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorMAPY
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
      ***  Return to fourth details screen
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
      ***  Else, return to first details screen
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
      ***  Update valid manual repayment: Last action code
      *
     C                   MOVEL     DDACTN        MRCHTP
     C                   MOVEL     DDESEQ        WrkDDESEQ
     C                   MOVEL     DDPASD        WrkDDPASD
      *
      ***  Update valid manual repayment: Front office transaction ID
      *
     C                   MOVEL     @FOTRANSEL    MRFRNT
      *
      *
      ***  Manual Repayments update
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C                   CALLB     'LEMAPYUPD'
      *
      ***  Return code
     C                   PARM                    @RTCD
      *
      ***  New manual repayment in file format
     C                   PARM                    NwMAPYFilFmt
     C                   PARM                    PDLoAmFilFmt                   PD/RE details
     C                   PARM                    WrkLnDetails                   Loan details
      *
      ***  Old settlement details
     C                   PARM                    OldSettlDS
      *
      ***  New settlement details
     C                   PARM                    NewSettlDS
      *
      ***  Pass data
     C                   PARM                    PassDtaDS
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    ErrorMAPY
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Reservation ID                                                          CDE005
     C                   PARM      *BLANKS       ResrvId          10            CDE005
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) =  'LEL0817'                                 AR868380
     C                   ENDIF                                                              AR868380
     C                   END
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     Idx           ORNE      *ZERO
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'
     C     @RTCD         ANDNE     '*RECLCK'                                                AR868380
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     ZATRNKD0      CHAIN     LEIMAPYD0                          99
     C  N99              DELETE    LEIMAPYD0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
      *
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
     C                   MOVEL(P)  NwMAPYScnFmt  IncDATA
     C                   MOVEL(P)  CrMAPYScnFmt  CurDATA
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode       10
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      *
      ***  Incoming Data
     C                   PARM                    IncDATA        2000
      *
      ***  Current Data
     C                   PARM                    CurDATA        2000
      *
     C                   MOVEL(P)  IncDATA       NwMAPYScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupAmend - Setup Settlement Instructions on Amendment       *
      *****************************************************************
      *
     C     SetupAmend    BEGSR
      *
      ***  Conversion of file fields to screen format
      *
     C                   MOVEL     MRREC         FLREC
     C                   MOVEL     MRRECEx       FLRONS                                       CGL029
     C                   MOVEL     MRRSTM        FLRSTM                                       CGL029
     C                   MOVEL     MRSCCY        FLRSCY
      *
     C                   MOVEL     MRPAY         FLPAY
     C                   MOVEL     MRPAYEx       FLPONS                                       CGL029
     C                   MOVEL     MRPSTM        FLPSTM                                       CGL029
     C                   MOVEL     MRCVMR        FLCVMR
     C                   MOVEL     MRSCCY        FLPSCY
     C                   MOVEL     MRICCY        FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     MRREXR        FLREXR                                       CLE031
     C                   Z-ADD     MRPEXR        FLPEXR                                       CLE031
     C                   MOVE      MRREXI        FLREXI                                       CLE031
     C                   MOVE      MRPEXI        FLPEXI                                       CLE031
     C                   MOVE      MRSCCY        FLRSCY                                       CLE031
     C                   MOVE      MRPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Current Settlement Instruction in input format
     C                   PARM      *BLANK        CrPaySttmt
     C                   PARM      *BLANK        CrRecSttmt
     C                   PARM      *BLANK        CrFRASttmt
     C                   PARM      DDSCCY        #TRCCY                                      CSF011A
     C                   PARM      DDSCCY        #TPCCY                                      CSF011A
      *
      ***  If no Payment or Receive instructions have been supplied
      *
     C                   IF            (##PAYS = *blank)
     C                   EVAL      ##PAYS = CrPaySttmt
     C                   ENDIF
      *
     C                   IF            (##RECS = *blank)
     C                   EVAL      ##RECS = CrRecSttmt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *****************************************************************
      *
     C     SDtDtaSubs    BEGSR
      *
      ***  Payment instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      ##PAYS        IncDATA
      *
      ***  Current Data
     C                   PARM      CrPaySttmt    CurDATA
      *
     C                   MOVEL     IncDATA       ##PAYS
      *
      ***  Receipt instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      ##RECS        IncDATA
      *
      ***  Current Data
     C                   PARM      CrRecSttmt    CurDATA
      *
     C                   MOVEL     IncDATA       ##RECS
      *
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
     C                   MOVEL     'LEMAPYRPR'   DBPGM
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
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Customer Lending data
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access Trading Data
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END

     C                   MOVEL     BGMBIN        MBIN              1
      *
      ***  Access General Ledger
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '005'         DBASE                          * DBERR 005 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   IF        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDRETLPD'    DBFILE                         *************
     C                   MOVEL     '006'         DBASE                          * DBERR 006 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - Authorization
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - BackValuation
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - Syndication
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE004
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - other features
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE007
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
     C                   END
      *
      ***  Determine if Customer Lending Enhancements -
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *
      ***  Determine if CEU004 is activated
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
      ***  Determine if CDE001 is activated - Data Export for CCRM limits
      *
     C                   MOVE      'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   END
      *
      ***  Determine if CLE023 is activated - LE enh: History improvement
      *
     C                   MOVE      'N'           CLE023            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   END
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 007                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Key Lists
      *
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
      *
      ***  Message Type
      *
     C                   MOVEL     'LEMAPY'      @MSGTYPE
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
      ***  If there was an error default the offset to 17 (DDACTN = 18)
      *
     C                   ELSE
     C                   EVAL      FldOffset = 17
     C                   ENDIF
     C                   MOVEL     *BLANKS       @RTCD
      *
      ***  Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEMAPYR014
                                                                                              CAP086
      ** Access SAR details file to determine if CAP086 is on.                                CAP086
      ** (Automatic Authorisation)                                                            CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD             6                          CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 008                                                CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
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
