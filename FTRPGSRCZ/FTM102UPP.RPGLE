     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT FTM102UPPsitions file')                       *
      *****************************************************************
      *                                                               *
      *  Midas - CCT Shadow postings                                  *
      *                                                               *
      *  FT102APS   - Update position files                           *
      *                                                               *
      * This routine can be called interactively or from FT0300       *
      * to confirm and write details of the CCT transaction.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 212229             Date 02Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185699             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178186             Date 26Apr00               *
      *                 CFT006  *CREATE    Date 14Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  212229 - Every amendment on the transaction produces Unnece- *
      *           ssary Dr/Cr postings. Shadow posting for amendment  *
      *           should only be created when there's a change in     *
      *           account/amount/date.                                *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185699 - Do not do shadow post if OP to be generated         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  178186 - Remove duplicated commit                            *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
     FFT102HL3  IF   E           K DISK    PREFIX(FH)
     FFT102DL0  IF   E           K DISK    PREFIX(FD)
 
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
     D*C#CNU1***               2      7  0                                                    CSD027
     D C#CNU1                  2      7                                                       CSD027
     D C#CCY1                  8     10
     D***C#ACO1*                11     14  0                                                  CGL029
     D C#ACS1                 15     16  0
     D C#BRC1                 17     19
     D C#NOSN                  2      3  0
     D C#NOS                   2      6
     D C#ACNO                  2     11  0
     D*C#CNUM***               2      7  0                                                    CSD027
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
     D*W#CNU1***               1      6  0                                             CGL029 CSD027
     D W#CNU1                  1      6                                                       CSD027
     D W#CCY1                  7      9                                                       CGL029
     D W#ACO1                 10     19  0                                                    CGL029
     D W#ACS1                 20     21  0                                                    CGL029
     D W#BRC1                 22     24                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D PHdrRcdIn     E DS                  EXTNAME(FT102HPD) PREFIX(PH)                       212229
     D PDtlRcdIn     E DS                  EXTNAME(FT102DPD) PREFIX(PD)                       212229
     D NHdrRcdIn     E DS                  EXTNAME(FT102HPD) PREFIX(NH)                       212229
     D NDtlRcdIn     E DS                  EXTNAME(FT102DPD) PREFIX(ND)                       212229
 
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
 
     D  WorkAmt        S                   Like(FHCCTAMT)
 
     D P@FMT         E DS                  EXTNAME(DSSDY)                            177669
     D @Type           S                   Like(@RTCD)
 
     D CRE020          S              1A                                                      CRE020
     D CAP205          S              1A                                                      CAP205
     D PRTCD           S              7A                                                      CRE020
     D POPTN           S              7A                                                      CRE020
     D PSARD           S              6A                                                      CRE020
     D WSequence       S              3A                                                      CRE020
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
     C     FHCCTID       Chain     FT102HL3                           55
 
     C                   If        *In55
     C                   Exsr      Ex@Pgm
     C                   Endif
 
     C                   Eval      HdrInfo = 'Y'
     C                   Eval      DtlInfo = 'N'                                              212229
     C                   Exsr      Det_Amounts
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WSequence = '000'                                          CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C     WORKAMT       IFNE      0                                                          212229
     C                   Exsr      Oth_Proc
     C                   ENDIF                                                                212229
 
     C                   Eval      *In55 = *Off
     C     FHCCTID       Setll     FT102DL0
     C     FHCCTID       ReadE     FT102DL0                               55
     C                   Dow       *In55 = *Off
     C                   Eval      HdrInfo = 'N'
     C                   Eval      DtlInfo = 'Y'
     C                   Exsr      Det_Amounts
      * Only if outgoing not to be generated                                    185699
     C     FDGOPFLG      Ifne      'Y'                                          185699
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WSequence = %SUBST(FDTRNSID:14:3)                          CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C     NDTRNSID      IFEQ      FDTRNSID                                                   212229
     C     ACTION        ANDNE     'I'                                                        212229
     C     HDRDLT        OREQ      'Y '                                                       212229
     C                   Exsr      Oth_Proc
     C                   ENDIF                                                                212229
     C                   Endif                                                  185699
      *                                                                         185699
     C     FHCCTID       ReadE     FT102DL0                               55
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
     C     FHCCTID       Chain     FT102HL3                           55
 
     C                   If        *In55
     C                   Exsr      Ex@Pgm
     C                   Endif
 
     C                   Eval      HdrInfo = 'Y'
     C                   Eval      DtlInfo = 'N'                                              212229
     C                   Exsr      Det_Amounts
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WSequence = '000'                                          CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C     WORKAMT       IFNE      0                                                          212229
     C                   Exsr      Oth_Proc
     C                   ENDIF                                                                212229
 
     C                   Eval      *In55 = *Off
     C     FHCCTID       Setll     FT102DL0
     C     FHCCTID       ReadE     FT102DL0                               55
     C                   Dow       *In55 = *Off
     C                   Eval      HdrInfo = 'N'
     C                   Eval      DtlInfo = 'Y'                                              212229
     C                   Exsr      Det_Amounts
      * Only if outgoing not to be generated                                    185699
     C     FDGOPFLG      Ifne      'Y'                                          185699
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WSequence = %SUBST(FDTRNSID:14:3)                          CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C     NDTRNSID      IFEQ      FDTRNSID                                                   212229
     C     ACTION        ANDNE     'D'                                                        212229
     C                   Exsr      Oth_Proc
     C                   ENDIF                                                                212229
     C                   Endif                                                  185699
      *                                                                         185699
     C     FHCCTID       ReadE     FT102DL0                               55
     C                   Enddo
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Det_amnts  : Determine Amounts                                *
      *                                                               *
      * Called by: Main.                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Det_Amounts   Begsr
 
     C                   Select
 
     C                   When      FHCcttyp = 'BI'
      * If remove, get current data
     C                   If        AddRemove = 'R'
 
      *  Determine amounts
     C                   If        HdrInfo = 'Y'
     C                   Eval      WorkAmt = FHCCTAMT * -1
     C                   Else
     C                   Eval      WorkAmt = FDPAYAMT
     C                   Endif
     C                   Else
 
     C                   If        HdrInfo = 'Y'
     C                   Eval      WorkAmt = FHCCTAMT
     C                   Else
     C                   Eval      WorkAmt = FDPAYAMT * - 1
     C                   Endif
 
     C                   Endif
 
     C                   When      FHCcttyp = 'BO'
 
     C                   If        AddRemove = 'R'
 
     C                   If        HdrInfo = 'Y'
     C                   Eval      WorkAmt = FHCCTAMT
     C                   Else
     C                   Eval      WorkAmt = FDPAYAMT * - 1
     C                   Endif
     C                   Else
 
     C                   If        HdrInfo = 'Y'
     C                   Eval      WorkAmt = FHCCTAMT * - 1
     C                   Else
     C                   Eval      WorkAmt = FDPAYAMT
     C                   Endif
 
     C                   Endif
 
     C                   Endsl
 
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
 
      ***4.**All*OK*so*far,*so*now*commit*postings                              178186
     C*******************Exsr      Cmt_AOSPOS                                   178186
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
     C                   Select
      * Header
     C                   When      HdrInfo = 'Y'
     C                   MOVE      *BLANKS       ACCTUSED          3                          212229
 
      * Move data : Amount
 
     C                   Select
      * If incoming, debit sending institution / senders corr / rcv corr
      * INCOMING MT102 : CREDIT
     C                   When      FHCcttyp = 'BI'
 
     C                   Select
      * Sending Institution
     C                   When      FHSINSTT = 'G'  OR
     C                             FHSINSTT = 'R'  OR
     C                             FHSINSTT = 'I'  OR
     C                             FHSINSTT = 'F'
     C                   Eval      C#ATYP = FHSINSTT
     C                   Eval      TmpA   = FHSINST
     C                   MOVE      'SIN'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Senders Correspondent
     C                   When      FHSNDTYP = 'G'  OR
     C                             FHSNDTYP = 'R'  OR
     C                             FHSNDTYP = 'I'  OR
     C                             FHSNDTYP = 'F'
     C                   Eval      C#ATYP = FHSNDTYP
     C                   Eval      TmpA   = FHSNDCOR
     C                   MOVE      'SCO'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Reveivers Correspondent
     C                   When      FHRCVTYP = 'G'  OR
     C                             FHRCVTYP = 'R'  OR
     C                             FHRCVTYP = 'I'  OR
     C                             FHRCVTYP = 'F'
     C                   Eval      C#ATYP = FHRCVTYP
     C                   Eval      TmpA   = FHRCVCOR
     C                   MOVE      'RCO'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Settlement Value Date
     C                   Eval      C#VDAT   =    FHTTVDTE
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    FHCCTCCY
      * Other fields
     C                   Eval      C#TRYP   =    FHCCTTYP
     C                   Eval      C#PREF   =    FHCctId
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHCctId                                      CRE020
     C                   MOVE      WSequence     C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#AMT    =    WorkAmt
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
 
     C     PHSINST       IFNE      NHSINST                                                    212229
     C     ACCTUSED      ANDEQ     'SIN'                                                      212229
     C     PHSNDCOR      ORNE      NHSNDCOR                                                   212229
     C     ACCTUSED      ANDEQ     'SCO'                                                      212229
     C     PHRCVCOR      ORNE      NHRCVCOR                                                   212229
     C     ACCTUSED      ANDEQ     'RCO'                                                      212229
     C     PHTTVDTE      ORNE      NHTTVDTE                                                   212229
     C     PHCCTCCY      ORNE      NHCCTCCY                                                   212229
     C     PHCCTTYP      ORNE      NHCCTTYP                                                   212229
     C     PHCCTAMT      ORNE      NHCCTAMT                                                   212229
     C     PDPAYAMT      ORNE      NDPAYAMT                                                   212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
 
 
      * OUTGOING MT102 : CREDIT
     C                   When      FHCcttyp = 'BO'
 
     C                   Select
      * Destination
     C                   When      FHDSTTYP = 'G'  OR
     C                             FHDSTTYP = 'R'  OR
     C                             FHDSTTYP = 'I'  OR
     C                             FHDSTTYP = 'F'
     C                   Eval      C#ATYP = FHDSTTYP
     C                   Eval      TmpA   = FHCCTDST
     C                   MOVE      'DES'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Senders Correspondent
     C                   When      FHSNDTYP = 'G'  OR
     C                             FHSNDTYP = 'R'  OR
     C                             FHSNDTYP = 'I'  OR
     C                             FHSNDTYP = 'F'
     C                   Eval      C#ATYP = FHSNDTYP
     C                   Eval      TmpA   = FHSNDCOR
     C                   MOVE      'SCO'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Reveivers Correspondent
     C                   When      FHRCVTYP = 'G'  OR
     C                             FHRCVTYP = 'R'  OR
     C                             FHRCVTYP = 'I'  OR
     C                             FHRCVTYP = 'F'
     C                   Eval      C#ATYP = FHRCVTYP
     C                   Eval      TmpA   = FHRCVCOR
     C                   MOVE      'RCO'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Settlement Value Date
     C                   Eval      C#VDAT   =    FHTTVDTE
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    FHCCTCCY
      * Other fields
     C                   Eval      C#TRYP   =    FHCCTTYP
     C                   Eval      C#PREF   =    FHCctId
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHCctId                                      CRE020
     C                   MOVE      WSequence     C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#AMT    =    WorkAmt
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
 
     C     PHCCTDST      IFNE      NHCCTDST                                                   212229
     C     ACCTUSED      ANDEQ     'DES'                                                      212229
     C     PHSNDCOR      ORNE      NHSNDCOR                                                   212229
     C     ACCTUSED      ANDEQ     'SCO'                                                      212229
     C     PHRCVCOR      ORNE      NHRCVCOR                                                   212229
     C     ACCTUSED      ANDEQ     'RCO'                                                      212229
     C     PHTTVDTE      ORNE      NHTTVDTE                                                   212229
     C     PHCCTTYP      ORNE      NHCCTTYP                                                   212229
     C     PHCCTAMT      ORNE      NHCCTAMT                                                   212229
     C     PDPAYAMT      ORNE      NDPAYAMT                                                   212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
 
     C                   Endsl
 
 
      *             P A Y     D E T A I L S
 
     C                   When      DtlInfo = 'Y'
     C                   MOVE      *BLANKS       ACCTUSED          3                          212229
 
      * Order for pay instructions are 1.  Receivers Correspondent,
      *  2. Account with Institution, 3. Beneficiary
 
     C                   Select
 
     C                   When      FHCcttyp = 'BI'
 
     C                   Select
 
      * Account with Institution
     C                   When      FDAWITP  = 'F'  OR
     C                             FDAWITP  = 'G'  OR
     C                             FDAWITP  = 'R'  OR
     C                             FDAWITP  = 'I'
     C                   Eval      C#ATYP  = FDAWITP
     C                   Eval      TmpA    = FDACCI35
     C                   MOVE      'AWI'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Beneficiary
     C                   When      FDBENTTD = 'I'  OR
     C                             FDBENTTD = 'G'  OR
     C                             FDBENTTD = 'R'  OR
     C                             FDBENTTD = 'F'
     C                   Eval      C#ATYP  = FDBENTTD
     C                   Eval      TmpA    = FDBENF1
     C                   MOVE      'BEN'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Pay Value Date
     C                   Eval      C#VDAT   =    FDCRDVDT
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    FDPAYCCY
      * Other fields
     C                   Eval      C#TRYP   =    FHCCTTYP
     C                   Eval      C#PREF   =    FHCctId
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHCctId                                      CRE020
     C                   MOVE      WSequence     C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#AMT    =    WorkAmt
     C                   If        FHCCTCHG = 'BEN'  OR
     C                             FHCCTCHG = 'SHA'  OR
     C                             FDCCYCHG= 'BEN'   OR
     C                             FDCCYCHG= 'SHA'
     C                   Sub       FDRCVOCG      C#AMT
     C                   Endif
 
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
 
     C     HDRDLT        IFEQ      'Y'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      Do_Add_Spos                                                212229
     C                   ELSE                                                                 212229
     C     PDACCI35      IFNE      NDACCI35                                                   212229
     C     ACCTUSED      ANDEQ     'AWI'                                                      212229
     C     PDBENF1       ORNE      NDBENF1                                                    212229
     C     ACCTUSED      ANDEQ     'BEN'                                                      212229
     C     PDCRDVDT      ORNE      NDCRDVDT                                                   212229
     C     PDPAYCCY      ORNE      NDPAYCCY                                                   212229
     C     PHCCTTYP      ORNE      NHCCTTYP                                                   212229
     C     PDPAYAMT      ORNE      NDPAYAMT                                                   212229
     C     PHCCTCHG      ORNE      NHCCTCHG                                                   212229
     C     PDCCYCHG      ORNE      NDCCYCHG                                                   212229
     C     PDRCVOCG      ORNE      NDRCVOCG                                                   212229
     C     FHCCTCHG      ANDNE     'OUR'                                                      212229
     C     PDRCVOCG      ORNE      NDRCVOCG                                                   212229
     C     FDCCYCHG      ANDNE     'OUR'                                                      212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
 
     C                   When      FHCcttyp = 'BO'
 
     C                   Select
 
      * Ordering Customer (HEADER)
     C                   When      FHCUSTTH  = 'F'  OR
     C                             FHCUSTTH  = 'G'  OR
     C                             FHCUSTTH  = 'R'  OR
     C                             FHCUSTTH  = 'I'
     C                   Eval      C#ATYP  = FHCUSTTH
     C                   Eval      TmpA    = FHTOCUS1
     C                   MOVE      'OCH'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Ordering Customer (DETAIL)
     C                   When      FDCUSTTD = 'F'  OR
     C                             FDCUSTTD = 'G'  OR
     C                             FDCUSTTD = 'R'  OR
     C                             FDCUSTTD = 'I'
     C                   Eval      C#ATYP  = FDCUSTTD
     C                   Eval      TmpA    = FDORDCU1
     C                   MOVE      'OCD'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Ordering Institution (HEADER)
     C                   When      FHORDITP  = 'I'  OR
     C                             FHORDITP  = 'G'  OR
     C                             FHORDITP  = 'R'  OR
     C                             FHORDITP  = 'F'
     C                   Eval      C#ATYP  = FHORDITP
     C                   Eval      TmpA    = FHOINST3
     C                   MOVE      'OIH'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
      * Ordering Institution (DETAIL)
     C                   When      FDORDITP  = 'I'  OR
     C                             FDORDITP  = 'G'  OR
     C                             FDORDITP  = 'R'  OR
     C                             FDORDITP  = 'F'
     C                   Eval      C#ATYP  = FDORDITP
     C                   Eval      TmpA    = FDORDI35
     C                   MOVE      'OID'         ACCTUSED                                     212229
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Pay Value Date
     C                   Eval      C#VDAT   =    FDCRDVDT
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    FDPAYCCY
      * Other fields
     C                   Eval      C#TRYP   =    FHCCTTYP
     C                   Eval      C#PREF   =    FHCctId
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   Eval      C#NARR   =    FHCctId                                      CRE020
     C                   MOVE      WSequence     C#CHQN                                       CRE020
     C                   IF        AddRemove = 'R'                                            CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Eval      C#AMT    =    WorkAmt
     C                   If        FHCCTCHG = 'OUR'  OR
     C                             FDCCYCHG = 'OUR'
     C                   Add       FDRCVOCG      C#AMT
     C                   Endif
 
     C                   If        FHCCTCHG = 'OUR'   OR
     C                             FHCCTCHG = 'SHA'   OR
     C                             FDCCYCHG = 'OUR'   OR
     C                             FDCCYCHG = 'SHA'
     C                   Add       FDSNDOCG      C#AMT
     C                   Endif
 
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#FTOV   =  'Y'
 
     C     HDRDLT        IFEQ      'Y'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      Do_Add_Spos                                                212229
     C                   ELSE                                                                 212229
     C     PHTOCUS1      IFNE      NHTOCUS1                                                   212229
     C     ACCTUSED      ANDEQ     'OCH'                                                      212229
     C     PDORDCU1      ORNE      NDORDCU1                                                   212229
     C     ACCTUSED      ANDEQ     'OCD'                                                      212229
     C     PHOINST3      ORNE      NHOINST3                                                   212229
     C     ACCTUSED      ANDEQ     'OIH'                                                      212229
     C     PDORDI35      ORNE      NDORDI35                                                   212229
     C     ACCTUSED      ANDEQ     'OID'                                                      212229
     C     PDCRDVDT      ORNE      NDCRDVDT                                                   212229
     C     PDPAYCCY      ORNE      NDPAYCCY                                                   212229
     C     PHCCTTYP      ORNE      NHCCTTYP                                                   212229
     C     PDPAYAMT      ORNE      NDPAYAMT                                                   212229
     C     PDRCVOCG      ORNE      NDRCVOCG                                                   212229
     C     FDCCYCHG      ANDEQ     'OUR'                                                      212229
     C     PDRCVOCG      ORNE      NDRCVOCG                                                   212229
     C     FHCCTCHG      ANDEQ     'OUR'                                                      212229
     C     PDSNDOCG      ORNE      NDSNDOCG                                                   212229
     C     FHCCTCHG      ANDNE     'BEN'                                                      212229
     C     PDSNDOCG      ORNE      NDSNDOCG                                                   212229
     C     FDCCYCHG      ANDNE     'BEN'                                                      212229
     C     ACTION        OREQ      'D'                                                        212229
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   Exsr      Do_Add_Spos
     C                   ENDIF                                                                212229
     C                   ENDIF                                                                212229
 
 
     C                   Endsl
 
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
 
     C                   If        C#Acct <> *Blanks
 
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
 
     C                   Else
     C                   Eval      C#ACCT = TmpA
     C                   Endif
     C                   Endif
                                                                                              CGL029
     C                   EVAL      C#CNU1 = W#CNU1                                            CGL029
     C                   EVAL      C#CCY1 = W#CCY1                                            CGL029
     C                   EVAL      C#ACO1 = W#ACO1                                            CGL029
     C                   EVAL      C#ACS1 = W#ACS1                                            CGL029
     C                   EVAL      C#BRC1 = W#BRC1                                            CGL029
 
     C                   Endsr
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
      * INPUTS
     C                   Parm                    RetCodeIn
      * Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      * S=Submitted (FT0300).  A=Interactive.
     C                   Parm                    Action
     C                   Parm                    AddRemove         1
     C                   Parm                    FHCCTID
     C                   PARM                    NHdrRcdIn                                    212229
     C                   PARM                    NDtlRcdIn                                    212229
     C                   PARM                    PHdrRcdIn                                    212229
     C                   PARM                    PDtlRcdIn                                    212229
     C                   PARM                    HDRDLT            1                          212229
 
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
     C                   MOVEL     'N'           CAP205                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       PRTCD                                        CAP205
     C                   PARM      '*VERIFY'     POPTN                                        CAP205
     C                   PARM      'CAP205'      PSARD                                        CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
                                                                                              CAP205
     C                   IF        PRTCD <> *BLANKS  AND                                      CAP205
     C                             PRTCD <> '*NRF'                                            CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   EVAL      DBKEY = 'CAP205'                                           CAP205
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP205
     C                   EVAL      DBASE = 11                                                 CAP205
     C                   EXSR      *PSSR                                                      CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   IF        PRTCD = *BLANKS                                            CAP205
     C                   MOVEL     'Y'           CAP205                                       CAP205
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
(c) Finastra International Limited 2001
