     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Details amend checking')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADAMD - Account Amend Checking                           *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended account against those currently on file.  *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD043086           Date 13Dec16               *      
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22768           Date 19Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27484           Date 21Apr10               *
      *                 CRE015             Date 18Dec09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP086             Date 08Jun05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Feb99               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 29Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 08Nov99               *
      *                 CAP035  *CREATE    Date 03May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD043086 - IBAN should be non-amendable but gets cleared by  *
      *           JMS GLAMAD API call when sending blanks.            *      
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22768 - Retain values on screen when validation fails     *
      *  BUG27484 - Error validation for period and penalty details   *
      *             is not working when AMAD is entered via SOAP      *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
      *  178695 - Protect Amend of Portfolio Reference field          *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * New Account in Screen Format
     D AccnNwMast    E DS                  EXTNAME(GLAMADPD)
     D AccnNwDebi    E DS                  EXTNAME(GLAMDIPD)
     D AccnNwCred    E DS                  EXTNAME(GLAMCIPD)
     D AccnNwComm    E DS                  EXTNAME(GLAMCOPD)
     D AccnNwOthe    E DS                  EXTNAME(GLAMODPD)
     D AccnNwPena    E DS                  EXTNAME(GLAMPPPD)                                  CRE015
     D  ScnPenaRows           33   4166                                                       CRE015
 
      * (Current) Account in Screen Format - Master Details
     D CurMasScn     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Debit Details
     D CurDebScn     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Credit Details
     D CurCreScn     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Commision Details
     D CurComScn     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Other Details
     D CurOthScn     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Period and Penalty Definition File               CRE015
     D CurPenScn     E DS                  EXTNAME(GLAMPPPD) PREFIX(@)                        CRE015
     D  CurPenScn2            33   4166                                                       CRE015
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
                                                                                178695
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    178695
      ** EXTERNAL DS FOR MODULE ID DETAILS                                      178695
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CRE015
      ** Array for screen definition                                                          CRE015
                                                                                              CRE015
     D GLAMPR        E DS                  EXTNAME(GLAMPRPD)                                  CRE015
     D ArrScnBuf       S                   DIM(26) LIKE(GLAMPR)                               CRE015
     D GLAM2PR       E DS                  EXTNAME(GLAMPRPD) PREFIX(PR:2)                     CRE015
     D CurScnBuf2      S                   DIM(26) LIKE(GLAM2PR)                              CRE015
                                                                                              CRE015
      ** Array for screen OK flags                                                            CRE015
                                                                                              CRE015
     D GLEAMPR       E DS                  EXTNAME(GLEAMPRPD)                                 CRE015
     D ArrOkBuf        S                   DIM(26) LIKE(GLEAMPR)                              CRE015
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKAcMast      E DS                  EXTNAME(GLEAMADPD)
     D OKAcDebi      E DS                  EXTNAME(GLEAMDIPD)
     D OKAcCred      E DS                  EXTNAME(GLEAMCIPD)
     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
     D OKAcOthe      E DS                  EXTNAME(GLEAMODPD)
     D OKAcPena      E DS                  EXTNAME(GLEAMPPPD) PREFIX(@)                       CRE015
     D  OKPenaRows             6    941                                                       CRE015
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D X               S              2  0                                                    CRE015
     D Y               S              2  0                                                    CRE015
     D MATCH           S               N                                                      CRE015
     D ZDAYNO          S              5  0                                                    CRE015
     D ZDATE           S              6  0                                                    CRE015
     D ZERR            S              7A                                                      CRE015
     D ZDATFM          S              1A                                                      CRE015
     D BVDAYN          S              5  0                                                    CRE015
     D RWBVDAT         S              5  0                                                    CRE015
     D A#VDAT          S              5  0                                                    CRE015
     D ZFREQ           S              1A                                                      CRE015
     D ZMDAY           S              2  0                                                    CRE015
     D ZCCY            S              3A                                                      CRE015
     D ZLOC            S              3A                                                      CRE015
     D ZDIREC          S              1A                                                      CRE015
     D ZRTRN           S              7A                                                      CRE015
 
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
      *
      **  Compare fields with amended values.
      *
     C                   EXSR      COMPFLDS
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current Account     *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
      *
      **   Screen 1, Account Master Details
      *
     C*-----------------------------------------*                                           MD043086
     C* IBAN                                    *                                           MD043086
     C*-----------------------------------------*                                           MD043086
     C** The IBAN field is not amendable                                                    MD043086
     C*                                                                                     MD043086
     C     DDIBAN        IFNE      @DDIBAN                                                  MD043086
     C                   ADD       1             Idx                                        MD043086
     C                   EVAL      FldNameArr(Idx) = 'DDIBAN'                               MD043086
     C                   EVAL      MsgIDArr(Idx)   = 'RE72034'                              MD043086
     C                   EVAL      DDIBANOK        = 'N'                                    MD043086
     C                   ENDIF                                                              MD043086
     C*                                                                                     MD043086
     C*-----------------------------------------*
     C* Number of Copies                        *
     C*-----------------------------------------*
     C** The number of Copies is not allowed if Frequency is not 'E'
     C*
     C     DDENOC        IFNE      *BLANKS
     C     DDSTFQ        ANDNE     'E'
     C*
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDENOC'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71110'
     C                   EVAL      DDENOCOK        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Profit Centre                           *
     C*-----------------------------------------*
     C** Only validate this field if Profit Centre ICD flag on.
     C*
     C     BKPRCU        IFEQ      'Y'
     C*
     C** This field is not amendable unless 'Profit Centre Amendable'
     C** ICD flag is on.
     C*
     C     DDPRFC        IFNE      @DDPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71120'
     C                   EVAL      DDPRFCOK        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
      *                                                                         178695
      *-----------------------------------------*                               178695
      * Portfolio Reference                     *                               178695
      *-----------------------------------------*                               178695
      ** Only validate this field if Private Banking Module is Active           178695
      *                                                                         178695
     C     BGN4ST        IFEQ      'Y'                                          178695
      *                                                                         178695
      ** Portfolio Reference could not be amendable                             178695
      *                                                                         178695
     C     DDPTFR        IFNE      @DDPTFR                                      178695
     C                   ADD       1             Idx                            178695
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'                   178695
     C                   EVAL      MsgIDArr(Idx)   = 'RE71024'                  178695
     C                   EVAL      DDPTFROK        = 'N'                        178695
     C                   ENDIF                                                  178695
      *                                                                         178695
     C                   ENDIF                                                  178695
      *
      **   Screen 2, Debit Interest Overdraft details
     C*
     C*-----------------------------------------*
     C* This Change Value Date                  *
     C*-----------------------------------------*
     C**  This field is not amendable if no interest details amended
     C*
     C     DDDRIB        IFEQ      @DDDRIB
     C     DDDRIS        ANDEQ     @DDDRIS
     C     DDDICT        ANDEQ     @DDDICT
     C     DDDSIG        ANDEQ     @DDDSIG
     C     DDDCST        ANDEQ     @DDDCST
      *
     C     DDDRCD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDRCD'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71209'
     C                   EVAL      DDDRCDOK        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Rev. Date (Line or Rate)                *
     C*-----------------------------------------*
     C**  This field is not amendable if Interest Calulation has
     C**  been entered, or not entered and additional overdraft rate
     C**  and overdraft line are blanks.
     C*
     C     DDITRD        IFNE      *BLANKS
     C*
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDITRD'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71874'
     C                   EVAL      DDITRDOK        = 'N'
     C                   ENDIF
     C*
     C     DDDICT        IFEQ      *BLANKS
     C     DDDCST        ANDEQ     *BLANKS
     C     DDAODR        ANDEQ     *BLANKS
     C     DDODLN        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDITRD'
     C                   EVAL      MsgIDArr(Idx)   = 'RE72011'
     C                   EVAL      DDITRDOK        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Additional Overdraft Rate               *
     C*-----------------------------------------*
     C** This field can't be amended when Interest Calculation Types
     C** have been entered.
     C*
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
     C*
     C     DDAODR        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAODR'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71874'
     C                   EVAL      DDAODROK        = 'N'
     C                   END
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Additional Overdraft Rate Sign          *
     C*-----------------------------------------*
     C** This field can't be amended when Interest Calculation Types
     C** have been entered.
     C*
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
     C*
     C     DDAODRX       IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAODRX'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71874'
     C                   EVAL      DDAODRXOK       = 'N'
     C                   END
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Change Value Date, Overdraft Rate       *
     C*-----------------------------------------*
     C** This field can't be amended when Interest Calculation Types
     C** have been entered.
     C*
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
     C*
     C     DDORTC        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDORTC'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71874'
     C                   EVAL      DDORTCOK        = 'N'
     C                   END
     C                   ENDIF
      *
      **   Screen 3, Credit Interest & Charges details
      *
     C*-----------------------------------------*
     C* This Change Value Date                  *
     C*-----------------------------------------*
     C**  This field is not amendable if no interest details amended
     C*
     C     DDCRIB        IFEQ      @DDCRIB
     C     DDCRIS        ANDEQ     @DDCRIS
     C     DDCICT        ANDEQ     @DDCICT
     C     DDCSIG        ANDEQ     @DDCSIG
     C     DDCCST        ANDEQ     @DDCCST
      *
     C     DDCRCD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCRCD'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71309'
     C                   EVAL      DDCRCDOK        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Alt. A/c Charges Acc.                   *
     C*-----------------------------------------*
     C**  This field is not amendable if no Charge calculation Types.
     C*
     C     DDCHCP        IFNE      *BLANKS
      *
     C     DDCHGT        IFEQ      *BLANKS
     C     DDCHST        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCHCP'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71327'
     C                   EVAL      DDCHCPOK        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Transaction Charges Override            *
     C*-----------------------------------------*
     C**  This field is not amendable if no Charge calculation Types.
     C*
     C     DDTCHO        IFNE      *BLANKS
      *
     C     DDCHGT        IFEQ      *BLANKS
     C     DDCHST        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCHO'
     C                   EVAL      MsgIDArr(Idx)   = 'RE71329'
     C                   EVAL      DDTCHOOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      **   Screen 4, Commissions & Override details doesn't have any
      **   non-amendable input fields
      *
      *
      **   Screen 5, Account Other Details doesn't have any
      **   non-amendable input fields
      *
     C*
                                                                                              CRE015
      ** Period and Penatly Details Tab                                                       CRE015
      ** Move screen row fields to array                                                      CRE015
                                                                                              CRE015
     C                   MOVEA     ScnPenaRows   ArrScnBuf                                    CRE015
     C                   MOVEA     CurPenScn2    CurScnBuf2                                   CRE015
                                                                                              CRE015
      ** Move screen row field OK flags to array                                              CRE015
                                                                                              CRE015
     C                   MOVEA     OKPenaRows    ArrOkBuf                                     CRE015
                                                                                              CRE015
     C                   EVAL      X = 1                                                      CRE015
     C                   EVAL      Y = 1                                                      CRE015
     C                   DOW       X <= 26 AND Y <= 26                                        CRE015
                                                                                              CRE015
     C                   IF        ArrScnBuf(X) <> *BLANKS                                    CRE015
                                                                                              CRE015
      ** Find the matching event id between the new and current data                          CRE015
                                                                                              CRE015
     C                   EVAL      MATCH = *OFF                                               CRE015
     C                   DOU       MATCH = *ON                                                CRE015
     C                   IF        %SUBST(ArrScnBuf(X):1:1) <> *BLANKS                        CRE015
     C                             AND %SUBST(CurScnBuf2(Y):1:1) <> *BLANKS                   CRE015
                                                                                              CRE015
     C                   IF        %SUBST(ArrScnBuf(X):1:1) =                                 CRE015
     C                             %SUBST(CurScnBuf2(Y):1:1)                                  CRE015
     C                   EVAL      MATCH = *ON                                                CRE015
     C                   ELSE                                                                 CRE015
     C                   IF        %SUBST(ArrScnBuf(X):1:1) <                                 CRE015
     C                             %SUBST(CurScnBuf2(Y):1:1)                                  CRE015
     C                   EVAL      X = X+1                                                    CRE015
     C                   ELSE                                                                 CRE015
     C                   EVAL      Y = Y+1                                                    CRE015
     C                   ENDIF                                                                CRE015
     C                   IF        X > 26 OR Y > 26                                           CRE015
     C                   LEAVE                                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ELSE                                                                 CRE015
     C                   LEAVE                                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Compare fields if match is found                                                     CRE015
                                                                                              CRE015
     C                   IF        MATCH = *ON                                                CRE015
     C                   EVAL      GLAMPR  = ArrScnBuf(X)                                     CRE015
     C                   EVAL      GLAM2PR = CurScnBuf2(Y)                                    CRE015
     C                   EVAL      GLEAMPR = ArrOkBuf(X)                                      CRE015
                                                                                              CRE015
      ** Validate non-amendable fields for Penalty and Period Details                         CRE015
                                                                                              CRE015
     C                   IF        RWVDAT <> PRVDAT                                         BUG27484
     C                             AND RWEVNT = 'A'                                         BUG27484
     C                   ADD       1             Idx                                        BUG27484
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT' + %CHAR(X)                    BUG27484
     C                   EVAL      MsgIDArr(Idx)   = 'TNN0456'                              BUG27484
     C                   EVAL      RWVDATOK = 'N'                                           BUG27484
     C                   IF        ResetErrs = 'Y'                                          BUG27484
     C                   MOVEL     PRVDAT        RWVDAT                                     BUG27484
     C                   ENDIF                                                              BUG27484
     C                   ENDIF                                                              BUG27484
                                                                                            BUG27484
     C                   IF        RWDNIR <> PRDNIR                                           CRE015
     C                   ADD       1             Idx                                          CRE015
     C                   EVAL      FldNameArr(Idx) = 'DDDNIR' + %CHAR(X)                      CRE015
     C                   EVAL      MsgIDArr(Idx)   = 'TNN0375'                                CRE015
     C                   EVAL      RWDNIROK = 'N'                                             CRE015
     C                   IF        ResetErrs = 'Y'                                            CRE015
     C                   MOVEL     PRDNIR        RWDNIR                                       CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        RWCNIR <> PRCNIR                                           CRE015
     C                   ADD       1             Idx                                          CRE015
     C                   EVAL      FldNameArr(Idx) = 'DDCNIR' + %CHAR(X)                      CRE015
     C                   EVAL      MsgIDArr(Idx)   = 'TNN0376'                                CRE015
     C                   EVAL      RWCNIROK        = 'N'                                      CRE015
     C                   IF        ResetErrs = 'Y'                                            CRE015
     C                   MOVEL     PRCNIR        RWCNIR                                       CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        PRDNIR <> 'P'                                              CRE015
     C                             AND PRCNIR <> 'P'                                          CRE015
     C                   MOVEL     PRBALN        RWBALN                                       CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Get next available date (i.e. first working day of                                   CRE015
      ** term)                                                                                CRE015
                                                                                              CRE015
     C                   Z-ADD     0             A#VDAT                                       CRE015
     C                   IF        PRVDAT <> *BLANKS                                          CRE015
     C                   MOVE      PRVDAT        ZDATE                                        CRE015
     C                   CALL      'ZDATE1'                                                   CRE015
     C                   PARM                    ZERR                                         CRE015
     C                   PARM                    ZDATE                                        CRE015
     C                   PARM      BJDFIN        ZDATFM                                       CRE015
     C                   PARM                    ZDAYNO                                       CRE015
     C                   MOVE      ZDAYNO        A#VDAT                                       CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        A#VDAT > 0                                                 CRE015
     C                   EVAL      ZDAYNO = A#VDAT - 1                                        CRE015
     C                   CALL      'ZFRQB5'                                                   CRE015
     C                   PARM      'D'           ZFREQ                                        CRE015
     C                   PARM                    ZDAYNO                                       CRE015
     C                   PARM      0             ZMDAY                                        CRE015
     C                   PARM      BJLCCY        ZCCY                                         CRE015
     C                   PARM      BJSLCD        ZLOC                                         CRE015
     C                   PARM      'F'           ZDIREC                                       CRE015
     C                   PARM      *BLANKS       ZRTRN                                        CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Change to calc basis only allowed on first working day of new term                   CRE015
      ** for periodic fixing                                                                  CRE015
                                                                                              CRE015
     C                   IF        @DD0TPRD = 'T' AND                                         CRE015
     C                             ZDAYNO <> BJRDNB AND                                       CRE015
     C                             X = 1                                                      CRE015
     C                                                                                        CRE015
     C                   IF        RWDRIC <> PRDRIC                                           CRE015
     C                   ADD       1             Idx                                          CRE015
     C                   EVAL      FldNameArr(Idx) = 'DDPDIC' + %CHAR(X)                      CRE015
     C                   EVAL      MsgIDArr(Idx)   = 'TNN0377'                                CRE015
     C                   EVAL      RWDRICOK        = 'N'                                      CRE015
     C                   IF        ResetErrs = 'Y'                                            CRE015
     C                   MOVEL     PRDRIC        RWDRIC                                       CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        RWCRIC <> PRCRIC                                           CRE015
     C                   ADD       1             Idx                                          CRE015
     C                   EVAL      FldNameArr(Idx) = 'DDPCIC' + %CHAR(X)                      CRE015
     C                   EVAL      MsgIDArr(Idx)   = 'TNN0378'                                CRE015
     C                   EVAL      RWCRICOK        = 'N'                                      CRE015
     C                   IF        ResetErrs = 'Y'                                            CRE015
     C                   MOVEL     PRCRIC        RWCRIC                                       CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   EVAL      ArrScnBuf(X) = GLAMPR                                      CRE015
     C                   EVAL      ArrOkBuf(X) = GLEAMPR                                      CRE015
                                                                                              CRE015
     C                   EVAL      X = X+1                                                    CRE015
     C                   EVAL      Y = Y+1                                                    CRE015
     C                   ELSE                                                                 CRE015
     C                   LEAVE                                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ELSE                                                                 CRE015
     C                   LEAVE                                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Update screen fields and OK flags                                                    CRE015
                                                                                              CRE015
     C                   MOVEA     ArrScnBuf     ScnPenaRows                                  CRE015
     C                   MOVEA     ArrOkBuf      OKPenaRows                                   CRE015
                                                                                              CRE015
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      * SCREEN 1
      *
      * IBAN                                                                                MD043086
     C     DDIBANOK      IFEQ      'N'                                                      MD043086
     C                   MOVEL     @DDIBAN       DDIBAN                                     MD043086
     C                   END                                                                MD043086
     C*                                                                                     MD043086
      * Number of Copies
     C     DDENOCOK      IFEQ      'N'
     C                   MOVEL     @DDENOC       DDENOC
     C                   END
     C*
     C* Profit Centre
     C     DDPRFCOK      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
     C*                                                                         178695
     C* Portfolio Reference                                                     178695
     C     DDPTFROK      IFEQ      'N'                                          178695
     C                   MOVEL     @DDPTFR       DDPTFR                         178695
     C                   END                                                    178695
      * SCREEN 2
     C*
     C* This Change Value Date
     C     DDDRCDOK      IFEQ      'N'
      *                                                                                     BUG22768
     C     @DDDRCD       IFNE      *BLANKS                                                  BUG22768
     C                   MOVEL     @DDDRCD       DDDRCD
     C                   ENDIF                                                              BUG22768
      *                                                                                     BUG22768
     C                   END
     C*
     C* O/D Secured
     C     DDODSCOK      IFEQ      'N'
     C                   MOVEL     @DDODSC       DDODSC
     C                   END
     C*
     C* Reversal Date Line/Rate
     C     DDITRDOK      IFEQ      'N'
     C                   MOVEL     @DDITRD       DDITRD
     C                   END
     C*
     C* Additional Overdraft Rate
     C     DDAODROK      IFEQ      'N'
     C                   MOVEL     @DDAODR       DDAODR
     C                   END
     C*
     C* Additional Overdraft Rate Sign
     C     DDAODRXOK     IFEQ      'N'
     C                   MOVEL     @DDAODRX      DDAODRX
     C                   END
     C*
     C* Change Value Date, Overdraft Rate
     C     DDORTCOK      IFEQ      'N'
     C                   MOVEL     @DDORTC       DDORTC
     C                   END
      * SCREEN 3
     C*
     C* This Change Vlue Date
     C     DDCRCDOK      IFEQ      'N'
      *                                                                                     BUG22768
     C     @DDCRCD       IFNE      *BLANKS                                                  BUG22768
     C                   MOVEL     @DDCRCD       DDCRCD
     C                   ENDIF                                                              BUG22768
      *                                                                                     BUG22768
     C                   END
     C*
     C* Alt. Account Charges Account
     C     DDCHCPOK      IFEQ      'N'
     C                   MOVEL     @DDCHCP       DDCHCP
     C                   END
     C*
     C* Transaction Charges Override
     C     DDTCHOOK      IFEQ      'N'
     C                   MOVEL     @DDTCHO       DDTCHO
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Account in Screen Format
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    AccnNwMast
     C                   PARM                    AccnNwDebi
     C                   PARM                    AccnNwCred
     C                   PARM                    AccnNwComm
     C                   PARM                    AccnNwOthe
     C                   PARM                    AccnNwPena                                   CRE015
      *
      * Current Account in Screen Format
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    CurMasScn
     C                   PARM                    CurDebScn
     C                   PARM                    CurCreScn
     C                   PARM                    CurComScn
     C                   PARM                    CurOthScn
     C                   PARM                    CurPenScn                                    CRE015
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKAcMast
     C                   PARM                    OKAcDebi
     C                   PARM                    OKAcCred
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthe
     C                   PARM                    OKAcPena                                     CRE015
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADAMD'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                         178695
      ** ACCESS MODULE ID DETAILS                                               178695
      *                                                                         178695
     C                   CALLB     'AOMMODR0'                                   178695
     C                   PARM      *BLANKS       @RTCD                          178695
     C                   PARM      '*FIRST '     @OPTN                          178695
     C     SDMMOD        PARM      SDMMOD        DSFDY                          178695
      *                                                                         178695
      * DATABASE ERROR                                                          178695
      *                                                                         178695
     C     @RTCD         IFNE      *BLANK                                       178695
     C                   MOVEL     @OPTN         DBKEY                          178695
     C                   MOVEL     'SDMMODPD'    DBFILE                         178695
     C                   MOVEL     '902'         DBASE                          178695
     C                   EXSR      *PSSR                                        178695
     C                   END                                                    178695
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
