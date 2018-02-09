     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate ordering institution - header')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVORIS01  - Validate Ordering Institution Header            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034390           Date 14May15               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24710           Date 06Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG19711           Date 17Oct08               *
      *                 BUG17060           Date 18Mar08               *
      *                 BUG15248A          Date 12Nov07               *
      *                 BUG15279           Date 08Nov07               *
      *                 BUG15248           Date 05Nov07               *
      *                 BUG15241           Date 05Nov07               *
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
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188775             Date 14Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT008  *CREATE    Date 21Aug99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034390 - CCTD and RFTD do not validate input for fields    *
      *             generating 52a, 56a, 57a when Clearing codes is   *
      *             supplied in transaction screen does affecting the *
      *             reports output                                    *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG24710 - "/" followed by valid retail account is rejected  *
      *             by the system                                     *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG19711 - FTC0690 failed in COB                             *
      *  BUG17060 - Payment Currency cannot be entered if a valid     *
      *             account has not been entered in one of the to be  *
      *             debited fields                                    *
      *  BUG15248A - Remove prefix '/' from the ordering customer     *
      *              (Reopen)                                         *
      *  BUG15279 - Error exist in pay currency                       *
      *  BUG15248 - Remove prefix '/' from the ordering customer      *
      *             line 1 when passing the value to the access obj.  *
      *  BUG15241 - No Validation for Ordering Institution Field      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  188775 - Checking for insufficient funds                     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CSW200 - SWIFT 2000 enhancements                             *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
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
 
      ** Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ***External*data*structure*for*Currency*standing*data                     188775
     D*SDCURR********E DS                  EXTNAME(SDCURRPD)                    188775
 
      ** External data structure for Customer standing data
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
     D CFT004          S              1    INZ(' ')
     D wvalid          S              1
      ***Numeric*version*of*Transfer*Amount                                     188775
     D*wamt************S             15P 0                                      188775
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      * Work Customer Number
     D  WCust          S                   Like(CNUM)
     D  @Type          S                   Like(@Rtcd)
 
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
     C                   Eval      PORDITP    = *Blank
     C                   Eval      PType    = *Blanks
     C                   Eval      BBCSID = *Blanks
     C                   Clear                   Accnt
 
 
     C                   Eval      GenOkFlag2 = 'Y'
 
     C                   SETON                                        67                    BUG15279
     C                   IF        %SUBST(PTOCUS1:1:1) = '/'                                BUG15248
     C                   EVAL      PACCT = %SUBST(PTOCUS1:2)                                BUG15248
     C                   ELSE                                                               BUG15248
     C                   Eval      PACCT = PTOCUS1
     C                   ENDIF                                                              BUG15248
     C                   EXSR      SrAcct
     C                   SETOFF                                       67                    BUG15279
 
     C                   Select
 
      ** Must not be the same with sending institution
     C                   When      PSINST = POINST3 AND PSINST <> *Blanks AND
     C                             POINST3 <> *blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0237'
      *                                                                                     BUG15279
      **  ordering customer is a invalid account                                            BUG15279
     C                   When      wvalid = 'N'   AND                                       BUG15279
     C                             PCCTTYP = 'BO' AND                                       BUG15279
     C                             PTOCUS1 <> *BLANKS  AND                                  BUG15279
     C                             Poinst3 = *BLANKS                                        BUG15279
     C                   Eval      GenOkFlag2 = 'N'                                         BUG15279
     C                   Eval      Idx = Idx + 1                                            BUG15279
     C                   Eval      RetCodeIn = 'Error'                                      BUG15279
     C                   Eval      FldNamXAr(Idx) = DDSName                                 BUG15279
     C                   Eval      MsgIdXAr(Idx) = 'RFV0343'                                BUG15279
 
      **  ordering customer is a valid account
     C                   When      wvalid = 'Y'
 
     C                   If        %Subst(POINST3:1:1) <> '/'  AND
     C                             POINST3 <> *Blanks          AND
     C                             PCCTTYP = 'BI'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0236'
     C                   Return
     C                   Endif
 
     C                   If        %Subst(POINST3:1:2) = '//'
     C                   CallB     'FTVBCCC01'
     C                   Parm      'HEADER'      BicRetCode       10
     C                   Parm      POINST3       ClrOrAcc         35
     C                   Parm      POINST1       BicCSname        11
     C                   Parm                    DDSName                        CSW200
 
     C                   Select
     C                   When      BicRetCode = '*INVALIDCC'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0238'
     C                   Eval      FldNamXAr(Idx) =   DDSName
 
     C                   When      BicRetCode = '*DIGITERR'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0119'
     C                   Eval      FldNamXAr(Idx) =   DDSName
 
     C                   When      BicRetCode = '*BLANKERR'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0366'
     C                   Eval      FldNamXAr(Idx) =   DDSName
 
 
     C                   When      BicRetCode = '*NOBIC   '
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0239'
     C                   Eval      FldNamXAr(Idx) =   DDSName
                                                                                            MD034390
     C                   WHEN      BicRetCode = '*11ERROR '                                 MD034390
     C                   EVAL      OKOINS1    = 'N'                                         MD034390
     C                   EVAL      Idx            =   Idx+1                                 MD034390
     C                   EVAL      RetCodeIn      =   'Error'                               MD034390
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0120'                             MD034390
     C                   EVAL      FldNamXAr(Idx) =   DDSName                               MD034390
     C                   Endsl
 
     C                   ELSE                                                               BUG19711
      *                                                                                     BUG19711
     C                   IF        POINST3 <> *BLANKS                                       BUG19711
     C                   EVAL      GenOkFlag2 = 'N'                                         BUG19711
     C                   EVAL      Idx            =   Idx+1                                 BUG19711
     C                   EVAL      RetCodeIn      =   'Error'                               BUG19711
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0945'                             BUG19711
     C                   EVAL      FldNamXAr(Idx) =   DDSName                               BUG19711
     C                   ENDIF                                                              BUG19711
     C                   Endif
 
      ** Type is BO and ordering customer is not a valid account
     C                   When      PCCTTYP = 'BO' and
     C**********                   wvalid = 'N' AND Poinst3 <> *Blanks                      BUG15241
     C**********                   wvalid = 'N'                                    BUG15241 BUG15279
     C                             wvalid = 'N' AND Poinst3 <> *Blanks                      BUG15279
     C                   Eval      PACCT = POINST3
     C                   Exsr      SrAcct
 
      ** Invalid Account
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0240'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Else
 
      * If valid account AND 1st character is a '/', remove it.
     C                   If        %Subst(POINST3:1:1) = '/'
     C                   Eval      POINST3 = %Subst(POINST3:2)
     C                   Endif
 
      * If a valid account, ensure that customer has a BIC defined.
     C                   Movel     WCust         @Key
     C
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    @Key             10
     C                   Parm                    @Keyst            7
     C     SDCUST        Parm      *Blanks       DSSDY
 
     C                   If        @Rtcd  <> *Blanks  OR
     C                             BBCSID = *Blanks
 
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0377'
     C                   Eval      FldNamXAr(Idx) =   DDSName
 
     C                   Endif
 
      ** Valid Account
     C                   If        DPPayCCY = %SUBST(DSSDY:8:3) and
     C                             PTYPE <> '*NOSTRO' or
     C                             DPPayCCY = %SUBST(DSSDY:1:3) and
     C                             PTYPE = '*NOSTRO'
 
      ** Second field must be blank
     C                   If        POINST1 <> *Blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0241'
     C****************** Eval      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   Eval      FldNamXAr(Idx) =   'POINST1'                 CAP084
     C                   Else
 
     C**************     Exsr      SrSffd                                       188775
 
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PORDITP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PORDITP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PORDITP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PORDITP = 'R'
     C                   Endsl
     C                   Endif
     C                   Else
 
      ** Payment ccy is not equal to the account ccy
     C                   IF        DPPayCcy <> *Blanks
     C                   Eval      GenOkFlag2 = 'W'
     C                   Eval      WIx = WIx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      WFldNmXAr(WIx) = DDSName
     C                   Eval      WMsgIdXAr(WIx) = 'RFV0289'
     C                   ENDIF
 
     C**************     Exsr      SrSffd                                       188775
 
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PORDITP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PORDITP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PORDITP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PORDITP = 'R'
     C                   Endsl
     C                   Endif
 
     C                   Endif
     C                   Endsl
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        POINST1 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POINST1       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'POINST1'                  CAP084
     C                   Eval      GenOkFlag2 = 'N'
     C                   Endif
     C                   Endif
 
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
 
     C                   Eval      PTYPE = *Blanks
     C                   Eval      wvalid = 'Y'
 
      ** CFT is switched on
     C                   If        CFT004 = 'Y'
 
      ** Validate Account
     C                   CallB     'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm                    PACCT            35
     C     ACCNT         Parm      ACCNT         DSSDY
 
     C                   If        PRTCD = *Blanks
     C                   Eval      PTYPE = 'IBAN'
     C                   Endif
     C                   Endif
 
     C                   If        PTYPE <> 'IBAN'
 
      ** Validate Account
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       PRTCD             7            B:Return code
     C                   Parm                    PTYPE             7            I:A/c ID
     C                   Parm                    PACCT                          I:A/c Currency
     C*****ACCNT         Parm      ACCNT         DSSDY
     C                   PARM                    DSSDY
     C                   Endif
      *
     C                   SELECT
 
     C                   WHEN      PTYPE = '*NOSTRO'
     C                   EVAL      N@FMT = DSSDY
     C                   Movel     A7Cust        WCust
 
     C                   WHEN      PTYPE = '*RETAIL'
     C                   EVAL      ACCNT = DSSDY
     C                   Eval      Wcust = CNUM
 
     C                   WHEN      PTYPE = '*LEDGER'
     C                   Eval      ACCNT = DSSDY
     C                   Eval      Wcust = CNUM
     C                   ENDSL
 
      ** Invalid Account
     C                   If        PTYPE <> 'IBAN' and
     C                             PTYPE <> '*NOSTRO'  and
     C                             PTYPE <> '*RETAIL'  and
     C                             PTYPE <> '*LEDGER' or
     C                             PRTCD <> *Blanks
     C                   Eval      wvalid = 'N'
     C                   Endif
     C**********         If        wvalid = 'Y'   AND                              BUG15279 BUG24710
     C**********                   PCCTTYP = 'BO' AND                              BUG15279 BUG24710
     C**********                   PTOCUS1 <> *BLANKS AND                          BUG15279 BUG24710
     C**********                   %SUBST(PTOCUS1:1:1) = '/' AND                   BUG15279 BUG24710
     C**********                   *IN67 = *ON  AND                                BUG15279 BUG24710
     C**********                   (PTYPE = '*NOSTRO' or                           BUG15279 BUG24710
     C**********                   PTYPE = '*LEDGER')                              BUG15279 BUG24710
      *                                                                                    BUG15248A
      ** If second line in ordering customer is not blanks, automatically the account line BUG15248A
      ** is seen as external account and the ordering institution is requested             BUG15248A
     C**********                   OR wvalid = 'Y'                                BUG15248A BUG24710
     C                   IF        wvalid = 'Y'                                             BUG24710
     C                             AND PCCTTYP = 'BO'                                      BUG15248A
     C                             AND %SUBST(PTOCUS1:1:1) = '/'                           BUG15248A
     C                             AND PTOCUS2 <> *BLANKS                                  BUG15248A
     C                             AND *IN67 = *ON                                         BUG15248A
      *                                                                                    BUG15248A
      ** If Ordering customer is a free format address, make sure the                       BUG17060
      ** Ordering institution is validated                                                  BUG17060
                                                                                            BUG17060
     C                             OR (wvalid = 'Y'                                         BUG17060
     C                             AND PCCTTYP = 'BO'                                       BUG17060
     C                             AND PCUSTTH = 'A'                                        BUG17060
     C                             AND *IN67 = *ON)                                         BUG17060
                                                                                            BUG17060
     C                   Eval      wvalid = 'N'                                             BUG15279
     C                   Endif                                                              BUG15279
 
     C                   Endsr
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
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CFT004'      PSARD             6
     C                   Parm                    DSFDY
 
     C                   Eval      CFT004 = 'N'
     C                   If        PRTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   Endif
 
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
