     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal contract input')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCSIN - INTERNAL CONTRACTS SCREEN INPUT                  *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for internal contracts.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 261962             Date 23Sep09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 13Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084             Date 02Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP076             Date 03Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 182224             Date 31Aug00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  261962 - Amended so that system can get the associated front *
      *           office ID from Java for INTC.                       *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - API Wrapper project                                 *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in ABINTCVAL                *
      *           (new parameter to ZINTDY)                           *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  182224 - Deal Numbers are skipped by  Auto-allocation  process
      *           in   FX &  MM  input options .  When  F12  is pressed
      *           from  the last confirmation  screen ,  the  ROLBK   *
      *           is not performed  every time .                      *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D CrDlFilFmt    E DS                  EXTNAME(ABDEALPP)
      * Current Deal in File Format
 
     D CrDlScnFmt    E DS                  EXTNAME(ABINTCPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)
 
     D NwDlFilFmt    E DS                  EXTNAME(ABVINTCPD)
      * New Deal in File Format
 
     D NwDlScnFmt    E DS                  EXTNAME(ABINTCPD)
      * New Deal in Screen Format
 
     D ABEINTC       E DS                  EXTNAME(ABEINTCPD)
      * Error indicators
 
 
 
     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKP                 6      6
 
     D @PCI@M          DS             6
      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN
 
 
     D ExtData       E DS                  EXTNAME(ABICEXPD)
      * Internal Contract Extra Data - File (D/B) format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
                                                                                              CSC022
      ** External DS SC Switchable Features                                                   CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D/COPY QWINDSRC,INTCSINDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
     D DDFOID          S             20A                                                      261962
     D DDAFID          S             20A                                                      261962
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,ABINTCS007
 
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
      /COPY WNCPYSRC,ABINTCS001
 
      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      /COPY WNCPYSRC,ABINTCS002
 
      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      *
      /COPY WNCPYSRC,ABINTCS003
 
      * SCREEN: WINDOW
      *
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
      *
      /COPY WNCPYSRC,ABINTCS004
 
      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      /COPY WNCPYSRC,ABINTCS005
 
      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      /COPY WNCPYSRC,ABINTCS006
 
      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,ABINTCS008
 
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      * Only required if deal number or action code has been changed
      * (this check will also cater for F12 taken from main screen)
      *
     C     BGWDPR        IFEQ      'Y'
     C     DDL1DN        IFNE      @PL1DN
     C     DDL2DN        ORNE      @PL2DN
     C     @CCI@M        ORNE      @PCI@M
                                                                                              182224
      * Check for the work field indicating Deal No. allocation has run                       182224
     C     @WFRUN        OREQ      'Y'                                                        182224
                                                                                              182224
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EVAL      @WFRUN = *BLANKS                                           182224
                                                                                              182224
     C                   END
     C                   END
      *
      * Update 'previous' deal number & screen control indicator
      *
     C                   MOVEL     DDL1DN        @PL1DN            6
     C                   MOVEL     DDL2DN        @PL2DN            6
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'ABINTCDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    ABEINTC
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEALS
     C                   PARM                    @SIDN1            6
     C                   PARM                    @SIDN2            6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       ABEINTC
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      * CK/8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deal details
      *
     C                   EXSR      RTVDEL
      *
      * If action code, deal numbers, or booking or orig. branch are NOT OK
      * Re-output screen with error messages on it
      *
     C     ddACTNok      IFEQ      'N'
     C     ddL1DNok      OREQ      'N'
     C     ddL2DNok      OREQ      'N'
     C     ddBRCDok      OREQ      'N'
     C     ddORBRok      OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete or enquire
      *   Put the deal on the main details screen
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'E'
     C                   EXSR      PUTD@M
     C                   END
      *
      * If deal numbers or screen control indicators have changed
      *   Re-output screen
      *
     C     DDL1DN        IFNE      @PL1DN
     C     DDACTN        ANDNE     'I'
     C     DDL2DN        ORNE      @PL2DN
     C     DDACTN        ANDNE     'I'
     C     @CCI@M        ORNE      @PCI@M
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       ABEINTC
     C                   CLEAR                   NwDlFilFmt
      *
      * Validate deal details
      *
     C                   CALLB     'ABINTCVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ExtData
     C                   PARM                    DDL2RT
     C                   PARM                    DDL2CB
     C                   PARM                    DDL2BA
     C                   PARM                    DDL2CS
     C                   PARM                    DDL2SA
     C                   PARM                    DDLOIA
     C                   PARM                    DDDPIA
      * Status                                                                  CAP084
     C                   PARM                    DDSTS            24            CAP084
     C                   PARM                    ABEINTC
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
      *
      * If windows processing on, call window routine
      * otherwise, continue to confirmation screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       ABEINTC
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'ABINTCDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
      *
      * FIELDS IN ERROR
     C                   PARM                    ABEINTC
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEALS
     C                   PARM                    @SIDN1            6
     C                   PARM                    @SIDN2            6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'Y'           WriteOnly         1
      *
     C/COPY WNCPYSRC,ABINTCSC02
      * IF FIRST DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDL1DN        IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDL1DN          6
     C                   PARM      *ZERO         JUFD38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDL1DN        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
     C/COPY WNCPYSRC,ABINTCSC01
      * IF SECOND DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDL2DN        IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDL2DN          6
     C                   PARM      *ZERO         JUSD38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDL2DN        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                              182224
      * Set up the work field indicating the Deal No. allocation has run                      182224
     C                   MOVE      'Y'           @WFRUN            1                          182224
                                                                                              182224
      *
     C/COPY WNCPYSRC,INTCSINMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'ABINTCSIN'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      DDACTN        ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to confirmation screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'D'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON DEALS FILE
      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'ABINTCRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDL1DN            6
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
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   END
      *
      * If deal read
      *
     C     @DLRED        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @DLRED        DDL1DN
     C                   EXSR      RTVDEL
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      PUTD@M
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'ABINTCBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDL1DN            6
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM      *BLANK        @DLSEL            6
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EBLDBR
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'ABINTCBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDL1DN            6
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM      *BLANK        @DLSEL            6
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * IF DEAL READ FROM SUBFILE
      *
     C     @DLSEL        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @DLSEL        DDL1DN
     C                   EXSR      RTVDEL
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      PUTD@M
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   END
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'ABINTCRTV'
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
      * (Midas) First Deal Number
     C                   PARM                    DDL1DN
      *
      * (Midas) Second Deal Number
     C                   PARM                    DDL2DN
      *
      * Booking branch
     C                   PARM                    DDBRCD
      *
      * Originating branch
     C                   PARM                    DDORBR
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        ddACTNok
      *
      * OK - First Deal Number
     C                   PARM      *BLANK        ddL1DNok
      *
      * OK - Second Deal Number
     C                   PARM      *BLANK        ddL2DNok
      *
      * OK - Booking branch
     C                   PARM      *BLANK        ddBRCDok
      *
      * OK - Originating branch
     C                   PARM      *BLANK        ddORBRok
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
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from ABDEALPP
      *
     C                   CALLB     'ABINTCCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                                       261962
      ** Front Office Transaction ID                                                          261962
      ** Associated Front Office Transaction ID                                               261962
      *                                                                                       261962
     C                   PARM                    DDFOID                                       261962
     C                   PARM                    DDAFID                                       261962
      *                                                                                       261962
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      * Enable/disable key & detail fields on main details screen
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'E', or 'D')
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      * Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   MOVEL     *BLANK        DDL2RT
     C                   MOVEL     *BLANK        DDL2CB
     C                   MOVEL     *BLANK        DDL2BA
     C                   MOVEL     *BLANK        DDL2CS
     C                   MOVEL     *BLANK        DDL2SA
     C                   MOVEL     *BLANK        DDLOIA
     C                   MOVEL     *BLANK        DDDPIA
     C                   END
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           ddACTNok
     C                   END
      *
      ** Deal number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMM0162'
     C                   MOVE      'N'           ddL1DNok
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       ABEINTC
      *
      * Validate deal details
      *
     C                   CALLB     'ABINTCVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ExtData
     C                   PARM                    DDL2RT
     C                   PARM                    DDL2CB
     C                   PARM                    DDL2BA
     C                   PARM                    DDL2CS
     C                   PARM                    DDL2SA
     C                   PARM                    DDLOIA
     C                   PARM                    DDDPIA
      * Status                                                                  CAP084
     C                   PARM                    DDSTS            24            CAP084
     C                   PARM                    ABEINTC
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'ABINTCDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
      *
      * FIELDS IN ERROR
     C                   PARM                    ABEINTC
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKP
      *
      * SUCCESFUL INSERT DEALS
     C                   PARM                    @SIDN1            6
     C                   PARM                    @SIDN2            6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       ABEINTC
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * IF FIRST DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDL1DN        IFEQ      *BLANK
      *
     C     I#DDL1DN      IFNE      *BLANK
     C                   MOVEL     I#DDL1DN      DDL1DN
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    DDL1DN
     C                   PARM      *ZERO         JUFD38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 001*
     C                   MOVEL     DDL1DN        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C                   END
      *
      * IF SECOND DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDL2DN        IFEQ      *BLANK
      *
     C     I#DDL2DN      IFNE      *BLANK
     C                   MOVEL     I#DDL2DN      DDL2DN
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    DDL2DN
     C                   PARM      *ZERO         JUSD38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 001*
     C                   MOVEL     DDL2DN        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C                   END
      *
      ** SUCCESSFUL INSERT
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     DDL1DN        @SIDN1
     C                   MOVEL     DDL2DN        @SIDN2
     C                   END
      *
      * UPDATE VALID DEAL: FIRST AND SECOND DEAL NUMBERS
      *
     C                   MOVEL     DDL1DN        JUFD38
     C                   MOVEL     DDL2DN        JUSD38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        JULACT
      *
      * INTERNAL CONTRACT DATABASE UPDATES
      *
     C                   CALLB     'ABINTCUPD'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   END
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   MOVEL     *BLANK        DDL2RT
     C                   MOVEL     *BLANK        DDL2CB
     C                   MOVEL     *BLANK        DDL2BA
     C                   MOVEL     *BLANK        DDL2CS
     C                   MOVEL     *BLANK        DDL2SA
     C                   MOVEL     *BLANK        DDLOIA
     C                   MOVEL     *BLANK        DDDPIA
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   END
      *
     C                   MOVEL     'T'           @SCRN
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
     C                   MOVEL     'ABINTCSIN'   DBPGM
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
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      *  is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRtCd                                        CSC022
     C                   PARM      '*VERIFY'     POptn                                        CSC022
     C                   PARM      'CSC022'      PSard                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        PRtCd <> '*NRF'                                            CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 003                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,ABINTCS009
 
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
(c) Finastra International Limited 2001
