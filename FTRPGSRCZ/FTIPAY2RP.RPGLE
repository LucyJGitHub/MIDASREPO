     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY - Repair')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY2RP - Incoming Payments Repair                         *
      *                                                               *
      *  Function:  This function allows invalid extended Incoming    *
      *             Payments to be 'repaired' and applied to the      *
      *             Midas database                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249652             Date 09Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249652 - CFT032, a few problems (Recompile)                  *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** Include the MM standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
 
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
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
 
     D @EI             S              1    DIM(6)
 
      *
      ** Current Incoming payments in File Format (OP)
      *
     D CrDlFilFmt    E DS                  EXTNAME(FTIPX1L0)
 
      *
      ** Current Incoming payments (invalid) in Screen Format (#LLX)
      *
     D CrDlScnFmt    E DS                  EXTNAME(FTIIPLX1PD)
     D                                     PREFIX(SS)
 
      *
      ** New Incoming payments in File Format (#LLXOP)
      *
     D NwDlFilFmt    E DS                  EXTNAME(FTVIPLX1PD)
 
      *
      ** New Incoming payments in Screen Format (#nLX)
      *
     D NwDlScnFmt    E DS                  EXTNAME(FTIPRXPD)
      *
      ** Previous Incoming payments in Screen Format
      *
     D PrvDlScnFmt   E DS                  EXTNAME(FTIPRXPD) PREFIX(P)
 
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
     D  #1DEXT               180    180
      *
      **
      **   Declared variables
      **   ==================
      **
      *
 
      *
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
      *
 
     D Format          S             10A   INZ('FTIPAYPD')
     D Field           S             10A   INZ('LLLXORTY')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
      *
      ** "Standard" variables
      *
     D WFIRST          S              1
     D WWERR           S              1
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
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
     D  P@CUST         S              6A
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
 
     D ZHEX            S              1A
     D ZHDEC           S              3P 0
     D HEX00           S              1A
     D WrkBIN          S              2A
     D LINROW          S              3P 0
     D LINCOL          S              3P 0
     D WrkPLEN         S              3P 0
     D WrkPID          S              3P 0
     D Wrk256          S            256A
     D WrkSEL          S              1A
     D WrkERR          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    W0RTN
     C                   PARM                    P@CUST
     C                   PARM                    WWCUTY
     C                   PARM                    NwDlScnFmt
     C                   PARM                    NwDlFilFmt
 
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
 
      ** Save first the screen details
 
     C                   EVAL      PrvDLScnFmt = NwDLScnFmt
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C     WWERR         DOUEQ     'N'
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
     C                   MOVEL     'ERN0929'     MsgIdArr(1)
     C                   GOTO      VAEXIT
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
     C                   PARM                    P@CUST
     C                   PARM                    Valfields
      *
      ** No errors so update the extension file
      *
     C     Idx           IFEQ      0
     C                   MOVE      'N'           WWERR
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
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
     C                   EVAL      NwDLScnFmt = PrvDLScnFmt
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
     C                   EVAL      NwDLScnFmt = PrvDLScnFmt
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
     C                   MOVEL     @Optn         DBKEY
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
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Protect input fields if enquiry and enable command keys
      ** accoring to action code
      *
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C     ACTN          WHENEQ    'E'
     C     ACTN          OREQ      'X'
     C                   MOVEL     'Y'           @EIN20
     C     ACTN          WHENEQ    'D'
     C                   MOVEL     'Y'           @EIN20
     C                   MOVEL     'Y'           @EINKJ
     C                   MOVEL     'N'           @EINKE
     C                   MOVEL     'N'           @EINKD
     C     ACTN          WHENEQ    'I'
     C     ACTN          OREQ      'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKE
     C                   MOVEL     'Y'           @EINKD
     C                   ENDSL
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOTR
     C                   KFLD                    #1TMST
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
      ** Get the field number for the first file;
      ** the screen fields start from that number. Subtract one from it
      ** to give the value to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ** If there was an error default the offset to 112
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member FTIPAYPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset = 118
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for deal
      *
     C     #1DEXT        IFEQ      'Y'
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   Z-ADD     0             E                 3 0
      *
     C     *IN99         DOWEQ     '0'
      *
     C                   MOVEL     ABFIELDNAM    WWFLD#L           2
      *
     C     WWFLD#L       IFEQ      'LL'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OkFlags
     C                   ENDIF
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
     C                   MOVE      BINROW        ZHEX
     C                   BITOFF    '01234567'    HEX00
     C                   MOVEL     HEX00         WrkBIN
     C                   MOVE      ZHEX          WrkBIN
     C                   MOVE      WrkBIN        BINARY
     C                   Z-ADD     BINVAL        ZHDEC
     C                   Z-ADD     ZHDEC         LINROW
      *
     C                   MOVE      BINCOL        ZHEX
     C                   BITOFF    '01234567'    HEX00
     C                   MOVEL     HEX00         WrkBIN
     C                   MOVE      ZHEX          WrkBIN
     C                   MOVE      WrkBIN        BINARY
     C                   Z-ADD     BINVAL        ZHDEC
     C                   Z-ADD     ZHDEC         LINCOL
      *
      ** Determine cursor location
      *
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
     C                   PARM      LLLXOPCO      WrkOPCO           3
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
     C                   PARM      LLLXCOCO      WrkCOCO           2
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
(c) Misys International Banking Systems Ltd. 2005
