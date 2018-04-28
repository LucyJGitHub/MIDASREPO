     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT FTM101UPPsitions file')                       *
      *****************************************************************
      *                                                               *
      *  Midas - CCT Confirmation                                     *
      *                                                               *
      *  FT101APS   - Update Positions file                           *
      *                                                               *
      * This routine can be called interactively or from FT0300       *
      * to confirm and write details of the CCT transaction.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 AR750695           Date 26Apr11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      *                 BUG24864           Date 13Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 TDA020             Date 14Apr04               *
      *                 219765             Date 13Apr04               *
      *                 212229             Date 13Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 213054             Date 09Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185699             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184182             Date 28Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177669             Date 10Apr00               *
      *                 CFT006  *CREATE    Date 14Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR750695 - RFTD fails to create shadow postings. Expected    *
      *             data of core fix 212229 are not passed from *VU   *
      *             programs. Fix done as part of ABC Phase2 (CAP207) *
      *             (Child: AR750696)                                 *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  BUG24864 - Incorrect parameter                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA020 - Specify prefix in ACCNTAB record to avoid conflicts.*
      *  219765 - Post receiver's charges properly and separately.    *
      *  212229 - Every amendment on the transaction produces Unnece- *
      *           ssary Dr/Cr postings. Shadow posting for amendment  *
      *           should only be created when there's a change in     *
      *           account/amount/date.                                *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  213054 - Correct condition used in validating account number *
      *  185699 - Do not do shadow post if OP to be generated         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184182 - Incorrect field length passed to AOACCTV1           *
      *  177669 - Not validating retail account                       *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
     FFT101HL3  IF   E           K DISK    PREFIX(FH)
     FFT101DL0  IF   E           K DISK    PREFIX(FD)
 
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
                                                                                              CRE020
      ** Midas Switchable features file accessed via access program                           CRE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
                                                                                              CRE020
      ** First DS for access programs, short data structure                                   CRE020
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE020
 
      * AOSPOSU0 datastructure parameter
     DC#DTA            DS           256
     D C#ATYP                  1      1
     D***C#ACCT*                 2     19                                                     CGL029
     D***C#CNU1*                 2      7  0                                                AR750695
     D C#CNU1                  2      7                                                     AR750695
     D C#CCY1                  8     10
     D***C#ACO1*                11     14  0                                                  CGL029
     D C#ACS1                 15     16  0
     D C#BRC1                 17     19
     D C#NOSN                  2      3  0
     D C#NOS                   2      6
     D C#ACNO                  2     11  0
     D***C#CNUM                  2      7  0                                                AR750695
     D C#CNUM                  2      7                                                     AR750695
     D***C#ACOD*                 8     11  0                                                  CGL029
     D C#ACSQ                 12     13  0
     D C#BRCA                 14     16
     D C#IO                   24     24
     D C#CCY                  25     27
     D C#TRYP                 28     29
     D C#NARR                 30     59
     D C#CHQN                 60     67  0
     D C#PREF                 68     82
     D C#TRN                  83     88
     D C#AMT                  89     96P 0
     D C#PRON                 97     97
     D C#OLPS                 98     98
     D C#MEMS                 99     99
     D C#RSAC                100    100
     D C#MOD                 101    102
     D C#OLRC                103    104
     D C#FTOV                105    105
     D C#VDAT                106    108P 0
     D C#PSTD                109    111P 0
     D C#PSTO                112    112
     D C#RPST                113    113
     D C#RPNB                114    116  0
     D C#RTYP                117    117
     D C#BBRN                118    120  0                                                    CGL029
     D C#ACO1                121    130  0                                                    CGL029
     D C#ACOD                131    140  0                                                    CGL029
     D C#OTR1                141    160                                                       CAP204
     D C#MTYP                161    161                                                       CAP205
 
      ** Exception Reference Id/Number                                                        CLE134
     D C#XRFI                162    164                                                       CLE134
     D C#XRFN                165    174  0                                                    CLE134
                                                                                              CGL029
      ** Full General Ledger - CNUM/CCY/ACOD/ACSQ                                             CGL029
     D                 DS                                                                     CGL029
     D C#ACCT                  1     24                                                       CGL029
     D***W#CNU1                  1      6  0                                         CGL029 AR750695
     D W#CNU1                  1      6                                                     AR750695
     D W#CCY1                  7      9                                                       CGL029
     D W#ACO1                 10     19  0                                                    CGL029
     D W#ACS1                 20     21  0                                                    CGL029
     D W#BRC1                 22     24                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Acc             S             35
     D TmpA            S                   Like(Acc)
 
     D  AddRemove      S              1
     D  Action         S              1
 
     D  HdrInfo        S              1
     D  DtlInfo        S              1
 
     D W0ACT           S              8
     D***C#AcctN         S             18  0                                           213054 CGL029
     D C#AcctN         S             24  0                                                    CGL029
 
     D  WorkAmt        S                   Like(FDPAYAMT)
     D CFT004          S              1    INZ('N')                                           212229
     D CAP205          S              1                                                       CAP205
     D IBANRetCde      S              7                                                       212229
     D P@IBAN          S             34                                                       212229
     D ACCTRetCde      S              7                                                       219765
     D W#AccNum        S             35                                                       219765
     D P@TYPE          S              7                                                       219765
                                                                                     177669
     D P@FMT         E DS                  EXTNAME(DSSDY)                            177669
     D @Type           S                   Like(@RTCD)
     D AccRecord     E DS                  EXTNAME(ACCNTAB)                                   212229
     D                                     PREFIX(AC)                                         TDA020
      ** First DS for access programs, short data structure                                   212229
     D PHdrRcdIn     E DS                  EXTNAME(FT101HPD) PREFIX(PH)                       212229
      *                                                                                       212229
      ** Previous Incoming Debit Details                                                      212229
     D PDtlRcdIn     E DS                  EXTNAME(FT101DPD) PREFIX(PD)                       212229
      *                                                                                       212229
      ** Current Incoming Debit Header Details                                                212229
     D NHdrRcdIn     E DS                  EXTNAME(FT101HPD) PREFIX(NH)                       212229
      *                                                                                       212229
      ** Current Incoming Debit Details                                                       212229
     D NDtlRcdIn     E DS                  EXTNAME(FT101DPD) PREFIX(ND)                       212229
      *                                                                                       212229
                                                                                              CRE020
     D CRE020          S              1                                                       CRE020
     D PRTCD           S              7                                                       CRE020
     D POPTN           S              7                                                       CRE020
     D PSARD           S              6                                                       CRE020
     D WSequence       S              3                                                       CRE020
                                                                                              CRE020
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *
      *  Reset Work Variables
     C                   EXSR      *INZSR                                                     212229
     C                   Eval      RetCodeIn  = *BlankS
 
     C                   If        AddRemove = 'R'
     C                   Exsr      Remove
     C                   Else
     C                   Exsr      AddPos
     C                   Endif
 
     C                   Exsr      Ex@Pgm
 
      /EJECT
      *****************************************************************
      *                                                               *
      * Remove     : Remove forward position amounts                  *
      *                                                               *
      * Called by: Main.                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Remove        Begsr
 
      * Remove all header and detail positions.
     C                   Eval      *In55 = *Off
     C     FHRFTID       Chain     FT101HL3                           55
 
     C                   If        *In55
     C                   Exsr      Ex@Pgm
     C                   Endif
 
     C*******************Exsr      Oth_Proc
 
     C                   Eval      *In55 = *Off
     C     FHRFTID       Setll     FT101DL0
     C     FHRFTID       ReadE     FT101DL0                               55
     C                   Dow       *In55 = *Off
      * Only if outgoing not to be generated                                    185699
     C     FDGOPFLG      Ifne      'Y'                                          185699
     C     HDRINFO       IFEQ      'Y'                                                        212229
     C     DTLINFO       OREQ      'Y'                                                        212229
     C     NDTRNSID      ANDEQ     FDTRNSID                                                   212229
     C     ACTION        IFNE      'I'                                                        212229
     C                   Exsr      Oth_Proc
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
     C                   Endif                                                  185699
      *                                                                         185699
     C     FHRFTID       ReadE     FT101DL0                               55
     C                   Enddo
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AddPos     : Add Positions file                               *
      *                                                               *
      * Called by: Main.                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     AddPos        Begsr
 
      * Add all header and detail positions.
     C                   Eval      *In55 = *Off
     C     FHRFTID       Chain     FT101HL3                           55
 
     C                   If        *In55
     C                   Exsr      Ex@Pgm
     C                   Endif
 
     C                   Eval      *In55 = *Off
     C     FHRFTID       Setll     FT101DL0
     C     FHRFTID       ReadE     FT101DL0                               55
     C                   Dow       *In55 = *Off
      * Only if outgoing not to be generated                                    185699
     C     FDGOPFLG      Ifne      'Y'                                          185699
     C     HDRINFO       IFEQ      'Y'                                                      AR750695
     C     DTLINFO       OREQ      'Y'                                                      AR750695
     C     NDTRNSID      ANDEQ     FDTRNSID                                                 AR750695
     C                   Exsr      Oth_Proc
     C                   Endif                                                              AR750695
     C                   Endif                                                  185699
      *                                                                         185699
     C     FHRFTID       ReadE     FT101DL0                               55
     C                   Enddo
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Oth_Proc   : Call Other Subroutines                           *
      *                                                               *
      * Called by: Main.                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Oth_Proc      Begsr
      *  Create Shadow Postings
 
      *  1.  Clear AOSPOSR0 arrays
     C                   Exsr      Clr_AOSPOS
 
      *  2.  Add AOSPOSR0 data
     C                   Exsr      Add_AOSPOS
 
      *  3.  Update positions
     C                   Exsr      Upd_AOSPOS
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr_AOSPOS : Clear AOSPOS arrays                              *
      *                                                               *
      * Called by: Main.                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_AOSPOS    Begsr
     C                   Clear                   C#DTA
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*CLEAR'      W0ACT                        Why 8?
     C                   PARM      C#DTA         O#DTA           256
      *
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Clr_AOSPOS'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_AOSPOS - Add AOSPOS data                                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Add_AOSPOS    Begsr
 
      *         S E T T L E M E N T     D E T A I L S
 
      * Move data : Amount
 
     C                   Select
      * If incoming, debit sending institution / senders corr / rcv corr
      * INCOMING MT101 : CREDIT
     C                   When      FHPYTP   = 'RI'
 
     C                   Select
      * Ordering Customer Header
     C                   When      FHCUSTTP = 'G'  OR
     C                             FHCUSTTP = 'R'  OR
     C                             FHCUSTTP = 'I'  OR
     C**********                   FHCUSTTP = 'F'                                           BUG24864
     C                             FHCUSTTP = 'F'  OR                                       BUG24864
     C                             FHCUSTTP = 'C'                                           BUG24864
     C                   Eval      C#ATYP = FHCUSTTP
     C                   Eval      TmpA   = FHHOCUS1
     C                   Exsr      FmtAcc
 
      * Ordering Customer Detail
     C                   When      FDDCUSTP = 'G'  OR
     C                             FDDCUSTP = 'R'  OR
     C                             FDDCUSTP = 'I'  OR
     C**********                   FDDCUSTP = 'F'                                           BUG24864
     C                             FDDCUSTP = 'F'  OR                                       BUG24864
     C                             FDDCUSTP = 'C'                                           BUG24864
     C                   Eval      C#ATYP = FDDCUSTP
     C                   Eval      TmpA   = FDTOCUS1
     C                   Exsr      FmtAcc
 
     C                   Endsl
      *                                                                                       219765
      ** Save debit account for charges processing in SRCVCharges                             219765
     C**********         Move      C#ACCT        DRAcct           18                 219765 AR750695
     C                   Move      C#ACCT        DRAcct           24                        AR750695
     C                   Move      C#ATYP        DRAtyp            1                          219765
 
     C                   Eval      C#AMT = FDTRNAMT
      *                                                                                       219765
      ** Charges will be posted separately in SRCBCharges                                     219765
     C**********         If        FHHANDAC <> *Blank                                         212229
     C*****FDCHGACC      IFEQ      *BLANK                                              212229 219765
     C**********         If        FDTDCHGS = 'OUR' OR                                        219765
     C**********                   FDTDCHGS = 'SHA'                                           219765
     C**********         Add       FDRCTCHG      C#AMT                                        219765
     C**********         Endif                                                                219765
     C**********         Endif                                                                219765
 
     C                   If        AddRemove = 'R'
     C                   Mult      -1            C#Amt
     C                   Endif
 
      * Debit Value Date
     C                   Eval      C#VDAT   =    FHDBTVDT
     C                   Eval      C#IO     =    'I'
      * Transfer Currency
     C                   Eval      C#CCY    =    FDTRNCCY
      * Other fields
     C                   Eval      C#TRYP   =    FHPytp
     C                   Eval      C#PREF   =    FHRFTID
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHRFTID                                      CRE020
     C                   Z-ADD     0             C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
 
     C     HDRINFO       IFEQ      'Y'                                                        212229
     C     PHHOCUS1      IFNE      NHHOCUS1                                                   212229
     C     PHHANDAC      ORNE      NHHANDAC                                                   212229
     C     PHDBTVDT      ORNE      NHDBTVDT                                                   212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
     C     FTSTP         IFNE      'Y'                                                        212229
     C     DTLINFO       IFEQ      'Y'                                                        212229
     C     PDTOCUS1      IFNE      NDTOCUS1                                                   212229
     C*****PDTDCHGS      ORNE      NDTDCHGS                                            212229 219765
     C*****PDTDCHGS      ANDEQ     'BEN'                                               212229 219765
     C*****PDTDCHGS      ORNE      NDTDCHGS                                            212229 219765
     C*****NDTDCHGS      ANDEQ     'BEN'                                               212229 219765
     C     PDTRNAMT      ORNE      NDTRNAMT                                                   212229
     C*****PDRCTCHG      ORNE      NDRCTCHG                                            212229 219765
     C*****PDTDCHGS      ANDNE     'BEN'                                               212229 219765
     C     PDTRNCCY      ORNE      NDTRNCCY                                                   212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                      AR750695
     C                   MOVEL     'F'           C#MTYP                                     AR750695
     C                   ENDIF                                                              AR750695
     C                   EXSR      Do_Add_Spos                                                212229
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
 
      * Charges Account
     C**********         If        FHHANDAC <> *Blank                                         212229
     C     FDCHGACC      IFNE      *BLANK                                                     212229
     C                   Eval      TmpA   = FDCHGACC                                          212229
     C                   EXSR      ValAccnt                                                   212229
     C                   MOVEL     WACCTTP       C#ATYP                                       212229
     C                   EXSR      FmtAcc                                                     212229
      *                                                                                       219765
      ** Save Chargeaccount for charges processing in SRCVCharges                             219765
     C**********         Move      C#ACCT        CHAcct           18                 219765 AR750695
     C                   Move      C#ACCT        CHAcct           24                        AR750695
     C                   Move      C#ATYP        CHAtyp            1                          219765
      *                                                                                       219765
      **  This charge posting to charge account is moved to SRCVCharges                       219765
     C**********         If        FDTDCHGS = 'OUR' OR                                        219765
     C**********                   FDTDCHGS = 'SHA'                                           219765
     C**********         Z-Add     FDRCTCHG      C#AMT                                        219765
     C**********         Endif                                                                219765
 
     C**********         If        AddRemove = 'R'                                            219765
     C**********         Eval      C#AMT =  C#AMT * - 1                                       219765
     C**********         Endif                                                                219765
 
      **Debit*Value Date                                                                      219765
     C**********         Eval      C#VDAT   =    FHDBTVDT                                     219765
     C**********         Eval      C#IO     =    'I'                                          219765
      **Transfer Currency                                                                     219765
     C**********         Eval      C#CCY    =    FHHANDCY                                     212229
     C**********         MOVE      FDRCHCCY      C#CCY                                 212229 219765
      **Other*fields                                                                          219765
     C**********         Eval      C#TRYP   =    FHPytp                                       219765
     C**********         Eval      C#PREF   =    FHRFTID                                      219765
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHRFTID                                      CRE020
     C                   Z-ADD     0             C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C**********         Eval      C#MOD    =    'FT'                                         219765
     C**********         Eval      C#OLRC   =    '01'                                         219765
     C**********         Eval      C#FTOV   =  'Y'                                            219765
 
     C*****HDRINFO       IFEQ      'Y'                                                 212229 219765
     C*****PHDBTVDT      IFNE      NHDBTVDT                                            212229 219765
     C*****ACTION        OREQ      'D'                                                 212229 219765
     C**********         Exsr      Do_Add_Spos                                                219765
     C**********         ENDIF                                                         212229 219765
     C**********         ENDIF                                                         212229 219765
     C*****DTLINFO       IFEQ      'Y'                                                 212229 219765
     C*****PDTDCHGS      IFNE      NDTDCHGS                                            212229 219765
     C*****PDTDCHGS      ANDEQ     'BEN'                                               212229 219765
     C*****PDTDCHGS      ORNE      NDTDCHGS                                            212229 219765
     C*****NDTDCHGS      ANDEQ     'BEN'                                               212229 219765
     C*****PDRCTCHG      ORNE      NDRCTCHG                                            212229 219765
     C*****PDTDCHGS      ANDNE     'BEN'                                               212229 219765
     C*****PDCHGACC      ORNE      NDCHGACC                                            212229 219765
     C*****PDRCHCCY      ORNE      NDRCHCCY                                            212229 219765
     C*****ACTION        OREQ      'D'                                                 212229 219765
     C**********         EXSR      Do_Add_Spos                                         212229 219765
     C**********         ENDIF                                                         212229 219765
     C**********         ENDIF                                                         212229 219765
     C                   Endif
 
 
     C                   MOVE      *BLANKS       ACCTUSED          3                          212229
      * Credit Amount
      * Beneficiary
     C                   Select
     C                   When      FDBENTTP = 'G'  OR
     C                             FDBENTTP = 'R'  OR
     C                             FDBENTTP = 'I'  OR
     C                             FDBENTTP = 'F'
     C                   Eval      C#ATYP = FDBENTTP
     C                   Eval      TmpA   = FDTBNA35
     C                   MOVE      'BEN'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Account With Institution
     C                   When      FDAWITTP = 'G'  OR
     C                             FDAWITTP = 'R'  OR
     C                             FDAWITTP = 'I'  OR
     C                             FDAWITTP = 'F'
     C                   Eval      C#ATYP = FDAWITTP
     C                   Eval      TmpA   = FDTACA35
     C                   MOVE      'AWI'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
      * Intermediary
     C                   When      FDINTTTP = 'G'  OR
     C                             FDINTTTP = 'R'  OR
     C                             FDINTTTP = 'I'  OR
     C                             FDINTTTP = 'F'
     C                   Eval      C#ATYP = FDINTTTP
     C                   Eval      TmpA   = FDTINST1
     C                   MOVE      'INT'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      ** Save credt account for charges processing in SRCVCharges                             219765
     C**********         Move      C#ACCT        CRAcct           18                 219765 AR750695
     C                   Move      C#ACCT        CRAcct           24                        AR750695
     C                   Move      C#ATYP        CRAtyp            1                          219765
      *                                                                                       219765
      * Amount
     C                   Eval      C#AMT = FDPAYAMT
      * BEN charge shadow posting is now done separately in SRCVCharges                       219765
     C**********         If        FDTDCHGS = 'BEN'                                           219765
     C**********         Sub       FDRCPCHG      C#AMT                                        219765
     C**********         Endif                                                                219765
 
     C                   If        AddRemove = 'A'
     C                   Eval      C#Amt = C#Amt * - 1
     C                   Endif
 
      * Debit Value Date
     C                   Eval      C#VDAT   =    FDCRDVDT
     C                   Eval      C#IO     =    'I'
      * Transfer Currency
     C                   Eval      C#CCY    =    FDPAYCCY
      * Other fields
     C                   Eval      C#TRYP   =    FHPytp
     C                   Eval      C#PREF   =    FHRFTID
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHRFTID                                      CRE020
     C                   EVAL      WSequence = %SUBST(FDTRNSID:14:3)                          CRE020
     C                   MOVE      WSequence     C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
 
     C     DTLINFO       IFEQ      'Y'                                                        212229
     C     ACCTUSED      IFEQ      'BEN'                                                      212229
     C     PDTBNA35      ANDNE     NDTBNA35                                                   212229
     C     ACCTUSED      OREQ      'AWI'                                                      212229
     C     PDTACA35      ANDNE     NDTACA35                                                   212229
     C     ACCTUSED      OREQ      'INT'                                                      212229
     C     PDTINST1      ANDNE     NDTINST1                                                   212229
     C     PDPAYAMT      ORNE      NDPAYAMT                                                   212229
     C*****PDTDCHGS      ORNE      NDTDCHGS                                            212229 219765
     C*****PDRCPCHG      ORNE      NDRCPCHG                                            212229 219765
     C*****PDTDCHGS      ANDEQ     'BEN'                                               212229 219765
     C     PDCRDVDT      ORNE      NDCRDVDT                                                   212229
     C     PDPAYCCY      ORNE      NDPAYCCY                                                   212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
     C     HDRINFO       IFEQ      'Y'                                                        212229
     C     ACTION        ANDEQ     'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      Do_Add_Spos                                                212229
     C                   ENDIF                                                                212229
      *                                                                                       219765
      ** Receiver's Charges shadow posting                                                    219765
     C                   If        FDRCVCHG <> 0                                              219765
     C                   Exsr      SRCVCharges                                                219765
     C                   Endif                                                                219765
 
 
      * OUTGOING MT101 : CREDIT
     C                   When      FHPytp   = 'RO'
 
      * Handling Charge Account
     C                   If        FHHANDAC <> *Blanks
 
     C                   Eval      TmpA = FHHANDAC                                   184182
 
     C                   CallB     'AOACCTV1'                                        177669
     C                   Parm      *Blanks       @Rtcd                               177669
     C                   Parm      *Blanks       @Type             7                 177669
     C                   Parm                    TmpA                                184182
     C*******************Parm                    FHHANDAC                            177669
     C                   Parm                    P@FMT                               177669
                                                                                     177669
     C                   If        @Type = '*LEDGER'                                 177669
     C                   Eval      C#ATYP = 'G'                                      177669
     C                   Else                                                        177669
     C                   Eval      C#ATYP = 'R'                                      177669
     C                   Endif                                                       177669
                                                                                     177669
     C                   Eval      TmpA   = FHHANDAC
     C                   Exsr      FmtAcc
 
      * Settlement Value Date
     C                   Eval      C#VDAT   =    FHINDATE
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    FHHANDCY
      * Other fields
     C                   Eval      C#TRYP   =    FHPytp
     C                   Eval      C#PREF   =    FHRFTID
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHRFTID                                      CRE020
     C                   Z-ADD     0             C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#AMT    =    FHHANDCG
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
     C     AddRemove     IFEQ      'R'                                                        212229
     C                   MULT      -1            C#AMT                                        212229
     C                   ENDIF                                                                212229
 
     C     HDRINFO       IFEQ      'Y'                                                        212229
     C     PHHANDAC      IFNE      NHHANDAC                                                   212229
     C     PHINDATE      ORNE      NHINDATE                                                   212229
     C     PHHANDCY      ORNE      NHHANDCY                                                   212229
     C     PHHANDCG      ORNE      NHHANDCG                                                   212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
     C     DTLINFO       IFEQ      'Y'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   EVAL      C#MTYP = 'F'                                               CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      Do_Add_Spos                                                212229
     C                   ENDIF                                                                212229
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Upd_AOSPOS - Update AOSPOS                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Upd_AOSPOS    Begsr
 
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*UPDATE'     W0ACT
     C                   PARM      C#DTA         O#DTA           256
      *
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 5
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Upd_AOSPOS'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Cmt_AOSPOSU0 Commit changes to shadow postings                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Cmt_AOSPOS    Begsr
 
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*COMMIT'     W0ACT
     C                   PARM      C#DTA         O#DTA           256
      *
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 5
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Upd_AOSPOS'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Do_Add_Spos : Add the AOSPOS records                          *
      *                                                               *
      * Called by: Various.                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Do_Add_Spos   Begsr
 
     C                   Move      C#Acct        C#AcctN                                      213054
                                                                                              213054
     C**********         If        C#Acct <> *Blanks                                          213054
     C                   If        C#AcctN <> *Zeros                                          213054
 
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*ADD   '     W0ACT
     C                   PARM      C#DTA         O#DTA           256
 
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Do_add_Spos'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************                       219765
      *                                                               *                       219765
      * SRCVCharges : Receiver's Charges shadow posting               *                       219765
      *                                                               *                       219765
      * Called by: Add_AOSPOS (on 'RI' only)                          *                       219765
      *                                                               *                       219765
      *****************************************************************                       219765
     C     SRCVCharges   Begsr                                                                219765
                                                                                              219765
     C                   Move      *blanks       ChgUpd            1                          219765
                                                                                              219765
     C                   Select                                                               219765
      *                                                                                       219765
     C                   When      FDTDCHGS = 'BEN'                                           219765
      *                                                                                       219765
      * Set conditions when postings can be updated (part of fix 212229 deleted               219765
      * in Add_AOS   is moved here)                                                           219765
     C     DTLINFO       IFEQ      'Y'                                                        219765
     C     ACCTUSED      IFEQ      'BEN'                                                      219765
     C     PDTBNA35      ANDNE     NDTBNA35                                                   219765
     C     ACCTUSED      OREQ      'AWI'                                                      219765
     C     PDTACA35      ANDNE     NDTACA35                                                   219765
     C     ACCTUSED      OREQ      'INT'                                                      219765
     C     PDTINST1      ANDNE     NDTINST1                                                   219765
     C     PDTDCHGS      ORNE      NDTDCHGS                                                   219765
     C     PDRCPCHG      ORNE      NDRCPCHG                                                   219765
     C     PDTDCHGS      ANDEQ     'BEN'                                                      219765
     C     PDCRDVDT      ORNE      NDCRDVDT                                                   219765
     C     PDPAYCCY      ORNE      NDPAYCCY                                                   219765
     C     ACTION        OREQ      'D'                                                        219765
     C                   Movel     'Y'           ChgUpd                                       219765
     C                   Eval      C#ACCT = CRAcct                                            219765
     C                   Eval      C#ATYP = CRAtyp                                            219765
     C                   Eval      C#CCY  = FDPAYCCY                                          219765
     C                   Eval      C#AMT  = FDRCPCHG                                          219765
     C                   Eval      C#VDAT = FDCRDVDT                                          219765
     C                   ENDIF                                                                219765
     C                   ENDIF                                                                219765
      *                                                                                       219765
     C                   When      FDTDCHGS = 'OUR'                                           219765
     C                             AND FDCHGACC =  *blank                                     219765
     C                             OR  FDTDCHGS = 'SHA'                                       219765
     C                             AND FDCHGACC =  *blank                                     219765
      *                                                                                       219765
      * Set conditions when postings can be updated (part of fix 212229 deleted               219765
      * in Add_AOS   is moved here)                                                           219765
     C     HDRINFO       IFEQ      'Y'                                                        219765
     C     PHHOCUS1      IFNE      NHHOCUS1                                                   219765
     C     PHDBTVDT      ORNE      NHDBTVDT                                                   219765
     C     ACTION        OREQ      'D'                                                        219765
     C                   Movel     'Y'           ChgUpd                                       219765
     C                   Endif                                                                219765
     C                   Endif                                                                219765
      *                                                                                       219765
     C     FTSTP         IFNE      'Y'                                                        219765
     C     DTLINFO       IFEQ      'Y'                                                        219765
     C     PDTOCUS1      IFNE      NDTOCUS1                                                   219765
     C     PDTDCHGS      ORNE      NDTDCHGS                                                   219765
     C     PDTDCHGS      ANDEQ     'BEN'                                                      219765
     C     PDTDCHGS      ORNE      NDTDCHGS                                                   219765
     C     NDTDCHGS      ANDEQ     'BEN'                                                      219765
     C     PDRCTCHG      ORNE      NDRCTCHG                                                   219765
     C     PDTRNCCY      ORNE      NDTRNCCY                                                   219765
     C     ACTION        OREQ      'D'                                                        219765
     C                   Movel     'Y'           ChgUpd                                       219765
     C                   ENDIF                                                                219765
     C                   ENDIF                                                                219765
     C                   ENDIF                                                                219765
      *                                                                                       219765
     C     ChgUpd        IFEQ      'Y'                                                        219765
     C                   Eval      C#ACCT = DRAcct                                            219765
     C                   Eval      C#ATYP = DRAtyp                                            219765
     C                   Eval      C#CCY  = FDTRNCCY                                          219765
     C                   Eval      C#AMT  = FDRCTCHG                                          219765
     C                   Eval      C#VDAT = FHDBTVDT                                          219765
     C                   Endif                                                                219765
      *                                                                                       219765
     C                   When      FDTDCHGS = 'OUR'                                           219765
     C                             AND FDCHGACC <> *blank                                     219765
     C                             OR  FDTDCHGS = 'SHA'                                       219765
     C                             AND FDCHGACC <> *blank                                     219765
      *                                                                                       219765
      * Set conditions when postings can be updated (part of fix 212229 deleted               219765
      * in Add_AOS   is moved here)                                                           219765
     C     HDRINFO       IFEQ      'Y'                                                        219765
     C     PHDBTVDT      ORNE      NHDBTVDT                                                   219765
     C     ACTION        OREQ      'D'                                                        219765
     C                   Movel     'Y'           ChgUpd                                       219765
     C                   Endif                                                                219765
      *                                                                                       219765
     C     DTLINFO       IFEQ      'Y'                                                        219765
     C     PDTDCHGS      IFNE      NDTDCHGS                                                   219765
     C     PDTDCHGS      ANDEQ     'BEN'                                                      219765
     C     PDTDCHGS      ORNE      NDTDCHGS                                                   219765
     C     NDTDCHGS      ANDEQ     'BEN'                                                      219765
     C     PDRCTCHG      ORNE      NDRCTCHG                                                   219765
     C     PDCHGACC      ORNE      NDCHGACC                                                   219765
     C     PDRCHCCY      ORNE      NDRCHCCY                                                   219765
     C     ACTION        OREQ      'D'                                                        219765
     C                   Movel     'Y'           ChgUpd                                       219765
     C                   ENDIF                                                                219765
     C                   ENDIF                                                                219765
      *                                                                                       219765
     C     ChgUpd        IFEQ      'Y'                                                        219765
     C                   Eval      C#ACCT = CHAcct                                            219765
     C                   Eval      C#ATYP = CHAtyp                                            219765
     C                   Eval      C#CCY  = FDTRNCCY                                          219765
     C                   Eval      C#AMT  = FDRCTCHG                                          219765
     C                   Eval      C#VDAT = FHDBTVDT                                          219765
     C                   Endif                                                                219765
      *                                                                                       219765
     C                   Endsl                                                                219765
                                                                                              219765
     C     ChgUpd        Ifeq      'Y'                                                        219765
     C                   If        AddRemove = 'R'                                            219765
     C                   Mult      -1            C#Amt                                        219765
     C                   Endif                                                                219765
     C                   Eval      C#IO     =    'I'                                          219765
      * Other fields                                                                          219765
     C                   Eval      C#TRYP   =    FHPytp                                       219765
     C                   Eval      C#PREF   =    FHRFTID                                      219765
     C                   Eval      C#MOD    =    'FT'                                         219765
     C                   Eval      C#OLRC   =    '01'                                         219765
     C                   Eval      C#FTOV   =  'Y'                                            219765
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
                                                                                              219765
     C                   Exsr      Do_Add_Spos                                                219765
     C                   Endif                                                                219765
                                                                                              219765
     C                   Endsr                                                                219765
      *****************************************************************                       219765
      /EJECT                                                                                  219765
      *****************************************************************
      *                                                               *
      * EX@PGM - Exit Program                                         *
      *                                                               *
      * Called by: Various.                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     EX@PGM        Begsr
     C                   Return
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FmtAcc - Formats Account into CcccccyyyAaaaBbbSe              *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     FmtAcc        Begsr
 
     C                   If        %Subst(TmpA:1:1) = '/'
     C                   Eval      Acc  = %Subst(TmpA:2:34)
     C                   Eval      TmpA = *Blanks
     C                   Eval      TmpA = Acc
     C                   Endif
 
     C                   If        C#ATYP = 'G'
     C**********         Eval      %Subst(Acc:1:6) = %Subst(TmpA:4:9)                         CGL029
     C**********         Eval      %Subst(Acc:7:9) = %Subst(TmpA:10:12)                       CGL029
     C**********         Eval      %Subst(Acc:10:13) = %Subst(TmpA:13:16)                     CGL029
     C**********         Eval      %Subst(Acc:14:15) = %Subst(TmpA:17:18)                     CGL029
     C**********         Eval      %Subst(Acc:16:18) = %Subst(TmpA:1:3)                       CGL029
                                                                                              CGL029
     C                   Eval      %Subst(Acc:1:6) = %Subst(TmpA:4:6)                         CGL029
     C                   Eval      %Subst(Acc:7:3) = %Subst(TmpA:10:3)                        CGL029
     C                   Eval      %Subst(Acc:10:10) = %Subst(TmpA:13:10)                     CGL029
     C                   Eval      %Subst(Acc:20:2) = %Subst(TmpA:23:2)                       CGL029
     C                   Eval      %Subst(Acc:22:3) = %Subst(TmpA:1:3)                        CGL029
 
     C                   Eval      C#ACCT = Acc
     C                   Else
 
     C                   If        C#ATYP = 'R'
     C                   CallB     'AOACCTV1'
     C                   Parm                    @RTCD                          B:Return code
     C                   Parm                    @TYPE                          B:Return code
     C     TmpA          Parm                    TmpA                           B:Return code
     C                   Parm                    P@FMT
 
     C                   Eval      C#ACCT = TmpA
     C                   Movel     TmpA          C#ACNO                                     AR750695
 
     C                   Else
     C                   Eval      C#ACCT = TmpA
     C                   Endif
     C                   Endif
                                                                                              CGL029
     C                   If        C#ATYP <> 'R'                                            AR750695
     C                   EVAL      C#CNU1 = W#CNU1                                            CGL029
     C                   EVAL      C#CCY1 = W#CCY1                                            CGL029
     C                   EVAL      C#ACO1 = W#ACO1                                            CGL029
     C                   EVAL      C#ACS1 = W#ACS1                                            CGL029
     C                   EVAL      C#BRC1 = W#BRC1                                            CGL029
     C                   Endif                                                              AR750695
 
     C                   Endsr
      /EJECT
      *****************************************************************                       212229
      *                                                               *                       212229
      * ValAccnt - Validate/retreive details of account entered       *                       212229
      *            in Ordering Customer field.                        *                       212229
      *                                                               *                       212229
      * Called by: Add_AOSPOS                                         *                       212229
      *                                                               *                       212229
      * Calls: AOIBANR2, AOACCTV1                                     *                       212229
      *                                                               *                       212229
      *****************************************************************                       212229
     C     ValAccnt      BEGSR                                                                212229
      *                                                                                       212229
     C                   CLEAR                   AccRecord                                    212229
      *                                                                                       212229
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.                  212229
     C                   IF        CFT004 = 'Y'                                               212229
      *                                                                                       212229
     C                   CALLB     'AOIBANR2'                                                 212229
     C                   PARM      *Blanks       IBANRetCde                                   212229
     C                   PARM                    P@IBAN                                       212229
     C                   PARM      *Blanks       AccRecord                                    212229
      *                                                                                       212229
     C                   ELSE                                                                 212229
     C                   MOVEL     'Dummy'       IBANRetCde                                   212229
     C                   MOVEL     *Blanks       P@IBAN                                       212229
     C                   ENDIF                                                                212229
                                                                                              212229
     C                   CallB     'AOACCTV1'                                                 212229
     C                   Parm                    @RTCD                                        212229
     C                   Parm                    @TYPE                                        212229
     C                   Parm                    TmpA                                         212229
     C                   Parm                    P@FMT                                        212229
      *                                                                                       212229
      ** If entry was account, load work fields                                               212229
      *                                                                                       212229
     C     @TYPE         IFEQ      '*RETAIL'                                                  212229
     C     @TYPE         OREQ      '*NOSTRO'                                                  212229
     C     @TYPE         OREQ      '*LEDGER'                                                  212229
     C     IBANRetCde    ORNE      *BLANKS                                                    212229
                                                                                              212229
     C                   SELECT                                                               212229
     C     @TYPE         WHENEQ    '*NOSTRO'                                                  212229
     C                   MOVEL     'F'           WACCTTP           1                          212229
     C     @TYPE         WHENEQ    '*LEDGER'                                                  212229
     C                   MOVEL     'G'           WACCTTP                                      212229
     C     @TYPE         WHENEQ    '*RETAIL'                                                  212229
     C                   MOVEL     'R'           WACCTTP                                      212229
     C     IBANRetCde    WHENNE    *BLANKS                                                    212229
     C                   MOVEL     'I'           WACCTTP                                      212229
     C                   ENDSL                                                                212229
                                                                                              212229
     C                   ENDIF                                                                212229
      *                                                                                       212229
     C                   ENDSR                                                                212229
      *****************************************************************                       212229
      /EJECT                                                                                  212229
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
      * INPUTS
     C                   Parm                    RetCodeIn
      * Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      * S=Submitted (FT0300).  A=Interactive.
     C                   Parm                    Action
     C                   Parm                    AddRemove         1
     C                   Parm                    FHRFTID
     C                   PARM                    NHdrRcdIn                                    212229
     C                   PARM                    NDtlRcdIn                                    212229
     C                   PARM                    PHdrRcdIn                                    212229
     C                   PARM                    PDtlRcdIn                                    212229
     C                   PARM                    HdrInfo                                      212229
     C                   PARM                    DtlInfo                                      212229
     C                   PARM                    FTSTP             1                          212229
      *                                                                                       212229
      ** Access SAR file to see if CFT004 is present                                          212229
      *                                                                                       212229
     C                   CALLB     'AOSARDR0'                                                 212229
     C                   PARM      *Blanks       @RTCD                                        212229
     C                   PARM      '*VERIFY'     @OPTN                                        212229
     C                   PARM      'CFT004'      @SARD                                        212229
     C                   PARM                    DSFDY                                        212229
     C     @RTCD         IFEQ      *BLANK                                                     212229
     C                   MOVE      'Y'           CFT004                                       212229
     C                   ELSE                                                                 212229
     C                   MOVE      'N'           CFT004                                       212229
     C                   ENDIF                                                                212229
 
      ** Check if Online Printing of Advices (GE7) is on.                                     CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
     C                   CALL      'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRTCD                                        CRE020
     C                   PARM      '*VERIFY'     POPTN                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRTCD <> *Blanks  and                                      CRE020
     C                             PRTCD <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 10                                                 CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        PRTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CAP205
      ** Determine if SAR CAP205 is installed                                                 CAP205
                                                                                              CAP205
     C                   MOVE      'N'           CAP205                                       CAP205
     C                   CALLB     'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       @RTCD                                        CAP205
     C                   PARM      '*VERIFY'     @OPTN                                        CAP205
     C                   PARM      'CAP205'      @SARD                                        CAP205
     C                   PARM                    DSFDY                                        CAP205
                                                                                              CAP205
     C                   IF        @RTCD <> *BLANKS  AND                                      CAP205
     C                             @RTCD <> '*NRF'                                            CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   EVAL      DBKey = 'CAP205'                                           CAP205
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP205
     C                   EVAL      DBase = 33                                                 CAP205
     C                   EXSR      *PSSR                                                      CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C     @RTCD         IFEQ      *BLANK                                                     CAP205
     C                   MOVE      'Y'           CAP205                                       CAP205
     C                   ENDIF                                                                CAP205
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
