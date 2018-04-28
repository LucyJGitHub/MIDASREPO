     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal range authorization')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEALRAT - MM DEAL RANGE AUTHORIZATION                      *
      *                                                               *
      *  Function:  This input function allows range authorization    *
      *             of all MM transactions.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG7222            Date 10Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 BUG2804            Date 20May04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 BUG2132            Date 07May04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             Date 25Nov99               *
      *                 CAP051             Date 12Nov99               *
      *                 CDL007             Date 12Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 01May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG7222- Incomplete parameter list passed to MMLDNIUPM.      *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMDEALGD02,MMDEALGC07,MMDEALGC03 *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  BUG2132- Midasplus webfacing  changes. Recompile due to      *
      *           changes in MMDEALRDF.                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FMMDEALRDF CF   E             WORKSTN INFSR(*PSSR)
     F/COPY WNCPYSRC,MMDEALGF01
 
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
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** data structure for data to output 'authorized' message
     D @ADAT           DS            45
     D  @ADAT1                 1      6
     D  @ADAT2                 7     12
     D  @ADAT3                13     18
 
      ** data structure for data to output 'failed' message
     D @FDTA           DS            45
     D  @FDT1                  1      6
     D  @FDT2                  7     12
     D  @FDT3                 13     18
     D  @FDT4                 19     24
 
 
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax) LIKE(#MsgID)
 
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax) LIKE(#MsgData)
 
      ** Array for Warning messages                                                           CAS004
     D WFldNamArr      S             10A   DIM(ArrayMax)                                      CAS004
     D WMsgIDArr       S                   DIM(ArrayMax) LIKE(#MsgID)                         CAS004
     D WMsgDtaArr      S                   DIM(ArrayMax) LIKE(#MsgData)                       CAS004
 
     D DELDFilFmt    E DS                  EXTNAME(MMDELDPP)
     D DSFRCD                       100    OVERLAY(DELDFilFmt:1850)                           CDL033
     D DENBFilFmt    E DS                  EXTNAME(MMDENBPP)
     D DENSFilFmt    E DS                  EXTNAME(MMDENSPP)
     D DORIQQ1       E                     EXTFLD(DORIQQ)                                     CGL029
     D MORIQQ1       E                     EXTFLD(MORIQQ)                                     CGL029
     D RONSQQ1       E                     EXTFLD(RONSQQ)                                     CGL029
     D PONSQQ1       E                     EXTFLD(PONSQQ)                                     CGL029
     D DEAMFilFmt    E DS                  EXTNAME(MMDEAMPP)
     D DORIQQ2       E                     EXTFLD(QQDORI)                                     CGL029
     D MORIQQ2       E                     EXTFLD(QQMORI)                                     CGL029
     D DOPIQQ2       E                     EXTFLD(QQDOPI)                                     CGL029
     D MOPIQQ2       E                     EXTFLD(QQMOPI)                                     CGL029
     D RONSQQ2       E                     EXTFLD(QQRONS)                                     CGL029
     D PONSQQ2       E                     EXTFLD(QQPONS)                                     CGL029
 
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
                                                                                              CDL006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
      ** External data structure for SAR details                                              CDL006
                                                                                              CDL006
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                             BUG7222
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                 BUG7222
      ** File - Payment Further Settlement Instructions                                      BUG7222
                                                                                             BUG7222
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                 BUG7222
      ** File - Receive Further Settlement Instructions                                      BUG7222
                                                                                             BUG7222
     D/COPY WNCPYSRC,MMDEALGD01
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D/COPY WNCPYSRC,MMDEALGD02
 
      ** Index for arrays of of warning message ids etc                                       CAS004
     D WIdx            S              3P 0                                                    CAS004
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CAS004
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
 
      ** If authorizations are not required
 
     C     BNMMAU        IFEQ      'N'
     C                   EXSR      NOINPUT
     C                   END
     C/COPY WNCPYSRC,MMDEALGC14
 
      **  Main processing
      **  Loop until CK/3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      MAIN
     C                   END
      *
      * TERMINATE PROGRAM
      *
     C                   MOVE      '1'           *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN PROCESSING
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Selection screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MMDEALS0
     C                   WRITE     MMDEALD1
     C                   WRITE     MMDEALF1
     C                   READ      MMDEALD1                               99
 
      ** If CK/3 taken, bypass
 
     C     *INKC         CABEQ     '1'           EMAIN
 
      ** Validate screen input
 
     C                   EXSR      VALSIN
 
      ** If validation not OK, bypass
 
     C     *IN50         CABEQ     '1'           EMAIN
 
      ** Initialize count of authorizattions and failed authorizations
 
     C                   Z-ADD     0             @CNTAU            6 0
     C                   Z-ADD     0             @CNTFL            6 0
 
      ** Authorize all unauthorized loans and deposits
 
     C                   EXSR      AUTHLDNI
 
      ** Authorize all unauthorized NAs purchased
 
     C                   EXSR      AUTHNASP
 
      ** Authorize all unauthorized NAs sold
 
     C                   EXSR      AUTHNASS
 
      ** Authorize all unauthorized deal amendments
 
     C                   EXSR      AUTHDEAM
 
      ** Output authorized count message
 
     C                   MOVEL     'MMM0265'     @MSGID
     C                   MOVE      @CNTAU        @ADAT1
     C                   MOVE      @FSTDLNO      @ADAT2
     C                   MOVE      @LSTDLNO      @ADAT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @ADAT
 
      ** Output failure count message
 
     C     @CNTFL        IFNE      0
     C                   MOVEL     'MMM1047'     @MSGID
     C                   MOVE      @CNTFL        @FDT1
     C                   MOVE      @FSTDLNO      @FDT2
     C                   MOVE      @LSTDLNO      @FDT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @FDTA
     C                   END
      *
     C     EMAIN         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHLDNI - Authorize all unauthorized loans and deposits
      *****************************************************************
     C     AUTHLDNI      BEGSR
 
      * Read Loans and Deposits
 
     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READLDNI
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     HKDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   ELSE
 
      ** Update Loan/Deposit
 
     C/COPY WNCPYSRC,MMDEALGC15
     C                   EXSR      UPDTLDNI
     C/COPY WNCPYSRC,MMDEALGC16
     C                   END
     C                   END
 
      * Read Loans and Deposits
 
     C                   EXSR      READLDNI
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHNASP - Authorize all unauthorized NAs Purchased
      *****************************************************************
     C     AUTHNASP      BEGSR
 
      * Read NAs Purchased
 
     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READNASP
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     HLDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   ELSE
 
      ** Update NA Purchased
 
     C                   EXSR      UPDTNASP
     C                   END
     C                   END
 
      * Read NAs Purchased
 
     C                   EXSR      READNASP
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHNASS - Authorize all unauthorized NAs Sold
      *****************************************************************
     C     AUTHNASS      BEGSR
 
      * Read NAs Sold
 
     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READNASS
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     HMDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   ELSE
 
      ** Update NA Sold
 
     C                   EXSR      UPDTNASS
     C                   END
     C                   END
 
      * Read NAs Sold
 
     C                   EXSR      READNASS
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHDEAM - Authorize all unauthorized Deal Amendments
      *****************************************************************
     C     AUTHDEAM      BEGSR
 
      * Read Deal amendments
 
     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READDEAM
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal amendment is not deleted
 
     C     HNDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   ELSE
 
      ** Update Deal amendment
 
     C                   EXSR      UPDTDEAM
     C                   END
     C                   END
 
      * Read Deal amendments
 
     C                   EXSR      READDEAM
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDTLDNI - UPDATE LOAN/DEPOSIT DEAL
      *****************************************************************
     C     UPDTLDNI      BEGSR
     C/COPY WNCPYSRC,MMDEALGC06
                                                                                              CDL033
     C                   MOVEL     *BLANKS       PBFRCD                                       CDL033
     C                   MOVEL     *BLANKS       PAFRCD                                       CDL033
                                                                                              CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     HKMTYP        IFEQ      'CF'                                                       CDL033
     C     HKMTYP        OREQ      'CI'                                                       CDL033
     C     HKMTYP        OREQ      'TI'                                                       CDL033
     C     HKMTYP        OREQ      'TD'                                                       CDL033
     C     HKMTYP        OREQ      'IP'                                                       CDL033
     C     HKMTYP        OREQ      'IT'                                                       CDL033
     C                   MOVEL     DSFRCD        PBFRCD                                       CDL033
     C                   MOVEL     DSFRCD        PAFRCD                                       CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        HKLACT
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    DELDFilFmt
     C                   PARM                    #FPAYF                                      BUG7222
     C                   PARM                    #FRECF                                      BUG7222
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM                    PBFRCD          100                          CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM                    PAFRCD          100                          CDL033
     C/COPY WNCPYSRC,MMDEALGC07
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DELDFilFmt
     C                   END
     C/COPY WNCPYSRC,MMDEALGC01
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C/COPY WNCPYSRC,MMDEALGC13
     C                   ADD       1             @CNTAU
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDTNASP - UPDATE NAS PURCHASED
      *****************************************************************
     C     UPDTNASP      BEGSR
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        HLLACT
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMNASPUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    DENBFilFmt
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMNASPUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DENBFilFmt
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ADD       1             @CNTAU
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDTNASS - UPDATE NAS SOLD
      *****************************************************************
     C     UPDTNASS      BEGSR
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        HMLACT
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMNASSUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    DENSFilFmt
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMNASSUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DENSFilFmt
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ADD       1             @CNTAU
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDTDEAM - UPDATE DEAL AMENDMENTS
      *****************************************************************
     C     UPDTDEAM      BEGSR
      *
      * UPDATE VALID DEAL AMENDMENT: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        HNLACT
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'MMDEAMUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    DEAMFilFmt
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMDEAMUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DEAMFilFmt
     C                   END
     C/COPY WNCPYSRC,MMDEALGC02
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ADD       1             @CNTAU
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READLDNI - READ THROUGH LOANS & DEPOSITS
      *****************************************************************
     C     READLDNI      BEGSR
      *
     C/COPY WNCPYSRC,MMDEALGC08
     C                   CALLB     'MMLDNIRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
      *
      * READ FORWARDS
     C                   PARM      'Y'           @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM      *BLANK        @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *
      * If no deal read, treat like EOF
      *
     C     @DLRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   END
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADLDNI
      *
      * Check whether past last deal number
      *
     C                   MOVEL     @DLRED        @CURDLNO          6 0
     C     @CURDLNO      IFGT      @LSTDLNO
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      RTVLDNI
     C                   END
     C/COPY WNCPYSRC,MMDEALGC09
      *
     C     EREADLDNI     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READNASP - READ THROUGH NAS PURCHASED
      *****************************************************************
     C     READNASP      BEGSR
      *
     C                   CALLB     'MMNASPRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
      *
      * READ FORWARDS
     C                   PARM      'Y'           @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM      *BLANK        @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *
      * If no deal read, treat like EOF
      *
     C     @DLRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   END
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADNASP
      *
      * Check whether past last deal number
      *
     C                   MOVEL     @DLRED        @CURDLNO          6 0
     C     @CURDLNO      IFGT      @LSTDLNO
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      RTVNASP
     C                   END
      *
     C     EREADNASP     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READNASS - READ THROUGH NAS SOLD
      *****************************************************************
     C     READNASS      BEGSR
      *
     C                   CALLB     'MMNASSRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
      *
      * READ FORWARDS
     C                   PARM      'Y'           @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM      *BLANK        @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *
      * If no deal read, treat like EOF
      *
     C     @DLRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   END
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADNASS
      *
      * Check whether past last deal number
      *
     C                   MOVEL     @DLRED        @CURDLNO          6 0
     C     @CURDLNO      IFGT      @LSTDLNO
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      RTVNASS
     C                   END
      *
     C     EREADNASS     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READDEAM - READ THROUGH DEAL AMENDMENTS
      *****************************************************************
     C     READDEAM      BEGSR
      *
     C/COPY WNCPYSRC,MMDEALGC10
     C                   CALLB     'MMDEAMRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDDS38            3
      *
      * READ FORWARDS
     C                   PARM      'Y'           @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM      *BLANK        @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *                                                                         CAP052
      * Front Office Associated ID READ                                         CAP052
     C                   PARM      *BLANK        @FARED           20            CAP052
      *
      * VALUE DATE READ
     C                   PARM      *BLANK        @VDRED            6
      *
      * SEQUENCE NUMBER READ
     C                   PARM      *BLANK        @SQRED            3
      *
      * If no deal amendment read, treat like EOF
      *
     C     @DLRED        IFEQ      *BLANK
     C     @VDRED        OREQ      *BLANK
     C     @SQRED        OREQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   END
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADDEAM
      *
      * Check whether past last deal number
      *
     C                   MOVEL     @DLRED        @CURDLNO          6 0
     C     @CURDLNO      IFGT      @LSTDLNO
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal amendment details
      *
     C                   ELSE
     C                   MOVEL     @DLRED        DDDLNO
     C                   MOVEL     @VDRED        DDVDAT
     C                   MOVEL     @SQRED        DDDS38
     C                   EXSR      RTVDEAM
     C                   END
     C/COPY WNCPYSRC,MMDEALGC11
      *
     C     EREADDEAM     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVLDNI - RETRIEVE LOAN & DEPOSIT DEAL
      *****************************************************************
     C     RTVLDNI       BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR            6                          196380
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN            6
      *
      * Booking branch
     C                   PARM                    DDBRCA            3
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DELDFilFmt
     C/COPY WNCPYSRC,MMDEALGC17
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN            1
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO            1
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA            1
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMDEALGC03
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVNASP - RETRIEVE NAS PURCHASED DEAL
      *****************************************************************
     C     RTVNASP       BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMNASPRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *
      * Booking branch
     C                   PARM                    DDBRCA
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DENBFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVNASS - RETRIEVE NAS SOLD DEAL
      *****************************************************************
     C     RTVNASS       BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMNASSRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DENSFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEAM - RETRIEVE DEAL AMENDMENT
      *****************************************************************
     C     RTVDEAM       BEGSR
      *
      * RETRIEVE DEAL AMENDMENT
      *
     C                   CALLB     'MMDEAMRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *
      * Value Date
     C                   PARM                    DDVDAT            6
      *
      * Sequence Number
     C                   PARM                    DDDS38            3
      *
      * Deal Amendment Amount
     C                   PARM                    DDAMNP           15
      *
      * Deal Amendment Type
     C                   PARM                    DDMTYP            2
      *
      * OUTPUTS
      *
      * Deal amendment in file format
     C                   PARM                    DEAMFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Value Date
     C                   PARM      *BLANK        OKVDAT            1
      *
      * OK - Sequence Number
     C                   PARM      *BLANK        OKDS38            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C/COPY WNCPYSRC,MMDEALGC04
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALSIN   - VALIDATE SCREEN INPUT
      *****************************************************************
     C     VALSIN        BEGSR
      *
      ** Clear the message queue & init error indicators
      *
     C                   CALL      'ZA0250'
     C                   MOVE      '0'           *IN50
     C                   MOVE      '0'           *IN10
     C                   MOVE      '0'           *IN11
      *
      ** First deal number must be numeric
      *
     C                   TESTN                   DDFDLN               9697
     C     DDFDLN        IFEQ      *BLANKS
     C     *IN96         ORNE      '1'
     C     *IN97         ANDNE     '1'
     C                   MOVEL     'MMM0262'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN10
     C                   END
      *
      ** Second deal number must be numeric
      *
     C                   TESTN                   DDLDLN               9697
     C     DDLDLN        IFEQ      *BLANKS
     C     *IN96         ORNE      '1'
     C     *IN97         ANDNE     '1'
     C                   MOVEL     'MMM0262'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN11
     C                   END
      *
      ** Numeric errors, no more checking
      *
     C     *IN50         CABEQ     '1'           EVALSI
      *
      ** Second number not less than first number
      *
     C                   MOVE      DDLDLN        @LSTDLNO          6 0
     C                   MOVE      DDFDLN        @FSTDLNO          6 0
     C     @LSTDLNO      IFLT      @FSTDLNO
     C                   MOVEL     'MMM0263'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN11
     C                   GOTO      EVALSI
     C                   END
      *
      ** Look for at least one deal
      *
     C     @FSTDLNO      SUB       1             @F_1DLNO          6 0
     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READLDNI
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      READNASP
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      READNASS
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      READDEAM
     C                   END
     C                   END
     C                   END
      *
      ** Error if not at least one record to authorize
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     'MMM1029'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN10
     C                   END
      *
     C     EVALSI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * NOINPUT - NO INPUT SCREEN
      *****************************************************************
     C     NOINPUT       BEGSR
      *
      ** Write message, present screen and end program
      *
     C                   MOVEL     'MMM0159'     @MSGID           10
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
 
     C                   MOVE      '1'           *IN13
     C                   TIME                    DDTIME
     C                   WRITE     MMDEALS0
     C                   WRITE     MMDEALD1
     C                   WRITE     MMDEALF1
     C                   READ      MMDEALD1                               99
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEALRAT'   DBPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** Get DEALING ICD
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDL006
      ** Check if Dealing Fiduciary is switched ON                                            CDL006
                                                                                              CDL006
     C                   CALLB     'MMFIDINIT'                                                CDL006
     C                   PARM      *BLANKS       WRTCD             7                          CDL006
     C/COPY WNCPYSRC,MMDEALGC05
      *                                                                                       CDL033
      ** Determine if Floating Rate CD Issued feature is                                      CDL033
      ** switched on.                                                                         CDL033
      *                                                                                       CDL033
     C                   MOVE      'N'           CDL033            1                          CDL033
     C                   CALL      'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      @SARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C     @RTCD         IFEQ      *BLANKS                                                    CDL033
     C                   MOVE      'Y'           CDL033                                       CDL033
     C                   ELSE                                                                 CDL033
     C     @RTCD         IFNE      '*NRF   '                                                  CDL033
     C                   MOVE      '901'         DBASE                                        CDL033
     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMDEALGC12
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
