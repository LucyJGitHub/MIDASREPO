     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CCT Ordering Customer-Header')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVORCS02  - Validate CCT Header Ordering Customer           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034176           Date 21Apr15               *
      *                 MD000091           Date 06May13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25973           Date 17Sep09               *
      *                 BUG25914           Date 09Sep09               *
      *                 BUG24555           Date 26Jun09               *
      *                 BUG24404           Date 19Apr09               *
      *                 BUG24625           Date 26Jun09               *
      *                 BUG24669           Date 01Jul09               *
      *                 BUG24471           Date 25Jun09               *
      *                 BUG24710           Date 02Jul09               *
      *                 BUG24470           Date 23Jun09               *
      *                 BUG24639           Date 30Jun09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15280A          Date 09Nov07               *
      *                 BUG15250           Date 09Nov07               *
      *                 BUG15279           Date 08Nov07               *
      *                 BUG15010A          Date 25Oct07               *
      *                 BUG15248           Date 05Nov07               *
      *                 BUG15261           Date 07Nov07               *
      *                 BUG15102           Date 24Oct07               *
      *                 BUG15065           Date 21Oct07               *
      *                 BUG15010           Date 17Oct07               *
      *                 BUG15029           Date 16Oct07               *
      *                 CSW207A            Date 22Jun07               *
      *                 CSW207             Date 22Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11467           Date 10Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221538             Date 01Apr04               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188775             Date 17Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034176 - Customer not found displayed in Ordering Customer *
      *             upon Enquire                                      *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG25914 - System should not accept fifth line in ordering   *
      *             customer if line 1 doesn't start with a "/" or    *
      *             valid 4 chars code word                           *
      *  BUG24555 - Code word DRLC-EMPL-CUST with blank issuing       *
      *             authority was not rejected                        *
      *  BUG24404 - 5th line was not rejected when the 1st line of    *
      *             Ordering Customer Field does not start with a     *
      *             SLASH                                             *
      *  BUG24625 - SWIFT Address is rejected in details section      *
      *  BUG24669 - Invalid Character did not accept                  *
      *  BUG24471 - Warning Message did not appear for IBAN with      *
      *             invalid ISO Code.                                 *
      *  BUG24710 - "/" followed by valid retail account is rejected  *
      *             by the system                                     *
      *  BUG24470 - For Incoming CCTD the Ordering Customer field1    *
      *  BUG24639 - Warning message for Iban validation should only   *
      *             be done if the 1st Line starts with XXNN format   *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15280A - Error on IBAN account in ordering customer       *
      *  BUG15250 - Incorrect :50: format in MT102                    *
      *  BUG15279 -  Error exist in pay currency                      *
      *  BUG15010A - Fix CFT032/CSW207 errors -Reopen                 *
      *  BUG15248 - Strip account line of prefix '/'.                 *
      *  BUG15261 -  System accepts blank input in ordering customer  *
      *  BUG15102 - Incorrect PAccount when no '/' entered in         *
      *             Ordering Customer.                                *
      *  BUG15065 - Error for SOSE identification type                *
      *  BUG15010 - CFT032 / CSW207 Errors                            *
      *  BUG15029 - Warning message displayed was "ERROR - Message    *
      *             not found                                         *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  BUG11467 - Errors in Ordering customer valdidation           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221538 - Expansion of field details.                         *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  188775 - Does not look up ordering customer ledger balance   *
      *           correctly if not a full GL account                  *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FFT102DL1  IF   E           K DISK    PREFIX(C)
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
      ***External*data*structure*for*Currency*standing*data                     188775
     D*SDCURR********E DS                  EXTNAME(SDCURRPD)                    188775
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for access programs (Long)                     188775
     D DSSDY1        E DS                  EXTNAME(DSSDY)                       188775
     D N_Sdy1        E                     ExtFld(SDY1)                         188775
     D N_Sdy2        E                     ExtFld(SDY2)                         188775
     D N_Sdy3        E                     ExtFld(SDY3)                         188775
     D N_Sdy4        E                     ExtFld(SDY4)                         188775
                                                                                188775
      ** External data structure for Nostro details
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)                                  221538
      ** Array of lower case letters                                                        BUG11467
     D lows            S              1    DIM(26) CTDATA PERRCD(26)                        BUG11467
      ** Array of upper case letters                                                        BUG11467
     D ups             S              1    DIM(26) CTDATA PERRCD(26)                        BUG11467
      ** Array for ordering bank                                                            BUG11467
     D TA              S              1    DIM(35)                                          BUG11467
     D S_ACCNT       E DS                  EXTNAME(ACCNTAB)                                BUG15010A
     D                                     PREFIX(S_)                                      BUG15010A
     D A_DSSDY       E DS                  EXTNAME(DSSDY)                                  BUG15010A
     D                                     PREFIX(A_)                                      BUG15010A
     D N_SDNOST      E DS                  EXTNAME(SDNOSTPD)                               BUG15010A
     D                                     PREFIX(N_)                                      BUG15010A
     D C_SDCUST      E DS                  EXTNAME(SDCUSTPD)                               BUG15010A
     D                                     PREFIX(C_)                                      BUG15010A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
     D CFT004          S              1    INZ(' ')
     D CSW207          S              1    INZ(' ')                                           CSW207
     D P@IBAN          S             34A                                                    BUG24639
                                                                                              CSW207
      ** Parameters for FT001000                                                              CSW207
     D PRtnCde         S              7A                                                      CSW207
     D PAccount        S             34A                                                      CSW207
     D PAcType         S              1A                                                      CSW207
     D PCust           S              6A                                                      CSW207
     D PNonActH        S             10A                                                      CSW207
     D PNetwork        S              6A                                                      CSW207
     D PMsgTyp         S              3A                                                      CSW207
     D PMsgTag         S              5A                                                      CSW207
     D PBrch           S              3A                                                      CSW207
     D PCountry        S              2A                                                      CSW207
     D PCurr           S              3A                                                      CSW207
     D PNostro         S              2A                                                      CSW207
     D P50FmtF1        S             35A                                                      CSW207
     D P50FmtF2        S             35A                                                      CSW207
     D P50FmtF3        S             35A                                                      CSW207
     D P50FmtF4        S             35A                                                      CSW207
     D P50FmtF5        S             35A                                                      CSW207
     D PVType          S              4A                                                      CSW207
     D PMsgID          S              7A                                                      CSW207
     D PModI           S              2A                                                      CSW207
     D POMFlag         S              1A                                                      CSW207
     D POut1           S             35A                                                      CSW207
     D POut2           S             35A                                                      CSW207
     D POut3           S             35A                                                      CSW207
     D POut4           S             35A                                                      CSW207
     D POut5           S             35A                                                      CSW207
                                                                                              CSW207
     D WCNUM           S              6A                                                      CSW207
     D WACOD           S             10A                                                      CSW207
     D WACSQ           S              2A                                                      CSW207
     D PTCUS1          S            105A                                                      CSW207
     D PTCUS2          S            140A                                                      CSW207
     D PTCUS3          S            105A                                                    MD034176
                                                                                              CSW207
      ***Numeric*version*of*Transfer*Amount                                     188775
     D*wamt************S             15P 0                                      188775
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
      ** Alphabetic array                                                                   BUG24639
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)                        BUG24639
      *                                                                                     BUG24639
      ** Numeric array                                                                      BUG24639
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)                        BUG24639
     D Char            S             26A   Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')                BUG24669
     D Num             S             10A   Inz('0123456789')                                BUG24669
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      PCUSTTH  = *Blanks
     C                   Eval      PType  = *Blanks
     C                   Clear                   Accnt
 
     C                   Eval      GenOkFlag2 = 'Y'
     C                   Eval      OkOcus1 = 'Y'
     C                   Eval      OkOcus2 = 'Y'
     C                   Eval      OkOcus3 = 'Y'
     C                   Eval      OkOcus4 = 'Y'
 
     C                   If        PTOCUS1 <> *Blanks
     C                             Or (CSW207 = 'Y' And (PTOCUS2 <> *Blanks                  CSW207A
     C                                Or PTOCUS3 <> *Blanks                                  CSW207A
     C                                Or PTOCUS4 <> *Blanks                                  CSW207A
     C                                Or PTOCUS5 <> *Blanks))                                CSW207A
     C                   Exsr      SrAcct
      *
     C**********         If        %Subst(PTOCUS1:1:1) = '/' And                   BUG24470 BUG24710
     C**********                   PTOCUS2 = *blanks                               BUG24470 BUG24710
     C**********         Eval      GenOkFlag2 = 'N'                                BUG24470 BUG24710
     C**********         Eval      Idx = Idx + 1                                   BUG24470 BUG24710
     C**********         Eval      RetCodeIn = 'Error'                             BUG24470 BUG24710
     C**********         Eval      FldNamXAr(Idx) = DDSName                        BUG24470 BUG24710
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2152'                       BUG24470 BUG24710
     C**********         Endif                                                     BUG24470 BUG24710
      **********                                                                   BUG24470 BUG24710
     C                   Eval      PTCUS1= PTOCUS2 + PTOCUS3 + PTOCUS4                        CSW207
     C                   Eval      PTCUS2= PTOCUS2 + PTOCUS3 + PTOCUS4 + PTOCUS5              CSW207
     C                   EVAL      PTCUS3 = PTOCUS3 + PTOCUS4 + PTOCUS5                     MD034176
     C                   IF        (%SUBST(PTOCUS1:1:1) <> '/' AND                          MD034176
     C                             PTCUS2 <> *BLANKS) OR                                    MD034176
     C                             (%SUBST(PTOCUS1:1:1) = '/' AND                           MD034176
     C                             PTCUS3 <> *BLANKS)                                       MD034176
     C                   EVAL      PTYPE = *BLANKS                                          MD034176
     C                   ENDIF                                                              MD034176
     C                   If        PCCtTYp = 'BI'
     C                   EXSR      SrSwft                                                     CSW207
     C                   If        PTYPE = '*NOSTRO' OR
     C                             PTYPE = '*RETAIL' OR
     C                             PTYPE = '*LEDGER'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0217'
     C                   ELse
     C                   If        PTYPE = '*CUSTNO' OR
     C**********                   PTYPE = '*SWIFT ' OR                              221538 BUG15010
     C                             PTYPE = '*SHNAME'
     C**********         If        PTOCUS2 = *blanks And PTOCUS3 = *blanks And         221538 CSW207
     C**********                   PTOCUS4 = *blanks                                   221538 CSW207
     C**********         If        (PTCUS1 = *Blanks                                 CSW207 BUG15010
     C**********                   And CSW207 = 'N')                                 CSW207 BUG15010
     C**********                   Or (PTCUS2 = *Blanks                              CSW207 BUG15010
     C**********                   And CSW207 = 'Y')                                 CSW207 BUG15010
     C                   EVAL      PCUSTTH = 'C'                                              221538
     C                   If        PTYPE = '*SHNAME'                                          221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   Movel     BBCOLC        PCountry                                   BUG15010
     C                   If        %Subst(PTOCUS1:1:1) = '/'                                BUG15010
     C                   Movel(P)  BBCUST        PTOCUS2                                    BUG15010
     C                   Else                                                               BUG15010
     C                   Movel(P)  BBCUST        PTOCUS1                                      221538
     C                   Endif                                                              BUG15010
     C                   Endif                                                                221538
     C**********         Endif                                                       221538 BUG15010
      *                                                                                       221538
     C**********         If        PTOCUS2 = *blanks And PTOCUS3 = *blanks And         221538 CSW207
     C**********                   PTOCUS4 = *blanks And PTYPE = '*SWIFT '             221538 CSW207
     C**********         If        (PTCUS1 = *Blanks                                 CSW207 BUG15010
     C**********                   And PTYPE = '*SWIFT'                              CSW207 BUG15010
     C**********                   And CSW207 = 'N')                                 CSW207 BUG15010
     C**********                   Or (PTCUS2 = *Blanks                              CSW207 BUG15010
     C**********                   And PTYPE = '*SWIFT'                              CSW207 BUG15010
     C**********                   And CSW207 = 'Y')                                 CSW207 BUG15010
     C                   If        (PTOCUS2 = *blanks And                                   BUG15010
     C                              PTOCUS3 = *blanks And                                   BUG15010
     C                              PTOCUS4 = *blanks And                                   BUG15010
     C                              PTOCUS5 = *blanks And                                   BUG15010
     C                              PTYPE = '*SWIFT ' ) or                                  BUG15010
     C                             (%Subst(PTOCUS1:1:1) = '/' and                           BUG15010
     C                              PTOCUS2 <> *blanks And                                  BUG15010
     C                              PTOCUS3 = *blanks And                                   BUG15010
     C                              PTOCUS4 = *blanks And                                   BUG15010
     C                              PTOCUS5 = *blanks And                                   BUG15010
     C                              PTYPE = '*SWIFT ')                                      BUG15010
     C                   EVAL      PCUSTTH = 'S'                                              221538
     C                   Endif                                                                221538
      *                                                                                       221538
     C                   If        PTOCUS2 <> *Blanks
     C                   Eval      OKoCus2 = 'N'
     C                   Eval      Idx             =   Idx+1                                BUG11467
     C                   Eval      FldNamXAr(Idx) = 'PTOCUS2'                   CAP084
     C                   Eval      MsgIdXAr(Idx) = 'RFV0307'                                BUG11467
     C                   Eval      RetCodeIn = 'Error'                                      BUG11467
     C                   Endif
     C                   IF        PTOCUS3 <> *Blanks
     C                   Eval      OKoCus3 = 'N'
     C                   Eval      Idx             =   Idx+1                                BUG11467
     C                   Eval      FldNamXAr(Idx) = 'PTOCUS3'                   CAP084
     C                   Eval      MsgIdXAr(Idx) = 'RFV0307'                                BUG11467
     C                   Eval      RetCodeIn = 'Error'                                      BUG11467
     C                   Endif
     C                   If        PTOCUS4 <> *Blanks
     C                   Eval      OKoCus4 = 'N'
     C                   Eval      Idx             =   Idx+1                                BUG11467
     C                   Eval      FldNamXAr(Idx) = 'PTOCUS4'                   CAP084
     C                   Eval      MsgIdXAr(Idx) = 'RFV0307'                                BUG11467
     C                   Eval      RetCodeIn = 'Error'                                      BUG11467
     C                   Endif
     C**********         If        PTOCUS5 <> *Blanks And CSW207 = 'Y'               CSW207 BUG15010
     C                   If        PTOCUS5 <> *Blanks                                       BUG15010
     C                   Eval      OKoCus5 = 'N'                                              CSW207
     C                   Eval      FldNamXAr(Idx) = 'PTOCUS5'                                 CSW207
     C                   Endif                                                                CSW207
     C*****              If        OkOcus2 = 'N' OR OkOcus3 = 'N' OR                        BUG11467
     C*****                        OkOcus4 = 'N'                                            BUG11467
     C*****              Eval      Idx = Idx + 1                                            BUG11467
     C*****              Eval      RetCodeIn = 'Error'                                      BUG11467
     C****************** Eval      FldNamXAr(Idx) = DDSName                     CAP084
     C*****              Eval      MsgIdXAr(Idx) = 'RFV0307'                                BUG11467
     C*****              Endif                                                              BUG11467
     C                   Endif
     C                   Endif
     C                   Endif
 
      ** Type is BO
     C                   If        PCCttyp = 'BO'
     C                   EXSR      SrSwft                                                     CSW207
     C                   If        PTYPE = '*NOSTRO' OR
     C                             PTYPE = '*RETAIL' OR
     C                             PTYPE = '*SHNAME' OR
     C                             PTYPE = '*LEDGER' OR
     C                             PTYPE = '*CUSTNO' OR
     C                             PTYPE = '*SWIFT ' OR                                       221538
     C                             PTYPE = 'IBAN'
      *                                                                                       221538
     C                   If        PTYPE = '*CUSTNO' OR                                       221538
     C                             PTYPE = '*SHNAME'                                          221538
     C                   If        PTOCUS2 = *blanks And PTOCUS3 = *blanks And                221538
     C                             PTOCUS4 = *blanks                                          221538
     C                   EVAL      PCUSTTH = 'C'                                              221538
     C                   If        PTYPE = '*SHNAME'                                          221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   Movel     BBCOLC        PCountry                                   BUG15010
     C                   If        %Subst(PTOCUS1:1:1) = '/'                                BUG15010
     C                   Movel(P)  BBCUST        PTOCUS2                                    BUG15010
     C                   Else                                                               BUG15010
     C                   Movel(P)  BBCUST        PTOCUS1                                      221538
     C                   Endif                                                              BUG15010
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
      *                                                                                       221538
     C**********         If        PTOCUS2 = *blanks And PTOCUS3 = *blanks And         221538 CSW207
     C**********                   PTOCUS4 = *blanks And PTYPE = '*SWIFT '             221538 CSW207
     C                   If        (PTCUS1 = *Blanks                                          CSW207
     C                             And PTYPE = '*SWIFT'                                       CSW207
     C                             And CSW207 = 'N')                                          CSW207
     C                             Or (PTCUS2 = *Blanks                                       CSW207
     C                             And PTYPE = '*SWIFT'                                       CSW207
     C                             And CSW207 = 'Y')                                          CSW207
     C                   EVAL      PCUSTTH = 'S'                                              221538
     C                   Endif                                                                221538
      *                                                                                       221538
 
      ** Payment ccy must be the same as the account ccy
 
     C                   Move      'N'           NotPCCY           1
 
     C     PCCTID        Setll     FT102DL1
     C     PCCTID        Reade     FT102DL1                               01
 
     C                   Dow       *IN01 = *OFF
 
     C                   If        CPayCCY <> %SUBST(DSSDY:1:3) and
     C                             PTYPE = '*NOSTRO' or
     C                             CPayCCY <> %SUBST(DSSDY:8:3) and
     C                             PTYPE = 'IBAN' or
     C                             CPayCCY <> %SUBST(DSSDY:8:3) and
     C                             PTYPE = '*LEDGER' or
     C                             CPayCCY <> %SUBST(DSSDY:8:3) and
     C                             PTYPE = '*RETAIL'
     C                   Move      'Y'           NotPCCY
     C                   Endif
 
     C     PCCTID        Reade     FT102DL1                               01
     C                   Enddo
 
     C                   If        NotPCCY = 'Y'
     C                   Eval      GenOkFlag2 = 'W'
     C                   Eval      WIx = WIx + 1
     C                   Eval      WFldNmXAr(WIx) = DDSName
     C                   Eval      WMsgIdXAr(WIx) = 'RFV0289'
     C                   Endif
 
     C**************     Exsr      SrSffd                                       188775
 
      ** Valid Account
      *                                                                                       221538
     C**********         If        PTOCUS2 = *blank And                                221538 CSW207
     C**********                   PTOCUS3 = *blank And                                221538 CSW207
     C**********                   PTOCUS4 = *blank                                    221538 CSW207
     C**********         If        (PTCUS1 = *Blanks                                 CSW207 BUG15248
     C**********                   And CSW207 = 'N')                                 CSW207 BUG15248
     C**********                   Or (PTCUS2 = *Blanks                              CSW207 BUG15248
     C**********                   And CSW207 = 'Y')                                 CSW207 BUG15248
     C**********         IF        PTOCUS2 = *BLANKS                               BUG15248 BUG15279
     C**********                   AND PTOCUS3 = *BLANKS                           BUG15248 BUG15279
     C**********                   AND PTOCUS4 = *BLANKS                           BUG15248 BUG15279
     C**********                   AND CSW207 = 'N'                                BUG15248 BUG15279
     C**********                   OR PTOCUS2 <> *BLANKS                           BUG15248 BUG15279
     C**********                   AND CSW207 = 'Y'                                BUG15248 BUG15279
     C                   If        (PTCUS1 = *Blanks                                        BUG15279
     C                             And CSW207 = 'N')                                        BUG15279
     C                             Or (PTCUS2 = *Blanks                                     BUG15279
     C                             And CSW207 = 'Y')                                        BUG15279
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PCUSTTH = 'I'
     C                   When      PTYPE = '*LEDGER'
      *                                                                                     BUG15279
     C**********         If        %Subst(PTOCUS1:1:1) <> '/'                      BUG15279 BUG24710
     C                   Eval      PCUSTTH = 'G'
     C**********         EndIf                                                     BUG15279 BUG24710
      *                                                                                     BUG15279
     C                   When      PTYPE = '*NOSTRO'
      *                                                                                     BUG15279
     C**********         If        %Subst(PTOCUS1:1:1) <> '/'                      BUG15279 BUG24710
     C                   Eval      PCUSTTH = 'F'
     C**********         EndIf                                                     BUG15279 BUG24710
      *                                                                                     BUG15279
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PCUSTTH = 'R'
     C                   Endsl
 
     C                   Endif                                                                221538
     C                   Endif
     C                   Endif
      *
      ** Ensure that the second line does not contain /
      *
     C     '/'           SCAN      PToCus2       ScanPos2          2 0
      *
     C                   If        ScanPos2 <> 0
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0348'
     C                   Eval      FldNamXAr(Idx)  =  'PToCus2'
     C                   Eval      OkOCus2 = 'N'
     C                   Endif
      *
      ** Ensure that the third line does not contain /
      *
     C     '/'           SCAN      PToCus3       ScanPos3          2 0
      *
     C                   If        ScanPos3 <> 0
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0349'
     C                   Eval      FldNamXAr(Idx)  =  'PToCus3'
     C                   Eval      OkOCus3 = 'N'
     C                   Endif
      *
      ** Ensure that the forth line does not contain /
      *
     C     '/'           SCAN      PToCus4       ScanPos4          2 0
      *
     C                   If        ScanPos4 <> 0
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0350'
     C                   Eval      FldNamXAr(Idx)  =  'PToCus4'
     C                   Eval      OkOCus4 = 'N'
     C                   Endif
      ************************************************                                CSW207 CSW207A
      ***Ensure that the fifth line does not contain /                                CSW207 CSW207A
      ************************************************                                CSW207 CSW207A
     C**********         If        CSW207 = 'Y'                                       CSW207 CSW207A
     C*****'/'**         SCAN      PToCus5       ScanPos5          2 0                CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
     C**********         If        ScanPos5 <> 0                                      CSW207 CSW207A
     C**********         Eval      Idx             =   Idx+1                          CSW207 CSW207A
     C**********         Eval      RetCodeIn       =   'Error'                        CSW207 CSW207A
     C**********         Eval      MsgIdXAr(Idx)   =  'RFV0350'                       CSW207 CSW207A
     C**********         Eval      FldNamXAr(Idx)  =  'PToCus5'                       CSW207 CSW207A
     C**********         Eval      OkOCus5 = 'N'                                      CSW207 CSW207A
     C**********         Endif                                                        CSW207 CSW207A
     C**********         Endif                                                        CSW207 CSW207A
 
     C                   Endif
 
      * Now validate that all data entered is OK for SWIFT
 
      *                                                                                     BUG24669
      ** Not applicable for incoming IBAN transactions                                      BUG24669
      *                                                                                     BUG24669
     C                   If        PCCTTYP = 'BI'                       And                 BUG24669
     C                             %SubSt(PToCus1:1:1) = '/'            And                 BUG24669
     C                             %Check(Char:%SubSt(PToCus1:2:2)) = 0 And                 BUG24669
     C                             %Check(Num:%SubSt(PToCus1:4:2)) = 0                      BUG24669
                                                                                            BUG24669
     C                   Else                                                               BUG24669
                                                                                            BUG24669
     C                   If        PToCus1 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PToCus1       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      OkOcus1 = 'N'
     C                   Endif
     C                   Endif
     C                   EndIf                                                              BUG24669
 
     C                   If        PToCus2 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PToCus2       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PTOCUS2'                  CAP084
     C                   Eval      OkOcus2 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PToCus3 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PToCus3       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PTOCUS3'                  CAP084
     C                   Eval      OkOcus3 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PToCus4 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PToCus4       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PTOCUS4'                  CAP084
     C                   Eval      OkOcus4 = 'N'
     C                   Endif
     C                   Endif
                                                                                              CSW207
     C**********         If        PToCus5 <> *Blanks And CSW207 = 'Y'               CSW207 BUG15010
     C                   If        PToCus5 <> *Blanks                                       BUG15010
     C                   CallB     'FTVSFTX01'                                                CSW207
     C                   Parm                    RetCdeIn         10                          CSW207
     C                   Parm      PToCus5       Swift_Text       50                          CSW207
     C                   If        RetCdeIn = 'Error'                                         CSW207
     C                   Eval      Idx            =   Idx+1                                   CSW207
     C                   Eval      RetCodeIn      =   'Error'                                 CSW207
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                CSW207
     C                   Eval      FldNamXAr(Idx) =  'PTOCUS5'                                CSW207
     C                   Eval      OkOcus5 = 'N'                                              CSW207
     C                   Endif                                                                CSW207
     C                   Endif                                                                CSW207
      *                                                                                     BUG15250
     C                   If        PCUSTTH = ' ' And PTYPE = '*CUSTNO'                      BUG15250
     C                   Eval      PCUSTTH = 'C'                                            BUG15250
     C                   Endif                                                              BUG15250
      *                                                                                     BUG15250
     C                   If        PCUSTTH = ' ' And PTYPE = '*SWIFT'                       BUG15250
     C                   Eval      PCUSTTH = 'S'                                            BUG15250
     C                   Endif                                                              BUG15250
      *                                                                                       221538
     C                   If        PCUSTTH = ' ' And PTOCUS1 <> *blanks Or                    221538
     C                             PCUSTTH = ' ' And PTOCUS2 <> *blanks Or                    221538
     C                             PCUSTTH = ' ' And PTOCUS3 <> *blanks Or                    221538
     C                             PCUSTTH = ' ' And PTOCUS4 <> *blanks                       221538
     C                             Or PCUSTTH = ' ' And PTOCUS5 <> *blanks                  BUG15010
     C**********                   Or (PCUSTTH = ' ' And PTOCUS5 <> *blanks          CSW207 BUG15010
     C**********                       And CSW207 = 'Y')                             CSW207 BUG15010
     C                   Eval      PCUSTTH = 'A'                                              221538
     C                   If        %Subst(PTOCUS1:1:1) = '/' And                            BUG24710
     C                             PTOCUS2 = *blanks                                        BUG24710
     C                   Eval      GenOkFlag2 = 'N'                                         BUG24710
     C                   Eval      Idx = Idx + 1                                            BUG24710
     C                   Eval      RetCodeIn = 'Error'                                      BUG24710
     C                   Eval      FldNamXAr(Idx) = DDSName                                 BUG24710
     C                   Eval      MsgIdXAr(Idx) = 'FTM2152'                                BUG24710
     C                   Endif                                                              BUG24710
      *                                                                                     BUG24710
     C                   Endif                                                                221538
     C                   IF        PToCus1 = *BLANKS and                                    BUG15261
     C                             PToCus2 <> *BLANKS OR                                    BUG15261
     C                             PToCus1 = *BLANKS and                                    BUG15261
     C                             PToCus3 <> *BLANKS OR                                    BUG15261
     C                             PToCus1 = *BLANKS and                                    BUG15261
     C                             PToCus4 <> *BLANKS OR                                    BUG15261
     C                             PToCus1 = *BLANKS and                                    BUG15261
     C                             PToCus5 <> *BLANKS OR                                    BUG15261
     C                             PToCus2 = *BLANKS and                                    BUG15261
     C                             PToCus3 <> *BLANKS OR                                    BUG15261
     C                             PToCus2 = *BLANKS and                                    BUG15261
     C                             PToCus4 <> *BLANKS OR                                    BUG15261
     C                             PToCus2 = *BLANKS and                                    BUG15261
     C                             PToCus5 <> *BLANKS OR                                    BUG15261
     C                             PToCus3 = *BLANKS and                                    BUG15261
     C                             PToCus4 <> *BLANKS OR                                    BUG15261
     C                             PToCus3 = *BLANKS and                                    BUG15261
     C                             PToCus5 <> *BLANKS OR                                    BUG15261
     C                             PToCus4 = *BLANKS and                                    BUG15261
     C                             PToCus5 <> *BLANKS                                       BUG15261
     C                   Eval      Idx = Idx + 1                                            BUG15261
     C                   Eval      RetCodeIn = 'Error'                                      BUG15261
     C                   Eval      FldNamXAr(Idx) = DDSName                                 BUG15261
     C                   Eval      MsgIdXAr(Idx) = 'RFV0076'                                BUG15261
     C                   Eval      OkOcus1 = 'N'                                            BUG15261
     C                   Eval      OkOcus2 = 'N'                                            BUG15261
     C                   Eval      OkOcus3 = 'N'                                            BUG15261
     C                   Eval      OkOcus4 = 'N'                                            BUG15261
     C                   Eval      OkOcus5 = 'N'                                            BUG15261
     C                   ENDIF                                                              BUG15261
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcct - Checks for valid account                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     SrAcct        Begsr
 
     C                   Eval      PAcType = *Blanks                                          CSW207
     C                   Eval      PTYPE = *Blanks
     C                   IF        %SUBST(PTOCUS1:1:1) = '/'                                BUG15248
     C                   EVAL      PACCT = %SUBST(PTOCUS1:2)                                BUG15248
     C                   ELSE                                                               BUG15248
     C                   Eval      PACCT = PTOCUS1
     C                   ENDIF                                                              BUG15248
 
      ** Validate Account
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       PRTCD             7            B:Return code
     C                   Parm                    PTYPE             7            I:A/c ID
     C                   Parm                    PACCT                          I:A/c Currency
     C                   Parm                    DSSDY                          I:A/c code
 
      *                                                                                     BUG11467
      *  If shortname or customer number were entered in lower case,                        BUG11467
      *  the return code will be '*NRF' and the input will be                               BUG11467
      *  accepted as free format name and address.  If *NRF is returned                     BUG11467
      *  try changing the first line to upper case and repeat the                           BUG11467
      *  validation.                                                                        BUG11467
      *                                                                                     BUG11467
     C     PTYPE         IFEQ      '*NRF   '                                                BUG11467
     C                   Eval      PTYPE = *Blanks                                          BUG11467
     C                   Movea     PACCT         TA                                         BUG11467
     C                   Z-add     1             I                 2 0                      BUG11467
     C                   Do        35            I                                          BUG11467
     C                   Z-add     1             yy                2 0                      BUG11467
     C     TA(I)         Lookup    lows(yy)                               88                BUG11467
     C     *IN88         Ifeq      *ON                                                      BUG11467
     C                   Move      ups(yy)       TA(I)                                      BUG11467
     C                   EndIf                                                              BUG11467
     C                   EndDo                                                              BUG11467
     C                   Movea     TA            PACCT                                      BUG11467
      ** Validate Account a second time                                                     BUG11467
     C                   CallB     'AOACCTV1'                                               BUG11467
     C                   Parm      *Blanks       PRTCD             7            B:Return codBUG11467
     C                   Parm                    PTYPE             7            I:A/c ID    BUG11467
     C                   Parm                    PACCT                          I:A/c CurrenBUG11467
     C                   Parm                    DSSDY                          I:A/c code  BUG11467
      *                                                                                     BUG11467
      *  If valid this time, move the upper case version to the screen field.               BUG11467
      *                                                                                     BUG11467
     C     PTYPE         IFNE      '*NRF   '                                                BUG11467
     C                   Move      Pacct         PTOCUS1                                    BUG11467
     C                   EndIf                                                              BUG11467
     C                   EndIf                                                              BUG11467
     C                   Select
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      N@FMT = DSSDY
                                                                                188775
     C                   Movel     A7ACSN        A7ACSNChar        2            188775
     C                   Eval      PACCT = A7BRCD + A7CUST + A7CYCD +           188775
     C                                     A7ACCD + A7ACSNChar                  188775
                                                                                188775
     C                   CallB     'AOACCTV1'                                   188775
     C                   Parm      *Blanks       XRTCD             7            188775
     C                   Parm                    XTYPE             7            188775
     C                   Parm                    PACCT                          188775
     C                   Parm                    DSSDY1                         188775
                                                                                188775
     C                   Eval      ACCNT = DSSDY1                               188775
                                                                                188775
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      ACCNT = DSSDY
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      ACCNT = DSSDY
      *                                                                                     BUG15250
     C**********         When      PTYPE = '*NRF' and CSW207 = 'Y'                 BUG15250 BUG25914
     C                   When      (PTYPE = '*NRF' and CSW207 = 'Y'                         BUG25914
     C                             AND PCCTTYP = 'BO')                                      BUG25914
     C                             OR (PTYPE = '*NRF' AND CSW207 = 'Y'                      BUG25914
     C                             AND PCCTTYP = 'BI' AND                                   BUG25914
     C                             %SUBST(PTOCUS1:1:1) = '/')                               BUG25914
      *                                                                                     BUG15250
      ** Try Second Line if contains a valid customer or swift ID                           BUG15250
      *                                                                                     BUG15250
     C                   Eval      PACCT = PTOCUS2                                          BUG15250
      *                                                                                     BUG15250
      ** Validate Account                                                                   BUG15250
      *                                                                                     BUG15250
     C                   CallB     'AOACCTV1'                                               BUG15250
     C                   Parm      *Blanks       PRTCD             7                        BUG15250
     C                   Parm                    PTYPE             7                        BUG15250
     C                   Parm                    PACCT                                      BUG15250
     C                   Parm                    DSSDY                                      BUG15250
      *                                                                                     BUG24404
     C                   When      (CSW207 = 'Y' and PTOCUS1 <> *Blanks                     BUG24404
     C                             and PTOCUS5 <> *Blanks                                   BUG24404
     C                             and %SUBST(PTOCUS1:1:1) <> '/')                          BUG24404
      *                                                                                     BUG24404
     C                   IF        %SUBST(PTOCUS5:1:2) <> '1/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '2/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '3/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '4/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '5/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '6/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '7/' AND                          BUG24404
     C                             %SUBST(PTOCUS5:1:2) <> '8/' AND                          BUG24404
      *                                                                                     BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'ARNU/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'CCPT/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'CUST/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'DRLC/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'EMPL/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'NIDN/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'SOSE/' AND                       BUG24404
     C                             %SUBST(PTOCUS1:1:5) <> 'TXID/'                           BUG24404
      *                                                                                     BUG24404
     C                   Eval      Idx = Idx + 1                                            BUG24404
     C                   Eval      MsgIdXAr(Idx) = 'FTM7112'                                BUG24404
     C                   Eval      RetCodeIn = 'Error'                                      BUG24404
     C                   Eval      OkOcus1 = 'N'                                            BUG24404
     C                   Eval      GenOkFlag2 = 'N'                                         BUG24404
     C                   Eval      FldNamXAr(Idx) = 'PTOCUS1'                               BUG24404
     C                   Endif                                                              BUG24404
      *                                                                                     BUG24404
     C                   Endsl
 
      ** CFT004 is switched on
     C                   If        CFT004 = 'Y' and
     C                             PCCTTYP = 'BO'
     C                             Or CSW207 = 'Y'                                           CSW207A
     C                   If        PTYPE <> '*NOSTRO'  and
     C                             PTYPE <> '*RETAIL'  and
     C                             PTYPE <> '*SHNAME'  and
     C                             PTYPE <> '*CUSTNO'
     C                             and PTYPE <> '*LEDGER'
     C                             and PTYPE <> '*SWIFT'                                    BUG15250
 
     C                   If        %SUBST(PTOCUS1:1:1) = '/'
     C                   Eval      PACCT = %SUBST(PTOCUS1:2)
     C                   Else                                                              BUG15280A
     C                   Eval      PACCT = PTOCUS1                                         BUG15280A
     C                   Endif
 
     C                   MOVEL     PACCT         PIBAN                                      BUG24639
     C                   CALL      'AOIBANR3'                                               BUG24639
     C                   PARM                    PRTCD                                      BUG24639
     C                   PARM                    PIBAN            47                        BUG24639
     C                   PARM                    POWITH           47                        BUG24639
     C     P@IBAN        PARM                    PONOBL           34                        BUG24639
                                                                                            BUG24639
     C     1             SUBST     P@IBAN:1      BCTY1             1                        BUG24639
     C     1             SUBST     P@IBAN:2      BCTY2             1                        BUG24639
     C     1             SUBST     P@IBAN:3      BDGT1             1                        BUG24639
     C     1             SUBST     P@IBAN:4      BDGT2             1                        BUG24639
     C     BCTY1         LOOKUP    ALPH                                   94                BUG24639
     C   94BCTY2         LOOKUP    ALPH                                   94                BUG24639
     C   94BDGT1         LOOKUP    NUMC                                   94                BUG24639
     C   94BDGT2         LOOKUP    NUMC                                   94                BUG24639
      *                                                                                     BUG24639
      ** Check that it is a valid IBAN                                                      BUG24639
     C                   IF        *IN94 = *ON                                              BUG24639
      *                                                                                     BUG24639
     C                   CallB     'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm                    PACCT            35
     C     ACCNT         Parm      ACCNT         Dssdy
 
     C                   If        PRTCD = *Blanks
     C                   Eval      PActype = 'I'                                             CSW207A
     C                   Move      CNUM          WCNUM                                       CSW207A
     C                   Move      ACOD          WACOD                                       CSW207A
     C                   Move      ACSQ          WACSQ                                       CSW207A
     C                   Eval      PAccount = ACBRCA + WCNUM + CCY                           CSW207A
     C                                  + WACOD + WACSQ                                      CSW207A
     C**********         Eval      PCountry = %Subst(PACCT:1:2)                     CSW207A BUG15010
     C                   Eval      PCUST    = WCNUM                                         BUG15010
     C                   Eval      PTYPE = 'IBAN'
                                                                                             CSW207A
     C                   Else                                                                CSW207A
      *                                                                                      CSW207A
      ** Check if external IBAN                                                              CSW207A
      *                                                                                      CSW207A
     C                   Call      'AOIBANR5'                                                CSW207A
     C                   Parm      *Blanks       PRTCD                                       CSW207A
     C                   Parm                    PACCT                                       CSW207A
     C                   If        PRTCD = *Blanks                                           CSW207A
     C**********         Call      'AOIBANR4'                                       CSW207A BUG15010
     C**********         Parm      *Blanks       PRTCD                              CSW207A BUG15010
     C**********         Parm      '*KEY'        POPTN                              CSW207A BUG15010
     C**********         Parm                    PACCT                              CSW207A BUG15010
     C*****ACCNT         Parm      ACCNT         DSSDY                              CSW207A BUG15010
     C**********         If        PRTCD = *Blanks                                  CSW207A BUG15010
     C**********         Eval      PActype = 'I'                                    CSW207A BUG15010
     C**********         Move      CNUM          WCNUM                              CSW207A BUG15010
     C**********         Move      ACOD          WACOD                              CSW207A BUG15010
     C**********         Move      ACSQ          WACSQ                              CSW207A BUG15010
     C**********         Eval      PAccount = ACBRCA + WCNUM + CCY                  CSW207A BUG15010
     C**********                        + WACOD + WACSQ                             CSW207A BUG15010
     C**********         Eval      PCountry = %Subst(PACCT:1:2)                     CSW207A BUG15010
     C**********         EndIf                                                      CSW207A BUG15010
     C                   Else                                                               BUG24471
                                                                                            BUG24471
     C                   SELECT                                                             BUG24471
                                                                                            BUG24471
      *                                                                                     BUG24471
      ** Invalid ISO country code                                                           BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      1'                                        BUG24471
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24471
     C                   ADD       1             WIX                                        BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2400'                               BUG24471
      *                                                                                     BUG24471
      ** Invalid BBAN length                                                                BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      2'                                        BUG24471
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24471
     C                   ADD       1             WIX                                        BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2401'                               BUG24471
      *                                                                                     BUG24471
      ** Invalid character                                                                  BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      3'                                        BUG24471
      *                                                                                     BUG24669
      ** Not applicable for outgoing IBAN transactions                                      BUG24669
      *                                                                                     BUG24669
     C                   If        PCCTTYP = 'BO'                       And                 BUG24669
     C                             %SubSt(PToCus1:1:1) = '/'            And                 BUG24669
     C                             %Check(Char:%SubSt(PToCus1:2:2)) = 0 And                 BUG24669
     C                             %Check(Num:%SubSt(PToCus1:4:2)) = 0                      BUG24669
                                                                                            BUG24669
     C                   Else                                                               BUG24669
                                                                                            BUG24669
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24471
     C                   ADD       1             WIX                                        BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2402'                               BUG24471
     C                   EndIf                                                              BUG24669
      *                                                                                     BUG24471
      ** Invalid IBAN length                                                                BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      4'                                        BUG24471
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24471
     C                   ADD       1             WIX                                        BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2403'                               BUG24471
      *                                                                                     BUG24471
      ** Invalid check digit                                                                BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      5'                                        BUG24471
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24471
     C                   ADD       1             WIX                                        BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2404'                               BUG24471
      *                                                                                     BUG24471
      ** Other/non-specific warning                                                         BUG24471
      *                                                                                     BUG24471
     C                   Other                                                              BUG24471
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24471
     C                   ADD       1             WIX                                        BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2405'                               BUG24471
                                                                                            BUG24471
     C                   Endsl                                                              BUG24471
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   Endif
     C                   Endif                                                              BUG24639
     C                   Endif
     C                   Endif
 
     C                   Endsr
 
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      *  SrSwft - Perform ordering customer validation for field :50F *                       CSW207
      *                                                               *                       CSW207
      *  Called by: Main processing                                   *                       CSW207
      *                                                               *                       CSW207
      *  Calls: FT001000                                              *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
     C     SrSwft        Begsr                                                                CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
      *                                                                                       CSW207
      ** Clear/initialize parameter fields                                                    CSW207
      *                                                                                       CSW207
     C                   EVAL      PRtnCde  = *BLANKS                                         CSW207
     C**********         EVAL      PAccount = PACCT                                   CSW207 CSW207A
     C                   EVAL      PCurr   = PCCTCCY                                          CSW207
     C                   Select                                                               CSW207
      *                                                                                       CSW207
     C                   When      PTYPE = '*CUSTNO'                                          CSW207
     C                   Eval      PAcType = 'C'                                              CSW207
     C                   EVAL      PAccount = *BLANKS                                         CSW207
     C                   If        %Subst(PTOCUS1:1:1) <> '/'                                 CSW207
     C                   EVAL      PCust = PTOCUS1                                            CSW207
     C                   Else                                                                 CSW207
     C                   EVAL      PCust = %Subst(PTOCUS1:2:6)                                CSW207
     C                   EndIf                                                                CSW207
     C                   EVAL      PBrch    = BBBRCD                                          CSW207
      *                                                                                       CSW207
     C                   When      PTYPE = '*SHNAME'                                          CSW207
     C                   Eval      PAcType = 'C'                                              CSW207
     C                   EVAL      PAccount = *BLANKS                                         CSW207
     C                   EVAL      PCust = PTOCUS1                                            CSW207
     C                   EVAL      PBrch    = BBBRCD                                          CSW207
      *                                                                                       CSW207
     C                   When      PTYPE = '*SWIFT '                                          CSW207
     C                   Eval      PAcType = 'S'                                              CSW207
     C                   EVAL      PAccount = *BLANKS                                         CSW207
     C                   EVAL      PCust = PTOCUS1                                            CSW207
     C                   EVAL      PBrch    = BBBRCD                                          CSW207
      *                                                                                       CSW207
     C                   When      PTYPE = '*NOSTRO'                                          CSW207
     C                   Eval      PAcType = 'N'                                              CSW207
     C                   EVAL      PCust = A7CUST                                             CSW207
     C                   EVAL      PBrch  = A7BRCD                                            CSW207
      *                                                                                       CSW207
     C                   When      PTYPE = '*RETAIL'                                          CSW207
     C                   Eval      PAcType = 'R'                                              CSW207
     C                   MOVE      CNUM          WCNUM                                        CSW207
     C                   MOVE      ACOD          WACOD                                        CSW207
     C                   MOVE      ACSQ          WACSQ                                        CSW207
     C                   Eval      PAccount = ACBRCA + WCNUM + CCY                            CSW207
     C                                  + WACOD + WACSQ                                       CSW207
     C                   Eval      PAcType = ATYP                                             CSW207
     C                   MOVEL     CNUM          PCust                                        CSW207
     C                   EVAL      PBrch    = ACBRCA                                          CSW207
      *                                                                                       CSW207
     C                   When      PTYPE = '*LEDGER'                                          CSW207
     C                   Eval      PAcType = 'G'                                              CSW207
     C                   IF        %Subst(PTOCUS1:1:1) = '/'                                BUG15102
     C                   Eval      PAccount = %Subst(PTOCUS1:2:34)                            CSW207
     C                   ELSE                                                               BUG15102
     C                   Eval      PAccount = PTOCUS1                                       BUG15102
     C                   ENDIF                                                              BUG15102
     C                   EVAL      PBrch    = ACBRCA                                          CSW207
                                                                                            BUG15065
     C                   Other                                                              BUG15065
      *                                                                                     BUG15065
      ** Swift address                                                                      BUG15065
      *                                                                                     BUG15065
     C                   If        PCUSTTH = ' ' And PTOCUS1 <> *blanks                     BUG15065
     C                             Or PCUSTTH = ' ' And PTOCUS2 <> *blanks                  BUG15065
     C                             Or PCUSTTH = ' ' And PTOCUS3 <> *blanks                  BUG15065
     C                             Or PCUSTTH = ' ' And PTOCUS4 <> *blanks                  BUG15065
     C                             Or PCUSTTH = ' ' And PTOCUS5 <> *blanks                  BUG15065
     C                   Eval      PAcType = 'A'                                            BUG15065
     C                   EndIf                                                              BUG15065
                                                                                            BUG15065
     C                   Endsl                                                                CSW207
      *                                                                                       CSW207
     C                   EVAL       PNonActH = *BLANKS                                        CSW207
     C                   EVAL       PNetwork = 'SWIFT'                                        CSW207
     C                   EVAL       PMsgTyp  = '102'                                          CSW207
     C                   EVAL       PMsgTag  = ':50F:'                                        CSW207
     C**********         EVAL       PCountry = BBCNCZ                                CSW207 BUG15010
     C**********         EVAL       PNostro  = A7NONB                               CSW207 BUG15010A
     C                   EVAL       P50FmtF1 = PTOCUS1                                        CSW207
     C                   EVAL       P50FmtF2 = PTOCUS2                                        CSW207
     C                   EVAL       P50FmtF3 = PTOCUS3                                        CSW207
     C                   EVAL       P50FmtF4 = PTOCUS4                                        CSW207
     C                   EVAL       P50FmtF5 = PTOCUS5                                        CSW207
     C                   EVAL       PVType   = 'TRAN'                                         CSW207
     C                   EVAL       PMsgID   = *BLANKS                                        CSW207
     C                   EVAL       PAcType  = PCUSTTH                                      BUG15010
     C**********         EVAL       PModI    = *BLANKS                               CSW207 BUG15010
     C**********         EVAL       PModI    = 'FT'                                BUG15010 BUG25973
     C                   EVAL       PModI    = PCCTTYP                                      BUG25973
     C                   EVAL       PBrch    = PBRCA                                        BUG15010
     C                   EVAL       PCurr    = PCCTCCY                                      BUG15010
     C                   EVAL       POMFlag  = *BLANKS                                        CSW207
      *                                                                                     BUG24625
     C                   IF        ((PTOCUS2 = *BLANKS And PTOCUS3 = *BLANKS And            BUG24625
     C                              PTOCUS4 = *BLANKS And PTOCUS5 = *BLANKS And             BUG24625
     C                              %SUBST(PTOCUS1:1:1) <> '/'                              BUG24625
     C                              And PTYPE = '*SWIFT ') or                               BUG24625
     C                             (PTOCUS3 = *BLANKS And                                   BUG24625
     C                              PTOCUS4 = *BLANKS And PTOCUS5 = *BLANKS And             BUG24625
     C                              %SUBST(PTOCUS1:1:1) =  '/')                             BUG24625
     C                              And PTYPE = '*SWIFT ')                                  BUG24625
     C                   EVAL      PCUSTTH = 'S'                                            BUG24625
     C                   ENDIF                                                              BUG24625
                                                                                           BUG15010A
      ** Get Country of Location parameter for FT001000                                    BUG15010A
      ** for Incoming must be the Destination, for Outgoing must be the Sender             BUG15010A
     C                   Exsr      GetCountry                                              BUG15010A
                                                                                           BUG15010A
      ** Get Nostro parameter from Sender or Receiver Correspondent if <> Blanks           BUG15010A
     C                   If        PSNDCOR <> *Blanks Or                                   BUG15010A
     C                             PRCVCOR <> *Blanks                                      BUG15010A
     C                   Exsr      GetNostro                                               BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000            BUG15010A
     C                   If        PCUSTTH = 'C'                                           BUG15010A
     C                   Movel     P50FmtF1      PCust                                     BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is IBAN, Retail or Ledger, set Account parameter of FT001000        BUG15010A
     C                   If        PCUSTTH = 'I' Or                                        BUG15010A
     C                             PCUSTTH = 'P' Or                                        BUG15010A
     C                             PCUSTTH = 'R'                                           BUG15010A
     C                   Exsr      GetAccount                                              BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                              CSW207
     C                   EVAL      PAcType = PCUSTTH                                       BUG15010A
     C                   CALL      'FT001000'    PLSWFT                                       CSW207
                                                                                              CSW207
     C                   IF        PRtnCde = '*ERROR'                                         CSW207
                                                                                            BUG15010
     C                   If        PCCttyp = 'BI' and PMsgID = 'FTS0055'                    BUG15010
     C                   Eval      POMFlag = 'W'                                            BUG15010
     C                   EndIf                                                              BUG15010
                                                                                              CSW207
     C                   IF        POMFlag = 'E'                                              CSW207
     C                   Eval      Idx = Idx + 1                                              CSW207
     C                   Eval      MsgIdXAr(Idx) = PMsgID                                     CSW207
     C                   Eval      RetCodeIn = 'Error'                                        CSW207
     C                   Eval      OKOCUS1 = 'N'                                              CSW207
     C                   Eval      OKOCUS2 = 'N'                                              CSW207
     C                   Eval      OKOCUS3 = 'N'                                              CSW207
     C                   Eval      OKOCUS4 = 'N'                                              CSW207
     C                   Eval      OKOCUS5 = 'N'                                              CSW207
     C**********         Eval      FldNamXAr(Idx) = PTOCUS1                           CSW207 CSW207A
     C                   Eval      FldNamXAr(Idx) = 'PTOCUS1'                                CSW207A
     C                   Eval      GenOkFlag2 = 'N'                                         BUG24555
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        POMFlag = 'W'                                              CSW207
     C                   Eval      WIx = WIx + 1                                              CSW207
     C                   Eval      WMsgIdXAr(WIx) = PMsgID                                    CSW207
     C                   Eval      RetCodeIn = 'Error'                                        CSW207
     C                   Eval      OKOCUS1 = 'W'                                              CSW207
     C                   Eval      OKOCUS2 = 'W'                                              CSW207
     C                   Eval      OKOCUS3 = 'W'                                              CSW207
     C                   Eval      OKOCUS4 = 'W'                                              CSW207
     C                   Eval      OKOCUS5 = 'W'                                              CSW207
     C**********         Eval      WFldNmXAr(WIx) = PTOCUS1                          CSW207 BUG15010
     C                   Eval      WFldNmXAr(WIx) = 'PTOCUS1'                               BUG15010
     C                   Eval      GenOkFlag2 = 'W'                                         BUG24555
                                                                                            BUG15029
     C                   If        PMsgID = 'FTS0053'                                       BUG15029
     C**********         Eval      WMsgDtXAr(WIx) =PNetwork                        BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PNetwork))                             MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(PNetwork)                 MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                       BUG15029
     C**********         Eval      WMsgDtXAr(WIx) =PMsgTag                         BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PMsgTag))                              MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(PMsgTag)                  MD000091
     C                   Endif                                                              BUG15029
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   Endsr                                                                CSW207
                                                                                              CSW207
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSffd - Checks for sufficient funds                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOCURRR0, ZALIGN                                       *
      *                                                               *
      *****************************************************************
      *******************                                                       188775
     C*****SrSffd********Begsr                                                  188775
      *******************                                                       188775
     C*******************Eval      ZALIGNok = 'Y'                               188775
     C*******************Eval      ZFIELD = *Blanks                             188775
     C*******************Eval      ZADEC = *Zero                                188775
     C*******************Eval      ZADIG = *Zero                                188775
     C*******************Eval      wamt = *Zero                                 188775
      *******************                                                       188775
      ***Currency*must*be valid on the system                                   188775
     C*******************Call      'AOCURRR0'                                   188775
     C*******************Parm      *Blanks       PRTCD             7            188775
     C*******************Parm      '*KEY  '      POPTN             7            188775
     C*******************Parm      PCCTCCY       PCCY              3            188775
     C*****SDCURR********Parm      SDCURR        DSSDY                          188775
      *******************                                                       188775
     C*******************If        PRTCD = *Blanks                              188775
     C*******************Move (P)  PCCTAMT       ZFIELD                         188775
     C*******************Eval      ZADIG = 15 - A6NBDP                          188775
      *******************                                                       188775
     C*******************CallB     'ZALIGN'                                     188775
     C*******************Parm                    ZALIGNok          1            188775
     C*******************Parm                    ZFIELD           16            188775
     C*******************Parm      A6NBDP        ZADEC             1 0          188775
     C*******************Parm                    ZADIG             2 0          188775
      *******************                                                       188775
     C*******************If        ZALIGNok = 'Y'                               188775
     C*******************Move      ZFIELD        wamt                           188775
     C*******************IF        PTYPE <> '*NRF'                              188775
     C*******************If        LDBL - wamt < 0                              188775
     C*******************Eval      GenOkFlag2 = 'W'                             188775
     C*******************Eval      WIx = WIx + 1                                188775
     C*******************Eval      WFldNmXAr(WIx) = DDSName                     188775
     C*******************Eval      WMsgIdXAr(WIx) = 'RFV0141'                   188775
     C*******************Endif                                                  188775
     C*******************Endif                                                  188775
     C*******************Endif                                                  188775
     C*******************Endif                                                  188775
      *******************                                                       188775
     C*******************Endsr                                                  188775
      *****************************************************************
      /EJECT
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetNostro - Get Nostro parameter for FT001000                *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetNostro     BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   If        PSNDCOR <> *Blanks                                      BUG15010A
     C                   Movel     PSNDCOR       ParmStr                                   BUG15010A
     C                   Else                                                              BUG15010A
     C                   Movel     PRCVCOR       ParmStr                                   BUG15010A
     C                   Endif                                                             BUG15010A
                                                                                           BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type             7                       BUG15010A
     C                   Parm                    ParmStr          35                       BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *BLANKS                                         BUG15010A
                                                                                           BUG15010A
     C                   Select                                                            BUG15010A
     C                   When      @Type = '*NOSTRO'                                       BUG15010A
     C                   Eval      N_SDNOST = A_DSSDY                                      BUG15010A
     C                   Movel     N_A7NONB      PNostro                                   BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*RETAIL'                                       BUG15010A
     C                             Or @Type = '*LEDGER'                                    BUG15010A
     C                   Eval      S_ACCNT = A_DSSDY                                       BUG15010A
     C                   Move      S_CNUM        PCUST2                                    BUG15010A
     C                   Movel     S_CCY         PCYCD                                     BUG15010A
     C                   Move      S_ACOD        PACCD                                     BUG15010A
     C                   Move      S_ACSQ        PACSN                                     BUG15010A
     C                   Movel     S_BRCA        PBRCD                                     BUG15010A
                                                                                           BUG15010A
     C                   CALLB     'AONOSTR0'                                              BUG15010A
     C                   PARM      *BLANKS       @RTCD                                     BUG15010A
     C                   PARM      '*KEY   '     POPTN             7                       BUG15010A
     C                   PARM                    PCUST2            6                       BUG15010A
     C                   PARM                    PCYCD             3                       BUG15010A
     C                   PARM                    PACCD            10                       BUG15010A
     C                   PARM                    PACSN             2                       BUG15010A
     C                   PARM      *BLANKS       PNONB             2                       BUG15010A
     C                   PARM                    PBRCD             3                       BUG15010A
     C                   PARM      *BLANKS       PCSSN            10                       BUG15010A
     C                   PARM      *BLANKS       PPNOI             1                       BUG15010A
     C     N_SDNOST      PARM      *BLANKS       DSFDY                                     BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *Blanks                                         BUG15010A
     C                   Movel     N_A7NONB      PNostro                                   BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   EndSl                                                             BUG15010A
                                                                                           BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   ENDSR                                                             BUG15010A
      *****************************************************************                    BUG15010A
     C/EJECT                                                                               BUG15010A
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetCountry - Get Country of Location Parameter for FT001000  *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetCountry    BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   Movel     *Blanks       PCountry                                  BUG15010A
     C                   Movel     *Blanks       PCust                                     BUG15010A
     C                   Movel     *Blanks       PAccount                                  BUG15010A
     C                   Movel     *Blanks       PNostro                                   BUG15010A
      *                                                                                    BUG15010A
      ** get Country of location                                                           BUG15010A
      ** for Incoming must be the Destination, for Outgoing must be the Sender             BUG15010A
     C                   If        PCCTTYP = 'BI'                                          BUG15010A
     C                   EVAL      ParmStr = PSNDCOR                                       BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = PCCTDST                                       BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type                                     BUG15010A
     C                   Parm                    ParmStr                                   BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *BLANKS                                         BUG15010A
                                                                                           BUG15010A
     C                   Select                                                            BUG15010A
     C                   When      @Type = '*RETAIL'                                       BUG15010A
     C                             Or @Type = '*LEDGER'                                    BUG15010A
     C                             Or @Type = '*NOSTRO'                                    BUG15010A
                                                                                           BUG15010A
     C                   If        @Type = '*NOSTRO'                                       BUG15010A
     C                   Eval      N_SDNOST = A_DSSDY                                      BUG15010A
     C                   Movel     N_A7CUST      @KEY1            10                       BUG15010A
     C                   Movel     N_A7NONB      PNostro                                   BUG15010A
     C                   Else                                                              BUG15010A
     C                   Eval      S_ACCNT = A_DSSDY                                       BUG15010A
     C                   Move      S_CNUM        WCNUM                                     BUG15010A
     C                   Movel     WCNUM         @KEY1                                     BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   CALL      'AOCUSTR0'                                              BUG15010A
     C                   PARM      *BLANKS       @RTCD                                     BUG15010A
     C                   PARM      '*KEY   '     @OPTN                                     BUG15010A
     C                   PARM                    @KEY1                                     BUG15010A
     C                   PARM      *BLANKS       @KYST             7                       BUG15010A
     C     C_SDCUST      PARM      *BLANKS       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
      ** if valid customer capture Country of location as Parameter to FT001000            BUG15010A
     C                   IF        @RTCD = *BLANKS                                         BUG15010A
     C                   Movel     C_BBCOLC      PCountry                                  BUG15010A
     C                   ENDIF                                                             BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*CUSTNO'                                       BUG15010A
     C                             Or @Type = '*SHNAME'                                    BUG15010A
     C                   Eval      C_SDCUST = A_DSSDY                                      BUG15010A
     C                   Movel     C_BBCOLC      PCountry                                  BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*SWIFT'                                        BUG15010A
     C                   Eval      PCountry = %Subst(ParmStr:5:2)                          BUG15010A
                                                                                           BUG15010A
     C                   EndSl                                                             BUG15010A
                                                                                           BUG15010A
     C                   ENDIF                                                             BUG15010A
                                                                                           BUG15010A
     C                   ENDSR                                                             BUG15010A
      *****************************************************************                    BUG15010A
     C/EJECT                                                                               BUG15010A
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetAccount - Get Account parameter for FT001000              *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetAccount    BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   If        %Subst(P50FmtF1:1:1) = '/'                              BUG15010A
     C                   EVAL      ParmStr = %SUBST(P50FmtF1:2:34)                         BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = P50FmtF1                                      BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type                                     BUG15010A
     C                   Parm                    ParmStr                                   BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *Blanks                                         BUG15010A
     C                   Eval      S_ACCNT = A_DSSDY                                       BUG15010A
     C                   Move      S_CNUM        WCNUM                                     BUG15010A
     C                   Move      S_ACOD        WACOD            10                       BUG15010A
     C                   Move      S_ACSQ        WACSQ             2                       BUG15010A
     C                   Eval      PAccount = S_BRCA+ WCNUM + S_CCY                        BUG15010A
     C                                  + WACOD + WACSQ                                    BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   ENDSR                                                             BUG15010A
      *****************************************************************                    BUG15010A
     C/EJECT                                                                               BUG15010A
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
 
      ** Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   PARM                    OKFlagHS1
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
     C     PLSWFT        PLIST
     C                   PARM                    PRtnCde                                      CSW207
     C                   PARM                    PMsgID                                       CSW207
     C                   PARM                    POMFlag                                      CSW207
     C                   PARM                    PVType                                       CSW207
     C                   PARM                    P50FmtF1                                     CSW207
     C                   PARM                    P50FmtF2                                     CSW207
     C                   PARM                    P50FmtF3                                     CSW207
     C                   PARM                    P50FmtF4                                     CSW207
     C                   PARM                    P50FmtF5                                     CSW207
     C                   PARM                    PAcType                                      CSW207
     C                   PARM                    PAccount                                     CSW207
     C                   PARM                    PCust                                        CSW207
     C**********         PARM                    PNonActH                           CSW207 BUG15010A
     C                   PARM      *Blanks       PNonActH                                  BUG15010A
     C                   PARM                    PNetwork                                     CSW207
     C                   PARM                    PMsgTyp                                      CSW207
     C                   PARM                    PMsgTag                                      CSW207
     C                   PARM                    PCountry                                     CSW207
     C                   PARM                    PBrch                                        CSW207
     C                   PARM                    PCurr                                        CSW207
     C                   PARM                    PNostro                                      CSW207
     C                   PARM                    PModI                                        CSW207
     C                   PARM                    POut1                                        CSW207
     C                   PARM                    POut2                                        CSW207
     C                   PARM                    POut3                                        CSW207
     C                   PARM                    POut4                                        CSW207
     C                   PARM                    POut5                                        CSW207
                                                                                              CSW207
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CFT004'      PSARD             6
     C                   Parm                    DSFDY
 
     C                   Eval      CFT004 = 'N'
     C                   If        PRTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   Endif
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRTCD                                        CSW207
                                                                                              CSW207
     C                   IF        PRTCD = *BLANKS                                            CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ENDif                                                                CSW207
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  lows                                                                                    BUG11467
abcdefghijklmnopqrstuvwxyz
**  ups                                                                                     BUG11467
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  ALPH                                                                                    BUG24639
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                  BUG24639
**  NUMC                                                                                    BUG24639
1234567890                                                                                  BUG24639
