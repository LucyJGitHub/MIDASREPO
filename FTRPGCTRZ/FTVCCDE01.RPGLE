     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CCT Ordering Customer-Detail')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCCDE01 - Validate Ordering Customer                       *
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
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25973           Date 17Sep09               *
      *                 BUG25997           Date 14Sep09               *
      *                 BUG25927           Date 09Sep09               *
      *                 BUG24555           Date 26Jun09               *
      *                 BUG24644           Date 01Jul09               *
      *                 BUG24484           Date 23Jun09               *
      *                 BUG24404           Date 19Apr09               *
      *                 BUG24669           Date 01Jul09               *
      *                 BUG24471           Date 25Jun09               *
      *                 BUG25018           Date 17Jul09               *
      *                 BUG24710           Date 02Jul09               *
      *                 BUG24470           Date 23Jun09               *
      *                 BUG24639           Date 30Jun09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15250           Date 08Nov07               *
      *                 BUG15279           Date 08Nov07               *
      *                 BUG15010A          Date 25Oct07               *
      *                 BUG15065           Date 21Oct07               *
      *                 BUG15010           Date 14Oct07               *
      *                 BUG14877           Date 19Sep07               *
      *                 BUG14593           Date 12Aug07               *
      *                 CSW207A            Date 29Jul07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
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
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 24Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG25997 - Second line is Mandatory in CCTD Incoming if      *
      *             Line1 starts with a slash                         *
      *  BUG25927 - No warning message for invalid IBAN length        *
      *  BUG24555 - Code word DRLC-EMPL-CUST with blank issuing       *
      *             authority was not rejected                        *
      *  BUG24644 - 8/ must not be repeated error                     *
      *  BUG24484 - Detail section ordering customer field does not   *
      *             reject embedded blank lines                       *
      *  BUG24404 - 5th line was not rejected when the 1st line of    *
      *             Ordering Customer Field does not start with a     *
      *             SLASH                                             *
      *  BUG24669 - Invalid Character did not accept                  *
      *  BUG24471 - Warning Message did not appear for IBAN with      *
      *             invalid ISO Code.                                 *
      *  BUG25018 - No error message appeared for external account not*
      *             defined in ACCNTAB.                               *
      *  BUG24710 - "/" followed by valid retail account is rejected  *
      *             by the system                                     *
      *  BUG24470 - For Incoming CCTD the Ordering Customer field1    *
      *             that starts with a SLASH with no value in second  *
      *             line was not rejected                             *
      *  BUG24639 - Warning message for Iban validation should only   *
      *             be done if the 1st Line starts with XXNN format   *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15250 - Incorrect :50: format in MT102                    *
      *  BUG15279 -  Error exist in pay currency.                     *
      *  BUG15010A - Fix CFT032/CSW207 errors -Reopen                 *
      *  BUG15065 - Error for SOSE identification type                *
      *  BUG15010 - Fix CFT032/CSW207 errors                          *
      *  BUG14877 - Errors encountered in CCTD                        *
      *  BUG14593 - Swift 2007 error in SP08                           *
      *  CSW207A - Swift 2007 Standard Changes                        *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221538 - Expansion of field details.                         *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
      *                                                               *
      *****************************************************************

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

      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)

      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)

      * OK Flags for first screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)

      * OK Flags for Second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)

      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)

      * OK Flags for Second screen - Header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)

      *  External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)

      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)                                  221538
     D S_ACCNT       E DS                  EXTNAME(ACCNTAB)                                BUG15010A
     D                                     PREFIX(S_)                                      BUG15010A
     D A_DSSDY       E DS                  EXTNAME(DSSDY)                                  BUG15010A
     D                                     PREFIX(A_)                                      BUG15010A
     D N_SDNOST      E DS                  EXTNAME(SDNOSTPD)                               BUG15010A
     D                                     PREFIX(N_)                                      BUG15010A
     D C_SDCUST      E DS                  EXTNAME(SDCUSTPD)                               BUG15010A
     D                                     PREFIX(C_)                                      BUG15010A

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0

     D CFT004          S              1    INZ('N')

     D RespMode        S              1

     D DDSName         S             10

     D W#OrdCU         S             35
     D W#OrdCuB        S             35                                                     BUG15010
                                                                                              CSW207
      ** SWIFT 2007 feature                                                                   CSW207
                                                                                              CSW207
     D MMSGCHK         S              1A                                                    BUG24555
     D CSW207          S              1A                                                      CSW207
     D WCNUM           S              6A                                                     CSW207A
     D WACOD           S             10A                                                     CSW207A
     D WACSQ           S              2A                                                     CSW207A
     D wSwift07        C                   'ARNU/CCPT/CUST/DRLC/EMPL/IBEI/NIDN/-              CSW207
     D                                     SOSE/TXID/'                                        CSW207
     D P@IBAN          S             34A                                                    BUG24639
      ** Alphabetic array                                                                   BUG24639
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)                        BUG24639
      *                                                                                     BUG24639
      ** Numeric array                                                                      BUG24639
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)                        BUG24639
     D Char            S             26A   Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')                BUG24669
     D Num             S             10A   Inz('0123456789')                                BUG24669

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
      *
      ** Initialise fields
      *
     C                   EVAL      Idx     = 0
     C                   EVAL      WIx     = 0
     C                   EVAL      OKOCU1  = 'Y'
     C                   EVAL      OKOCu2  = 'Y'
     C                   EVAL      OKOCu3  = 'Y'
     C                   EVAL      OKOCu4  = 'Y'
     C                   EVAL      OKOCu5  = 'Y'                                              CSW207
     C                   EVAL      PCusTtd = *Blanks
     C                   EVAL      PType   = *Blanks
      *
      ** Main processing
      *
     C                   EXSR      VALIDATE
      *
      ** If no problems with the account entered, set up hidden field.
      *
     C                   IF        Idx = 0
      *
     C**********         If        POrdCu2 = *blank And                                221538 CSW207
     C**********                   POrdCu3 = *blank And                                221538 CSW207
     C**********                   POrdCu4 = *blank                                    221538 CSW207
     C**********         If        (POrdCu2 = *blank And                             CSW207 BUG15010
     C**********                    POrdCu3 = *blank And                             CSW207 BUG15010
     C**********                    POrdCu4 = *blank And CSW207 = 'N') Or            CSW207 BUG15010
     C**********                   (POrdCu2 = *blank And                             CSW207 BUG15010
     C**********                    POrdCu3 = *blank And                             CSW207 BUG15010
     C**********                    POrdCu4 = *blank And                             CSW207 BUG15010
     C**********                    POrdCu5 = *blank And CSW207 = 'Y')               CSW207 BUG15010
      * Fifth line not switchable                                                           BUG15010
     C                   If        (POrdCu2 = *blank And                                    BUG15010
     C                              POrdCu3 = *blank And                                    BUG15010
     C                              POrdCu4 = *blank And                                    BUG15010
     C                              POrdCu5 = *blank)                                       BUG15010
     C                   SELECT
     C                   WHEN      PType = 'IBAN'
     C                                                                                      BUG25997
     C                   If        PCCTTYP = 'BI' And                                       BUG25997
     C                             %Subst(POrdCu1:1:1) = '/'                                BUG25997
     C                   Eval      PCustTd = 'A'                                            BUG25997
     C                   Else                                                               BUG25997
     C                   EVAL      PCusTtd = 'I'
     C                   EndIf                                                              BUG25997
     C                                                                                      BUG25997
     C                   WHEN      PType = '*LEDGER'
      *                                                                            BUG15279 BUG24710
     C**********         If        %Subst(POrdCU1:1:1) <> '/'                               BUG15279
     C                   EVAL      PCusttd = 'G'
     C**********         EndIf                                                     BUG15279 BUG24710
      *                                                                                     BUG15279
     C                   WHEN      PType = '*NOSTRO'
      *                                                                                     BUG15279
     C**********         If        %Subst(POrdCU1:1:1) <> '/'                      BUG15279 BUG24710
     C                   EVAL      PCusttd = 'F'
     C**********         EndIf                                                     BUG15279 BUG24710
      *                                                                                     BUG15279
     C                   WHEN      PType = '*RETAIL'
     C                   EVAL      PCusttd = 'R'
     C                   ENDSL
     C                   Endif                                                                221538
      *
     C                   ENDIF

      * Now validate that all data entered is OK for SWIFT

      *                                                                                     BUG24669
      ** Not applicable for incoming IBAN transactions                                      BUG24669
      *                                                                                     BUG24669
     C                   If        PCCTTYP = 'BI'                       And                 BUG24669
     C                             %SubSt(POrdCu1:1:1) = '/'            And                 BUG24669
     C                             %Check(Char:%SubSt(POrdCu1:2:2)) = 0 And                 BUG24669
     C                             %Check(Num:%SubSt(POrdCu1:4:2)) = 0                      BUG24669
                                                                                            BUG24669
     C                   Else                                                               BUG24669
                                                                                            BUG24669
     C                   If        POrdCu1 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POrdCu1       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKOCU1  = 'N'
     C                   Endif
     C                   Endif
     C                   EndIf                                                              BUG24669

     C                   If        POrdCu2 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POrdCu2       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PORDCU2'                  CAP084
     C                   EVAL      OKOCU2  = 'N'
     C                   Endif
     C                   Endif

     C                   If        POrdCu3 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POrdCu3       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PORDCU3'                  CAP084
     C                   EVAL      OKOCU3  = 'N'
     C                   Endif
     C                   Endif

     C                   If        POrdCu4 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POrdCu4       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PORDCU4'                  CAP084
     C                   EVAL      OKOCU4  = 'N'
     C                   Endif
     C                   Endif
                                                                                              CSW207
     C**********         If        POrdCu5 <> *Blanks And CSW207 = 'Y'               CSW207 BUG15010
     C                   If        POrdCu5 <> *Blanks                                       BUG15010
     C                   CallB     'FTVSFTX01'                                                CSW207
     C                   Parm                    RetCdeIn         10                          CSW207
     C                   Parm      POrdCu5       Swift_Text       50                          CSW207
     C                   If        RetCdeIn = 'Error'                                         CSW207
     C                   Eval      Idx            =   Idx+1                                   CSW207
     C                   Eval      RetCodeIn      =   'Error'                                 CSW207
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                CSW207
     C                   Eval      FldNamXAr(Idx) =  'PORDCU5'                                CSW207
     C                   EVAL      OKOCU5  = 'N'                                              CSW207
     C                   Endif                                                                CSW207
     C                   Endif                                                                CSW207

     C                   If        PCUSTTD = ' ' And POrdCu1 <> *blanks Or                    221538
     C                             PCUSTTD = ' ' And POrdCu2 <> *blanks Or                    221538
     C                             PCUSTTD = ' ' And POrdCu3 <> *blanks Or                    221538
     C**********                   PCUSTTD = ' ' And POrdCu4 <> *blanks              221538 BUG15010
     C**********                   Or (PCUSTTD = ' ' And POrdCu5 <> *blanks          CSW207 BUG15010
     C**********                       And CSW207 = 'Y')                             CSW207 BUG15010
     C                             PCUSTTD = ' ' And POrdCu4 <> *blanks Or                  BUG15010
     C                             PCUSTTD = ' ' And POrdCu5 <> *blanks                     BUG15010
     C                             Or (PCUSTTD = 'A')                                       BUG25997
     C                   If        PCUSTTD = ' '                                            BUG25997
     C                   Eval      PCUSTTD = 'A'                                              221538
     C                   EndIf                                                              BUG25997
      *                                                                                     BUG24710
     C                   If        %Subst(POrdCu1:1:1) = '/' And                            BUG24710
     C                             POrdCu2 = *blanks                                        BUG24710
     C                   EVAL      OKoCu1 = 'N'                                             BUG24710
     C                   EVAL      Idx = Idx +1                                             BUG24710
     C                   EVAL      FldNamXAr(Idx) = DDSName                                 BUG24710
     C                   EVAL      MsgIdXAr(Idx) = 'FTM2152'                                BUG24710
     C                   EVAL      RetCodeIn = 'Error'                                      BUG24710
     C                   Endif                                                              BUG24470
      *                                                                                     BUG24710
     C                   Endif                                                                221538
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ValAccnt                                               *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE      BEGSR
      *
      ** If this field has already been entered in the header, entry here is
      ** prohibited.  Otherwise, this field is mandatory.
      *
     C                   IF        HPToCus1 <> *Blanks
      *
     C                   IF        POrdCu1 <> *Blanks
      * First line is mandatory                                                             BUG15010
     C**********                   Or (CSW207 = 'Y' And (POrdCu2 <> *Blanks         CSW207A BUG15010
     C**********                      Or POrdCu3 <> *Blanks                         CSW207A BUG15010
     C**********                      Or POrdCu4 <> *Blanks                         CSW207A BUG15010
     C**********                      Or POrdCu5 <> *Blanks))                       CSW207A BUG15010
     C                   EVAL      OKoCu1 = 'N'
     C                   EVAL      Idx = Idx +1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0131'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   ELSE
      *                                                                                     BUG15065
      ** Swift address                                                                      BUG15065
      *                                                                                     BUG15065
     C**********         If        PCUSTTD = ' ' And POrdCu1 <> *blanks            BUG15065 BUG25018
     C**********                   Or PCUSTTD = ' ' And POrdCu2 <> *blanks         BUG15065 BUG25018
     C**********                   Or PCUSTTD = ' ' And POrdCu3 <> *blanks         BUG15065 BUG25018
     C**********                   Or PCUSTTD = ' ' And POrdCu4 <> *blanks         BUG15065 BUG25018
     C**********                   Or PCUSTTD = ' ' And POrdCu5 <> *blanks         BUG15065 BUG25018
     C**********         Eval      PCUSTTD = 'A'                                   BUG15065 BUG25018
     C**********         EndIf                                                     BUG15065 BUG25018
      *
     C**********         If        %Subst(POrdCu1:1:1) = '/' And                   BUG24470 BUG24710
     C**********                   POrdCu2 = *blanks                               BUG24470 BUG24710
     C**********         EVAL      OKoCu1 = 'N'                                    BUG24470 BUG24710
     C**********         EVAL      Idx = Idx +1                                    BUG24470 BUG24710
     C**********         EVAL      FldNamXAr(Idx) = DDSName                        BUG24470 BUG24710
     C**********         EVAL      MsgIdXAr(Idx) = 'FTM2152'                       BUG24470 BUG24710
     C**********         EVAL      RetCodeIn = 'Error'                             BUG24470 BUG24710
     C**********         Endif                                                     BUG24470 BUG24710
      *                                                                                     BUG24470
     C                   IF        POrdCu1 = *Blanks
     C                   EVAL      OKoCu1 = 'N'
     C                   EVAL      Idx = Idx +1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0130'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C**********         ELSEIF    (POrdCu1 <> *Blanks and                         BUG24404 BUG24644
     C                   IF        (POrdCu1 <> *Blanks and                                  BUG24644
     C                             POrdCu5 <> *Blanks and                                   BUG24404
     C                             %SUBST(POrdCu1:1:1) <> '/')                              BUG24404
      *                                                                                     BUG24404
     C                   IF        %SUBST(POrdCu5:1:2) <> '1/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '2/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '3/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '4/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '5/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '6/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '7/' AND                          BUG24404
     C                             %SUBST(POrdCu5:1:2) <> '8/' AND                          BUG24404
      *                                                                                     BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'ARNU/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'CCPT/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'CUST/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'DRLC/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'EMPL/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'NIDN/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'SOSE/' AND                       BUG24404
     C                             %SUBST(POrdCu1:1:5) <> 'TXID/'                           BUG24404
      *                                                                                     BUG24404
     C                   EVAL      OKoCu1 = 'N'                                             BUG24404
     C                   EVAL      Idx = Idx +1                                             BUG24404
     C                   EVAL      FldNamXAr(Idx) = DDSName                                 BUG24404
     C                   EVAL      MsgIdXAr(Idx) = 'FTM7112'                                BUG24404
     C                   EVAL      RetCodeIn = 'Error'                                      BUG24404
     C                   ENDIF                                                              BUG24404
     C                   ENDIF                                                              BUG24644
      *
     C*****POrdCU1:5     SCAN      wSwift07                                           CSW207 CSW207A
     C**********         IF        NOT %FOUND                                         CSW207 CSW207A
     C                   CLEAR                   W#OrdCU
     C                   EVAL      W#OrdCu = POrdCU1
     C                   EXSR      ValAccnt
      *                                                                                     BUG24484
      ** Embedded blanks not allowed                                                        BUG24484
      *                                                                                     BUG24484
     C                   If        POrdCu2 = *Blanks AND                                    BUG24484
     C                             POrdCu3 <>*Blanks OR                                     BUG24484
     C                             POrdCu2 = *Blanks AND                                    BUG24484
     C                             POrdCu4 <>*Blanks OR                                     BUG24484
     C                             POrdCu2 = *Blanks AND                                    BUG24484
     C                             POrdCu5 <>*Blanks OR                                     BUG24484
     C                             POrdCu3 = *Blanks AND                                    BUG24484
     C                             POrdCu4 <>*Blanks OR                                     BUG24484
     C                             POrdCu3 = *Blanks AND                                    BUG24484
     C                             POrdCu5 <>*Blanks OR                                     BUG24484
     C                             POrdCu4 = *Blanks AND                                    BUG24484
     C                             POrdCu5 <>*Blanks                                        BUG24484
     C                   Eval      Idx            =   Idx+1                                 BUG24484
     C                   Eval      RetCodeIn      =   'Error'                               BUG24484
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0925'                              BUG24484
     C                   Eval      FldNamXAr(Idx) =  DDSName                                BUG24484
     C                   Eval      OkOCu2    = 'N'                                          BUG24484
     C                   Eval      OkOCu3    = 'N'                                          BUG24484
     C                   Eval      OkOCu4    = 'N'                                          BUG24484
     C                   Eval      OkOCu5    = 'N'                                          BUG24484
     C                   Endif                                                              BUG24484
     C**********         ELSE                                                         CSW207 CSW207A
     C**********         EVAL      PType = '*SWIFT '                                  CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
      *
      ** If the Transfer Type is 'BI':
      *
     C                   IF        HPCCTTYP = 'BI'
      *
      ** If more then one line entered, then assume free format name
      ** and address has been entered otherwise a customer number or
      ** shortname may be entered on the first line
      *
     C                   IF        PType = '*CUSTNO' OR
     C**********                   PTYPE = '*SWIFT ' OR                              221538 BUG15010
     C                             PType = '*SHNAME'
     C**********                   OR CSW207 = 'Y'                                  CSW207A BUG15010
     C**********         If        POrdCu2 = *blanks And POrdCu3 = *blanks And         221538 CSW207
     C**********                   POrdCu4 = *blanks                                   221538 CSW207
     C**********         If        (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And CSW207 = 'N') Or           CSW207 BUG15010
     C**********                   (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And POrdCu5 = *blanks And      CSW207 BUG15010
     C**********                    CSW207 = 'Y')                                    CSW207 BUG15010
     C                   EVAL      PCUSTTD = 'C'                                              221538
     C                   If        PTYPE = '*SHNAME'                                          221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   If        %Subst(POrdCu1:1:1) = '/'                                BUG15010
     C                   Movel(P)  BBCUST        POrdCu2                                    BUG15010
     C                   Else                                                               BUG15010
     C                   Movel(P)  BBCUST        POrdCu1                                      221538
     C                   Endif                                                              BUG15010
     C                   Endif                                                                221538
     C                   Endif                                                                221538
      *                                                                                       221538
     C**********         If        POrdCu2 = *blanks And POrdCu3 = *blanks And         221538 CSW207
     C**********                   POrdCu4 = *blanks And PTYPE = '*SWIFT '             221538 CSW207
     C**********         If        (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And PTYPE = '*SWIFT 'And       CSW207 BUG15010
     C**********                    CSW207 = 'N') Or                                 CSW207 BUG15010
     C**********                   (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And PTYPE = '*SWIFT ' And      CSW207 BUG15010
     C**********                    POrdCu5 = *blanks And CSW207 = 'Y')              CSW207 BUG15010
     C                   If        (POrdCu2 = *blanks And                                   BUG15010
     C                              POrdCu3 = *blanks And                                   BUG15010
     C                              POrdCu4 = *blanks And                                   BUG15010
     C                              POrdCu5 = *blanks And                                   BUG15010
     C                              PTYPE = '*SWIFT ' ) or                                  BUG15010
     C                             (%Subst(POrdCu1:1:1) = '/' and                           BUG15010
     C                              POrdCu2 <> *blanks And                                  BUG15010
     C                              POrdCu3 = *blanks And                                   BUG15010
     C                              POrdCu4 = *blanks And                                   BUG15010
     C                              POrdCu5 = *blanks And                                   BUG15010
     C                              PTYPE = '*SWIFT ')                                      BUG15010
     C                   EVAL      PCUSTTD = 'S'                                              221538
     C                   Endif                                                                221538
      *                                                                                       221538
                                                                                              CSW207
      ** Call 50F validation program                                                          CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
                                                                                           BUG15010A
      ** Get Country of Location parameter for FT001000                                    BUG15010A
      ** for Incoming must be the Destination, for Outgoing must be the Sender             BUG15010A
     C                   Exsr      GetCountry                                              BUG15010A
                                                                                           BUG15010A
      ** Get Nostro parameter from Sender or Receiver Correspondent if <> Blanks           BUG15010A
     C                   If        HPSNDCOR <> *Blanks Or                                  BUG15010A
     C                             HPRCVCOR <> *Blanks                                     BUG15010A
     C                   Exsr      GetNostro                                               BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000            BUG15010A
     C                   If        PCUSTTD = 'C'                                           BUG15010A
     C                   If        POrdCu2 = *Blanks                                        BUG15250
     C                   Movel     POrdCu1       PCust                                     BUG15010A
     C                   Else                                                               BUG15250
     C                   Movel     POrdCu2       PCust                                      BUG15250
     C                   EndIf                                                              BUG15250
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is IBAN, Retail or Ledger, set Account parameter of FT001000        BUG15010A
     C                   If        PCUSTTD = 'I' Or                                        BUG15010A
     C                             PCUSTTD = 'P' Or                                        BUG15010A
     C                             PCUSTTD = 'R'                                           BUG15010A
     C                   Exsr      GetAccount                                              BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                              CSW207
     C                   EVAL      PAcType = PCUSTTD                                        BUG15010
     C                   CALL      'FT001000'                                                 CSW207
     C                   PARM      *BLANKS       PrtCd                                        CSW207
     C                   PARM      *BLANKS       PMsgID            7                          CSW207
     C                   PARM      *BLANK        POMFlag           1                          CSW207
     C**********         PARM      'OMFM'        PVtype            4                  CSW207 CSW207A
     C                   PARM      'TRAN'        PVtype            4                         CSW207A
     C                   PARM                    POrdCu1                                      CSW207
     C                   PARM                    POrdCu2                                      CSW207
     C                   PARM                    POrdCu3                                      CSW207
     C                   PARM                    POrdCu4                                      CSW207
     C                   PARM                    POrdCu5                                      CSW207
     C**********         PARM      *BLANKS       PAcType           1                  CSW207 CSW207A
     C                   PARM                    PAcType           1                         CSW207A
     C**********         PARM      *BLANKS       PAccount         34                  CSW207 CSW207A
     C                   PARM                    PAccount         34                         CSW207A
     C**********         PARM      *BLANKS       PCust             6                  CSW207 CSW207A
     C                   PARM                    PCust             6                         CSW207A
     C                   PARM      *BLANKS       PNonActH         10                          CSW207
     C                   PARM      'SWIFT'       PNetwork          6                          CSW207
     C                   PARM      '102'         PMsgTyp           3                          CSW207
     C                   PARM      ':50F:'       PMsgTag           5                          CSW207
     C                   PARM                    PCountry          2                          CSW207
     C**********         PARM                    PBrch             3                 CSW207 BUG15010
     C                   PARM      HPBRCA        PBrch             3                        BUG15010
     C**********         PARM                    PCurr             3                 CSW207 BUG15010
     C                   PARM      HPCCTCCY      PCurr             3                        BUG15010
     C                   PARM                    PNostro           2                          CSW207
     C**********         PARM      *BLANK        PModI             2                 CSW207 BUG15010
     C**********         PARM      'FT'          PModI             2               BUG15010 BUG25973
     C                   PARM      HPCCTTYP      PModI             2                        BUG25973
     C                   PARM                    POut1            35                          CSW207
     C                   PARM                    POut2            35                          CSW207
     C                   PARM                    POut3            35                          CSW207
     C                   PARM                    POut4            35                          CSW207
     C                   PARM                    POut5            35                          CSW207
                                                                                              CSW207
     C                   EVAL      MMSGCHK = 'N'                                            BUG24555
     C                   IF        PMsgID= 'FTS0055'                                        BUG15010
     C                   Eval      POMFlag = 'W'                                            BUG15010
     C                   ENDIF                                                              BUG15010
      *                                                                                     BUG15010
     C                   IF        PrtCd = '*ERROR '                                          CSW207
     C                             and POMFlag = 'E'                                        BUG15010
     C                   EVAL      Idx = Idx + 1                                              CSW207
     C                   EVAL      MsgIDXar(Idx) = PMsgID                                     CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU1'                                 CSW207
     C                   EVAL      RetCodeIn = 'Error'                                        CSW207
     C                   EVAL      MMSGCHK = 'Y'                                            BUG24555
     C**********         ELSE                                                        CSW207 BUG15010
     C**********         LEAVESR                                                     CSW207 BUG15010
     C                   ENDIF                                                                CSW207
      *                                                                                     BUG15010
     C                   IF        PrtCd = '*ERROR '                                        BUG15010
     C                             and POMFlag = 'W'                                        BUG15010
     C                   EVAL      WIx = WIx + 1                                            BUG15010
     C                   EVAL      WMsgIDXAr(WIx) = PMsgID                                  BUG15010
     C                   EVAL      WFldNmXAr(WIx) = 'PORDCU1'                               BUG15010
     C                   EVAL      RetCodeIn = 'Error'                                      BUG15010
     C                   EVAL      MMSGCHK = 'Y'                                            BUG24555
     C                   ENDIF                                                              BUG15010
      *                                                                                     BUG15010
     C                   IF        RetCodeIn <> 'Error'                                     BUG15010
     C                   LeaveSR                                                            BUG15010
     C                   Endif                                                              BUG15010
      *                                                                                     BUG15010
     C**********         ENDIF                                                       CSW207 BUG15010
                                                                                              CSW207
     C                   IF        POrdCu2 <> *Blanks
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU2'                   CAP084
     C                   EndIf                                                              BUG14593
     C                   ENDIF
     C                   IF        POrdCu3 <> *Blanks
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu3 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU3'                   CAP084
     C                   EndIf                                                              BUG14593
     C                   ENDIF
     C                   IF        POrdCu4 <> *Blanks
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu4 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU4'                   CAP084
     C                   EndIf                                                              BUG14593
     C                   ENDIF
     C**********         IF        POrdCu5 <> *Blanks AND CSW207 = 'Y'               CSW207 BUG15010
     C                   IF        POrdCu5 <> *Blanks                                       BUG15010
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu5 = 'N'                                               CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU5'                                 CSW207
     C                   EndIf                                                              BUG14593
     C                   ENDIF                                                                CSW207
     C                   IF        OKOCu2 = 'N' OR OKOCu3 = 'N' OR
     C                             OKOCu4 = 'N'
     C**********                   OR (OKOCu5 = 'N' AND CSW207 = 'Y')                CSW207 BUG15010
     C                             OR (OKOCu5 = 'N')                                        BUG15010
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0215'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *                                                                                     BUG24555
     C                   IF        MMSGCHK = 'Y'                                            BUG24555
     C                   Eval      OkOCu1 = 'N'                                             BUG24555
     C                   Eval      OkOCu2 = 'N'                                             BUG24555
     C                   Eval      OkOCu3 = 'N'                                             BUG24555
     C                   Eval      OkOCu4 = 'N'                                             BUG24555
     C                   Eval      OkOCu5 = 'N'                                             BUG24555
     C                   ENDIF                                                              BUG24555
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the Transfer Type is 'BO':
      *
      *
      ** If more then one line entered, then assume free format name
      ** and address has been entered otherwise a customer number,
      ** shortname or account identifier may be entered.
      *
     C                   IF        HPCctTyp = 'BO'
      *
     C                   IF        PType = '*NOSTRO' OR
     C                             PType = '*RETAIL' OR
     C                             PType = '*SHNAME' OR
     C                             PType = '*LEDGER' OR
     C                             PType = '*CUSTNO' OR
     C                             PTYPE = '*SWIFT ' OR                                       221538
     C                             PType = 'IBAN'
     C**********                   OR CSW207 = 'Y'                                  CSW207A BUG15010
      *                                                                                       221538
     C                   If        PTYPE = '*CUSTNO' OR                                       221538
     C                             PTYPE = '*SHNAME'                                          221538
     C**********         If        POrdCu2 = *blanks And POrdCu3 = *blanks And         221538 CSW207
     C**********                   POrdCu4 = *blanks                                   221538 CSW207
     C**********         If        (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And CSW207 = 'N') Or           CSW207 BUG15010
     C**********                   (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And POrdCu5 = *blanks And      CSW207 BUG15010
     C**********                    CSW207 = 'Y')                                    CSW207 BUG15010
     C                   If        ((POrdCu2 = *blanks And POrdCu3 = *blanks And            BUG15010
     C                              POrdCu4 = *blanks And POrdCu5 = *blanks And             BUG15010
     C                              %Subst(POrdCu1:1:1) <> '/') or                          BUG15010
     C                             (                      POrdCu3 = *blanks And             BUG15010
     C                              POrdCu4 = *blanks And POrdCu5 = *blanks And             BUG15010
     C                              %Subst(POrdCu1:1:1) =  '/'))                            BUG15010
     C                   EVAL      PCUSTTD = 'C'                                              221538
     C                   If        PTYPE = '*SHNAME'                                          221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   If        %Subst(POrdCu1:1:1) =  '/'                               BUG15010
     C                   Movel(P)  BBCUST        POrdCu2                                    BUG15010
     C                   Else                                                               BUG15010
     C                   Movel(P)  BBCUST        POrdCu1                                      221538
     C                   Endif                                                              BUG15010
     C                   Endif                                                              BUG15010
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
      *                                                                                       221538
     C**********         If        POrdCu2 = *blanks And POrdCu3 = *blanks And         221538 CSW207
     C**********                   POrdCu4 = *blanks And PTYPE = '*SWIFT '             221538 CSW207
     C**********         If        (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And PTYPE = '*SWIFT ' And      CSW207 BUG15010
     C**********                    CSW207 = 'N') Or                                 CSW207 BUG15010
     C**********                   (POrdCu2 = *blanks And POrdCu3 = *blanks And      CSW207 BUG15010
     C**********                    POrdCu4 = *blanks And PTYPE = '*SWIFT ' And      CSW207 BUG15010
     C**********                    POrdCu5 = *blanks And CSW207 = 'Y')              CSW207 BUG15010
     C                   If        ((POrdCu2 = *blanks And POrdCu3 = *blanks And            BUG15010
     C                              POrdCu4 = *blanks And POrdCu5 = *blanks And             BUG15010
     C                              %Subst(POrdCu1:1:1) <> '/'                              BUG15010
     C                              And PTYPE = '*SWIFT ') or                               BUG15010
     C                             (POrdCu3 = *blanks And                                   BUG15010
     C                              POrdCu4 = *blanks And POrdCu5 = *blanks And             BUG15010
     C                              %Subst(POrdCu1:1:1) =  '/')                             BUG15010
     C                              And PTYPE = '*SWIFT ')                                  BUG15010
     C                   EVAL      PCUSTTD = 'S'                                              221538
     C                   Endif                                                                221538
      *                                                                                       221538
                                                                                              CSW207
      ** Call 50F validation program                                                          CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
                                                                                           BUG15010A
      ** Get Country of Location parameter for FT001000                                    BUG15010A
      ** for Incoming must be the Destination, for Outgoing must be the Sender             BUG15010A
     C                   Exsr      GetCountry                                              BUG15010A
                                                                                           BUG15010A
      ** Get Nostro parameter from Sender or Receiver Correspondent if <> Blanks           BUG15010A
     C                   If        HPSNDCOR <> *Blanks Or                                  BUG15010A
     C                             HPRCVCOR <> *Blanks                                     BUG15010A
     C                   Exsr      GetNostro                                               BUG15010A
     C                   EndIf                                                             BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000             BUG15250
     C                   If        PCUSTTD = 'C'                                            BUG15250
     C                   If        POrdCu2 = *Blanks                                        BUG15250
     C                   Movel     POrdCu1       PCust                                      BUG15250
     C                   Else                                                               BUG15250
     C                   Movel     POrdCu2       PCust                                      BUG15250
     C                   EndIf                                                              BUG15250
     C                   EndIf                                                              BUG15250

     C                   EVAL      PAcType = PCUSTTD                                        BUG15010
     C                   CALL      'FT001000'                                                 CSW207
     C                   PARM      *BLANKS       PrtCd                                        CSW207
     C                   PARM      *BLANKS       PMsgID                                       CSW207
     C                   PARM      *BLANK        POMFlag                                      CSW207
     C                   PARM      'TRAN'        PVtype                                       CSW207
     C                   PARM                    POrdCu1                                      CSW207
     C                   PARM                    POrdCu2                                      CSW207
     C                   PARM                    POrdCu3                                      CSW207
     C                   PARM                    POrdCu4                                      CSW207
     C                   PARM                    POrdCu5                                      CSW207
     C**********         PARM      *BLANKS       PAcType                              CSW207 CSW207A
     C                   PARM                    PAcType                                     CSW207A
     C**********         PARM      *BLANKS       PAccount                             CSW207 CSW207A
     C                   PARM                    PAccount                                    CSW207A
     C**********         PARM      *BLANKS       PCust                                CSW207 CSW207A
     C                   PARM                    PCust                                       CSW207A
     C                   PARM      *BLANKS       PNonActH                                     CSW207
     C                   PARM      'SWIFT'       PNetwork                                     CSW207
     C                   PARM      '102'         PMsgTyp                                      CSW207
     C                   PARM      ':50F:'       PMsgTag                                      CSW207
     C                   PARM                    PCountry                                     CSW207
     C**********         PARM                    PBrch                               CSW207 BUG15010
     C                   PARM      HPBRCA        PBrch                                      BUG15010
     C**********         PARM                    PCurr                               CSW207 BUG15010
     C                   PARM      HPCCTCCY      PCurr                                      BUG15010
     C                   PARM                    PNostro                                      CSW207
     C**********         PARM      *BLANK        PModI                               CSW207 BUG15010
     C**********         PARM      'FT'          PModI                             BUG15010 BUG25973
     C                   PARM      HPCCTTYP      PModI                                      BUG25973
     C                   PARM                    POut1                                        CSW207
     C                   PARM                    POut2                                        CSW207
     C                   PARM                    POut3                                        CSW207
     C                   PARM                    POut4                                        CSW207
     C                   PARM                    POut5                                        CSW207
                                                                                              CSW207
     C                   EVAL      MMSGCHK = 'N'                                            BUG24555
     C                   IF        PrtCd = '*ERROR '                                          CSW207
     C                             and POMFlag = 'E'                                        BUG15010
     C                   EVAL      Idx = Idx + 1                                              CSW207
     C                   EVAL      MsgIDXar(Idx) = PMsgID                                     CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU1'                                 CSW207
     C                   EVAL      RetCodeIn = 'Error'                                        CSW207
     C                   EVAL      MMSGCHK = 'Y'                                            BUG24555
     C**********         ELSE                                                        CSW207 BUG15010
     C**********         LEAVESR                                                     CSW207 BUG15010
     C                   ENDIF                                                                CSW207
      *                                                                                     BUG15010
     C                   IF        PrtCd = '*ERROR '                                        BUG15010
     C                             and POMFlag = 'W'                                        BUG15010
     C                   EVAL      WIx = WIx + 1                                            BUG15010
     C                   EVAL      WMsgIDXAr(WIx) = PMsgID                                  BUG15010
     C                   EVAL      WFldNmXAr(WIx) = 'PORDCU1'                               BUG15010
     C                   EVAL      RetCodeIn = 'Error'                                      BUG15010
     C                   EVAL      MMSGCHK = 'Y'                                            BUG24555
     C                   ENDIF                                                              BUG15010
      *                                                                                     BUG15010
     C                   IF        RetCodeIn <> 'Error'                                     BUG15010
     C                   LeaveSR                                                            BUG15010
     C                   Endif                                                              BUG15010
      *                                                                                     BUG15010
     C**********         ENDIF                                                       CSW207 BUG15010
                                                                                              CSW207
     C                   IF        POrdCu2 <> *Blanks
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU2'                   CAP084
     C                   EndIf                                                              BUG14593
     C                   ENDIF
     C                   IF        POrdCu3 <> *Blanks
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu3 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU3'                   CAP084
     C                   EndIf                                                              BUG14593
     C                   ENDIF
     C                   IF        POrdCu4 <> *Blanks
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu4 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU4'                   CAP084
     C                   EndIf                                                              BUG14593
     C                   ENDIF
     C**********         IF        POrdCu5 <> *Blanks And CSW207='Y'                 CSW207 BUG15010
     C                   IF        POrdCu5 <> *Blanks                                       BUG15010
     C                   If        CSW207 = 'N'                                             BUG14593
     C                   EVAL      OkOCu5 = 'N'                                               CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PORDCU5'                                 CSW207
     C                   EndIf                                                              BUG14593
     C                   ENDIF                                                                CSW207
     C                   IF        OKOCu2 = 'N' OR OKOCu3 = 'N' OR
     C                             OKOCu4 = 'N'
     C**********                   Or (OKOCu5 = 'N' And CSW207 = 'Y')                CSW207 BUG15010
     C                             OR (OKOCu5 = 'N')                                        BUG15010
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0215'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *                                                                                     BUG24555
     C                   IF        MMSGCHK = 'Y'                                            BUG24555
     C                   Eval      OkOCu1 = 'N'                                             BUG24555
     C                   Eval      OkOCu2 = 'N'                                             BUG24555
     C                   Eval      OkOCu3 = 'N'                                             BUG24555
     C                   Eval      OkOCu4 = 'N'                                             BUG24555
     C                   Eval      OkOCu5 = 'N'                                             BUG24555
     C                   ENDIF                                                              BUG24555
      *
     C                   ENDIF
      *
     C                   If        CSW207 = 'N'                                             BUG15010
      ** Ensure that the second line does not contain /
      *
     C     '/'           SCAN      POrdCu2       ScanPos2          2 0
      *
     C                   If        ScanPos2 <> 0
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0348'
     C                   Eval      FldNamXAr(Idx)  =  'POrdCu2'
     C                   Eval      OkOCu2 = 'N'
     C                   Endif
      *
      ** Ensure that the third line does not contain /
      *
     C     '/'           SCAN      POrdCu3       ScanPos3          2 0
      *
     C                   If        ScanPos3 <> 0
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0349'
     C                   Eval      FldNamXAr(Idx)  =  'POrdCu3'
     C                   Eval      OkOCu3 = 'N'
     C                   Endif
      *
      ** Ensure that the forth line does not contain /
      *
     C     '/'           SCAN      POrdCu4       ScanPos4          2 0
      *
     C                   If        ScanPos4 <> 0
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0350'
     C                   Eval      FldNamXAr(Idx)  =  'POrdCu4'
     C                   Eval      OkOCu4 = 'N'
     C                   Endif
      *                                                                                       CSW207
      ** Ensure that the fifth line does not contain /                                        CSW207
      *                                                                                       CSW207
     C**********         IF        CSW207 = 'Y'                                      CSW207 BUG15010
     C     '/'           SCAN      POrdCu5       ScanPos5          2 0                        CSW207
      *                                                                                       CSW207
     C                   If        ScanPos5 <> 0                                              CSW207
     C                   Eval      Idx             =   Idx+1                                  CSW207
     C                   Eval      RetCodeIn       =   'Error'                                CSW207
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0350'                               CSW207
     C                   Eval      FldNamXAr(Idx)  =  'POrdCu5'                               CSW207
     C                   Eval      OkOCu5 = 'N'                                               CSW207
     C                   Endif                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAccnt - Checks for valid account                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAccnt      BEGSR
      *
     C                   EVAL      PType = *Blanks
     C                   If        %Subst(W#OrdCu  :1:1)  = '/'                             BUG15010
     C**********         Eval      W#OrdCuB = POrdCU2                              BUG15010 BUG15279
     C                   Eval      W#OrdCuB = %Subst(W#OrdCu:2)                             BUG15279
     C                   Else                                                               BUG15010
     C                   Eval      W#OrdCuB = W#OrdCu                                       BUG15010
     C                   Endif                                                              BUG15010
     C                   Eval      PAcType = *Blanks                                        BUG14877
      *
      ** Validate Account
      *
     C                   IF        HPCCTTYP = 'BO'                                          BUG24710
     C                   CALLB     'AOACCTV1'
     C                   PARM      *Blanks       PRtcd             7            B:Return code
     C                   PARM                    PType             7            I:A/c ID
     C**********         PARM                    W#OrdCu                        I:A/c CurrenBUG15010
     C                   PARM                    W#OrdCuB                       I:A/c CurrenBUG15010
     C                   PARM                    DSSDY                          I:A/c code
     C                   ELSE                                                               BUG25927
     C                   EVAL      PRTCD = '*NRF'                                           BUG25927
     C                   ENDIF                                                              BUG24710
      *
      ** CFT004 is switched on
      *
     C                   IF        CFT004 = 'Y' and
     C                             HPCctTyp = 'BO'
     C                             Or CSW207 = 'Y'                                          BUG24471
      *                                                                                     BUG15250
      ** If not valid account check 2nd line if valid                                       BUG15250
      *                                                                                     BUG15250
     C                   If        %Subst(W#OrdCu:1:1)  = '/'  And                          BUG15250
     C                             POrdCU2 <> *Blanks  And                                  BUG15250
     C                             PRtcd = '*NRF'                                           BUG15250
      *                                                                                     BUG15250
     C                   Movel     POrdCU2       W#OrdCuB                                   BUG15250
     C                   CALLB     'AOACCTV1'                                               BUG15250
     C                   PARM      *Blanks       PRtcd                                      BUG15250
     C                   PARM                    PType                                      BUG15250
     C                   PARM                    W#OrdCuB                                   BUG15250
     C                   PARM                    DSSDY                                      BUG15250
     C                   EndIf                                                              BUG15250
      *                                                                                     BUG15250
     C                   IF        PType <> '*NOSTRO'  and
     C                             PType <> '*RETAIL'  and
     C                             PType <> '*SHNAME'  and
     C**********                   PType <> '*CUSTNO' or                                      221538
     C**********                   PType <> '*LEDGER' or                                      221538
     C                             PType <> '*CUSTNO' And                                     221538
     C                             PType <> '*LEDGER' And                                     221538
     C                             PRtcd <> *Blanks
     C**********                   OR CSW207 = 'Y'                                  CSW207A BUG14877
     C                   If        %Subst(W#OrdCu:1:1) = '/'                                 CSW207A
     C                   Eval      W#OrdCu = %Subst(W#OrdCu:2)                               CSW207A
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   MOVEL     W#OrdCu       PIBAN                                      BUG24639
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
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       PRTCD
     C                   PARM                    W#OrdCu
     C     Accnt         PARM      Accnt         Dssdy

     C                   IF        PRtcd = *Blanks
     C                   EVAL      PType = 'IBAN'
     C                   Eval      PAcType = 'I'                                             CSW207A
     C                   Move      CNUM          WCNUM                                       CSW207A
     C                   Move      ACOD          WACOD                                       CSW207A
     C                   Move      ACSQ          WACSQ                                       CSW207A
     C                   Eval      PAccount = ACBRCA + WCNUM + CCY                           CSW207A
     C                                  + WACOD + WACSQ                                      CSW207A
     C**********         Eval      PCountry = %Subst(W#OrdCu:1:2)                   CSW207A BUG15010
     C                   Eval      PCUST    = WCNUM                                         BUG15010
                                                                                             CSW207A
     C                   Else                                                                CSW207A
      *                                                                                      CSW207A
      ** Check external IBAN                                                                 CSW207A
      *                                                                                      CSW207A
     C                   Call      'AOIBANR5'                                                CSW207A
     C                   Parm      *Blanks       PRTCD                                       CSW207A
     C                   Parm                    W#OrdCu                                     CSW207A
     C                   If        PRTCD = *Blanks                                           CSW207A
     C**********         Call      'AOIBANR4'                                       CSW207A BUG15010
     C**********         Parm      *Blanks       PRTCD                              CSW207A BUG15010
     C**********         Parm      '*KEY'        @OPTN                              CSW207A BUG15010
     C**********         Parm                    W#OrdCu                            CSW207A BUG15010
     C*****Accnt         Parm      Accnt         Dssdy                              CSW207A BUG15010
     C**********         If        PRTCD = *Blanks                                  CSW207A BUG15010
     C**********         Eval      PAcType = 'I'                                    CSW207A BUG15010
     C**********         Move      CNUM          WCNUM                              CSW207A BUG15010
     C**********         Move      ACOD          WACOD                              CSW207A BUG15010
     C**********         Move      ACSQ          WACSQ                              CSW207A BUG15010
     C**********         Eval      PAccount = ACBRCA + WCNUM + CCY                  CSW207A BUG15010
     C**********                        + WACOD + WACSQ                             CSW207A BUG15010
     C**********         Eval      PCountry = %Subst(W#OrdCu:1:2)                   CSW207A BUG15010
     C**********         EndIf                                                      CSW207A BUG15010
     C                   Else                                                               BUG24471
                                                                                            BUG24471
     C                   SELECT                                                             BUG24471
                                                                                            BUG24471
      *                                                                                     BUG24471
      ** Invalid ISO country code                                                           BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      1'                                        BUG24471
     C                   EVAL      OKoCu1 = 'W'                                             BUG24471
     C                   EVAL      WIX = WIX +1                                             BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIDXAr(WIX) = 'FTM2400'                               BUG24471
      *                                                                                     BUG24471
      ** Invalid BBAN length                                                                BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      2'                                        BUG24471
     C                   EVAL      OKoCu1 = 'W'                                             BUG24471
     C                   EVAL      WIX = WIX +1                                             BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIDXAr(WIX) = 'FTM2401'                               BUG24471
      *                                                                                     BUG24471
      ** Invalid character                                                                  BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      3'                                        BUG24471
      *                                                                                     BUG24669
      ** Not applicable for outgoing IBAN transactions                                      BUG24669
      *                                                                                     BUG24669
     C                   If        PCCTTYP = 'BO'                       And                 BUG24669
     C                             %SubSt(POrdCu1:1:1) = '/'            And                 BUG24669
     C                             %Check(Char:%SubSt(POrdCu1:2:2)) = 0 And                 BUG24669
     C                             %Check(Num:%SubSt(POrdCu1:4:2)) = 0                      BUG24669
                                                                                            BUG24669
     C                   Else                                                               BUG24669
                                                                                            BUG24669
     C                   EVAL      OKoCu1 = 'W'                                             BUG24471
     C                   EVAL      WIX = WIX +1                                             BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIDXAr(WIX) = 'FTM2402'                               BUG24471
     C                   EndIf                                                              BUG24669
      *                                                                                     BUG24471
      ** Invalid IBAN length                                                                BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      4'                                        BUG24471
     C                   EVAL      OKoCu1 = 'W'                                             BUG24471
     C                   EVAL      WIX = WIX +1                                             BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIDXAr(WIX) = 'FTM2403'                               BUG24471
      *                                                                                     BUG24471
      ** Invalid check digit                                                                BUG24471
      *                                                                                     BUG24471
     C                   WHEN      PRTCD = '      5'                                        BUG24471
     C                   EVAL      OKoCu1 = 'W'                                             BUG24471
     C                   EVAL      WIX = WIX +1                                             BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIDXAr(WIX) = 'FTM2404'                               BUG24471
      *                                                                                     BUG24471
      ** Other/non-specific warning                                                         BUG24471
      *                                                                                     BUG24471
     C                   Other                                                              BUG24471
     C                   EVAL      OKoCu1 = 'W'                                             BUG24471
     C                   EVAL      WIX = WIX +1                                             BUG24471
     C                   EVAL      WFldNmXAr(WIX) = DDSName                                 BUG24471
     C                   EVAL      WMsgIDXAr(WIX) = 'FTM2405'                               BUG24471
                                                                                            BUG24471
     C                   Endsl                                                              BUG24471
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   ENDIF
     C                   Endif                                                              BUG24639
     C                   ENDIF
     C                   ENDIF
                                                                                             CSW207A
     C**********         If        CSW207 = 'Y'                                     CSW207A BUG15010
     C**********                   And PAcType <> 'I'                               CSW207A BUG15010
     C                   If        PAcType <> 'I'                                           BUG15010
     C**********         Eval      PAcType = *Blanks                                CSW207A BUG14877
     C                   Select                                                              CSW207A
     C                   When      PType = '*RETAIL'                                         CSW207A
     C                             Or PType = '*LEDGER'                                      CSW207A
     C                   Eval      ACCNT = DSSDY                                             CSW207A
     C                   Move      CNUM          WCNUM                                       CSW207A
     C                   Move      ACOD          WACOD                                       CSW207A
     C                   Move      ACSQ          WACSQ                                       CSW207A
     C                   Eval      PAccount = ACBRCA + WCNUM + CCY                           CSW207A
     C                                  + WACOD + WACSQ                                      CSW207A
     C                   Eval      PCUST    = WCNUM                                         BUG15010
     C                   If        PType = '*RETAIL'                                         CSW207A
     C                   Eval      PAcType = 'R'                                             CSW207A
     C                   Else                                                                CSW207A
     C                   Eval      PAcType = 'G'                                             CSW207A
     C                   EndIf                                                               CSW207A
     C                   When      PType = '*CUSTNO'                                         CSW207A
     C                             Or PType = '*SHNAME'                                      CSW207A
     C                   Eval      PAcType = 'C'                                             CSW207A
     C                   Eval      C@FMT = DSSDY                                            BUG15010
     C                   Movel(P)  BBCUST        PCust                                      BUG15010
     C**********         Eval      PCust   = W#OrdCu                                CSW207A BUG15010
     C                   Movel     BBCOLC        PCountry                                   BUG15010
     C                   EndSl                                                               CSW207A
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetNostro - Get Nostro parameter for FT001000                *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetNostro     BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   If        HPSNDCOR <> *Blanks                                     BUG15010A
     C                   Movel     HPSNDCOR      ParmStr                                   BUG15010A
     C                   Else                                                              BUG15010A
     C                   Movel     HPRCVCOR      ParmStr                                   BUG15010A
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
     C                   If        HPCCTTYP = 'BI'                                         BUG15010A
     C                   EVAL      ParmStr = HPSNDCOR                                      BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = HPCCTDST                                      BUG15010A
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
      * if valid customer capture Country of location as Parameter to FT001000             BUG15010A
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
     C                   If        %Subst(POrdCu1:1:1) = '/'                               BUG15010A
     C                   EVAL      ParmStr = %SUBST(POrdCu1:2:34)                          BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = POrdCu1                                       BUG15010A
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDS1
     C                   PARM                    OKFlagDS2
     C                   PARM                    OKFlagHS1
     C                   PARM                    OKFlagHS2
      *
      ** Access SAR file to see if CFT004 is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blank
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      CFT004 = 'N'
     C                   ELSE
      *
      ** Database Error
      *
     C                   EVAL      DBKey  =  CFT004
     C                   EVAL      DBFile = 'AOSARDR0'
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      Dbase  = 1
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *Blanks       @RtCd                                        CSW207
                                                                                              CSW207
     C                   IF        @RtCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *
      ** Program, module and procedure names for database error processing.*
      ** The following /COPY sets these values, and also defines LDA as    *
      ** an external data area                                             *
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      **********************************************************************
      *
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  ALPH                                                                                    BUG24639
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                  BUG24639
**  NUMC                                                                                    BUG24639
1234567890                                                                                  BUG24639
