     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT OPAY - Input - LU Window')                    *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  FTOPAY3SN - Midas FT Outgoing Payments Display Extension     *
      *                                                               *
      *  Function:  This function is the main screen input for        *
      *             Outgoing Payments.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD027A            Date 09May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build).  *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
     FFTOPX1L0  IF   E           K DISK    USROPN
     F                                     RENAME(OTPAYDDL:RTVIDX)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
     FOTPAY     IF   E           K DISK
      *
      ** Master   Outgoing Payments
      *
     FSDCUX1L0  IF   E           K DISK
      *
      ** IBLC Customer details
      *
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                          error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **
      **   Named constants
      **   ===============
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      ** Return code from following window - 'R' if F12 key pressed.
      *
     D SPARE2          DS           256
     D  WUCF12               246    246
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
      ** Current FT Outgoing payments in File Format (OP)
      *
     D CrDlFilFmt    E DS                  EXTNAME(FTOPX1L0)
      *
      ** Current FT Outgoing payments in Screen Format (#LLX)
      *
     D CrDlScnFmt    E DS                  EXTNAME(FTOPEXPD)
     D                                     PREFIX(SS)
      *
      ** New FT Outgoing payments in File Format (#LLXOP)
      *
     D NwDlFilFmt    E DS                  EXTNAME(FTVOPLX1PD)
      *
      ** New FT Outgoing payments in Screen Format (#nLX)
      *
     D NwDlScnFmt    E DS                  EXTNAME(FTOPRXPD)
      *
      ** Error indicators (OK#LLX)
      *
     D OkFlags       E DS                  EXTNAME(FTEOPLX1PD)
      *
      ** Fields used in module FTOPLXVXL
      *
     D Valfields     E DS                  EXTNAME(OTPAY)
      *
      ** Data passed from caller program
      *
     D PDATA           DS          1024
     D  #1FLD1#                1      6  0
     D  PREF1                  7     21
     D  #1FOTR                22     41
     D  #1TMST                42     67Z
     D  #1ORCT                68     68
     D  #1ORBK                69     80
     D  #1ORC1                81    115
     D  #1SMCY               116    118
     D  #1ORBT               119    119
     D  #1SMAM               120    132P 0
     D  #1PCCY               133    135
     D  #1SNCT               136    136
     D  #1SNCO               137    146
     D  #1DSTT               147    147
     D  #1DST1               148    182
      *
      **
      **   Declared variables
      **   ==================
      **
      ** "Standard" variables
      *
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D ULX043          S              1A   INZ('N')
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D SROW            S              3P 0
     D SCOL            S              3P 0
     D TITLE           S              7
      *
      ** "Standard" modules parameters
      *
     D @EINKJ          S              1                                         Enable Function Keys
     D @EINKE          S              1
     D @EIN20          S              1                                         Enable Indicator
     D @INKC           S              1                                         Function Keys
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
     D @INKD           S              1
     D @EINKD          S              1
      *
     D Idx             S              3P 0 INZ(0)                               Index error array
     D WIdx            S              3P 0 INZ(0)                               Index warning array
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
     D BINROW                  1      1
     D BINCOL                  2      2
      *
      ** Data structure used to determine cursor location
      *
     D BINARY          DS
     D BINVAL                  1      2B 0
      *
      ** Define working field
      *
     D WWCUTY          S              2A
     D REDIS           S              1A
     D WrkOPCO         S              3A
     D WrkCOCO         S              2A
      *
     D ZHEX            S              1A
     D ZHDEC           S              3P 0
     D HEX00           S              1A
     D WrkBIN          S              2A
     D Wrkrow          S              3P 0
     D Wrkcol          S              3P 0
     D LINROW          S              3P 0
     D LINCOL          S              3P 0
     D WrkPLEN         S              3P 0
     D WrkPID          S              3P 0
     D Wrk256          S            256A
     D WrkSEL          S              1A
     D WrkERR          S              1A
     D RESULT          S              1P 0
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *  Standard parameter list for window manager                   *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    W0RTN
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
     C     WWERR         DOUEQ     'N'
      *
     C                   CALLB     'FTOPAY8DP'
      *                                                                         Input Parameters
     C                   PARM      *BLANK        RetCodeOut                     Return Code
     C                   PARM                    NwDlScnFmt                     Deal in screen forma
     C                   PARM                    OkFlags                        Fields in error
     C                   PARM                    FldNameArr                     Errors
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr                     Warnings
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKJ                         Enable Function Keys
     C                   PARM                    @EINKE
     C                   PARM                    @EIN20                         Indicators
      *                                                                         Output parameters
     C                   PARM      '0'           @INKC                          Function Keys
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKD
     C                   PARM      *BLANKS       WFILEDS                        Define cursor loc.
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
     C     @INKJ         CASEQ     '1'           SRDELET
     C     @INKL         CASEQ     '1'           SRPREV
     C     @INKD         CASEQ     '1'           SRINVIT
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
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C     ACTN          IFEQ      'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'XXX9001'     MsgIdArr(1)
     C                   GOTO      VAEXIT
     C                   ENDIF
      *
      ** Check if '?' is Entered in Operation Code or Country Code Fields
      *
     C     '?'           SCAN      LLLXOPCO      RESULT                   60
     C     '?'           SCAN      LLLXCOCO      RESULT                   61
     C     *IN60         IFEQ      *ON
     C     *IN61         OREQ      *ON
     C                   MOVE      '1'           REDIS                          Redisplay Wnd
     C                   ELSE
     C                   MOVE      '0'           REDIS                          Not Redisplay Wnd
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'FTOPAY8VL'
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
     C     REDIS         IFNE      '1'
     C     Idx           IFEQ      0
     C                   MOVE      'N'           WWERR
     C                   EXSR      SRUPDAT
     C                   ENDIF
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      /EJECT
      *
      *****************************************************************
      *                                                               *
      * SRUPDAT - Update the extension file                           *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDAT       BEGSR
      *
     C                   CALLB     'FTOPAY2UP'
     C                   PARM                    ACTN
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    WFIND
     C                   PARM                    NwDlFilFmt
     C                   PARM                    CrDlFilFmt
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this pgm
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C     @RTCD         ANDNE     '*RECLCK'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ENDIF
      *
      ** If update not done due to record has been updated by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'XXX9000'     #MsgID
     C                   MOVEL     #MsgID        MsgIdArr(1)
     C                   MOVE      ' '           WWERR
     C                   ENDIF
      *
      ** If update not done due to record being locked by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECLCK'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ULX0208'     #MsgID
     C                   MOVEL     #MsgID        MsgIdArr(1)
     C                   MOVE      ' '           WWERR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELET - Delete record                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRDELET       BEGSR
      *
      ** Activate the following coding when the extension can be
      ** removed
      *
     C                   CALLB     'FTOPAY2UP'
     C                   PARM                    ACTN
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    WFIND
     C                   PARM                    NwDlFilFmt
     C                   PARM                    CrDlFilFmt
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this pgm, otherwise commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C     @RTCD         ANDNE     '*RECLCK'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If delete not done due to record has been updated by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'XXX9000'     #MsgID
     C                   MOVE      #MsgID        MsgIdArr(1)
     C                   ENDIF
      *
      ** If delete not done due to record being locked by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECLCK'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ULX0208'     #MsgID
     C                   MOVEL     #MsgID        MsgIdArr(1)
     C                   ENDIF
      *
     C                   EXSR      SREND
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
      ** Call pgm once more just to close files
      *
     C                   CALL      'IL0421'
      * Input
     C                   PARM                    @CURR
     C                   PARM                    @TYPE
     C                   PARM                    @LINE
     C                   PARM      9             @OPCL
      * Output
     C                   PARM                    @ACCD
     C                   PARM                    @CUST
     C                   PARM                    @FOUND
      *
     C                   CLOSE     FTOPX1L0
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
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
     C     WFIRST        IFEQ      *BLANKS
      *
      ** Get installation control data
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RtCd         IFNE      *BLANKS
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
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** ULX043 - API for FT Outgoing payments
      *
     C                   MOVEL     'N'           ULX043
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX043'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BGNWST        ANDEQ     'Y'
     C                   MOVEL     'Y'           ULX043
     C                   OPEN      FTOPX1L0
     C                   ELSE
      *
      ** If the feature isn't installed and F12 key has been pressed on
      ** following window, indicate to window controller it has to
      ** display previous window.
      *
     C     WUCF12        IFEQ      'R'
     C                   MOVE      *BLANKS       WUCF12
     C                   EXSR      SRPREV
     C                   ELSE
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Reset the field used for the F12 processing
      *
     C                   MOVE      *BLANKS       WUCF12
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C     ACTN          WHENEQ    'E'
     C     ACTN          OREQ      'X'
     C                   MOVEL     'Y'           @EIN20                         Protect fields
     C     ACTN          WHENEQ    'D'
     C                   MOVEL     'Y'           @EIN20                         Protect fields
     C                   MOVEL     'Y'           @EINKJ                         Delete
     C                   MOVEL     'N'           @EINKE                         Refresh
     C                   MOVEL     'N'           @EINKD                         Invite
     C     ACTN          WHENEQ    'I'
     C     ACTN          OREQ      'A'
     C                   MOVEL     'N'           @EINKJ                         Delete
     C                   MOVEL     'Y'           @EINKE                         Refresh
     C                   MOVEL     'Y'           @EINKD                         Invite
     C                   ENDSL
      *
      ** Setup key values using transaction data passed from caller
      *
     C     *LIKE         DEFINE    OPPREF        KPREF
     C                   MOVEL     PREF1         KPREF
      *
     C     K@KEY1        KLIST
     C                   KFLD                    KPREF
      *
      ** Retrieve Ordering Customer type ORCT
      *
     C     ACTN          IFNE      'I'
     C     PREF1         CHAIN     OTPAY                              99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'OTPAY'       DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     *BLANKS       DBKEY                          ****************
     C                   MOVEL     PREF1         DBKEY                          * DB ERROR 900 *
     C                   EXSR      *PSSR                                        ****************
     C                   ENDIF
     C                   ELSE                                                   IL0035
      *
      ** Take screen value passed by FTOPAYSDTA (Screen content)
      *
     C                   MOVEL     #1ORCT        ORCT
     C                   MOVEL     #1ORBT        ORBT
     C                   MOVEL     #1ORBK        ORBK
     C                   MOVEL     #1ORC1        ORC1
     C                   MOVEL     #1SMCY        SMCY
     C                   ENDIF
      *
      ** Setup parameters PTYPE and PLINE to call IL0421
      *
     C     ORCT          IFEQ      'A'
     C                   MOVE      ORBT          @TYPE
     C                   MOVEL     ORBK          @LINE
     C                   ELSE
     C                   MOVE      ORCT          @TYPE
     C                   MOVE      ORC1          @LINE
     C                   ENDIF
      *
     C                   CALL      'IL0421'
      * Input
     C                   PARM      SMCY          @CURR
     C                   PARM                    @TYPE
     C                   PARM                    @LINE
     C                   PARM      0             @OPCL
      * Output
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @CUST
     C                   PARM                    @FOUND
      *
     C                   MOVE      *BLANKS       WWCUTY
      *
     C     @FOUND        IFEQ      'Y'
      *
     C     @CUST         CHAIN     SDCUX1L0                           99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDCUX1L0'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     *BLANKS       DBKEY                          ****************
     C                   MOVEL     @CUST         DBKEY                          * DB ERROR 901 *
     C                   EXSR      *PSSR                                        ****************
     C                   ENDIF
      *
     C                   MOVE      CUTYPE        WWCUTY
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
      ** Retrieve record
      *
     C     K@KEY1        CHAIN(N)  RTVIDX                             85
     C     *IN85         IFEQ      *OFF
     C                   EXSR      SRFTOS
     C                   ELSE
     C     ACTN          IFNE      'E'
     C                   EXSR      SRINZ
     C                   ENDIF
     C                   ENDIF
      *
      ** If delete does not require window to be displayed, do here
      *
     C     ACTN          IFEQ      'D'
     C                   EXSR      SRDELET
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFTOS - Move file fields to screen fields                    *
      *                                                               *
      *****************************************************************
      *
     C     SRFTOS        BEGSR
      *
     C                   MOVE      'Y'           WFIND
      *
     C                   MOVEL     OPORTY        LLLXORTY
     C                   MOVEL     OPBETY        LLLXBETY
     C                   MOVEL     OPOPCO        LLLXOPCO
     C                   MOVEL     OPCOCO        LLLXCOCO
     C                   MOVEL     OPIDCO        LLLXIDCO
     C                   MOVEL     OPIDEN        LLLXIDEN
      *
     C                   MOVE      CrDlFilFmt    NwDlFilFmt
     C                   MOVE      NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINZ - Initialize screen fields                              *
      *                                                               *
      *****************************************************************
      *
     C     SRINZ         BEGSR
      *
     C                   MOVE      *BLANKS       WFIND
      *
     C                   MOVE      WWCUTY        LLLXORTY
     C                   MOVE      *BLANKS       LLLXBETY
     C                   MOVE      *BLANKS       LLLXOPCO
     C                   MOVE      *BLANKS       LLLXCOCO
     C                   MOVE      *BLANKS       LLLXIDCO
     C                   MOVE      *BLANKS       LLLXIDEN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINVIT - Display Invite                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINVIT       BEGSR
      *
      ** Determine cursor location in screen
      *
     C                   MOVE      BINROW        ZHEX                           Row
     C                   BITOFF    '01234567'    HEX00
     C                   MOVEL     HEX00         WrkBIN
     C                   MOVE      ZHEX          WrkBIN
     C                   MOVE      WrkBIN        BINARY
     C                   Z-ADD     BINVAL        ZHDEC
     C                   Z-ADD     ZHDEC         LINROW
      *
     C                   MOVE      BINCOL        ZHEX                           Col
     C                   BITOFF    '01234567'    HEX00
     C                   MOVEL     HEX00         WrkBIN
     C                   MOVE      ZHEX          WrkBIN
     C                   MOVE      WrkBIN        BINARY
     C                   Z-ADD     BINVAL        ZHDEC
     C                   Z-ADD     ZHDEC         LINCOL
      *
      ** Determine cursor location in window
      *
     C     LINROW        SUB       SROW          LINROW
     C     LINCOL        SUB       SCOL          LINCOL
     C                   SUB       1             LINCOL
      *
      ** Select Invite depending cursor location
      *
     C                   SELECT
      *
     C     LINROW        WHENEQ    5
     C     LINCOL        ANDGE     33
     C     LINCOL        ANDLE     35
      *
     C                   CALL      'IL0400'                             45
     C                   PARM      LLLXOPCO      WrkOPCO
     C                   PARM      *BLANKS       WrkSEL
     C                   PARM      *BLANKS       WrkERR
      *
      ** If selected, move selection to the screen field
      *
     C     WrkSEL        IFEQ      '1'
     C                   MOVEL     WrkOPCO       LLLXOPCO
     C                   ENDIF
      *
     C     LINROW        WHENEQ    6
     C     LINCOL        ANDGE     33
     C     LINCOL        ANDLE     34
      *
     C                   CALL      'IL0401'                             45
     C                   PARM      LLLXCOCO      WrkCOCO
     C                   PARM      *BLANKS       WrkSEL
     C                   PARM      *BLANKS       WrkERR
      *
      ** If selected, move selection to the screen field
      *
     C     WrkSEL        IFEQ      '1'
     C                   MOVEL     WrkCOCO       LLLXCOCO
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Error message - function invalid for this field
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'IL00010'     #MsgID
     C                   MOVEL     #Msgid        MsgIdArr(1)
     C                   MOVE      ' '           WWERR
      *
     C                   ENDSL
      *
     C                   ENDSR
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
(c) Copyright Misys International Banking Systems Ltd. 2005
