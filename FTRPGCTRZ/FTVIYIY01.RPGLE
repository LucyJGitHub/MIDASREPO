     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate intermediary')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIYIY01 - Validate Intermediary                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG25385           Date 10Aug09               *
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
      *                 221760             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184179             Date 05Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT006  *CREATE    Date 18Oct99               *
      * Midas DBA 3.00 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184179 - Allow account starting with '/' in first field      *
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
 
      * All Intermediary screen fields
     D IntFields       DS
     D  W#PINSTA                     11
     D  W#PINST1                     35
     D  W#PINST2                     35
     D  W#PINST3                     35
     D  W#PINST4                     35
     D  W#PINST5                     35
 
     D  Char18         S             18                                         184179
     D  CSW202         S              1                                                       CSW202
     D  PRTCD          S              7                                                       CSW202
 
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
     C                   EVAL      OKINTA = 'Y'
     C                   EVAL      OKINT1 = 'Y'
     C                   EVAL      OKINT2 = 'Y'
     C                   EVAL      OKINT3 = 'Y'
     C                   EVAL      OKINT4 = 'Y'
     C                   EVAL      OKINT5 = 'Y'
     C                   EVAL      PINTTTP = *Blanks
     C                   CLEAR                   IntFields
 
      ** Main processing - validate only if field is non-blank
     C                   IF        PINST1 <> *Blanks  or  PINSTA <> *Blanks or
     C                             PINST2 <> *Blanks  or  PINST3 <> *Blanks or
     C                             PINST4 <> *Blanks  or  PINST5 <> *Blanks
     C                   EVAL      W#PINSTA = PINSTA
     C                   EVAL      W#PINST1 = PINST1
     C                   EVAL      W#PINST2 = PINST2
     C                   EVAL      W#PINST3 = PINST3
     C                   EVAL      W#PINST4 = PINST4
     C                   EVAL      W#PINST5 = PINST5
 
     C                   EXSR      VALIDATE
 
     C                   ENDIF
 
      ** In the case of incoming RFTs:
      ** If none of Beneficiary, A/C with Institution and Intermediary
      ** long fields contain a valid account, send on error message.
     C                   IF        PPTYP   = 'RI'     and
     C                             PBENTTP = *Blanks  and
     C                             PAWITTP = *Blanks  and
     C                             PINTTTP = *Blanks
     C                             Or PGOPFLG = 'Y'                                         BUG25385
     C                             And PPTYP = 'RI'                                         BUG25385
     C                             And PBENTTP = 'A'                                        BUG25385
     C                             And PINST1 = *Blanks                                     BUG25385
     C                             And PAWITTP = *Blanks                                    BUG25385
     C                             And PINTTTP = *Blanks                                    BUG25385
     C                   MOVE      'N'           OKINT1
     C                   Eval      Idx            =   Idx+1                                 BUG25385
     C                   Eval      RetCodeIn      =   'Error'                               BUG25385
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0122'                              BUG25385
     C                   Eval      FldNamXAr(Idx) =  DDSName                                BUG25385
     C                   ENDIF
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PINST1  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PINST1        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKINT1 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PINST2  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PINST2        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C**********         Eval      FldNamXAr(Idx) =  DDSName                                  CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINST2'                                 CAP084
     C                   EVAL      OKINT2 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PINST3  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PINST3        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C**********         Eval      FldNamXAr(Idx) =  DDSName                                  CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINST3'                                 CAP084
     C                   EVAL      OKINT3 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PINST4  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PINST4        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C**********         Eval      FldNamXAr(Idx) =  DDSName                                  CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINST4'                                 CAP084
     C                   EVAL      OKINT4 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PINST5  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PINST5        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C**********         Eval      FldNamXAr(Idx) =  DDSName                                  CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINST5'                                 CAP084
     C                   EVAL      OKINT5 = 'N'
     C                   Endif
     C                   Endif
      *                                                                                       221538
     C                   If        PINTTTP = ' ' And PINST1 <> *blanks Or                     221538
     C                             PINTTTP = ' ' And PINST2 <> *blanks Or                     221538
     C                             PINTTTP = ' ' And PINST3 <> *blanks Or                     221538
     C                             PINTTTP = ' ' And PINST4 <> *blanks Or                     221538
     C                             PINTTTP = ' ' And PINST5 <> *blanks Or                     221538
     C                             PINTTTP = ' ' And PINSTA <> *blanks                        221538
     C                   Eval      PINTTTP = 'A'                                              221538
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
      * Calls: FTVBCCC01                                              *
      *                                                               *
      *****************************************************************
     C     VALIDATE      BEGSR
      *
      ** Intermediary can only be entered if A/C with Institution has been
      ** entered already.
     C                   IF        IntFields <> *Blanks  and
     C                             PACA35 = *Blanks   and  PACA11 = *Blanks
     C                   MOVE      'N'           OKINTA
     C                   MOVE      'N'           OKINT1
     C                   MOVE      'N'           OKINT2
     C                   MOVE      'N'           OKINT3
     C                   MOVE      'N'           OKINT4
     C                   MOVE      'N'           OKINT5
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0121'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** 1st validation case: Beneficiary and A/C with Inst. do not contain
      ** a valid account and Transfer Type is 'RI'.
      ** and Outgoing Payment Flag is not 'Y'                                                 226083
     C**********         IF        PPTYP = 'RI'  and                                          221538
     C**********                   PAWITTP = *Blanks and  PBENTTP = *Blanks                   221538
     C*                                                                                       226083
     C                   IF        PPTYP = 'RI'                                               221538
     C                             and PGOPFLG <> 'Y' And                                     226083
     C***********        If        PBENTTP = 'A' Or PBENTTP = 'C' Or                   221538 226083
     C***********                  PBENTTP = 'S' Or PAWITTP = 'A' Or                   221538 226083
     C***********                  PAWITTP = 'C' Or PAWITTP = 'S'                      221538 226083
     C                             PBENTTP <> 'F' And PBENTTP <> 'G' And                      226083
     C                             PBENTTP <> 'I' And PBENTTP <> 'R' And                      226083
     C                             PAWITTP <> 'F' And PAWITTP <> 'G' And                      226083
     C                             PAWITTP <> 'R'                                             226083
      *
      ** Intermediary must be a valid account - nostro, general ledger
      ** or retail.
      *
     C                   CallB     'AOACCTV1'
     C                   Parm                    ACCTRetCde        7
     C                   Parm                    P@TYPE            7
     C                   Parm                    PINST1
     C                   Parm                    DSSDY
 
     C                   IF        ACCTRetCde <> *Blanks  or
     C                             P@TYPE <> '*NOSTRO' and
     C                             P@TYPE <> '*LEDGER' and
     C                             P@TYPE <> '*RETAIL'
     C                   ELSE
 
      * If contains a valid account and the first character is a /, remove.
 
     C                   If        %Subst(PINST1:1:1) = '/'
     C                   Eval      PINST1 = %Subst(PINST1:2)
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
      ** The currency of the A/C entered must equal the Payment Currency.
     C                   IF        CCY <> PPAYCCY  and PPAYCCY <> *Blanks       I:A/c Currency
     C                   MOVE      'N'           OKINT1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0123'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** If no problems with the account entered, set up hidden field.
     C                   IF        PINST1 <> *blanks And PINST2 = *blanks And                 221538
     C                             PINST3 = *blanks And PINST4 = *blanks  And                 221538
     C                             PINST5 = *blanks                                           221538
     C                   SELECT
     C                   WHEN      P@TYPE = '*LEDGER'
     C                   EVAL      PINTTTP = 'G'
     C                   WHEN      P@TYPE = '*NOSTRO'
     C                   EVAL      PINTTTP = 'F'
     C                   WHEN      P@TYPE = '*RETAIL'
     C                   EVAL      PINTTTP = 'R'
     C                   ENDSL
     C                   Endif                                                                221538
 
     C                   ENDIF
      *
      ** The 11-long field must be blank if the 35-long fields defines
      **    an account.
     C                   IF        PINSTA <> *Blanks                            I:A/c Currency
     C                   MOVE      'N'           OKINTA
     C                   ADD       1             Idx
     C**********         MOVEL     DDSName       FldNamXAr(Idx)                               CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINSTA'                                 CAP084
     C                   MOVEL     'RFV0128'     MsgIdXAr(Idx)
     C                   ENDIF
      **                                                                                      226083
      ** If valid account is defined, lines 2-5 must be blank                                 226083
      **                                                                                      226083
     C                   IF        PINST2 <> *Blanks  OR                                      226083
     C                             PINST3 <> *Blanks  OR                                      226083
     C                             PINST4 <> *Blanks  OR                                      226083
     C                             PINST5 <> *Blanks                                          226083
     C                   MOVE      'N'           OKINT2                                       226083
     C                   MOVE      'N'           OKINT3                                       226083
     C                   MOVE      'N'           OKINT4                                       226083
     C                   MOVE      'N'           OKINT5                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0926'     MsgIdXAr(Idx)                                226083
     C                   Endif                                                                226083
      *
     C                   ENDIF
     C***********        ENDIF                                                         221538 226083
      *
      ** ... Validation case 2:  All other situations
     C                   ELSE
      *
      ** Use access object to validate entries in the 11-long and the first
      ** of the 35-long fields.
     C                   CALLB     'FTVBCCC01'
     C                   Parm      'DETAIL'      RetCodeOut
     C                   Parm                    PINST1           35
     C                   Parm                    PINSTA           11
     C                   Parm                    DDSName                        CSW200
      *
     C                   IF        PINST1 <> *Blanks  or PINSTA <> *Blanks
      *
     C                   IF        %Subst(PINST1:1:2) =  '//'                   184179
      *
     C                   SELECT
      *
     C                   WHEN      RetCodeOut = '*INVALIDCC'                    I:A/c Currency
     C                   MOVE      'N'           OKINT1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0124'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*DIGITERR'                     I:A/c Currency
     C                   MOVE      'N'           OKINT1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   MOVEL     'RFV0119'     MsgIdXAr(Idx)                                CSW202
     C                   ELSE                                                                 CSW202
     C                   MOVEL     'RFV0125'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
      *
     C                   WHEN      RetCodeOut = '*11ERROR'                      I:A/c Currency
     C                   MOVE      'N'           OKINTA
     C                   ADD       1             Idx
     C**********         MOVEL     DDSName       FldNamXAr(Idx)                               CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINSTA'                                 CAP084
     C                   MOVEL     'RFV0126'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*BLANKERR'                     I:A/c Currency
     C                   MOVE      'N'           OKINT1
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0366'     MsgIdXAr(Idx)
      *
     C* These lines of codes are moved down below                                             226083
     C***********        WHEN      RetCodeOut = *blanks                         I:A/c Currency226083
     C***********                  and PINSTA <> *blanks                                      226083
     C***********                  or RetCodeOut = '*BICFND'                                  226083
     C***********                  and PINSTA <> *blanks                                      226083
      ***********                                                                             226083
     C***********        IF        PINST2 <> *blanks or PINST3 <> *blanks                     226083
     C***********                  or PINST4 <> *blanks or PINST5 <> *blanks                  226083
     C***********        MOVE      'N'           OKINT2                                       226083
     C***********        MOVE      'N'           OKINT3                                       226083
     C***********        MOVE      'N'           OKINT4                                       226083
     C***********        MOVE      'N'           OKINT5                                       226083
     C***********        ADD       1             Idx                                          226083
     C***********        MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C***********        MOVEL     'RFV0295'     MsgIdXAr(Idx)                                226083
     C***********        ENDIF                                                                226083
      *
     C                   ENDSL
      *
     C                   ENDIF                                                   184179
      *                                                                         184179
      * Ensure that if 11 character field entered contains either a BIC, CNUM   184179
      *  or SNAME                                                               184179
      *                                                                         184179
     C                   IF        PINSTA <> *Blanks                            184179
      *                                                                         184179
     C                   Eval      Char18 = PINSTA                              184179
     C**********         CallB     'AOBICDV0'                                          184179 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm      *Blanks       RetCodeIn                      184179
     C                   Parm                    Char18                         184179
     C                   Parm                    P@Type                         184179
     C                   Parm                    DSSDY                          184179
     C*                                                                                       226083
     C* If MEBICDPD is empty, allow entry of customer/shortname without bic                   226083
     C                   If        P@TYPE = '*NRF   ' And RetCodeIn = *blank                  226083
     C                             And %subst(PINSTA:11:1) = *blank                           226083
     C                   Movel     PINSTA        KeyVal                                       226083
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
     C                   MOVE      'N'           OKINTA                         184179
     C                   ADD       1             Idx                            184179
     C**********         MOVEL     DDSName       FldNamXAr(Idx)                        184179 CAP084
     C                   Eval      FldNamXAr(Idx) =  'PINSTA'                                 CAP084
     C**********         MOVEL     'RFV0128'     MsgIdXAr(Idx)                         184179 226083
     C                   MOVEL     'RFV0928'     MsgIdXAr(Idx)                                226083
     C                   ENDIF                                                  184179
      *                                                                         184179
      *                                                                                       226083
     C*  If PINSTA <> *blank, PINST2-5 are not allowed  and PINST1 must start                 226083
     C*  with '/' if entered.                                                                 226083
      *                                                                                       226083
     C                   IF        PINST2 <> *blanks or PINST3 <> *blanks                     226083
     C                             or PINST4 <> *blanks or PINST5 <> *blanks                  226083
     C                   MOVE      'N'           OKINT2                                       226083
     C                   MOVE      'N'           OKINT3                                       226083
     C                   MOVE      'N'           OKINT4                                       226083
     C                   MOVE      'N'           OKINT5                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0295'     MsgIdXAr(Idx)                                226083
     C                   ENDIF                                                                226083
      *                                                                                       226083
     C                   IF        PINST1 <> *blanks And                                      226083
     C                             %subst(PINST1:1:1) <> '/'                                  226083
     C                   MOVE      'N'           OKINT1                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0295'     MsgIdXAr(Idx)                                226083
     C                   ENDIF                                                                226083
      *                                                                                       226083
     C                   ENDIF                                                  184179
      *                                                                         184179
      *  If PINSTA is not entered, free format text is allowed but must not have              226083
      *  embedded blanks                                                                      226083
     C                   If        PINSTA = *blanks                                           226083
     C                   If        PINST1  = *Blanks AND  PINST2 <> *blank  OR                226083
     C                             PINST2  = *Blanks AND  PINST3 <> *blank  OR                226083
     C                             PINST3  = *Blanks AND  PINST4 <> *blank  OR                226083
     C                             PINST4  = *Blanks AND  PINST5 <> *blank                    226083
     C                   MOVE      'N'           OKINT1                                       226083
     C                   MOVE      'N'           OKINT2                                       226083
     C                   MOVE      'N'           OKINT3                                       226083
     C                   MOVE      'N'           OKINT4                                       226083
     C                   MOVE      'N'           OKINT5                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0927'     MsgIdXAr(Idx)                                226083
     C                   Endif                                                                226083
     C                   Endif                                                                226083
      *                                                                                       226083
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        Idx   = 0                                                  221538
      *                                                                                       226083
      **  Only customer, shortname, address, SWIFT and clearing code entry allowed here       226083
      **  so no need to check for valid internal account.                                     226083
      ***********                                                                             226083
     C***********        IF        PINST1 <> *blanks And PINST2 = *blanks And          221538 226083
     C***********                  PINST3 = *blanks And PINST4 = *blanks  And          221538 226083
     C***********                  PINST5 = *blanks                                    221538 226083
     C***********        CallB     'AOACCTV1'                                                 226083
     C***********        Parm                    ACCTRetCde        7                          226083
     C***********        Parm                    P@TYPE            7                          226083
     C***********        Parm                    PINST1                                       226083
     C***********        Parm                    DSSDY                                        226083
     C***********        Select                                                               226083
     C***********        When      P@TYPE = '*NOSTRO'                                         226083
     C***********        Eval      N@FMT  =  DSSDY                                            226083
     C***********        EVAL      CCY    =  A7CYCD                             O:ACCNT Format226083
     C***********        When      P@TYPE = '*RETAIL'                                         226083
     C***********        Eval      P@FMT  =  DSSDY                                            226083
     C***********        When      P@TYPE = '*LEDGER'                                         226083
     C***********        Eval      P@FMT  =  DSSDY                                            226083
     C***********        Endsl                                                                226083
     C***********        Endif                                                                226083
     C***********        IF        PINSTA <> *blanks And PINST1 = *blanks And          221538 226083
     C                   IF        PINSTA <> *blanks And                                      226083
     C                             PINST2 = *blanks And PINST3 = *blanks  And                 221538
     C                             PINST3 = *blanks And PINST4 = *blanks And                  221538
     C                             PINST5 = *blanks                                           221538
     C                   Eval      Char18 = PINSTA                                            221538
     C                   CallB     'AOBICDV01'                                                221538
     C                   Parm      *Blanks       RetCodeIn                                    221538
     C                   Parm                    Char18                                       221538
     C                   Parm                    P@Type                                       221538
     C                   Parm                    DSSDY                                        221538
     C*                                                                                       226083
     C* If MEBICDPD is empty, allow entry of customer/shortname without bic                   226083
     C                   If        P@TYPE = '*NRF   ' And RetCodeIn = *blank                  226083
     C                             And %subst(PINSTA:11:1) = *blank                           226083
     C                   Movel     PINSTA        KeyVal                                       226083
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
     C                   EVAL      PINTTTP = 'S'                                              221538
     C                   WHEN      P@TYPE = '*NUMBER' Or                                      221538
     C                             P@TYPE = '*SHNAME'                                         221538
     C                   EVAL      PINTTTP = 'C'                                              221538
     C                   If        P@TYPE = '*SHNAME'                                         221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   Movel(P)  BBCUST        PINSTA                                       221538
     C                   Endif                                                                221538
     C                   ENDSL                                                                221538
     C                   Endif                                                                221538
     C*                                                                                       226083
     C                   If        PINSTA =  *blank  And                                      226083
     C                             %subst(PINST1:1:1) = '/'  And                              226083
     C                             PINST2 = *blank And                                        226083
     C                             PINST3 = *blank And                                        226083
     C                             PINST4 = *blank And                                        226083
     C                             PINST5 = *blank                                            226083
     C                   EVAL      PINTTTP = 'A'                                              226083
     C                   Endif                                                                226083
     C*                                                                                       226083
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
                                                                                              CSW202
      ** Check if SWIFT 2002 is installed                                                     CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
                                                                                              CSW202
     C                   IF        PRTCD = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
 
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
(c) Misys International Banking Systems Ltd. 2001
