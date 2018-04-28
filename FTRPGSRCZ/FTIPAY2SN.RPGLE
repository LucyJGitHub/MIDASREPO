     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY - Input')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY2SN - FT Incoming Payments Input                       *
      *                                                               *
      *  Function:  This function is the main screen input for        *
      *             Incoming Payments.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler')
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in the
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      **
      **   Named constants
      **   ===============
      **
      *
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Midas Modules
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Current FT Incoming payments in File Format (OP)
      *
     D CrDlFilFmt    E DS                  EXTNAME(FTIPX1L0)
      *
      ** Current FT Incoming payments in Screen Format (#LLX)
      *
     D CrDlScnFmt    E DS                  EXTNAME(FTIPEXPD)
     D                                     PREFIX(SS)
      *
      ** New FT Incoming payments in File Format (#LLXIP)
      *
     D NwDlFilFmt    E DS                  EXTNAME(FTVIPLX1PD)
      *
      ** New FT Incoming payments in Screen Format (#nLX)
      *
     D NwDlScnFmt    E DS                  EXTNAME(FTIPRXPD)
      *
      ** Error indicators (OK#LLX)
      *
     D OkFlags       E DS                  EXTNAME(FTEIPLX1PD)
      *
      ** Fields used in module FTIPLXVXL
      *
     D Valfields     E DS                  EXTNAME(INPAY)
      *
      ** Data passed from caller program
      *
     D/COPY QWINDSRC,FTIPAYDTA
     D PDATA           DS          1024
     D  #1FLD1                 1      6  0
     D  PREF1                  7     21
     D  #1FOTR                22     41
     D  #1TMST                42     67Z
     D  #1ACBT                68     68
     D  #1ACBK                69     80
     D  #1BNC1                81    115
     D  #1PCCY               116    118
     D  #1BNCT               119    119
     D  #1SMAM               120    132P 0
     D  #1RCRT               133    133
     D  #1RCCO               134    143  0
     D  #1SNTP               144    144
     D  #1SND1               145    179
 
      *
      **
      **   Declared variables
      **   ==================
      **
      *
      ** "Standard" variables
      *
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D W0RTN           S              7
     D TITLE           S              7
 
      *
      ** "Standard" modules parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
     D @INKD           S              1
     D @EINKD          S              1
 
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
 
      *
      ** Define parameters for call pgm
      *
     D @CURR           S              3A
     D @TYPE           S              1A
     D @LINE           S             35
     D @OPCL           S              1  0
     D @ACCD           S             10A
     D @CUST           S              6A
     D @FOUND          S              1A
 
      *
      ** Define working DS
      ** File feedback data structure used to determine cursor location
      *
     D                 DS             2
     D WFILEDS                 1      2
 
      *
      ** Data structure used to determine cursor location
      *
     D BINARY          DS
     D BINVAL                  1      2B 0
 
      *
      ** Define working field
      *
     D WWCUTY          S              2A
 
     D ZHEX            S              1A
     D ZHDEC           S              3P 0
     D HEX00           S              1A
     D WrkBIN          S              2A
     D WrkPLEN         S              3P 0
     D WrkPID          S              3P 0
     D Wrk256          S            256A
     D WrkSEL          S              1A
     D WrkERR          S              1A
 
      /EJECT
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    W0RTN
     C                   PARM                    NwDlScnFmt
     C                   PARM                    NwDlFilFmt
 
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C                   DOU       WWERR = 'N'
      *
     C                   CALLB     'FTIPAY6DP'
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
     C                   PARM                    @EIN20
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKD
     C                   PARM      *BLANKS       WFILEDS
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *BLANKS       W0RTN
      *
      ** Verify action
      *
     C     @INKC         CASEQ     '1'           SREXIT
     C     @INKE         CASEQ     '1'           SRRESET
     C     @INKJ         CASEQ     '1'           SREND
     C     @INKL         CASEQ     '1'           SRPREV
     C                   CAS                     SRVALID
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   EXSR      SREND
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Validate the screen                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALID       BEGSR
      *
      ** If the action code is enquire then simply exit from program
      *
     C                   IF        ACTN = 'E' or
     C                             ACTN = 'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   IF        ACTN = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'XXX9001'     MsgIdArr(1)
     C                   GOTO      VAEXIT
     C                   ENDIF
      *
      ** Check if '?' is Entered in Operation Code or Country Code
      ** Fields
      *
     C     '?'           SCAN      LLLXOPCO      RESULT            1 0    60
     C     '?'           SCAN      LLLXCOCO      RESULT                   61
     C     *IN60         IFEQ      *ON
     C     *IN61         OREQ      *ON
     C                   MOVE      '1'           REDIS             1
     C                   ELSE
     C                   MOVE      '0'           REDIS
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'FTIPAY6VL'
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C                   PARM                    WWCUTY
     C                   PARM                    @CUST
     C                   PARM                    Valfields
      *
      ** No errors so update the extension file
      *
     C                   IF        REDIS <> '1'
     C                   IF        Idx = 0
     C                   MOVE      'N'           WWERR
     C                   ENDIF
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Exit from program if F3 has been pressed             *
      *                                                               *
      *****************************************************************
      *
     C     SREXIT        BEGSR
      *
     C                   MOVE      'Y2U9999'     W0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESET - Refresh the screen if F5 has been pressed           *
      *                                                               *
      *****************************************************************
      *
     C     SRRESET       BEGSR
      *
      ** Clear the program message queue and call SR/SRINIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   EXSR      SRINIT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPREV - Exit from program if F12 has been pressed            *
      *                                                               *
      *****************************************************************
      *
     C     SRPREV        BEGSR
      *
     C                   MOVE      'USR0790'     W0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Only do first time through
      *
     C                   IF        WFIRST = *BLANKS
      *
      ** Get installation control data
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      *
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C                   WHEN      ACTN = 'E' or
     C                             ACTN = 'X'
     C                   MOVEL     'Y'           @EIN20
     C                   WHEN      ACTN = 'D'
     C                   MOVEL     'Y'           @EIN20
     C                   MOVEL     'Y'           @EINKJ
     C                   MOVEL     'N'           @EINKE
     C                   MOVEL     'N'           @EINKD
     C                   WHEN      ACTN = 'I' or
     C                             ACTN = 'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKE
     C                   MOVEL     'Y'           @EINKD
     C                   ENDSL
      *
      ** Setup key values using transaction data passed from caller
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   EVAL      *InLR = *On
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
