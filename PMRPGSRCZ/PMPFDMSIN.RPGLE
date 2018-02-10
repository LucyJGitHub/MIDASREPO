     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio definition input')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMSIN - Portfolio Definition Input                       *
      *                                                               *
      *  Function: This is the main screen input function for         *
      *            Portfolio Definitions.                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 205131             Date 25Jul02               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  205131 - Do not default Investment and Management Type.      *
      *           They are now setup in Touch Of Finance.             *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,PMPFDMS001
      *
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
     D MaxChrgArr      C                   CONST(10)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Override Database Table                                                CPB002
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)            CPB002
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     D NwDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
      *
      ** Primary details screen fields
     D  NwDetailScrn          16    108
      *
      ** Portfolio Definition Details - for file update
     D NwDfFilFmt    E DS                  EXTNAME(PMVPFDMPD)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     D CrDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
     D                                     PREFIX(P)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     D CrDfFilFmt    E DS                  EXTNAME(PMPORTPD)
      *
      ** REVIEW FROM Customer and Portfolio Reference fields
     D DDREVIEW        DS
     D  DDPNP8                 1      6
     D  DDPORT                 7     10
      *
      ** Investment Policy Indicators - screen
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
     D NwInvest        DS
     D  DDIPIN                 1      1
     D  DDCYIN                 2      2
     D  DDYPIN                 3      3
     D  DDNPIN                 4      4
      *
      ** Investment Policy Indicators - hidden
     D Invest_H        DS
     D  DDIPIH                 1      1
     D  DDCYIH                 2      2
     D  DDYPIH                 3      3
     D  DDNPIH                 4      4
      *
      ** Portofolio Definition Error indicators
     D PMEPMD        E DS                  EXTNAME(PMEPFDMPD)
     D  PMEPMD_KEY             1      3
 
      *
      ** New Portfolio Charges header details - screen format
     D***NwChrgScrnH     DS            21                                                     CGL029
     D NwChrgScrnH     DS            27                                                       CGL029
      *
      ** Original Portfolio Charges header details - screen format
     D***CrChrgScrnH     DS            21                                                     CGL029
     D CrChrgScrnH     DS            27                                                       CGL029
      *
      ** New Portfolio Charges details array - screen format
     D NwChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** Original Portfolio Charges details array - screen format
     D CrChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** DS for Portfolio Charges screen fields - detail
     D ChrgScrnD       DS
     D  DDCGCO                 1      2
     D  DDCGSP                 3     16
     D  DDCGSI                17     17
     D  DDCGEI                18     18
     D  DDCGFQ                19     19
     D  DDCGDY                20     21
     D  DDCGND                22     27
     D  DDCGST                28     28
     D  DDCSFQ                29     29
     D  DDCSDY                30     31
     D  DDCSND                32     37
     D  DDPRFC                38     41
      *
     D  DDVALD                42     42
     D  DDCGCH                43     44
     D  DDCGSH                45     57  0
     D  DDCGEH                58     58
     D  DDCGLH                59     63  0
     D  DDCGDH                64     65
     D  DDCGNH                66     70  0
     D  DDCGFH                71     71
     D  DDCSFH                72     72
     D  DDCSDH                73     74
     D  DDCSNH                75     79  0
     D  DDCGTH                80     80
     D  DDPRFH                81     84
      *
      ** Portfolio Charges details array - for file update
     D NwChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Original Portfolio Charges details array - file format
     D CrChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** Error indicators - charges header
     D PMEPMC          DS
     D  OKBCGY                 1      1
     D  OKCSCY                 2      2
     D  OKCUSA                 3      3
     D  OKBRCA                 4      4
      *
      ** DS for Error indicators - charges details
     D PMEPMCD         DS
     D  OKCGCO                 1      1
     D  OKCGSP                 2      2
     D  OKCGSI                 3      3
     D  OKCGEI                 4      4
     D  OKCGFQ                 5      5
     D  OKCGDY                 6      6
     D  OKCGND                 7      7
     D  OKCGST                 8      8
     D  OKCSFQ                 9      9
     D  OKCSDY                10     10
     D  OKCSND                11     11
     D  OKPRFC                12     12
      *
      ** Error indicators array - charges details
     D PMEPMCArr       S                   DIM(MaxChrgArr)
     D                                     LIKE(PMEPMCD)
      *
      ** Incoming Extra Data
     D PExtData      E DS                  EXTNAME(PMPFEXPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Portfolio Details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      *
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Custody Fees
     D SDSCFE        E DS                  EXTNAME(SDSCFEPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data Structure for last update
     D WLUP            DS
     D   WDLUP                 1      2  0
     D   WMLUP                 3      5
     D   WYLUP                 6      7  0
      *
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PRespMode       S              1A   INZ('S')
      *
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CSC011
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,PMPFDMS002
      *
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
      *
      /COPY WNCPYSRC,PMPFDMS003
      *
      ** Read next browse subfile record.
      *
     C     WSCRN         IFEQ      'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMS004
      *
      ** DO WHILE screen: Initial details screen
      *
     C     WSCRN         DOWEQ     'I'
     C                   EXSR      SRScrn_I
     C                   ENDDO
      *
      /COPY WNCPYSRC,PMPFDMS005
      *
      ** DO WHILE screen: Primary details screen
      *
     C     WSCRN         DOWEQ     'P'
     C                   EXSR      SRScrn_P
     C                   ENDDO
      *
      /COPY WNCPYSRC,PMPFDMS006
      *
      ** DO WHILE Screen: Charges details
      *
     C     WSCRN         DOWEQ     'C'
     C                   EXSR      SRScrn_C
     C                   ENDDO
      *
      /COPY WNCPYSRC,PMPFDMS007
      *
      ** Screen: Confirmation of input
      *
     C     WSCRN         IFEQ      'F'
     C                   EXSR      SRScrn_F
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMS008
      *
      ** Do file updates.
      *
     C     WSCRN         IFEQ      'U'
     C                   EXSR      SRUpdats
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMS009
      *
      ** Terminate Program.
      *
     C     WSCRN         IFEQ      'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,PMPFDMS010
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
      *
     C     SRRdNBrw      BEGSR
      *
     C                   CALLB     'PMPFDMBRW'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Customer
     C                   PARM      *BLANKS       DDCSNM
      *
      ** Portfolio Reference
     C                   PARM      *BLANKS       DDPREF
      *
      ** REVIEW FROM Customer
     C                   PARM      *BLANKS       DDPNP8
      *
      ** REVIEW FROM Portfolio Reference
     C                   PARM      *BLANKS       DDPORT
      *
      ** Build subfile
     C                   PARM      *BLANK        PBDSFL            1
      *
      ** Read subfile record
     C                   PARM      'Y'           PRDSFL            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PERRMS            7
      *
      ** Option selected
     C                   PARM                    POPSEL            1
      *
      ** Customer Number selected
     C                   PARM                    PCSSEL           10
      *
      ** Portfolio Reference selected
     C                   PARM                    PPRSEL            4
      *
      ** Command keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
      *
      ** If no Portfolio Definition read from subfile, reset
      ** Read Next Browse Subfile Record indicator and then
      ** display initial screen with blank key fields.
      *
     C     POPSEL        IFEQ      *BLANK
     C                   MOVEL     *BLANK        PRDNB
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
      *
     C                   goto      ESRRDNBRW
     C                   ENDIF
      *
      ** Update action code with option selected.
      *
     C                   MOVEL     POPSEL        DDACTN
      *
      ** Default action code to enquiry if not valid.
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
      ** Retrieve Portfolio Definition details.
      *
     C                   MOVEL     PCSSEL        DDCSNM
     C                   MOVEL     PPRSEL        DDPREF
     C                   MOVEL     *BLANKS       DDREVIEW
      *
     C                   EXSR      SRRtvDef
      *
      ** If errors occurred in the retrieve module, display
      ** error messages on the initial screen.
      *
     C     Idx           IFGT      1
     C     Idx           OREQ      1
     C     MsgIdArr(1)   ANDNE     'APM1000'
      *
     C                   MOVEL     'I'           WSCRN
      *
     C                   goto      ESRRDNBRW
     C                   ENDIF
      *
      ** Put the Portfolio Definition details on the primary screen.
      *
     C                   EXSR      SRPutD_P
     C                   MOVEL     CrDfScnFmt    NwDfScnFmt
      *
      ** Update hidden Investment Policy Indicators.  (The different
      ** Investment Policy details screens are to be displayed if
      ** the values of the indicators on the primary details screen
      ** are different from the values of these fields.)
      *
     C                   MOVEL     NwInvest      Invest_H
      *
      ** If action code is not Insert, put the Portfolio Definition
      ** details retrieved from the master database file into the
      ** update file record.
      *
     C     DDACTN        IFNE      'I'
     C                   MOVEL     CrDfFilFmt    NwDfFilFmt
     C                   ENDIF
      *
      ** If action code is Insert, initialise Portfolio
      ** Definition for file update and default Date Opened
      ** to rundate.
      *
     C     DDACTN        IFEQ      'I'
     C                   CLEAR                   NwDfFilFmt
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C**********         Z-ADD     BJRDNB        P1PNDPOP                                     CSC011
     C**********         Z-ADD     BJRDNB        PNDPOP                                       CSC011
     C                   Z-ADD     WRunDay       P1PNDPOP                                     CSC011
     C                   Z-ADD     WRunDay       PNDPOP                                       CSC011
      *
     C**********         Z-ADD     *ZERO         P1PNMGTP                                     205131
     C**********         Z-ADD     *ZERO         P1PNINTP                                     205131
     C                   ENDIF
      *
      ** Set up Portfolio Charges screen and file arrays only if
      ** customer is a Portfolio Management Customer, and action
      ** code is not Closure.
      *
     C     PMCUST        IFEQ      'Y'
     C     DDACTN        ANDNE     'C'
     C                   EXSR      SRChrg
     C                   ENDIF
      *
      ** Go to primary details screen.
      *
     C                   MOVEL     'P'           WSCRN
      *
     C     ESRRDNBRW     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_I - Process initial screen                            *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_I      BEGSR
      *
      ** Set up error indicators for initial screen.
      *
     C                   EVAL      PMEPMD_IDSP = PMEPMD_KEY + OKREVIEW
      *
      ** Display initial screen.
      *
     C                   CALLB     'PMPFDM2DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Key fields (Action Code, Customer and Portfolio Reference)
     C                   PARM                    DDACTN
     C                   PARM                    DDCSNM
     C                   PARM                    DDPREF
      *
      ** Review From fields (Customer and Portfolio Reference)
     C                   PARM                    DDREVIEW
      *
      ** OK indicators (key fields and Review From fields)
     C                   PARM                    PMEPMD_IDSP       4
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESETERR
      *
      ** Blank out primary details screen fields.
      *
     C                   MOVE      *BLANKS       PDDDELT
     C                   MOVE      *BLANKS       NwDetailScrn
      *
     C                   SELECT
      *
      ** F3 - End Program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SRENDP
      *
      ** F7 - Roll Backwards.
      *
     C     PINKG         WHENEQ    '1'
     C                   EXSR      SRROLL
      *
      ** F8 - Roll Forwards.
      *
     C     PINKH         WHENEQ    '1'
     C                   EXSR      SRROLL
      *
      ** F12 - Read next subfile record or redisplay initial screen
      ** with blank key fields.
      *
     C     PINKL         WHENEQ    '1'
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDPNP8
     C                   MOVEL     *BLANKS       DDPORT
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
      ** F15 - Build Browse.
      *
     C     PINKP         WHENEQ    '1'
     C                   EXSR      SRBLDBRW
      *
      ** ENTER - Validate input to initial screen.
      *
     C                   OTHER
     C                   EXSR      SRVal_I
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_I - Validate input to initial screen                   *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_I       BEGSR
      *
      ** Validate key and REVIEW FROM fields.
      ** Retrieve Portfolio Definition details if no errors found in
      ** key fields and action code is not Insert.
      *
     C                   EXSR      SRRtvDef
      *
      ** If action code, customer, portfolio reference or REVIEW FROM
      ** fields are NOT OK, re-output initial screen with error
      ** messages on it.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCSNM        OREQ      'N'
     C     OKPREF        OREQ      'N'
     C     OKREVIEW      OREQ      'N'
      *
     C                   goto      ESRVal_I
     C                   ENDIF
      *
      ** If browse pointer was set (REVIEW FROM was supplied),
      ** then proceed to browse screen.
      *
     C     DDPNP8        IFNE      *BLANKS
      *
     C                   EXSR      SRBldBrw
      *
     C                   goto      ESRVal_I
     C                   ENDIF
      *
      ** If action code is not Insert, put the Portfolio Definition
      ** on the primary details screen.
      *
     C     DDACTN        IFNE      'I'
      *
     C                   EXSR      SRPutD_P
     C                   MOVEL     CrDfScnFmt    NwDfScnFmt
      *
     C                   ELSE
      *
      ** Else, if action code is insert, put default values for
      ** Date Opened and Investment Policy Indicators on the
      ** primary details screen.
      *
     C                   MOVEL     WRUNDATE      DDDPOP            6
     C                   MOVE      'N'           DDIPIN
     C                   MOVE      'N'           DDCYIN
     C                   MOVE      'N'           DDYPIN
     C                   MOVE      'N'           DDNPIN
      *
     C                   ENDIF
      *
      ** Update hidden Investment Policy Indicators.  (The different
      ** Investment Policy details screens are to be displayed if
      ** the values of the indicators on the primary details screen
      ** are different from the values of these fields.)
      *
     C                   MOVEL     NwInvest      Invest_H
      *
      ** If action code is not Insert, put the Portfolio Definition
      ** details retrieved from the master database file into the
      ** update file record.
      *
     C     DDACTN        IFNE      'I'
     C                   MOVEL     CrDfFilFmt    NwDfFilFmt
     C                   ENDIF
      *
      ** If action code is Insert, initialise Portfolio
      ** Definition for file update and default Date Opened
      ** to rundate.
      *
     C     DDACTN        IFEQ      'I'
     C                   CLEAR                   NwDfFilFmt
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C**********         Z-ADD     BJRDNB        P1PNDPOP                                     CSC011
     C**********         Z-ADD     BJRDNB        PNDPOP                                       CSC011
     C                   Z-ADD     WRunDay       P1PNDPOP                                     CSC011
     C                   Z-ADD     WRunDay       PNDPOP                                       CSC011
     C                   ENDIF
      *
      ** Set up Portfolio Charges screen and file arrays only if
      ** customer is a Portfolio Management Customer, and action
      ** code is not Closure.
      *
     C     PMCUST        IFEQ      'Y'
     C     DDACTN        ANDNE     'C'
     C                   EXSR      SRChrg
     C                   ENDIF
      *
      ** Go to primary details screen.
      *
     C                   MOVEL     'P'           WSCRN
      *
     C     ESRVal_I      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_P - Process primary details screen                    *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_P      BEGSR
      *
      ** Enable/disable detail fields on primary details screen
      ** (key fields = action code, customer & Portfolio reference;
      ** detail fields = rest).
      ** (Action code can only be 'I', 'A', 'C' or 'E'.)
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           PEDTFD
     C                   ELSE
     C                   MOVEL     'N'           PEDTFD
     C                   ENDIF
      *
      ** Enable/disable Portfolio Date Closed field.
      *
     C     DDACTN        IFEQ      'C'
     C                   MOVEL     'Y'           PEDT_DPCL
     C                   ELSE
     C                   MOVEL     'N'           PEDT_DPCL
     C                   ENDIF
      *
      ** Condition function keys F1 (Charges) and F24 (Notepad)
      ** against PM Customer or closure request.
      *
     C     PMCUST        IFNE      'Y'
     C     DDACTN        OREQ      'C'
     C                   MOVEL     'N'           PEINKA
     C                   MOVEL     'N'           PEINKY
     C                   ELSE
     C                   MOVEL     'Y'           PEINKA
     C                   MOVEL     'Y'           PEINKY
     C                   ENDIF
      *
      ** Write/read display screen.
      *
     C                   CALLB     'PMPFDM3DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators - screen
     C                   PARM                    NwInvest
      *
      ** Portfolio Date Opened in screen format
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT
      *
      ** Enable Portfolio Date Closed field
     C                   PARM                    PEDT_DPCL         1
      *
      ** Display Investment Policy Indicators
     C                   PARM      'Y'           PSIN80            1
      *
      ** Enable detail fields
     C                   PARM                    PEDTFD            1
      *
      ** Enabled function keys
      ** KA = Command key 01 = PORTFOLIO CHARGES
      ** KG = Command Key 07 = READ PREVIOUS
      ** KH = Command Key 08 = READ NEXT
      ** KP = Command Key 15 = BROWSE
      ** KY = Command key 24 = NOTEPAD
     C                   PARM                    PEINKA            1
     C                   PARM      'Y'           PEINKG            1
     C                   PARM      'Y'           PEINKH            1
     C                   PARM      'Y'           PEINKP            1
     C                   PARM                    PEINKY            1
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           PINKA             1
     C                   PARM      '0'           PINKC             1
     C                   PARM      '0'           PINKG             1
     C                   PARM      '0'           PINKH             1
     C                   PARM      '0'           PINKL             1
     C                   PARM      '0'           PINKP             1
     C                   PARM      '0'           PINKY             1
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESETERR
      *
      ** Blank out REVIEW FROM Customer and Portfolio Reference fields.
      *
     C                   MOVE      *BLANKS       DDREVIEW
      *
     C                   SELECT
      *
      ** F1 - Go to Charges screen.  If action is Insert or Amend,
      ** details entered on primary screen should have passed
      ** validation and investment policy details should have
      ** been processed already before the Charges screen is
      ** displayed.
      *
     C     PINKA         WHENEQ    '1'
      *
     C     DDACTN        IFNE      'E'
     C                   EXSR      SRVaL_P
      *
     C     IDx           IFEQ      0
     C                   MOVEL     'C'           WSCRN
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'C'           WSCRN
     C                   ENDIF
      *
      ** F3 - End program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SRENDP
      *
      ** F7 - Roll backwards.
      *
     C     PINKG         WHENEQ    '1'
     C                   EXSR      SRROLL
      *
      ** F8 - Roll forwards.
      *
     C     PINKH         WHENEQ    '1'
     C                   EXSR      SRROLL
      *
      ** F12 - Rollback changes to all details screens and then
      ** read next subfile record or display initial screen
      ** with blank key fields.
      *
     C     PINKL         WHENEQ    '1'
      *
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
      ** F15 - Build Browse screen.
      *
     C     PINKP         WHENEQ    '1'
     C                   EXSR      SRBLDBRW
      *
      ** F24 - Go to Notepad screen.
      *
     C     PINKY         WHENEQ    '1'
     C                   EXSR      SRNOTEPAD
      *
      ** ENTER - If action code is not enquire, validate details
      ** entered.  Else, display Investment Policy details
      ** screens.
      *
     C                   OTHER
      *
     C     DDACTN        IFNE      'E'
     C                   EXSR      SRVal_P
      *
     C                   ELSE
      *
     C                   EXSR      SRPolicy_E
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_P - Validate input to primary details screen           *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_P       BEGSR
      *
      ** Prior to validation, reset error fields.
      *
     C                   EXSR      SRRESETERR
      *
      ** If action code is Amend, validate whether non-amendable
      ** fields have been changed.
      *
     C     DDACTN        IFEQ      'A'
      *
     C                   CALLB     'PMPFDM2AD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    CrDfScnFmt
      *
      ** Date Opened retrieved from file
      ** - in screen format
     C                   PARM                    DDDPOP
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           RESETERRS         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Amendments OK
     C                   PARM                    AmendOK           1
      *
     C                   ENDIF
      *
      ** Validate Portfolio Definition details.
      *
     C                   CALLB     'PMPFDM2VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM                    PRespMode
      *
      ** Incoming Portfolio Definition Details - screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators - screen
     C                   PARM                    NwInvest
      *
      ** Incoming Extra Data
     C                   PARM                    PExtData
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    PNDPOP
      *
      ** Original Performance Start Date
     C                   PARM                    PNPSDT
      *
      ** Original Pledge Finish Date
     C                   PARM                    PNPDGF
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFMt
      *
      ** If errors exist, re-display primary details screen with
      ** error messages.
      *
     C     IDx           IFNE      0
      *
      ** If validation was called due to F1 (Charges screen),
      ** being pressed, output 'F1 is taken but errors exist'
      ** on the primary details screen.
      *
     C     PINKA         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'PM11401'
     C                   ENDIF
      *
     C                   goto      ESRVal_P
     C                   ENDIF
      *
      ** Process Investment Policy details if no errors and flags
      ** on the screen were changed.
      *
     C     Invest_H      IFNE      NwInvest
      *
     C                   EXSR      SRPolicy_A
     C                   ENDIF
      *
      ** Proceed to confirmation screen if validation was
      ** called by pressing ENTER (and not F1) and F3/F12
      ** not pressed on any Investment Policy screens.
      *
     C     PINKA         IFEQ      '0'
     C     WSCRN         ANDNE     'T'
     C     WSCRN         ANDNE     'I'
     C                   MOVEL     'F'           WSCRN
     C                   ENDIF
      *
     C     ESRVal_P      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPolicy_A - Process investment policy indicators for        *
      *               Amend                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRPolicy_A    BEGSR
      *
     C                   MOVEL     *BLANK        PW0170            1
     C                   MOVEL     *BLANK        PW0180            1
     C                   MOVEL     *BLANK        PW0190            1
     C                   MOVEL     *BLANK        PW0200            1
      *
      ** Instrument Investment Policy indicator
      *
     C     DDIPIH        IFNE      DDIPIN
      *
     C     DDIPIH        IFEQ      'Y'
     C     DDIPIN        ANDEQ     'N'
     C                   MOVEL     'D'           PW0170
     C                   ELSE
     C                   MOVEL     'A'           PW0170
     C                   ENDIF
     C                   ENDIF
      *
      ** Currency Investment Policy indicator
      *
     C     DDCYIH        IFNE      DDCYIN
      *
     C     DDCYIH        IFEQ      'Y'
     C     DDCYIN        ANDEQ     'N'
     C                   MOVEL     'D'           PW0180
     C                   ELSE
     C                   MOVEL     'A'           PW0180
     C                   ENDIF
     C                   ENDIF
      *
      ** Country of Risk Investment Policy indicator
      *
     C     DDYPIH        IFNE      DDYPIN
      *
     C     DDYPIH        IFEQ      'Y'
     C     DDYPIN        ANDEQ     'N'
     C                   MOVEL     'D'           PW0190
     C                   ELSE
     C                   MOVEL     'A'           PW0190
     C                   ENDIF
     C                   ENDIF
      *
      ** Industry Investment Policy indicator
      *
     C     DDNPIH        IFNE      DDNPIN
      *
     C     DDNPIH        IFEQ      'Y'
     C     DDNPIN        ANDEQ     'N'
     C                   MOVEL     'D'           PW0200
     C                   ELSE
     C                   MOVEL     'A'           PW0200
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRPol_Call
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPolicy_E - Process investment policy indicators for        *
      *               Enquire                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRPolicy_E    BEGSR
      *
     C                   MOVEL     *BLANK        PW0170
     C                   MOVEL     *BLANK        PW0180
     C                   MOVEL     *BLANK        PW0190
     C                   MOVEL     *BLANK        PW0200
      *
      ** Process Investment Policy indicators only if
      ** customer is a Portfolio Management Customer.
      *
     C     PMCUST        IFEQ      'Y'
      *
      ** Instrument Investment Policy indicator
      *
     C     DDIPIN        IFEQ      'Y'
     C                   MOVEL     'E'           PW0170
     C                   ENDIF
      *
      ** Currency Investment Policy indicator
      *
     C     DDCYIN        IFEQ      'Y'
     C                   MOVEL     'E'           PW0180
     C                   ENDIF
      *
      ** Country of Risk Investment Policy indicator
      *
     C     DDYPIN        IFEQ      'Y'
     C                   MOVEL     'E'           PW0190
     C                   ENDIF
      *
      ** Industry Investment Policy indicator
      *
     C     DDNPIN        IFEQ      'Y'
     C                   MOVEL     'E'           PW0200
     C                   ENDIF
      *
     C                   EXSR      SRPol_Call
      *
     C                   ENDIF
      *
      ** If all investment policy details have been shown, read
      ** next subfile record or display initial screen with
      ** blank key fields.  Do this, if F3 has not been
      ** pressed.
      *
     C     WSCRN         IFNE      'T'
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPol_Call - Display investment policy details screens       *
      *                                                               *
      *****************************************************************
      *
     C     SRPol_Call    BEGSR
      *
     C                   MOVEL     '0'           PWRTRN
     C                   MOVEL     *BLANK        PWPOLI
     C                   MOVEL     DDCSNM        PWCCNM
     C                   MOVEL     DDPREF        PWPTFR
     C                   Z-ADD     0             PWNEWT
      *
      ** Instrument Investment Policy screen
      *
     C     PW0170        IFNE      *BLANK
     C                   MOVEL     PW0170        PWACTO
     C                   MOVEL     'Y'           CALLED_0170       1
      *
     C                   CALL      'PM0170'      LIST2
      *
     C                   SELECT
      *
     C     PWRTRN        WHENEQ    '1'
     C                   EXSR      SREndP
     C                   goto      ESRPol_Call
      *
     C     PWRTRN        WHENEQ    '2'
     C                   EXSR      SRReturn
     C                   goto      ESRPol_Call
      *
     C                   OTHER
     C                   MOVEL     PWPOLI        DDIPIN
     C                   MOVEL     PWPOLI        DDIPIH
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** Currency Investment Policy screen
      *
     C     PW0180        IFNE      *BLANK
     C                   MOVEL     PW0180        PWACTO
     C                   MOVEL     'Y'           CALLED_0180       1
      *
     C                   CALL      'PM0180'      LIST2
      *
     C                   SELECT
      *
     C     PWRTRN        WHENEQ    '1'
     C                   EXSR      SREndP
     C                   goto      ESRPol_Call
      *
     C     PWRTRN        WHENEQ    '2'
     C                   EXSR      SRReturn
     C                   goto      ESRPol_Call
      *
     C                   OTHER
     C                   MOVE      PWPOLI        DDCYIN
     C                   MOVE      PWPOLI        DDCYIH
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** Country of Risk Investment Policy screen
      *
     C     PW0190        IFNE      *BLANK
     C                   MOVEL     PW0190        PWACTO
     C                   MOVEL     'Y'           CALLED_0190       1
      *
     C                   CALL      'PM0190'      LIST2
      *
     C                   SELECT
      *
     C     PWRTRN        WHENEQ    '1'
     C                   EXSR      SREndP
     C                   goto      ESRPol_Call
      *
     C     PWRTRN        WHENEQ    '2'
     C                   EXSR      SRReturn
     C                   goto      ESRPol_Call
      *
     C                   OTHER
     C                   MOVE      PWPOLI        DDYPIN
     C                   MOVE      PWPOLI        DDYPIH
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** Industry Investment Policy screen
      *
     C     PW0200        IFNE      *BLANK
     C                   MOVEL     PW0200        PWACTO
     C                   MOVEL     'Y'           CALLED_0200       1
      *
     C                   CALL      'PM0200'      LIST2
      *
     C                   SELECT
      *
     C     PWRTRN        WHENEQ    '1'
     C                   EXSR      SREndP
     C                   goto      ESRPol_Call
      *
     C     PWRTRN        WHENEQ    '2'
     C                   EXSR      SRReturn
     C                   goto      ESRPol_Call
      *
     C                   OTHER
     C                   MOVE      PWPOLI        DDNPIN
     C                   MOVE      PWPOLI        DDNPIH
      *
     C                   ENDSL
     C                   ENDIF
      *
     C     ESRPol_Call   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return from Investment Policy details screen      *
      *                                                               *
      *****************************************************************
      *
     C     SRReturn      BEGSR
      *
      ** Rollback changes to all details screens and then
      ** read next subfile record or display initial screen
      ** with blank key fields.
      *
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_C - Process Charges screen                            *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_C      BEGSR
      *
      ** Enable/disable detail fields on charges screen.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           PEDTFD
     C                   ELSE
     C                   MOVEL     'N'           PEDTFD
     C                   ENDIF
      *
      ** Write/read display screen.
      *
     C                   CALLB     'PMPFDM1DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Key Fields
      ** - Action Code
      ** - Customer Number
      ** - Portfolio Reference
     C                   PARM                    DDACTN
     C                   PARM                    DDCSNM
     C                   PARM                    DDPREF
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT
      *
      ** New Portfolio Charges header details - screen format
     C                   PARM                    NwChrgScrnH
      *
      ** New Portfolio Charges details array - screen format
     C                   PARM                    NwChrgScrnArr
      *
      ** Enable detail fields
     C                   PARM                    PEDTFD
      *
      ** Error indicators - charges header
     C                   PARM                    PMEPMC
      *
      ** Error indicators array - charges details
     C                   PARM                    PMEPMCArr
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           PINKA
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKY
      *
      ** Reset error fields.
      *
     C                   MOVE      *ALL'Y'       PMEPMC
     C                   MOVEA     *ALL'Y'       PMEPMCArr
     C                   EXSR      SRRESETERR
      *
     C                   SELECT
      *
      ** F1 - Go to primary screen.  If action is Insert or Amend,
      ** details entered on charges screen should have passed
      ** validation before the primary screen is diplayed.
      *
     C     PINKA         WHENEQ    '1'
      *
     C     DDACTN        IFNE      'E'
     C                   EXSR      SRVaL_C
      *
     C     IDx           IFEQ      0
     C                   MOVEL     'P'           WSCRN
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'P'           WSCRN
     C                   ENDIF
      *
      ** F3 - End program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SRENDP
      *
      ** F12 - Rollback changes to all details screens and then
      ** read next subfile record or display initial screen
      ** with blank key fields.
      *
     C     PINKL         WHENEQ    '1'
      *
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
      ** F24 - Go to Notepad screen.
      *
     C     PINKY         WHENEQ    '1'
     C                   EXSR      SRNOTEPAD
      *
      ** ENTER - If action code is not enquire, validate details
      ** entered.  Else, read next subfile record or display
      ** initial screen with blank key fields.
      *
     C                   OTHER
      *
     C     DDACTN        IFNE      'E'
     C                   EXSR      SRVal_C
      *
     C                   ELSE
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_C - Validate input to charges details screen           *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_C       BEGSR
      *
      ** Prior to validation, initialise error fields.
      *
     C                   MOVE      *ALL'Y'       PMEPMC
     C                   MOVEA     *ALL'Y'       PMEPMCArr
     C                   EXSR      SRRESETERR
      *
      ** Validate whether non-amenable fields have been changed.
      *
     C                   CALLB     'PMPFDM1AD'
      *                             ==========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** New Portfolio Charges header details - screen format
     C                   PARM                    NwChrgScrnH
      *
      ** Original Portfolio Charges header details - screen format
     C                   PARM                    CrChrgScrnH
      *
      ** Charge Exists flag
     C                   PARM                    ChrgExists
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           RESETERRS
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Charges header fields OK indicators
     C                   PARM                    PMEPMC
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Amendments OK
     C                   PARM                    AmendOk
      *
      ** Validate Charges details.
      *
     C                   CALLB     'PMPFDM1VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM                    PRespMode
      *
      ** Customer - incoming
     C                   PARM                    DDCSNM
      *
      ** New Portfolio Charges header details - screen format
     C                   PARM                    NwChrgScrnH
      *
      ** New Portfolio Charges details array - screen format
     C                   PARM                    NwChrgScrnArr
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Base Currency
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Single Branch code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Multi-branching Indicator
     C                   PARM                    BGMBIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFLDNAMARR
     C                   PARM                    WMSGIDARR
     C                   PARM                    WMSGDTAARR
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDX
      *
      ** Error indicators - charges header
     C                   PARM                    PMEPMC
      *
      ** Error indicators array - charges details
     C                   PARM                    PMEPMCArr
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFMt
      *
      ** Portfolio Charges details array - for file update
     C                   PARM                    NwChrgFileArr
      *
      ** If errors exist, re-display charges details screen with
      ** error messages.
      *
     C     IDx           IFNE      0
      *
      ** If validation was called due to F1 (primary screen),
      ** being pressed, output 'F1 is taken but errors exist'
      ** on the charges details screen.
      *
     C     PINKA         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'PM11401'
     C                   ENDIF
      *
     C                   goto      ESRVal_C
     C                   ENDIF
      *
      ** Proceed to confirmation screen if validation was
      ** called by pressing ENTER (and not F1).
      *
     C     PINKA         IFEQ      '0'
     C                   MOVEL     'F'           WSCRN
     C                   ENDIF
      *
     C     ESRVal_C      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_F - Process confirmation screen                       *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_F      BEGSR
      *
      ** Transaction is valid or only warnings exist.  Output warning
      ** messages before the message "Press enter to apply transaction
      ** to database or F12 to change".
      *
     C                   Z-ADD     1             Ix                3 0
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         70
     C                   MOVEL     '*ANY'        WFldNamArr(Ix)
     C                   MOVEL     'MMM1031'     WMsgIdArr(Ix)
      *
      ** Write/read display screen.
      *
     C                   CALLB     'PMPFDM3DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators - screen
     C                   PARM                    NwInvest
      *
      ** Date Opened in screen format
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT
      *
      ** Enable Portfolio Date Closed field
     C                   PARM      'N'           PEDT_DPCL
      *
      ** Display Investment Policy Indicators
     C                   PARM      'Y'           PSIN80
      *
      ** Enable detail fields
     C                   PARM      'N'           PEDTFD
      *
      ** Enable function keys
     C                   PARM      'N'           PEINKA
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKP
     C                   PARM      'N'           PEINKY
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           PINKA
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
     C                   PARM      '0'           PINKY
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   SELECT
      *
      ** F3 - End program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SRENDP
      *
      ** F12 - Return to primary details screen.
      *
     C     PINKL         WHENEQ    '1'
     C                   MOVEL     'P'           WSCRN
      *
      ** ENTER - Update records.
      *
     C                   OTHER
     C                   MOVEL     'U'           WSCRN
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATS - Files update                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdats      BEGSR
      *
      ** Set Details for Insert.
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'D'           P1PNRECI
     C                   MOVEL     DDCSNM        P1PNCNUM
     C                   MOVEL     DDPREF        P1PNPTFR
     C                   ENDIF
      *
      ** Set Details for Insert, Amend and Closure.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   EVAL      WLUP = BJMRDT
     C                   EVAL      P1PNDLUP = WDLUP
     C                   EVAL      P1PNMLUP = WMLUP
     C                   EVAL      P1PNYLUP = WYLUP
     C                   EVAL      P1PNTLUP = PSRUNTIME
     C                   EVAL      P1PNLCD  = BJRDNB
     C                   EVAL      P1PNTNLU = *ZERO
      *
     C                   EVAL      P1PNIPIN = DDIPIN
     C                   EVAL      P1PNCYIN = DDCYIN
     C                   EVAL      P1PNYPIN = DDYPIN
     C                   EVAL      P1PNNPIN = DDNPIN
     C                   ENDIF
      *
      ** Move action code to last change type to affect changes.
      *
     C                   EVAL      P1PNCHTP = DDACTN
      *
      ** Update Portfolio Definitions file.
      *
     C                   CALLB     'PMPFDMUPD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       PRTCD             7
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *                                                                         CPB002
      ** SDMMOD - Private Banking                                               CPB002
     C                   PARM                    BGN4ST                         CPB002
      *
      ** If no errors, action code is not Closure and customer is a PM
      ** Customer, then update Portfolio Charges file.
      ** Charges file.
      *
     C     PRTCD         IFEQ      *BLANKS
     C     DDACTN        ANDNE     'C'
     C     PMCUST        ANDEQ     'Y'
      *
     C                   EXSR      SRSetChgUpd
      *
      ** Update Portfolio Charges file.
      *
     C                   CALLB     'PMPFDMUPH'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       PRTCD
      *
      ** Charges details array - for file update
     C                   PARM                    NwChrgFileArr
      *
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation, send message to screen.
      *
     C
     C     PRTCD         IFEQ      '*RECUPD'
     C                   Z-ADD     1             Idx
     C                   Eval      FldNameArr(Idx) = '*ANY'
     C                   Eval      MsgIdArr(Idx) = 'APM1000'
     C                   ENDIF
      *
      ** Read next subfile record or display initial screen
      ** with blank key fields.
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     'I'           WSCRN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetChgUpd - Set charges fields for update                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSetChgUpd   BEGSR
      *
     C                   Z-ADD     1             WCntr             2 0
      *
     C     WCntr         DOUGT     MaxChrgArr
      *
     C                   CLEAR                   PMCHRG
     C                   EVAL      PMCHRG = NwChrgFileArr(Wcntr)
      *
     C                   EVAL      PORECI = 'D'
     C                   EVAL      POLCD  = BJRDNB
     C                   EVAL      PODLUP = WDLUP
     C                   EVAL      POMLUP = WMLUP
     C                   EVAL      POYLUP = WYLUP
     C                   EVAL      POTLUP = PSRUNTIME
     C                   EVAL      POTNLU = *ZERO
      *
      ** If key fields (customer, portfolio reference and
      ** sequence) are blanks but Charge Code is not,
      ** record is to be inserted so fill up other
      ** details.
      *
     C*****POCNUM        IFEQ      0                                                          CSD027
     C     POCNUM        IFEQ      *BLANKS                                                    CSD027
     C     POCGCO        ANDNE     *BLANKS
     C     POPTFR        OREQ      *BLANKS
     C     POCGCO        ANDNE     *BLANKS
     C                   MOVEL     'I'           POCHTP
     C                   MOVEL     DDCSNM        POCNUM
     C                   MOVEL     DDPREF        POPTFR
     C                   Z-ADD     Wcntr         POCGSQ
     C                   Z-ADD     0             POCGAD
      *
     C**********         EVAL      POCGLD = BJRDNB - 1                                        CSC011
     C                   EVAL      POCGLD = WRunDay - 1                                       CSC011
      *
     C                   MOVEL     *BLANK        POCSIS
     C                   MOVEL     *BLANKS       POCCSP
     C                   Z-ADD     0             POCSSP
     C                   MOVEL     *BLANK        POCISP
     C                   Z-ADD     0             POCGAJ
     C                   MOVEL     *BLANK        POCGAS
     C                   MOVEL     *BLANKS       POCGAP
     C                   MOVEL     *BLANKS       POCSPR
     C                   Z-ADD     0             POCGAT
     C                   Z-ADD     0             POCSTT
      *
     C                   ELSE
     C                   MOVEL     'A'           POCHTP
     C                   ENDIF
      *
     C                   EVAL      NwChrgFileArr(WCntr) = PMCHRG
      *
     C                   ADD       1             WCntr
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Roll backward or forward through the Portfolio      *
      *           Definitions                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRRoll        BEGSR
      *
      ** Read next or previous record on Portfolio Definitions file
      ** according to command key taken (F7=INKG or F8=INKH).
      *
     C     PINKG         IFEQ      '1'
     C                   MOVEL     *BLANK        PRDFWD
     C                   MOVEL     'Y'           PRDBCK
     C                   ELSE
     C                   MOVEL     'Y'           PRDFWD
     C                   MOVEL     *BLANK        PRDBCK
     C                   ENDIF
      *
      ** Read next or previous record on Portfolio Definitions file.
      *
     C                   CALLB     'PMPFDMRED'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Customer
     C                   PARM                    DDCSNM
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF
      *
      ** REVIEW FROM Customer
     C                   PARM                    DDPNP8
      *
      ** REVIEW FROM Portfolio Reference
     C                   PARM                    DDPORT
      *
      ** Read forwards
     C                   PARM                    PRDFWD            1
      *
      ** Read backwards
     C                   PARM                    PRDBCK            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PERRMS
      *
      ** Customer Number of Portfolio Definition read
     C                   PARM                    PCNUM             6
      *
      ** Portfolio Reference  of Portfolio Definition read
     C                   PARM                    PPTFR             4
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESETERR
      *
      ** If error message returned from read, send it to screen.
      *
     C     PERRMS        IFNE      *BLANKS
     C                   EXSR      SRSndM
      *
     C                   goto      ESRROLL
     C                   ENDIF
      *
      ** Blank out REVIEW FROM Customer and Portfolio Reference fields.
      *
     C                   MOVE      *BLANKS       DDREVIEW
      *
      ** Default action code to enquiry if not valid.
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
      ** Retrieve Portfolio Definition details.
      *
     C                   MOVE      PPTFR         DDPREF
     C                   MOVEL     PCNUM         DDCSNM
     C                   EXSR      SRRtvDef
      *
      ** If errors occurred in the retrieve module, display
      ** error messages on the initial screen.
      *
     C     Idx           IFNE      *ZERO
     C                   MOVEL     'I'           WSCRN
      *
     C                   goto      ESRROLL
     C                   ENDIF
      *
      ** Put the Portfolio Definition details on the primary screen.
      *
     C                   EXSR      SRPutD_P
     C                   MOVEL     CrDfScnFmt    NwDfScnFmt
      *
      ** Update hidden Investment Policy Indicators.  (The different
      ** Investment Policy details screens are to be displayed if
      ** the values of the indicators on the primary details screen
      ** are different from the values of these fields.)
      *
     C                   MOVEL     NwInvest      Invest_H
      *
      ** If action code is not Insert, put the Portfolio Definition
      ** details retrieved from the master database file into the
      ** update file record.
      *
     C     DDACTN        IFNE      'I'
     C                   MOVEL     CrDfFilFmt    NwDfFilFmt
     C                   ENDIF
      *
      ** If action code is Insert, initialise Portfolio
      ** Definition for file update and default Date Opened
      ** to rundate.
      *
     C     DDACTN        IFEQ      'I'
     C                   CLEAR                   NwDfFilFmt
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C**********         Z-ADD     BJRDNB        P1PNDPOP                                     CSC011
     C**********         Z-ADD     BJRDNB        PNDPOP                                       CSC011
     C                   Z-ADD     WRunDay       P1PNDPOP                                     CSC011
     C                   Z-ADD     WRunDay       PNDPOP                                       CSC011
     C                   ENDIF
      *
      ** Set up Portfolio Charges screen and file arrays only if
      ** customer is a Portfolio Management Customer, and action
      ** code is not Closure.
      *
     C     PMCUST        IFEQ      'Y'
     C     DDACTN        ANDNE     'C'
     C                   EXSR      SRChrg
     C                   ENDIF
      *
      ** Go to primary details screen.
      *
     C                   MOVEL     'P'           WSCRN
      *
     C     ESRROLL       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build browse subfile record                       *
      *                                                               *
      *****************************************************************
      *
     C     SRBldBrw      BEGSR
      *
      ** Reset next browse subfile record.
      *
     C                   MOVEL     *BLANK        PRDNB             1
      *
      ** Display browse screen.
      *
     C                   CALLB     'PMPFDMBRW'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Customer
     C                   PARM                    DDCSNM
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF
      *
      ** REVIEW FROM Customer
     C                   PARM                    DDPNP8
      *
      ** REVIEW FROM Portfolio Reference
     C                   PARM                    DDPORT
      *
      ** Build subfile
     C                   PARM      'Y'           PBDSFL
      *
      ** Read subfile record
     C                   PARM      *BLANK        PRDSFL
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PERRMS
      *
      ** Option selected
     C                   PARM                    POPSEL
      *
      ** Customer Number selected
     C                   PARM                    PCSSEL
      *
      ** Portfolio Reference selected
     C                   PARM                    PPRSEL
      *
      ** Command keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   SELECT
      *
      ** F3 - End program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SREndP
      *
      ** F12 - Display initial screen with blank key fields
      ** and REVIEW FROM fields.
      *
     C     PINKL         WHENEQ    '1'
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDREVIEW
     C                   MOVEL     'I'           WSCRN
      *
      ** ERROR - Send error message to screen.
      *
     C     PERRMS        WHENNE    *BLANKS
     C                   EXSR      SRSndM
      *
      ** ENTER - Read selected subfile records.
      *
     C                   OTHER
     C                   MOVE      'Y'           PRDNB
     C                   MOVEL     'R'           WSCRN
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNotePad - Process Notepad details                          *
      *                                                               *
      *****************************************************************
      *
     C     SRNotePad     BEGSR
      *
     C                   MOVEL     '0'           PWRTRN
     C                   MOVEL     DDCSNM        PWCCNM
     C                   MOVEL     DDPREF        PWPTFR
     C                   MOVEL     'Y'           CALLED_0600       1
      *
     C                   CALL      'PMC0601'     LIST1
      *
     C     PWRTRN        IFEQ      '1'
     C                   EXSR      SREndP
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVDEF - Retrieve Portfolio Definition Details             *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvDef      BEGSR
      *
     C                   CALLB     'PMPFDM2RV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE             6
      *
      ** Response Mode
     C                   PARM                    PRespMode
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM      *BLANKS       FOTRID           20
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF            4
      *
      ** Customer Number
     C                   PARM                    DDCSNM           10
      *
      ** REVIEW FROM Customer and Portfolio Reference
     C                   PARM                    DDREVIEW
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    CrDfFilFmt
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Portfolio Reference
     C                   PARM                    OKPREF
      *
      ** OK Customer
     C                   PARM                    OKCSNM
      *
      ** OK REVIEW FROM
     C                   PARM                    OKREVIEW          1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutD_P - Convert Original Portfolio Definition Details     *
      *             to screen format                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPutD_P      BEGSR
      *
     C                   CALLB     'PMPFDM2CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    CrDfFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    CrDfScnFmt
      *
      ** Investment Policy Indicators - screen
     C                   PARM                    NwInvest
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send a message to the screen                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM        BEGSR
      *
      ** If single branching, user cannot browse file.
      *
     C     PERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           OKACTN
     C                   ENDIF
      *
      ** If REVIEW FROM details are supplied, Customer and
      ** Portfolio Reference should not be entered.
      *
     C     PERRMS        IFEQ      'PMA1007'
     C                   MOVE      'N'           OKCSNM
     C                   MOVE      'N'           OKPREF
     C                   ENDIF
      *
      ** If REVIEW FROM Portfolio Reference is supplied,
      ** REVIEW FROM Customer must not be blank.
      *
     C     PERRMS        IFEQ      'PM11102'
     C                   MOVE      'N'           OKREVIEW
     C                   ENDIF
      *
      ** REVIEW FROM Customer must be numeric.
      *
     C     PERRMS        IFEQ      'PMA1006'
     C                   MOVE      'N'           OKREVIEW
     C                   ENDIF
      *
      ** If Portfolio Reference is supplied, Customer must not
      ** be blank.
      *
     C     PERRMS        IFEQ      'PMA1009'
     C                   MOVE      'N'           OKCSNM
     C                   ENDIF
      *
      ** Customer must be numeric.
      *
     C     PERRMS        IFEQ      'PMA1008'
     C                   MOVE      'N'           OKCSNM
     C                   ENDIF
      *
      ** Add error message to array passed to screen.
      *
     C                   Z-ADD     1             Ex                3 0
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     PERRMS        MsgIdArr(Ex)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChrg - Set Charges details screen                          *
      *                                                               *
      *****************************************************************
      *
     C     SRChrg        BEGSR
      *
      ** Retrieve Charges details.
      *
     C                   EXSR      SRRtvChrg
      *
      ** Convert Charges details to screen format.
      *
     C                   EXSR      SRPutD_C
      *
     C                   CLEAR                   NwChrgScrnH
     C                   CLEAR                   NwChrgScrnArr
     C                   CLEAR                   NwChrgFileArr
      *
      ** Put the Charges header and details on the screen.
      *
     C                   MOVEL     CrChrgScrnH   NwChrgScrnH
     C                   MOVEL     CrChrgScrnArr NwChrgScrnArr
      *
      *
      ** Put the Charges details retrieved from the master database
      ** file into the update file array.
      *
     C                   MOVEL     CrChrgFileArr NwChrgFileArr
      *
     C     ESRChrg       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvChrg - Retrieve Charges details                          *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvChrg     BEGSR
      *
     C                   CALLB     'PMPFDM1RV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Customer
     C                   PARM                    DDCSNM
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Charges details array - file format
     C                   PARM                    CrChrgFileArr
      *
      ** Charge Exists flag
     C                   PARM                    ChrgExists        1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutD_C - Convert Charges details to screen format          *
      *                                                               *
      *****************************************************************
      *
     C     SRPutD_C      BEGSR
      *
     C                   CALLB     'PMPFDM1CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Original Portfolio Charges details array - file format
     C                   PARM                    CrChrgFileArr
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDGELR - Profit Centres Used
     C                   PARM                    BKPRCU
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Charges header details - screen format
     C                   PARM                    CrChrgScrnH
      *
      ** Original Portfolio Charges details array - screen format
     C                   PARM                    CrChrgScrnArr
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - Set program to end                                  *
      *                                                               *
      *****************************************************************
      *
     C     SREndP        BEGSR
      *
      ** Issue rollback to clear any possible updates in lower
      ** level programs.
      *
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
      ** Close files that were used by investment policy details
      ** screens.
      *
     C                   MOVEL     '9'           PWRTRN
     C                   MOVEL     *BLANK        PWACTO
     C                   MOVEL     *BLANK        PWPOLI
     C                   MOVEL     '0'           PWCCNM
     C                   MOVEL     *BLANKS       PWPTFR
      *
      ** Notepad program
      *
     C     CALLED_0600   IFEQ      'Y'
     C                   CALL      'PMC0601'     LIST1
     C                   ENDIF
      *
      ** Instrument Investment Policy program
      *
     C     CALLED_0170   IFEQ      'Y'
     C                   CALL      'PM0170'      LIST2
     C                   ENDIF
      *
      ** Currency Investment Policy program
      *
     C     CALLED_0180   IFEQ      'Y'
     C                   CALL      'PM0180'      LIST2
     C                   ENDIF
      *
      ** Country of Risk Investment Policy program
      *
     C     CALLED_0190   IFEQ      'Y'
     C                   CALL      'PM0190'      LIST2
     C                   ENDIF
      *
      ** Industry Investment Policy program
      *
     C     CALLED_0200   IFEQ      'Y'
     C                   CALL      'PM0200'      LIST2
     C                   ENDIF
      *
      ** Set processing to end program.
      *
     C                   MOVEL     'T'           WSCRN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERR - Reset errors fields                             *
      *                                                               *
      *****************************************************************
      *
     C     SRRESETERR    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   MOVE      *ALL'Y'       PMEPMD
     C                   MOVE      'Y'           OKREVIEW
      *
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
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Acces Midas General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Portfolio Management is installed, access ICD details.
      *
     C     BGPFMG        IFEQ      'Y'
      *
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAC003
      ** (Profit Centre) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAC003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CAC003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Switch on Profit Centre feature if Analytical Accounting is
      ** also switched on.
      *
     C     PRTCD         IFEQ      *BLANK
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     'Y'           CAC003            1
     C                   ELSE
     C                   MOVEL     'N'           CAC003
     C                   ENDIF
      *
      ** Access SAR file to determine if S01464 (Safe Custody Fees)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01464'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01464'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01464            1
     C                   ELSE
     C                   MOVEL     'N'           S01464
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 8                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      * Database Error                                                                        CSC022
      *                                                                                       CSC022
     C                   If        PRTCD <> *BLANKS and                                       CSC022
     C                             PRTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 9                                                  CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      ** If Safe Custody Fees is installed, access ICD details.
      *
     C     S01464        IFEQ      'Y'
      *
     C                   CALL      'AOSCFER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSCFE        PARM      SDSCFE        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDSCFEPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Key Lists
      *
     C     LIST1         PLIST
     C                   PARM                    PWRTRN
     C                   PARM                    PWCCNM
     C                   PARM                    PWPTFR
      *
     C     LIST2         PLIST
     C                   PARM                    PWACTO            1
     C                   PARM                    PWRTRN            1
     C                   PARM                    PWPOLI            1
     C                   PARM                    PWCCNM            6
     C                   PARM                    PWPTFR            4
     C                   PARM                    PWNEWT            5 0
     C                   PARM                    DDPTFN
      *
      ** Convert Rundate to date format.
      *
     C**********         MOVE      BJRDNB        ZDAYNO                                       CSC011
     C                   MOVE      WRunDay       ZDAYNO                                       CSC011
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVEL     *BLANKS       WRUNDATE          6
     C                   MOVEL     ZDATE         WRUNDATE
      *
      ** Start on initial screen.
      *
     C                   MOVEL     'I'           WSCRN             1
      *
     C                   EVAL      PMODE = '*SIN  '
                                                                                CPB002
     C* Override SDPBDSLR                                                       CPB002
     C                   Z-ADD     50            MESLEN           15 5          CPB002
     C                   CALL      'QCMDEXC'                                    CPB002
     C                   PARM                    ##OX1                          CPB002
     C                   PARM                    MESLEN                         CPB002
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,PMPFDMS011
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
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
