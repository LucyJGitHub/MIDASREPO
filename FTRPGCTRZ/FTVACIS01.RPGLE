     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate a/c with institution(merge from)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVACIS01 - Validate Account with Institution                *
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
      *  Prev Amend No. MD034627           Date 08Jun15               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25385           Date 10Aug09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
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
      *                 221760             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      *                 221538             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184179             Date 21Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT006  *CREATE    Date 18Oct99               *
      * Midas DBA 3.00 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034627 - Incomplete fix applied 226083 in FTVACIS01 program*
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25385 - Database error appears when opening OPAC          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  226083 - Correct various RFTD validation errors.             *
      *           Here, if valid internal account entered, lines      *
      *           2-5 must be blank.                                  *
      *  221538 - Expansion of field details.                         *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184179 - If transaction type = 'RO', and account is allowed  *
      *           in the second field as long as preceeded with '/' . *
      *  CSW200 - SWIFT 2000 enhancements                             *
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
 
      * ACCNTABF - Account details record format data structure
     D P@FMT         E DS                  EXTNAME(ACCNTAB)
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)                                  221538
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
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
 
     D P@ACID          S             10
     D P@TYPE          S              7
     D P@NOSN          S              2
 
 
     D RespMode        S              1
 
     D DDSName         S             10
 
     D ACCTRetCde      S              7
 
      * SWIFT 2000 flag                                                         CSW200
     D  CSW200         S              1                                         CSW200
                                                                                CSW200
     D  Char18         S             18                                         184179
 
 
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
     C                   EVAL      Idx    = 0
     C                   EVAL      WIdx   = 0
     C                   EVAL      OKAA35 = 'Y'
     C                   EVAL      OKAI11 = 'Y'
     C                   EVAL      PAWITTP = *Blanks
 
     C                   MOVE      'N'           InvldInst         1
      *
      ** Check if intermediary is a valid account
      *
     C                   CallB     'AOACCTV1'
     C                   Parm                    ACCTRetCde
     C                   Parm                    P@TYPE
     C                   Parm                    PINST1
     C                   Parm                    DSSDY
 
     C                   IF        P@TYPE <> '*NOSTRO' and
     C                             P@TYPE <> '*LEDGER' and
     C                             P@TYPE <> '*RETAIL'
     C                   MOVE      'Y'           InvldInst         1
     C                   ELSE
 
     C                   Select
     C                   When      P@TYPE = '*NOSTRO'
     C                   Eval      N@FMT  =  DSSDY
     C                   EVAL      CCY    =  A7CYCD                             O:ACCNT Format
     C                   When      P@TYPE = '*RETAIL'
     C                   Eval      P@FMT  =  DSSDY
     C                   When      P@TYPE = '*LEDGER'
     C                   Eval      P@FMT  =  DSSDY
     C                   Endsl
 
     C                   IF        CCY <> PPAYCCY  and PPAYCCY <> *Blanks       I:A/c Currency
     C                   MOVE      'Y'           InvldInst         1
     C                   ENDIF
 
     C                   ENDIF
 
 
      ** Main processing - validate only if either field is non-blank
     C                   IF        PACA35 <> *Blanks  or  PACA11 <> *Blanks
 
     C                   EXSR      VALIDATE
 
     C                   ENDIF
 
      ** In the case of incoming RFTs:
      ** If none of Beneficiary, A/C with Institution and Intermediary
      ** long fields contain a valid account, send on error message.
     C                   IF        PPTYP   = 'RI'     and
     C                             PBENTTP = *Blanks  and
     C                             PAWITTP = *Blanks and InvldInst = 'Y'
     C                             Or PGOPFLG = 'Y'                                         BUG25385
     C                             And PPTYP = 'RI'                                         BUG25385
     C                             And PBENTTP = 'A'                                        BUG25385
     C                             And PACA35 = *Blanks                                     BUG25385
     C                             And PAWITTP = *Blanks and InvldInst = 'Y'                BUG25385
     C                   MOVE      'N'           OKAA35
     C                   Eval      Idx            =   Idx+1                                 BUG25385
     C                   Eval      RetCodeIn      =   'Error'                               BUG25385
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0115'                              BUG25385
     C                   Eval      FldNamXAr(Idx) =  DDSName                                BUG25385
     C                   ENDIF
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PACA35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PACA35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C*******************EVAL      OKAA35 = 'Y'                                 CAP084
     C                   EVAL      OKAA35 = 'N'                                 CAP084
     C                   Endif
     C                   Endif
 
      **Now*validate*that all data entered is OK for SWIFT                      CAP084
      ******************                                                        CAP084
     C****************** If        PACA35  <> *Blanks                           CAP084
     C****************** CallB     'FTVSFTX01'                                  CAP084
     C****************** Parm                    RetCdeIn         10            CAP084
     C****************** Parm      PACA35        Swift_Text       50            CAP084
     C****************** If        RetCdeIn = 'Error'                           CAP084
     C****************** Eval      Idx            =   Idx+1                     CAP084
     C****************** Eval      RetCodeIn      =   'Error'                   CAP084
     C****************** Eval      MsgIdXAr(Idx)  =  'RFV0364'                  CAP084
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C****************** EVAL      OKAA35 = 'Y'                                 CAP084
     C****************** Endif                                                  CAP084
     C****************** Endif                                                  CAP084
                                                                                              226083
     C                   If        PACC35  <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PACC35        Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   EVAL      OKAC35 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        PACD35  <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PACD35        Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   EVAL      OKAD35 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        PACE35  <> *Blanks                                         226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm      PACE35        Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   EVAL      OKAE35 = 'N'                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
      *                                                                                       221538
     C                   If        PAWITTP = ' ' And PACA35 <> *blanks Or                     221538
     C                             PAWITTP = ' ' And PACB35 <> *blanks Or                     221538
     C                             PAWITTP = ' ' And PACC35 <> *blanks Or                     221538
     C                             PAWITTP = ' ' And PACD35 <> *blanks Or                     221538
     C                             PAWITTP = ' ' And PACE35 <> *blanks Or                     221538
     C                             PAWITTP = ' ' And PACA11 <> *blanks                        221538
     C                   Eval      PAWITTP = 'A'                                              221538
     C                   Endif                                                                221538
 
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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     VALIDATE      BEGSR
      *
      ** 1st validation case: Beneficiary and Intermediary do not contain
      ** a valid account and Transfer Type is 'RI'.
     C**********         IF        PPTYP = 'RI'  and                                          221538
     C**********                   PBENTTP = *Blanks  and  InvldInst = 'Y'                    221538
      *                                                                                       221538
     C                   IF        PPTYP = 'RI'                                               221538
     C                             And PGOPFLG <> 'Y'  And                                  MD034627
     C**********         If        PBENTTP = 'A' Or                                  221538 MD034627
     C**********                   PBENTTP = 'C' Or                                  221538 MD034627
     C**********                   PBENTTP = 'S'                                     221538 MD034627
     C                             PBENTTP <> 'F' And PBENTTP <> 'G' And                    MD034627
     C                             PBENTTP <> 'I' And PBENTTP <> 'R' And                    MD034627
     C                             PINTTTP <> 'F' And PINTTTP <> 'G' And                    MD034627
     C                             PINTTTP <> 'R'                                           MD034627
      *
      **  A/C with Inst. must be a valid account - nostro, general ledger
      **  or retail.
     C                   CallB     'AOACCTV1'
     C                   Parm                    ACCTRetCde
     C                   Parm                    P@TYPE
     C                   Parm                    PACA35
     C                   Parm                    DSSDY
      *
     C                   IF        ACCTRetCde <> *Blanks  or
     C                             P@TYPE <> '*NOSTRO'  and
     C                             P@TYPE <> '*RETAIL'  and
     C                             P@TYPE <> '*LEDGER'
     C                   ELSE
 
      * If a valid account, remove the leading / if there is one
     C                   If        %Subst(PACA35:1:1) = '/'
     C                   Eval      PACA35 = %Subst(PACA35:2)
     C                   Endif
 
     C                   Select
     C                   When      P@TYPE = '*NOSTRO'
     C                   Eval      N@FMT  =  DSSDY
     C                   EVAL      CCY    =  A7CYCD                             O:ACCNT Format
     C                   When      P@TYPE = '*RETAIL'
     C                   Eval      P@FMT  =  DSSDY
     C                   When      P@TYPE = '*LEDGER'
     C                   Eval      P@FMT  =  DSSDY
     C                   Endsl
 
      *
      **  The currency of the A/C entered must equal the Payment Currency.
      *
     C                   IF        CCY <> PPAYCCY  and PPAYCCY <> *Blanks       I:A/c Currency
     C                   MOVE      'N'           OKAA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0116'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** If A/C entered is OK set up hidden field.
      *
     C                   If        PACB35 = *blanks And PACC35 = *blanks And                  221538
     C                             PACD35 = *blanks And PACE35 = *blanks                      221538
     C                   SELECT
     C                   WHEN      P@TYPE = '*LEDGER'
     C                   EVAL      PAWITTP = 'G'
     C                   WHEN      P@TYPE = '*NOSTRO'
     C                   EVAL      PAWITTP = 'F'
     C                   WHEN      P@TYPE = '*RETAIL'
     C                   EVAL      PAWITTP = 'R'
     C                   ENDSL
     C                   Endif                                                                221538
 
     C                   ENDIF
      *
      **  The 11-long field must be blank if the 35-long fields defines
      **  an account.
     C                   IF        PACA11 <> *Blanks                            I:A/c Currency
     C                   MOVE      'N'           OKAI11
     C                   ADD       1             Idx
     C*******************MOVEL     DDSName       FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'PACA11'      FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'RFV0127'     MsgIdXAr(Idx)
     C                   ENDIF
      **                                                                                    MD034627
     C                   IF        PACB35 <> *Blanks  OR                                    MD034627
     C                             PACC35 <> *Blanks  OR                                    MD034627
     C                             PACD35 <> *Blanks  OR                                    MD034627
     C                             PACE35 <> *Blanks                                        MD034627
     C                   MOVE      'N'           OKAB35                                     MD034627
     C                   MOVE      'N'           OKAC35                                     MD034627
     C                   MOVE      'N'           OKAD35                                     MD034627
     C                   MOVE      'N'           OKAE35                                     MD034627
     C                   ADD       1             Idx                                        MD034627
     C                   MOVEL     DDSName       FldNamXAr(Idx)                             MD034627
     C                   MOVEL     'RFV0926'     MsgIdXAr(Idx)                              MD034627
      *
     C                   ENDIF
     C                   ENDIF                                                                221538
      *
      ** ... Validation case 2:  All other situations
     C                   ELSE
      *
      ** Use access object to validate entries in the 11-long and the first
      ** of the 35-long fields.
     C                   IF        PACA35 <> *Blanks  or  PACA11 <> *Blanks
      *
     C                   CALLB     'FTVBCCC01'
     C                   Parm      'DETAIL'      RetCodeOut
     C                   Parm                    PACA35
     C                   Parm                    PACA11
     C                   Parm                    DDSName                        CSW200
      *
     C                   IF        %Subst(PACA35:1:2) =  '//'                   184179
      *
     C                   SELECT
      *
     C                   WHEN      RetCodeOut = '*INVALIDCC'                    I:A/c Currency
     C                   MOVE      'N'           OKAA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0113'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*DIGITERR'                     I:A/c Currency
     C                   MOVE      'N'           OKAA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0119'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*11ERROR'                      I:A/c Currency
     C                   MOVE      'N'           OKAI11
     C                   ADD       1             Idx
     C*******************MOVEL     DDSName       FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'PACA11'      FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'RFV0120'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*BLANKERR'                     I:A/c Currency
     C                   MOVE      'N'           OKAA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0366'     MsgIdXAr(Idx)
      *
     C                   ENDSL
      *
     C                   ENDIF                                                  184179
      *
     C                   IF        PINST1 <> *Blank  or
     C                             PINST2 <> *Blank  or
     C                             PINST3 <> *Blank  or
     C                             PINST4 <> *Blank  or
     C                             PINST5 <> *Blank  or
     C                             PINSTA <> *Blank
     C                   IF        %SUBST(PACA35:1:4) = '//FW'  or
     C                             %SUBST(PACA35:1:4) = '//AU'  or
     C                             %SUBST(PACA35:1:4) = '//SC'  or
     C                             %SUBST(PACA35:1:4) = '//CP'  or
     C*******************          %SUBST(PACA35:1:4) = '//RT'                  CSW200
     C                             %SUBST(PACA35:1:4) = '//RT'  and             CSW200
     C                             CSW200            <> 'Y'                     CSW200
     C                   MOVE      'N'           OKAA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0114'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C* These lines of codes are moved down below                                             226083
     C***********        IF        RetCodeOut = *blanks                                       226083
     C***********                  and PACA11 <> *blanks                                      226083
     C***********                  or RetCodeOut = '*BICFND'                                  226083
     C***********                  and PACA11 <> *blanks                                      226083
      ***********                                                                             226083
     C***********        IF        PACB35 <> *blanks or PACC35 <> *blanks                     226083
     C***********                  or PACD35 <> *blanks or PACE35 <> *blanks                  226083
     C***********        MOVE      'N'           OKAB35                                       226083
     C***********        MOVE      'N'           OKAC35                                       226083
     C***********        MOVE      'N'           OKAD35                                       226083
     C***********        MOVE      'N'           OKAE35                                       226083
     C***********        ADD       1             Idx                                          226083
     C***********        MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C***********        MOVEL     'RFV0294'     MsgIdXAr(Idx)                                226083
     C***********        ENDIF                                                                226083
     C***********        ENDIF                                                                226083
      *
     C                   ENDIF
      *                                                                         184179
      * Ensure that if 11 character field entered contains either a BIC, CNUM   184179
      *  or SNAME                                                               184179
      *                                                                         184179
     C                   IF        PACA11 <> *Blanks                            184179
      *                                                                         184179
     C                   Eval      Char18 = PACA11                              184179
     C**********         CallB     'AOBICDV0'                                          184179 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm      *Blanks       RetCodeIn                      184179
     C                   Parm                    Char18                         184179
     C                   Parm                    P@Type                         184179
     C                   Parm                    DSSDY                          184179
     C*                                                                                       226083
     C* If MEBICDPD is empty, allow entry of customer/shortname without bic                   226083
     C                   If        P@TYPE = '*NRF   ' And RetCodeIn = *blank                  226083
     C                             And %subst(PACA11:11:1) = *blank                           226083
     C                   Movel     PACA11        KeyVal                                       226083
     C                   Call      'AOCUSTR0'                                                 226083
     C                   Parm      *Blanks       @Rtcd                                        226083
     C                   Parm      '*KEY   '     @Optn                                        226083
     C                   Parm                    KeyVal           10                          226083
     C                   Parm      *Blanks       @Type             7                          226083
     C                   Parm                    DSSDY                                        226083
     C*                                                                                       226083
     C                   If        @RTCD = *blank      And                                    226083
     C                             @TYPE  = '*CNUM  '                                         226083
     C                   Eval      P@TYPE = '*NUMBER'                                         226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        @RTCD =   *blank    And                                    226083
     C                             @TYPE  = '*CSHT  '                                         226083
     C                   Eval      P@TYPE = '*SHNAME'                                         226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
                                                                                184179
     C                   IF        P@TYPE <> '*BIC   ' AND                      184179
     C                             P@TYPE <> '*NUMBER' AND                      184179
     C                             P@TYPE <> '*SHNAME'                          184179
      *                                                                         184179
     C                   MOVE      'N'           OKAI11                         184179
     C                   ADD       1             Idx                            184179
     C*******************MOVEL     DDSName       FldNamXAr(Idx)           184179CAP084
     C                   MOVEL     'PACA11'      FldNamXAr(Idx)                 CAP084
     C************       MOVEL     'RFV0120'     MsgIdXAr(Idx)                         184179 226083
     C                   MOVEL     'RFV0929'     MsgIdXAr(Idx)                                226083
      *                                                                         184179
     C                   ENDIF                                                  184179
      *                                                                                       226083
     C*  If PACA11 <> *blank, lines2-5 are not allowed  and PACB35 must start                 226083
     C*  with '/' if entered.                                                                 226083
      *                                                                                       226083
     C                   IF        PACB35 <> *blanks or PACC35 <> *blanks                     226083
     C                             or PACD35 <> *blanks or PACE35 <> *blanks                  226083
     C                   MOVE      'N'           OKAB35                                       226083
     C                   MOVE      'N'           OKAC35                                       226083
     C                   MOVE      'N'           OKAD35                                       226083
     C                   MOVE      'N'           OKAE35                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0295'     MsgIdXAr(Idx)                                226083
     C                   ENDIF                                                                226083
      *                                                                                       226083
     C                   IF        PACA35 <> *blanks And                                      226083
     C                             %subst(PACA35:1:1) <> '/'                                  226083
     C                   MOVE      'N'           OKAA35                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0295'     MsgIdXAr(Idx)                                226083
     C                   ENDIF                                                                226083
      *                                                                         184179
     C                   ENDIF                                                  184179
      *  If PACA11 is not entered, free format text is allowed but must not have              226083
      *  embedded blanks                                                                      226083
     C                   If        PACA11 = *blanks                                           226083
     C                   If        PACA35  = *Blanks AND  PACB35 <> *blank  OR                226083
     C                             PACB35  = *Blanks AND  PACC35 <> *blank  OR                226083
     C                             PACC35  = *Blanks AND  PACD35 <> *blank  OR                226083
     C                             PACD35  = *Blanks AND  PACE35 <> *blank                    226083
     C                   MOVE      'N'           OKAA35                                       226083
     C                   MOVE      'N'           OKAB35                                       226083
     C                   MOVE      'N'           OKAC35                                       226083
     C                   MOVE      'N'           OKAD35                                       226083
     C                   MOVE      'N'           OKAE35                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0930'     MsgIdXAr(Idx)                                226083
     C                   Endif                                                                226083
      *
     C                   ENDIF
      *                                                                                       221538
     C                   If        Idx = 0                                                    221538
      *                                                                                       226083
      **  Only customer, shortname, address, SWIFT and clearing code entry allowed here       226083
      **  so no need to check for valid internal account.                                     226083
      ***********                                                                             226083
     C***********        If        PACB35 = *blanks And PACC35 = *blanks And           221538 226083
     C***********                  PACD35 = *blanks And PACE35 = *blanks               221538 226083
     C***********        CallB     'AOACCTV1'                                          221538 226083
     C***********        Parm                    ACCTRetCde                            221538 226083
     C***********        Parm                    P@TYPE                                221538 226083
     C***********        Parm                    PACA35                                221538 226083
     C***********        Parm                    DSSDY                                 221538 226083
     C***********        SELECT                                                        221538 226083
     C***********        WHEN      P@TYPE = '*LEDGER'                                  221538 226083
     C***********        EVAL      PAWITTP = 'G'                                       221538 226083
     C***********        WHEN      P@TYPE = '*NOSTRO'                                  221538 226083
     C***********        EVAL      PAWITTP = 'F'                                       221538 226083
     C***********        WHEN      P@TYPE = '*RETAIL'                                  221538 226083
     C***********        EVAL      PAWITTP = 'R'                                       221538 226083
     C***********        ENDSL                                                         221538 226083
     C***********        Endif                                                         221538 226083
      *                                                                                       221538
     C***********        If        PACA35 = *blanks And PACB35 = *blanks And           221538 226083
     C                   If        PACA11<> *blanks And PACB35 = *blanks And                  226083
     C                             PACC35 = *blanks And PACD35 = *blanks And                  221538
     C                             PACE35 = *blanks                                           221538
     C                   Eval      Char18 = PACA11                                            221538
     C                   CallB     'AOBICDV01'                                                221538
     C                   Parm      *Blanks       RetCodeIn                                    221538
     C                   Parm                    Char18                                       221538
     C                   Parm                    P@Type                                       221538
     C                   Parm                    DSSDY                                        221538
     C*                                                                                       226083
     C* If MEBICDPD is empty, allow entry of customer/shortname without bic                   226083
     C                   If        P@TYPE = '*NRF   ' And RetCodeIn = *blank                  226083
     C                             And %subst(PACA11:11:1) = *blank                           226083
     C                   Movel     PACA11        KeyVal                                       226083
     C                   Call      'AOCUSTR0'                                                 226083
     C                   Parm      *Blanks       @Rtcd                                        226083
     C                   Parm      '*KEY   '     @Optn                                        226083
     C                   Parm                    KeyVal           10                          226083
     C                   Parm      *Blanks       @Type             7                          226083
     C                   Parm                    DSSDY                                        226083
     C*                                                                                       226083
     C                   If        @RTCD = *blank      And                                    226083
     C                             @TYPE  = '*CNUM  '                                         226083
     C                   Eval      P@TYPE = '*NUMBER'                                         226083
     C                   Eval      C@FMT= DSSDY                                               226083
     C                   Endif                                                                226083
                                                                                              226083
     C                   If        @RTCD =   *blank    And                                    226083
     C                             @TYPE  = '*CSHT  '                                         226083
     C                   Eval      P@TYPE = '*SHNAME'                                         226083
     C                   Eval      C@FMT= DSSDY                                               226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
     C                   SELECT                                                               221538
     C                   WHEN      P@TYPE = '*BIC'                                            221538
     C                   EVAL      PAWITTP = 'S'                                              221538
     C                   WHEN      P@TYPE = '*NUMBER' Or                                      221538
     C                             P@TYPE = '*SHNAME'                                         221538
     C                   EVAL      PAWITTP = 'C'                                              221538
     C                   If        P@TYPE = '*SHNAME'                                         221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   Movel(P)  BBCUST        PACA11                                       221538
     C                   Endif                                                                221538
     C                   ENDSL                                                                221538
     C                   Endif                                                                221538
     C*                                                                                       226083
     C                   If        PACA11 =  *blank  And                                      226083
     C                             %subst(PACA35:1:1) = '/'  And                              226083
     C                             PACB35 = *blank And                                        226083
     C                             PACC35 = *blank And                                        226083
     C                             PACD35 = *blank And                                        226083
     C                             PACE35 = *blank                                            226083
     C                   EVAL      PAWITTP = 'A'                                              226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                221538
     C                   Endif                                                                221538
      *
     C                   ENDSR
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
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
 
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
     C                   PARM                    DDSName
     C                   PARM                    OKFlags
 
      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Check if SWIFT 2000 is applicable.                                     CSW200
                                                                                CSW200
     C                   CALLB     'SWIF2000'                                   CSW200
     C                   PARM      *BLANKS       RetCode7          7            CSW200
                                                                                CSW200
     C                   IF        RetCode7 <> *Blanks                          CSW200
     C                   EVAL      CSW200 = 'Y'                                 CSW200
     C                   ELSE                                                   CSW200
     C                   EVAL      CSW200 = 'N'                                 CSW200
     C                   ENDIF                                                  CSW200
                                                                                CSW200
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
