     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate beneficiary - detail')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVBEBE02 - Validate Beneficiary - Detail                    *
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
      *                 CSW215             Date 06Apr15               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25235           Date 29Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
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
      *                 CSW200             Date 24Aug00               *
      *                 177662             Date 21Aug00               *
      *                 CFT008  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25235 - Beneficiary must not be a valid account if        *
      *             Generate OP Flag is set to 'Y'                    *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
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
      *  CSW200 - SWIFT 2000 enhancements                             *
      *  177662 - Change cross validation with :23: = CHQB            *
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

      ** Arrays used to check clearing code if SWIFT 2000 is on                 CSW200
     D ArrDig          S              1    DIM(10) CTDATA PERRCD(10)            CSW200
     D StrArr          S              1    DIM(35)                              CSW200
                                                                                CSW200
      ** Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)

      ** Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)

      ** OK Flags for first screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)

      ** OK Flags for Second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)

      ** OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)

      ** OK Flags for Second screen - Header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)

      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)                                  221538

      ** External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
      ** Nostro DS                                                                            CSW215
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSW215

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

     D PAcct           S             35

     D RespMode        S              1

     D DDSName         S             10

     D WValid          S              1    INZ('Y')

     D BnkCod          C                   'CHQB'

     D CSW200          S              1                                         CSW200
                                                                                CSW200
     D SPos            S              3  0                                      CSW200
     D EPos            S              3  0                                      CSW200
     D DigLen          S              3  0                                      CSW200
     D FirstBlank      S              3  0                                      CSW200
     D DigitErr        S              1                                         CSW200
                                                                                CSW200
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
                                                                                              CSW215
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
      ** Initialise
      *
     C                   EVAL      Idx       = 0
     C                   EVAL      WIx       = 0
     C                   EVAL      OkBn1     = 'Y'
     C                   EVAL      OkBn2     = 'Y'
     C                   EVAL      OkBn3     = 'Y'
     C                   EVAL      OkBn4     = 'Y'
     C                   EVAL      OkBn5     = 'Y'
     C                   EVAL      PBenttd   = *Blanks
     C                   EVAL      PType   = *Blanks
     C                   EVAL      PRtcd   = *Blanks
      *
      ** Main processing
      *
     C                   EXSR      VALIDATE
      *
      ** If no problems with the account entered, set up hidden field.
      *
     C                   IF        OKBn1 = 'Y'
      *
     C                   SELECT
     C                   WHEN      %Subst(PBenf1:1:1) = '/'  AND
     C                             %Subst(PBenf1:2:1) <> '/'
     C                   CLEAR                   PAcct
     C                   EVAL      PAcct = %SUBST(PBenf1:2)
      *
     C                   WHEN      %Subst(PBenf1:1:1) <> '/'
     C                   CLEAR                   PAcct
     C                   EVAL      PAcct = PBenf1
     C                   ENDSL
      *
     C                   EXSR      ValAcct
      *
     C                   If        PBenf2 = *blank And                                        221538
     C                             PBenf3 = *blank And                                        221538
     C                             PBenf4 = *blank And                                        221538
     C                             PBenf5 = *blank                                            221538
     C                   SELECT
     C                   WHEN      PType = 'IBAN'
     C                   EVAL      PBenTtd = 'I'
     C                   WHEN      PType = '*LEDGER'
     C                   EVAL      PBenttd = 'G'
     C                   WHEN      PType = '*NOSTRO'
     C                   EVAL      PBenttd = 'F'
     C                   WHEN      PType = '*RETAIL'
     C                   EVAL      PBenttd = 'R'
     C                   ENDSL
     C                   Endif                                                                221538
      *
     C                   ENDIF

      * Now validate that all data entered is OK for SWIFT

     C                   IF        PBenf1  <> *Blanks
     C                   CALLB     'FTVSFTX01'
     C                   PARM                    RetCdeIn         10
     C                   PARM      PBenf1        Swift_Text       50
     C                   IF        RetCdeIn = 'Error'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =  'RFV0364'
     C                   EVAL      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OkBn1     = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        PBenf2  <> *Blanks
     C                   CALLB     'FTVSFTX01'
     C                   PARM                    RetCdeIn         10
     C                   PARM      PBenf2        Swift_Text       50
     C                   IF        RetCdeIn = 'Error'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************EVAL      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   EVAL      FldNamXAr(Idx) =  'PBENF2'                   CAP084
     C                   EVAL      OkBn2     = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        PBenf3  <> *Blanks
     C                   CALLB     'FTVSFTX01'
     C                   PARM                    RetCdeIn         10
     C                   PARM      PBenf3        Swift_Text       50
     C                   IF        RetCdeIn = 'Error'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************EVAL      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   EVAL      FldNamXAr(Idx) =  'PBENF3'                   CAP084
     C                   EVAL      OkBn3     = 'N'
     C                   ENDIF
     C                   Endif

     C                   IF        PBenf4  <> *Blanks
     C                   CALLB     'FTVSFTX01'
     C                   PARM                    RetCdeIn         10
     C                   PARM      PBenf4        Swift_Text       50
     C                   IF        RetCdeIn = 'Error'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** EVAL      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   EVAL      FldNamXAr(Idx) =  'PBENF4'                   CAP084
     C                   EVAL      OkBn4     = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        PBenf5  <> *Blanks
     C                   CALLB     'FTVSFTX01'
     C                   PARM                    RetCdeIn         10
     C                   PARM      PBenf5        Swift_Text       50
     C                   IF        RetCdeIn = 'Error'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** EVAL      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   EVAL      FldNamXAr(Idx) =  'PBENF5'                   CAP084
     C                   EVAL      OkBn5     = 'N'
     C                   ENDIF
     C                   ENDIF
      *                                                                                       221538
     C                   If        PBENTTD = ' '                                              221538
     C                   Eval      PBENTTD = 'A'                                              221538
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND Idx = 0                                   CSW215
     C                   EXSR      VAL59F                                                     CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
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
      * VALIDATE - Validation selection                               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: Validate1, Validate2                                   *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE      BEGSR
      *
      ** Beneficiary is mandatory.
      *
     C                   IF        PBenf1 = *Blanks                             177662
     C*******************IF        PBenf1 = *Blanks AND PBenf2 = *BlankS AND    177662
     C*****************************PBenf3 = *Blanks AND PBenf4 = *BlankS AND    177662
     C*****************************PBenf5 = *Blanks                             177662
     C*******************IF        HPCCtBoc = 'CHQB            '                177662
     C*******************MOVE      'N'           OkBn2                          177662
     C*******************ELSE                                                   177662
     C                   MOVE      'N'           OkBn1
     C*******************ENDIF                                                  177662
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0107'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** If 'CHQB' entered in bnk op code then account identifier must
      ** not be entered therefore a slash must not be entered, otherwise,
      ** beneficiary must preceed with a /.
      * Is a CHQB ??
     C                   If        PBENF1  <> *Blanks AND
     C*****************************HPCCtBoc = 'CHQB            '                177662
     C                             HPCCtBoc = 'CHQB            ' AND            177662
     C                             %Subst(PBenf1:1:1) = '/'
     C                   EVAL      OkBn1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C*******************EVAL      MsgIdXAr(Idx) = 'RFV0374'                    177662
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0378'                    177662
     C                   EVAL      RetCodeIn = 'Error'
     C*******************Endif                                                  177662
     C                   ELSE                                                   177662
      *
      *
     C     '/'           SCAN      PBenF1        ScanPosn          2 0
     C                   IF        ScanPosn <> 1  AND
     C                             PcctTyp = 'BO'
     C                   IF        HPCCtBoc <> 'CHQB            '
     C                   EVAL      OkBn1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0109'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ELSE

      *
      ** Check to see if A/C with Institution contains
      ** a valid account
      *
     C                   CLEAR                   PAcct
     C                   EVAL      PAcct = PAcci35
     C                   EXSR      ValAcct
      *
     C                   SELECT
     C                   WHEN      PcctTyp = 'BO'
     C                   EXSR      Validate1
      *
     C                   WHEN      WValid = 'Y' AND Pccttyp = 'BI'
      *
      ** If 'CHQB' entered in bnk op code then account identifier must
      ** not be entered therefore a slash must not be entered, otherwise,
      ** beneficiary must preceed with a /.
      *
     C     '/'           SCAN      PBenF1        ScanPosn          2 0
     C                   IF        ScanPosn <> 1  AND
     C                             PcctTyp = 'BI'  AND
     C                             HPCCtBoc <> 'CHQB            '
     C                   EVAL      OkBn1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0109'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   EXSR      Validate1
     C                   ENDIF
      *
     C                   WHEN      WValid = 'N' AND Pccttyp = 'BI'
     C                   EXSR      Validate2
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF                                                  177662
      *                                                                         177662
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE1 - Main validation processing                        *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Validate1     BEGSR
      *
      **  First character must be '/'.
      **  If the entry is not one of the following, a
      **  warning message is issued: GL account, nostro code, retail account
      **  no., IBAN, customer number or customer shortname.
      *
      ** If bank op code is not equal to 'CHQB'
      *
     C                   IF        HPCCtBoc <> 'CHQB            '
     C                   EVAL      PAcct = %SUBST(PBenf1:2)
     C                   EXSR      ValAcct
      *
      ** At least one line must be entered after an account identifier
      *
     C                   IF        PBenf2 = *Blanks AND PBenf3 = *Blanks AND
     C                             PBenf4 = *Blanks AND PBenf5 = *Blanks
     C                   EVAL      OkBn2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C*****************  EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PBENF2'                    CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0112'
     C                   EVAL      RetCodeIn = 'Error'
      *                                                                                       221538
     C                   ELSE                                                                 221538
     C                   If        PBenf2 <> *blanks                                          221538
     C                   CallB     'AOACCTV1'                                                 221538
     C                   Parm                    PRtcd                                        221538
     C                   Parm                    PType                                        221538
     C                   Parm                    Pbenf2                                       221538
     C                   Parm                    DSSDY                                        221538
      *                                                                                       221538
     C                   If        PBenf3 = *blank And                                        221538
     C                             PBenf4 = *blank And                                        221538
     C                             PBenf5 = *blank                                            221538
     C                   If        PType = '*CUSTNO'                                          221538
     C                             OR PType = '*SHNAME'                                       221538
     C                   Eval      PBENTTD = 'C'                                              221538
     C                   If        PType = '*SHNAME'                                          221538
     C                   Eval      C@FMT = DSSDY                                              221538
     C                   Movel(P)  BBCUST        PBenf2                                       221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   Endif                                                                221538
     C                   ENDIF
      *
      ** If SWIFT 2000 present, clearing code //NZxxxxxx can be entered         CSW200
      ** where xxxxxx represents any six numbers.                               CSW200
      *                                                                         CSW200
     C                   IF        %SUBST(PBenf1:1:4) = '//NZ'  AND             CSW200
     C                             CSW200 = 'Y'                                 CSW200
      *                                                                         CSW200
     C                   Eval      SPos = 5                                     CSW200
     C                   Eval      EPos = 10                                    CSW200
     C                   Eval      DigLen = 6                                   CSW200
     C                   Eval      FirstBlank = 11                              CSW200
     C                   EXSR      ChkDigit                                     CSW200
      *                                                                         CSW200
     C                   IF        DigitErr = 'Y'                               CSW200
     C                   EVAL      OkBn2 = 'N'                                  CSW200
     C                   EVAL      Idx = Idx + 1                                CSW200
     C*******************EVAL      FldNamXAr(Idx) = DDSName               CSW200CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PBENF2'                    CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0384'                    CSW200
     C                   EVAL      RetCodeIn = 'Error'                          CSW200
     C                   ENDIF                                                  CSW200
      *                                                                         CSW200
     C                   ENDIF                                                  CSW200
      *                                                                         CSW200
      ****
      *
     C                   ELSE
      *
      ** If bnk op code contains 'CHQB' then an account line must not be entered
      *
     C     '/'           SCAN      PBenF1        ScanPosn          2 0
     C                   IF        ScanPosn = 1
     C                   EVAL      OkBn1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0109'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   EVAL      PAcct = %SUBST(PBenf1:1)
     C                   EXSR      ValAcct
     C                   IF        WValid = 'Y'
     C                   EVAL      OkBn1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0370'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Ensure that the second line does not contain /
      *
     C     '/'           SCAN      PBenf2        ScanPos2          2 0
      *
     C                   IF        ScanPos2 <> 0
      *                                                                                       CSW215
      ** Allow 1/,2/,3/  on the second line if CSW215 is 'Y'                                  CSW215
      *                                                                                       CSW215
     C                   IF        %SUBST(PBenf2:1:2) <> '1/' AND                             CSW215
     C                             %SUBST(PBenf2:1:2) <> '2/' AND                             CSW215
     C                             %SUBST(PBenf2:1:2) <> '3/'                                 CSW215
     C                             OR CSW215 = 'N'                                            CSW215
      *                                                                                       CSW215
     C                   EVAL      Idx             =   Idx+1
     C                   EVAL      RetCodeIn       =   'Error'
     C                   EVAL      MsgIdXAr(Idx)   =  'RFV0352'
     C                   EVAL      FldNamXAr(Idx)  =  'PBenf2'
     C                   EVAL      OkBn2 = 'N'
     C                   ENDIF                                                                CSW215
     C                   Endif
      *
      ** Ensure that the third line does not contain /
      *
     C     '/'           SCAN      PBenf3        ScanPos3          2 0
      *
     C                   IF        ScanPos3 <> 0
      *                                                                                       CSW215
      ** Allow 1/,2/,3/  on the second line if CSW215 is 'Y'                                  CSW215
      *                                                                                       CSW215
     C                   IF        %SUBST(PBenf3:1:2) <> '1/' AND                             CSW215
     C                             %SUBST(PBenf3:1:2) <> '2/' AND                             CSW215
     C                             %SUBST(PBenf3:1:2) <> '3/'                                 CSW215
     C                             OR CSW215 = 'N'                                            CSW215
      *                                                                                       CSW215
     C                   EVAL      Idx             =   Idx+1
     C                   EVAL      RetCodeIn       =   'Error'
     C                   EVAL      MsgIdXAr(Idx)   =  'RFV0353'
     C                   EVAL      FldNamXAr(Idx)  =  'PBenf3'
     C                   EVAL      OkBn3 = 'N'
     C                   ENDIF                                                                CSW215
     C                   ENDIF
      *
      ** Ensure that the forth line does not contain /
      *
     C     '/'           SCAN      PBenf4        ScanPos4          2 0
      *
     C                   IF        ScanPos4 <> 0
      *                                                                                       CSW215
      ** Allow 1/,2/,3/  on the second line if CSW215 is 'Y'                                  CSW215
      *                                                                                       CSW215
     C                   IF        %SUBST(PBenf4:1:2) <> '1/' AND                             CSW215
     C                             %SUBST(PBenf4:1:2) <> '2/' AND                             CSW215
     C                             %SUBST(PBenf4:1:2) <> '3/'                                 CSW215
     C                             OR CSW215 = 'N'                                            CSW215
      *                                                                                       CSW215
     C                   EVAL      Idx             =   Idx+1
     C                   EVAL      RetCodeIn       =   'Error'
     C                   EVAL      MsgIdXAr(Idx)   =  'RFV0354'
     C                   EVAL      FldNamXAr(Idx)  =  'PBenf4'
     C                   EVAL      OkBn4 = 'N'
     C                   ENDIF                                                                CSW215
     C                   ENDIF
      *
      ** Ensure that the fifth line does not contain /
      *
     C     '/'           SCAN      PBenf5        ScanPos5          2 0
      *
     C                   IF        ScanPos5 <> 0
      *                                                                                       CSW215
      ** Allow 1/,2/,3/  on the second line if CSW215 is 'Y'                                  CSW215
      *                                                                                       CSW215
     C                   IF        %SUBST(PBenf5:1:2) <> '1/' AND                             CSW215
     C                             %SUBST(PBenf5:1:2) <> '2/' AND                             CSW215
     C                             %SUBST(PBenf5:1:2) <> '3/'                                 CSW215
     C                             OR CSW215 = 'N'                                            CSW215
      *                                                                                       CSW215
     C                   EVAL      Idx             =   Idx+1
     C                   EVAL      RetCodeIn       =   'Error'
     C                   EVAL      MsgIdXAr(Idx)   =  'RFV0355'
     C                   EVAL      FldNamXAr(Idx)  =  'PBenf5'
     C                   EVAL      OkBn5 = 'N'
     C                   ENDIF                                                                CSW215
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************         CSW200
      *                                                               *         CSW200
      * ChkDigit : Check that number of digits are correct            *         CSW200
      *                                                               *         CSW200
      * Called by: Validate1                                          *         CSW200
      *                                                               *         CSW200
      * Calls: None                                                   *         CSW200
      *                                                               *         CSW200
      *****************************************************************         CSW200
     C     ChkDigit      BEGSR                                                  CSW200
                                                                                CSW200
     C                   EVAL      DigitErr = 'N'                               CSW200
     C                   MOVEA     PBenF1        StrArr(1)                      CSW200
                                                                                CSW200
      * Check that the first blank space is correct                             CSW200
     C                   IF        StrArr(FirstBlank) <> *Blank                 CSW200
     C                   EVAL      DigitErr = 'Y'                               CSW200
     C                   ENDIF                                                  CSW200
                                                                                CSW200
     C                   DOW       SPos <= EPos                                 CSW200
     C     StrArr(SPos)  LOOKUP    ArrDig(1)                              99    CSW200
     C                   IF        *In99 = *Off                                 CSW200
     C                   EVAL      DigitErr = 'Y'                               CSW200
     C                   LEAVE                                                  CSW200
     C                   ENDIF                                                  CSW200
     C                   EVAL      SPos = SPos + 1                              CSW200
     C                   ENDDO                                                  CSW200
                                                                                CSW200
      * Now ensure that the remaining characters are blank                      CSW200
     C                   EVAL      EPos = EPos + 1                              CSW200
     C                   IF        EPos < 5                                     CSW200
     C                   EVAL      EPos = 5                                     CSW200
     C                   ENDIF                                                  CSW200
                                                                                CSW200
     C                   DOW       EPos <= 35                                   CSW200
     C                   IF        StrArr(EPos) <> *Blank                       CSW200
     C                   EVAL      DigitErr = 'Y'                               CSW200
     C                   LEAVE                                                  CSW200
     C                   ENDIF                                                  CSW200
     C                   EVAL      EPos = EPos + 1                              CSW200
     C                   ENDDO                                                  CSW200
                                                                                CSW200
     C                   ENDSR                                                  CSW200
                                                                                CSW200
      *****************************************************************
      *                                                               *
      * VALIDATE2 - Main validation processing                        *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Validate2     BEGSR
      *
      ** If account with institution doesn't contain a valid account
      ** and transfer type is 'BI' and GOPFlag is not 'Y' then the ben
      ** field must have a valid account
      *
     C                   EVAL      PAcct = PBenf1
     C                   EXSR      ValAcct
      *
     C                   IF        PGopFlg <> 'Y'
     C                   IF        WValid <> 'Y'    and
     C                             HPCCtBoc <> 'CHQB            '
     C                   EVAL      OkBn1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0111'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C**********         IF        %Subst(PBenf1:1:1) = '/'                                 BUG25235
     C**********         EVAL      PBenf1 = %Subst(PBenf1:2)                                BUG25235
     C**********         ENDIF                                                              BUG25235
     C                   ENDIF
      *
     C                   ELSE                                                               BUG25235
      *                                                                                     BUG25235
      ** Otherwise, if GOPFlag is set to 'Y', beneficiary must be a ful                     BUG25235
      ** having '/'.                                                                        BUG25235
      *                                                                                     BUG25235
     C                   IF        %SUBST(PBenf1:1:1) <> '/'                                BUG25235
     C                             AND  HPCCtBoc <> 'CHQB            '                      BUG25235
     C                   EVAL      OkBn1 = 'N'                                              BUG25235
     C                   EVAL      Idx = Idx + 1                                            BUG25235
     C                   EVAL      FldNamXAr(Idx) = DDSName                                 BUG25235
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0109'                                BUG25235
     C                   EVAL      RetCodeIn = 'Error'                                      BUG25235
     C                   ENDIF                                                              BUG25235
      *                                                                                     BUG25235
     C                   IF        %SUBST(PBenf1:1:1) = '/'                                 BUG25235
     C                             AND  PBenf2 = *BLANKS                                    BUG25235
     C                   EVAL      OkBn1 = 'N'                                              BUG25235
     C                   EVAL      Idx = Idx + 1                                            BUG25235
     C                   EVAL      FldNamXAr(Idx) = DDSName                                 BUG25235
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0300'                                BUG25235
     C                   EVAL      RetCodeIn = 'Error'                                      BUG25235
     C                   ENDIF                                                              BUG25235
      *                                                                                     BUG25235
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAcct  - Checks for valid account                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAcct       BEGSR
      *
     C                   EVAL      PType = *Blanks
     C                   EVAL      wvalid = 'Y'
      *
     C                   IF        CFT004 = 'Y'
      *
      ** Validate Account
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       PRtcd
     C                   PARM                    PAcct            35
     C     Accnt         PARM      Accnt         DSSDY
      *
     C                   IF        PRtcd = *Blanks
     C                   EVAL      PType = 'IBAN'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PType <> 'IBAN'
      *
      ** Validate Account
      *
     C                   CALLB     'AOACCTV1'
     C                   PARM      *Blanks       PRtcd             7            B:Return code
     C                   PARM                    PType             7            I:A/c ID
     C                   PARM                    PAcct            35            I:A/c Currency
     C                   PARM      *Blanks       DSSDY                          I:A/c code
     C                   ENDIF
      *
      ** Invalid Account
      *
     C                   IF        PType <> 'IBAN' and
     C                             PType <> '*NOSTRO'  and
     C                             PType <> '*RETAIL'  and
     C                             PType <> '*LEDGER' or
     C                             PRtcd <> *Blanks
     C                   EVAL      Wvalid = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
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
     C                   EVAL      PNost = *BLANKS                                            CSW215
     C                                                                                        CSW215
      ** Get Country of location                                                              CSW215
      ** for Outgoing must be the Destination, for Incoming must be the Sender                CSW215
                                                                                              CSW215
     C                   IF        PCCTTYP = 'BI'                                             CSW215
     C                   EVAL      ParmStr = HPSNDCOR                                         CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      ParmStr = HPCCTDST                                         CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   CALLB     'AOACCTV1'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      *BLANKS       PType                                        CSW215
     C                   PARM                    ParmStr                                      CSW215
     C                   PARM      *BLANKS       DSSDY                                        CSW215
      *                                                                                       CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
                                                                                              CSW215
     C                   SELECT                                                               CSW215
     C                   WHEN      PType = '*RETAIL'                                          CSW215
     C                             Or PType = '*LEDGER'                                       CSW215
     C                             Or PType = '*NOSTRO'                                       CSW215
                                                                                              CSW215
     C                   IF        PType = '*NOSTRO'                                          CSW215
     C                   EVAL      SDNOST = DSSDY                                             CSW215
     C                   MOVEL     A7CUST        PKey1                                        CSW215
     C                   EVAL      PNost = %SUBST(HPCCTDST:4:2)                               CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      ACCNT = DSSDY                                              CSW215
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
     C                   WHEN      PType = '*CUSTNO'                                          CSW215
     C                             Or PType = '*SHNAME'                                       CSW215
     C                   EVAL      C@FMT = DSSDY                                              CSW215
     C                   EVAL      PCnty = BBCOLC                                             CSW215
                                                                                              CSW215
     C                   WHEN      PType = '*SWIFT'                                           CSW215
     C                   EVAL      PCnty = %Subst(ParmStr:5:2)                                CSW215
                                                                                              CSW215
     C                   ENDSL                                                                CSW215
                                                                                              CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   CALL      'MG001001'                                                 CSW215
      **Return Code                                                                           CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
      **Validation Type                                                                       CSW215
     C                   PARM      'TRAN'        PValTyp                                      CSW215
      **5X35 lines to be checked                                                              CSW215
     C                   PARM                    PBenf1                                       CSW215
     C                   PARM                    PBenf2                                       CSW215
     C                   PARM                    PBenf3                                       CSW215
     C                   PARM                    PBenf4                                       CSW215
     C                   PARM                    PBenf5                                       CSW215
      **Network                                                                               CSW215
     C                   PARM      'SWIFT'       PNwrk                                        CSW215
      **Message Type                                                                          CSW215
     C                   PARM      '102'         PMsgTp                                       CSW215
      **Message tag                                                                           CSW215
     C                   PARM      ':59F:'       PMsgTg                                       CSW215
      ** Branch Code                                                                          CSW215
     C                   PARM      HPBRCA        PBrch                                        CSW215
      ** Country of location                                                                  CSW215
     C                   PARM                    PCnty                                        CSW215
      ** Currency Code                                                                        CSW215
     C                   PARM      HPCCTCCY      PCurr                                        CSW215
      ** Nostro                                                                               CSW215
     C                   PARM                    PNost                                        CSW215
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
     C                   EVAL      FldNamXAr(Idx) = 'PBenf1'                                  CSW215
     C                   EVAL      OkBn1 = 'N'                                                CSW215
     C                   EVAL      OkBn2 = 'N'                                                CSW215
     C                   EVAL      OkBn3 = 'N'                                                CSW215
     C                   EVAL      OkBn4 = 'N'                                                CSW215
     C                   EVAL      OkBn5 = 'N'                                                CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   IF        PErrTyp = 'W'                                              CSW215
     C                   EVAL      WIx = WIx + 1                                              CSW215
     C                   EVAL      OkBn1     = 'W'                                            CSW215
     C                   EVAL      OkBn2     = 'W'                                            CSW215
     C                   EVAL      OkBn3     = 'W'                                            CSW215
     C                   EVAL      OkBn4     = 'W'                                            CSW215
     C                   EVAL      OkBn5    = 'W'                                             CSW215
     C                   EVAL      WFldNmXAr(WIx) = 'PBenf1'                                  CSW215
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
      *
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
                                                                                CSW200
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

     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
                                                                                CSW200
      ** /CSW200 change/ Compile-time array ArrDig added                        CSW200
**  CPY@
(c) Finastra International Limited 2001
**  CTDATA ArrDig
0123456789
