     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-sell backs maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEBYSLSIN - SECURITIES BUY-SELL BACKS INPUT                  *
      *                                                               *
      *  Function:  This is the main screen input function for        *
      *             Buy-Sell Backs.  It generates two trades for      *
      *             each Buy-Sell Back, one sale and one purchase.    *
      *             After entering basic details the user can         *
      *             enter more details via SE3002.  The trades are    *
      *             written to a temporary file (SEBYSLPD) before     *
      *             a job is submitted to update TRADSD using         *
      *             SE3003.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 233708             Date 05Jul04               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CSC023             Date 28Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 201192             Date 17Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 14Nov01               *
      *                 191878             Date 25Apr01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 07May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233708 - Fiscal Price doesn't appear on SE Trade screen      *
      *           of Buy/Sell back.                                   *
      *  CGL031 - Taxation of Savings Income (Recompiled)             *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  201192 - Buy-sell back give db error when going to ext.      *
      *           settlement screen.                                  *
      *           Initialize numeric parameters.                      *
      *  CPK014 - Submit jobs with user *JOBD                         *
      *  191878 - Pick up clearance type information.                 *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CSD006 - Use DSSDY to call AOCURRR0.                         *
      *  CSE023 - Treaty Withholding Tax. (Recompiled)                *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *                                                               *
      *****************************************************************
      ** Buy-Sell Backs temporary file
     FSEBYSLPD  O    E             DISK    RENAME(BULKTDF:SEBYSLD0)
     F                                     INFSR(*PSSR)
 
      ** Midas SE Book Position Profit Centre file
     FSEPCBD    IF   E           K DISK    INFSR(*PSSR)
 
      ** Investment types file
     FINVTPC    IF   E           K DISK    INFSR(*PSSR)
 
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
      ** The following /COPY includes the SE standard declares:
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
 
      ** Array containing Buy/Sell trade link reference numbers
     D W#LKRF          S              6    DIM(2)
 
      ** Array containing Buy/Sell trade link reference numbers
     D W#TDRF          S              6    DIM(2)
 
      ** Compile-time array holding long text strings for QCMDEXEC
     D TextArr         S             80    DIM(4) CTDATA
 
      ** +--------------------------------------+
      ** ¦ Data Structures                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      * Trade Purchased in file format - Valid file
     D TPFileFmt     E DS                  EXTNAME(SEVBYSLPPD) PREFIX(TP)
 
      * Trade Sold in file format - Valid file
     D TSFileFmt     E DS                  EXTNAME(SEVBYSLSPD) PREFIX(TS)
 
      * Current Trade details
     D CurTrade      E DS                  EXTNAME(TRADSD)
 
      * Current Screen Details
     D NwBSScnFmt    E DS                  EXTNAME(SEBSTRPD)
 
      * Error indicators
     D OKBuySell     E DS                  EXTNAME(SEEBSTRPD)
 
      ** DS containing Trade details for CALL to SE3002
     D ParmTrad      E DS                  EXTNAME(TRADSD) PREFIX(Parm)         CAP004
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
      ** DS containing Midas User Data Area (to get default branch)
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** DS for command string for QCMDEXC (CALL to SE3003)
     D @Cmd            DS           240                                         CAP004
     D  @CmdPart1              1     80
     D  @CmdPart2             81    160
     D  @CmdPart3            161    240
     D  @JobName              12     20
     D  @BulkRef              14     19
     D  @Action               20     20
     D  @FromJob              84     93
     D  @TradeRef             99    104
     D  @XAgency             121    121
 
      ** DS for submitted job name message
     D                 DS                                                       CAP004
     D  JobMessage             1     23
     D  SbmJobName             7     12
 
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(S_)
     D  CDArr                183    230
     D  CRArr                231    242
      ** External DS for Security Details
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities Trading Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SC_LCD       E                     EXTFLD(LCD)
      ** External DS for SAR Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** External DS for Securities Customers
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CAP004
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      * Main Process control flag
     D @Scrn           S              1A
 
      * No. of decimal places for Nominal currency (packed format)
     D NomCcyDec       S              1P 0
 
      * No. of decimal places for Value currency (packed format)
     D ValCcyDec       S              1P 0
 
      * Buy Value Date in Midas format
     D BuyValD         S              5S 0
 
      * Sell Value Date in Midas format
     D SellValD        S                   LIKE(BuyValD)
 
      * Difference in days between Buy and Sell vaule dates
     D VDatDiff        S                   LIKE(BuyValD)
 
      * No of Interest Days in year
     D DaysInYear      S                   LIKE(BuyValD)
 
      * Flag showing if Buy happens before Sell ('B') or vice-versa ('S')
     D FirstFlag       S              1
 
      * New parameter for call to SE3002 - Call from Buy-Sell Maint. flag
     D ParmBYSL        S              1
 
      * Screen fields converted to numeric fields
     D NumNominal      S             11P 0
 
     D NumSellPr       S             15P 8
 
     D NumBuyPr        S             15P 8
 
     D NumSellInt      S             15  0
 
     D NumBuyInt       S             15  0
 
     D NumSellVal      S             15  0
 
     D NumBuyVal       S             15  0
 
      * Numeric version of Trade Reference
     D NumTDRF         S              6S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEBYSLS005
 
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
      *                                                                         140951
      /COPY WNCPYSRC,SEBYSLS001
      *
     C                   EXSR      INITIAL
      *
      ** DO WHILE screen: Detail Screen
      *
     C     @Scrn         DOWEQ     'P'
     C                   EXSR      PROCSCRN
      *
      /COPY WNCPYSRC,SEBYSLS003
      *
      ** Call Trades Review to add extra details for each trade
      *
     C     @Scrn         IFEQ      'X'
     C                   EXSR      ADDDET
     C                   ENDIF
      *
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEBYSLS003
      *
      ** Do File updates
      *
     C     @Scrn         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLS004
      *
      ** Terminate program (commit changes to PF/ZAAVSTPD first)
      *
     C     @Scrn         IFEQ      'T'
     C                   COMMIT
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEBYSLS005
 
      /EJECT
      *****************************************************************
      * PROCSCRN - Process Screen
      *****************************************************************
     C     PROCSCRN      BEGSR
 
      ** WRITE/READ DISPLAY SCREEN - Buy/Sell Back Details
      *
     C                   CALLB     'SEBYSLDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Buy-Sell Back (IN SCREEN FORMAT)
     C                   PARM                    NwBSScnFmt
      *
      * Name of submitted job
     C                   PARM                    JobMessage
      *
      * Fields in error
     C                   PARM                    OKBuySell
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Enabled Detail Fields
     C                   PARM                    @EDTFD            1
      *
      * Security Processing Type
     C                   PARM                    PROT
      *
      * OUTPUT PARAMETERS :
      * Function Key - F3
     C                   PARM      '0'           @INKC             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      * Feature CGL031                                                                        233708
     C                   PARM                    CGL031                                       233708
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKBuySell
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C                   SELECT
     C                   WHEN      @INKC = '1'
     C                   EXSR      ENDPROG
      *
      * Enter pressed
     C                   OTHER
      *
     C                   IF        WriteOnly = 'Y'
     C                   MOVEL     'X'           @Scrn
     C                   ELSE
     C                   EXSR      ENTER
     C                   ENDIF
      *
     C                   ENDSL
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENTER - PROCESS ENTER KEY
      *****************************************************************
     C     ENTER         BEGSR
      *
      ** Clear message showing the name of the submitted job
     C                   MOVEL     *Blanks       JobMessage
     C                   MOVEL     *Blanks       SbmJobName
      *
      * Default and validate the screen fields...
     C                   EXSR      VAL
      *
      * ...if any errors, redisplay screen with error messages
     C                   IF        Idx <> 0 or WIdx <> 0
     C                             and WIdx <> WIdx_Prev
     C                   EVAL      WriteOnly = 'N'
     C                   Z-ADD     WIdx          WIdx_Prev         3 0
 
      * ...if no errors or warning errors are the same
     C                   ELSE
 
      * Get processing type
     C                   EXSR      GETPROT
      *
      * Calculate interest, value and implied repo rate
     C                   EXSR      CALC
      *
      * Redisplay screen with no read indicator set and no warning errors
     C                   EVAL      WriteOnly = 'Y'
     C                   EVAL      WIdx_Prev = 0
     C                   MOVE      *ALL'Y'       OKBuySell
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - CALL SE3003 AND UPDATE BULK TRADE FILE
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ** Set up subfields containing SBMJOB parameters.
     C                   MOVEL     TextArr(1)    @CmdPart1
     C                   MOVEL     TextArr(2)    @CmdPart2
     C                   MOVEL     TextArr(3)    @CmdPart3
     C                   MOVEL     BLKR          @BulkRef
     C                   MOVEL     'I'           @Action
     C                   MOVEL     PSJobName     @FromJob
     C                   MOVEL     BLKR          @TradeRef
     C                   MOVEL     CAGT          @XAgency
      *
      ** Use QCMDEXC to submit job
     C                   CALL      'QCMDEXC'                            81
      *
     c                   PARM                    @Cmd
     C                   PARM      240           @CmdLen          15 5
      *
     C                   IF        *IN81 = *On
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     *Blanks       DBFILE
     C                   MOVEL     'QCMDEXEC'    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Display a message showing the name of the submitted job
     C                   MOVEL     TextArr(4)    JobMessage
     C                   MOVEL     BLKR          SbmJobName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDPROG - END PROGRAM
      *****************************************************************
     C     ENDPROG       BEGSR
      *
     C                   EVAL      @Scrn='T'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL - Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Blank the screen
     C                   CLEAR                   NwBSScnFmt
      *
      * Blank various data structures
     C                   CLEAR                   TPFileFmt
     C                   CLEAR                   TSFileFmt
     C                   CLEAR                   ParmTrad
     C                   CLEAR                   CurTrade
     C                   CLEAR                   @Cmd
      *                                                                                       201192
      ** Initialise numeric fields                                                            201192
      *                                                                                       201192
     C                   EXSR      SRCler                                                     201192
      *
      * Initialise error indicators
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '00000000'    *IN(18)
     C                   MOVEA     '00000'       *IN(26)
      *
      * Initialise Trade Type for each valid file
     C                   MOVEL     'TP'          TPTDTP
     C                   MOVEL     'TS'          TSTDTP
      *
      * Initialise Implied Repo Rate screen field
     C                   Z-ADD     0             DDIMPR
      *
      * Primary Details Screen
     C                   MOVEL     'P'           @SCRN
     C                   EVAL      WriteOnly = 'N'
     C                   EVAL      WIdx_Prev = 0
      *
     C                   ENDSR
      *****************************************************************                       201192
      /EJECT                                                                                  201192
      *****************************************************************                       201192
      *                                                               *                       201192
      *  SRCler - Clear numeric variables                             *                       201192
      *                                                               *                       201192
      *****************************************************************                       201192
     C     SRCler        BEGSR                                                                201192
      *                                                                                       201192
     C**********         Z-ADD     0             TPTCNR                                201192 CSD027
     C                   EVAL      TPTCNR = *BLANKS                                           CSD027
     C                   Z-ADD     0             TPNOML                                       201192
     C                   Z-ADD     0             TPTNMD                                       201192
     C                   Z-ADD     0             TPTPDY                                       201192
     C                   Z-ADD     0             TPTDVD                                       201192
     C                   Z-ADD     0             TPTDDT                                       201192
     C                   Z-ADD     0             TPTCAP                                       201192
     C                   Z-ADD     0             TPDADJ                                       201192
     C                   Z-ADD     0             TPITRA                                       201192
     C                   Z-ADD     0             TPTINA                                       201192
     C                   Z-ADD     0             TPTDCR                                       201192
     C                   Z-ADD     0             TPPRIC                                       201192
     C                   Z-ADD     0             TPRALL                                       201192
     C                   Z-ADD     0             TPTDER                                       201192
     C                   Z-ADD     0             TPTBCR                                       201192
     C                   Z-ADD     0             TPSMTH                                       201192
     C                   Z-ADD     0             TPASNM                                       201192
     C**********         Z-ADD     0             TPDELT                                201192 CSD027
     C**********         Z-ADD     0             TPDELF                                201192 CSD027
     C                   EVAL      TPDELT = *BLANKS                                           CSD027
     C                   EVAL      TPDELF = *BLANKS                                           CSD027
     C                   Z-ADD     0             TPTBCA                                       201192
     C                   Z-ADD     0             TPTCCA                                       201192
     C                   Z-ADD     0             TPTCA1                                       201192
     C                   Z-ADD     0             TPTCA2                                       201192
     C                   Z-ADD     0             TPTCA3                                       201192
     C                   Z-ADD     0             TPTCA4                                       201192
     C                   Z-ADD     0             TPTCA5                                       201192
     C                   Z-ADD     0             TPTCA6                                       201192
     C                   Z-ADD     0             TPTCA7                                       201192
     C                   Z-ADD     0             TPTAXA                                       201192
     C                   Z-ADD     0             TPBCMR                                       201192
     C                   Z-ADD     0             TPCCMR                                       201192
     C                   Z-ADD     0             TPTXRB                                       201192
     C                   Z-ADD     0             TPTIME                                       201192
     C                   Z-ADD     0             TPTOSN                                       201192
     C                   Z-ADD     0             TPTNSN                                       201192
     C                   Z-ADD     0             TPTNSP                                       201192
     C                   Z-ADD     0             TPTOSV                                       201192
     C                   Z-ADD     0             TPTVSN                                       201192
     C                   Z-ADD     0             TPTVSP                                       201192
     C                   Z-ADD     0             TPTDSN                                       201192
     C                   Z-ADD     0             TPTDSP                                       201192
     C                   Z-ADD     0             TPTDFS                                       201192
     C                   Z-ADD     0             TPTSSQ                                       201192
     C                   Z-ADD     0             TPTCSR                                       201192
     C                   Z-ADD     0             TPTCTR                                       201192
     C                   Z-ADD     0             TPTDMC                                       201192
     C                   Z-ADD     0             TPTOED                                       201192
     C                   Z-ADD     0             TPLCD                                        201192
     C                   Z-ADD     0             TPTNLU                                       201192
     C                   Z-ADD     0             TPLSWS                                       201192
     C                   Z-ADD     0             TPTCFC                                       201192
     C                   Z-ADD     0             TPSPXR                                       201192
     C                   Z-ADD     0             TPFXMP                                       201192
     C                   Z-ADD     0             TPFXMR                                       201192
     C                   Z-ADD     0             TPMAMT                                       201192
     C                   Z-ADD     0             TPORDE                                       201192
     C                   Z-ADD     0             TPWHTX                                       CAS006
     C                   Z-ADD     0             TPCRSK                                       CAS006
     C                   Z-ADD     0             TPLQPR                                       CAS006
     C                   Z-ADD     0             TPTINN                                       CAS006
     C                   Z-ADD     0             TPITRN                                       CAS006
     C                   Z-ADD     0             TPPRICN                                      CAS006
      *                                                                                       201192
     C**********         Z-ADD     0             TSTCNR                                201192 CSD027
     C                   EVAL      TSTCNR = *BLANKS                                           CSD027
     C                   Z-ADD     0             TSNOML                                       201192
     C                   Z-ADD     0             TSTNMD                                       201192
     C                   Z-ADD     0             TSTPDY                                       201192
     C                   Z-ADD     0             TSTDVD                                       201192
     C                   Z-ADD     0             TSTDDT                                       201192
     C                   Z-ADD     0             TSTCAP                                       201192
     C                   Z-ADD     0             TSDADJ                                       201192
     C                   Z-ADD     0             TSITRA                                       201192
     C                   Z-ADD     0             TSTINA                                       201192
     C                   Z-ADD     0             TSTDCR                                       201192
     C                   Z-ADD     0             TSPRIC                                       201192
     C                   Z-ADD     0             TSRALL                                       201192
     C                   Z-ADD     0             TSTDER                                       201192
     C                   Z-ADD     0             TSTBCR                                       201192
     C                   Z-ADD     0             TSSMTH                                       201192
     C                   Z-ADD     0             TSASNM                                       201192
     C**********         Z-ADD     0             TSDELT                                201192 CSD027
     C**********         Z-ADD     0             TSDELF                                201192 CSD027
     C                   EVAL      TSDELT = *BLANKS                                           CSD027
     C                   EVAL      TSDELF = *BLANKS                                           CSD027
     C                   Z-ADD     0             TSTBCA                                       201192
     C                   Z-ADD     0             TSTCCA                                       201192
     C                   Z-ADD     0             TSTCA1                                       201192
     C                   Z-ADD     0             TSTCA2                                       201192
     C                   Z-ADD     0             TSTCA3                                       201192
     C                   Z-ADD     0             TSTCA4                                       201192
     C                   Z-ADD     0             TSTCA5                                       201192
     C                   Z-ADD     0             TSTCA6                                       201192
     C                   Z-ADD     0             TSTCA7                                       201192
     C                   Z-ADD     0             TSTAXA                                       201192
     C                   Z-ADD     0             TSBCMR                                       201192
     C                   Z-ADD     0             TSCCMR                                       201192
     C                   Z-ADD     0             TSTXRB                                       201192
     C                   Z-ADD     0             TSTIME                                       201192
     C                   Z-ADD     0             TSTOSN                                       201192
     C                   Z-ADD     0             TSTNSN                                       201192
     C                   Z-ADD     0             TSTNSP                                       201192
     C                   Z-ADD     0             TSTOSV                                       201192
     C                   Z-ADD     0             TSTVSN                                       201192
     C                   Z-ADD     0             TSTVSP                                       201192
     C                   Z-ADD     0             TSTDSN                                       201192
     C                   Z-ADD     0             TSTDSP                                       201192
     C                   Z-ADD     0             TSTDFS                                       201192
     C                   Z-ADD     0             TSTSSQ                                       201192
     C                   Z-ADD     0             TSTCSR                                       201192
     C                   Z-ADD     0             TSTCTR                                       201192
     C                   Z-ADD     0             TSTDMC                                       201192
     C                   Z-ADD     0             TSTOED                                       201192
     C                   Z-ADD     0             TSLCD                                        201192
     C                   Z-ADD     0             TSTNLU                                       201192
     C                   Z-ADD     0             TSLSWS                                       201192
     C                   Z-ADD     0             TSTCFC                                       201192
     C                   Z-ADD     0             TSSPXR                                       201192
     C                   Z-ADD     0             TSFXMP                                       201192
     C                   Z-ADD     0             TSFXMR                                       201192
     C                   Z-ADD     0             TSMAMT                                       201192
     C                   Z-ADD     0             TSORDE                                       201192
     C                   Z-ADD     0             TSWHTX                                       CAS006
     C                   Z-ADD     0             TSCRSK                                       CAS006
     C                   Z-ADD     0             TSLQPR                                       CAS006
     C                   Z-ADD     0             TSTINN                                       CAS006
     C                   Z-ADD     0             TSITRN                                       CAS006
     C                   Z-ADD     0             TSPRICN                                      CAS006
      *                                                                                       201192
     C**********         Z-ADD     0             ParmTCNR                              201192 CSD027
     C                   EVAL      ParmTCNR = *BLANKS                                         CSD027
     C                   Z-ADD     0             ParmNOML                                     201192
     C                   Z-ADD     0             ParmTNMD                                     201192
     C                   Z-ADD     0             ParmTPDY                                     201192
     C                   Z-ADD     0             ParmTDVD                                     201192
     C                   Z-ADD     0             ParmTDDT                                     201192
     C                   Z-ADD     0             ParmTCAP                                     201192
     C                   Z-ADD     0             ParmDADJ                                     201192
     C                   Z-ADD     0             ParmITRA                                     201192
     C                   Z-ADD     0             ParmTINA                                     201192
     C                   Z-ADD     0             ParmTDCR                                     201192
     C                   Z-ADD     0             ParmPRIC                                     201192
     C                   Z-ADD     0             ParmRALL                                     201192
     C                   Z-ADD     0             ParmTDER                                     201192
     C                   Z-ADD     0             ParmTBCR                                     201192
     C                   Z-ADD     0             ParmSMTH                                     201192
     C                   Z-ADD     0             ParmASNM                                     201192
     C**********         Z-ADD     0             ParmDELT                              201192 CSD027
     C**********         Z-ADD     0             ParmDELF                              201192 CSD027
     C                   EVAL      ParmDELT = *BLANKS                                         CSD027
     C                   EVAL      ParmDELF = *BLANKS                                         CSD027
     C                   Z-ADD     0             ParmTBCA                                     201192
     C                   Z-ADD     0             ParmTCCA                                     201192
     C                   Z-ADD     0             ParmTCA1                                     201192
     C                   Z-ADD     0             ParmTCA2                                     201192
     C                   Z-ADD     0             ParmTCA3                                     201192
     C                   Z-ADD     0             ParmTCA4                                     201192
     C                   Z-ADD     0             ParmTCA5                                     201192
     C                   Z-ADD     0             ParmTCA6                                     201192
     C                   Z-ADD     0             ParmTCA7                                     201192
     C                   Z-ADD     0             ParmTAXA                                     201192
     C                   Z-ADD     0             ParmBCMR                                     201192
     C                   Z-ADD     0             ParmCCMR                                     201192
     C                   Z-ADD     0             ParmTXRB                                     201192
     C                   Z-ADD     0             ParmTIME                                     201192
     C                   Z-ADD     0             ParmTOSN                                     201192
     C                   Z-ADD     0             ParmTNSN                                     201192
     C                   Z-ADD     0             ParmTNSP                                     201192
     C                   Z-ADD     0             ParmTOSV                                     201192
     C                   Z-ADD     0             ParmTVSN                                     201192
     C                   Z-ADD     0             ParmTVSP                                     201192
     C                   Z-ADD     0             ParmTDSN                                     201192
     C                   Z-ADD     0             ParmTDSP                                     201192
     C                   Z-ADD     0             ParmTDFS                                     201192
     C                   Z-ADD     0             ParmTSSQ                                     201192
     C                   Z-ADD     0             ParmTCSR                                     201192
     C                   Z-ADD     0             ParmTCTR                                     201192
     C                   Z-ADD     0             ParmTDMC                                     201192
     C                   Z-ADD     0             ParmTOED                                     201192
     C                   Z-ADD     0             ParmLCD                                      201192
     C                   Z-ADD     0             ParmTNLU                                     201192
     C                   Z-ADD     0             ParmLSWS                                     201192
     C                   Z-ADD     0             ParmTCFC                                     201192
     C                   Z-ADD     0             ParmSPXR                                     201192
     C                   Z-ADD     0             ParmFXMP                                     201192
     C                   Z-ADD     0             ParmFXMR                                     201192
     C                   Z-ADD     0             ParmMAMT                                     201192
     C                   Z-ADD     0             ParmORDE                                     201192
     C                   Z-ADD     0             ParmWHTX                                     201192
     C                   Z-ADD     0             ParmCRSK                                     CAS006
     C                   Z-ADD     0             ParmLQPR                                     CAS006
     C                   Z-ADD     0             ParmTINN                                     CAS006
     C                   Z-ADD     0             ParmITRN                                     CAS006
     C                   Z-ADD     0             ParmPRICN                                    CAS006
      *                                                                                       201192
     C**********         Z-ADD     0             TCNR                                  201192 CSD027
     C                   EVAL      TCNR = *BLANKS                                             CSD027
     C                   Z-ADD     0             NOML                                         201192
     C                   Z-ADD     0             TNMD                                         201192
     C                   Z-ADD     0             TPDY                                         201192
     C                   Z-ADD     0             TDVD                                         201192
     C                   Z-ADD     0             TDDT                                         201192
     C                   Z-ADD     0             TCAP                                         201192
     C                   Z-ADD     0             DADJ                                         201192
     C                   Z-ADD     0             ITRA                                         201192
     C                   Z-ADD     0             TINA                                         201192
     C                   Z-ADD     0             TDCR                                         201192
     C                   Z-ADD     0             PRIC                                         201192
     C                   Z-ADD     0             RALL                                         201192
     C                   Z-ADD     0             TDER                                         201192
     C                   Z-ADD     0             TBCR                                         201192
     C                   Z-ADD     0             SMTH                                         201192
     C                   Z-ADD     0             ASNM                                         201192
     C**********         Z-ADD     0             DELT                                  201192 CSD027
     C**********         Z-ADD     0             DELF                                  201192 CSD027
     C                   EVAL      DELT = *BLANKS                                             CSD027
     C                   EVAL      DELF = *BLANKS                                             CSD027
     C                   Z-ADD     0             TBCA                                         201192
     C                   Z-ADD     0             TCCA                                         201192
     C                   Z-ADD     0             TCA1                                         201192
     C                   Z-ADD     0             TCA2                                         201192
     C                   Z-ADD     0             TCA3                                         201192
     C                   Z-ADD     0             TCA4                                         201192
     C                   Z-ADD     0             TCA5                                         201192
     C                   Z-ADD     0             TCA6                                         201192
     C                   Z-ADD     0             TCA7                                         201192
     C                   Z-ADD     0             TAXA                                         201192
     C                   Z-ADD     0             BCMR                                         201192
     C                   Z-ADD     0             CCMR                                         201192
     C                   Z-ADD     0             TXRB                                         201192
     C                   Z-ADD     0             TIME                                         201192
     C                   Z-ADD     0             TOSN                                         201192
     C                   Z-ADD     0             TNSN                                         201192
     C                   Z-ADD     0             TNSP                                         201192
     C                   Z-ADD     0             TOSV                                         201192
     C                   Z-ADD     0             TVSN                                         201192
     C                   Z-ADD     0             TVSP                                         201192
     C                   Z-ADD     0             TDSN                                         201192
     C                   Z-ADD     0             TDSP                                         201192
     C                   Z-ADD     0             TDFS                                         201192
     C                   Z-ADD     0             TSSQ                                         201192
     C                   Z-ADD     0             TCSR                                         201192
     C                   Z-ADD     0             TCTR                                         201192
     C                   Z-ADD     0             TDMC                                         201192
     C                   Z-ADD     0             TOED                                         201192
     C                   Z-ADD     0             LCD                                          201192
     C                   Z-ADD     0             TNLU                                         201192
     C                   Z-ADD     0             LSWS                                         201192
     C                   Z-ADD     0             TCFC                                         201192
     C                   Z-ADD     0             SPXR                                         201192
     C                   Z-ADD     0             FXMP                                         201192
     C                   Z-ADD     0             FXMR                                         201192
     C                   Z-ADD     0             MAMT                                         201192
     C                   Z-ADD     0             ORDE                                         201192
     C                   Z-ADD     0             WHTX                                         201192
     C                   Z-ADD     0             CRSK                                         CAS006
     C                   Z-ADD     0             LQPR                                         CAS006
     C                   Z-ADD     0             TINN                                         CAS006
     C                   Z-ADD     0             ITRN                                         CAS006
     C                   Z-ADD     0             PRICN                                        CAS006
      *                                                                                       201192
     C                   ENDSR                                                                201192
      *****************************************************************
      /EJECT
      *****************************************************************
      * GETPROT - GET PROCESSING TYPE OF SECURITY
      *****************************************************************
     C     GETPROT       BEGSR
      *
     C                   IF        S_SESN <> *Blanks
      *
     C     PROTKey       CHAIN     INVTPC                             80
      *
      * Database error
     C                   IF        *IN80 = '1'
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     'INVTPC'      DBFILE
     C                   MOVEL     S_SITP        PROTdbErr         6
     C                   MOVE      S_NMCY        PROTdbErr
     C                   MOVEL     PROTdbErr     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATE INPUT TO DETAIL SCREEN
      *****************************************************************
     C     VAL           BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKBuySell
      *
      * Validate Buy-Sell Back details
      *
     C                   CALLB     'SEBYSLVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
      ** Buy-Sell Back Details
     C                   PARM                    NwBSScnFmt
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
     C                   PARM                    CGL031                                       233708
 
      * OUTPUTS :
 
      ** Security details
     C                   PARM                    SECTY
      ** Buy-Sell Back Details OK indicators
     C                   PARM                    OKBuySell
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blank        FldNameArr
     C                   PARM      *Blank        MsgIDArr
     C                   PARM      *Blank        MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blank        WFldNamArr
     C                   PARM      *Blank        WMsgIDArr
     C                   PARM      *Blank        WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
      * Valid layout (for both trades) to/from caller
     C                   PARM                    TPFileFmt
     C                   PARM                    TSFileFmt
      * Collect clearance type data.                                                          191878
     C                   PARM                    CLTY                                         191878
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CALC - CALCULATE THE VALUES OF THE OUTPUT ONLY FIELDS
      *****************************************************************
     C     CALC          BEGSR
 
      ** Get number of decimal places for nominal currency of the security
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      S_NMCY        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                  CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                                  CSD006
      *
      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '110'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        NomCcyDec
 
      ** Set up work fields used in interest calculation
     C                   Z-ADD     TPTDVD        BuyValD
     C                   Z-ADD     TSTDVD        SellValD
     C                   Z-ADD     TPNOML        NumNominal
     C                   Z-ADD     TSTPDY        NumSellPr
     C                   Z-ADD     TPTPDY        NumBuyPr
 
      ** Determine which of the two trades happens first and find the
      ** number of days between the trade value dates
     C                   EXSR      FIRSTTR
 
      ** Do not bother with interest calculation for non-interest bearing
      ** securities
     C                   IF        PROT <> '2' and PROT <> '4'
     C                             and PROT <> '7'
 
      ** Calculate Sold Interest
     C                   Z-ADD     SellValD      TDVD
     C                   EXSR      INT
     C                   MOVE      ITRA          NumSellInt
 
      ** Calculate Purchased Interest
     C                   Z-ADD     BuyValD       TDVD
     C                   EXSR      INT
     C                   MOVE      ITRA          NumBuyInt
 
     C                   ENDIF
 
      ** Calculate Sold Value
     C***********        EVAL      NumSellVal = (NumNominal * NumSellPr)
     C***********                  + NumSellInt
     C                   Z-ADD     NumSellPr     ZPRC
     C                   Z-ADD     NumNominal    ZNOML
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    S_SPBS
     C                   PARM                    S_NMDP
     C                   PARM                    NomCcyDec
 
      * OUTPUTS
 
      **  Consideration
     C                   PARM                    ZCONS            15 0
 
      **  Add consideration to any interest
     C     ZCONS         ADD       NumSellInt    NumSellVal
     C
 
      ** Calculate Purchased Value
     C***********        EVAL      NumBuyVal = (NumNominal * NumBuyPr)
     C***********                  + NumBuyInt
     C                   Z-ADD     NumBuyPr      ZPRC
     C                   Z-ADD     NumNominal    ZNOML
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    S_SPBS
     C                   PARM                    S_NMDP
     C                   PARM                    NomCcyDec
 
      * OUTPUTS
 
      **  Consideration
     C                   PARM                    ZCONS            15 0
 
      **  Add consideration to any interest
     C     ZCONS         ADD       NumBuyInt     NumBuyVal
 
      ** Find number of days in interest year
     C                   EXSR      ZDYYR
 
      ** Calculate Implied Repo Rate
     C                   IF        FirstFlag = 'B'
     C                   EVAL      DDIMPR = ((NumBuyVal - NumSellVal)
     C                             / NumSellVal) * (DaysInYear/VDatDiff)*100
     C                   ELSE
     C                   EVAL      DDIMPR = ((NumSellVal - NumBuyVal)
     C                             / NumBuyVal) * (DaysInYear/VDatDiff) *100
     C                   ENDIF
 
      ** Load these fields to the screen and to valid files
     C                   EXSR      LOADSCNFLD
 
      ** Initialise Outstanding Nominal to the value of the Nominal
     C                   EVAL      TPTOSN = TPNOML
     C                   EVAL      TSTOSN = TSNOML
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FIRSTTR - DETERMINE WHICH TRADE HAPPENS FIRST
      *****************************************************************
     C     FIRSTTR       BEGSR
 
      ** Determine which trade happens first and the number of days
      ** between the two value dates (VDatDiff)
     C                   IF        SellValD > BuyValD
     C                   EVAL      VDatDiff = SellValD - BuyValD
     C                   EVAL      FirstFlag = 'B'
     C                   ELSE
     C                   EVAL      VDatDiff = BuyValD - SellValD
     C                   EVAL      FirstFlag = 'S'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * LOADSCNFLD - LOAD OUTPUT ONLY FIELDS TO THE SCREEN & VALID FILE
      *****************************************************************
     C     LOADSCNFLD    BEGSR
 
      ** Get number of decimal places for Value currency of the security
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      S_NMCY        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                  CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                                  CSD006
      *
      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '110'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        ValCcyDec
 
 
      ** Sold Interest
     C                   MOVE (P)  NumSellInt    ZFIELD
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      ValCcyDec     ZADEC             1 0
 
     C                   MOVE      ZFIELD        DDSITRA
     C                   MOVE      NumSellInt    TSITRA
 
      ** Purchased Interest
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVE (P)  NumBuyInt     ZFIELD
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      ValCcyDec     ZADEC             1 0
 
     C                   MOVE      ZFIELD        DDPITRA
     C                   MOVE      NumBuyInt     TPITRA
 
      ** Sold Value
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVE (P)  NumSellVal    ZFIELD
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      ValCcyDec     ZADEC             1 0
 
     C                   MOVE      ZFIELD        DDSTCTR
     C                   Z-ADD     NumSellVal    TSTCTR
 
      ** Purchased Value
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVE (P)  NumBuyVal     ZFIELD
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      ValCcyDec     ZADEC             1 0
 
     C                   MOVE      ZFIELD        DDPTCTR
     C                   Z-ADD     NumBuyVal     TPTCTR
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDYYR - FIND NO. OF DAYS IN INTEREST YEAR
      *****************************************************************
     C     ZDYYR         BEGSR
 
      ** For non-interest bearing securities, some of the parameters for
      ** ZDYYR are unknown.  In this case, set Divisor Basis to '3' and
      ** Next Coupon Date to the Value Date of the Buy-Sell Back.
     C                   IF        PROT = '2' or PROT = '4' or PROT = '7'
     C                   EVAL      S_DVBS = '3'
 
     C                   IF        FirstFlag = 'B'
     C                   EVAL      NCD = BuyValD
     C                   ELSE
     C                   EVAL      NCD = SellValD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALLB     'ZDYYR'
     C                   PARM                    S_DYBS
     C                   PARM                    S_DVBS
     C                   PARM                    S_ISSD
     C                   PARM                    S_ITLD
     C                   PARM                    S_LCPN
     C                   PARM                    S_FCPN
     C                   PARM                    S_MATY
     C                   PARM                    S_IADJ
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    S_CPNR                         149162
     C                   PARM                    DADJN             1
     C                   PARM                    NCD               5 0
     C                   PARM                    ECD               5 0
     C                   PARM                    BJDFIN
     C                   PARM                    S_HCY1                                       CSE071
     C                   PARM                    S_HCY2                                       CSE071
     C                   PARM                    S_HCY3                                       CSE071
     C                   PARM                    S_HCY4                                       CSE071
     C                   PARM                    S_HCY5                                       CSE071
     C                   PARM                    S_HCY6                                       CSE071
     C                   PARM                    S_HCY7                                       CSE071
     C                   PARM                    S_HCY8                                       CSE071
     C                   PARM                    S_HCY9                                       CSE071
     C                   PARM      *Zeros        ZINTDD            5 0
     C                   PARM                    LCDD5             5 0
 
     C                   Z-ADD     ZINTDD        DaysInYear
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INT - CALCULATE THE PURCHASED/SOLD INTEREST
      *****************************************************************
     C     INT           BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
 
      ** Defualt the trade Accrued Indicator to 'C' (cum-coupon) as in Buy-
      ** Sell Backs, the coupon income always belongs to the buyer.
     C                   MOVE      'C'           ACIN
 
      ** Default days adjustment to that on the security
     C                   Z-ADD     S_IADJ        DADJ
 
      ** Default Actual/Difference indicator
     C                   IF        S_IADJ <> *Zeros
     C                   MOVE      'D'           DDACTD
     C                   ENDIF
 
 
      ** Call the Validate Trade Interest Amount module
      *
     C                   CALLB     'SEVTINTAMT'
 
      * INPUTS
 
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'N'           Validate          1
      *
      ** Screen Fields
      ** -------------
 
      ** Accrued indicator  (1A)
      ** Days Adjustment  (5A)
      ** Actual/Difference Indicator (1A)
      ** Interest Amount (15A)
     C                   PARM      ACIN          DDACIN            1
     C                   PARM      *Blanks       DDDADJ            5
     C                   PARM                    DDACTD            1
     C                   PARM      *Blanks       DDITRA           15
 
      ** Trade Details
      ** -------------
      ** Nominal  (11P 0)
      ** Value Date (5P 0)
      ** Days Adjustment <actual> (3P 0)
      ** Coupon rate (for trade) (11P 7)
      ** Overide Indicator  (1A)
 
     C                   PARM                    NumNominal
     C                   PARM                    TDVD              5 0
     C                   PARM                    DADJ
     C                   PARM      S_CPNR        TDCR
     C                   PARM                    ZCPOVR            1
 
      ** Security Details
      ** ----------------
      ** Interest days adjustment
      ** Nominal currency decimal places   (1P 0)
      ** Processing type   (1A)
 
     C                   PARM                    SECTY
     C                   PARM                    DADJN             1
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
 
      *
      ** System details
      ** --------------
      ** Date format  (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Indicators
      ** -------------
 
      ** Days Adjustment OK indicator  (1A)
      ** Actual/Difference Ind OK indicator  (1A)
      ** Interest Amount OK Indicator (1A)
 
     C                   PARM                    ddDADJok          1
     C                   PARM                    ddACTDok          1
     C                   PARM                    ddITRAok          1
 
      ** Interest Amount
      ** Interest Adjustment
      ** Expected Interest Amount
     C                   PARM      *Zeros        ITRA
     C                   PARM      *Zeros        TINA
     C                   PARM      *Zeros        EXPT_ITRA        13 0
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ADDDET - CALL SE3002 TO ALLOW ADDITION OF MORE TRADE DETAILS
      *****************************************************************
     C     ADDDET        BEGSR
      *
     C                   MOVE      CLTY          CLTY2             1                          191878
      ** If Trade Reference(s) have been left blank, generate them
     C                   EXSR      GENREFNO
      *
     C                   CLEAR                   ParmTrad
      *
      * Use the Trade Ref. of the first trade as the Bulk Ref. of both.
      * Load details for the trade with the earlier value date
     C                   IF        FirstFlag = 'B'
     C                   MOVEL     TPTDRF        TPBLKR
     C                   MOVEL     TPTDRF        TSBLKR
     C                   MOVEL     TPFileFmt     ParmTrad
     C                   ELSE
     C                   MOVEL     TSTDRF        TPBLKR
     C                   MOVEL     TSTDRF        TSBLKR
     C                   MOVEL     TSFileFmt     ParmTrad
     C                   ENDIF
      *
      * Load any other details SE3002 requires
     C                   MOVEL     S_NMCY        ParmTNMC
     C                   MOVEL     'I'           ParmCHTP
      *
      * Call Midas Review Trades for Bulk Input (SE3002) for 1st trade
     C                   CALL      'SE3002'
 
     C                   PARM                    ParmTrad
     C                   PARM      'I'           ParmACTN          1
     C                   PARM                    ParmCUMMC        15 0
     C                   PARM                    ParmCUMMN        15 0
     C                   PARM      *Blanks       P#TDRF            6
     C                   PARM      *Blanks       P#LKRF            6
     C                   PARM      'N'           ParmCAGT          1
      * New parameter - Called from Buy-Sell Maintenance flag
     C                   PARM      'Y'           ParmBYSL
 
      * New parameter - Set up clearance type flag.                                           191878
     C                   PARM                    CLTY                                         191878
 
      * If Enter pressed on final screen of SE3002, continue processing
      * (else F3 or F12 taken, redisplay Buy-Sell Backs screen)
     C                   IF        ParmACTN <> '3' and ParmACTN <> '2'
      *
      * Update: a) the valid file DS for the 1st trade
      *         b) the Buy-Sell Trade Details temporary file for 1st trade
     C                   IF        FirstFlag = 'B'
     C                   MOVEL     ParmTrad      TPFileFmt
     C                   ELSE
     C                   MOVEL     ParmTrad      TSFileFmt
     C                   ENDIF
      *
     C                   MOVEL     ParmTrad      CurTrade
     C                   EVAL      TOED = BJRDNB
     C                   BITOFF    '01234567'    TACI
     C                   BITOFF    '01234567'    PARMTACI
     C                   WRITE     SEBYSLD0                             82
      *
      * Database error
     C                   IF        *IN82 = '1'
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     'SEBYSLPD'    DBFILE
     C                   MOVEL     CurTrade      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Clear out data structures
     C                   CLEAR                   ParmTrad
     C                   CLEAR                   CurTrade
 
      * Load details for the second trade
     C                   IF        FirstFlag = 'B'
     C                   MOVEL     TSFileFmt     ParmTrad
     C                   ELSE
     C                   MOVEL     TPFileFmt     ParmTrad
     C                   ENDIF
      *
      * Load any other details SE3002 requires
     C                   MOVEL     S_NMCY        ParmTNMC
     C                   MOVEL     'I'           ParmCHTP
      *
      * Call Midas Review Trades for Bulk Input (SE3002) for 2nd trade
     C                   CALL      'SE3002'
 
     C                   PARM                    ParmTrad
     C                   PARM      'I'           ParmACTN          1
     C                   PARM                    ParmCUMMC        15 0
     C                   PARM                    ParmCUMMN        15 0
     C                   PARM      *Blanks       P#TDRF            6
     C                   PARM      *Blanks       P#LKRF            6
     C                   PARM      'N'           ParmCAGT          1
      * New parameter - Called from Buy-Sell Maintenance flag
     C                   PARM      'Y'           ParmBYSL
 
      * New parameter - Set up clearance type flag.                                           191878
     C                   PARM                    CLTY2                                        191878
 
      * If Enter pressed on final screen of SE3002, update SDBYSLPD
      * (else F3 or F12 taken, redisplay Buy-Sell Backs screen).
     C                   IF        ParmACTN <> '3' and ParmACTN <> '2'
      *
      * Update: a) the valid file DS for the 2nd trade
      *         b) the Buy-Sell Trade Details temporary file for 2nd trade
     C                   IF        FirstFlag = 'B'
     C                   MOVEL     ParmTrad      TSFileFmt
     C                   ELSE
     C                   MOVEL     ParmTrad      TPFileFmt
     C                   ENDIF
      *
     C                   MOVEL     ParmTrad      CurTrade
     C                   EVAL      TOED = BJRDNB
     C                   BITOFF    '01234567'    TACI
     C                   BITOFF    '01234567'    PARMTACI
     C                   WRITE     SEBYSLD0                             82
      *
     C                   IF        *IN82 = '0'
     C                   MOVEL     'U'           @Scrn
     C                   ELSE
      * Database error
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     'SEBYSLPD'    DBFILE
     C                   MOVEL     CurTrade      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Else F3 or F12 was taken from SE3002 - redisplay Buy-Sell Back
     C                   ELSE
     C                   EVAL      @Scrn = 'P'
     C                   EVAL      WriteOnly = 'N'
      *
     C                   ENDIF
      *
      ** Else F3 or F12 was taken from SE3002 - redisplay Buy-Sell Back
     C                   ELSE
     C                   EVAL      @Scrn = 'P'
     C                   EVAL      WriteOnly = 'N'
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AOPRFM - Subroutine to default profit centres.                *
      *****************************************************************
     C     AOPRFM        BEGSR
 
      ** Access Profit Centre Default Matrix file
 
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANK        #RTCD             1
     C                   PARM      DDTDBK        @BKCD             2
     C                   PARM                    @TRTY             5
     C                   PARM                    @SBTY             2
     C                   PARM      DDTDBA        @BRCD             3
     C                   PARM      *BLANKS       @DPCD             3
     C                   PARM      PSUser        @USID            10
     C                   PARM      *BLANKS       @ACOC             2
     C                   PARM                    @CUST             6
     C                   PARM                    @PRFC             4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GENREFNO - GENERATE TRADE REFERENCE NOS. (IF LEFT BLANK)
      *****************************************************************
     C     GENREFNO      BEGSR
      *
      * Generate Trade Sold trade no.
     C     DDSTDRF       IFEQ      *Blanks
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          MODU              2
     C                   PARM      'T'           TRTY              1
     C                   PARM                    TSTDRF
     C                   PARM      *ZERO         NumTDRF
      *
      * Database error
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   MOVEL     TSTDRF        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     DDSTDRF       TSTDRF
      *
     C                   ENDIF
      *
      * Generate Trade Purchased trade no.
     C     DDPTDRF       IFEQ      *BLANK
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          MODU              2
     C                   PARM      'T'           TRTY              1
     C                   PARM                    TPTDRF
     C                   PARM      *ZERO         NumTDRF
      *
      * Database error
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   MOVEL     '008'         DBASE
     C                   MOVEL     TPTDRF        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     DDPTDRF       TPTDRF
      *
     C                   ENDIF
      *
     C                   MOVEL     TPTDRF        TSLKRF
     C                   MOVEL     TSTDRF        TPLKRF
      *
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
     C                   MOVEL     'SEBYSLSIN'   DBPGM
      *
      **  Get ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      **  Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Securities Trading Details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '107'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '102'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '103'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if S01401
      ** (MT5XX Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '104'         DBASE
     C                   MOVEL     'S01401'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAC005 is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '105'         DBASE
     C                   MOVEL     'CAC005'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAC005            1
     C                   ELSE
     C                   MOVEL     'N'           CAC005
     C                   ENDIF
      *                                                                                       233708
      ** Access SAR details file to determine if CGL031 is on                                 233708
      *                                                                                       233708
     C                   CALLB     'AOSARDR0'                                                 233708
     C                   PARM      *BLANKS       @RTCD                                        233708
     C                   PARM      '*VERIFY'     @OPTN                                        233708
     C                   PARM      'CGL031'      @SARD                                        233708
     C     SCSARD        PARM      SCSARD        DSFDY                                        233708
      *                                                                                       233708
      * Database Error                                                                        233708
     C     @RTCD         IFNE      *BLANKS                                                    233708
     C     @RTCD         ANDNE     '*NRF   '                                                  233708
     C                   MOVEL     'SCSARDPD'    DBFILE                                       233708
     C                   MOVEL     '109'         DBASE                                        233708
     C                   MOVEL     'CGL031'      DBKEY                                        233708
     C                   EXSR      *PSSR                                                      233708
     C                   ENDIF                                                                233708
      *                                                                                       233708
     C     @RTCD         IFEQ      *BLANK                                                     233708
     C                   MOVEL     'Y'           CGL031            1                          233708
     C                   ELSE                                                                 233708
     C                   MOVEL     'N'           CGL031                                       233708
     C                   ENDIF                                                                233708
      *
      ** Access Securities Customers
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM      *BLANKS       @CUST             6                  222373
     C     SDSECS        PARM      SDSECS        DSFDY
      *
      * Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSECSPD'    DBFILE
     C                   MOVEL     '106'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set up key list for Book Position Profit Centre file
     C     PrfCenKey     KLIST
     C                   KFLD                    KeyTDBK           2
     C                   KFLD                    KeyTDBA           3
     C                   KFLD                    KeyTDSS          10
     C                   KFLD                    KeyTDMI           1
 
      * Set up key list for Investment Types file
     C     PROTKey       KLIST
     C                   KFLD                    S_SITP
     C                   KFLD                    S_NMCY
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEBYSLS012
 
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
**  TextArr - Large text strings
SBMJOB JOB(BTnnnnnnx) JOBD(BULKTJOBD)             RQSDTA('CALL PGM(SEC3003) PARM
(''xxxxxxxxxx'' ''xxxxxx'' ''S01401'' ''X'' ''Y'')')
  MSGQ(MOPERQ) RTGDTA(*JOBD) INLLIBL(*JOBD) USER(*JOBD) OUTQ(*JOBD)                           CSC023
Job BTnnnnnnI submitted
