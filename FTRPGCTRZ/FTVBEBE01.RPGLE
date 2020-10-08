     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate beneficiary')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVBEBE01 - Validate Beneficiary                             *
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
      *                 MD034749           Date 19Jun15               *
      *                 MD034728           Date 18Jun15               *
      *                 229251             Date 18Jun15               *
      *                 CSW215             Date 06Apr15               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25136           Date 23Jul09               *
      *                 BUG24955           Date 15Jul09               *
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
      *                 226083             Date 01Apr04               *
      *                 221538             Date 01Apr04               *
      *                 224336             Date 01Apr04               *
      *                 221776             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 10Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034749 - Entry of number code '1/' should not be allowed   *
      *             in Beneficiary Line 1                             *
      *  MD034728 - Beneficiary Customer entry of beginnign '/' was   *
      *             removed upon completion of incoming RFTD          *
      *  229251 - Do not remove '/' until the account has been        *
      *           valdated as an internal account.                    *
      *         - Applied for MD-34728                                *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25136 - Second line must be present if /IBAN for RI       *
      *  BUG24955 - Generated transaction is not inline with input    *
      *             validation                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  226083 - Correct various MT101 validation errors             *
      *  221538 - Expansion of field details.                         *
      *  224336 - Remove nuisance warning messages                    *
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

      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D  SDY1_O       E                     EXTFLD(SDY1)
     D  SDY2_O       E                     EXTFLD(SDY2)
     D  SDY3_O       E                     EXTFLD(SDY3)
     D  SDY4_O       E                     EXTFLD(SDY4)

      * ACCNTABF - Account details record format data structure
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)
     D A@FMT         E DS                  EXTNAME(ACCNTAB)
     D P@FMT         E DS                  EXTNAME(DSSDY)
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

      ** Alphabetic array                                                                     226083
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)                          226083
      *                                                                                       226083
      ** Numeric array                                                                        226083
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)                          226083
      *                                                                                       226083
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
     D SECONDLINE      S              1A                                                    BUG24955
                                                                                              CSW215
      ** Work variable for CSW215                                                             CSW215
     D CSW215          S              1A                                                      CSW215
     D PErrTyp         S              1A                                                      CSW215
     D PNwrk           S              6A                                                      CSW215
     D PMsgTp          S              3A                                                      CSW215
     D PBrch           S              3A                                                      CSW215
     D PCurr           S              3A                                                      CSW215
     D PValTyp         S              4A                                                      CSW215
     D PCnty           S              2A                                                      CSW215
     D PNost           S              2A                                                      CSW215
     D POut1           S             35A                                                      CSW215
     D POut2           S             35A                                                      CSW215
     D POut3           S             35A                                                      CSW215
     D POut4           S             35A                                                      CSW215
     D POut5           S             35A                                                      CSW215
     D PMsgId          S              7A                                                      CSW215
     D PMsgTg          S              5A                                                      CSW215
     D ParmStr         S             35A                                                      CSW215
     D PKey1           S             10A                                                      CSW215
     D PKyst           S              7A                                                      CSW215
     D WCNum           S              6A                                                      CSW215
     D POptn           S              7A                                                      CSW215
     D WrkA35          S             35A                                                    MD034728
     D Wrk59F          S              1A                                                    MD034749
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
     C                   EVAL      Idx       = 0
     C                   EVAL      WIx       = 0
     C                   EVAL      OKBA35    = 'Y'
     C                   EVAL      OKBB35    = 'Y'
     C                   EVAL      OKBC35    = 'Y'
     C                   EVAL      OKBD35    = 'Y'
     C                   EVAL      OKBE35    = 'Y'
     C                   EVAL      PBENTTP   = *Blanks
     C                   EVAL      SECONDLINE = *Blanks                                     BUG24955
     C                   MOVE      'N'           SLASHIBAN         1                        BUG25136

      ** Clear work fields
     C                   CLEAR                   AccntCode
     C                   EVAL      P@TYPE = *Blanks
     C                   EVAL      W#Accno = *Blanks
      *
     C                   MOVE      'N'           InvldAcIns        1
     C                   MOVE      'N'           InvldInst         1
      *
      ** Check if A/C with institution is a valid account
      *
     C                   CallB     'AOACCTV1'
     C                   Parm                    ACCTRetCde
     C                   Parm                    P@TYPE
     C                   Parm                    PACA35
     C                   Parm                    DSSDY

     C                   IF        P@TYPE <> '*NOSTRO' and
     C                             P@TYPE <> '*LEDGER' and
     C                             P@TYPE <> '*RETAIL'
     C                   MOVE      'Y'           InvldAcIns
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
     C                   MOVE      'Y'           InvldAcIns
     C                   ENDIF

     C                   ENDIF
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
     C                   MOVE      'Y'           InvldInst
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
     C                   MOVE      'Y'           InvldInst
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      P@TYPE = *Blanks

      ** Main processing
     C                   EXSR      VALIDATE
     C                   EXSR      ValText

     C                   If        PBENTTP = ' '                                              221538
     C                   Eval      PBENTTP = 'A'                                              221538
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND Idx = 0                                   CSW215
     C                   EXSR      VAL59F                                                     CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
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
      ** Beneficiary is mandatory.
     C                   IF        PBNA35 = *Blanks
     C                             And PBNB35 = *Blanks                                       226083
     C                             And PBNC35 = *Blanks                                       226083
     C                             And PBND35 = *Blanks                                       226083
     C                             And PBNE35 = *Blanks                                       226083
     C*                                                                                       226083
     C                   MOVE      'N'           OKBA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0107'     MsgIdXAr(Idx)
     C                   ELSE
      *
      **  First character must be '/'.
      *
     C*****'/'**         SCAN      PBNA35        ScanPosn          2 0                        226083
      **********                                                                              226083
     C**********         IF        ScanPosn <> 1  AND                                         226083
     C**********                   PPTYP = 'RO'                                               226083
     C**********         MOVE      'N'           OKBA35                                       226083
     C**********         ADD       1             Idx                                          226083
     C**********         MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C**********         MOVEL     'RFV0109'     MsgIdXAr(Idx)                                226083
      **********                                                                              226083
     C**********         ELSE                                                                 226083
      *
      ** 1st validation case: A/C with Institution and Intermediary do not
      ** contain a valid account, Transfer Type is 'RI'.
      ** and Outgoign Payment Flag <> 'Y'                                                     226083
     C**********         IF        PPTYP = 'RI' and InvldAcIns = 'Y' and                      226083
     C**********                   InvldInst = 'Y'                                            226083
     C                   IF        PPTYP = 'RI' and PAWITTP <> 'G' And                        226083
     C                             PAWITTP <> 'R' and PAWITTP <> 'F'  And                     226083
     C                             PINTTTP <> 'R' and PINTTTP <> 'G' And                      226083
     C                             PINTTTP <> 'F' and PGOPFLG <> 'Y'                          226083
     C*                                                                                       226083
     C**Remove*starting*'/'*if*supplied********************************                226083 229251
     C***********        If        %subst(PBNA35:1:1) = '/'                            226083 229251
     C***********        Eval      PBNA35 = %subst(PBNA35:2)                           226083 229251
     C***********        Eval      %subst(PBNA35:35:1) = *blank                        226083 229251
     C***********        Endif                                                         226083 229251
      *
      ** 1) Beneficiary must be a valid account - nostro, General Ledger,
      **    retail or an IBAN.
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
     C**********         IF        CFT004 = 'Y'                                               226083
     C**********         SUBST     PBNA35:2      W#AccNo          34                          226083
      **********                                                                              226083
     C**********         CALLB     'AOIBANR5'                                                 226083
     C**********         PARM      *Blanks       IBANRetCde        7            B:Return code 226083
     C**********         PARM      W#AccNo       P@IBAN           34            I:Option      226083
      **********                                                                              226083
     C**********         ELSE                                                                 226083
     C**********         MOVEL     'Dummy'       IBANRetCde        7            B:Return code 226083
     C**********         ENDIF                                                  I:Option      226083

     C                   MOVEL     PBNA35        WrkA35                                     MD034728
     C                   MOVEL     ' '           Wrk59F                                     MD034749
     C                   If        %subst(PBNA35:1:1) <> '/'                                BUG24955
     C                   CallB     'AOACCTV1'
     C                   Parm                    ACCTRetCde        7
     C                   Parm                    P@TYPE            7
     C                   Parm                    PBNA35
     C                   Parm                    P@FMT
     C                   ENDIF                                                              BUG24955
                                                                                              226083
     C                   If        CFT004 = 'Y'                                               226083
                                                                                              226083
     C                   If        @Type <> '*LEDGER' And                                     226083
     C                             @Type <> '*RETAIL' And                                     226083
     C                             @Type <> '*NOSTRO'                                         226083
                                                                                              226083
     C                   Movel(P)  PBNA35        PIBAN                                        226083
      *                                                                                       229251
      ** Remove starting '/' if supplied                                                      229251
      *                                                                                       229251
     C                   IF        %SUBST(PIBAN:1:1) = '/'                                    229251
     C                   EVAL      PIBAN  = %SUBST(PIBAN:2)                                   229251
     C                   EVAL      %SUBST(PIBAN:35:1) = *BLANK                                229251
     C                   ENDIF                                                                229251
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
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      OKBA35    = 'N'                                            226083
      *                                                                                       226083
      ** Invalid country                                                                      226083
     C                   Select                                                               226083
     C                   When      PRTCD = '      1'                                          226083
     C                   Eval      MsgIdXAr(Idx)  =  'FTA0125'                                226083
      ** Invalid BBAN length on country file                                                  226083
     C                   When      PRTCD = '      2'                                          226083
     C                   Eval      MsgIdXAr(Idx)  =  'FTA0126'                                226083
      ** IBAN contains invalid characters                                                     226083
     C                   When      PRTCD = '      3'                                          226083
     C                   Eval      MsgIdXAr(Idx)  =  'FTA0127'                                226083
      ** IBAN length of BBAN is incorrect                                                     226083
     C                   When      PRTCD = '      4'                                          226083
     C                   Eval      MsgIdXAr(Idx)  =  'FTA0128'                                226083
      ** Checks Digits are not corrects                                                       226083
     C                   When      PRTCD = '      5'                                          226083
     C                   Eval      MsgIdXAr(Idx)  =  'FTA0129'                                226083
      ** Valid IBAN but not on the system, entry is not a valid account.                      226083
     C                   When      PRTCD = '      6'                                          226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0931'                                226083
     C                   Eval      @TYPE  = '*NRF   '                                         226083
     C                   Endsl                                                                226083
                                                                                              226083
     C                   Else                                                                 226083
                                                                                              226083
     C                   Eval      @RTCD  = *blank                                            226083
     C                   If        %subst(PBNA35:1:1) <> '/'                                BUG25136
     C                   Eval      P@TYPE  = '*IBAN  '                                        226083
     C                   Else                                                               BUG25136
     C                   EVAL      SLASHIBAN = 'Y'                                          BUG25136
     C                   Endif                                                              BUG25136
     C                   Endif                                                                226083
                                                                                              226083
     C                   ENDIF                                                                226083
     C                   ENDIF                                                                226083
     C                   ENDIF                                                  End CFT004    226083
      *
      ** Beginning '/' should be returned for SWIFT2015 50F validation                      MD034728
      *                                                                                     MD034728
     C                   IF        CSW215 = 'Y' AND                                         MD034728
     C                             (%SUBST(WrkA35:1:1) = '/' AND                            MD034728
     C                              %SUBST(PBNB35:2:1) = '/')                               MD034728
     C                   EVAL      PBENTTP = ' '                                            MD034728
     C                   MOVEL     WrkA35        PBNA35                                     MD034728
     C                   MOVEL     'Y'           Wrk59F                                     MD034749
     C                   ELSE                                                               MD034728
      *                                                                                     MD034728
     C**********         IF        IBANRetCde <> *Blanks  and                                 226083
     C**********                   ACCTRetCde <> *Blanks  or                                  226083
     C                   If        P@TYPE <> '*IBAN  '  and                                   226083
     C                             P@TYPE <> '*NOSTRO'  and
     C                             P@TYPE <> '*RETAIL'  and
     C                             P@TYPE <> '*LEDGER'
     C                   IF        PBNB35 = *blanks                                         BUG24955
     C                   MOVE      'N'           OKBB35                                     BUG24955
     C                   ADD       1             Idx                                        BUG24955
     C                   MOVEL     DDSName       FldNamXAr(Idx)                             BUG24955
     C                   MOVEL     'RFV0300'     MsgIdXAr(Idx)                              BUG24955
     C                   ENDIF                                                              BUG24955
      *                                                                                     BUG24955
     C                   EVAL      P@Type = *Blanks                                         BUG24955
     C**********         IF        CFT004 = 'Y'                                    BUG24955 BUG25136
     C**********         CALL      'AOIBANR2'                                      BUG24955 BUG25136
     C**********         PARM                    PRTCD                             BUG24955 BUG25136
     C**********         PARM                    PBNB35                            BUG24955 BUG25136
     C**********         PARM                    P@FMT                             BUG24955 BUG25136
     C**********         IF        PRtcd = *Blanks                                 BUG24955 BUG25136
     C**********         EVAL      P@Type = '*IBAN'                                BUG24955 BUG25136
     C**********         ENDIF                                                     BUG24955 BUG25136
     C**********         ENDIF                                                     BUG24955 BUG25136
     C**********         IF        P@Type <> '*IBAN'                               BUG24955 BUG25136
     C                   CallB     'AOACCTV1'                                               BUG24955
     C                   Parm                    ACCTRetCde                                 BUG24955
     C                   Parm                    P@TYPE                                     BUG24955
     C                   Parm                    PBNB35                                     BUG24955
     C                   Parm                    DSSDY                                      BUG24955
     C**********         ENDIF                                                     BUG24955 BUG25136
      *                                                                                     BUG24955
     C                   Select                                                             BUG24955
     C                   When      P@TYPE = '*NOSTRO'                                       BUG24955
     C                   Eval      N@FMT = DSSDY                                            BUG24955
     C                   EVAL      Secondline = 'Y'                                         BUG24955
     C                   Eval      CCY = A7CYCD                                             BUG24955
     C                   When      P@TYPE = '*RETAIL'                                       BUG24955
     C                   Eval      A@FMT = DSSDY                                            BUG24955
     C                   EVAL      Secondline = 'Y'                                         BUG24955
     C                   When      P@TYPE = '*LEDGER'                                       BUG24955
     C                             OR P@TYPE = '*IBAN  '                                    BUG24955
     C                   Eval      A@FMT = DSSDY                                            BUG24955
     C                   EVAL      Secondline = 'Y'                                         BUG24955
     C                   Endsl                                                              BUG24955
     C                   IF        SLASHIBAN = 'Y'                                          BUG25136
     C                   IF        PBNC35 = *Blanks and                                     BUG25136
     C                             PBND35 = *Blanks and                                     BUG25136
     C                             PBNE35 = *Blanks                                         BUG25136
     C                   If        P@Type = '*CUSTNO' or                                    BUG25136
     C                             P@Type = '*SHNAME'                                       BUG25136
     C                   Eval      PBENTTP = 'C'                                            BUG25136
     C                   If        P@Type = '*SHNAME'                                       BUG25136
     C                   Eval      C@FMT = DSSDY                                            BUG25136
     C                   Movel(P)  BBCUST        PBNB35                                     BUG25136
     C                   Endif                                                              BUG25136
     C                   Endif                                                              BUG25136
     C                   Endif                                                              BUG25136
     C                   ELSE                                                               BUG25136
      *                                                                                     BUG24955
      ** Must be in same currency                                                           BUG24955
      *                                                                                     BUG24955
     C                   IF        CCY <> PPAYCCY  and PPAYCCY <> *Blanks                   BUG24955
     C                   MOVE      'N'           OKBA35                                     BUG24955
     C                   ADD       1             Idx                                        BUG24955
     C                   MOVEL     DDSName       FldNamXAr(Idx)                             BUG24955
     C                   MOVEL     'RFV0110'     MsgIdXAr(Idx)                              BUG24955
     C                   ENDIF                                                              BUG24955
      *                                                                                     BUG24955
     C                   SELECT                                                             BUG24955
     C                   WHEN      P@TYPE = '*IBAN  '                                       BUG24955
     C                   EVAL      PBENTTP = 'I'                                            BUG24955
     C                   WHEN      P@TYPE = '*LEDGER'                                       BUG24955
     C                   EVAL      PBENTTP = 'G'                                            BUG24955
     C                   WHEN      P@TYPE = '*NOSTRO'                                       BUG24955
     C                   EVAL      PBENTTP = 'F'                                            BUG24955
     C                   WHEN      P@TYPE = '*RETAIL'                                       BUG24955
     C                   EVAL      PBENTTP = 'R'                                            BUG24955
     C                   ENDSL                                                              BUG24955
     C                   Endif                                                              BUG25136
     C                   ELSE

     C**********         If        %Subst(PBNA35:1:1) = '/'                                 BUG24955
     C**********         Eval      PBNA35 = %Subst(PBNA35:2)                                BUG24955
     C**********         Endif                                                              BUG24955

     C                   Select
     C                   When      P@TYPE = '*NOSTRO'
     C                   Eval      N@FMT = P@FMT
     C                   Eval      CCY = A7CYCD
     C                   Eval      P@ACID = PBNA35                                            221776
     C                   Call      'AOACCTV0'                                                 221776
     C                   Parm      *blanks       ACCTRetCde                                   221776
     C                   Parm                    P@ACID           10                          221776
     C                   Parm      *blanks       P@CYCD            3                          221776
     C                   Parm      *blanks       P@ACCD                                       221776
     C                   Parm      *blanks       P@ACSN            2                          221776
     C                   Parm      *blanks       P@BRCA            3                          221776
     C                   Parm      *blanks       @TYPE             7                          221776
     C                   Parm      *blanks       P@NOSN            2                          221776
     C     A@FMT         Parm      A@FMT         P@FMT                                        221776
     C                   When      P@TYPE = '*RETAIL'
     C                   Eval      A@FMT = P@FMT
     C                   When      P@TYPE = '*LEDGER'
     C                             OR P@TYPE = '*IBAN  '                                      226083
     C                   Eval      A@FMT = P@FMT
     C                   Endsl
      *                                                                                       221776
     C                   IF        P@TYPE = '*NOSTRO'  OR                                     221776
     C                             P@TYPE = '*RETAIL'  OR                                     221776
     C                             P@TYPE = '*IBAN  '  OR                                     226083
     C                             P@TYPE = '*LEDGER'                                         221776
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
     C                   Eval      OKBA35 = 'N'                                               221776
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
     C                   Eval      OKBA35 = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Blocked Credit                                                                       221776
      *                                                                                       221776
     C                   TESTB     '3'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0019'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKBA35 = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Inactive                                                                             221776
      *                                                                                       221776
     C                   TESTB     '4'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      WIx              =   WIx + 1                               221776
     C                   Eval      RetCodeIn        =   'Error'                               221776
     C                   Eval      WMsgIdXAr(WIx)   =   'FTM0017'                             221776
     C                   Eval      WFldNmXAr(WIx)   =   DDSName                               221776
     C                   Eval      OKBA35 = 'W'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Referred Credit                                                                      221776
      *                                                                                       221776
     C                   TESTB     '1'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      WIx              =   WIx + 1                               221776
     C                   Eval      RetCodeIn        =   'Error'                               221776
     C                   Eval      WMsgIdXAr(WIx)   =   'FTM0020'                             221776
     C                   Eval      WFldNmXAr(WIx)   =   DDSName                               221776
     C                   Eval      OKBA35 = 'W'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
     C                   Endif                                                                221776
      *
      ** 2) The currency of the A/C entered must equal the Payment Currency.
     C                   IF        CCY <> PPAYCCY  and PPAYCCY <> *Blanks
     C                   MOVE      'N'           OKBA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0110'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** If no problems with the account entered, set up hidden field.
     C                   SELECT
     C**********         WHEN      IBANRetCde = *Blanks                                       226083
     C                   WHEN      P@TYPE = '*IBAN  '                                         226083
     C                   EVAL      PBENTTP = 'I'
     C                   WHEN      P@TYPE = '*LEDGER'
     C                   EVAL      PBENTTP = 'G'
     C                   WHEN      P@TYPE = '*NOSTRO'
     C                   EVAL      PBENTTP = 'F'
     C                   WHEN      P@TYPE = '*RETAIL'
     C                   EVAL      PBENTTP = 'R'
     C                   ENDSL

     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                              MD034728
      *
      *
      ** ...Else the validation is the same in all other cases, i.e.:
      ** a) Transfer Type is 'RI' and the A/C with Institution or Inter-
      **    mediary contains a valid account.
      ** b) Transfer Type is 'RO'.
      ** c) Outgoing Payment Flag = 'Y'                                                       226083
      *
     C                   ELSE
      *                                                                                       226083
      * '/' is mandatory                                                                      226083
      *                                                                                       226083
     C                   IF        %subst(PBNA35:1:1) <> '/'                                  226083
     C                   MOVE      'N'           OKBA35                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0109'     MsgIdXAr(Idx)                                226083
     C                   Return                                                               226083
     C                   Endif                                                                226083
      *
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
     C                   IF        CFT004 = 'Y'
     C                   SUBST     PBNA35:2      W#AccNo          34
      **********                                                                              226083
     C**********         CALLB     'AOIBANR2'                                                 226083
     C**********         PARM      *Blanks       IBANRetCde        7            B:Return code 226083
     C**********         PARM      W#AccNo       P@IBAN           34            I:Option      226083
     C**********         PARM                    DSSDY                          I:Option      226083
      **********                                                                              226083
     C**********         ELSE                                                   I:Option      226083
     C**********         MOVEL     'Dummy'       IBANRetCde        7            B:Return code 226083
     C**********         ENDIF                                                  I:Option      226083
      **********                                                                              226083
     C**********         CallB     'AOACCTV1'                                                 226083
     C**********         Parm                    ACCTRetCde                                   226083
     C**********         Parm                    P@TYPE                                       226083
     C**********         Parm                    PBNA35                                       226083
     C**********         Parm                    P@FMT           800                          226083
      **********                                                                              226083
     C**********         IF        IBANRetCde <> *Blanks  and                                 226083
     C**********                   ACCTRetCde <> *Blanks  and                                 226083
     C**********                   ACCTRetCde <> '*KEY' and PPTYP = 'RI'                      226083
     C**********         MOVE      'W'           OKBA35                                       226083
     C**********         ADD       1             WIx                                          226083
     C**********         MOVEL     DDSName       WFldNmXAr(WIx)                               226083
     C**********         MOVEL     'RFV0118'     WMsgIdXAr(WIx)                               226083
     C**********         ENDIF                                                                226083
      **********                                                                              226083
                                                                                              226083
      *  Format field, removing blanks and IBAN prefix                                        226083
                                                                                              226083
     C                   CALL      'AOIBANR3'                                                 226083
     C                   PARM                    @Rcode            7                          226083
     C                   PARM      W#Accno       PIBAN            47                          226083
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
     C                   Eval      WIx              =   WIx + 1                               226083
     C                   Eval      RetCodeIn        =   'Error'                               226083
     C                   Eval      WFldNmXAr(WIx)  =  DDSName                                 226083
     C                   Eval      OKBA35    = 'W'                                            226083
                                                                                              226083
     C                   SELECT                                                               226083
                                                                                              226083
      *  Invalid ISO country code                                                             226083
     C                   WHEN      @RTCD  = '      1'                                         226083
     C                   EVAL      WMsgIdXAr(WIx)  = 'FTM2400'                                226083
      *  Invalid BBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      2'                                         226083
     C                   EVAL      WMsgIdXAr(WIx)  = 'FTM2401'                                226083
      *  Invalid character                                                                    226083
     C                   WHEN      @RTCD  = '      3'                                         226083
     C                   EVAL      WMsgIdXAr(WIx)  = 'FTM2402'                                226083
      *  Invalid IBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      4'                                         226083
     C                   EVAL      WMsgIdXAr(WIx)  = 'FTM2403'                                226083
      *  Invalid check digit                                                                  226083
     C                   WHEN      @RTCD  = '      5'                                         226083
     C                   EVAL      WMsgIdXAr(WIx)  = 'FTM2404'                                226083
      *  Other/non-specific warning                                                           226083
     C                   OTHER                                                                226083
     C                   EVAL      WMsgIdXAr(WIx)  = 'FTM2405'                                226083
     C                   ENDSL                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                  End IBAN chk  226083
      **                                                                                      226083
      **                                                                                      226083
      * Embedded blanks are not allowed                                                       226083
     C                   If        PBNA35  = *Blanks AND                                      226083
     C                             PBNB35  <>*Blanks OR                                       226083
     C                             PBNB35  = *Blanks AND                                      226083
     C                             PBNC35  <>*Blanks OR                                       226083
     C                             PBNC35  = *Blanks AND                                      226083
     C                             PBND35  <>*Blanks OR                                       226083
     C                             PBND35  = *Blanks AND                                      226083
     C                             PBNE35  <>*Blanks                                          226083
                                                                                              226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      RetCodeIn      =   'Error'                                 226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0925'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      OKBA35    = 'N'                                            226083
     C                   Eval      OKBA35    = 'N'                                            226083
     C                   Eval      OKBB35    = 'N'                                            226083
     C                   Eval      OKBC35    = 'N'                                            226083
     C                   Eval      OKBD35    = 'N'                                            226083
     C                   Eval      OKBE35    = 'N'                                            226083
                                                                                              226083
     C                   Endif                                                                226083
      *                                                                                       226083
      ** Validate 2nd line. It must be text, a customer number or shortname.
      *
     C                   IF        PBNB35 = *blanks
     C                   MOVE      'N'           OKBB35
     C                   ADD       1             Idx
     C*******************MOVEL     DDSName       FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'PBNB35'      FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'RFV0300'     MsgIdXAr(Idx)
     C**********         ENDIF                                                        224336  221538
      *                                                                                       224336
      * Users should not be bothered with these warning errors as free-format text            224336
      * should be acceptable if entry is not customer number or shortname                     224336
      *                                                                                       224336
     C**********         ELSE                                                                 224336
      **********                                                                              224336
     C**********         CallB     'AOACCTV1'                                                 224336
     C**********         Parm                    ACCTRetCde                                   224336
     C**********         Parm                    P@TYPE                                       224336
     C**********         Parm                    PBNB35                                       224336
     C**********         Parm                    DSSDY                                        224336
      **********                                                                              224336
     C**********         IF        %SUBST(PBNB35:7) = *Blanks                                 224336
     C**********                                                                              224336
     C**********         MOVEL     PBNB35        CNo               6                          224336
     C**********         TESTN                   Cno                  01                      224336
     C**********                                                                              224336
     C**********         IF        P@TYPE <> '*CUSTNO' and *IN01 = *ON                        224336
     C**********         MOVE      'W'           OKBB35                                       224336
     C**********         ADD       1             WIx                                          224336
     C*******************MOVEL     DDSName       WFldNmXAr(WIx)
     C**********         MOVEL     'PBNB35'      WFldNmXAr(WIx)                        CAP084 224336
     C**********         MOVEL     'RFV0291'     WMsgIdXAr(WIx)                               224336
     C**********         ENDIF                                                                224336
      **********                                                                              224336
     C**********         ELSE                                                                 224336
      **********                                                                              224336
     C**********         IF        %SUBST(PBNB35:11) = *Blanks                                224336
      **********                                                                              224336
     C**********         IF        P@TYPE <> '*SHNAME'                                        224336
     C**********         MOVE      'W'           OKBB35                                       224336
     C**********         ADD       1             WIx                                          224336
     C****************** MOVEL     DDSName       WFldNmXAr(WIx)                        CAP084 224336
     C**********         MOVEL     'PBNB35'      WFldNmXAr(WIx)                        CAP084 224336
     C**********         MOVEL     'RFV0292'     WMsgIdXAr(WIx)                               224336
     C**********         ENDIF                                                                224336
     C**********                                                                              224336
     C**********         ENDIF                                                                224336
     C**********         ENDIF                                                                224336
     C**********         ENDIF                                                                224336

     C                   ELSE                                                                 221538
     C                   CallB     'AOACCTV1'                                                 221538
     C                   Parm                    ACCTRetCde                                   221538
     C                   Parm                    P@TYPE                                       221538
     C                   Parm                    PBNB35                                       221538
     C                   Parm                    DSSDY                                        221538
      *                                                                                       221538
     C                   If        PBNC35 = *blank And                                        221538
     C                             PBND35 = *blank And                                        221538
     C                             PBNE35 = *blank                                            221538
     C                   If        P@TYPE = '*CUSTNO'                                         221538
     C                             OR P@TYPE = '*SHNAME'                                      221538
     C                   Eval      PBENTTP = 'C'                                              221538
     C                   If        P@TYPE = '*SHNAME'                                         221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   Movel(P)  BBCUST        PBNB35                                       221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   ENDIF
      *
     C**********         ENDIF                                                                226083
      *
      *
     C                   ENDIF

      ** In the case of incoming RFTs:
      ** If none of Beneficiary, A/C with Institution and Intermediary
      ** long fields contain a valid account, send on error message.
     C************       IF        PPTYP   = 'RI' and PBENTTP = *blanks                       226083
     C************                 and InvldInst = 'Y' and InvldAcIns = 'Y'                   226083
     C                   IF        PPTYP = 'RI' and PGOPFLG <> 'Y'                            226083
     C*                                                                                       226083
     C                   If        PBENTTP <> 'R' and PBENTTP <> 'F'  And                     226083
     C                             PBENTTP <> 'G' and PBENTTP <> 'I'  And                     226083
     C                             PBENTTP <> 'C' and Slashiban = 'N' And                   BUG25136
     C                             PAWITTP <> 'R' and PAWITTP <> 'F'  And                     226083
     C                             PAWITTP <> 'G' and PINTTTP <> 'G' And                      226083
     C                             PINTTTP <> 'F' and PINTTTP <> 'R'                          226083
     C                   IF        Wrk59F = 'Y'                                             MD034749
      ** Do not issue error                                                                 MD034749
     C                   ELSE                                                               MD034749
     C                   MOVE      'N'           OKBA35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0157'     MsgIdXAr(Idx)
     C                   ENDIF                                                                226083
     C                   ENDIF                                                              MD034728
     C*                                                                                       226083
     C                   If        PBENTTP =  'R' or  PBENTTP =  'F'  or                      226083
     C                             PBENTTP =  'G' or  PBENTTP =  'I'                          226083
     C                   IF        Secondline <> 'Y'                                        BUG24955
     C                   If        PBNB35  <> *blank or PBNC35 <> *blank and                  226083
     C                             PBND35  <> *blank or PBNE35 <> *blank                      226083
     C                   MOVE      'N'           OKBB35                                       226083
     C                   MOVE      'N'           OKBC35                                       226083
     C                   MOVE      'N'           OKBD35                                       226083
     C                   MOVE      'N'           OKBE35                                       226083
     C                   ADD       1             Idx                                          226083
     C                   MOVEL     DDSName       FldNamXAr(Idx)                               226083
     C                   MOVEL     'RFV0926'     MsgIdXAr(Idx)                                226083
     C                   ENDIF                                                                226083
     C                   ENDIF                                                                226083
     C                   ENDIF                                                              BUG24955
     C*                                                                                       226083
     C                   ENDIF
      *
      ** Ensure that the second line does not contain /
      *
     C     '/'           SCAN      PBNB35        ScanPos2          2 0
      *
     C                   If        ScanPos2 <> 0
      *                                                                                       CSW215
      ** Allow 1/,2/,3/  on the second line if CSW215 is 'Y'                                  CSW215
      *                                                                                       CSW215
     C                   IF        %SUBST(PBNB35:1:2) <> '1/' AND                             CSW215
     C                             %SUBST(PBNB35:1:2) <> '2/' AND                             CSW215
     C                             %SUBST(PBNB35:1:2) <> '3/'                                 CSW215
     C                             OR CSW215 = 'N'                                            CSW215
      *                                                                                       CSW215
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0352'
     C                   Eval      FldNamXAr(Idx)  =  'PBNB35'
     C                   Eval      OkBB35 = 'N'
     C                   ENDIF                                                                CSW215
     C                   Endif
      ************                                                                            226083
      ***Ensure*that the third line does not contain /                                        226083
      ************                                                                            226083
     C*****'/'****       SCAN      PBNC35        ScanPos3          2 0                        226083
      ************                                                                            226083
     C************       If        ScanPos3 <> 0                                              226083
     C************       Eval      Idx             =   Idx+1                                  226083
     C************       Eval      RetCodeIn       =   'Error'                                226083
     C************       Eval      MsgIdXAr(Idx)   =  'RFV0353'                               226083
     C************       Eval      FldNamXAr(Idx)  =  'PBNB35'                                226083
     C************       Eval      OkBC35 = 'N'                                               226083
     C************       Endif                                                                226083
      ************                                                                            226083
      ***Ensure*that the forth line does not contain /                                        226083
      ************                                                                            226083
     C*****'/'****       SCAN      PBND35        ScanPos4          2 0                        226083
      ************                                                                            226083
     C************       If        ScanPos4 <> 0                                              226083
     C************       Eval      Idx             =   Idx+1                                  226083
     C************       Eval      RetCodeIn       =   'Error'                                226083
     C************       Eval      MsgIdXAr(Idx)   =  'RFV0354'                               226083
     C************       Eval      FldNamXAr(Idx)  =  'PBND35'                                226083
     C************       Eval      OkBD35 = 'N'                                               226083
     C************       Endif                                                                226083
      ************                                                                            226083
      ***Ensure*that the fifth line does not contain /                                        226083
      ************                                                                            226083
     C*****'/'****       SCAN      PBNE35        ScanPos5          2 0                        226083
      ************                                                                            226083
     C************       If        ScanPos5 <> 0                                              226083
     C************       Eval      Idx             =   Idx+1                                  226083
     C************       Eval      RetCodeIn       =   'Error'                                226083
     C************       Eval      MsgIdXAr(Idx)   =  'RFV0355'                               226083
     C************       Eval      FldNamXAr(Idx)  =  'PBNE35'                                226083
     C************       Eval      OkBE35 = 'N'                                               226083
     C************       Endif                                                                226083
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * ValText  - Validate text                                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ValText       BEGSR

      * Now validate that all data entered is OK for SWIFT

     C                   If        PBNA35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PBNA35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKBA35    = 'N'
     C                   Endif
     C                   Endif

     C                   If        PBNB35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PBNB35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PBNB35'                   CAP084
     C                   EVAL      OKBB35    = 'N'
     C                   Endif
     C                   Endif

     C                   If        PBNC35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PBNC35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PBNC35'                   CAP084
     C                   EVAL      OKBC35    = 'N'
     C                   Endif
     C                   Endif

     C                   If        PBND35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PBND35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PBND35'                   CAP084
     C                   EVAL      OKBD35    = 'N'
     C                   Endif
     C                   Endif

     C                   If        PBNE35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PBNE35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PBNE35'                   CAP084
     C                   EVAL      OKBE35    = 'N'
     C                   Endif
     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW215
      *                                                               *                       CSW215
      * Val59F  - Validate 59F                                        *                       CSW215
      *                                                               *                       CSW215
      * Called by: Main processing                                    *                       CSW215
      *                                                               *                       CSW215
      * Calls: MG001001                                               *                       CSW215
      *                                                               *                       CSW215
      *****************************************************************                       CSW215
                                                                                              CSW215
     C     Val59F        BEGSR                                                                CSW215
                                                                                              CSW215
     C                   EVAL      PCnty = *BLANKS                                            CSW215
                                                                                              CSW215
      ** Get Country of location                                                              CSW215
      ** for Outgoing must be the Destination, for Incoming must be the Sender                CSW215
                                                                                              CSW215
     C                   IF        PPTYP = 'RI'                                               CSW215
     C                   EVAL      ParmStr = PSINST                                           CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      ParmStr = PRFTDST                                          CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   CALLB     'AOACCTV1'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      *BLANKS       P@Type                                       CSW215
     C                   PARM                    ParmStr                                      CSW215
     C                   PARM      *BLANKS       DSSDY                                        CSW215
      *                                                                                       CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
                                                                                              CSW215
     C                   SELECT                                                               CSW215
     C                   WHEN      P@Type = '*RETAIL'                                         CSW215
     C                             Or P@Type = '*LEDGER'                                      CSW215
     C                             Or P@Type = '*NOSTRO'                                      CSW215
                                                                                              CSW215
     C                   IF        P@Type = '*NOSTRO'                                         CSW215
     C                   EVAL      N@FMT = DSSDY                                              CSW215
     C                   MOVEL     A7CUST        PKey1                                        CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      A@FMT = DSSDY                                              CSW215
     C                   MOVE      CNUM          WCNum                                        CSW215
     C                   MOVEL     WCNum         PKey1                                        CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   CALL      'AOCUSTR0'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      '*KEY   '     POptn                                        CSW215
     C                   PARM                    PKey1                                        CSW215
     C                   PARM      *BLANKS       PKyst                                        CSW215
     C     C@FMT         PARM      *BLANKS       DSSDY                                        CSW215
                                                                                              CSW215
      ** if valid customer capture Country of location as Parameter to MG001001               CSW215
                                                                                              CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
     C                   EVAL      PCnty = BBCOLC                                             CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   WHEN      P@Type = '*CUSTNO'                                         CSW215
     C                             Or P@Type = '*SHNAME'                                      CSW215
     C                   EVAL      C@FMT = DSSDY                                              CSW215
     C                   EVAL      PCnty = BBCOLC                                             CSW215
                                                                                              CSW215
     C                   WHEN      P@Type = '*SWIFT'                                          CSW215
     C                   EVAL      PCnty = %Subst(ParmStr:5:2)                                CSW215
                                                                                              CSW215
     C                   ENDSL                                                                CSW215
                                                                                              CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   CALL      'MG001001'                                                 CSW215
      **Return Code                                                                           CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
      **Validation Type                                                                       CSW215
     C                   PARM      'TRAN'        PValTyp                                      CSW215
      **5X35 lines to be checked                                                              CSW215
     C                   PARM                    PBNA35                                       CSW215
     C                   PARM                    PBNB35                                       CSW215
     C                   PARM                    PBNC35                                       CSW215
     C                   PARM                    PBND35                                       CSW215
     C                   PARM                    PBNE35                                       CSW215
      **Network                                                                               CSW215
     C                   PARM      'SWIFT'       PNwrk                                        CSW215
      **Message Type                                                                          CSW215
     C                   PARM      '101'         PMsgTp                                       CSW215
      **Message tag                                                                           CSW215
     C                   PARM      ':59F:'       PMsgTg                                       CSW215
      ** Branch Code                                                                          CSW215
     C                   PARM      PBRCA         PBrch                                        CSW215
      ** Country of location                                                                  CSW215
     C                   PARM                    PCnty                                        CSW215
      ** Currency Code                                                                        CSW215
     C                   PARM      PTRNCCY       PCurr                                        CSW215
      ** Nostro                                                                               CSW215
     C                   PARM      *BLANKS       PNost                                        CSW215
      ** 5X35 lines to be output                                                              CSW215
     C                   PARM      *BLANKS       POut1                                        CSW215
     C                   PARM      *BLANKS       POut2                                        CSW215
     C                   PARM      *BLANKS       POut3                                        CSW215
     C                   PARM      *BLANKS       POut4                                        CSW215
     C                   PARM      *BLANKS       POut5                                        CSW215
      ** Message ID Field                                                                     CSW215
     C                   PARM      *BLANKS       PMsgId                                       CSW215
      ** Error Type                                                                           CSW215
     C                   PARM      *BLANKS       PErrTyp                                      CSW215
      *                                                                                       CSW215
     C                   IF        PErrTyp = 'E'                                              CSW215
     C                   EVAL      Idx = Idx + 1                                              CSW215
     C                   EVAL      RetCodeIn = 'Error'                                        CSW215
     C                   EVAL      MsgIdXAr(Idx) = PMSGID                                     CSW215
     C                   EVAL      FldNamXAr(Idx) = 'PBNA35'                                  CSW215
     C                   EVAL      OKBA35    = 'N'                                            CSW215
     C                   EVAL      OKBB35    = 'N'                                            CSW215
     C                   EVAL      OKBC35    = 'N'                                            CSW215
     C                   EVAL      OKBD35    = 'N'                                            CSW215
     C                   EVAL      OKBE35    = 'N'                                            CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   IF        PErrTyp = 'W'                                              CSW215
     C                   EVAL      WIx = WIx + 1                                              CSW215
     C                   EVAL      OKBA35    = 'W'                                            CSW215
     C                   EVAL      OKBB35    = 'W'                                            CSW215
     C                   EVAL      OKBC35    = 'W'                                            CSW215
     C                   EVAL      OKBD35    = 'W'                                            CSW215
     C                   EVAL      OKBE35    = 'W'                                            CSW215
     C                   EVAL      WFldNmXAr(WIx) = 'PBNA35'                                  CSW215
     C                   EVAL      WMsgIdXAr(WIx) = PMSGID                                    CSW215
                                                                                              CSW215
     C                   IF        PMSGID = 'ME00329'                                         CSW215
     C                   EVAL      WMsgDtXAr(WIx) = PNWRK                                     CSW215
     C                   ELSEIF    PMSGID = 'ME00330'                                         CSW215
     C                   EVAL      WMsgDtXAr(WIx) = PMSGTG                                    CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   ENDSR                                                                CSW215
                                                                                              CSW215
      *****************************************************************                       CSW215
      /EJECT                                                                                  CSW215
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
      *
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

      ** Check if SWIFT 2015enhancement is installed                                          CSW215
      *                                                                                       CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
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
**  ALPH
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  NUMC
1234567890
