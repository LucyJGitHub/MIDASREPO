     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal range auth. by front office ID')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMPBDLRAT - MM DEAL RANGE AUTHORIZATION                      *
      *              By Front Office ID                               *
      *                                                               *
      *  Function:  This input function allows range authorization    *
      *             of all MM transactions by Front Office ID         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR701789           Date 26Sep16               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
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
      *                 CMM105             Date 22Jun04               *
      *                 BUG2804            Date 20May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052  *CREATE    Date 25Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *         - Incomplete parameter list passed to MMLDNIUPM.      *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMPBDLGD02,MMPBDLGC02,           *
      *           Core hooks added:MMPBDLGC10                         *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *                                                               *
      *****************************************************************
 
     FMMPBDLRDF CF   E             WORKSTN INFSR(*PSSR)
     F/COPY WNCPYSRC,MMPBDLGF01
 
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
                                                                                              CAS004
      ** Array for Warning messages                                                           CAS004
     D WFldNamArr      S             10A   DIM(ArrayMax)                                      CAS004
     D WMsgIDArr       S                   DIM(ArrayMax) LIKE(#MsgID)                         CAS004
     D WMsgDtaArr      S                   DIM(ArrayMax) LIKE(#MsgData)                       CAS004
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** data structure for data to output 'authorized' message
     D @ADAT           DS            46
     D  @ADAT1                 1      6
     D  @ADAT2                 7     26
     D  @ADAT3                27     45
 
      ** data structure for data to output 'failed' message
     D @FDTA           DS            45
     D  @FDT1                  1      6
     D  @FDT2                  7     26
     D  @FDT3                 27     45
 
 
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax) LIKE(#MsgID)
 
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax) LIKE(#MsgData)
 
 
     D DELDFilFmt    E DS                  EXTNAME(MMDELDPP)
     D DSFRCD                        47    OVERLAY(DELDFilFmt:1850)                           CDL033
      ** DS for FRCD Issued Extension details                                                 CDL033
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CDL033
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL033
      ** File - Payment Further Settlement Instructions                                       CDL033
                                                                                              CDL033
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL033
      ** File - Receive Further Settlement Instructions                                       CDL033
                                                                                              CDL033
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL033
      ** External data structure for SAR details                                              CDL033
                                                                                              CDL033
     D PBFRCD          S            100A                                                      CDL033
     D PAFRCD          S            100A                                                      CDL033
     D PRTCD           S              7A                                                      CDL033
     D POPTN           S              7A                                                      CDL033
     D PSARD           S              6A                                                      CDL033
                                                                                              CDL033
     D/COPY WNCPYSRC,MMPBDLGD01
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D/COPY WNCPYSRC,MMPBDLGD02
 
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
     C                   ENDIF
 
      **  Main processing
      **  Loop until CK/3 taken
 
     C     *INKC         DOWEQ     False
     C                   EXSR      MAIN
     C                   ENDDO
      *
      * TERMINATE PROGRAM
      *
     C                   MOVE      True          *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN PROCESSING
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Selection screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MMPBDLS0
     C                   WRITE     MMPBDLD1
     C                   WRITE     MMPBDLF1
     C                   READ      MMPBDLD1                               99
 
      ** If CK/3 taken, bypass
 
     C     *INKC         CABEQ     True          EMAIN
 
      ** Validate screen input
 
     C                   EXSR      VALSIN
 
      ** If validation not OK, bypass
 
     C     *IN50         CABEQ     True          EMAIN
 
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
 
     C                   MOVEL     'MMM0266'     @MSGID
     C                   MOVE      @CNTAU        @ADAT1
     C                   MOVEL     DDFDLN        @ADAT2
     C                   MOVEL     DDLDLN        @ADAT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @ADAT
 
      ** Output failure count message
 
     C     @CNTFL        IFNE      0
     C                   MOVEL     'MMM1048'     @MSGID
     C                   MOVE      @CNTFL        @FDT1
     C                   MOVEL     DDFDLN        @FDT2
     C                   MOVEL     DDLDLN        @FDT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @FDTA
     C                   ENDIF
      *
     C     EMAIN         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHLDNI - Authorize all unauthorized loans and deposits
      *****************************************************************
     C     AUTHLDNI      BEGSR
 
      * Read Loans and Deposits
 
     C                   MOVEL     NXTLDNIID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READLDNI
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     HKDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   MOVEL     @FTRED        DDFRTN
     C                   ELSE
 
      ** Update Loan/Deposit
 
     C                   EXSR      UPDTLDNI
     C                   ENDIF
     C                   ENDIF
 
      * Read Loans and Deposits
 
     C                   EXSR      READLDNI
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHNASP - Authorize all unauthorized NAs Purchased
      *****************************************************************
     C     AUTHNASP      BEGSR
 
      * Read NAs Purchased
 
     C                   MOVEL     NXTNASPID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READNASP
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     HLDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   MOVEL     @FTRED        DDFRTN
     C                   ELSE
 
      ** Update NA Purchased
 
     C                   EXSR      UPDTNASP
     C                   ENDIF
     C                   ENDIF
 
      * Read NAs Purchased
 
     C                   EXSR      READNASP
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHNASS - Authorize all unauthorized NAs Sold
      *****************************************************************
     C     AUTHNASS      BEGSR
 
      * Read NAs Sold
 
     C                   MOVEL     NXTNASSID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READNASS
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     HMDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   MOVEL     @FTRED        DDFRTN
     C                   ELSE
 
      ** Update NA Sold
 
     C                   EXSR      UPDTNASS
     C                   ENDIF
     C                   ENDIF
 
      * Read NAs Sold
 
     C                   EXSR      READNASS
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHDEAM - Authorize all unauthorized Deal Amendments
      *****************************************************************
     C     AUTHDEAM      BEGSR
 
      * Read Deal amendments
 
     C                   MOVEL     NXTDEAMID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READDEAM
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal amendment is not deleted
 
     C     HNDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   MOVEL     @FTRED        DDFRTN
     C                   ELSE
 
      ** Update Deal amendment
 
     C                   EXSR      UPDTDEAM
     C                   ENDIF
     C                   ENDIF
 
      * Read Deal amendments
 
     C                   EXSR      READDEAM
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDTLDNI - UPDATE LOAN/DEPOSIT DEAL
      *****************************************************************
     C     UPDTLDNI      BEGSR
     C/COPY WNCPYSRC,MMPBDLGC01
                                                                                              CDL033
     C                   EVAL      PBFRCD = *BLANKS                                           CDL033
     C                   EVAL      PAFRCD = *BLANKS                                           CDL033
                                                                                              CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     HKMTYP        IFEQ      'CF'                                                       CDL033
     C     HKMTYP        OREQ      'CI'                                                       CDL033
     C     HKMTYP        OREQ      'TI'                                                       CDL033
     C     HKMTYP        OREQ      'TD'                                                       CDL033
     C     HKMTYP        OREQ      'IP'                                                       CDL033
     C     HKMTYP        OREQ      'IT'                                                       CDL033
     C                   EVAL      PBFRCD = DSFRCD                                            CDL033
     C                   EVAL      PAFRCD = DSFRCD                                            CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
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
     C                   PARM                    #FPAYF                                       CDL033
     C                   PARM                    #FRECF                                       CDL033
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM                    PBFRCD                                       CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM                    PAFRCD                                       CDL033
     C/COPY WNCPYSRC,MMPBDLGC02
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DELDFilFmt
     C                   ENDIF
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C/COPY WNCPYSRC,MMPBDLGC09
     C                   ADD       1             @CNTAU
     C                   ENDIF
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
     C                   ENDIF
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
     C                   ENDIF
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
     C                   ENDIF
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
     C                   ENDIF
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
     C                   ENDIF
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
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READLDNI - READ THROUGH LOANS & DEPOSITS
      *****************************************************************
     C     READLDNI      BEGSR
      *
     C/COPY WNCPYSRC,MMPBDLGC04
     C                   CALLB     'MMLDNIRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT'      @@MODE            6
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * DEAL Front Office Pointer
     C                   PARM                    DDFRTN           20
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      * If no deal read, treat like EOF
      *
     C     @FTRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   ENDIF
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADLDNI
      *
      * Check whether past last deal number
      *
     C     @FTRED        IFGT      DDLDLN
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @FTRED        FOTRID
     C                   EXSR      RTVLDNI
     C                   ENDIF
     C/COPY WNCPYSRC,MMPBDLGC05
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
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT'      @@MODE            6
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * DEAL Front Office Pointer
     C                   PARM                    DDFRTN           20
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      * If no deal read, treat like EOF
      *
     C     @FTRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   ENDIF
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADNASP
      *
      * Check whether past last deal number
      *
     C     @FTRED        IFGT      DDLDLN
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @FTRED        FOTRID
     C                   EXSR      RTVNASP
     C                   ENDIF
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
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT'      @@MODE            6
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * DEAL Front Office Pointer
     C                   PARM                    DDFRTN           20
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      * If no deal read, treat like EOF
      *
     C     @FTRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   ENDIF
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADNASS
      *
      * Check whether past last deal number
      *
     C     @FTRED        IFGT      DDLDLN
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @FTRED        FOTRID
     C                   EXSR      RTVNASS
     C                   ENDIF
      *
     C     EREADNASS     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READDEAM - READ THROUGH DEAL AMENDMENTS
      *****************************************************************
     C     READDEAM      BEGSR
      *
     C/COPY WNCPYSRC,MMPBDLGC06
     C                   CALLB     'MMDEAMRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT'      @@MODE            6
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * DEAL Front Office Pointer
     C                   PARM                    DDFRTN           20
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDDS38            3
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      * Front Office Associated ID READ
     C                   PARM      *BLANK        @FARED           20
      *
      * VALUE DATE READ
     C                   PARM      *BLANK        @VDRED            6
      *
      * SEQUENCE NUMBER READ
     C                   PARM      *BLANK        @SQRED            3
      *
      * If no deal amendment read, treat like EOF
      *
     C     @FTRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   ENDIF
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADDEAM
      *
      * Check whether past last deal number
      *
     C     @FTRED        IFGT      DDLDLN
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal amendment details
      *
     C                   ELSE
     C                   MOVEL     @FTRED        FOTRID
     C                   MOVEL     @FARED        FOASID
     C                   MOVEL     @VDRED        DDVDAT
     C                   MOVEL     @SQRED        DDDS38
     C                   EXSR      RTVDEAM
     C                   ENDIF
     C/COPY WNCPYSRC,MMPBDLGC07
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
     C                   PARM      '*FRONT'      @@MODE            6
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
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DELDFilFmt
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
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
     C/COPY WNCPYSRC,MMPBDLGC10
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
     C                   PARM      '*FRONT'      @@MODE            6
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
     C                   PARM      '*FRONT'      @@MODE            6
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
     C                   PARM      '*FRONT'      @@MODE            6
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
      ** First Front Office Id must be entered
      *
     C     DDFDLN        IFEQ      *BLANKS
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN10
     C                   ENDIF
      *
      ** Second Front Office Id must be enterd
      *
     C     DDLDLN        IFEQ      *BLANKS
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN11
     C                   ENDIF
      *
     C     DDFDLN        IFEQ      *BLANKS
     C     DDLDLN        OREQ      *BLANKS
     C                   MOVEL     'FXM0500'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   GOTO      EVALSI
     C                   ENDIF
      *
      ** Second Id must be less than first Front Office Id
      *
     C     DDLDLN        IFLT      DDFDLN
     C                   MOVEL     'FXM0501'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN11
     C                   GOTO      EVALSI
     C                   ENDIF
      *
      ** Look for at least one deal
      *
     C                   MOVEL     DDFDLN        DDFRTN
     C                   MOVE      *BLANKS       @RDFWD
     C                   MOVE      'Y'           @RDBCK
     C                   EXSR      READLDNI
      *
     C                   MOVEL     @FTRED        NXTLDNIID        20
     C                   MOVEL     NXTLDNIID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READLDNI
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     DDFDLN        DDFRTN
     C                   MOVE      *BLANKS       @RDFWD
     C                   MOVE      'Y'           @RDBCK
     C                   EXSR      READNASP
      *
     C                   MOVEL     @FTRED        NXTNASPID        20
     C                   MOVEL     NXTNASPID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READNASP
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     DDFDLN        DDFRTN
     C                   MOVE      *BLANKS       @RDFWD
     C                   MOVE      'Y'           @RDBCK
     C                   EXSR      READNASS
      *
     C                   MOVEL     @FTRED        NXTNASSID        20
     C                   MOVEL     NXTNASSID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READNASS
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     DDFDLN        DDFRTN
     C                   MOVE      *BLANKS       @RDFWD
     C                   MOVE      'Y'           @RDBCK
     C                   EXSR      READDEAM
      *
     C                   MOVEL     @FTRED        NXTDEAMID        20
     C                   MOVEL     NXTDEAMID     DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READDEAM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Error if not at least one record to authorize
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     'MMM1029'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN10
     C                   ENDIF
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
     C                   WRITE     MMPBDLS0
     C                   WRITE     MMPBDLD1
     C                   WRITE     MMPBDLF1
     C                   READ      MMPBDLD1                               99
 
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
     C                   MOVEL     'MMPBDLRAT'   DBPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      True          *IN40
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
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033                                       CDL033
      ** (Floating Rate CD Issued) is on.                                                     CDL033
      *                                                                                       CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C                   MOVE      'N'           CDL033            1                          CDL033
     C                   IF        PRTCD  = *BLANKS                                           CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
     C                   ELSE                                                                 CDL033
     C                   IF        PRTCD  <> '*NRF   '                                        CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   MOVE      '901'         DBASE                                        CDL033
     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C/COPY WNCPYSRC,MMPBDLGC03
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMPBDLGC08
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CCPY@
(c) Misys International Banking Systems Ltd. 2001
