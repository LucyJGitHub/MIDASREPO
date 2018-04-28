     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details screen input')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSECDSIN - SECURITY CUSTOMER DETAILS SCREEN INPUT           *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Securities Clients Details.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG16696           Date 05Mar08               *
      *                 249076             Date 03Aug07               *
      *                 243070             Date 10Jul06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE070             Date 15Feb05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CAAA03             Date 12May04               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209867             Date 10Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 204747             Date 17Apr02               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 04Oct99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16696 - Missing parameter when calling SDSECDBRW on       *
      *             RDNBRW subroutine                                 *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CAAA03 - Array index out of range due to the non-clearing of *
      *           customer number after press of F12 during insertion *
      *           of security customer.                               *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  209867 - No rollback when F3 pressed. Msg ENDCMTCTL not      *
      *           allowed at signoff due to updates in window pgm.    *
      *  204747 - Removed restriction of having 10 custodians defined *
      *           in the ICD before using F11 function.               *
      *  193883 - Recompile over changed SDSECDUPD.                   *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
 
     D CrSdFilFmt    E DS                  EXTNAME(SDSECSPD)
     D                                     PREFIX(C_)
      * Current Securities Clients Detail in File Format
 
 
     D CurSecDets    E DS                  EXTNAME(SDSECDPD)
     D                                     PREFIX(@)
      * Current Securities Clients Detail in Screen Format
 
 
     D NwSdFilFmt    E DS                  EXTNAME(SDVSECDPD)
      * New Securities Clients Detail in File Format
 
 
     D PrvSecDets    E DS                  EXTNAME(SDSECDPD)
     D                                     PREFIX(@P)
      * Previous Securities Clients Detail in Scrn Format
 
 
     D OKSecDets     E DS                  EXTNAME(SDESECDPD)
      * Error indicators
 
     D OKSecDets2    E DS                  EXTNAME(SDESECD2PD)                                CSE039
      * Error indicators                                                                      CSE039
                                                                                              CSE039
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access progrmas, long data structure
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Customer Work Field
     D WKCUST          S                   LIKE(DDCUSN)
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Customer Number
     D DDCUSN          S              6A
 
      ** Action Code
     D DDACTN          S              1A
 
      ** Customer Shortname
     D DDCSSN          S             10A
 
      ** Customer Number / Shortname
     D DDCSST          S             10A
 
      ** Customer Report Town
     D DDCRTN          S             10A
 
      ** Customer Report Name
     D DDCRNM          S             20A
 
      ** Build subfile
     D @BDSFL          S              1A
 
      ** Customer selected
     D @CUSEL          S              6A
 
      ** Whether position/select fields have been changed during key browse
     D KPosSelChg      S              1A
 
      ** condition availability of F10 (delete)
     D @EINKJ          S              1A
                                                                                              CSE022
      ** condition availability of F11 (Depot References)                                     CSE022
     D @EINKK          S              1A                                                      CSE022
 
      ** error message reference
     D @ERRMS          S              7A
      ** error message data                                                                   249076
     D @data           S             45                                                       249076
 
      ** F3 Exit
     D @INKC           S              1A
 
      ** F7 Roll backwards
     D @INKG           S              1A
 
      ** F8 Roll forwards
     D @INKH           S              1A
 
      ** F9 Insert
     D @INKI           S              1A
 
      ** F10 Delete
     D @INKJ           S              1A
                                                                                              CSE022
      ** F11 Depot Reference                                                                  CSE022
     D @INKK           S              1A                                                      CSE022
 
      ** F12 Cancel
     D @INKL           S              1A
 
      ** Option selected
     D @OPSEL          S              1A
 
      ** Read backwards in roll
     D @RDBCK          S              1A
 
      ** Read forwards in roll
     D @RDFWD          S              1A
 
      ** Read next browse
     D @RDNB           S              1A
 
      ** Read subfile
     D @RDSFL          S              1A
 
      **
     D @SCRED          S              6A
 
      ** Screen / function
     D @SCRN           S              1A
 
      ** Control return to key screen after F7/F8 rolls
     D INSERTENQ       S              1A
 
      ** Read next browse in key screen query browse subfile
     D K@RDNB          S              1A
 
      ** Query check in key screen customer number field
     D KEYQUERY        S              1A
 
      ** Mode of operation
     D MODEOFOP        S              6A
 
      ** Called from Customer Details or Midas menu
     D SDCUSDCALL      S              1A
 
      ** Called from Customer Details or Midas menu
     D BrwQuery        S              1A
 
      ** Index of errors
     D Idx             S              3P 0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
                                                                                              CSE022
      ** Depository Definition Enhancement Indicator                                          CSE022
     D CSE022          S              1A                                                      CSE022
                                                                                              CSE022
      ** Automatic Setllement of Trades Indicator                                             CSE039
     D CSE039          S              1A                                                      CSE039
                                                                                              CSE039
      ** DVP/RVP Processing Indicator                                                         CSE041
     D CSE041          S              1A                                                      CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements Indicator                                          CSE042
     D CSE042          S              1A                                                      CSE042
                                                                                              CSE042
      ** Return code for SDC100001                                                            CSE022
     D PRTCD           S             10A                                                      CSE022
     D PModeOfOp       S              3A   INZ('SIN')                                         CSE022
 
      ** Work variables for CSE022                                                            CSE022
     D WkCnt           S              3P 0                                                    CSE022
                                                                                              CSE022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSECDS001
 
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
      /COPY WNCPYSRC,SDSECDS002
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   ROLBK
     C                   END
      *
      /COPY WNCPYSRC,SDSECDS003
      *
      ** Build browse subfile record
      *
     C     @SCRN         IFEQ      'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSECDS004
      *
      ** Do while screen: Key Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_KVAL         3 0
     C     @SCRN         DOWEQ     'K'
     C                   EXSR      Scrn@K
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDSECDS005
      *
      ** Build key screen '?' browse subfile record
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      KBLDBRW
     C                   ENDIF
      *
      ** Read next key screen '?' browse subfile record
      *
     C     @SCRN         IFEQ      'S'
     C                   EXSR      KRDNBRW
     C                   ENDIF
      *
     C     @SCRN         IFEQ      ' '
     C                   EXSR      RTVCUS
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   MOVEL     'T'           @SCRN
     C                   END
      *
      * If action code is not insert
      *  .. Convert the Securities customer details to screen format
      *  .. Go to Details screen
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      CVTCUS
     C                   MOVEL     CrSdFilFmt    NwSdFilFmt
     C                   EXSR      SFDS@P
     C                   END
      *
      * Clear DS parameter arrays and go to detail screen
      *
     C                   MOVE      *ALL'Y'       OKSecDets
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSECDS006
      ** Do while screen: Securities Clients Detail Screen
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   EXSR      SFDS@P
     C                   ENDDO
      *                                                                                       CSE039
      ** Do while screen: Securities Clients Detail Screen 2                                  CSE039
      *                                                                                       CSE039
     C     @SCRN         DOWEQ     'F'                                                        CSE039
     C                   EXSR      Scrn@F                                                     CSE039
     C                   EXSR      SFDS@P                                                     CSE039
     C                   ENDDO                                                                CSE039
      *
      /COPY WNCPYSRC,SDSECDS007
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSECDS008
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSECDS009
 
      /EJECT
      *****************************************************************
      * SCRN@K - PROCESS SCREEN: KEY DETAILS
      *****************************************************************
     C     SCRN@K        BEGSR
 
      * Set Customer number if there are no errors
     C     Idx           IFEQ      0
 
      * Set key customer field with query processing work field value
      * (blank in normal processing, customer ref after query processing)
     C                   MOVEL     *BLANKS       DDCSST
     C                   MOVEL     WKCUST        DDCSST
 
     C                   ENDIF
 
      * Set F7/F8 called from Insert mode flag
     C                   MOVE      'Y'           INSERTENQ
 
 
      ** WRITE/READ DISPLAY SCREEN - Key Details
 
     C                   CALLB     'SDSECDKDP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeIn
 
      ** Customer Number / Shortname
     C                   PARM                    DDCSST
 
      ** Security Details in screen format
     C                   PARM                    CurSecDets
 
      ** Security Details OK indicators
     C                   PARM                    OKSecDets
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * OUTPUT PARAMETERS :
 
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKL
 
 
      * Reset customer number work field for query processing
     C                   Eval      WKCUST = *BLANKS
 
      * Reset Errors
 
     C                   MOVE      *ALL'Y'       OKSecDets
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
 
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Key Screen
     C     @INKL         CASEQ     '1'           CANC@K
      *
      * Validate input to Key screen
     C                   CAS                     VAL@K
      *
     C                   ENDCS
      *
     C     EndKey        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@K  - VALIDATE INPUT TO KEY SCREEN
      *****************************************************************
     C     VAL@K         BEGSR
 
      * If query on key screen, provide customer subfile for selection
 
     C                   MOVEL     DDCSST        KEYQuery
     C                   IF        KEYQuery = '?'
     C                   Eval      @SCRN = 'C'
     C                   Eval      DDCSST=*BLANKS
     C                   Eval      DDCUSN=*BLANKS
     C                   GOTO      EndVal@K
     C                   ENDIF
 
      * Retrieve Securities Clients Detail
      * Screen field may be shortname or customer number
     C                   MOVEL     DDCSST        DDCUSN
 
     C                   EXSR      RTVCUS
 
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   GOTO      EndVAL@K
     C                   END
      *
      * If action code is not insert
      *  .. Convert the Securities customer details to screen format
      *  .. Update the customer in file format
      *  .. Go to Details screen
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      CVTCUS
     C                   MOVEL     CrSdFilFmt    NwSdFilFmt
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
     C                   GOTO      EndVAL@K
     C                   END
      *
      * Clear DS parameter arrays and go to detail screen
      *
     C                   CLEAR                   NwSdFilFmt
     C                   CLEAR                   CrSdFilFmt
     C                   CLEAR                   CurSecDets
     C                   MOVE      *ALL'Y'       OKSecDets
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
      *
     C     EndVAL@K      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON DETAIL SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on detail screen
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
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
      * SCRN@P - PROCESS DETAIL SCREEN
      *****************************************************************
     C     SCRN@P        BEGSR
 
      * Set function key status on screen
 
     C                   EXSR      SFKEYS
     C                   Eval      @DDACTN = DDACTN
     C                   Eval      @DDCUSN = DDCUSN
 
 
      ** WRITE/READ DISPLAY SCREEN - Primary Details
 
     C                   CALLB     'SDSECDDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
 
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Security Details in screen format
     C                   PARM                    CurSecDets
 
      ** Security Details OK indicators
     C                   PARM                    OKSecDets
 
      ** Customer Shortname
     C                   PARM                    DDCSSN
 
      ** Customer Report Name
     C                   PARM                    DDCRNM
 
      ** Customer Report Town
     C                   PARM                    DDCRTN
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      ** Called from Customer Details Module
     C                   PARM                    SDCUSDcall
 
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      *                                                                         CAP014
      * ENABLED KEY & DETAIL FIELDS                                             CAP014
      *                                                                         CAP014
     C                   PARM                    @EKYFD            1            CAP014
     C                   PARM                    @EDTFD            1            CAP014
      *                                                                         CAP014
      * Enabled Function Keys
      * F10 - Delete
     C                   PARM                    @EINKJ
                                                                                              CSE022
      ** F11 - Depot References                                                               CSE022
 
     C                   PARM                    @EINKK                                       CSE022
 
      * OUTPUT PARAMETERS :
 
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK                                        CSE022
     C                   PARM      '0'           @INKL
 
      * Reset Errors
 
     C                   MOVE      *ALL'Y'       OKSecDets
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
 
      ** If CSE022 is not installed                                                           CSE022
                                                                                              CSE022
     C                   IF        CSE022 = 'N'                                               CSE022
                                                                                              CSE022
     C                   EVAL      @DDNDR3 = @DDDRF3                                          CSE022
     C                   EVAL      @DDNDR4 = @DDDRF4                                          CSE022
     C                   EVAL      @DDNDR5 = @DDDRF5                                          CSE022
     C                   EVAL      @DDNDR6 = @DDDRF6                                          CSE022
     C                   EVAL      @DDNDR7 = @DDDRF7                                          CSE022
     C                   EVAL      @DDNDR8 = @DDDRF8                                          CSE022
     C                   EVAL      @DDNDR9 = @DDDRF9                                          CSE022
     C                   EVAL      @DDNDR0 = @DDDRF0                                          CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
 
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
                                                                                              CSE022
      ** F11 - Depot References                                                               CSE022
                                                                                              CSE022
     C     @INKK         CASEQ     '1'           SRDePRef                                     CSE022
      *
      * F12 - Cancel on Details Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      * Validate Input to Details Screen
     C                   CAS                     VAL@P
 
     C                   ENDCS
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      *
      * If customer number is NOT OK
      * Re-output screen with error message on it
      *
     C     DDCUSNOK      IFEQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   MOVE      *ALL'Y'       OKSecDets
      *
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF F10 TAKEN, GO ON TO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@P
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
 
     C     DDACTN        IFEQ      'E'
     C     CSE039        ANDEQ     'N'                                                        CSE039
     C     CSE041        ANDEQ     'N'                                                        CSE041
     C     CSE042        ANDEQ     'N'                                                        CSE042
 
     C     @RDNB         IFEQ      'Y'
     C                   MOVE      'R'           @SCRN
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
 
     C                   GOTO      EndVAL@P
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
 
      * Validate Securities Clients Detail
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     @DDDRF1       @DDNDR1                                      CSE022
     C                   MOVEL     @DDDRF2       @DDNDR2                                      CSE022
     C                   MOVEL     CurSecDets    PrvSecDets
 
     C                   CALLB     'SDSECDVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS
 
      * Response mode
     C                   PARM      *BLANK        RespMode
 
      ** Security Details
     C                   PARM                    CurSecDets
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
 
      * OUTPUTS
 
      ** Security Details OK inds
     C                   PARM                    OKSecDets
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Valid Securities Clients details layout (DS) from/to caller
     C                   PARM                    NwSdFilFmt
 
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     CurSecDets    IFNE      PrvSecDets
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKSecDets
     C                   ENDIF
 
     C                   MOVE      'U'           @SCRN
      *                                                                                       CSE039
      * Display second screen if feature is on                                                CSE039
      *                                                                                       CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C     CSE041        OREQ      'Y'                                                        CSE041
     C     CSE042        OREQ      'Y'                                                        CSE042
      *                                                                                       CSE039
      * Display second screen if Classification is 'S' or 'D'                                 CSE039
     C     SECLAS        IFEQ      'S'                                                        CSE039
     C     SECLAS        OREQ      'D'                                                        CSE039
     C                   MOVE      'F'           @SCRN                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
 
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      * SCRN@F - PROCESS DETAIL SCREEN 2                                                      CSE039
      *****************************************************************                       CSE039
     C     SCRN@F        BEGSR                                                                CSE039
                                                                                              CSE039
      * Set function key status on screen                                                     CSE039
                                                                                              CSE039
     C                   Eval      @DDACTN = DDACTN                                           CSE039
     C                   Eval      @DDCUSN = DDCUSN                                           CSE039
                                                                                              CSE039
                                                                                              CSE039
      ** WRITE/READ DISPLAY SCREEN 2 - Secondary Details                                      CSE039
                                                                                              CSE039
     C                   CALLB     'SDSECD2DP'                                                CSE039
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                CSE039
      * INPUT PARAMETERS :                                                                    CSE039
                                                                                              CSE039
      * Return code                                                                           CSE039
     C                   PARM      *BLANKS       RetCodeIn                                    CSE039
                                                                                              CSE039
      ** Security Details in screen format                                                    CSE039
     C                   PARM                    CurSecDets                                   CSE039
                                                                                              CSE039
      ** Security Details screen 2 OK indicators                                              CSE039
     C                   PARM                    OKSecDets2                                   CSE039
                                                                                              CSE039
      ** Customer Shortname                                                                   CSE039
     C                   PARM                    DDCSSN                                       CSE039
                                                                                              CSE039
      ** Customer Report Name                                                                 CSE039
     C                   PARM                    DDCRNM                                       CSE039
                                                                                              CSE039
      ** Customer Report Town                                                                 CSE039
     C                   PARM                    DDCRTN                                       CSE039
                                                                                              CSE039
      ** Called from Customer Details Module                                                  CSE039
     C                   PARM                    SDCUSDcall                                   CSE039
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
                                                                                              CSE039
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041                                       CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042                                       CSE042
                                                                                              CSE039
                                                                                              CSE039
      * ERRORS                                                                                CSE039
     C                   PARM                    FldNameArr                                   CSE039
     C                   PARM                    MsgIdArr                                     CSE039
     C                   PARM                    MsgDtaArr                                    CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      * ENABLED KEY & DETAIL FIELDS                                                           CSE039
      *                                                                                       CSE039
     C                   PARM                    @EKYFD            1                          CSE039
     C                   PARM                    @EDTFD            1                          CSE039
                                                                                              CSE039
      * OUTPUT PARAMETERS :                                                                   CSE039
                                                                                              CSE039
      * Function Keys                                                                         CSE039
     C                   PARM      '0'           @INKC                                        CSE039
     C                   PARM      '0'           @INKL                                        CSE039
                                                                                              CSE039
      * Reset Errors                                                                          CSE039
                                                                                              CSE039
     C                   MOVE      *ALL'Y'       OKSecDets2                                   CSE039
     C                   MOVEL     *BLANK        FldNameArr                                   CSE039
     C                   MOVEL     *BLANK        MsgIdArr                                     CSE039
     C                   MOVEL     *BLANK        MsgDtaArr                                    CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      * F3 - End Program                                                                      CSE039
     C     @INKC         CASEQ     '1'           ENDP                                         CSE039
      *                                                                                       CSE039
      * F12 - Cancel on Details Screen 2                                                      CSE039
     C     @INKL         CASEQ     '1'           CANC@F                                       CSE039
      *                                                                                       CSE039
      * Validate Input to Details Screen 2                                                    CSE039
     C                   CAS                     VAL@F                                        CSE039
                                                                                              CSE039
     C                   ENDCS                                                                CSE039
                                                                                              CSE039
                                                                                              CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      * VAL@F  - VALIDATE INPUT TO DETAILS SCREEN 2                                           CSE039
      *****************************************************************                       CSE039
     C     VAL@F         BEGSR                                                                CSE039
      *                                                                                       CSE039
      * Prior to validation, initialize error indicators as 'OK'                              CSE039
      *                                                                                       CSE039
     C                   Z-ADD     *ZERO         Idx                                          CSE039
     C                   Z-ADD     *ZERO         WIdx_PVAL                                    CSE039
     C                   MOVE      *ALL'Y'       OKSecDets2                                   CSE039
      *                                                                                       CSE039
      *----------------------------------------------------------------                       CSE039
      * IF ENQUIRE                                                                            CSE039
                                                                                              CSE039
     C     DDACTN        IFEQ      'E'                                                        CSE039
     C                   EXSR      INITIAL                                                    CSE039
     C                   GOTO      EndVAL@F                                                   CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      *----------------------------------------------------------------                       CSE039
      * IF INSERT OR AMEND / CHANGE                                                           CSE039
      *                                                                                       CSE039
     C     DDACTN        IFEQ      'I'                                                        CSE039
     C     DDACTN        OREQ      'A'                                                        CSE039
                                                                                              CSE039
      * Validate Securities Clients Detail screen 2                                           CSE039
                                                                                              CSE039
      * Update 'previous' screens and previous number of warnings                             CSE039
                                                                                              CSE039
     C                   MOVEL     @DDDRF1       @DDNDR1                                      CSE039
     C                   MOVEL     @DDDRF2       @DDNDR2                                      CSE039
     C                   MOVEL     CurSecDets    PrvSecDets                                   CSE039
                                                                                              CSE039
     C                   CALLB     'SDSECD2VL'                                                CSE039
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                               CSE039
      * INPUTS                                                                                CSE039
                                                                                              CSE039
      * Response mode                                                                         CSE039
     C                   PARM      *BLANK        RespMode                                     CSE039
                                                                                              CSE039
      ** Security Details                                                                     CSE039
     C                   PARM                    CurSecDets                                   CSE039
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
                                                                                              CSE039
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041                                       CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042                                       CSE042
                                                                                              CSE039
      * OUTPUTS                                                                               CSE039
                                                                                              CSE039
      ** Security Details screen 2 OK inds                                                    CSE039
     C                   PARM                    OKSecDets2                                   CSE039
                                                                                              CSE039
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE039
     C                   PARM                    FldNameArr                                   CSE039
     C                   PARM                    MsgIDArr                                     CSE039
     C                   PARM                    MsgDtaArr                                    CSE039
                                                                                              CSE039
      * Array index (3P0) from/to caller                                                      CSE039
     C                   PARM                    Idx                                          CSE039
                                                                                              CSE039
      * Valid Securities Clients details layout (DS) from/to caller                           CSE039
     C                   PARM                    NwSdFilFmt                                   CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      * If errors returned                                                                    CSE039
      *                                                                                       CSE039
     C     Idx           IFNE      0                                                          CSE039
     C                   GOTO      EndVAL@F                                                   CSE039
     C                   END                                                                  CSE039
      *                                                                                       CSE039
      * If the screen has changed in the course of the validation                             CSE039
      * or if there are warnings which have not been displayed                                CSE039
      * re-display the screen                                                                 CSE039
      *                                                                                       CSE039
     C     CurSecDets    IFNE      PrvSecDets                                                 CSE039
     C                   GOTO      EndVAL@F                                                   CSE039
     C                   END                                                                  CSE039
      *                                                                                       CSE039
      * Clear any warning messages                                                            CSE039
      *                                                                                       CSE039
     C                   MOVE      *ALL'Y'       OKSecDets2                                   CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
     C                   MOVE      'U'           @SCRN                                        CSE039
                                                                                              CSE039
     C     EndVAL@F      ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * If action is insert, control return to key screen
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'Y'           INSERTENQ
     C                   END
      *
      * Default action code to enquiry if action insert or not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * Read next or previous record on customer file
      * according to command key taken (F7/@INKG or F8/@INKH)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'SDSECDRED'
      *
      * INPUT PARAMETERS :
 
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Securites client reference pointer
     C                   PARM                    DDCUSN
      * Read Forwards
     C                   PARM                    @RDFWD
      * Read Backwards
     C                   PARM                    @RDBCK
 
      * OUTPUT PARAMETERS :
 
      * Error message
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @data                                        249076
      * Securities client read
     C                   PARM      *BLANK        @SCRED
      *
 
      * If error message returned from read, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   END
 
      * If customer read
 
     C     @SCRED        IFNE      *BLANK
 
      * Retrieve customer details
 
     C                   MOVEL     @SCRED        DDCUSN
 
      * CSST field is used to test for blank/zeros customer in RTV module
     C                   MOVEL     DDCUSN        DDCSST
 
     C                   EXSR      RTVCUS
 
      * Return to previous screen if there is an error on customer/action
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
 
     C     INSERTENQ     IFEQ      'Y'
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
 
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * Convert Securities Clients Detail
     C                   EXSR      CVTCUS
     C                   MOVEL     CrSdFilFmt    NwSdFilFmt
      *
      * Put the Securities Clients Detail on screen
      *
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Set/reset return to key screen from primary details
     C                   MOVE      'N'           INSERTENQ
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB
      *
      * Build Browse subfile
     C                   CALLB     'SDSECDBRW'
 
      * INPUT PARAMETERS :
 
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Securities Clients Detail Reference Pointer
     C                   PARM                    DDCUSN
      * Build Sub-File
     C                   PARM      'Y'           @BDSFL
      * Read Subfile Record
     C                   PARM      *BLANKS       @RDSFL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
     C                   PARM      *BLANKS       @ERRMS
     C                   PARM      *BLANK        @data                                        249076
      * Option Selected
     C                   PARM      *BLANKS       @OPSEL
      * Customer Reference selected
     C                   PARM      *BLANKS       @CUSEL
      * Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
      *
 
 
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If Insert (F9) selected from browse, go to key screen
     C     @OPSEL        IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   MOVE      'I'           DDACTN
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
     C                   CALLB     'SDSECDBRW'
 
      * INPUT PARAMETERS :
 
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Securities Clients Detail Reference Pointer
     C                   PARM                    DDCUSN
      * Build Sub-File
     C                   PARM      *BLANKS       @BDSFL
      * Read Subfile Record
     C                   PARM      'Y'           @RDSFL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
     C                   PARM      *BLANKS       @ERRMS
     C                   PARM      *BLANK        @data                                      BUG16696
      * Option Selected
     C                   PARM      *BLANKS       @OPSEL
      * Customer Reference selected
     C                   PARM      *BLANKS       @CUSEL
      * Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
      *
      *
      * If Customer read from subfile
     C     @CUSEL        IFNE      *BLANK
      *
      * Retrieve Securities Clients Detail
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @CUSEL        DDCUSN
 
      * CSST field is used to test for blank/zeros customer in RTV module
     C                   MOVEL     DDCUSN        DDCSST
 
     C                   EXSR      RTVCUS
 
      * Stay on browse screen if there is an error on customer number
      *
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   GOTO      EndRDNBRW
     C                   ENDIF
      *
      * Convert Securities Clients Detail
     C                   EXSR      CVTCUS
     C                   MOVEL     CrSdFilFmt    NwSdFilFmt
      *
      * Put Securities Clients Detail detail screen
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
      *
      * Else, rebuild subfile browse
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * KBLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     KBLDBRW       BEGSR
 
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        K@RDNB
 
      * Build Browse subfile
     C                   CALLB     'SDSECDKBR'
 
      * INPUT PARAMETERS :
 
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Securities Clients Detail Reference Pointer
     C                   PARM                    DDCUSN
      * Build Sub-File
     C                   PARM      'Y'           @BDSFL
      * Read Subfile Record
     C                   PARM      *BLANKS       @RDSFL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
     C                   PARM      *BLANKS       @ERRMS
     C                   PARM      *BLANK        @data                                        249076
      * Option Selected
     C                   PARM      *BLANKS       @OPSEL
      * Customer Reference selected
     C                   PARM      *BLANKS       @CUSEL
      * New User Entry in Position/Select Fields
     C                   PARM      *BLANKS       KPosSelChg
      * Command Keys
     C                   PARM      '0'           @INKC
 
 
      * If F3 taken in browse, return to key screen
     C     @INKC         IFEQ      '1'
     C                   Eval      @SCRN = 'K'
     C                   GOTO      EndKBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to key screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@K
     C                   GOTO      EndKBLDBRW
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           K@RDNB
     C                   MOVEL     'S'           @SCRN
      *
     C     EndKBLDBRW    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * KRDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     KRDNBRW       BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'SDSECDKBR'
 
      * INPUT PARAMETERS :
 
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Securities Clients Detail Reference Pointer
     C                   PARM                    DDCUSN
      * Build Sub-File
     C                   PARM      *BLANKS       @BDSFL
      * Read Subfile Record
     C                   PARM      'Y'           @RDSFL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
     C                   PARM      *BLANKS       @ERRMS
      * Option Selected
     C                   PARM      *BLANKS       @OPSEL
      * Customer Reference selected
     C                   PARM      *BLANKS       @CUSEL
      * New User Entry in Position/Select Fields
     C                   PARM      *BLANKS       KPosSelChg
      * Command Keys
     C                   PARM      '0'           @INKC
      *
      *
      * Customer not read from subfile?
     C                   IF        @INKC = '1'
      *
      * Err: 'No selection' message
     C                   Eval      @ERRMS = 'USR5000'
     C                   EXSR      SNDM@K
     C                   Eval      DDCUSN=*BLANKS
     C                   Eval      @SCRN = 'K'
     C                   GOTO      EndKRDNBRW
 
     C                   ELSE
 
      * Rebuild browse subfile after Enter or position/select entry
     C                   IF        @OPSEL = *BLANKS
     C                   Eval      @SCRN = 'C'
     C                   GOTO      EndKRDNBRW
     C                   ENDIF
 
     C                   IF        @OPSEL <> '1'
 
      * Err: 'Value entered for field is not valid, enter a '1' to select'
     C                   Eval      @ERRMS = 'USR5001'
     C                   EXSR      SNDM@K
     C                   Eval      @SCRN = 'C'
     C                   GOTO      EndKRDNBRW
      *
     C                   ELSE
      *
      * Retrieve Customer
     C                   MOVEL     'I'           DDACTN
     C                   MOVEL     @CUSEL        DDCUSN
     C                   MOVEL     @CUSEL        WKCUST
     C                   MOVEL     *BLANKS       DDCSST
     C                   MOVEL     DDCUSN        DDCSSN
 
     C                   EXSR      RTVCUS
 
      * Return to key screen if there is an error on customer number
 
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'K'           @SCRN
     C                   GOTO      EndKRDNBRW
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      'K'           @SCRN
 
     C     EndKRDNBRW    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVCUS - Retrieve Securities Clients Detail
      *****************************************************************
     C     RTVCUS        BEGSR
      *
      * Retrieve Securities Clients Detail
      *
     C                   CALLB     'SDSECDRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      ModeofOp
      *
      * Response mode
     C                   PARM      'S'           RespMode
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    C_BFFRNT
      *
      * (Midas) Customer number
     C                   PARM                    DDCUSN
      *                                                                         154562
      * Key Screen Customer number / shortname entry
     C                   PARM                    DDCSST
      *                                                                         154562
      * OUTPUTS
      *
      * Securities Clients Details in File Format
     C                   PARM                    CrSdFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Customer Number
     C                   PARM      *BLANK        DDCUSNOK
      *
      ** Customer Shortname
     C                   PARM                    DDCSSN
 
      ** Customer Report Name
     C                   PARM                    DDCRNM
 
      ** Customer Report Town
     C                   PARM                    DDCRTN
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *
 
 
     C     EndRTVCUS     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTCUS - Put a Securities Clients Detail on Screen
      *****************************************************************
     C     CVTCUS        BEGSR
      *
      * Call program to fill screen fields with data from SDSECSPD
      *
     C                   CALLB     'SDSECDCVT'
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Securities Clients Details File Format
     C                   PARM                    CrSdFilFmt
      *
 
      * Output Parameters
 
      * Securities Clients Details Screen Format
     C                   PARM                    CurSecDets
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
 
      * Enable/disable function keys
 
      * KJ = Command Key F10 = CONFIRM DELETE
 
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
                                                                                              CSE022
      * Enable/disable function key F11 (Other Depot Reference)                               CSE022
                                                                                              CSE022
     C                   IF        CSE022 = 'Y' AND DDACTN <> 'D'                             CSE022
                                                                                              CSE022
     C                   MOVEL     'Y'           @EINKK                                       CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   MOVEL     'N'           @EINKK                                       CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO DETAIL SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
     C                   MOVEL     @data         MsgDtaArr(E)                                 249076
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@K - SEND A MESSAGE TO KEY SCREEN
      *****************************************************************
     C     SNDM@K        BEGSR
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@K     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@K - CANCEL ON KEY SCREEN
      *****************************************************************
     C     CANC@K        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     'B'           @SCRN
     C                   MOVEL     *BLANK        DDCSST
     C                   MOVEL     *BLANK        DDCUSN                                       CAAA03
      *
      * If input fields are enabled
      * Blank the screens
      *
     C                   MOVEL     *BLANK        CurSecDets
      *
      * Initialize field status on Key Screen
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * Return to previous screen
     C                   MOVEL     *BLANK        DDCSST
     C                   MOVEL     *BLANK        DDCUSN
      *
     C     INSERTENQ     IFEQ      'Y'
     C                   MOVE      'I'           DDACTN
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      * CANC@F - CANCEL ON SECOND SCREEN                                                      CSE039
      *****************************************************************                       CSE039
     C     CANC@F        BEGSR                                                                CSE039
      *                                                                                       CSE039
      * Return to previous screen                                                             CSE039
     C                   MOVEL     'P'           @SCRN                                        CSE039
      *                                                                                       CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
 
      * Update valid customer: customer reference
     C                   MOVEL     DDCUSN        SECUST
     C                   MOVEL     DDACTN        SETYLC
 
      ** Carry forward non-validated screen field values to valid file
     C                   Eval      SESRCD = @DDSRCD
     C                   Eval      SENARR = @DDNARR
 
     C     DDACTN        IFEQ      'A'
 
      ** Carry forward number of trades value to valid file field
     C                   Eval      SENTFC = C_BFNTFC
     C                   Eval      SETMES = C_BFTMST
 
     C                   ELSE
 
     C     DDACTN        IFEQ      'I'
 
      ** Initialise number of trades field for Insert
     C                   Eval      SENTFC = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     *BLANK        @RTCD
 
      * Securities Clients Details Updates
 
     C                   CALLB     'SDSECDUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwSdFilFmt
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program. Otherwise, commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   END
      *
      * If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO INSERT KEY SCREEN OR BROWSE SBFILE
      *
     C     DDACTN        IFEQ      'I'
     C                   Eval      @ERRMS = 'USR5002'
     C                   EXSR      SNDM@K
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     WSCRN         @SCRN
     C                   ENDIF
     C                   ENDIF
      *
     C     @CALLP        IFEQ      'CUSD'
     C                   MOVEL     'T'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       209867
      ** Issue rollback to clear any possible updates in window function                      209867
      *                                                                                       209867
     C                   ROLBK                                                                209867
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     *BLANK        DDCUSN
      *
      * Blank the screens
      *
     C                   MOVEL     *BLANK        CurSecDets
      *
      * Browse Screen
      *
     C                   MOVEL     'B'           @SCRN
     C                   MOVEL     'B'           WSCRN             1
      *
      * Initialize field status on Key Screen
      *
     C                   ENDSR
      *****************************************************************                       CSE022
      /EJECT                                                                                  CSE022
      *****************************************************************                       CSE022
      * SRDepRef - Other Depot Reference                                                      CSE022
      *****************************************************************                       CSE022
                                                                                              CSE022
     C     SRDepRef      BEGSR                                                                CSE022
                                                                                              CSE022
      ** If classification is 'E' or 'C' F11 not allowed.                                     CSE022
                                                                                              CSE022
     C                   IF        @DDCLAS = 'C' OR @DDCLAS = 'E'                             CSE022
     C                   EVAL      @ERRMS = 'USR9117'                                         CSE022
     C                   EXSR      SNDM@K                                                     CSE022
     C                   GOTO      ESRDepRef                                                  CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   IF        CurSecDets <> PrvSecDets                                   CSE022
                                                                                              CSE022
     C                   EXSR      VAL@P                                                      CSE022
                                                                                              CSE022
     C                   MOVE      'P'           @SCRN                                        CSE022
                                                                                              CSE022
      ** If errors returned                                                                   CSE022
                                                                                              CSE022
     C     Idx           IFNE      0                                                          CSE022
     C                   GOTO      ESRDepRef                                                  CSE022
     C                   ENDIF                                                                CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
      ***Check*if*all*ten*depot*reference*has*been*entered.************                CSE022 204747
                                                                                              CSE022
     C**********         EVAL      WkCnt = 1                                           CSE022 204747
     C**********         DOW       WkCnt <= 10                                         CSE022 204747
                                                                                              CSE022
     C**********         IF        DepotSn(WkCnt) = *BLANKS                            CSE022 204747
     C**********         EVAL      @ERRMS = 'USR9117'                                  CSE022 204747
     C**********         EXSR      SNDM@K                                              CSE022 204747
     C**********         GOTO      ESRDepRef                                           CSE022 204747
     C**********         ENDIF                                                         CSE022 204747
     C**********         EVAL      WkCnt = WkCnt + 1                                   CSE022 204747
                                                                                              CSE022
     C**********         ENDDO                                                         CSE022 204747
                                                                                              CSE022
     C                   CALL      'SDC100001'                                                CSE022
     C                   PARM                    DDACTN                                       CSE022
     C                   PARM                    CurSecDets                                   CSE022
     C                   PARM      *BLANKS       PRTCD                                        CSE022
     C                   PARM                    PModeOfOp                                    CSE022
                                                                                              CSE022
     C                   IF        PRTCD = 'SDA0002'                                          CSE022
                                                                                              CSE022
     C                   EXSR      ENDP                                                       CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C     ESRDepRef     ENDSR                                                                CSE022
                                                                                              CSE022
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
      * INPUTS
      *
      * SECURITIES CUSTOMER NUMBER
      *
     C                   PARM                    DDCUSN            6
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSECDSIN'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CSE022
      ** Access SAR details file to determine if CSE022                                       CSE022
      ** (Depository Definition Enhancement) is on                                            CSE022
                                                                                              CSE022
     C                   CALLB     'AOSARDR0'                                                 CSE022
     C                   PARM      *BLANKS       @RTCD                                        CSE022
     C                   PARM      '*VERIFY'     @OPTN                                        CSE022
     C                   PARM      'CSE022'      @SARD                                        CSE022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE022
                                                                                              CSE022
      ** Database Error                                                                       CSE022
                                                                                              CSE022
     C                   IF        @RTCD <> *BLANKS AND                                       CSE022
     C                             @RTCD <> '*NRF   '                                         CSE022
                                                                                              CSE022
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE022
     C                   MOVEL     '902'         DBASE                                        CSE022
     C                   MOVEL     'CSE022'      DBKEY                                        CSE022
     C                   EXSR      *PSSR                                                      CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   IF        @RTCD = *BLANKS                                            CSE022
                                                                                              CSE022
     C                   EVAL      CSE022 = 'Y'                                               CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   EVAL      CSE022 = 'N'                                               CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE039
      ** Access SAR details file to determine if CSE039                                       CSE039
      ** (Automatic Setllement of Trades) is on                                               CSE039
                                                                                              CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
      *                                                                                       CSE039
     C                   IF        @RTCD = *BLANKS                                            CSE039
     C                   EVAL      CSE039 = 'Y'                                               CSE039
     C                   ELSE                                                                 CSE039
     C                   EVAL      CSE039 = 'N'                                               CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE041
      ** Access SAR details file to determine if CSE041                                       CSE041
      ** (DVP/RVP Processing) is on                                                           CSE041
                                                                                              CSE041
     C                   CALLB     'AOSARDR0'                                                 CSE041
     C                   PARM      *BLANKS       @RTCD                                        CSE041
     C                   PARM      '*VERIFY'     @OPTN                                        CSE041
     C                   PARM      'CSE041'      @SARD                                        CSE041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE041
      *                                                                                       CSE041
     C                   IF        @RTCD = *BLANKS                                            CSE041
     C                   EVAL      CSE041 = 'Y'                                               CSE041
     C                   ELSE                                                                 CSE041
     C                   EVAL      CSE041 = 'N'                                               CSE041
     C                   ENDIF                                                                CSE041
                                                                                              CSE042
      ** Access SAR details file to determine if CSE042                                       CSE042
      ** (Auto Feed of Trades and Movements) is on                                            CSE042
                                                                                              CSE042
     C                   CALLB     'AOSARDR0'                                                 CSE042
     C                   PARM      *BLANKS       @RTCD                                        CSE042
     C                   PARM      '*VERIFY'     @OPTN                                        CSE042
     C                   PARM      'CSE042'      @SARD                                        CSE042
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE042
      *                                                                                       CSE042
     C                   IF        @RTCD = *BLANKS                                            CSE042
     C                   EVAL      CSE042 = 'Y'                                               CSE042
     C                   ELSE                                                                 CSE042
     C                   EVAL      CSE042 = 'N'                                               CSE042
     C                   ENDIF                                                                CSE042
      *
     C     DDCUSN        IFNE      *blank
     C     DDACTN        ANDNE     ' '
     C                   MOVEL     ' '           WSCRN             1
     C                   MOVEL     ' '           @SCRN             1
     C                   MOVEL     'CUSD'        @CALLP            4
      *
      * Clear DS parameter arrays and go to detail screen
     C                   CLEAR                   NwSdFilFmt
     C                   CLEAR                   CrSdFilFmt
     C                   CLEAR                   CurSecDets
     C                   MOVE      *ALL'Y'       OKSecDets
      *
     C                   ELSE
      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
     C                   MOVEL     'SECD'        @CALLP            4
     C                   ENDIF
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSECDS010
 
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
