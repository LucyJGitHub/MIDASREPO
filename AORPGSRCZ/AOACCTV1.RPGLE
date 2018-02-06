     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO FT validate account identifier')              *
/*OVR *: OVRDBF FILE(ACCRETL) TOFILE(ACCNTL1) SHARE(*NO)                                     260426A
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOACCTV1 - Validate Account ID                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD030906           Date 13Nov14               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260426A            Date 01Jun09               *
      *                 260426             Date 25May09               *
      *                 260150             Date 07May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15154           Date 26Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA020             Date 12Apr04               *
      *                 226083             Date 31Mar04               *
      *                 221538             Date 31Mar04
      *                 212229             Date 31Mar04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030906 - Counterparty Nostro not defaulted.                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  260426A- Patterned from fix 259769.                          *
      *  260426 - Only chain to ACCNTL1 when not Nostro               *
      *  260150 - Chain to ACCNTL1 is not keyed                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15154 - Customer number is being converted to retail      *
      *             number                                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA020 - Correct 10-digit account code errors.               *
      *  226083 - Correct validation errors in RFT                    *
      *           Here, ParmStr entry is accepted even when           *
      *           trailing characters are inserted.  For example,     *
      *           a valid GL account appended with a few characters   *
      *           should be rejected.                                 *
      *  221538 - Expansion of field details.  Add SWIFT checking.    *
      *  212229 - System converts the customer number to a retail     *
      *           account. Change the checking for *IN90.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
     FACCNT     IF   E           K DISK    IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F*ACCNTL1***IF***E           K DISK    Rename(ACCNTABF:ACCNTABFX)                       260426A
     FACCRETL   IF   E           K DISK    Rename(ACCNTABF:ACCNTABFX)                        260426A
     F                                     USROPN                                            260426A
     FSDNOSTL1  IF   E           K DISK
     FSDCUSTL0  IF   E           K DISK
     FSDCUSTL2  IF   E           K DISK
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
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)
     D A@FMT         E DS                  EXTNAME(ACCNTAB)
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D RunDta        E DS                  EXTNAME(RUNDAT)
      ** External DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Midas Counterparty NOSTROS                                                           221538
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  221538
      ** Midas BIC Directory                                                                  221538
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                                  221538
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAX       E                     EXTFLD(QQDFAC)                                     CGL029
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      /COPY FTCPYSRC,SFTVALCSLE                                                               221538
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D  AccStr         S             35
     D  AccStr1        S             34
     D  ParmStr        S                   Like(AccStr)
 
     D @Type           S                   Like(@RTCD)
     D GLAcc           S                   Like(AccStr)
     DCharCNUM         S              6
     D*CharACOD*       S              4                                                       CGL029
     DCharACOD         S             10                                                       CGL029
     DCharACSQ         S              2
     DChar1            S              1
     DChar3            S              3
     DChar10           S             10
     D A1              S              1    Dim(10)
     D i               S              5u 0
     D j               S              5u 0
     D ##CSID          S              1                                                       221538
     D CMD@            S             60    DIM(1) CTDATA PERRCD(1)                           260426A
 
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
 
     C                   Eval      P@FMT = *Blanks
     C                   Eval      @RTCD = *Blanks
     C                   Eval      AccStr = ParmStr
     C                   Eval      @TYPE = *BLANKS
 
      * If account starts with a '/', remove it.
     C                   If        %Subst(AccStr:1:1) = '/'
     C                   Eval      AccStr1 = %Subst(AccStr:2:34)
     C                   Eval      AccStr = AccStr1
     C                   Endif
 
     C                   CallB     'ZAVALTXT'
     C                   Parm                    RetCode          10
     C                   Parm                    AccStr
 
     C                   If        RetCode <> *Blanks
     C                   Eval      @TYPE = '*NRF   '
     C                   Eval      @RTCD = '*NRF   '
     C                   Return
     C                   Endif
 
 
      *  Account entry for GL Account should be in format :
      *   BbbCcccccAaaaCcySq (18)
 
      *  If in a single branch mode, get default branch from SDBANKPD
      *  If branch code not 1st 3 characters, move default in
 
     C                   Eval      GLAcc  = AccStr
 
      * If 1st 3 characters numeric and single branch mode, move in branch
      *  code.
     C                   Eval      Char3 = %Subst(GLAcc:1:3)
     C                   TESTN                   Char3                20
     C                   If        *In20 AND                                    Numeric
     C                             AGMBIN <> 'Y'
     C                   Eval      GLAcc = BJSBRC + GLAcc
     C                   Endif
 
      * Check to see if a GL Account
      *   Len                            Start
     C     3             Subst     GLAcc:1       BRCA
     C     6             Subst     GLAcc:4       CharCNUM
     C     3             Subst     GLAcc:10      CCY
     C*****4****         Subst     GLAcc:13      CharACOD                                     CGL029
     C*****2****         Subst     GLAcc:17      CharACSQ                                     CGL029
     C     10            Subst     GLAcc:13      CharACOD                                     CGL029
     C     2             Subst     GLAcc:23      CharACSQ                                     CGL029
 
     C                   Movel     CharCNUM      CNUM
     C                   Movel     CharACOD      ACOD
     C                   Movel     CharACSQ      ACSQ
 
     C     KAccnt        Chain     ACCNTABF                           97
     C                   If        NOT *IN97
     C**********                   And %subst(GLAcc:19:17) =  *blank                   226083 TDA020
     C                             And %subst(GLAcc:25:11) =  *blank                          TDA020
     C                   Eval      @TYPE = '*LEDGER'
     C                   Eval      P@FMT = A@FMT
     C                   Else
      *                                                                                     BUG15154
     C     6             Subst     AccStr:1      CharCNUM                                   BUG15154
     C                   Movel     CharCNUM      BBCUST                                     BUG15154
     C     BBCUST        Chain     SDCUSTL0                           97                    BUG15154
     C                   If        %Subst(AccStr:7:29) = *Blanks AND                        BUG15154
     C                             NOT *IN97                                                BUG15154
     C                   Eval      P@FMT = C@FMT                                            BUG15154
     C                   Eval      @TYPE = '*CUSTNO'                                        BUG15154
     C                   Else                                                               BUG15154
 
      ** Retail Account ?  Accntl1
     C                   Eval      ACNO = *Zeros
     C                   Movel     AccStr        Char10
     C                   TESTN                   Char10               31                      260426
     C                   movel     Char10        ACNO                                        260426A
     C**********         If        Char10 <> *Blanks                                         260426A
     C**********                     and *In31 = *ON                                  260426 260426A
     C**********         Exsr      FmtRet                                                    260426A
     C**********         Endif                                                               260426A
     C*****ACNO*         Chain     ACCNTL1                            97                      260150
     C                   If        *In31 = *ON                                                260426
     C*****KAcno         Chain     ACCNTL1                            97              260150 260426A
     C     KAcno         Chain     ACCRETL                            97                     260426A
     C                   EndIf                                                                260426
     C**********         If        %Subst(AccStr:11:24) = *Blanks AND                         226083
     C                   If        %Subst(AccStr:11:25) = *Blanks AND                         226083
     C**********                   NOT *IN97                                                  260426
     C                               *In97 = *Off and *In31 = *On                             260426
     C                   Eval      @TYPE = '*RETAIL'
     C                   Eval      P@FMT = A@FMT
     C                   Eval      ParmStr = *Blanks
     C                   Movel     ACNO          ACNOC            10
     C                   Eval      ParmStr = ACNOC
     C                   Else
 
      ** Nostro Account ?  SDNOSTL1
     C     3             Subst     AccStr:1      A7CYCD
     C     2             Subst     AccStr:4      A7NONB
     C     KNostro       Chain     SDNOSTL1                           97
     C**********         If        %Subst(AccStr:6:29) = *Blanks AND                          226083
     C                   If        %Subst(AccStr:6:30) = *Blanks AND                          226083
     C                             NOT *IN97
     C                   Eval      P@FMT = N@FMT
     C                   Eval      @TYPE = '*NOSTRO'
     C                   Else
 
     C*****6****         Subst     AccStr:1      CharCNUM                                   BUG15154
     C**********         Movel     CharCNUM      BBCUST                                     BUG15154
     C*****BBCUST        Chain     SDCUSTL0                           97                    BUG15154
     C**********         If        %Subst(AccStr:7:29) = *Blanks AND                        BUG15154
     C**********                   NOT *IN97                                                BUG15154
     C**********         Eval      P@FMT = C@FMT                                            BUG15154
     C**********         Eval      @TYPE = '*CUSTNO'                                        BUG15154
     C**********         Else                                                               BUG15154
      *                                                                                      221538
     C     11            Subst     AccStr:1      CLSWTK           12                         221538
     C                   Exsr      SWIFTCHK                                                  221538
     C                   If        ##CSID = 'Y' And                                          221538
     C                             *IN31 = '0' And                                           221538
     C                             *IN32 = '0'                                               221538
     C                   Eval      P@FMT = C@FMT                                             221538
     C                   Eval      @TYPE = '*SWIFT '                                         221538
     C                   If        W9CNST = 'Y'                                             MD030906
     C                   Eval      @TYPE = '*CNST  '                                        MD030906
     C                   Eval      P@FMT = SDCNST                                           MD030906
     C                   Endif                                                              MD030906
     C                   Else                                                                221538
      *                                                                                      221538
 
     C     10            Subst     AccStr:1      BBCSSN
     C     BBCSSN        Chain     SDCUSTL2                           97
     C                   If        %Subst(AccStr:11:25) = *Blanks AND
     C                             NOT *IN97
     C                   Eval      P@FMT = C@FMT
     C                   Eval      @TYPE = '*SHNAME'
     C                   Else
     C                   Eval      @TYPE = '*NRF   '
     C                   Eval      @RTCD = '*NRF   '
 
     C                   Endif                                                                221538
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   IF        @TYPE = '*RETAIL' OR
     C                             @TYPE = '*LEDGER'
     C                   IF        RECI <> 'D'
     C                   Eval      @TYPE = '*NRF   '
     C                   Eval      @RTCD = '*NRF   '
     C                   Endif
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FmtRet - Format Retail Account Numbet                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     FmtRet        Begsr
 
     C                   MoveA     Char10        A1
     C                   Z-add     1             j
     C                   Z-add     10            i
 
      * Find first blank character
     C     ' '           Lookup    A1(j)                                  90
     C**********         If        *In90                                                      212229
     C     *IN90         IFEQ      '0'                                                        212229
     C                   Dow       j > 1
     C                   Sub       1             j
     C                   MoveA     A1(j)         Char1
     C                   MoveA     ' '           A1(j)
     C                   MoveA     Char1         A1(i)
     C                   Sub       1             i
     C                   Enddo
     C                   Endif
 
 
     C                   MoveA     A1            Char10
     C                   Move      Char10        ACNO
 
     C                   Endsr
      /EJECT                                                                                  221538
      *****************************************************************                       221538
      *                                                               *                       221538
      *  SWIFTCHK - Validate SWIFT Address                            *                       221538
      *                                                               *                       221538
      *****************************************************************                       221538
      *                                                                                       221538
     C     SWIFTCHK      BEGSR                                                                221538
      *                                                                                       221538
     C                   Movea     '00'          *IN(31)                                      221538
                                                                                              221538
      ** Test positions 1-8 for valid SWIFT Characters                                        221538
                                                                                              221538
      ** Check how many characters are alphanumeric                                           221538
     C                   Movel     *Blanks       FLD                                          221538
     C                   Movel     CLSWTK        FLD              35                          221538
     C     ALPHAN        Check     FLD           X#                3 0    90                  221538
                                                                                              221538
      * If the first 8 or 11 are ok proceed                                                   221538
     C                   If        *IN90 = *On and                                            221538
     C                             X# = 9      or                                             221538
     C                             *IN90 = *On and                                            221538
     C                             X# = 12                                                    221538
     C     ' '           Check     FLD:X#                                 90                  221538
                                                                                              221538
      ** Check for blanks if before 8 or 11 then assume address                               221538
     C                   If        *IN90 = *On and                                            221538
     C                             X# = 11                                                    221538
     C                   Eval      *IN31 = *On                                                221538
     C                   Eval      ##CSID = 'Y'                                               221538
     C                   Goto      EXSWIFT                                                    221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
                                                                                              221538
      ** Invalid format - Not a S.W.I.F.T.                                                    221538
                                                                                              221538
     C                   If        *IN90 = *On                                                221538
     C                   Eval      ##CSID = 'N'                                               221538
     C                   Goto      EXSWIFT                                                    221538
     C                   Endif                                                                221538
                                                                                              221538
      ** Call Access object to validate identifier                                            221538
                                                                                              221538
     C                   Movel     FLD           W9BICC                                       221538
     C     3             Subst     FLD:9         W9BICB                                       221538
                                                                                              221538
     C                   CALL      'ME1400'                                                   221538
     C                   Parm      *Blanks       W9RTN             7                          221538
     C                   Parm                    W9BICC            8                          221538
     C                   Parm                    W9BICB            3                          221538
     C                   Parm                    C@FMT                                        221538
     C                   Parm                    SDCNST                                       221538
     C                   Parm                    MEBICD                                       221538
     C                   Parm      *Blanks       W9CUST            1                          221538
     C                   Parm      *Blanks       W9CNST            1                          221538
     C                   Parm      *Blanks       W9BICD            1                          221538
                                                                                              221538
     C                   Select                                                               221538
                                                                                              221538
      ** Record not found on directory but found on others                                    221538
      ** - BIC directory has data so error                                                    221538
                                                                                              221538
     C                   When      W9RTN = 'MIN0244' or                                       221538
     C                             W9RTN = 'MIN0245' or                                       221538
     C                             W9RTN = 'MIN0246'                                          221538
     C                   Eval      *IN31 = *On                                                221538
     C                   Eval      ##CSID = 'Y'                                               221538
                                                                                              221538
      ** Record not found - S.W.I.F.T does not exist                                          221538
                                                                                              221538
     C                   When      W9RTN = 'Y2U0005'                                          221538
     C                   Eval      *IN32 = *On                                                221538
     C                   Eval      ##CSID = 'Y'                                               221538
                                                                                              221538
      ** Record found - BIC exists                                                            221538
                                                                                              221538
     C                   When      W9RTN = *Blanks                                            221538
     C                   Eval      ##CSID = 'Y'                                               221538
                                                                                              221538
     C                   Endsl                                                                221538
     CSR   EXSWIFT       ENDSR                                                                221538
      *                                                                                       221538
      *****************************************************************                       221538
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
     C                   Parm                    @RTCD                          B:Return code
     C                   Parm                    @TYPE                          B:Return code
     C                   Parm                    ParmStr                        B:Return code
     C                   Parm                    P@FMT
 
      * GL Account Key List
     C     KAccnt        Klist
     C                   Kfld                    CNUM
     C                   Kfld                    CCY
     C                   Kfld                    ACOD
     C                   Kfld                    ACSQ
     C                   Kfld                    BRCA
 
      * Nostro Klist
     C     KNostro       Klist
     C                   Kfld                    A7CYCD
     C                   Kfld                    A7NONB
 
      * Retail ACNO Klist                                                                     260150
     C     KAcno         Klist                                                                260150
     C                   Kfld                    ACNO                                         260150
                                                                                              260150
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*FIRST   '   @Optn
     C     Sdbank        Parm      Sdbank        Dsfdy
 
     C                   If        @Rtcd <> *Blanks
     C                   Eval      dbfile = 'SDBANKPD'
     C                   Eval      dbase = 1
     C                   Eval      dbkey = '*FIRST'
     C                   Exsr      *PSSR
     C                   Endif
 
     C     *DTAARA       Define    RUNDAT        RunDta
     C                   In        RunDta
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
     C     @OPEN@        IFNE      'Y'                                                       260426A
     C                   MOVEL     'Y'           @OPEN@            1                         260426A
     C                   Z-ADD     60            @P2@             15 5                       260426A
     C                   MOVEL     CMD@(1)       @P1@             60                         260426A
     C                   CALL      'QCMDEXC'                                                 260426A
     C                   PARM                    @P1@                                        260426A
     C                   PARM                    @P2@                                        260426A
     C                   OPEN      ACCRETL                                                   260426A
     C                   END                                                                 260426A
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  CMD@
OVRDBF ACCRETL ACCNTL1 SHARE(*NO) OVRSCOPE(*JOB)
