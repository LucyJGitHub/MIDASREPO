     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE header validate and update')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITHVU - General Ledger JE Header validate and update      *
      *                                                               *
      *                                                               *
      *  Function: This Program Validates GL Function name            *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD045854           Date 25May17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 AR1092517          Date 14Mar13               *
      *                 AR1078953          Date 18Jan13               *
      *                 CLE134             Date 01Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 249585             Date 16May12               *
      *                 260029             Date 29Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15754           Date 30Jan08               *
      *                 249177             Date 25Oct07               *
      *                 247132             Date 23Jul07               *
      *                 246518             Date 13Jun07               *
      *                 BUG13869A          Date 10May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243860             Date 20Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237512 (Reopen)    Date 22May06               *
      *                 240063             Date 06Jun06               *
      *                 239155             Date 31May06               *
      *                 BUG9713            Date 04Jan06               *
      *                 BUG7426            Date 15Jul05               *
      *                 GOC001             Date 14Jul04               *
      *                 BUG7895            Date 19Jul05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG7459            Date 14Jun05               *
      *                 BUG3500            Date 06Jul04               *
      *                 BUG2948            Date 03Jun04               *
      *                 BUG1175R           Date 01Jun04               *
      *                 BUG1175            Date 28Apr04               *
      *                 BUG1898            Date 20Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG711             Date 19Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 20Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD045854 - Batch Detail cannot be entered with message       *
      *             Batch Header already accepted. Removed CAP209     *
      *             conditioning from AR1092517 fix.                  *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1092517 - Transaction is not populated in List View for    *
      *              transactions with blank batch number             *
      *  AR1078953 - Blank Batch Number is not accepted by the system *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSC054 - Period End Adjustments                              *
      *  249585 - Front office id of batch entered via APIs gets      *
      *           overriden when amended in Midas Plus screens        *
      *           Applied for AR971392 (Child: AR971393)              *
      *  260029 - Applied core fix 251260.                            *
      *  251260 - Journal entry hash item no. do not match. Increase  *
      *           length of field DDHINC from 2A to 3A (Recompile).   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15754 - Applied fix 249471.                               *
      *  249471 - Calculated Hash Total and No. of Items added to     *
      *           Header input screen.  Recompiled only.              *
      *  249177 - Add validation to check the correct value for field *
      *           Type of Journal Entry                               *
      *  247132 - Replace value of Type Of Journal Entry.             *
      *  246518 - Avoid lock between thin client session and REC0880. *
      *  BUG13869A - Error message change in GLBITHRTV (Recompile)    *
      *  243860  - No detail entries written on GLJENPPD              *
      *  237512  - Pass the value of BKMHTN for further validation.   *
      *  240063  - Pass the value of BKMHTN for further validation.   *
      *            Applied fix 237512.                                *
      *  239155 - Avoid lock between thin client session and GLC445.  *
      *           (already done under BUG7459).                       *
      *  BUG9713 - GL Batch Header Input - Serious MidasPlus had      *
      *            occurred                                           *
      *  BUG7426 - GL Batch Input, user can't reuse previously        *
      *            deleted batch number                               *
      *  GOC001 - Account Posting (Journal Entry) Input Amendments    *
      *           Amend core hook GLBITH02                            *
      *           Add core hooks GLBITH03, GLBITH04, GLBITH05         *
      *  BUG7895 - Added action code to GLBITHPD                      *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BUG7459 - Avoid lock between thin client session and GLC445. *
      *  BUG3500 - Amendment to batch deletion processing             *
      *  BUG2948 - Do not allow change of Multi-branch field from     *
      *            'Y' to 'N'.                                        *
      *  BUG1175R-User ID is now setup in workstation ID by java      *
      *  BUG1175- If setting batch to in use also set up user & tmst  *
      *  BUG1898- Add extra parameter for call to GLBITHUPD           *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG711 - Batch is now set in use when user retrieves details *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      *
      ** JE Headers file by Front Office ID
     FGLJENHL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** JE Headers file by Front Office ID
     FGLJENHL0  UF   E           K DISK    INFSR(*PSSR)
      *
      ** Today's batch numbers used
     FGLBTNOL0  UF   E           K DISK    INFSR(*PSSR)
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
     F/COPY WNCPYSRC,GLH00745
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
      ** User                                                                                BUG1175
     D LUser           S             10A                                                     BUG1175
     D TIMEtime        S               T                                                     BUG1175
     D TIMEchar        S             10A                                                     BUG1175
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Message Header (DS)
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction (DS)
     D PTranIn       E DS                  EXTNAME(GLBITHPD)
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
                                                                                             BUG2948
      ** Current JE Header (DS)                                                              BUG2948
     D CurFilJENH    E DS                  EXTNAME(GLJENHPD)                                 BUG2948
     D  QQACCF1      E                     EXTFLD(QQACCF)                                    BUG2948
     D  QQACCT1      E                     EXTFLD(QQACCT)                                    BUG2948
      *
      ** JE Headers Error Indicators (DS)
     D PFlagsOK      E DS                  EXTNAME(GLEBITHPD)
     D  WIndOK                 1      7    DIM(7) INZ('Y')
      *
      ** JE Non-screen Interface Data file format                                             CAP086
     D PInfData      E DS                  EXTNAME(GLJEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
      ** JE Headers Extra Data (DS)
     D PExtData      E DS                  EXTNAME(GLBHEXPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for API ICD Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Hook for non-core D-specs (all types)                                                GOC001
      /COPY WNCPYSRC,GLBITH03                                                                 GOC001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIdx            S              3P 0
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
      *
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Field (500A) to receive the incoming transaction
     D PTrans500       S            500A
      *
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D PInfData500     S            500A                                                      CAP086
                                                                                              CAP086
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *                                                                                       CSC054
      ** Period End Adjustments Fields                                                        CSC054
     D PEAHeader       S              8A                                                      CSC054
      *
      ** Module ID, to be passed to the Message Handler
     D PModuleID       S              2A
      *
      ** Action code defaults to 'I' for insert
     D PAction         S              1A   INZ('I')
      *
      ** Timestamp for the transaction
     D PTimeStamp      S               Z

     D DBerrUpd        C                   CONST('DB error in BITH API update')
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CAP086
      ** Auto Authorisation flag                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
     C                   MOVEL     PTrans500     PTranIn
     C                   MOVEL     PInfData500   PInfData                                     CAP086
     C                   MOVEL     PExtdata500   PExtdata
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      ** Process transaction.
      ** If user is 'releasing' a batch in use then
      ** update header record and do not continue processing
      *
     C*****DDBTNB        CHAIN     GLJENHL0                           22                     BUG7459
     C     DDBTNB        CHAIN     GLJENHL0                           2223                   BUG7459
      *                                                                                       249585
      ** Set up front office id / asoc frnt fields                                            249585
     C                   IF        *IN22 = *OFF                                               249585
     C                   EVAL      B1FRNT = BRFRNT                                            249585
     C                   EVAL      B1AFRT = BRAFRT                                            249585
     C                   ENDIF                                                                249585
      *                                                                                       249585
     C                   IF        *IN23 = *ON                                               BUG7459
     C                   SELECT                                                              BUG7459
     C                   WHEN      %STATUS = 01218                                           BUG7459
      *                                                                                      BUG7459
      ** Record already locked                                                               BUG7459
      *                                                                                      BUG7459
     C                   MOVEL     'GLX0274'     MsgIdArr(1)                                 BUG7459
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                               BUG7459
     C**********         Eval      MsgDtaArr(1) = DDBTNB                            BUG7459 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBTNB))                               MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(DDBTNB)                     MD000091
     C                   Z-ADD     1             Idx                                         BUG7459
     C                   OTHER                                                               BUG7459
      *                                                                                      BUG7459
      ** Other I/O error detected                                                            BUG7459
      *                                                                                      BUG7459
     C                   MOVEL     'USR0563'     MsgIdArr(1)                                 BUG7459
     C                   Z-ADD     1             Idx                                         BUG7459
     C                   ENDSL                                                               BUG7459
     C                   MOVE      *ON           *INLR                                       BUG7459
     C                   RETURN                                                              BUG7459
     C                   ELSE                                                                BUG7459
     C     *IN22         IFEQ      *OFF
     C     BRBIUF        ANDEQ     'Y'
     C     DDINOV        ANDNE     'Y'                                                        BUG711
     C     DDINOV        ANDNE     'U'                                                        BUG711
      *
     C     DDBHAI        IFNE      'U'
     C*****BRUSRA        IFEQ      *BLANKS                                          BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRI                                   BUG1175 BUG1175R
     C**********         ELSE                                                       BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRI                                   BUG1175 BUG1175R
     C**********         ENDIF                                                      BUG1175 BUG1175R
     C                   Eval      LUser = BRWSID                                           BUG1175R
     C                   MOVEL     'DDBTNB'      FldNameArr(1)
     C**********         MOVEL     'GLX0041'     MsgIdArr(1)                                 BUG1175
     C                   MOVEL     'GLX0422'     MsgIdArr(1)                                 BUG1175
     C                   Eval      TIMEtime = %time(BRTMST)                                  BUG1175
     C                   MOVE      TIMEtime      TIMEchar                                    BUG1175
     C**********         Eval      MsgDtaArr(1) = LUser + ' @ ' + TIMEchar          BUG1175 MD000091
     C                   EVAL      MsgDtaTmp = LUser + ' @ ' + TIMEchar                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   Z-ADD     1             Idx
     C                   ELSE
     C                   IF        BRWSID <> 'GLC445'                                        BUG7459
     C                             AND BRWSID <> 'REC0880'                                    246518
     C                   MOVE      ' '           BRBIUF
     C                   Eval      BRWSID = *blanks                                         BUG1175R
     C                   UPDATE    @BRREAG
     C                   ENDIF                                                               BUG7459
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ELSE
      *
     C     DDINOV        IFEQ      'U'                                                        BUG711
     C     BRWSID        ANDNE     'GLC445'                                                  BUG7459
     C     BRWSID        ANDNE     'REC0880'                                                  246518
     C                   MOVE      ' '           BRBIUF                                       BUG711
     C                   Eval      BRWSID = *blanks                                         BUG1175R
      * Don't try to update a record that was not found                                      BUG3500
     C     *IN22         IFEQ      *OFF                                                      BUG3500
     C                   UPDATE    @BRREAG                                                    BUG711
     C                   ENDIF                                                               BUG3500
     C                   SETON                                        LR                      BUG711
     C                   RETURN                                                               BUG711
     C                   ELSE                                                                 BUG711
      *                                                                                       BUG711
     C                   UNLOCK    GLJENHL0
     C                   ENDIF                                                                BUG711
      *  Perform validation subroutines                                                      BUG7895
      *  Validate Action Code                                                                BUG7895
                                                                                             BUG7895
     C                   EXSR      ValidateAc                                                BUG7895
      *  If error in validation of action code, fail this input                              BUG7895
      *                                                                                      BUG7895
     C     Idx           IFNE      0                                                         BUG7895
     C                   GOTO      INVALID                                                   BUG7895
     C                   END                                                                 BUG7895
      *                                                                                      BUG7895
      *  Validate Transaction details                                                        BUG7895
     C                   EXSR      SRValdTran
     C/COPY WNCPYSRC,GLBITH04                                                                 GOC001
     C                   ENDIF
     C                   ENDIF                                                               BUG7459
      *
      ** If errors exist, set Valid Indicator to 'N' and Transaction
      ** Status to F (Failure); otherwise, set Valid Indicator to 'Y'
      ** and Transaction Status to S (Success).
      *
     C     INVALID       TAG                                                                 BUG7895
     C     Idx           IFGT      *ZERO
     C                   EVAL      B1VALI = 'N'
     C                   ELSE
     C                   EVAL      B1VALI = 'Y'
     C                   ENDIF

      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF
      *
     C                   EVAL                    Buffer = PTranIn
     C**********                                 + PExtData                                   CAP086
     C                                           + PEAHeader                                  CSC054
     C                                           + PInfData + PExtData                        CAP086

     C                   SETON                                        LR

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
      *
     C                   CLEAR                   PVBITH
      *
      ** Numeric fields within PVBITH have to be reset explicitly as
      ** there are long alpha fields overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields.
      *
     C                   Z-ADD     *ZERO         B1HICC
     C                   Z-ADD     *ZERO         B1HDCC
     C                   Z-ADD     *ZERO         B1HINC
     C                   Z-ADD     *ZERO         B1HIIN
     C                   Z-ADD     *ZERO         B1HDIN
     C                   Z-ADD     *ZERO         B1HINI
     C                   Z-ADD     *ZERO         B1SPTT
     C                   Z-ADD     *ZERO         B1NIST
     C                   Z-ADD     *ZERO         B1RACF
     C                   Z-ADD     *ZERO         B1AMTF
     C                   Z-ADD     *ZERO         B1RACT
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
      *
     C                   RESET                   FldNoArr
      *
     C                   RESET                   PFlagsOK
      *
     C                   ENDSR
      *                                                                                      BUG7895
      *****************************************************************                      BUG7895
      /EJECT                                                                                 BUG7895
      *****************************************************************                      BUG7895
      *                                                               *                      BUG7895
      * ValidateAc - Routine to validate action code versus the       *                      BUG7895
      *    transaction IDs supplied                                   *                      BUG7895
      *                                                               *                      BUG7895
      *****************************************************************                      BUG7895
                                                                                             BUG7895
     C     ValidateAc    BEGSR                                                               BUG7895
                                                                                             BUG7895
     C/COPY WNCPYSRC,GLH00767
      * Validate action code versus transaction IDs supplied                                 BUG7895
     C                   CLEAR                   CurFilJENH                                  BUG7895
                                                                                             BUG7895
     C                   RESET                   ReturnCode                                  BUG7895
     C                   CALLB     'GLBITHRTV'                                               BUG7895
                                                                                             BUG7895
      * INPUTS                                                                               BUG7895
                                                                                             BUG7895
      * Return code                                                                          BUG7895
     C                   PARM      *BLANK        ReturnCode                                  BUG7895
                                                                                             BUG7895
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                 BUG7895
     C                   PARM      '      '      ModeofOp          6                         BUG7895
      *                                                                                      BUG7895
      * Response mode                                                                        BUG7895
     C                   PARM      'S'           APRESPMODE                                  BUG7895
                                                                                             BUG7895
      * Action Code                                                                          BUG7895
     C                   PARM                    DDACTN                                      BUG7895
                                                                                             BUG7895
      * Front Office Transaction ID                                                          BUG7895
     C                   PARM                    APFOTranID                                  BUG7895
                                                                                             BUG7895
      * Batch Header Number                                                                  BUG7895
     C                   PARM                    DDBTNB                                      BUG7895
                                                                                             BUG7895
      * Multiple branch batch indicator                                                      BUG7895
     C                   PARM                    DDMBRB                                      BUG7895
                                                                                             BUG7895
      * Batch Header Branch                                                                  BUG7895
     C                   PARM                    DDBCDA                                      BUG7895
                                                                                             BUG7895
      * OUTPUTS                                                                              BUG7895
                                                                                             BUG7895
      * (Current) deal in file format                                                        BUG7895
     C                   PARM                    CurFilJENH                                  BUG7895
                                                                                             BUG7895
      * OK - Action code                                                                     BUG7895
     C                   PARM                    DDActnOK          1                         BUG7895
                                                                                             BUG7895
      * OK - Batch Number                                                                    BUG7895
     C                   PARM                    DDBtnbBK          1                         BUG7895
                                                                                             BUG7895
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG7895
     C                   PARM                    FldNameArr                                  BUG7895
     C                   PARM                    MsgIDArr                                    BUG7895
     C                   PARM                    MsgDtaArr                                   BUG7895
                                                                                             BUG7895
      * Array index (3P0) from/to caller                                                     BUG7895
     C                   PARM                    Idx                                         BUG7895
                                                                                             BUG7895
     C                   ENDSR                                                               BUG7895
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdTran - Routine to validate the main transaction        *
      *               details                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRValdTran    BEGSR
      *
     C                   CALLB     'GLBITHVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM      'S'           APRESPMODE
      ** from Java only                                                                       243860
     C                   PARM      'Y'           fromJava          1                          243860
      *                                                                                    AR1078953
      ** Front Office Transaction ID                                                       AR1078953
     C                   PARM                    APFOTranID                                AR1078953
      *
      ** Incoming Transaction (DS)
     C                   PARM                    PTranIn
      *
      ** JE Headers Extra Data (DS)
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Mandatory Batch No./ No. of Items
     C                   PARM                    BKMHTN
      *
      ** OUTPUT
      ** ======
      *
      ** JE Headers Error Indicators (DS)
     C                   PARM                    PFlagsOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/msg data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
                                                                                             BUG2948
      ** Current JE Header File Format                                                       BUG2948
     C                   PARM                    CurFilJENH                                  BUG2948
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SRSetOFld
     C                   EXSR      UpdateDB
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *
      ** Update JE Headers file.
      *
     C                   CALLB     'GLBITHUPD'
      *                             =========
      ** Return code
     C                   PARM      *BLANK        PRTCD             7
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Security on Journal Entry
     C                   PARM                    CGL008
      *
      ** Valid JE Headers (DS) - for file update
     C                   PARM                    PVBITH
      *                                                                                      BUG1898
      ** Parameter to contain error message for java user                                    BUG1898
     C                   PARM      *BLANKS       JERRMSG           7                         BUG1898
      *                                                                                       237512
      ** Parameter to contain BKMHTN from GL ICD                                              237512
     C                   PARM                    BKMHTN                                       237512
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*RECUPD'
     C*****PRTCD         ANDNE     'CGL0002'                                                 BUG1898
     C*****PRTCD         ANDNE     'CGL0003'                                                 BUG1898
     C     JERRMSG       ANDEQ     *BLANK                                                    BUG1898
     C                   MOVEL     '0'           APIRetc
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.

     C     PRTCD         IFEQ      '*RECUPD'

     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     DBerrUpd      MsgIdArr(1)

     C                   END
      *
      ** If update not done due to user not been authorised (CGL008) send message
      *
     C*****CGL008        IFEQ      'Y'
     C*****PRTCD         IFEQ      'CGL0002'                                                 BUG1898
     C*****PRTCD         OREQ      'CGL0003'                                                 BUG1898
     C*****PRTCD         OREQ      'GLX0075'                                                 BUG1898
     C*****PRTCD         OREQ      'GLX0041'                                                 BUG1898
     C*****PRTCD         OREQ      'GLX0232'                                                 BUG1898
     C     JERRMSG       IFNE      *BLANKS                                                   BUG1898
     C                   MOVEL     'DDBHAI'      FldNameArr(1)
     C**********         MOVEL     PRTCD         MsgIdArr(1)                                 BUG1898
     C                   MOVEL     JERRMSG       MsgIdArr(1)                                 BUG1898
      *                                                                                      BUG1175
     C     JERRMSG       IFEQ      'GLX0422'                                                 BUG1175
     C*****B1USRA        IFEQ      *BLANKS                                          BUG1175 BUG1175R
     C**********         Eval      LUser = B1USRI                                   BUG1175 BUG1175R
     C**********         ELSE                                                       BUG1175 BUG1175R
     C**********         Eval      LUser = B1USRI                                   BUG1175 BUG1175R
     C**********         ENDIF                                                      BUG1175 BUG1175R
     C                   Eval      LUser = B1WSID                                           BUG1175R
     C                   MOVEL     'GLX0422'     MsgIdArr(1)                                 BUG1175
     C                   Eval      TIMEtime = %time(B1TMST)                                  BUG1175
     C                   MOVE      TIMEtime      TIMEchar                                    BUG1175
     C**********         Eval      MsgDtaArr(1) = LUser + ' @ ' + TIMEchar          BUG1175 MD000091
     C                   EVAL      MsgDtaTmp = LUser + ' @ ' + TIMEchar                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   ENDIF                                                               BUG1175
      *                                                                                      BUG1175
     C                   ADD       1             Idx
     C                   ENDIF
     C**********         ENDIF                                                               BUG1898

      ** Batch Number to pass back to APTRANVU on insert mode

     C                   EVAL                    DDBTNB = B1BTNB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetOFld - Set up additional fields that are needed on the  *
      *              file record                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRSetOFld     BEGSR
      *
      ** Update record with Message Header data.
      *
     C                   IF        B1FRNT = *BLANKS                                           249585
     C                   EVAL      B1FRNT = 'APCTRANVU'
      *                                                                                       CSC054
      ** Front office only updated from 3rd party                                             CSC054
      *                                                                                       CSC054
     C**********         IF        CGL125 = 'Y'                                     CSC054 AR1092517
     C**********         IF        CAP209 = 'Y'                                   AR1092517 MD045854
     C                   IF        APFOTranID <> *BLANKS                                    MD045854
     C                   EVAL      B1FRNT = APFOTranID                                        CSC054
     C                   ENDIF                                                                CSC054
     C                   EVAL      B1AFRT = APFOAsocID
     C                   ENDIF                                                                249585
     C                   EVAL      B1TMST = PTimeStamp
      ** If coming from JAVA front end then set up front office ID as 'APCTRANVU'
      ** suffixed with the batch header number when accepting a batch
      *
      ** Front office only updated from 3rd party                                             CSC054
      *                                                                                       CSC054
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1092517
     C**********         IF        CAP209 = 'N'                                   AR1092517 MD045854
                                                                                              CSC054
     C     DDBTNB        IFNE      *BLANKS
     C     B1FRNT        ANDEQ     'APCTRANVU'                                                249585
     C                   MOVE      *BLANKS       FRNTID            9
     C                   MOVEL     B1FRNT        FRNTID
     C     FRNTID        CAT       DDBTNB        B1FRNT
     C                   ENDIF
                                                                                              CSC054
     C**********         ENDIF                                                       CSC054 MD045854
      *
      ** If current batch has dumped already, set to allow to dump again
      *
     C/COPY WNCPYSRC,GLH00746
     C     B1BTNB        CHAIN     GLBTNOL0                           21
      *
     C                   IF        *IN21 = *OFF AND B3DUMP = 'Y'
      *
     C                   MOVE      ' '           B3DUMP
     C                   UPDATE    GLBTNOD0
      *                                                                                      BUG7426
      ** To allow deletion of batch number in GLBITHUPD program                              BUG7426
      *                                                                                      BUG7426
     C                   ELSE                                                                BUG7426
     C                   UNLOCK    GLBTNOL0                                                  BUG7426
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLH00747
      *  Checking JE Headers master file to see if already exists
      *
     C**********         IF        CGL125 = 'N'                                     CSC054 AR1092517
     C**********         IF        CAP209 = 'N'                                   AR1092517 MD045854
     C                   IF        B1FRNT <> *BLANKS                                        MD045854
     C     B1FRNT        CHAIN     GLJENHL3                           20
     C                   ENDIF                                                                CSC054
      *
      ** Default Batch Status to Held.
      *
     C     B1BTSF        IFNE      'A'
     C                   EVAL      B1BTSF = 'H'
     C                   ENDIF
      ** Type of Journal is Interface.
      *
     C                   IF        IF_AUTH <> ' '                                             249177
     C                   EVAL      B1TOJE = 'I'
     C                   ELSE                                                                 249177
     C                   EVAL      B1TOJE = 'J'                                               249177
     C                   ENDIF                                                                249177
      *                                                                                       249177
      ** If batch in use flag is 'Y' but the current user set it to be in use                 BUG711
      ** in edit or action mode, then clear flag.                                             BUG711
      *
     C     B1BIUF        IFEQ      'Y'                                                        BUG711
     C     DDINOV        ANDEQ     'Y'                                                        BUG711
     C                   EVAL      B1BIUF = ' '                                               BUG711
     C                   EVAL      B1WSID = *blanks                                         BUG1175R
     C                   ENDIF                                                                BUG711
      *                                                                                       BUG711
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      B1AUTH =  IF_AUTH                                          CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Common Message Header information (DS) from source system
     C                   PARM                    PHeadIn
      *
      ** Transaction information in a single large field from
      ** from source system
     C                   PARM                    PTrans500
      *                                                                                       CSC054
      ** Corrective batch header                                                              CSC054
     C                   PARM                    PEAHeader                                    CSC054
      *                                                                                       CAP086
      ** Non-screen interface data file format                                                CAP086
     C                   PARM                    PInfData500                                  CAP086
      *
      ** Extra Transaction information in a single large field
      ** from source system
     C                   PARM                    PExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLBITH02
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL(P)  POPTN         DBKEY
     C                   MOVEL(P)  'SDAPIPD'     DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CGL008 (Security on Journal
      ** Entry) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL008'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL008'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   ENDIF
      *
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 3                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CAP086
     C/COPY WNCPYSRC,GLH00748
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRTCD                                        CAP086
     C                   PARM      '*VERIFY'     POPTN                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRTCD <> *BLANKS AND                                       CAP086
     C                             PRTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'GLAMADVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 4                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        PRTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Access SAR details file to see if CGL125 is installed.                               CSC054
      *                                                                                       CSC054
     C                   EVAL      CGL125 = 'N'                                               CSC054
     C                   CALL      'AOSARDR0'                                                 CSC054
     C                   PARM      *BLANKS       PRTCD                                        CSC054
     C                   PARM      '*VERIFY'     POPTN                                        CSC054
     C                   PARM      'CGL125'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC054
      *                                                                                       CSC054
     C                   IF        PRTCD <> *BLANKS AND                                       CSC054
     C                             PRTCD <> '*NRF'                                            CSC054
     C     *LOCK         IN        LDA                                                        CSC054
     C                   EVAL      DBPGM = 'GLAMADVU'                                         CSC054
     C                   EVAL      DBKEY = 'CGL125'                                           CSC054
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC054
     C                   EVAL      DBASE  = 5                                                 CSC054
     C                   OUT       LDA                                                        CSC054
     C                   EXSR      *PSSR                                                      CSC054
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
     C                   IF        PRTCD = *BLANKS                                            CSC054
     C                   MOVE      'Y'           CGL125            1                          CSC054
     C                   ENDIF                                                                CSC054
      *****************************************************************              CSC054 MD045854
      ***Access*SAR*details*file*to*see*if*CAP209*is*installed.********           AR1092517 MD045854
      *****************************************************************           AR1092517 MD045854
     C**********         MOVE      'N'           CAP209            1              AR1092517 MD045854
     C**********         CALL      'AOSARDR0'                                     AR1092517 MD045854
     C**********         PARM      *BLANKS       PRTCD                            AR1092517 MD045854
     C**********         PARM      '*VERIFY'     POPTN                            AR1092517 MD045854
     C**********         PARM      'CAP209'      PSARD                            AR1092517 MD045854
     C*****SCSARD        PARM      SCSARD        DSFDY                            AR1092517 MD045854
      *                                                                           AR1092517 MD045854
     C**********         IF        PRTCD <> *BLANKS AND                           AR1092517 MD045854
     C**********                   PRTCD <> '*NRF'                                AR1092517 MD045854
     C******LOCK         IN        LDA                                            AR1092517 MD045854
     C**********         EVAL      DBPGM = 'GLBITHVU'                             AR1092517 MD045854
     C**********         EVAL      DBKEY = 'CAP209'                               AR1092517 MD045854
     C**********         EVAL      DBFILE ='SCSARDPD'                             AR1092517 MD045854
     C**********         EVAL      DBASE  = 5                                     AR1092517 MD045854
     C**********         OUT       LDA                                            AR1092517 MD045854
     C**********         EXSR      *PSSR                                          AR1092517 MD045854
     C**********         ENDIF                                                    AR1092517 MD045854
      *                                                                           AR1092517 MD045854
     C**********         IF        PRTCD = *BLANKS                                AR1092517 MD045854
     C**********         EVAL      CAP209 = 'Y'                                   AR1092517 MD045854
     C**********         ENDIF                                                    AR1092517 MD045854
      **********                                                                  AR1092517 MD045854
     C                   MOVE      *BLANKS       PRTCD                                       BUG9713
                                                                                             BUG9713
     C/COPY WNCPYSRC,GLBITH05                                                                 GOC001
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
