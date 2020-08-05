     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate RFT Header Ordering Customer')       *
      * ==============================================================
      *  Midas - Standard subprograms                                 *
 
      *  FTVHDCS01  - Validate RFT Header Ordering Customer           *
 
      *  (c) Finastra International Limited 2001                      *
 
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
 
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
 
      *  Last Amend No. 259576             Date 02Apr14               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034505           Date 26May15               *
      *                 MD027284           Date 25Nov14               *
      *                 MD000091           Date 07May13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26267           Date 01Oct09               *
      *                 BUG26237           Date 01Oct09               *
      *                 BUG26222           Date 29Sep09               *
      *                 BUG25973           Date 17Sep09               *
      *                 BUG26080           Date 17Sep09               *
      *                 BUG25897           Date 04Sep09               *
      *                 BUG25858           Date 02Sep09               *
      *                 BUG25685           Date 21Aug09               *
      *                 BUG24472           Date 24Jun09               *
      *                 BUG24469           Date 23Jun09               *
      *                 BUG25130           Date 27Jul09               *
      *                 BUG25238           Date 29Jul09               *
      *                 BUG24609           Date 29Jun09               *
      *                 BUG24434           Date 23Jun09               *
      *                 BUG25128           Date 23Jul09               *
      *                 BUG25015           Date 20Jul09               *
      *                 BUG24829           Date 09Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG21276           Date 07Oct08               *
      *                 BUG21272           Date 07Oct08               *
      *                 BUG21228           Date 30Sep08               *
      *                 BUG15239           Date 07Nov07               *
      *                 BUG15211           Date 01Nov07               *
      *                 BUG15010A          Date 25Oct07               *
      *                 BUG15188           Date 31Oct07               *
      *                 BUG15077           Date 22Oct07               *
      *                 BUG15065           Date 21Oct07               *
      *                 BUG15010           Date 17Oct07               *
      *                 BUG15029           Date 16Oct07               *
      *                 BUG14593           Date 12Aug07               *
      *                 CSW207A            Date 21Jun07               *
      *                 CSW207             Date 21Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8578            Date 20Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA020             Date 12Apr04               *
      *                 221761             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      *                 221538             Date 01Apr04               *
      *                 221774             Date 01Apr04               *
      *                 221776             Date 01Apr04               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 10Sep99               *
      *                                    Date ddmmmyy               *
 
      *---------------------------------------------------------------*
      *                                                               *
      *  259576 - Remove warning message for Inactive accounts.       *
      *           Applied for MD-26109                                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034505 - Database error encountered when Ordering Customer *
      *             is a Customer Number or Accountline               *
      *           - Partially applied BUG19263                        *
      *  MD027284 - Database error encountered upon inserting Customer*
      *             shortname in Ordering customer                    *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG26267 - Error message RFV0364 appears twice.              *
      *  BUG26237 - Error message that appear is incorrect.           *
      *  BUG26222 - Warning message is Unclear.                       *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG26080 - Valid 50f format was rejected.                    *
      *  BUG25897 - Unexpected error occurred.                        *
      *  BUG25858 - Slash + IBAN not validated                        *
      *  BUG25685 - Valid 50F Format input is rejected.               *
      *  BUG24472 - IBAN Validations not performed                    *
      *  BUG24469 - No error message displayed                        *
      *  BUG25130 - Warning message should be displayed not error     *
      *             message                                           *
      *  BUG25238 - Should not accept values. Error should be         *
      *             displayed                                         *
      *  BUG24609 - At least one line of text must be entered after   *
      *             the account identifier                            *
      *  BUG24434 - Invalid Characters was accepted                   *
      *  BUG25128 - Should not accept values. Error should be         *
      *             displayed.                                        *
      *  BUG25015 - External account treated as internal in RFTD RI   *
      *  BUG24829 - Database error message is encountered             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG21276 - Applied fix 19193A                                *
      *  BUG19193A - No validation done on 3/                         *
      *  BUG21272 - MT101 Ordering customer output in Detail is       *
      *             different from the Header section                 *
      *  BUG21228 - Invalid Customer # was not rejected.              *
      *  BUG15239 - Wrong 50H Output in MT101                         *
      *  BUG15211 - Not accepting partial account in ordering customer*
      *             in header                                         *
      *  BUG15010A - Fix CFT032/CSW207 errors -Reopen                 *
      *  BUG15188 - 5th line of ordering customer should be blank for *
      *             full address.                                     *
      *  BUG15077 - Conflict in validations for 50F and 50G/50H.      *
      *  BUG15065 - Error for SOSE identification type                *
      *  BUG15010 - CFT032 / CSW207 Errors                            *
      *  BUG15029 - Warning message displayed was "ERROR - Message    *
      *             not found                                         *
      *  BUG14593 - SWIFT 2007 error in SP08                          *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8578- Correct error message for RI RFT                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA020 - Correct account code length in call to AOACCTV0.    *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  226083 - Correct various RFTD validation errors              *
      *  221538 - Expansion of field details.                         *
      *  221774 - Ensure lines 2-5 is blank if line 1 is blank or     *
      *           contains a valid account.                           *
      *  221776 - Ensure account conditions are also validated.       *
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
     F*  +--------------------------------------+
     D CFT004          S              1    INZ(' ')
     D CSW207          S              1    INZ(' ')                                           CSW207
     D WCNUM           S              6A                                                     CSW207A
     D WACOD           S             10A                                                     CSW207A
     D WACSQ           S              2A                                                     CSW207A
     D Valid50F        S              1A   INZ('N')                                         BUG15239
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * OK Flags for screen - Header
     D OKFlagHs      E DS                  EXTNAME(FTE101HPD)
 
     D GenOkFlag       S              1    Import
 
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
     D WIdx            S              3P 0
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D P@ACCT        E DS                  EXTNAME(ACCNTAB)                                   221776
     D                                     PREFIX(A_)                                         221776
     D IBAN                                LIKE(CFT004)
                                                                                           BUG15010A
     D S_ACCNT       E DS                  EXTNAME(ACCNTAB)                                BUG15010A
     D                                     PREFIX(S_)                                      BUG15010A
     D A_DSSDY       E DS                  EXTNAME(DSSDY)                                  BUG15010A
     D                                     PREFIX(A_)                                      BUG15010A
     D N_SDNOST      E DS                  EXTNAME(SDNOSTPD)                               BUG15010A
     D                                     PREFIX(N_)                                      BUG15010A
     D C_SDCUST      E DS                  EXTNAME(SDCUSTPD)                               BUG15010A
     D                                     PREFIX(C_)                                      BUG15010A
 
     D IbanStr         S             34
 
     D RespMode        S              1
     D DDSName         S             10
     D WAccStr         S              1    INZ('N')                                           221538
 
     D AccStr          S                   Like(PHOCUS1)
     D @TYPE           S                   Like(@RTCD)
      *                                                                                       226083
      ** Alphabetic array                                                                     226083
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)                          226083
      *                                                                                       226083
      ** Numeric array                                                                        226083
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)                          226083
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                       226083
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
 
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
 
     C                   Eval      GenOkFlag = 'Y'
     C                   Eval      OkHoc1 = 'Y'
     C                   Eval      OkHoc2 = 'Y'
     C                   Eval      OkHoc3 = 'Y'
     C                   Eval      OkHoc4 = 'Y'
     C                   Eval      OkHoc5 = 'Y'
 
     C                   Eval      PCUSTTP = ' '
 
     C***********        Eval      ScanPos2  = *Zeros                                         226083
     C***********        Eval      ScanPos3  = *Zeros                                         226083
     C***********        Eval      ScanPos4  = *Zeros                                         226083
     C***********        Eval      ScanPos5  = *Zeros                                         226083
 
      * Optional.  (If not entered in general details, mandatory in
      * transaction details).  Send Warning Message
 
     C***********        If        PHOCUS1 = *Blanks                                          226083
     C                   If        PHOCUS1 = *Blanks  And                                     226083
     C                             PHOCUS2 = *blanks  And                                     226083
     C                             PHOCUS3 = *blanks  And                                     226083
     C                             PHOCUS4 = *blanks  And                                     226083
     C                             PHOCUS5 = *blanks                                          226083
     C*                                                                                       226083
     C                   Eval      WIdx             =   WIdx+1
     C                   Eval      RetCodeIn        =   'Error'
     C                   Eval      WMsgIdXAr(WIdx)  =   'RFV0031'
     C                   Eval      WFldNmXAr(WIdx)  =   DDSName
     C                   Eval      GenOkFlag = 'W'
     C                   Return
     C                   Endif
      *                                                                                     BUG24469
     C                   IF        %SUBST(PHOCUS1:1:1) = '/' And                            BUG24469
     C                             PHOCUS2 = *Blanks                                        BUG24469
      *                                                                                     BUG24469
     C                   Eval      Idx             =   Idx+1                                BUG24469
     C                   Eval      RetCodeIn       =   'Error'                              BUG24469
     C                   Eval      MsgIdXAr(Idx)   =  'FTM2152'                             BUG24469
     C                   Eval      FldNamXAr(Idx)  =  DDSName                               BUG24469
     C                   Eval      GenOkFlag = 'N'                                          BUG24469
     C                   Return                                                             BUG24469
     C                   ENDIF                                                              BUG24469
      *                                                                                       CSW207
     C*****CSW207        Ifeq      'Y'                                               CSW207 BUG15077
     C                   If        CSW207 = 'Y'                                             BUG15077
     C***********                  And PHOCUS2 = *Blanks                           BUG25130 BUG25238
     C***********                  And %Subst(PHOCUS1:1:1) <> '/'                  BUG15077 BUG21272
     C                   Exsr      SRValidate                                                 CSW207
     C                   Endif                                                                CSW207
      *                                                                                    BUG19193A
      ** Validate customer if in 50F format                                                BUG19193A
      *                                                                                    BUG19193A
     C                   IF        CSW207 = 'Y'                                            BUG19193A
     C                             and GenOkFlag = 'Y'                                      BUG25238
     C                             AND %SUBST(PHOCUS1:1:1) = '/'                           BUG19193A
     C                   IF        %SUBST(PHOCUS2:1:2) = '1/' OR                           BUG19193A
     C                             %SUBST(PHOCUS2:1:2) = '2/' OR                           BUG19193A
     C                             %SUBST(PHOCUS2:1:2) = '3/' OR                           BUG19193A
     C                             %SUBST(PHOCUS2:1:2) = '4/' OR                           BUG19193A
     C                             %SUBST(PHOCUS2:1:2) = '5/' OR                           BUG19193A
     C                             %SUBST(PHOCUS2:1:2) = '6/' OR                           BUG19193A
     C                             %SUBST(PHOCUS2:1:2) = '7/'                              BUG19193A
     C                   EXSR      SRValidate                                              BUG19193A
     C                   ENDIF                                                             BUG19193A
     C                   ENDIF                                                             BUG19193A
      *
      * The first character in line 1 must be / for outward 101's
      *
     C                   If        %Subst(PHOCUS1:1:1) <> '/' AND
     C                             PPTYP = 'RO'
     C**********                   And CSW207 <> 'Y'                                CSW207A BUG15239
     C                             And Valid50F = 'N'                                       BUG15239
     C                             AND PMSGID <> 'FTS0055'                                  BUG25685
     C                             AND GenOkFlag = 'Y'                                      BUG26237
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0079'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif
 
     C                   Select
     C                   When      PPTYP = 'RO'
 
      * Ensure that the second character is not blank
     C                   If        %Subst(PHOCUS1:2:1) = *Blank
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0173'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif
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
      ***********                                                                             226083
      ***Ensure*that the second line does not contain /                                       226083
      ***********                                                                             226083
     C*****'/'***        SCAN      PHoCus2       ScanPos2          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos2 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0348'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PHoCus2'                               226083
     C***********        Eval      OkHoc2 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ***Ensure*that the third line does not contain /                                        226083
      ***********                                                                             226083
     C*****'/'***        SCAN      PHoCus3       ScanPos3          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos3 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0349'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PHoCus3'                               226083
     C***********        Eval      OkHoc3 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ***Ensure*that the forth line does not contain /                                        226083
      ***********                                                                             226083
     C*****'/'***        SCAN      PHoCus4       ScanPos4          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos4 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0350'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PHoCus4'                               226083
     C***********        Eval      OkHoc4 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ***Ensure*that the fifth line does not contain /                                        226083
      ***********                                                                             226083
     C*****'/'***        SCAN      PHoCus5       ScanPos5          2 0                        226083
      ***********                                                                             226083
     C***********        If        ScanPos5 <> 0                                              226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0351'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  'PHoCus5'                               226083
     C***********        Eval      OkHoc5 = 'N'                                               226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      **If*feature CFT004 is active,                                                          226083
      *****Call*AOIBANR5 (validate external IBAN).  This is turn calls                        226083
      *****AOIBANR0 (validate IBAN check digit)                                               226083
     C***********        If        CFT004 = 'Y'                                               226083
     C***********        Move      PHOCUS1       IbanStr                                      226083
     C***********        CallB     'AOIBANR5'                                                 226083
     C***********        Parm      *Blanks       @RTCD                                        226083
     C***********        Parm                    Iban                                         226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        If        @RTCD <> *Blanks   OR                                      226083
     C***********                  CFT004 = 'N'                                               226083
     C***********        Eval      IBAN = 'N'                                                 226083
     C***********        Else                                                                 226083
     C***********        Eval      IBAN = 'Y'                                                 226083
      **If*an*IBAN, ensure that an additional line of text entered                            226083
     C***********        If        PHOCUS2 = *Blanks And                                      226083
     C***********                  PHOCUS3 = *Blanks And                                      226083
     C***********                  PHOCUS4 = *Blanks And                                      226083
     C***********                  PHOCUS5 = *Blanks                                          226083
     C***********        Eval      Idx             =   Idx+1                                  226083
     C***********        Eval      RetCodeIn       =   'Error'                                226083
     C***********        Eval      MsgIdXAr(Idx)   =  'RFV0080'                               226083
     C***********        Eval      FldNamXAr(Idx)  =  DDSName                                 226083
     C***********        Eval      GenOkFlag = 'N'                                            226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      *****If*the entry in line 1 is not an IBAN, ensure the entry in line 1                  226083
      *****is*a*valid customer or shortname.  Use access object AOACCTV1.                     226083
     C***********        If        IBAN = 'N'                                                 226083
      *****Check*that either position 1 - 18 contains a valid customer                        226083
      *****number or positions 1 -10 contain a valid shortname                                226083
      *****Shortname = Positions 1-10                                                         226083
      *****Customer Number                                                                    226083
     C***********        CallB     'AOACCTV1'                                                 226083
     C***********        Parm      *blanks       @RTCD                                        226083
     C***********        Parm      *Blanks       @TYPE                                        226083
     C***********        Parm      PHOCUS1       AccStr                                       226083
     C***********        Parm                    P@FMT                                        226083
      ***********                                                                             226083
     C***********        Select                                                               226083
     C***********        When      @Type = '*LEDGER'                                          226083
     C***********        Eval      PCUSTTP = 'G'                                              226083
     C***********        When      @Type = '*RETAIL'                                          226083
     C***********        Eval      PCUSTTP = 'R'                                              226083
     C***********        When      @Type = '*NOSTRO'                                          226083
     C***********        Eval      PCUSTTP = 'F'                                              226083
     C***********        When      @Type = '*CUSTNO'                                          226083
     C***********        Eval      PCUSTTP = 'C'                                              226083
     C***********        When      @Type = '*SHNAME'                                          226083
     C***********        Eval      PCUSTTP = 'S'                                              226083
     C***********        Endsl                                                                226083
      ***********                                                                             226083
      **If*not*a*shortname, customer number, test that ALL 5 lines                            226083
      **are*not*filled.                                                                       226083
      ***********                                                                             226083
     C***********        If        IBAN = 'N'    And                                          226083
     C***********                  @TYPE <>       '*SHNAME'  And                              226083
     C***********                  @TYPE <>       '*CUSTNO'                                   226083
      ***********                                                                             226083
     C***********        If        PHOCUS2 = *Blanks AND                                      226083
     C***********                  PHOCUS3 = *Blanks AND                                      226083
     C***********                  PHOCUS4 = *Blanks AND                                      226083
     C***********                  PHOCUS5 = *Blanks                                          226083
      ***********                                                                             226083
     C***********        Eval      Idx            =   Idx+1                                   226083
     C***********        Eval      RetCodeIn      =   'Error'                                 226083
     C***********        Eval      MsgIdXAr(Idx)  =  'RFV0081'                                226083
     C***********        Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C***********        Eval      GenOkFlag = 'N'                                            226083
      ***********                                                                             226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        Endif                                                                226083
     C*                                                                                       226083
     C** Line 1: Check for IBAN entry and correctness of format                               226083
     C*                                                                                       226083
     C                   If        CFT004 = 'Y'                                               226083
     C*                                                                                       226083
     C                   EVAL      PIBAN    = *blanks                                         226083
     C                   EVAL      PIBAN    = %Subst(PHOCUS1:2)                               226083
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
     C                   Eval      WIdx             =   WIdx+1                                226083
     C                   Eval      RetCodeIn        =   'Error'                               226083
     C                   Eval      WFldNmXAr(WIdx) =  DDSName                                 226083
     C                   Eval      GenOkFlag = 'W'                                            226083
                                                                                              226083
     C                   SELECT                                                               226083
                                                                                              226083
      *  Invalid ISO country code                                                             226083
     C                   WHEN      @RTCD  = '      1'                                         226083
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM2400'                                226083
      *  Invalid BBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      2'                                         226083
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM2401'                                226083
      *  Invalid character                                                                    226083
     C                   WHEN      @RTCD  = '      3'                                         226083
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM2402'                                226083
      *  Invalid IBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      4'                                         226083
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM2403'                                226083
      *  Invalid check digit                                                                  226083
     C                   WHEN      @RTCD  = '      5'                                         226083
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM2404'                                226083
      *  Other/non-specific warning                                                           226083
     C                   OTHER                                                                226083
     C                   EVAL      WMsgIdXAr(WIdx) = 'FTM2405'                                226083
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
     C                   If        PHOCUS2 = *Blanks AND                                      226083
     C                             PHOCUS3 = *Blanks AND                                      226083
     C                             PHOCUS4 = *Blanks AND                                      226083
     C                             PHOCUS5 = *Blanks                                          226083
     C**********                   AND CSW207 <> 'Y'                                CSW207A BUG15077
     C**********                   AND %Subst(PHOCUS1:1:1) = '/'                   BUG15077 BUG15211
     C**********                   AND CSW207 <> 'Y'                               BUG15211 BUG15239
     C                             AND Valid50F = 'N'                                       BUG15239
                                                                                              226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0081'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      GenOkFlag = 'N'                                            226083
                                                                                              226083
     C                   Endif                                                                226083
     C*                                                                                     BUG24609
     C                   If        %Subst(PHOCUS1:1:1) = '/' And                            BUG24609
     C                             PHOCUS2 = *Blanks                                        BUG24609
     C                   Eval      Idx            =   Idx+1                                 BUG24609
     C                   Eval      RetCodeIn      =   'Error'                               BUG24609
     C                   Eval      MsgIdXAr(Idx)  =  'FTM2152'                              BUG24609
     C                   Eval      FldNamXAr(Idx) =  DDSName                                BUG24609
     C                   Eval      GenOkFlag = 'N'                                          BUG24609
     C                   Endif                                                              BUG24609
     C*                                                                                       226083
     C** Embedded blanks not allowed                                                          226083
     C*                                                                                       226083
     C                   If        PHOCUS2 = *Blanks AND                                      226083
     C                             PHOCUS3 <>*Blanks OR                                       226083
     C                             PHOCUS2 = *Blanks AND                                      226083
     C                             PHOCUS4 <>*Blanks OR                                       226083
     C                             PHOCUS2 = *Blanks AND                                      226083
     C                             PHOCUS5 <>*Blanks OR                                       226083
     C                             PHOCUS3 = *Blanks AND                                      226083
     C                             PHOCUS4 <>*Blanks OR                                       226083
     C                             PHOCUS3 = *Blanks AND                                      226083
     C                             PHOCUS5 <>*Blanks OR                                       226083
     C                             PHOCUS4 = *Blanks AND                                      226083
     C                             PHOCUS5 <>*Blanks                                          226083
                                                                                              226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0925'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      GenOkFlag = 'N'                                            226083
                                                                                              226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C** No errors so far, check there are no invalid characters used.                        226083
     C                   If        GenOkFlag <>'N'                                            226083
                                                                                              226083
     C                   If        PHOCUS1 <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PHOCUS1       Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      OkHoc1 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        PHOCUS2 <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PHOCUS2       Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C**********         Eval      FldNamXAr(Idx) =  DDSName                         226083 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS2'                              BUG26267
     C                   Eval      OkHoc2 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        PHOCUS3 <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PHOCUS3       Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C**********         Eval      FldNamXAr(Idx) =  DDSName                         226083 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS3'                              BUG26267
     C                   Eval      OkHoc3 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        PHOCUS4 <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PHOCUS4       Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C**********         Eval      FldNamXAr(Idx) =  DDSName                         226083 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS4'                              BUG26267
     C                   Eval      OkHoc4 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        PHOCUS5 <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PHOCUS5       Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C**********         Eval      FldNamXAr(Idx) =  DDSName                         226083 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS5'                              BUG26267
     C                   Eval      OkHoc5 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                  End CharTest  226083
     C*                                                                                       226083
     C**  Now, Ordering Customer for RO is completely valid.                                  226083
     C**  Assign Entry type.                                                                  226083
     C*                                                                                       226083
     C                   If        GenOKFlag <> 'N'                                           226083
     C                             And PCUSTTP = *Blanks                                   BUG15010A
     C*                                                                                       226083
     C*       Assume an Address type                                                          226083
     C*                                                                                       226083
     C                   Eval      PCUSTTP = 'A'                                              226083
     C*                                                                                       226083
     C*       Unless, it is a customer number or shortname (type = 'C')                       226083
     C*                                                                                       226083
     C                   If        PHOCUS3 =  *blank   AND                                    226083
     C                             PHOCUS4 =  *blank   AND                                    226083
     C                             PHOCUS5 =  *blank   AND                                    226083
     C                             %Subst(PHOCUS2:1:6) <> *blank  AND                         226083
     C                             %Subst(PHOCUS2:7:29) = *blank  OR                          226083
     C*                                                                                       226083
     C                             PHOCUS3 =  *blank   AND                                    226083
     C                             PHOCUS4 =  *blank   AND                                    226083
     C                             PHOCUS5 =  *blank   AND                                    226083
     C                             %Subst(PHOCUS2:1:10) <> *blank  AND                        226083
     C                             %Subst(PHOCUS2:11:25) = *blank                             226083
                                                                                              226083
     C                   Eval      KeyVal = %subst(PHOCUS2:1:10)                              226083
                                                                                              226083
     C                   Call      'AOCUSTR0'                                                 226083
     C                   Parm      *Blanks       @Rtcd                                        226083
     C                   Parm      '*KEY   '     @Optn                                        226083
     C                   Parm                    KeyVal           10                          226083
     C                   Parm      *Blanks       @Type                                        226083
     C     SDCUST        Parm      SDCUST        P@FMT                                        226083
                                                                                              226083
     C                   If        @RTCD =  *BLANKS   AND                                     226083
     C                             @Type =  '*CSHT  ' OR                                      226083
     C                             @RTCD =  *blanks   AND                                     226083
     C                             @Type =  '*CNUM  '                                         226083
     C                   Eval      PCUSTTP = 'C'                                              226083
     C                   If        @Type =  '*CSHT  '                                         226083
     C                   Movel(P)  BBCUST        PHOCUS2                                      226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
     C*                                                                                       226083
      * <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <-> <->
 
      * If the transfer type is 'RI' a valid account must be entered into
      *  this field.  Either GL, IBAN, Retail or Nostro
 
      *                                                                                       226083
      **  For RIs,                                                                            226083
      **  (1) Entry is only allowed on line 1....2-5 should be blank                          226083
      **  (2) Entry must be a valid account in Retail, GL, Nostro or IBAN format              226083
      **      (insert correct IBAN validation)                                                226083
      **  (3) Should not accept a Customer, Shortname or SWIFT ID type of entry.              226083
      *                                                                                       226083
     C                   When      PPTYP = 'RI'
 
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      *Blanks       @TYPE
     C                   Parm      PHOCUS1       AccStr
     C                   Parm                    P@FMT
      *                                                                                       226083
      *  AOACCTV1 does not check for IBAN, so do it here.                                     226083
     C*                                                                                       226083
     C                   If        CFT004 = 'Y'                                               226083
                                                                                              226083
     C                   If        @Type <> '*LEDGER' And                                     226083
     C                             @Type <> '*RETAIL' And                                     226083
     C                             @Type <> '*NOSTRO'                                         226083
                                                                                              226083
     C**********         If        %subst(PHOCUS1:1) = '/'                           226083 BUG24472
     C                   If        %subst(PHOCUS1:1:1) = '/'                                BUG24472
     C                   Eval      PIBAN  =  %subst(PHOCUS1:2:34)                             226083
     C                   ELSE                                                                 226083
     C                   Eval      PIBAN   =  *blank                                          226083
     C                   Eval      PIBAN   =  PHOCUS1                                         226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   CALL      'AOIBANR3'                                                 226083
     C                   PARM                    PRTCD             7                          226083
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
     C                   CALL      'AOIBANR2'                                                 226083
     C                   PARM                    PRTCD                                        226083
     C                   PARM                    P@IBAN           34                          226083
     C                   PARM                    P@FMT                                        226083
      *                                                                                       226083
     C                   If        PRTCD  <> *blank                                           226083
     C                             And Idx = 0                                              BUG25130
     C**********         Eval      Idx            =   Idx+1                          226083 BUG25130
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C**********         Eval      FldNamXAr(Idx) =  DDSName                         226083 BUG25130
     C**********         Eval      GenOkFlag = 'N'                                   226083 BUG25130
     C                   Eval      WIdx = WIdx + 1                                          BUG25130
     C                   Eval      WFldNmXAr(WIdx) =  DDSName                               BUG25130
     C                   Eval      GenOkFlag = 'W'                                          BUG25130
     C**********         Eval      WMsgDtXAr(WIdx) = PHOCUS1                       BUG26222 MD000091
     C                   EVAL      BLen = %Len(%Trim(PHOCUS1))                              MD000091
     C                   EVAL      WMsgDtXAr(WIdx) = LenStr +%TRIM(PHOCUS1)                 MD000091
      *                                                                                       226083
      ** Invalid country                                                                      226083
     C                   Select                                                               226083
     C                   When      PRTCD = '      1'                                          226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0125'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(Widx) = 'FTM2400'                              BUG25130
      ** Invalid BBAN length on country file                                                  226083
     C                   When      PRTCD = '      2'                                          226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0126'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM2401'                              BUG25130
      ** IBAN contains invalid characters                                                     226083
     C                   When      PRTCD = '      3'                                          226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0127'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM2402'                              BUG25130
      ** IBAN length of BBAN is incorrect                                                     226083
     C                   When      PRTCD = '      4'                                          226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0128'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM2403'                              BUG25130
      ** Checks Digits are not corrects                                                       226083
     C                   When      PRTCD = '      5'                                          226083
     C**********         Eval      MsgIdXAr(Idx)  =  'FTA0129'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM2404'                              BUG25130
      ** Valid IBAN but not on the system, entry is not a valid account.                      226083
     C                   When      PRTCD = '      6'                                          226083
     C**********         Eval      MsgIdXAr(Idx)  =  'RFV0931'                       226083 BUG25130
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM2405'                              BUG25130
     C                   Eval      @TYPE  = '*NRF   '                                         226083
                                                                                              226083
     C                   IF        %Subst(PHOCUS1:1:1) = '/'                                MD034505
     C                   IF        PHOCUS2 <> *BLANKS                                       MD034505
     C                   EVAL      @Type = '*ACCT'                                          MD034505
     C                   ELSE                                                               MD034505
     C                   RETURN                                                             MD034505
     C                   ENDIF                                                              MD034505
     C                   ENDIF                                                              MD034505
                                                                                              226083
     C                   Endsl                                                                226083
                                                                                              226083
     C                   Else                                                                 226083
                                                                                              226083
     C                   Eval      @RTCD  = *blank                                            226083
     C                   Eval      @TYPE  = '*IBAN  '                                         226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   ENDIF                                                                226083
     C                   ENDIF                                                                226083
     C                   ENDIF                                                  End CFT004    226083
 
     C                   IF        %Subst(PHOCUS1:1:1) = '/'                                BUG25015
     C                             AND PHOCUS2 <> *BLANKS                                   BUG25015
     C                   EVAL      @Type = '*ACCT'                                          BUG25015
     C                   ENDIF                                                              BUG25015
     C                                                                                      BUG25015
      * Valid account.  Remove leading / if there is one
     C***********        If        @Type <> '*NRF'                                            226083
     C                   If        @Type =  '*LEDGER' OR                                      226083
     C                             @Type =  '*RETAIL' OR                                      226083
     C                             @Type =  '*NOSTRO' OR                                      226083
     C                             @Type =  '*IBAN  '                                         226083
     C                   If        %Subst(PHOCUS1:1:1) = '/'
     C                   Eval      PHOCUS1 = %Subst(PHOCUS1:2)
     C                   Endif
     C                   Endif
 
     C     @Type         Ifeq      '*LEDGER'                                                  221776
     C     @Type         Oreq      '*RETAIL'                                                  221776
     C     @Type         Oreq      '*NOSTRO'                                                  221776
     C     @Type         Oreq      '*IBAN  '                                                  226083
      *                                                                                       221776
     C                   BITOFF    '01234567'    WRETB             1                          221776
      *                                                                                       221776
     C     @Type         Ifeq      '*LEDGER'                                                  221776
     C     @Type         Oreq      '*RETAIL'                                                  221776
     C     @Type         Oreq      '*IBAN  '                                                  226083
     C                   Eval      P@ACCT = P@FMT                                             221776
     C                   Endif                                                                221776
      *                                                                                       221776
     C                   If        @Type = '*NOSTRO'                                          221776
     C                   Eval      P@ACID = PHOCUS1                                           221776
     C                   Eval      P@CYCD = *blanks                                           221776
     C                   Eval      P@ACCD = *blanks                                           221776
     C                   Eval      P@ACSN = *blanks                                           221776
     C                   Eval      P@BRCA = *blanks                                           221776
     C                   Eval      P@NOSN = *blanks                                           221776
      *                                                                                       221776
     C                   Call      'AOACCTV0'                                                 221776
     C                   Parm      *blanks       @RTCD                                        221776
     C                   Parm                    P@ACID           10                          221776
     C                   Parm                    P@CYCD            3                          221776
     C**********         Parm                    P@ACCD            4                   221776 TDA020
     C                   Parm                    P@ACCD           10                          TDA020
     C                   Parm                    P@ACSN            2                          221776
     C                   Parm                    P@BRCA            3                          221776
     C                   Parm      *blanks       P@TYPE            7                          221776
     C                   Parm                    P@NOSN            2                          221776
     C     P@ACCT        Parm      P@ACCT        P@FMT                                        221776
     C                   Endif                                                                221776
      *                                                                                       221776
     C                   eval      WRETB = A_RETB                                             221776
      *                                                                                       221776
      ** Bankrupt/Liquidated                                                                  221776
      *                                                                                       221776
     C                   TESTB     '6'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0015'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      GenOkFlag = 'N'                                            221776
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
     C                   Eval      GenOkFlag = 'N'                                            221776
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
     C                   Eval      GenOkFlag = 'N'                                            221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Inactive                                                                             221776
      *                                                                                       221776
     C**********         TESTB     '4'           WRETB                    48           221776 259576
     C**********         If        *IN48 = '1'                                         221776 259576
     C**********         Eval      WIdx             =   WIdx+1                         221776 259576
     C**********         Eval      RetCodeIn        =   'Error'                        221776 259576
     C**********         Eval      WMsgIdXAr(WIdx)  =   'FTM0017'                      221776 259576
     C**********         Eval      WFldNmXAr(WIdx)  =   DDSName                        221776 259576
     C**********         If        GenOkFlag <> 'N'                                    221774 259576
     C**********         Eval      GenOkFlag = 'W'                                     221776 259576
     C**********         Endif                                                         221774 259576
     C**********         Endif                                                         221776 259576
      *                                                                                       221776
      ** Referred Debit                                                                       221776
      *                                                                                       221776
     C                   TESTB     '0'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      WIdx             =   WIdx+1                                221776
     C                   Eval      RetCodeIn        =   'Error'                               221776
     C                   Eval      WMsgIdXAr(WIdx)  =   'FTM0018'                             221776
     C                   Eval      WFldNmXAr(WIdx)  =   DDSName                               221776
     C                   If        GenOkFlag <> 'N'                                           221774
     C                   Eval      GenOkFlag = 'W'                                            221776
     C                   Endif                                                                221774
     C                   Endif                                                                221776
      *                                                                                       221776
     C                   Endif                                                                221776
      *                                                                                       221776
     C                   Select
     C***********        When      @Type = '*NRF'                                             226083
     C                   When      @Type <> '*LEDGER' And                                     226083
     C                             @Type <> '*RETAIL' And                                     226083
     C                             @Type <> '*IBAN  ' And                                     226083
     C                             @Type <> '*CUSTNO' AND                                   MD034505
     C                             @Type <> '*ACCT'   AND                                   MD034505
     C                             @Type <> '*NOSTRO'                                         226083
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C**********         Eval      MsgIdXAr(Idx)   =  'RFV0076'                              BUG8578
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0133'                              BUG8578
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   When      @Type = '*LEDGER'
     C                   Eval      PCUSTTP = 'G'
     C                   When      @Type = '*RETAIL'
     C                   Eval      PCUSTTP = 'R'
     C                   When      @Type = '*NOSTRO'
     C                   Eval      PCUSTTP = 'F'
     C                   When      @Type = '*IBAN  '                                          226083
     C                   Eval      PCUSTTP = 'I'                                              226083
     C                   When      @Type = '*CUSTNO'                                        MD034505
     C                   Eval      PCUSTTP = 'C'                                            MD034505
     C                   WHEN      @Type = '*ACCT'                                          MD034505
     C                   EVAL      PCUSTTP = 'A'                                            MD034505
     C*                                                                                       226083
     C                   Endsl                                                                226083
     C***********                                                                             226083
     C***********        When      @Type = '*CUSTNO'                                          226083
     C***********        Eval      PCUSTTP = 'C'                                              226083
     C***********        When      @Type = '*SHNAME'                                          226083
     C***********        Eval      PCUSTTP = 'S'                                              226083
     C***********        Other                                                                226083
     C***********                                                                             226083
      ***Iban.**Access objects AOIBANR2 and R3                                                226083
     C***********        CallB     'FTVIBNB01'                                                226083
     C***********        Parm      *Blanks       RetCodeIn        10                          226083
     C***********        Parm                    PPTYP                                        226083
     C***********        Parm                    PHOCUS1                                      226083
      ***********                                                                             226083
     C***********        If        RetCodeIn = '*NOTINST  ' Or                                226083
     C***********                  RetCodeIn = '*VALIDIN  '                                   226083
      ***********                                                                             226083
     C***********        If        RetCodeIn = '*VALIDIN  '                                   226083
     C***********        Eval      PCUSTTP = 'I'                                              226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        Endsl                                                                226083
      ***********                                                                             226083
     C***********        Endsl                                                                226083
      ***********                                                                             226083
      **Now*validate that all data entered is OK for SWIFT                                    226083
     C***********        If        PHOCUS1 <> *Blanks                                         226083
     C***********        CallB     'FTVSFTX01'                                                226083
     C***********        Parm                    RetCdeIn         10                          226083
     C***********        Parm      PHOCUS1       Swift_Text       50                          226083
     C***********        If        RetCdeIn = 'Error'                                         226083
     C***********        Eval      Idx            =   Idx+1                                   226083
     C***********        Eval      RetCodeIn      =   'Error'                                 226083
     C***********        Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C***********        Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C***********        Eval      OkHoc1 = 'N'                                               226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        If        PHOCUS2 <> *Blanks                                         226083
     C***********        CallB     'FTVSFTX01'                                                226083
     C***********        Parm                    RetCdeIn         10                          226083
     C***********        Parm      PHOCUS2       Swift_Text       50                          226083
     C***********        If        RetCdeIn = 'Error'                                         226083
     C***********        Eval      Idx            =   Idx+1                                   226083
     C***********        Eval      RetCodeIn      =   'Error'                                 226083
     C***********        Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C***********        Eval      FldNamXAr(Idx) =  'PHOCUS2'                  CAP084        226083
     C***********        Eval      OkHoc2 = 'N'                                               226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        If        PHOCUS3 <> *Blanks                                         226083
     C***********        CallB     'FTVSFTX01'                                                226083
     C***********        Parm                    RetCdeIn         10                          226083
     C***********        Parm      PHOCUS3       Swift_Text       50                          226083
     C***********        If        RetCdeIn = 'Error'                                         226083
     C***********        Eval      Idx            =   Idx+1                                   226083
     C***********        Eval      RetCodeIn      =   'Error'                                 226083
     C***********        Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C***********        Eval      FldNamXAr(Idx) =  'PHOCUS3'                  CAP084        226083
     C***********        Eval      OkHoc3 = 'N'                                               226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        If        PHOCUS4 <> *Blanks                                         226083
     C***********        CallB     'FTVSFTX01'                                                226083
     C***********        Parm                    RetCdeIn         10                          226083
     C***********        Parm      PHOCUS4       Swift_Text       50                          226083
     C***********        If        RetCdeIn = 'Error'                                         226083
     C***********        Eval      Idx            =   Idx+1                                   226083
     C***********        Eval      RetCodeIn      =   'Error'                                 226083
     C***********        Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C***********        Eval      FldNamXAr(Idx) =  'PHOCUS4'                  CAP084        226083
     C***********        Eval      OkHoc4 = 'N'                                               226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
     C***********        If        PHOCUS5 <> *Blanks                                         226083
     C***********        CallB     'FTVSFTX01'                                                226083
     C***********        Parm                    RetCdeIn         10                          226083
     C***********        Parm      PHOCUS5       Swift_Text       50                          226083
     C***********        If        RetCdeIn = 'Error'                                         226083
     C***********        Eval      Idx            =   Idx+1                                   226083
     C***********        Eval      RetCodeIn      =   'Error'                                 226083
     C***********        Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C***********        Eval      FldNamXAr(Idx) =  'PHOCUS5'                  CAP084        226083
     C***********        Eval      OkHoc5 = 'N'                                               226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      *                                                                                       221774
     C     PPTYP         Ifeq      'RI'                                                       221774
     C     GenOkFlag     Andne     'N'                                                        221774
     C     PPTYP         Oreq      'RI'                                                       221774
     C     PHOCUS1       Andeq     *blanks                                                    221774
      *                                                                                       221774
     C                   If        PHOCUS2 <> *blanks                                         221774
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx            =   Idx+1                                   221774
     C                   Eval      RetCodeIn      =   'Error'                                 221774
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0921'                                221774
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  221774
     C                   Eval      OkHoc2 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   If        PHOCUS3 <> *blanks                                         221774
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx            =   Idx+1                                   221774
     C                   Eval      RetCodeIn      =   'Error'                                 221774
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0921'                                221774
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  221774
     C                   Eval      OkHoc3 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   If        PHOCUS4 <> *blanks                                         221774
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx            =   Idx+1                                   221774
     C                   Eval      RetCodeIn      =   'Error'                                 221774
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0921'                                221774
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  221774
     C                   Eval      OkHoc4 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   If        PHOCUS5 <> *blanks                                         221774
     C                             And CSW207 <> 'Y'                                         CSW207A
     C                   Eval      Idx            =   Idx+1                                   221774
     C                   Eval      RetCodeIn      =   'Error'                                 221774
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0921'                                221774
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  221774
     C                   Eval      OkHoc5 = 'N'                                               221774
     C                   Endif                                                                221774
      *                                                                                       221774
     C                   Endif                                                                221774
      *                                                                                       226083
     C                   ENDSL                                                                226083
 
     C*                                                                                     BUG24434
     C** No errors so far, check there are no invalid characters used.                      BUG24434
     C                   If        GenOkFlag <>'N'                                          BUG24434
     C                             AND PPTYP = 'RO'                                         BUG25130
                                                                                            BUG24434
     C                   If        PHOCUS1 <> *Blanks                                       BUG24434
     C                             AND OkHoc1 = 'Y'                                         BUG26267
     C                   CallB     'FTVSFTX01'                                              BUG24434
     C                   Parm                    RetCdeIn         10                        BUG24434
     C                   Parm      PHOCUS1       Swift_Text       50                        BUG24434
     C                   If        RetCdeIn = 'Error'                                       BUG24434
     C                   Eval      Idx            =   Idx+1                                 BUG24434
     C                   Eval      RetCodeIn      =   'Error'                               BUG24434
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                              BUG24434
     C                   Eval      FldNamXAr(Idx) =  DDSName                                BUG24434
     C                   Eval      OkHoc1 = 'N'                                             BUG24434
     C                   Eval      GenOkFlag = 'N'                                          BUG24434
     C                   Endif                                                              BUG24434
     C                   Endif                                                              BUG24434
                                                                                            BUG24434
     C                   If        PHOCUS2 <> *Blanks                                       BUG24434
     C                             AND OkHoc2 = 'Y'                                         BUG26267
     C                   CallB     'FTVSFTX01'                                              BUG24434
     C                   Parm                    RetCdeIn         10                        BUG24434
     C                   Parm      PHOCUS2       Swift_Text       50                        BUG24434
     C                   If        RetCdeIn = 'Error'                                       BUG24434
     C                   Eval      Idx            =   Idx+1                                 BUG24434
     C                   Eval      RetCodeIn      =   'Error'                               BUG24434
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                              BUG24434
     C**********         Eval      FldNamXAr(Idx) =  DDSName                       BUG24434 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS2'                              BUG26267
     C                   Eval      OkHoc2 = 'N'                                             BUG24434
     C                   Endif                                                              BUG24434
     C                   Endif                                                              BUG24434
                                                                                            BUG24434
     C                   If        PHOCUS3 <> *Blanks                                       BUG24434
     C                             AND OkHoc3 = 'Y'                                         BUG26267
     C                   CallB     'FTVSFTX01'                                              BUG24434
     C                   Parm                    RetCdeIn         10                        BUG24434
     C                   Parm      PHOCUS3       Swift_Text       50                        BUG24434
     C                   If        RetCdeIn = 'Error'                                       BUG24434
     C                   Eval      Idx            =   Idx+1                                 BUG24434
     C                   Eval      RetCodeIn      =   'Error'                               BUG24434
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                              BUG24434
     C**********         Eval      FldNamXAr(Idx) =  DDSName                       BUG24434 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS3'                              BUG26267
     C                   Eval      OkHoc3 = 'N'                                             BUG24434
     C                   Endif                                                              BUG24434
     C                   Endif                                                              BUG24434
                                                                                            BUG24434
     C                   If        PHOCUS4 <> *Blanks                                       BUG24434
     C                             AND OkHoc4 = 'Y'                                         BUG26267
     C                   CallB     'FTVSFTX01'                                              BUG24434
     C                   Parm                    RetCdeIn         10                        BUG24434
     C                   Parm      PHOCUS4       Swift_Text       50                        BUG24434
     C                   If        RetCdeIn = 'Error'                                       BUG24434
     C                   Eval      Idx            =   Idx+1                                 BUG24434
     C                   Eval      RetCodeIn      =   'Error'                               BUG24434
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                              BUG24434
     C**********         Eval      FldNamXAr(Idx) =  DDSName                       BUG24434 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS4'                              BUG26267
     C                   Eval      OkHoc4 = 'N'                                             BUG24434
     C                   Endif                                                              BUG24434
     C                   Endif                                                              BUG24434
                                                                                            BUG24434
     C                   If        PHOCUS5 <> *Blanks                                       BUG24434
     C                             AND OkHoc5 = 'Y'                                         BUG26267
     C                   CallB     'FTVSFTX01'                                              BUG24434
     C                   Parm                    RetCdeIn         10                        BUG24434
     C                   Parm      PHOCUS5       Swift_Text       50                        BUG24434
     C                   If        RetCdeIn = 'Error'                                       BUG24434
     C                   Eval      Idx            =   Idx+1                                 BUG24434
     C                   Eval      RetCodeIn      =   'Error'                               BUG24434
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                              BUG24434
     C**********         Eval      FldNamXAr(Idx) =  DDSName                       BUG24434 BUG26267
     C                   Eval      FldNamXAr(Idx) =  'PHOCUS5'                              BUG26267
     C                   Eval      OkHoc5 = 'N'                                             BUG24434
     C                   Endif                                                              BUG24434
     C                   Endif                                                              BUG24434
     C                                                                                      BUG24434
     C                   Endif                                                              BUG24434
 
     C                   IF        GenOKFlag <> 'N'                                         BUG24829
     C                                 And PCUSTTP = *Blanks                                BUG24829
     C                   EVAL      PCUSTTP = 'A'                                            BUG24829
     C                   ENDIF                                                              BUG24829
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetCountry - Get Country of Location Parameter for FT001000  *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetCountry    BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   Movel     *Blanks       PCCD                                      BUG15010A
     C**********         Movel     *Blanks       PCNUM                            BUG15010A MD027284
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
     C                   Movel     C_BBCOLC      PCCD                                      BUG15010A
     C                   ENDIF                                                             BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*CUSTNO'                                       BUG15010A
     C                             Or @Type = '*SHNAME'                                    BUG15010A
     C                   Eval      C_SDCUST = A_DSSDY                                      BUG15010A
     C                   Movel     C_BBCOLC      PCCD                                      BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*SWIFT'                                        BUG15010A
     C                   Eval      PCCD = %Subst(ParmStr:5:2)                              BUG15010A
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
     C                   EVAL      PACNT = *Blanks                                         BUG15010A
     C                   If        %Subst(PHOCUS1:1:1) = '/'                               BUG15010A
      *                                                                                     BUG21272
     C                   IF        PHOCUS2 = *BLANKS                                        BUG21272
     C                   EVAL      ParmStr = %SUBST(PHOCUS1:2:34)                          BUG15010A
     C                   ELSE                                                               BUG21272
     C                   EVAL      ParmStr = PHOCUS2                                        BUG21272
     C                   ENDIF                                                              BUG21272
      *                                                                                     BUG21272
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = PHOCUS1                                       BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type                                     BUG15010A
     C                   Parm                    ParmStr                                   BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *Blanks                                         BUG15010A
                                                                                           BUG15010A
     C                   Select                                                            BUG15010A
     C                   When      @Type = '*RETAIL'                                       BUG15010A
     C                             Or @Type = '*LEDGER'                                    BUG15010A
     C                   Eval      S_ACCNT = A_DSSDY                                       BUG15010A
     C                   Move      S_CNUM        WCNUM                                     BUG15010A
     C                   Move      S_ACOD        WACOD            10                       BUG15010A
     C                   Move      S_ACSQ        WACSQ             2                       BUG15010A
     C                   Eval      PACNT = S_BRCA+ WCNUM + S_CCY                           BUG15010A
     C                                  + WACOD + WACSQ                                    BUG15010A
     C                   If        @Type = '*RETAIL'                                       BUG15010A
     C                   Eval      PCUSTTP = 'R'                                           BUG15010A
     C                   Else                                                              BUG15010A
     C                   Eval      PCUSTTP = 'P'                                           BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*CUSTNO'                                       BUG15010A
     C                             Or @Type = '*SHNAME'                                    BUG15010A
     C                   Eval      PCUSTTP = 'C'                                           BUG15010A
     C                   IF        @Type = '*SHNAME'                                        MD027284
     C                   MOVEL     PARMSTR       @KEY1                                      MD027284
     C                   CALL      'AOCUSTR0'                                               MD027284
     C                   PARM      *BLANKS       @RTCD                                      MD027284
     C                   PARM      '*KEY   '     @OPTN                                      MD027284
     C                   PARM                    @KEY1                                      MD027284
     C                   PARM      *BLANKS       @KYST                                      MD027284
     C     SDCUST        PARM      *BLANKS       P@FMT                                      MD027284
     C                   MOVEL     BBCUST        PCNUM                                      MD027284
     C                   ENDIF                                                              MD027284
                                                                                           BUG15010A
     C                   When      @Type = '*SWIFT'                                        BUG15010A
     C                   Eval      PCUSTTP = 'S'                                           BUG15010A
                                                                                           BUG15010A
     C                   EndSl                                                             BUG15010A
                                                                                           BUG15010A
     C                   Else                                                              BUG15010A
     C                   Movel     ParmStr       IbanStr                                   BUG15010A
     C                   Call      'AOIBANR4'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      '*KEY'        @OPTN                                     BUG15010A
     C                   Parm                    IbanStr                                   BUG15010A
     C     S_ACCNT       Parm      S_ACCNT       A_DSSDY                                   BUG15010A
     C                   If        @RTCD = *Blanks                                         BUG15010A
     C                   Move      S_CNUM        WCNUM                                     BUG15010A
     C                   Move      S_ACOD        WACOD            10                       BUG15010A
     C                   Move      S_ACSQ        WACSQ             2                       BUG15010A
     C                   Eval      PACNT = S_BRCA+ WCNUM + S_CCY                           BUG15010A
     C                                  + WACOD + WACSQ                                    BUG15010A
     C                   Eval      PCUSTTP = 'I'                                           BUG15010A
     C                   EndIf                                                             BUG15010A
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
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   PARM                    OKFlagHS
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName
 
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT004'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   Select
     C                   When      @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Eval      DbFile =  'SCSARDPD'
     C                   Eval      DBase =  2
     C                   Eval      DBKey = 'CFT004'
     C                   Exsr      *PSSR
 
     C                   When      @RTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
 
     C                   When      @RTCD = '*NRF   '
     C                   Eval      @RTCD = *Blanks
     C                   Eval      CFT004 = 'N'
 
     C                   Endsl
      *                                                                                       CSW207
      ** Check if SWIFT Changes 2007 (CSW207) is installed                                    CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   Parm      *BLANKS       PRTCD             7                          CSW207
      *                                                                                       CSW207
     C     PRTCD         Ifeq      'CSW2007'                                                  CSW207
     C                   Eval      CSW207 = 'Y'                                               CSW207
     C                   Else                                                                 CSW207
     C                   Eval      CSW207 = 'N'                                               CSW207
     C                   Endif                                                                CSW207
      *                                                                                       CSW207
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      * SRValidate - Validate new format ":50F:" for ordering         *                       CSW207
      *              customer in a SWIFT message                      *                       CSW207
      *                                                               *                       CSW207
      * Called by: Main processing                                    *                       CSW207
      *                                                               *                       CSW207
      * Calls: FT001000                                               *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
                                                                                              CSW207
     C     SRValidate    BEGSR                                                                CSW207
     C*                                                                                       CSW207
      ** The validation below is already performed above for non-50F fields (i.e.           BUG15077
      ** 50G/50H fields).                                                                   BUG15077
                                                                                            BUG15077
     C**********         CALLB     'AOACCTV1'                                        CSW207 BUG15077
     C**********         PARM      *Blanks       @RTCD                               CSW207 BUG15077
     C**********         PARM      *Blanks       @Type                               CSW207 BUG15077
     C**********         PARM                    PHOCUS1                             CSW207 BUG15077
     C**********         PARM                    P@FMT                               CSW207 BUG15077
      **********                                                                     CSW207 BUG15077
     C**********         IF        @RTCD = *BLANKS                                   CSW207 BUG15077
     C**********         EVAL      P@ACCT = P@FMT                                    CSW207 BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         IF        @Type <> '*CUSTNO'                               CSW207A BUG15077
     C**********         MOVEL     A_ACNO        PACNT                              CSW207A BUG15077
     C**********         MOVE      A_CNUM        PCNUM                               CSW207 BUG15077
     C**********         ELSE                                                       CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         IF        %Subst(PHOCUS1:1:1) = '/'                        CSW207A BUG15077
     C**********         Eval      PCNUM = %Subst(PHOCUS1:2:6)                      CSW207A BUG15077
     C**********         ELSE                                                       CSW207A BUG15077
     C**********         Eval      PCNUM = %Subst(PHOCUS1:1:6)                      CSW207A BUG15077
     C**********         ENDIF                                                      CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         ENDIF                                                      CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         Select                                                    BUG14593 BUG15077
      **********                                                                   BUG14593 BUG15077
     C**********         When      @Type = '*CUSTNO'                               BUG14593 BUG15077
     C**********         Eval      PATYP = 'C'                                     BUG14593 BUG15077
     C**********         IF        %Subst(PHOCUS1:1:1) = '/'                       BUG14593 BUG15077
     C**********         Eval      PCNUM = %Subst(PHOCUS1:2:6)                     BUG14593 BUG15077
     C**********         Else                                                      BUG14593 BUG15077
     C**********         Eval      PCNUM = %Subst(PHOCUS1:1:6)                     BUG14593 BUG15077
     C**********         EndIf                                                     BUG14593 BUG15077
      **********                                                                   BUG14593 BUG15077
     C**********         When      @Type = '*RETAIL'                               BUG14593 BUG15077
     C**********         Eval      PATYP = 'R'                                     BUG14593 BUG15077
     C**********         Move      A_CNUM        WCNUM                             BUG14593 BUG15077
     C**********         Move      A_ACOD        WACOD                             BUG14593 BUG15077
     C**********         Move      A_ACSQ        WACSQ                             BUG14593 BUG15077
     C**********         Eval      PACNT = A_BRCA + WCNUM + A_CCY                  BUG14593 BUG15077
     C**********                        + WACOD + WACSQ                            BUG14593 BUG15077
     C**********         EndSl                                                     BUG14593 BUG15077
      **********                                                                   BUG14593 BUG15077
     C**********         Eval      PACNT = %Subst(PHOCUS1:2:34)                       CSW207 CSW207A
     C**********         IF        @Type = '*RETAIL'                                  CSW207 CSW207A
     C**********         Eval      PATYP = 'R'                                        CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
     C**********         IF        @Type = '*LEDGER'                                  CSW207 CSW207A
     C**********         Eval      PATYP = 'G'                                        CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
                                                                                              CSW207
     C**********         ELSE                                                        CSW207 BUG15077
     C**********         EVAL      PCNUM = *BLANKS                                   CSW207 BUG15077
     C**********         EVAL      PATYP = *BLANKS                                   CSW207 BUG15077
     C**********         EVAL      PACNT = *BLANKS                                   CSW207 BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         If        %Subst(PHOCUS1:1:1) = '/'                        CSW207A BUG15077
     C**********         Eval      P@IBAN = %Subst(PHOCUS1:2)                       CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
      ***Check*internal*IBAN                                                        CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         Call      'AOIBANR2'                                       CSW207A BUG15077
     C**********         Parm      *Blanks       PRTCD                              CSW207A BUG15077
     C**********         Parm                    P@IBAN                             CSW207A BUG15077
     C*****P@ACCT        Parm      P@ACCT        P@FMT                              CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         If        PRTCD = *Blanks                                  CSW207A BUG15077
     C**********         Eval      PATYP = 'I'                                      CSW207A BUG15077
     C**********         Move      A_CNUM        WCNUM                              CSW207A BUG15077
     C**********         Move      A_ACOD        WACOD                              CSW207A BUG15077
     C**********         Move      A_ACSQ        WACSQ                              CSW207A BUG15077
     C**********         Eval      PACNT = A_BRCA + WCNUM + A_CCY                   CSW207A BUG15077
     C**********                        + WACOD + WACSQ                             CSW207A BUG15077
     C**********         Eval      PCCD = %Subst(P@IBAN:1:2)                        CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         Else                                                       CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
      ***Check*external*IBAN                                                        CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         Call      'AOIBANR5'                                       CSW207A BUG15077
     C**********         Parm      *Blanks       PRTCD                              CSW207A BUG15077
     C**********         Parm                    P@IBAN                             CSW207A BUG15077
     C**********         If        PRTCD = *Blanks                                  CSW207A BUG15077
     C**********         Call      'AOIBANR4'                                       CSW207A BUG15077
     C**********         Parm      *Blanks       PRTCD                              CSW207A BUG15077
     C**********         Parm      '*KEY'        @OPTN                              CSW207A BUG15077
     C**********         Parm                    P@IBAN                             CSW207A BUG15077
     C*****P@ACCT        Parm      P@ACCT        P@FMT                              CSW207A BUG15077
     C**********         If        PRTCD = *Blanks                                  CSW207A BUG15077
     C**********         Eval      PATYP = 'I'                                      CSW207A BUG15077
     C**********         Move      A_CNUM        WCNUM                              CSW207A BUG15077
     C**********         Move      A_ACOD        WACOD                              CSW207A BUG15077
     C**********         Move      A_ACSQ        WACSQ                              CSW207A BUG15077
     C**********         Eval      PACNT = A_BRCA + WCNUM + A_CCY                   CSW207A BUG15077
     C**********                        + WACOD + WACSQ                             CSW207A BUG15077
     C**********         Eval      PCCD = %Subst(P@IBAN:1:2)                        CSW207A BUG15077
     C**********         EndIf                                                      CSW207A BUG15077
     C**********         EndIf                                                      CSW207A BUG15077
     C**********         EndIf                                                      CSW207A BUG15077
     C**********         EndIf                                                      CSW207A BUG15077
      **********                                                                    CSW207A BUG15077
     C**********         ENDIF                                                       CSW207 BUG15077
      **********                                                                     CSW207 BUG15077
      ** if input type is IBAN, Retail or Ledger, set Account parameter of FT001000        BUG15010A
     C                   Exsr      GetAccount                                              BUG15010A
                                                                                           BUG15010A
     C                   IF        PCUSTTP = *BLANKS OR                                     BUG15065
     C                             PHOCUS2 <> *BLANKS                                       BUG15065
     C                   EVAL      PATYP = 'A'                                              BUG15065
     C                   ELSE                                                               BUG15065
     C                   EVAL      PATYP = PCUSTTP                                          BUG15065
     C                   ENDIF                                                              BUG15065
                                                                                            BUG15065
      ** Get Country of Location parameter for FT001000                                    BUG15010A
      ** for Incoming must be the Destination, for Outgoing must be the Sender             BUG15010A
     C                   Exsr      GetCountry                                              BUG15010A
                                                                                           BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000            BUG15010A
     C                   If        PATYP = 'C'                                             BUG15010A
     C                             AND PCNUM = *BLANKS                                      MD027284
     C                   Movel     PHOCUS1       PCNUM                                     BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      *                                                                                     BUG21228
      ** Validate Ordering Customer                                                         BUG21228
      ** If Full address and does not start with a '/'                                      BUG21228
      ** second line should not be blank                                                    BUG21228
      *                                                                                     BUG21228
     C                   If        PATYP = 'A'                                              BUG21228
     C                             And %SUBST(PHOCUS1:1:1) = '/'                            BUG21228
     C                             And PHOCUS2 = *BLANKS                                    BUG21228
     C                             And OkHoc1 <> 'N'                                        BUG21228
      * Send error to screen                                                                BUG21228
     C                   Eval      OkHoc1 = 'N'                                             BUG21228
     C                   Eval      Idx             =   Idx+1                                BUG21228
     C                   Eval      FldNamXAr(Idx)  =  DDSName                               BUG21228
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0081'                             BUG21228
     C                   Eval      RetCodeIn       =   'Error'                              BUG21228
      *                                                                                     BUG21228
     C**********         ElseIf    PATYP = 'A'                                     BUG21228 BUG25897
     C**********                   And %SUBST(PHOCUS1:1:1) <> '/'                  BUG21228 BUG25897
     C**********                   And PHOCUS2 = *BLANKS                           BUG21228 BUG25897
     C**********                   And OkHoc1 <> 'N'                               BUG21228 BUG25897
      **Send*error*to*screen*                                                      BUG21228 BUG25897
     C**********         Eval      OkHoc1 = 'N'                                    BUG21228 BUG25897
     C**********         Eval      Idx             =   Idx+1                       BUG21228 BUG25897
     C**********         Eval      FldNamXAr(Idx)  =  DDSName                      BUG21228 BUG25897
     C**********         Eval      MsgIdXAr(Idx)   =  'RFV0076'                    BUG21228 BUG25897
     C**********         Eval      RetCodeIn       =   'Error'                     BUG21228 BUG25897
     C                   EndIf                                                              BUG21228
 
      ** Check if valid 50F format                                                          BUG15077
     C                   Eval      Valid50F = 'Y'                                           BUG15239
                                                                                            BUG15077
     C                   Call      'FT001000'                                                 CSW207
      ** Return Code                                                                          CSW207
     C                   Parm      *BLANKS       PRTCD             7                          CSW207
      ** Message ID Field                                                                     CSW207
     C                   Parm      *BLANKS       PMSGID            7                          CSW207
      ** Flag                                                                                 CSW207
     C                   Parm      *BLANK        PFLAG             1                          CSW207
      ** Type of Validation                                                                   CSW207
     C                   Parm      'TRAN'        PVALTYP           4                          CSW207
      ** 5X35 lines to be checked                                                             CSW207
     C                   Parm      PHOCUS1       PFIELD1          35                          CSW207
     C                   Parm      PHOCUS2       PFIELD2          35                          CSW207
     C                   Parm      PHOCUS3       PFIELD3          35                          CSW207
     C                   Parm      PHOCUS4       PFIELD4          35                          CSW207
     C                   Parm      PHOCUS5       PFIELD5          35                          CSW207
      ** Input Type                                                                           CSW207
     C                   Parm                    PATYP             1                          CSW207
      ** Account                                                                              CSW207
     C                   Parm                    PACNT            34                          CSW207
      ** Customer Number                                                                      CSW207
     C                   Parm                    PCNUM             6                          CSW207
      ** Non Account Holder                                                                   CSW207
     C**********         Parm                    PNAHT            10                CSW207 BUG15010A
     C                   Parm      *Blanks       PNAHT            10                       BUG15010A
      ** Network                                                                              CSW207
     C                   Parm      'SWIFT'       PNWRK             6                          CSW207
      ** Message Type                                                                         CSW207
     C**********         Parm      '103'         PMSGTP            3                  CSW207 CSW207A
     C                   Parm      '101'         PMSGTP            3                          CSW207
      ** Message Tag                                                                          CSW207
     C                   Parm      ':50F:'       PMSGTG            5                          CSW207
      ** Country of Location                                                                  CSW207
     C                   Parm                    PCCD              2                          CSW207
      ** Branch Code                                                                          CSW207
     C*********          Parm                    PBRCH             3                 CSW207 BUG15010
     C                   Parm      PBRCA         PBRCH             3                        BUG15010
      ** Currency Code                                                                        CSW207
     C                   Parm      A_CCY         PCCY              3                          CSW207
      ** Nostro                                                                               CSW207
     C**********         Parm                    PNOST             2                CSW207 BUG15010A
     C                   Parm      *Blanks       PNOST             2                       BUG15010A
      ** Module Indicator                                                                     CSW207
     C**********         Parm                    PMODI             2                 CSW207 BUG15010
     C**********         Parm      'FT'          PMODI             2               BUG15010 BUG25973
     C                   Parm      PPTYP         PMODI             2                        BUG25973
      ** 5X35 lines to be output                                                              CSW207
     C                   Parm                    POUT1            35                          CSW207
     C                   Parm                    POUT2            35                          CSW207
     C                   Parm                    POUT3            35                          CSW207
     C                   Parm                    POUT4            35                          CSW207
     C                   Parm                    POUT5            35                          CSW207
      *                                                                                       CSW207
     C     PRTCD         Ifeq      '*ERROR'                                                   CSW207
      *                                                                                       CSW207
     C                   IF        PFLAG = 'E'                                              BUG26080
     C                   Eval      Valid50F = 'N'                                           BUG15239
     C                   ENDIF                                                              BUG26080
     C                                                                                      BUG15239
     C                   If        PPTYP = 'RI' and PMSGID = 'FTS0055'                      BUG15010
     C                   Eval      PFLAG = 'W'                                              BUG15010
     C                   EndIf                                                              BUG15010
      *                                                                                     BUG15010
     C     PFLAG         Ifeq      'E'                                                        CSW207
     C                   Eval      Idx = Idx + 1                                              CSW207
     C                   Eval      MsgIdXAr(Idx) = PMSGID                                     CSW207
     C                   Eval      GenOkFlag = 'N'                                            CSW207
     C                   Eval      RetCodeIn = 'ERROR'                                        CSW207
     C                   Eval      FldNamXAr(Idx) = 'PHOCUS1'                                 CSW207
     C                   Endif                                                                CSW207
                                                                                              CSW207
     C     PFLAG         Ifeq      'W'                                                        CSW207
     C                   Eval      WIdx = WIdx + 1                                            CSW207
     C                   Eval      WMsgIdXAr(WIdx) = PMSGID                                   CSW207
     C                   Eval      GenOkFlag = 'W'                                            CSW207
     C                   Eval      RetCodeIn = 'ERROR'                                        CSW207
     C                   Eval      WFldNmXAr(WIdx) = 'PHOCUS1'                                CSW207
                                                                                            BUG15029
     C                   If        PMsgID = 'FTS0053'                                       BUG15029
     C**********         Eval      WMsgDtXAr(WIdx) = PNWRK                         BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PNWRK))                                MD000091
     C                   EVAL      WMsgDtXAr(WIdx) = LenStr +%TRIM(PNWRK)                   MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                       BUG15029
     C**********         Eval      WMsgDtXAr(WIdx) = PMSGTG                        BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PMSGTG))                               MD000091
     C                   EVAL      WMsgDtXAr(WIdx) = LenStr +%TRIM(PMSGTG)                  MD000091
     C                   Endif                                                              BUG15029
     C                   Endif                                                                CSW207
                                                                                              CSW207
     C                   Endif                                                                CSW207
      *                                                                                     BUG15188
     C**********         If        PRtCd = *Blanks And                             BUG15188 BUG25128
     C                   If        PRtCd <> '*ERROR' And                                    BUG25128
     C                             %SUBST(PHOCUS1:1:1) <> '/' And                           BUG15188
     C                             PHOCUS5    <> *Blank                                     BUG15188
     C                   If        %SUBST(PHOCUS5:1:2) <> '1/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '2/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '3/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '4/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '5/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '6/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '7/' And                          BUG15188
     C                             %SUBST(PHOCUS5:1:2) <> '8/'                              BUG15188
      * as CFT032 is not Switchable 50K can be input with 5 lines                           BUG15188
     C                   Move      'N'           OKHOC5                                     BUG15188
     C                   Eval      Idx = Idx + 1                                            BUG15188
     C                   Eval      FldNamXAr(Idx) = 'PHOCUS5'                               BUG15188
     C                   Eval      MsgIdXAr(Idx) = 'FTM7112'                                BUG15188
     C                   EndIf                                                              BUG15188
     C                   EndIf                                                              BUG15188
      *                                                                                     BUG15188
     C                   ENDSR                                                                CSW207
                                                                                              CSW207
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      ********************************************************************                    CSW207
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  ALPH                                                                                    BUG25858
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                  BUG25858
**  NUMC                                                                                    BUG25858
1234567890                                                                                  BUG25858
