     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid Rollover Instr repair')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIRPR - Invalid Rollover Instr Repair                    *
      *                                                               *
      *  Function:  This function allows invalid Rollover Instructions*
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR702532           Date 13Jan15               *
      *                 MD028338           Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13843           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2579            Date 07Jun04               *
      *                 BUG2665            Date 13May04               *
      *                 BUG827             Date 06May04               *
      *                 CAP084             Date 09Jan04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA067             Date 22Mar04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 WA0021             Date 02Oct03               *
      *                 WA0027             Date 01Oct03               *
      *                 WA0005             Date 19Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 23May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Recompile*
      *             due to changes on LELERIPD and LELERI2PD.         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  BUG2665 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - API wrapper project                                 *
      *           Remove Rollover Status from defn file (recompile)   *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA067 - Misaligned settlement details                       *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  WA0021 - Remove Rollover Status from defn file (recompile)   *
      *  WA0027 - Loan number should be alpha not numeric             *
      *  WA0005 - Recompiled over changed LEVLERLPD                   *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FLEILERIL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEILERID0 : LEILERIX0)
     FLEILERIL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(LO_)
     FLEFCLTL0  IF   E           K DISK
     F                                     PREFIX(F_)
     FLELOAML0  IF   E           K DISK
     F                                     PREFIX(A_)
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDFF)
     F                                     PREFIX(P_)
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELERIR001
 
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(50)
 
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
      ***  Current Loan in File Format CL
     D                                     PREFIX(L)
      *
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Current Loan in File Format CK
     D                                     PREFIX(K)
      *
     D**CUREC****************401    469                                                       TDA067
     D**CUPAY****************544   1102                                                       TDA067
     D  CUREC                415    469                                                       TDA067
     D  CUPAY                558   1102                                                       TDA067
 
     D CrRoScnFmt    E DS                  EXTNAME(LELERIPD)
      * (Current) Rollover Instructions in Screen Format
     D                                     PREFIX(@)
      *
     D NwLnFilFmtCL  E DS                  EXTNAME(LEVLERLPD)
      ***  New Loan in File Format CL
     D**CLREC****************459    527                                                       TDA067
     D**CLPAY****************528   1086                                                       TDA067
     D  CLREC                473    527                                                       TDA067
     D  CLPAY                542   1086                                                       TDA067
      *
     D NwLnFilFmtCK  E DS                  EXTNAME(LEVLERKPD)
      ***  New Loan in File Format CK
     D                                     PREFIX(K_)
     D**CKREC****************401    469                                                       TDA067
     D**CKPAY****************544   1102                                                       TDA067
     D  CKREC                415    469                                                       TDA067
     D  CKPAY                558   1102                                                       TDA067
      *
 
     D NwRoScnFmt    E DS                  EXTNAME(LELERIPD)
      ***  New Rollover in Screen Format
 
     D NwRoScnFmt2   E DS                  EXTNAME(LELERI2PD)
      *** Rollover Instructions Work fields
 
     D LERI_OK       E DS                  EXTNAME(LEELERIPD)
      ***  Error indicators Screen
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D**FLREC******************1     69                                                       TDA067
     D  FLREC                 21     75                                                       TDA067
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D**FLPAY******************1    559                                                       TDA067
     D  FLPAY                 21    565                                                       TDA067
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current
 
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current
 
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** EXTERNAL DS FOR CUSTOMER LENDING ICD
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** EXTERNAL DS FOR API ICD
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ExtData       E DS                  EXTNAME(LELEEXPD)
      * LE (LERI) Extra Data - File (D/B) format
 
      *
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * LE (LERI) Extra Data - File (D/B) format                                              CAP086
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      * 24X7 Data Structure
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)  DTAARA(SDSTAT)
      * SDSTAT Data Structure
 
     D ACCYA           S              3    DIM(12)
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
     D/COPY QWINDSRC,LELERISDTA
 
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D*OLNOAlpha               1      6                                                CSD027 CLE148
     D*OLNONum**               1      6  0                                             CSD027 CLE148
      *                                                                                       CSD027
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('LELERIPD')
 
     D Field           S             10A   INZ('DDACTN')
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** Message type field for chaining to APIDSETPD; defined in terms
      ** of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S             26Z
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
 
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
     D WReDisplay      S              1A
     D WiX             S              3P 0
     D CAP086          S              1A   INZ('N')                                           CAP086
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LELERIR002
 
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
 
      /COPY WNCPYSRC,LELERIR003
 
      * DO SCREEN: BROWSE INVALID ROLLOVER INSTRUCTIONS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      /COPY WNCPYSRC,LELERIR004
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      /COPY WNCPYSRC,LELERIR005
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      /COPY WNCPYSRC,LELERIR006
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
 
      /COPY WNCPYSRC,LELERIR007
 
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
 
      /COPY WNCPYSRC,LELERIR008
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      /COPY WNCPYSRC,LELERIR009
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELERIR010
 
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID ROLLOVER INSTRUCTIONS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'LELERIRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous Loan
     C                   PARM                    @ERRUP            1
      *
     C                   PARM                    CSC011
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'LELERIRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous loan
     C                   PARM                    @ERRUP            1
      *
     C                   PARM                    CSC011
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID LOAN READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwRoScnFmt
      *
      * RESET ERRORS
      *
     C                   EXSR      SrResetErr
      *
      * Retrieve Loan details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      * Make sure Invalid transaction's  details are passed to 'Retreive'
      * module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     LEILERIX0                          99
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C     DDLNRF        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVLOAN
      *
      * If Loan details were retrieved
      * Put the Loan on the main details screen
      *
     C*****LLNRF         IFNE      *ZEROS                                                     CLE148
     C     LLNRF         IFNE      *BLANKS                                                    CLE148
     C     LCHTP         ANDNE     'D'
     C     DDACTN        ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Rollover file (except for the Loan number
      * retrieved above using the front office transaction ID)
      * Access invalid Rollover with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDLNRF        ##DDLNRF          6
     C     ZATRNKX0      CHAIN     LEILERIX0                          99
     C*****LLNRF         IFNE      *ZEROS                                                     CLE148
     C     LLNRF         IFNE      *BLANKS                                                    CLE148
     C     LCHTP         ANDNE     'D'
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDLNRF      DDLNRF
     C                   END
      *
      * Access invalid Loan settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *
      * If Loan details were retrieved and this is an amendment
      *
     C*****LLNRF         IFNE      *ZEROS                                                     CLE148
     C     LLNRF         IFNE      *BLANKS                                                    CLE148
     C     LCHTP         ANDNE     'D'
     C     DDACTN        ANDEQ     'A'
 
      * Data Substitution - Transaction Details
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        SCAN      NwRoScnFmt                             99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   END
     C                   END
 
      * Setup settlement instructions on amend
 
     C                   EXSR      SetupAmend
 
      * Data Substitution - Settlement Details
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        SCAN      ##PAYS                                 99
     C  N99GHSUBS        SCAN      ##RECS                                 99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   END
     C                   END
 
     C                   END
      *
      * If action code, or Loan number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the loans error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID LOAN READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'LEV9010'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     LERI_OK       @EI
      *
      ** Read error messages for Rollover Instructions
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      50
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           LERI_OK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      *  Check if Extended Settlements, Funding details and Mutli ccy
      *  Rollover are required
      *
     C     DDLNRF        IFNE      @PLOAN
     C     DDACTN        ORNE      @PACTN
     C                   EXSR      @CHKLOAN
     C                   ENDIF
                                                                                              TDA067
      ** Reset Settlement Details                                                             TDA067
                                                                                              TDA067
     C                   CLEAR                   ##RECS                                       TDA067
     C                   CLEAR                   ##PAYS                                       TDA067
     C                   CLEAR                   ##RECF                                       TDA067
     C                   CLEAR                   ##PAYF                                       TDA067
      *
      *    Update 'previous' Loan number
     C                   MOVEL     DDLNRF        @PLOAN            6
     C                   MOVEL     DDACTN        @PACTN            1
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed
      * (key fields = action code & loan number; detail fields = rest)
      * (Action code can only be  'A' or 'X')
      * (Can also be Q now)                                                                   CLE030
      *
     C     DDACTN        IFEQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C     DDACTN        IFEQ      'X'                                                        CLE030
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF                                                                CLE030
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'LELERIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ROLLOVER INSTRUCTIONS  (IN SCREEN FORMAT)
     C                   PARM                    NwRoScnFmt
      *
      *
      * FIELDS IN ERROR
     C                   PARM                    LERI_OK
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @EINKQ            1
      *
      * SUCCESFUL INSERT LOAN
     C                   PARM                    @SIDN             6
      *
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
      *
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827
      *
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
      *
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1
      *
      ** Save warning message ids array of this screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      * RESET ERRORS
      *
     C                   EXSR      SrResetErr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve Loan details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVLOAN
      *
      * If action code, loan number are NOT OK and it is not a warning
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE
      * OR REQUIRES RELEASE AND CLE030 IS OFF                                                 CLE030
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'N'                                                        CLE030
      *
      * Update Loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      * If F16 required and F16 taken, go to update
      * If F16 required and F16 not taken, display same screen
      * If F16 not required, continue to settlements screen (review all screens)
      *
     C     @EINKQ        IFEQ      'Y'
      *
     C     @INKQ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   GOTO      EVAL@M
     C                   END
      *
     C                   ELSE
      **  Display settlement details if Discount Loan
      **  or a multi-currency rollover
     C     WDisc         IFEQ      'Y'
     C     DDNCCY        ORNE      *BLANKS
     C     DDNCCYB       ORNE      *BLANKS
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
      *
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      * OR AUTHORISE AND CLE030 IS ON                                                         CLE030
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       LERI_OK
     C                   CLEAR                   NwLnFilFmtCL
     C                   CLEAR                   NwLnFilFmtCK
      *
      * IF AMEND
      * OR AUTHORISE AND CLE030 IS ON                                                         CLE030
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      * Update Loan in File Format
      *
     C                   MOVEL     CrLnFilFmtCL  NwLnFilFmtCL
     C                   MOVEL     CrLnFilFmtCK  NwLnFilFmtCK
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LELERIAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Loan in Screen Format
     C                   PARM                    NwRoScnFmt
      * Current Loan in Screen Format
     C                   PARM                    CrRoScnFmt
      *
      * Current Loan in file format (CL)
     C                   PARM                    CrLnFilFmtCL
      * Current Loan in file format (CK)
     C                   PARM                    CrLnFilFmtCK
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    LERI_OK
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
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      * Validate Rollover Instructions details
      *
     C                   CALLB     'LELERIVAL'
     C                   PARM                    RespMode
      * Transaction information (DS) from source system  (screen format)
     C                   PARM                    NwRoScnFmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    @@FRNT           20
     C                   PARM                    ExtData
      *                                                                                     AR702532
      ** Action Code (Reject transaction)                                                   AR702532
      *                                                                                     AR702532
     C                   PARM      *BLANK        @ACTRV            1                        AR702532
     C                   PARM                    LERI_OK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      * Valid Loans layout (DS) from/to caller
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
                                                                                             BUG2579
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827
                                                                                              BUG827
      * Repayment Exist
     C                   PARM                    @WERLN
     C                   PARM                    @WLNNO
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
     C                   PARM                    WINCY
     C                   PARM                    WPSET
     C                   PARM                    WRLDT1            1
     C                   PARM                    WNCCY1            1
     C                   PARM                    MULTIC
     C                   PARM                    WSett
      * Current Loan
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM      *blank        @@CTU
      *
     C                   EVAL      WReDisplay = *BLANK
      *
      ** If no errors occurred during validation of key fields, check
      ** if there are warnings which have not been displayed yet.
      *
     C                   IF        IDx = *ZERO
 
     C                   Z-ADD     1             WiX
 
     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK
 
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WReDisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C     WReDisplay    OREQ      'Y'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Continue to settlements screen
      *
      **  Display settlement details if Discount Loan
      **  or a multi-currency rollover
     C     WDisc         IFEQ      'Y'
     C     DDNCCY        ORNE      *BLANKS
     C     DDNCCYB       ORNE      *BLANKS
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
      *
     C                   END
      *                                                                                       CAP086
      * Setup Automatic Authorisation flag on the Valid file                                  CAP086
     C     CAP086        IFEQ      'Y'                                                        CAP086
     C                   EVAL      CLAUTH = DDAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVLOAN- RETRIEVE Loan
      *****************************************************************
     C     RTVLOAN       BEGSR
      *
      * Retrieve Loan
      *
     C                   CALLB     'LELERIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Loan Number
     C                   PARM                    DDLNRF
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      *
      * OUTPUTS
      *
      ***  (Current) loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      ***  (Current) loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Loan Number
     C                   PARM      *BLANK        DDLNRFOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A LOAN ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from CloanCL CloanCK
      *
     C                   CALLB     'LELERICVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      * Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      *
      * OUTPUTS
      *
      * Loan in screen format
     C                   PARM                    NwRoScnFmt
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
      *
      *** Update 'Current' Loan with Loan in Screen Format
      *
     C                   MOVEL     NwRoScnFmt    CrRoScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
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
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
      *
      * Fill Our Pay branch and Our Receive branch if blank
      *
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLRSTM        IFEQ      05
     C     KRLBR         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ENDIF
     C                   ENDIF
      *
     C     LPTYP         IFEQ      67
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLPSTM        IFEQ      05
     C     KRLSB         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ENDIF
     C                   ENDIF
      *
      **  If Rollover date is to be removed,
      **  or multi-currency details are to be removed
      **  settlement details must be removed also.
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     CLRLDT        ##DATR                         new RLDT
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
      *
      * Remove Receive Settlements Intructions
      *
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     63
     C     LPTYP         ANDNE     65
     C                   Z-ADD     *ZERO         FLRSTM                                       TDA067
     C                   MOVE      *BLANKS       FLRONS                                       TDA067
     C                   MOVE      *BLANKS       FLREC
     C                   MOVEL     *BLANKS       FLROBR
     C                   MOVEL     *BLANKS       FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   MOVE      *BLANKS       FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
      * Remove Pay Settlements Intructions
      *
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     67
     C                   Z-ADD     *ZERO         FLPSTM                                       TDA067
     C                   MOVE      *BLANKS       FLPONS                                       TDA067
     C                   MOVE      *BLANKS       FLPAY
     C                   MOVEL     *BLANKS       FLPOBR
     C                   MOVEL     *BLANKS       FLCVMR
     C                   MOVEL     *BLANKS       FLPSCY
     C                   MOVEL     *BLANKS       FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   MOVE      *BLANKS       FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C     ##PREC        IFEQ      'Y'
     C     ##PPAY        ANDEQ     'Y'
      * action must be A when ccy details are to be removed to allow
      * same Settlement Screen processing as if normal amendment
     C     WNCCY1        ANDNE     '*'
     C     WRLDT1        ANDNE     '*'
     C                   MOVE      'E'           WWACTN
     C                   ENDIF
      *
      * Rollover date or multi ccy details not removed
     C                   ELSE
      *
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVE      'N'           ##PREC
     C                   ENDIF
     C     LPTYP         IFEQ      67
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up other payment settlement details
      ** For parts sold, pay out in old ccy, receive in new ccy
      ** For the rest, receive in old ccy, pay out in new ccy
      *
     C     WPSET         IFEQ      'Y'
      *
     C     DDNCCYB       IFNE      *BLANKS
     C     WNCCY1        ANDNE     '*'
     C                   MOVE      DDNCCYB       WNCCY             3
     C                   ELSE
     C                   MOVE      DDNCCY        WNCCY
     C                   ENDIF
      *
     C     WSOLD         IFEQ      'Y'
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
      *
     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
      *
     C                   ELSE
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##PCCY
     C                   MOVE      WNCCY         ##RCCY
      *
     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up date of receipt and payment
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
     C     CLRLDT        IFEQ      *ZEROS                                       new RLDT
     C                   Z-ADD     LRLDT         ##DATP                         current RLDT
     C                   Z-ADD     LRLDT         ##DATR                         current RLDT
     C                   ENDIF
     C     WRLDT1        IFNE      '*'
     C     DDRLDTB       ANDNE     *BLANKS
     C     DDRLDT        ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
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
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      * (default if both are blanks)
      *
     C     ##PAYS        IFEQ      *blank
     C     ##RECS        ANDEQ     *blank
      *
      ***  Defaults settlement details for multi-ccy rollover
      *
     C     FLPSTM        IFEQ      *ZERO
     C     FLRSTM        ANDEQ     *ZERO
     C     WPSET         ANDEQ     'Y'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C     DDACTN        ANDEQ     'A'
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      * Payment currency
     C                   PARM                    ##PCCY            3
      *
      * Receive currency
     C                   PARM                    ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      LLTYP         ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
     C                   ENDIF                                                  on invalid file
      *
     C                   ENDIF
      *
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      * (default if both are blanks)
      *
     C     ##PAYS        IFEQ      *blank
     C     ##RECS        ANDEQ     *blank
     C     WNCCY1        OREQ      '*'
     C     WRLDT1        OREQ      '*'
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      ** Screen FRA/IRS Settlement Instruction                                                222373
     C                   PARM      *BLANK        ##FRIS                                       222373
     C                   PARM      ##RCCY        #TRCCY                                      CSF011A
     C                   PARM      ##PCCY        #TPCCY                                      CSF011A
      *
     C                   ENDIF
      *
      * SETTLEMENT INSTRUCTIONS INPUT - VALIDATE
      *
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM      WWACTN        ##ACTN            1
      *
      * Loan number
     C                   PARM      DDLNRF        ##LOAN            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      * Payment currency
     C                   PARM                    ##PCCY            3
      *
      * Receive currency
     C                   PARM                    ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      LLTYP         ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
      *
      * Booking branch
     C                   PARM      LBRCA         ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
     C                   MOVE      DDACTN        WWACTN            1
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ELSE
     C     WRLDT1        IFEQ      '*'
     C     DDRLDTB       OREQ      *BLANKS
     C     DDRLDT        ANDEQ     *BLANKS
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
      *
      ** Discounted loans and parts purchased need receive settlements
      ** only, discounted parts sold needs pay settlements
      *
     C                   ELSE
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ENDIF
     C     LPTYP         IFEQ      67
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  Set up date of receipt for amend.
      **  and date of payment
      *
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     CLRLDT        ##DATR                         new RLDT
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
     C                   ENDIF
      *
      ** Allow rec/pay settlement details for multi-ccy rollover
      *
     C     MULTIC        IFEQ      *ON
     C     DDNCCY        ANDNE     *BLANKS
     C     MULTIC        OREQ      *ON
     C     DDNCCYB       ANDNE     *BLANKS
     C                   MOVE      'Y'           WPSET             1
     C     DDACTN        IFEQ      'A'
     C     WRLDT1        ANDNE     '*'
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
      *
      ** When deleting just the multi-ccy details, for discounted loans
      ** still allow receive settlement input, for others protect both
      ** pay and receive settlements
     C     WNCCY1        IFEQ      '*'
     C     LPTYP         IFNE      63
     C     LPTYP         ANDNE     65
     C     LPTYP         ANDNE     67
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      'E'           WWACTN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C                   GOTO      EDETP@S
     C                   END
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65
     C                   Z-ADD     K_CLRRST      FLRSTM                                       TDA067
     C                   MOVEL     K_CLRRON      FLRONS                                       TDA067
     C                   MOVEL     CKREC         FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      67
     C                   Z-ADD     K_CLRPST      FLPSTM                                       TDA067
     C                   MOVEL     K_CLRPON      FLPONS                                       TDA067
     C                   MOVEL     CKPAY         FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Get receipt settlement from CLOANCK if not blank
      **  Else, get details from CLOANCL
      **  If all details in first screen has been '*'ed
      **  settlement details would be blanked out.
      *
     C     DDACTN        IFEQ      'A'
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65
      *
     C     KRRST         IFNE      *ZERO
      *
      * Set up Receive Instructions from CLOANCK
      *
     C                   Z-ADD     K_CLRRST      FLRSTM                                       TDA067
     C                   MOVEL     K_CLRRON      FLRONS                                       TDA067
     C                   MOVEL     CKREC         FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      * Set up Receive Instructions from CLOANCL
      *
     C                   Z-ADD     CLRSTM        FLRSTM                                       TDA067
     C                   MOVEL     CLRONS        FLRONS                                       TDA067
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     LOMDB         FLROBR
     C                   MOVEL     LSCCY         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LREXR         FLREXR                                       CLE031
     C                   MOVE      LREXI         FLREXI                                       CLE031
     C                   MOVE      LSCCY         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For multi-currency rollover, also allow for pay settle input
      ** Default coming from CLOANCK or CLOANCL
      *
     C     DDACTN        IFEQ      'A'
     C     WPSET         ANDEQ     'Y'
     C     DDACTN        OREQ      'A'
     C     LPTYP         ANDEQ     67
      *
     C     KRPST         IFNE      *ZERO
      *
      * Set up Pay Instructions from CLOANCK
      *
     C                   Z-ADD     K_CLRPST      FLPSTM                                       TDA067
     C                   MOVEL     K_CLRPON      FLPONS                                       TDA067
     C                   MOVEL     CKPAY         FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      * Set up Pay Instructions from CLOANCL
      *
     C                   Z-ADD     CLPSTM        FLPSTM                                       TDA067
     C                   MOVEL     CLPONS        FLPONS                                       TDA067
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     LOMDB         FLPOBR
     C                   MOVEL     LCVMR         FLCVMR
     C                   MOVEL     LSCCY         FLPSCY
     C                   MOVEL     LICCY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LREXR         FLPEXR                                       CLE031
     C                   MOVE      LREXI         FLPEXI                                       CLE031
     C                   MOVE      LSCCY         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * @CHKLOAN - Check if Extended Settlements, Funding details and
      *            Mutli ccy Rollovers are required
      *****************************************************************
     C     @CHKLOAN      BEGSR
      *
     C                   MOVE      ' '           @FUNDING
     C                   MOVE      ' '           @FCXRATE                                    BUG2579
      *
      **  Enable display of Funding Details if Analytical Accounting
      **  module is switched on and loan is directly funded.
      **  or enable display of Funding Details if Revenue Analysis
      **  is switched on.
      *
     C     BGN0ST        IFEQ      'Y'
     C     LFPRC         ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'
      *
     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C     LPTYP         OREQ      61
     C     LPTYP         OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      67
     C     CDE002        ANDEQ     'Y'
     C                   MOVE      'Y'           @FUNDING
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      **  Enable Extended Settlement Details for Discount Loan.
      **  and discounted parts purchased or sold
      *
     C                   MOVE      *BLANKS       WDisc             1
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WDisc
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WSOLD             1
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF
      *
      **  Get facility details.
      *
     C     WFCLT         CHAIN     LEFCLTL0                           85
      *
      **  Enable New currency, New currency amount, Exchange rate,
      **  Exchange rate indicator, Next loan currency repayment
      **  amount will be displayed if Customer Lending Enhancement
      **  Syndications feature is switched on and if it is a
      **  Multi-currency rollover or if EMU Lending Multi currency
      **  rollover feauture is switched on and if loan currency is
      **  an 'In' currency
      *
     C     CEU020        IFEQ      'Y'
     C                   MOVE      LCCY          @CURR
     C                   Z-ADD     61            DBASE
     C                   EXSR      SRCurrDet
     C                   ENDIF
      *
     C     LMCRA         IFEQ      'Y'
     C     CEU020        IFEQ      'Y'
     C                   MOVE      A6INCY        WINCY             1
     C                   Z-ADD     A6TPSD        WTPSD             5 0
     C                   Z-ADD     A6SPRT        WASPRT           13 8
     C                   ENDIF
     C                   MOVE      'Y'           @MULTI
      *
      **  Determine if multi-currency rollover
      **  can be processed.
      **  If Multi Ccy Rollovers, enable the Settlements Screen
     C                   EXSR      SRMCCY
      *
     C     MULTIC        IFEQ      *ON
     C                   MOVEA     F_ALCY        ACCYA
     C     DDACTN        IFEQ      'A'
     C     KNCCY         ORNE      *BLANKS
     C     CEU020        IFEQ      'Y'
     C     KNCCY         ORNE      *BLANKS
     C                   MOVE      'Y'           WSett             1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              BUG827
      ** Determine if New Forward Yield is required                                           BUG827
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C     LPTYP         ANDNE     70                                                         BUG827
     C     LPTYP         ANDNE     71                                                         BUG827
     C     LPTYP         ANDNE     72                                                         BUG827
     C                   MOVE      'Y'           @FYIELD                                      BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           @FYIELD                                      BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if New Facility Exchange Rate is required                                 BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     F_MCCY        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      'Y'           @FCXRATE                                    BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           @FCXRATE                                    BUG2579
     C                   ENDIF                                                               BUG2579
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMCCY  -  Check if Mutli-currency rollover is allowed.       *
      *****************************************************************
     C     SRMCCY        BEGSR
      *
     C                   MOVE      *OFF          MULTIC            1
     C                   MOVE      'N'           @WERLN
      *
      **  Multi-currency rollover processing are allowed
      **  if there are no past due payments outstanding.
      **  and no future-dated loan amendments (except for repay sched)
      *
      **  Access loan amendments file.
      *
     C**********         Z-ADD     LLNRF         ALNRF                                        CLE148
     C                   MOVEL     LLNRF         ALNRF                                        CLE148
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
      *
      **  Check if past due exists.
     C                   MOVE      *ON           WLOGIC            1
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     LLNRF         ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     LLNRF
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C     CLE014        ANDEQ     'N'
     C                   MOVE      *OFF          WLOGIC
      *
      ** If CEU020 is installed, future dated loan amendments will be
      ** allowed if amendment currency is equal to Euro ccy
      *
     C     CEU020        IFEQ      'Y'
     C     A_CCY         ANDEQ     BKEURO
     C                   MOVE      *ON           WLOGIC
     C                   ENDIF
      *
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
     C                   ENDIF
      *
      ** If parts sold, check if original loan has no past due
      ** payments or future dated loan amendments except for 'RE'.
      *
     C**********         Z-ADD     LLNRF         WWLNRF            6 0                        CLE148
     C                   MOVEL     LLNRF         WWLNRF            6                          CLE148
      *
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C     LPTYP         OREQ      69
     C     LPTYP         OREQ      72
      *
     C                   MOVE      LOLNO         ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C*****LOLNO         ANDEQ     A_LNRF                                                     CSD027
     C     ALNRF         ANDEQ     A_LNRF                                                     CSD027
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C*****A_LNRF        ANDEQ     LOLNO                                                      CSD027
     C     A_LNRF        ANDEQ     ALNRF                                                      CSD027
     C     @WERLN        ANDEQ     'N'
      *
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
      *
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
     C                   ENDIF
     C                   MOVE      LOLNO         WOLNO
      *
      ** Multi-ccy rollover allowed indicator of original loan must
      ** be 'Y'.
      *
     C                   MOVE      'A'           WRCDT
     C                   MOVE      LOLNO         WLNRF
     C     WLOAN         CHAIN     CLOAN                              85
     C     *IN85         IFEQ      *OFF
     C     LO_MCRA       ANDEQ     'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      LO_LNRF       @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
      *
     C                   ELSE
     C**********         MOVE      LLNRF         WOLNO             6 0                        CLE148
     C                   MOVE      LLNRF         WOLNO             6                          CLE148
     C                   ENDIF
      *
      ** Check if all the related parts sold has no past due payments
      ** or future dated loan amendments except for 'RE'.
      *
     C*****WOLNO         SETLL     PSOLDFF                                                    CSD027
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C**********         EVAL      OLNONum = WOLNO                                     CSD027 CLE148
     C*****OLNOALpha     SETLL     PSOLDFF                                             CSD027 CLE148
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         SETLL     PSOLDFF                                                    CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
      *
     C     *IN85         DOWEQ     '0'
     C     @WERLN        ANDEQ     'N'
      *
     C     P_LNRF        IFNE      WWLNRF
     C                   MOVE      P_LNRF        ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C     P_LNRF        ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN            1
     C***********        MOVE      A_LNRF        @WLNNO            6 0                        WA0027
     C                   MOVE      A_LNRF        @WLNNO            6                          WA0027
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     P_LNRF
     C     @WERLN        ANDEQ     'N'
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multi-ccy rollover allowed indicator must be 'Y' for all of
      ** the related loan
      *
     C     P_MCRA        IFEQ      'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      P_LNRF        @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
     C                   ENDDO
      *
     C                   MOVE      WLOGIC        MULTIC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrDet - Access Currency Details                           *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
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
     C                   MOVEL     'C'           @SCRN
      *
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     FLPSTM        K_CLRPST                                     TDA067
     C                   MOVEL     FLPONS        K_CLRPON                                     TDA067
     C                   MOVEL     FLPAY         CKPAY
     C                   MOVEL     FLPOBR        K_CLRLSB
     C                   MOVEL     FLCVMR        K_CLRCVM
     C                   MOVEL     FLPSCY        K_CLRPSC
     C                   MOVEL     FLIC72        K_CLRICY
      *
      * UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     FLRSTM        K_CLRRST                                     TDA067
     C                   MOVEL     FLRONS        K_CLRRON                                     TDA067
     C                   MOVEL     FLREC         CKREC
     C                   MOVEL     FLROBR        K_CLRLBR
     C                   MOVEL     FLRSCY        K_CLRRSC
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        K_CLRRSR                                     CLE031
     C                   Z-ADD     FLPEXR        K_CLRPSR                                     CLE031
     C                   MOVE      FLREXI        K_CLRRSI                                     CLE031
     C                   MOVE      FLPEXI        K_CLRPSI                                     CLE031
     C                   MOVE      FLRSCY        K_CLRRSC                                     CLE031
     C                   MOVE      FLPSCY        K_CLRPSC                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, Reset error fields
      *
     C                   EXSR      SRResetErr
      *
      * Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEV9008'     MsgIdArr(1)
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'LELERIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Loan (in screen format)
     C                   PARM                    NwRoScnFmt
      *
      * FIELDS IN ERROR
     C                   PARM                    LERI_OK
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKQ
      *
      * Succesful Insert Loan
     C                   PARM                    @SIDN             6
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
      *
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827
      *
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
      *
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1
      *
      * RESET ERRORS
      *
     C                   EXSR      SrResetErr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
      ** Setup Rollover Instructions support log
 
     C                   CALLB     'LELERILOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    NwRoScnFmt
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LELERI'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     K_CLFRNT      APFOTRANID
     C                   MOVEL     K_CLLNRF      PDealNo
     C                   MOVEL     *BLANKS       PADealNo
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      @RTCD    = '*ERROR'
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDIF
      *
      * Update valid Loan: Loan Number
      *
     C                   MOVEL     DDLNRF        CLLNRF
      *
      * Update valid Loan: Last change type
      *
     C                   EVAL      CLCHTP = 'A'
     C                   EVAL      K_CLCHTP = CLCHTP
      *
      * Update valid Loan: Front Office Transaciton ID
      *
     C                   MOVEL     @FOTRANSEL    CLFRNT
      *
      * Loans Update
      *
     C                   CALLB     'LELERIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DDACTN
     C                   PARM                    NwLnFilFmtCL
     C                   PARM                    NwLnFilFmtCK
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM      *blank        @@CTU             1
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID LE LOAN ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
      *   ROLLBACK data if either of the following is true:                                   CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N'                                              CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkipCommit = 'N'                                          CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Eval      *InU7 = *On                                                CSC022
     C                   Eval      *InU8 = *On                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     ZATRNKD0      CHAIN     LEILERID0                          99
     C  N99              DELETE    LEILERID0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
 
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'LELERI'
     C                   EVAL      KFrntOffID = DDFOTRANID
     C                   EVAL      KTimeStamp = DDTMESTMP
 
     C     KAPLOG        CHAIN     APILOGL0                           99
 
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
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
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
 
     C     SRResetErr    BEGSR
      *
      ** Reset error fields.
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IdX
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdX
      *
      ** Initialise screen fields error indicators.
      *
     C                   MOVE      *ALL'Y'       LERI_OK
 
     C     ESRResetErr   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      NwRoScnFmt    IncDATA        2000
      * Current Data
     C                   PARM      CrRoScnfmt    CurDATA        2000
 
     C                   MOVEL     IncDATA       NwRoScnFmt
 
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
     C                   Z-ADD     KRRST         FLRSTM                                       TDA067
     C                   MOVEL     KRRON         FLRONS                                       TDA067
     C                   MOVEL     CUREC         FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
     C                   Z-ADD     KRPST         FLRSTM                                       TDA067
     C                   MOVEL     KRPON         FLRONS                                       TDA067
     C                   MOVEL     CUPAY         FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   CALLB     'ZASETINCVT'
 
      ** Roll Instr Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
 
      ** Current Settlement Instruction in input format
     C                   PARM      *BLANK        CrPaySttmt
     C                   PARM      *BLANK        CrRecSttmt
     C                   PARM      *BLANK        CrFRASttmt
     C                   PARM      LCCY          #TRCCY                                      CSF011A
     C                   PARM      LCCY          #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the loan (rollover settlements)
 
     C                   IF            (##PAYS = *blank)
     C                   EVAL      ##PAYS = CrPaySttmt
     C                   ENDIF
 
     C                   IF            (##RECS = *blank)
     C                   EVAL      ##RECS = CrRecSttmt
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
     C                   PARM      ##PAYS        IncDATA
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA
 
     C                   MOVEL     IncDATA       ##PAYS
 
      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      ##RECS        IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA
 
     C                   MOVEL     IncDATA       ##RECS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LELERIRPR'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     914           DBASE                          * DBASE 914 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      ** Initialize program name
      *
     C                   MOVEL     'LELERIRPR'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      **  Retrieve general ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     904           DBASE                          * DBERR 904*
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine if Lending Enhancements for BHF-London is active
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      PSARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C     @RTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     905           DBASE                          * DBERR 905*
     C                   MOVEL     'CLE014'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if EMU Lending Multi Currency Rollover - CEU020
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU020'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU020            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CEU020
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 906*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Authorisation
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE002'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE002            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE002
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 907*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Backvaluations
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE003            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE003
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '908'         DBASE                          * DBERR 908*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Others
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE005
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 909*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if BLI Lending Enhancements feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01465'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01465            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           S01465
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '910'         DBASE                          * DBERR 910*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Rollover rate fixing day enhancement - CLE011
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE011'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE011            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE011
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '911'         DBASE                          * DBERR 911*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                             BUG2579
      ** Check if Lending Facility History Improvements - CLE023                             BUG2579
      ** feature is installed                                                                BUG2579
                                                                                             BUG2579
     C                   CALLB     'AOSARDR0'                                                BUG2579
     C                   PARM      *BLANKS       @RTCD                                       BUG2579
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2579
     C                   PARM      'CLE023'      @SARD                                       BUG2579
     C                   PARM                    DSFDY                                       BUG2579
     C     @RTCD         IFEQ      *BLANK                                                    BUG2579
     C                   MOVE      'Y'           CLE023            1                         BUG2579
     C                   ELSE                                                                BUG2579
     C     @RTCD         IFEQ      '*NRF'                                                    BUG2579
     C                   MOVE      'N'           CLE023                                      BUG2579
     C                   ELSE                                                                BUG2579
                                                                                             BUG2579
      ** Database error                                                                      BUG2579
                                                                                             BUG2579
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************ BUG2579
     C                   MOVEL     '915'         DBASE                          * DBERR 915* BUG2579
     C                   MOVEL     @OPTN         DBKEY                          ************ BUG2579
     C                   EXSR      *PSSR                                                     BUG2579
     C                   END                                                                 BUG2579
     C                   END                                                                 BUG2579
 
      ** Access SAR details file to determine if CDE002 is switched on
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDE002'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CDE002            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CDE002 = 'Y'
     C                   Endif
      *
      ** Access Customer Lending ICD via access program
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDCLND        PARM      SDCLND        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         ************
     C                   Z-ADD     912           DBASE                          * DBERR 912*
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '913'         DBASE                          * DBERR 913 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD                                        BUG827
     C                   PARM      '*VERIFY '    @OPTN                                        BUG827
     C                   PARM      'CAS001'      @SARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
      *
      * Key Lists
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
 
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
      *
      **  Key list for LEFCLTL0
      *
     C     WFCLT         KLIST
     C                   KFLD                    LFCUS
     C                   KFLD                    LFTYP
     C                   KFLD                    LFSEQ
      *
      **  Key list for LELOAML0
      *
     C     WLOAM         KLIST
     C**********         KFLD                    ALNRF             6 0                        CLE148
     C                   KFLD                    ALNRF             6                          CLE148
     C                   KFLD                    AVDAT             5 0
     C                   KFLD                    ALASN             3 0
      *
      **  Key list for CLOAN
      *
     C     WLOAN         KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1
      *
      ** Message Type
     C                   MOVEL     'LELERI'      @MSGTYPE
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LELERIR011
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 916                                               CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
 
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
