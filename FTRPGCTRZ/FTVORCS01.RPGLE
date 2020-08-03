     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate RFT detail ordering customer')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVORCS01 - Validate Ordering Customer                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 259576             Date 02Apr14               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 15May13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26222           Date 29Sep09               *
      *                 BUG25973           Date 17Sep09               *
      *                 BUG26080           Date 17Sep09               *
      *                 BUG25858           Date 02Sep09               *
      *                 BUG25685           Date 21Aug09               *
      *                 BUG24464           Date 22Jun09               *
      *                 BUG25130           Date 27Jul09               *
      *                 BUG24481           Date 22Jun09               *
      *                 BUG24734           Date 03Jul09               *
      *                 BUG19578           Date 27Jun08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG21228           Date 30Sep08               *
      *                 BUG21185           Date 24Sep08               *
      *                 BUG21190           Date 24Sep08               *
      *                 BUG15239           Date 07Nov07               *
      *                 BUG15010A          Date 25Oct07               *
      *                 BUG15188           Date 30Oct07               *
      *                 BUG15065           Date 21Oct07               *
      *                 BUG15010           Date 17Oct07               *
      *                 BUG15029           Date 16Oct07               *
      *                 BUG14856           Date 14Sep07               *
      *                 BUG14755           Date 31Aug07               *
      *                 CSW207A            Date 22Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      *                 221538             Date 01Apr04               *
      *                 221774             Date 01Apr04               *
      *                 221776             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 18Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  259576 - Remove warning message for Inactive accounts.       *
      *           Applied for MD-26109                                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG26222 - Warning message is Unclear.                       *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG26080 - Valid 50f format was rejected.                    *
      *  BUG25858 - Slash + IBAN not validated                        *
      *  BUG25685 - Valid 50F Format input is rejected.               *
      *  BUG24464 - "/" in ordering customer line 1 is missing after  *
      *             pressing enter key                                *
      *  BUG25130 - Warning message should be displayed not error     *
      *             message                                           *
      *  BUG24481 - No error message displayed                        *
      *  BUG24734 - No error message displayed                        *
      *  BUG19578 - External account treated as internal in RFTD      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG21228 - Invalid Customer # was not rejected.              *
      *  BUG21185 - Ordering customer don't start with '/' rejected   *
      *  BUG21190 - Applied fix 19257                                 *
      *  BUG19257 - Slash('/') removed in the Ordering Customer field *
      *  BUG15239 - Wrong 50H Output in MT101                         *
      *  BUG15010A - Fix CFT032/CSW207 errors -Reopen                 *
      *  BUG15188 - 5th line of ordering customer should be blank for *
      *             full address.                                     *
      *  BUG15065 - Error for SOSE identification type                *
      *  BUG15010 - CFT032 / CSW207 Errors                            *
      *  BUG15029 - Warning message displayed was "ERROR - Message    *
      *             not found                                         *
      *  BUG14856 - Missing/blank data is allowed in                  *
      *             "Ordering Customer" format                        *
      *  BUG14755 - MT 101 generated is 50H for retail number under   *
      *             ordering customer                                 *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  226083 - Correct various RFTD validation errors              *
      *  221538 - Expansion of field details.                         *
      *  221774 - Ensure lines 2-5 is blank if line 1 is blank or     *
      *           contains a valid account.                           *
      *  221776 - Ensure account conditions are also validated.       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for first screen
     D OKFlags       E DS                  EXTNAME(FTE101S1PD)
 
      * Incoming account details from access objects
     D AccRecord     E DS                  EXTNAME(ACCNTAB)
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                           BUG15010A
     D S_ACCNT       E DS                  EXTNAME(ACCNTAB)                                BUG15010A
     D                                     PREFIX(S_)                                      BUG15010A
     D A_DSSDY       E DS                  EXTNAME(DSSDY)                                  BUG15010A
     D                                     PREFIX(A_)                                      BUG15010A
     D N_SDNOST      E DS                  EXTNAME(SDNOSTPD)                               BUG15010A
     D                                     PREFIX(N_)                                      BUG15010A
     D C_SDCUST      E DS                  EXTNAME(SDCUSTPD)                               BUG15010A
     D                                     PREFIX(C_)                                      BUG15010A
 
      * DS to split account identifier into components
     D AccntCode       DS
     D  CustNo                 1      6
     D  P@CYCD                 7      9
     D  P@ACCD                10     19                                                       CGL029
     D  P@ACSN                20     21                                                       CGL029
     D  P@BRCA                22     24                                                       CGL029
     D**P@ACCD**              10     13                                                       CGL029
     D**P@ACSN**              14     15                                                       CGL029
     D**P@BRCA**              16     18                                                       CGL029
 
      * DS to split account identifier into components
     D WorkAccId       DS
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#CCY                  7      9
     D  W#ACOD                10     19  0                                                    CGL029
     D  W#ACSQ                20     21  0                                                    CGL029
     D  W#BRCA                22     24                                                       CGL029
     D**W#ACOD**              10     13  0                                                    CGL029
     D**W#ACSQ**              14     15  0                                                    CGL029
     D**W#BRCA**              16     18                                                       CGL029
 
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
     D WCNUM           S              6A                                                     CSW207A
     D WACOD           S             10A                                                     CSW207A
     D WACSQ           S              2A                                                     CSW207A
     D Valid50F        S              1A   INZ('N')                                         BUG15239
     D WAccStr         S              1    INZ('N')                                           221538
     D AccStr          S                   Like(POCUS1)                                       221538
     D WPOCUS1         S                   Like(POCUS1)                                     BUG19257
      *                                                                                       226083
      ** Alphabetic array                                                                     226083
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)                          226083
      *                                                                                       226083
      ** Numeric array                                                                        226083
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)                          226083
                                                                                             CSW207A
      ** Parameters for FT001000                                                             CSW207A
     D PRtnCde         S              7A                                                     CSW207A
     D PAccount        S             34A                                                     CSW207A
     D PAcType         S              1A                                                     CSW207A
     D PCust           S              6A                                                     CSW207A
     D PNonActH        S             10A                                                     CSW207A
     D PNetwork        S              6A                                                     CSW207A
     D PMsgTyp         S              3A                                                     CSW207A
     D PMsgTag         S              5A                                                     CSW207A
     D PBrch           S              3A                                                     CSW207A
     D PCountry        S              2A                                                     CSW207A
     D PCurr           S              3A                                                     CSW207A
     D PNostro         S              2A                                                     CSW207A
     D P50FmtF1        S             35A                                                     CSW207A
     D P50FmtF2        S             35A                                                     CSW207A
     D P50FmtF3        S             35A                                                     CSW207A
     D P50FmtF4        S             35A                                                     CSW207A
     D P50FmtF5        S             35A                                                     CSW207A
     D PVType          S              4A                                                     CSW207A
     D PMsgID          S              7A                                                     CSW207A
     D PModI           S              2A                                                     CSW207A
     D POMFlag         S              1A                                                     CSW207A
     D POut1           S             35A                                                     CSW207A
     D POut2           S             35A                                                     CSW207A
     D POut3           S             35A                                                     CSW207A
     D POut4           S             35A                                                     CSW207A
     D POut5           S             35A                                                     CSW207A
                                                                                             CSW207A
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
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise
     C                   EVAL      Idx     = 0
     C                   EVAL      WIx     = 0
     C                   EVAL      OKTOC1  = 'Y'
     C                   EVAL      OKTOC2  = 'Y'
     C                   EVAL      OKTOC3  = 'Y'
     C                   EVAL      OKTOC4  = 'Y'
     C                   EVAL      OKTOC5  = 'Y'
     C                   EVAL      PDCUSTP = *Blanks
     C                   EVAL      P@TYPE  = *Blanks                                          226083
     C                   CLEAR                   AccRecord
 
      ** Main processing
 
     C                   EXSR      VALIDATE
 
      ** If no problems with the account entered, set up hidden field.
     C                   IF        Idx = 0
      *
      * Note:                                                                                 226083
      * For RO, types available are C=customer and A=address only                             226083
      * For RI, types available are R=Retail, G=GL, F=nostro, and I=IBan                      226083
      *                                                                                       226083
     C                   SELECT
     C***********        WHEN      IBANRetCde = *Blanks and                                   226083
     C***********                  P@IBAN <> *Blanks                                          226083
     C                   WHEN      P@TYPE     = '*IBAN  '                                     226083
     C                   EVAL      PDCUSTP = 'I'
     C                   WHEN      P@TYPE = '*LEDGER'
     C                   EVAL      PDCUSTP = 'G'
     C                   WHEN      P@TYPE = '*NOSTRO'
     C                   EVAL      PDCUSTP = 'F'
     C                   WHEN      P@TYPE = '*RETAIL'
     C                   EVAL      PDCUSTP = 'R'
     C                   WHEN      P@TYPE = '*SHNAME'
     C**********         EVAL      PDCUSTP = 'S'                                              226083
     C                   WHEN      P@TYPE= '*SWIFT '                                        BUG19578
     C                   EVAL      PDCUSTP = 'S'                                            BUG19578
     C                   WHEN      P@TYPE = '*CUSTNO'
     C                   EVAL      PDCUSTP = 'C'
     C                   WHEN      P@TYPE = '*ADDRES'                                         226083
     C                   EVAL      PDCUSTP = 'A'                                              226083
     C                   ENDSL
      *
     C                   ENDIF
 
      * Now validate that all data entered is OK for SWIFT
     C                   IF        PPTYP = 'RO'                                             BUG25130
     C                   If        POCUS1  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POCUS1        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKTOC1  = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        POCUS2  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POCUS2        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******            Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'POCUS2'                   CAP084
     C                   EVAL      OKTOC2  = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        POCUS3  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POCUS3        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'POCUS3'                   CAP084
     C                   EVAL      OKTOC3  = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        POCUS4  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POCUS4        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'POCUS4'                   CAP084
     C                   EVAL      OKTOC4  = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        POCUS5  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POCUS5        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'POCUS5'                   CAP084
     C                   EVAL      OKTOC5  = 'N'
     C                   Endif
     C                   Endif
     C                   EndIf                                                              BUG25130
     C     PPTYP         Ifeq      'RI'                                                       221774
     C     OKTOC1        Andne     'N'                                                        221774
     C     PPTYP         Oreq      'RI'                                                       221774
     C     POCUS1        Andeq     *blanks                                                    221774
      *                                                                                       221774
     C                   If        PoCus2 <> *blanks                                          221774
     C                             And CSW207 <> 'Y'                                         CSW207A
      *                                                                                       221774
     C                   If        PHOCUS1 = *blanks                                          221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0921'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus2'                                221774
     C                   Eval      OkToC2 = 'N'                                               221774
     C                   Else                                                                 221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0131'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus2'                                221774
     C                   Eval      OkToC2 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   If        PoCus3 <> *blanks                                          221774
     C                             And CSW207 <> 'Y'                                         CSW207A
      *                                                                                       221774
     C                   If        PHOCUS1 = *blanks                                          221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0921'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus3'                                221774
     C                   Eval      OkToC3 = 'N'                                               221774
     C                   Else                                                                 221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0131'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus3'                                221774
     C                   Eval      OkToC3 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   If        PoCus4 <> *blanks                                          221774
     C                             And CSW207 <> 'Y'                                         CSW207A
      *                                                                                       221774
     C                   If        PHOCUS1 = *blanks                                          221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0921'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus4'                                221774
     C                   Eval      OkToC4 = 'N'                                               221774
     C                   Else                                                                 221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0131'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus4'                                221774
     C                   Eval      OkToC4 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   If        PoCus5 <> *blanks                                          221774
     C                             And CSW207 <> 'Y'                                         CSW207A
      *                                                                                       221774
     C                   If        PHOCUS1 = *blanks                                          221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0921'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus5'                                221774
     C                   Eval      OkToC5 = 'N'                                               221774
     C                   Else                                                                 221774
     C                   Eval      Idx             =   Idx+1                                  221774
     C                   Eval      RetCodeIn       =   'Error'                                221774
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0131'                               221774
     C                   Eval      FldNamXAr(Idx)  =  'PoCus5'                                221774
     C                   Eval      OkToC5 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   Endif                                                                221774
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     VALIDATE      BEGSR
      *
      ** 50F Validation                                                                      CSW207A
     C                   EXSR      SrSwft                                                    CSW207A
                                                                                             CSW207A
      ** If this field has already been entered in the header, entry here is
      ** prohibited.  Otherwise, this field is mandatory.
     C                   IF        POCUS1 = *Blanks
     C                             And POCUS2 = *Blanks                                       226083
     C                             And POCUS3 = *Blanks                                       226083
     C                             And POCUS4 = *Blanks                                       226083
     C                             And POCUS5 = *Blanks                                       226083
      *
     C                   IF        PHOCUS1 = *Blanks
     C                   MOVE      'N'           OKTOC1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0130'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Else Ordering Customer has been entered here:
     C                   ELSE
      *
      ** Field must not have been entered on the header.
     C                   IF        PHOCUS1 <> *Blanks
     C                   MOVE      'N'           OKTOC1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0131'     MsgIdXAr(Idx)
     C                   ELSE
     C*                                                                                     BUG24734
     C                   If        %Subst(POCUS1:1:1) = '/' And                             BUG24734
     C                             POCUS2 = *Blanks                                         BUG24734
     C                   Eval      Idx            =   Idx+1                                 BUG24734
     C                   Eval      RetCodeIn      =   'Error'                               BUG24734
     C                   Eval      MsgIdXAr(Idx)  =  'FTM2152'                              BUG24734
     C                   Eval      FldNamXAr(Idx) =  DDSName                                BUG24734
     C                   Eval      OkToc1  = 'N'                                            BUG24734
     C                   Leavesr                                                            BUG24734
     C                   Endif                                                              BUG24734
      *
      ** If the Transfer Type is 'RO':
      *                                                                                       226083
      **  The following Ord Cust Validations for ROs are wrong                                226083
      **    (1) It shouldn't have to check for '/' in lines 2-5                               226083
      **    (2) Validation for external IBAN checking is not done properly.                   226083
      **    (3) First line shouldn't be validated as an Internal account                      226083
      **    (4) It is line 2 that needs to be checked with CNUM or SHNAME entry               226083
      **        and not line 1!                                                               226083
      **  Re-write the Ord Cust validation for ROs as follows:                                226083
      **    (1) Line 1 should be an a/c line (starting with '/') -  already checked above     226083
      **    (2) Check a/c line for IBAN format (external check)                               226083
      **    (3) Line 2 is mandatory (may contain CNUM, SHNAME or free format entry)           226083
      **    (4) If lines 3-5 empty, check for customer, shortname entry on line 2             226083
      **    (5) If lines 3-5 filled, consider as free-format entry (type A)                   226083
      **        even if line 2 is customer or shortname (same as in Outgoing Payments)        226083
      **                                                                                      226083
     C                   IF        PPTYP = 'RO'
      *
      ** The Ordering Customer must begin with '/'
     C                   IF        %SUBST(POCUS1:1:1) <> '/'
     C**********                   And CSW207 <> 'Y'                                CSW207A BUG15239
     C                             And Valid50F = 'N'                                       BUG15239
     C                             AND PMSGID <> 'FTS0055'                                  BUG25685
     C                   MOVE      'N'           OKTOC1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0132'     MsgIdXAr(Idx)
     C                   ELSE
 
     C*                                                                                       226083
     C* Remove the following lines of codes as Ordering customer for ROs should               226083
     C* not be validated as internal accounts, and there is no need to check '/'              226083
     C* on each line.                                                                         226083
     C*                                                                                       226083
     C***********        EVAL      P@IBAN = %SUBST(POCUS1:2)                                  226083
      ***********                                                                             226083
     C***********        EXSR      ValAccnt                                                   226083
      ***********                                                                             226083
      ***The*currency of the A/C entered must equal the Transfer Currency                     226083
     C***********        IF        P@TYPE = '*NOSTRO'  OR                                     226083
     C***********                  P@TYPE = '*LEDGER'  OR                                     226083
     C***********                  P@TYPE = '*RETAIL'                                         226083
     C***********        IF        CCY <> PTRNCCY  and  PTRNCCY <> *Blanks      I:A/c Currency226083
     C***********        MOVE      'N'           OKTOC1                                       226083
     C***********        ADD       1             Idx                                          226083
     C***********        MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C***********        MOVEL     'RFV0134'     MsgIdXAr(Idx)                                226083
     C***********        ENDIF                                                                226083
      ***********                                                                             226083
     C***********        ENDIF                                                                226083
      ***********                                                                             226083
     C***********        ENDIF                                                                226083
      ***********                                                                             226083
      ***Ensure*that the second line does not contain /                                       226083
      ***********                                                                             226083
     C*****'/'***        SCAN      PoCus2        ScanPos2          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos2 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0348'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PoCus2'                                226083
     C***********        Eval      OkToC2 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ***Ensure*that the third line does not contain /                                        226083
      ***********                                                                             226083
     C*****'/'***        SCAN      POCus3        ScanPos3          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos3 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0349'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PoCus3'                                226083
     C***********        Eval      OkToC3 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ***Ensure*that the forth line does not contain /                                        226083
      ***********                                                                             226083
     C*****'/'***        SCAN      POCus4        ScanPos4          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos4 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0350'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PoCus4'                                226083
     C***********        Eval      OkTOC4 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ***Ensure*that the fifth line does not contain /                                        226083
      ***********                                                                             226083
     C*****'/'***        SCAN      PoCus5        ScanPos5          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos5 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0351'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PoCus5'                                226083
     C***********        Eval      OkToc5 = 'N'                                               226083
     C***********        Endif                                                                226083
     C*                                                                                       226083
     C*                                                                                       226083
     C** Line 1: Check for IBAN entry and correctness of format                               226083
     C*                                                                                       226083
     C                   If        CFT004 = 'Y'                                               226083
     C*                                                                                       226083
     C                   EVAL      PIBAN    = *blanks                                         226083
     C                   EVAL      PIBAN    = %Subst(POCUS1:2)                                226083
                                                                                              226083
      *  Format field, removing blanks and IBAN prefix                                        226083
                                                                                              226083
     C                   CALL      'AOIBANR3'                                                 226083
     C                   PARM                    @Rcode            7                          226083
     C                   PARM                    PIBAN            47                          226083
     C                   PARM                    POWith           47                          226083
     C     P@IBAN        PARM                    PONobl           34                          226083
                                                                                              226083
      *  If first four characters are 'AANN', proceed with IBAN validn                        226083
                                                                                              226083
     C     1             SUBST     P@IBAN:1      IBCTY1            1                          226083
     C     1             SUBST     P@IBAN:2      IBCTY2            1                          226083
     C     1             SUBST     P@IBAN:3      IBCHK1            1                          226083
     C     1             SUBST     P@IBAN:4      IBCHK2            1                          226083
     C     IBCTY1        LOOKUP    ALPH                                   94                  226083
     C   94IBCTY2        LOOKUP    ALPH                                   94                  226083
     C   94IBCHK1        LOOKUP    NUMC                                   94                  226083
     C   94IBCHK2        LOOKUP    NUMC                                   94                  226083
     C*                                                                                       226083
     C                   If        *IN94 = *ON                                                226083
     C*                                                                                       226083
     C                   CallB     'AOIBANR5'                           90                    226083
     C                   Parm      *Blanks       @RTCD                                        226083
     C                   Parm                    P@IBAN                                       226083
                                                                                              226083
     C                   IF        *IN90 = *Off and @RTCD  = *Blanks                          226083
     C*                                                                                       226083
     C                   ELSE                                                                 226083
                                                                                              226083
      *  Warnings:                                                                            226083
                                                                                              226083
     C                   Eval      WIx             =   WIx+1                                  226083
     C                   Eval      RetCodeIn       =   'Error'                                226083
     C                   Eval      WFldNmXAr(WIx) =  DDSName                                  226083
     C                   Eval      OKTOC1 = 'W'                                               226083
                                                                                              226083
     C                   SELECT                                                               226083
                                                                                              226083
      *  Invalid ISO country code                                                             226083
     C                   WHEN      @RTCD  = '      1'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2400'                                 226083
      *  Invalid BBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      2'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2401'                                 226083
      *  Invalid character                                                                    226083
     C                   WHEN      @RTCD  = '      3'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2402'                                 226083
      *  Invalid IBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      4'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2403'                                 226083
      *  Invalid check digit                                                                  226083
     C                   WHEN      @RTCD  = '      5'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'                                 226083
      *  Other/non-specific warning                                                           226083
     C                   OTHER                                                                226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'                                 226083
     C                   ENDSL                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                  End IBAN chk  226083
     C*                                                                                       226083
     C** Line 2 is mandatory                                                                  226083
     C*                                                                                       226083
     C                   If        POCUS2 = *Blanks AND                                       226083
     C                             POCUS3 = *Blanks AND                                       226083
     C                             POCUS4 = *Blanks AND                                       226083
     C                             POCUS5 = *Blanks                                           226083
     C**********                   And CSW207 <> 'Y'                                CSW207A BUG15239
     C                             AND Valid50F = 'N'                                       BUG15239
                                                                                              226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0081'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      OkToc1  = 'N'                                              226083
                                                                                              226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C** Embedded blanks not allowed                                                          226083
     C*                                                                                       226083
     C                   If        POCUS2 = *Blanks AND                                       226083
     C                             POCUS3 <>*Blanks OR                                        226083
     C                             POCUS2 = *Blanks AND                                       226083
     C                             POCUS4 <>*Blanks OR                                        226083
     C                             POCUS2 = *Blanks AND                                       226083
     C                             POCUS5 <>*Blanks OR                                        226083
     C                             POCUS3 = *Blanks AND                                       226083
     C                             POCUS4 <>*Blanks OR                                        226083
     C                             POCUS3 = *Blanks AND                                       226083
     C                             POCUS5 <>*Blanks OR                                        226083
     C                             POCUS4 = *Blanks AND                                       226083
     C                             POCUS5 <>*Blanks                                           226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0925'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      OkToc2    = 'N'                                            226083
     C                   Eval      OkToc3    = 'N'                                            226083
     C                   Eval      OkToc4    = 'N'                                            226083
     C                   Eval      OkToc5    = 'N'                                            226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C**  Now, Ordering Customer for RO is completely valid.                                  226083
     C**  Assign Entry type (P@TYPE)                                                          226083
     C*                                                                                       226083
     C                   If        OkToc1    <>'N'    OR                                      226083
     C                             OkToc2    <>'N'    OR                                      226083
     C                             OkToc3    <>'N'    OR                                      226083
     C                             OkToc4    <>'N'    OR                                      226083
     C                             OkToc5    <>'N'                                            226083
     C*                                                                                       226083
     C*       Assume an Address type                                                          226083
     C*                                                                                       226083
     C                   IF        PDCUSTP = *BLANKS                                       BUG15010A
     C                   Eval      P@TYPE  = '*ADDRES'                                        226083
     C                   ENDIF                                                             BUG15010A
      *                                                                                     BUG21228
      ** Validate Ordering Customer                                                         BUG21228
      ** If Full address and does not start with a '/'                                      BUG21228
      ** second line should not be blank                                                    BUG21228
      *                                                                                     BUG21228
     C                   If        PDCUSTP = 'A'                                            BUG21228
     C                             And %SUBST(POCUS1:1:1) = '/'                             BUG21228
     C                             And POCUS2 = *BLANKS                                     BUG21228
     C                             And OkToc1 <> 'N'                                        BUG21228
      * Send error to screen                                                                BUG21228
     C                   Eval      OkToc1 = 'N'                                             BUG21228
     C                   Eval      Idx             =   Idx+1                                BUG21228
     C                   Eval      FldNamXAr(Idx)  =  DDSName                               BUG21228
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0081'                             BUG21228
     C                   Eval      RetCodeIn       =   'Error'                              BUG21228
      *                                                                                     BUG21228
     C                   ElseIf    PDCUSTP = 'A'                                            BUG21228
     C                             And %SUBST(POCUS1:1:1) <> '/'                            BUG21228
     C                             And POCUS2 = *BLANKS                                     BUG21228
     C                             And OkToc1 <> 'N'                                        BUG21228
      * Send error to screen                                                                BUG21228
     C                   Eval      OkToc1 = 'N'                                             BUG21228
     C                   Eval      Idx             =   Idx+1                                BUG21228
     C                   Eval      FldNamXAr(Idx)  =  DDSName                               BUG21228
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0076'                             BUG21228
     C                   Eval      RetCodeIn       =   'Error'                              BUG21228
     C                   EndIf                                                              BUG21228
     C*                                                                                       226083
     C*       Unless, it is a customer number or shortname (type = 'C')                       226083
     C*                                                                                       226083
     C                   If        POCUS3 =  *blank   AND                                     226083
     C                             POCUS4 =  *blank   AND                                     226083
     C                             POCUS5 =  *blank   AND                                     226083
     C                             %Subst(POCUS2:1:6) <> *blank  AND                          226083
     C                             %Subst(POCUS2:7:29) = *blank  OR                           226083
     C*                                                                                       226083
     C                             POCUS3 =  *blank   AND                                     226083
     C                             POCUS4 =  *blank   AND                                     226083
     C                             POCUS5 =  *blank   AND                                     226083
     C                             %Subst(POCUS2:1:10) <> *blank  AND                         226083
     C                             %Subst(POCUS2:11:25) = *blank                              226083
                                                                                              226083
     C                   Eval      KeyVal = %subst(POCUS2:1:10)                               226083
                                                                                              226083
     C                   Call      'AOCUSTR0'                                                 226083
     C                   Parm      *Blanks       @Rtcd                                        226083
     C                   Parm      '*KEY   '     @Optn                                        226083
     C                   Parm                    KeyVal           10                          226083
     C                   Parm      *Blanks       @Type                                        226083
     C                   Parm                    C@FMT                                        226083
                                                                                              226083
     C                   If        @RTCD =  *BLANKS   AND                                     226083
     C                             @Type =  '*CSHT  ' OR                                      226083
     C                             @RTCD =  *blanks   AND                                     226083
     C                             @Type =  '*CNUM  '                                         226083
     C                   Eval      P@TYPE  = '*CUSTNO'                                        226083
     C                   If        @Type =  '*CSHT  '                                         226083
     C                   Movel(P)  BBCUST        POCUS2                                       226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
      *                                                                                       226083
      *<-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <->                        226083
      *
      ** If the Transfer Type is 'RI':
     C                   ELSE
      *
     C**********         If        %Subst(POCUS1:1:1) = '/'                                 BUG24464
     C**********         Eval      POCUS1 = %Subst(POCUS1:2)                                BUG24464
     C**********         Endif                                                              BUG24464
      *
      ** First line must contain a valid account - nostro, GL, retail or
      ** an IBAN.
     C***********        EVAL      P@IBAN = POCUS1                                            226083
      *
     C                   EXSR      ValAccnt
      *
     C                   IF        P@TYPE = '*NOSTRO'  OR
     C                             P@TYPE = '*RETAIL'  OR
     C                             P@TYPE = '*IBAN  '  OR                                     226083
     C                             P@TYPE = '*LEDGER'
      *                                                                                       221776
     C                   MOVE      RETB          WRETB             1                          221776
      *                                                                                       221776
      ** Bankrupt/Liquidated                                                                  221776
      *                                                                                       221776
     C                   TESTB     '6'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0015'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKTOC1 = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Bad Debt                                                                             221776
      *                                                                                       221776
     C                   TESTB     '7'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0016'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKTOC1 = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Blocked Debit                                                                        221776
      *                                                                                       221776
     C                   TESTB     '2'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0014'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKTOC1 = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Inactive                                                                             221776
      *                                                                                       221776
     C**********         TESTB     '4'           WRETB                    48           221776 259576
     C**********         If        *IN48 = '1'                                         221776 259576
     C**********         Eval      WIx              =   WIx + 1                        221776 259576
     C**********         Eval      RetCodeIn        =   'Error'                        221776 259576
     C**********         Eval      WMsgIdXAr(WIx)   =   'FTM0017'                      221776 259576
     C**********         Eval      WFldNmXAr(WIx)   =   DDSName                        221776 259576
     C**********         If        OKTOC1 <> 'N'                                       221776 259576
     C**********         Eval      OKTOC1 = 'W'                                        221776 259576
     C**********         Endif                                                         221776 259576
     C**********         Endif                                                         221776 259576
      *                                                                                       221776
      ** Referred Debit                                                                       221776
      *                                                                                       221776
     C                   TESTB     '0'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      WIx              =   WIx + 1                               221776
     C                   Eval      RetCodeIn        =   'Error'                               221776
     C                   Eval      WMsgIdXAr(WIx)   =   'FTM0018'                             221776
     C                   Eval      WFldNmXAr(WIx)   =   DDSName                               221776
     C                   If        OKTOC1 <> 'N'                                              221774
     C                   Eval      OKTOC1 = 'W'                                               221776
     C                   Endif                                                                221774
     C                   Endif                                                                221776
      *                                                                                       221776
      *
      ** The currency of the A/C entered must equal the Transfer Currency
     C                   IF        CCY <> PTRNCCY  and  PTRNCCY <> *Blanks      I:A/c Currency
     C                   MOVE      'N'           OKTOC1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0134'     MsgIdXAr(Idx)
     C                   ELSE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        P@TYPE = '*NRF'
     C                             AND CSW207 <> 'Y'                                         CSW207A
     C                   MOVE      'N'           OKTOC1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0133'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAccnt - Validate/retreive details of account entered       *
      *            in Ordering Customer field.                        *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     ValAccnt      BEGSR
      *
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
     C                   IF        CFT004 = 'Y'
                                                                                              226083
     C                   Eval      PIBAN = *blanks                                            226083
     C                   If        %SUBST(POCUS1:1:1) = '/'                                 BUG25130
     C                   Eval      PIBAN  =  %subst(POCUS1:2:34)                            BUG25130
     C                   Else                                                               BUG25130
     C                   Eval      PIBAN = POCUS1                                             226083
     C                   EndIf                                                              BUG25130
                                                                                              226083
     C                   CALL      'AOIBANR3'                                                 226083
     C                   PARM                    IBANRetCde        7                          226083
     C                   PARM                    PIBAN            47                          226083
     C                   PARM                    POWITH           47                          226083
     C     P@IBAN        PARM                    PONOBL           34                          226083
                                                                                              226083
     C     1             SUBST     P@IBAN:1      BCTY1             1                          226083
     C     1             SUBST     P@IBAN:2      BCTY2             1                          226083
     C     1             SUBST     P@IBAN:3      BDGT1             1                          226083
     C     1             SUBST     P@IBAN:4      BDGT2             1                          226083
     C     BCTY1         LOOKUP    ALPH                                   94                  226083
     C   94BCTY2         LOOKUP    ALPH                                   94                  226083
     C   94BDGT1         LOOKUP    NUMC                                   94                  226083
     C   94BDGT2         LOOKUP    NUMC                                   94                  226083
      *                                                                                       226083
      ** Check that it is a valid IBAN                                                        226083
     C                   IF        *IN94 = *ON                                                226083
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       IBANRetCde        7            B:Return code
     C                   PARM                    P@IBAN           34            I:Option
     C                   PARM      *Blanks       AccRecord                      O:Data Structure
      *                                                                                       226083
     C                   If        IBANRetCde <> *blank                                       226083
     C                             And Idx = 0                                              BUG25130
     C**********         Eval      Idx            =   Idx+1                          226083 BUG25130
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C**********         Eval      FldNamXAr(Idx) =  DDSName                         226083 BUG25130
     C**********         Eval      OkToc1    = 'N'                                   226083 BUG25130
     C                   Eval      WIx = WIx + 1                                            BUG25130
     C                   Eval      WFldNmXAr(WIx) =  DDSName                                BUG25130
     C                   Eval      OkToc1    = 'W'                                          BUG25130
     C**********         Eval      WMsgDtXAr(WIx) = POCUS1                         BUG26222 MD000091
     C                   EVAL      BLen = %Len(%Trim(POCUS1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(POCUS1)                   MD000091
      *                                                                                       226083
      ** Invalid country                                                                      226083
     C                   Select                                                               226083
     C                   When      IBANRetCde  = '      1'                                    226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0125'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(Wix) = 'FTM2400'                               BUG25130
      ** Invalid BBAN length on country file                                                  226083
     C                   When      IBANRetCde  = '      2'                                    226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0126'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2401'                               BUG25130
      ** IBAN contains invalid characters                                                     226083
     C                   When      IBANRetCde  = '      3'                                    226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0127'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2402'                               BUG25130
      ** IBAN length of BBAN is incorrect                                                     226083
     C                   When      IBANRetCde  = '      4'                                    226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0128'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2403'                               BUG25130
      ** Checks Digits are not corrects                                                       226083
     C                   When      IBANRetCde  = '      5'                                    226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0129'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2404'                               BUG25130
      ** Valid IBAN but not on the system, entry is not a valid account.                      226083
     C                   When      IBANRetCde  = '      6'                                    226083
     C**********         Eval      MsgIdXAr(Idx)  =  'RFV0931'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2405'                               BUG25130
     C                   Endsl                                                                226083
                                                                                              226083
     C                   Else                                                                 226083
                                                                                              226083
     C                   Eval      P@TYPE  = '*IBAN  '                                        226083
     C                   Eval      ACCRECORD = ACCRECORD                                      226083
     C                   EVAL      W#CCY  = CCY                                               226083
     C                   EVAL      W#ACOD = ACOD                                              226083
     C                   EVAL      W#ACSQ = ACSQ                                              226083
     C                   EVAL      W#BRCA = BRCA                                              226083
     C                   EVAL      W#CNUM = CNUM                                              226083
     C*  Ignore the rest of the processing as a valid IBAN has already been validated         226083
     C                   GOTO      EndValAccnt                                                226083
     C                   Endif                                                                226083
      *
     C                   ENDIF                                                                226083
     C*                                                                                       226083
     C                   ELSE
     C***********        MOVEL     'Dummy'       IBANRetCde        7            B:Return code 226083
     C***********        MOVEL     *Blanks       P@IBAN           34            I:Option      226083
     C                   MOVEL     *Blanks       P@TYPE                                       226083
     C                   ENDIF                                                  I:Option
      *
     C*  If not a valid IBAN, check if RETAIL, GL or NOSTRO                                   226083
      *                                                                                       226083
     C                   CLEAR                   AccRecord
 
     C                   EVAL      WPOCUS1 = POCUS1                                         BUG24734
     C*                                                                                     BUG24734
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       ACCTRetCde        7
     C                   Parm      *Blanks       P@TYPE            7
     C**********         Parm                    POCUS1                                     BUG24734
     C                   Parm                    WPOCUS1                                    BUG24734
     C                   Parm                    DSSDY
      *
     C                   If        ACCTRetCde = *Blanks
     C                   Select
     C                   When      P@TYPE = '*NOSTRO'
     C                   Eval      N@FMT = DSSDY
     C                   EVAL      W#CCY  = A7CYCD                              O:ACCNT Format
     C                   EVAL      CCY    = A7CYCD                              O:ACCNT Format
     C                   MOVEL     A7ACCD        W#ACOD
     C                   EVAL      W#ACSQ = 01                                  O:ACCNT Format
     C                   EVAL      W#BRCA = A7BRCD                              O:ACCNT Format
     C                   MOVEL     A7CUST        W#CNUM
     C                   Eval      P@ACID = POCUS1                                            221776
     C                   Call      'AOACCTV0'                                                 221776
     C                   Parm      *blanks       ACCTRetCde                                   221776
     C                   Parm                    P@ACID           10                          221776
     C                   Parm      *blanks       P@CYCD            3                          221776
     C                   Parm      *blanks       P@ACCD                                       221776
     C                   Parm      *blanks       P@ACSN            2                          221776
     C                   Parm      *blanks       P@BRCA            3                          221776
     C                   Parm      *blanks       @TYPE             7                          221776
     C                   Parm      *blanks       P@NOSN            2                          221776
     C     ACCRECORD     Parm      ACCRECORD     DSSDY                                        221776
     C                   When      P@TYPE = '*RETAIL'
     C                   Eval      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY                                 O:ACCNT Format
     C                   EVAL      W#ACOD = ACOD                                O:ACCNT Format
     C                   EVAL      W#ACSQ = ACSQ                                O:ACCNT Format
     C                   EVAL      W#BRCA = BRCA                                O:ACCNT Format
     C                   EVAL      W#CNUM = CNUM
     C                   When      P@TYPE = '*LEDGER'
     C                   Eval      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY                                 O:ACCNT Format
     C                   EVAL      W#ACOD = ACOD                                O:ACCNT Format
     C                   EVAL      W#ACSQ = ACSQ                                O:ACCNT Format
     C                   EVAL      W#BRCA = BRCA                                O:ACCNT Format
     C                   EVAL      W#CNUM = CNUM
     C                   Endsl
     C                   Endif
      *
     C     EndValAccnt   Tag                                                                  226083
     C*                                                                                       226083
     C                   ENDSR
      *****************************************************************                      CSW207A
      /EJECT                                                                                 CSW207A
      *****************************************************************                      CSW207A
      *                                                               *                      CSW207A
      *  SrSwft - Perform ordering customer validation for field :50F *                      CSW207A
      *                                                               *                      CSW207A
      *  Called by: Main processing                                   *                      CSW207A
      *                                                               *                      CSW207A
      *  Calls: FT001000                                              *                      CSW207A
      *                                                               *                      CSW207A
      *****************************************************************                      CSW207A
     C     SrSwft        Begsr                                                               CSW207A
                                                                                             CSW207A
     C                   IF        CSW207 = 'Y'                                              CSW207A
      * Check if valid Customer and get Account Type                                         CSW207A
                                                                                             CSW207A
     C                   IF        %SUBST(POCUS1:1:1) <> '/'                                BUG19578
     C                   EVAL      WPOCUS1 = POCUS1                                         BUG19257
     C                   ELSE                                                               BUG19578
     C                   EVAL      WPOCUS1 = POCUS2                                         BUG19578
     C                   ENDIF                                                              BUG19578
     C                   CallB     'AOACCTV1'                                                CSW207A
     C                   Parm      *Blanks       ACCTRetCde                                  CSW207A
     C                   Parm      *Blanks       P@TYPE                                      CSW207A
     C**********         Parm                    POCUS1                             CSW207A BUG19257
     C                   PARM                    WPOCUS1                                    BUG19257
     C                   Parm                    DSSDY                                       CSW207A
                                                                                             CSW207A
     C                   Eval      PAccount = *Blanks                                      BUG15010A
     C                   Eval      PAcType = *Blanks                                         CSW207A
     C                   If        ACCTRetCde = *Blanks                                      CSW207A
     C                   Select                                                              CSW207A
     C                   When      P@TYPE = '*NOSTRO'                                        CSW207A
     C                   Eval      PAcType = 'N'                                             CSW207A
     C                   When      P@TYPE = '*RETAIL'                                        CSW207A
     C                             Or P@TYPE = '*LEDGER'                                   BUG15010A
     C**********         Eval      PAcType = 'R'                                   CSW207A BUG15010A
     C                   Eval      AccRecord = DSSDY                                        BUG14755
     C                   Move      CNUM          WCNUM                                      BUG14755
     C                   Move      ACOD          WACOD                                      BUG14755
     C                   Move      ACSQ          WACSQ                                      BUG14755
     C                   Eval      PAccount = BRCA + WCNUM + CCY                            BUG14755
     C                                  + WACOD + WACSQ                                     BUG14755
     C**********         MOVEL     POCUS1        PAccount                           CSW207A BUG14755
     C                   If        P@TYPE = '*RETAIL'                                      BUG15010A
     C                   Eval      PAcType = 'R'                                           BUG15010A
     C                   Else                                                              BUG15010A
     C                   Eval      PAcType = 'P'                                           BUG15010A
     C                   EndIf                                                             BUG15010A
     C                   When      P@TYPE = '*LEDGER'                                        CSW207A
     C                   Eval      PAcType = 'L'                                             CSW207A
     C                   MOVEL     POCUS1        PAccount                                    CSW207A
     C                   When      P@TYPE = 'IBAN'                                           CSW207A
     C                   Eval      PAcType = 'I'                                             CSW207A
     C                   MOVEL     POCUS1        PAccount                                    CSW207A
     C                   When      P@TYPE = '*CUSTNO'                                        CSW207A
     C                   Eval      PAcType = 'C'                                             CSW207A
     C                   MOVEL     POCUS1        PCust                                       CSW207A
      *                                                                                      CSW207A
     C                   Movel     POCUS1        Keyval                                      CSW207A
     C                   Call      'AOCUSTR0'                                                CSW207A
     C                   Parm      *Blanks       @Rtcd                                       CSW207A
     C                   Parm      '*KEY   '     @Optn                                       CSW207A
     C                   Parm                    KeyVal                                      CSW207A
     C                   Parm      *Blanks       @Type                                       CSW207A
     C                   Parm                    C@FMT                                       CSW207A
     C                   EndSl                                                               CSW207A
     C                   ENDIF                                                               CSW207A
      *                                                                                      CSW207A
      ** If Return code is not blanks check if IBAN account                                  CSW207A
                                                                                             CSW207A
     C                   If        PActype = *BLANKS                                         CSW207A
     C                   EVAL      PCust = *BLANKS                                           CSW207A
     C                   Eval      PAccount = *BLANKS                                        CSW207A
     C                   Eval      PAcType = ' '                                             CSW207A
     C                   If        %Subst(POCUS1:1:1) = '/'                                  CSW207A
     C                   Eval      P@IBAN = %Subst(POCUS1:2)                                 CSW207A
     C                   Else                                                              BUG15010A
     C                   Eval      P@IBAN = POCUS1                                         BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                      CSW207A
      ** Check internal IBAN                                                                 CSW207A
      *                                                                                      CSW207A
     C                   Call      'AOIBANR2'                                                CSW207A
     C                   Parm      *Blanks       @RTCD                                       CSW207A
     C                   Parm                    P@IBAN                                      CSW207A
     C     AccRecord     Parm      AccRecord     DSSDY                                       CSW207A
      *                                                                                      CSW207A
     C                   If        @RTCD = *Blanks                                           CSW207A
     C                   Eval      PAcType = 'I'                                             CSW207A
     C                   Move      CNUM          WCNUM                                       CSW207A
     C                   Move      ACOD          WACOD                                       CSW207A
     C                   Move      ACSQ          WACSQ                                       CSW207A
     C                   Eval      PAccount = BRCA + WCNUM + CCY                             CSW207A
     C                                  + WACOD + WACSQ                                      CSW207A
     C                   Eval      PCountry = %Subst(P@IBAN:1:2)                             CSW207A
                                                                                             CSW207A
     C                   Else                                                                CSW207A
      *                                                                                      CSW207A
      ** Check external IBAN                                                                 CSW207A
      *                                                                                      CSW207A
     C                   Call      'AOIBANR5'                                                CSW207A
     C                   Parm      *Blanks       @RTCD                                       CSW207A
     C                   Parm                    P@IBAN                                      CSW207A
     C                   If        @RTCD = *Blanks                                           CSW207A
     C                   Call      'AOIBANR4'                                                CSW207A
     C                   Parm      *Blanks       @RTCD                                       CSW207A
     C                   Parm      '*KEY'        @OPTN                                       CSW207A
     C                   Parm                    P@IBAN                                      CSW207A
     C     AccRecord     Parm      AccRecord     DSSDY                                       CSW207A
     C                   If        @RTCD = *Blanks                                           CSW207A
     C                   Eval      PAcType = 'I'                                             CSW207A
     C                   Move      CNUM          WCNUM                                       CSW207A
     C                   Move      ACOD          WACOD                                       CSW207A
     C                   Move      ACSQ          WACSQ                                       CSW207A
     C                   Eval      PAccount = BRCA + WCNUM + CCY                             CSW207A
     C                                  + WACOD + WACSQ                                      CSW207A
     C                   Eval      PCountry = %Subst(P@IBAN:1:2)                             CSW207A
     C                   EndIf                                                               CSW207A
     C                   EndIf                                                               CSW207A
     C                   EndIf                                                               CSW207A
     C                   EndIf                                                               CSW207A
     C**********         ENDIF                                                     CSW207A BUG15010A
                                                                                             CSW207A
     C                   IF        PAcType = *BLANKS Or                                    BUG15010A
     C                             POCUS2 <> *Blanks                                       BUG15010A
     C                   Eval      PAcType =  'A'                                          BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   Eval      PDCUSTP =  PAcType                                      BUG15010A
     C**********         IF        PCUSTTP = *BLANKS OR                           BUG15065 BUG15010A
     C**********                   POCUS2 <> *BLANKS                              BUG15065 BUG15010A
     C**********         EVAL      PAcType = 'A'                                  BUG15065 BUG15010A
     C**********         ELSE                                                     BUG15065 BUG15010A
     C**********         EVAL      PAcType = PCUSTTP                              BUG15065 BUG15010A
     C**********         ENDIF                                                    BUG15065 BUG15010A
                                                                                  BUG15065 BUG15010A
      ** Get Country of Location parameter for FT001000                                    BUG15010A
      ** for Incoming must be the Destination, for Outgoing must be the Sender             BUG15010A
     C                   Exsr      GetCountry                                              BUG15010A
                                                                                           BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000            BUG15010A
     C                   If        PAcType = 'C'                                           BUG15010A
     C                   Movel     POCUS1        PCust                                     BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                     BUG21185
      ** Check if valid 50F format                                                          BUG21185
     C                   Eval      Valid50F = 'Y'                                           BUG21185
                                                                                           BUG15010A
     C                   CALL      'FT001000'    PLSWFT                                      CSW207A
                                                                                             CSW207A
     C                   IF        PRtnCde = '*ERROR'                                        CSW207A
                                                                                             CSW207A
     C                   IF        POMFlag  = 'E'                                           BUG26080
     C                   Eval      Valid50F = 'N'                                           BUG15239
     C                   ENDIF                                                              BUG26080
     C                                                                                      BUG15239
     C                   If        PPTYP = 'RI' and PMsgID = 'FTS0055'                      BUG15010
     C                   Eval      POMFlag = 'W'                                            BUG15010
     C                   EndIf                                                              BUG15010
      *                                                                                     BUG15010
     C                   IF        POMFlag = 'E'                                             CSW207A
     C                   Eval      Idx = Idx + 1                                             CSW207A
     C                   Eval      MsgIdXAr(Idx) = PMsgID                                    CSW207A
     C                   Eval      RetCodeIn = 'Error'                                       CSW207A
     C                   Eval      OKTOC1 = 'N'                                              CSW207A
     C                   Eval      OKTOC2 = 'N'                                              CSW207A
     C                   Eval      OKTOC3 = 'N'                                              CSW207A
     C                   Eval      OKTOC4 = 'N'                                              CSW207A
     C                   Eval      OKTOC5 = 'N'                                              CSW207A
     C                   Eval      FldNamXAr(Idx) = 'POCUS1'                                 CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
     C                   IF        POMFlag = 'W'                                             CSW207A
     C                   Eval      WIx = WIx + 1                                             CSW207A
     C                   Eval      WMsgIdXAr(WIx) = PMsgID                                   CSW207A
     C                   Eval      RetCodeIn = 'Error'                                       CSW207A
     C                   Eval      OKTOC1 = 'W'                                              CSW207A
     C                   Eval      OKTOC2 = 'W'                                              CSW207A
     C                   Eval      OKTOC3 = 'W'                                              CSW207A
     C                   Eval      OKTOC4 = 'W'                                              CSW207A
     C                   Eval      OKTOC5 = 'W'                                              CSW207A
     C                   Eval      WFldNmXAr(WIx) = 'POCUS1'                                 CSW207A
      *                                                                                     BUG15029
     C                   If        PMsgID = 'FTS0053'                                       BUG15029
     C**********         Eval      WMsgDtXAr(WIx) =PNetwork                        BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PNetwork))                             MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(PNetwork)                 MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                       BUG15029
     C**********         Eval      WMsgDtXAr(WIx) =PMsgTag                         BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PMsgTag))                              MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(PMsgTag)                  MD000091
     C                   Endif                                                              BUG15029
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
     C                   ENDIF                                                               CSW207A
      *                                                                                     BUG15188
     C**********         If        PRtnCde = *Blanks And                           BUG15188 BUG24481
     C                   If        PRtnCde <> '*ERROR' And                                  BUG24481
     C                             %SUBST(POCUS1:1:1) <> '/' And                            BUG15188
     C                             POCUS5    <> *Blank                                      BUG15188
     C                   If        %SUBST(POCUS5:1:2) <> '1/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '2/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '3/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '4/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '5/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '6/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '7/' And                           BUG15188
     C                             %SUBST(POCUS5:1:2) <> '8/'                               BUG15188
      * as CFT032 is not Switchable 50K can be input with 5 lines                           BUG15188
     C                   Move      'N'           OKTOC5                                     BUG15188
     C                   Eval      Idx = Idx + 1                                            BUG15188
     C                   Eval      FldNamXAr(Idx) = 'POCUS5'                                BUG15188
     C                   Eval      MsgIdXAr(Idx) = 'FTM7112'                                BUG15188
     C                   EndIf                                                              BUG15188
     C                   EndIf                                                              BUG15188
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
     C                   Endsr                                                               CSW207A
                                                                                             CSW207A
      *****************************************************************
      /EJECT
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetCountry - Get Country of Location Parameter for FT001000  *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetCountry    BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   Movel     *Blanks       PCountry                                  BUG15010A
     C                   Movel     *Blanks       PCust                                     BUG15010A
      *                                                                                    BUG15010A
      ** get Country of location                                                           BUG15010A
      ** for Outgoing must be the Destination, for Incoming must be the Sender             BUG15010A
     C                   If        PPTYP = 'RI'                                            BUG15010A
     C                   EVAL      ParmStr = PSINST                                        BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = PRFTDST                                       BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type                                     BUG15010A
     C                   Parm                    ParmStr          35                       BUG15010A
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
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
 
      *  Screen fields
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlags
      *  OK flags from screen 2
     C                   PARM                    OKTRAM            1
     C                   PARM                    OKTRCY            1
 
     C     PLSWFT        PLIST                                                               CSW207A
     C                   PARM      *Blanks       PRtnCde                                     CSW207A
     C                   PARM      *Blanks       PMsgID                                      CSW207A
     C                   PARM      *Blanks       POMFlag                                     CSW207A
     C                   PARM      'TRAN'        PVType                                      CSW207A
     C                   PARM      POCUS1        P50FmtF1                                    CSW207A
     C                   PARM      POCUS2        P50FmtF2                                    CSW207A
     C                   PARM      POCUS3        P50FmtF3                                    CSW207A
     C                   PARM      POCUS4        P50FmtF4                                    CSW207A
     C                   PARM      POCUS5        P50FmtF5                                    CSW207A
     C                   PARM                    PAcType                                     CSW207A
     C                   PARM                    PAccount                                    CSW207A
     C**********         PARM      *Blanks       PCust                              CSW207A BUG14856
     C                   PARM                    PCust                                      BUG14856
     C                   PARM      *Blanks       PNonActH                                    CSW207A
     C                   PARM      'SWIFT'       PNetwork                                    CSW207A
     C                   PARM      '101'         PMsgTyp                                     CSW207A
     C                   PARM      ':50F:'       PMsgTag                                     CSW207A
     C                   PARM                    PCountry                                    CSW207A
     C**********         PARM      *Blanks       PBrch                              CSW207A BUG15010
     C                   PARM      PBRCA         PBrch                                      BUG15010
     C**********         PARM      *Blanks       PCurr                              CSW207A BUG15010
     C                   PARM      PTRNCCY       PCurr                                      BUG15010
     C                   PARM      *Blanks       PNostro                                     CSW207A
     C**********         PARM      *Blanks       PModI                              CSW207A BUG15010
     C**********         PARM      'FT'          PModI                             BUG15010 BUG25973
     C                   PARM      PPTYP         PModI                                      BUG25973
     C                   PARM      *Blanks       POut1                                       CSW207A
     C                   PARM      *Blanks       POut2                                       CSW207A
     C                   PARM      *Blanks       POut3                                       CSW207A
     C                   PARM      *Blanks       POut4                                       CSW207A
     C                   PARM      *Blanks       POut5                                       CSW207A
                                                                                             CSW207A
      ** Access SAR file to see if CFT004 is present
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
     C                   Eval      DBKey  =  CFT004
     C                   Eval      DBFile = 'AOSARDR0'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                             CSW207A
     C                   CALL      'SWIF2007'                                                CSW207A
     C                   PARM      *BLANKS       @RTCD                                       CSW207A
                                                                                             CSW207A
     C                   IF        @RTCD = *BLANKS                                           CSW207A
     C                   MOVE      'N'           CSW207            1                         CSW207A
     C                   ELSE                                                                CSW207A
     C                   MOVE      'Y'           CSW207                                      CSW207A
     C                   ENDif                                                               CSW207A
 
      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  ALPH                                                                                    BUG25858
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                  BUG25858
**  NUMC                                                                                    BUG25858
1234567890                                                                                  BUG25858
