     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT OPAY - Repair - LU Window')                   *
      *****************************************************************
      *                                                               *
      *  Midas - FT Outgoing Payments Display - Extension             *
      *                                                               *
      *  FTOPAY2RP - Outgoing Payments Display - Extension (Repair)   *
      *                                                               *
      *  Function:  This function displays the extended details       *
      *             screen of the Outgoing Payments                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249652 - CFT032, a few problems (Recompile)                  *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
     FSDCUX1L0  IF   E           K DISK
      *
      *****************************************************************
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
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
      *
      *****************************************************************
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
     D @EI             S              1    DIM(6)
      *
      ** Current Outgoing payments in File Format (OP)
      *
     D CrOPFilFmt    E DS                  EXTNAME(FTOPX1L0)
      *
      ** New Outgoing payments in File Format (#LLXOP)
      *
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPLX1PD)
      *
      ** New Outgoing payments in Screen Format (#nLX)
      *
     D NwOPScnFmt    E DS                  EXTNAME(FTOPRXPD)
      *
      ** Previous Outgoing payments in Screen Format
      *
     D PrvOPScnFmt   E DS                  EXTNAME(FTOPRXPD) PREFIX(P)
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
     D  #1DEXT               183    183
      *
      **
      ** Declared variables
      ** ==================
      **
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested
      ** field).
      *
     D Format          S             10A   INZ('FTOPAYPD')
     D Field           S             10A   INZ('LLLXORTY')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
      *
      ** Standard variables
      *
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
      *
      ** Standard *entry parameters
      *
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D SROW            S              3P 0
     D SCOL            S              3P 0
     D TITLE           S              7
      *
      ** Standard modules parameters
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
      *
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
     D WrkOPCO         S              3A
      *
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
     D WWFLD#L         S              2A
     D E               S              3P 0
     D F               S              3P 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
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
     C                   PARM                    NwOPFilFmt
     C                   PARM                    NwOPScnFmt
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
 
      ** Save first the screen details
 
     C                   EVAL      PrvOPScnFmt = NwOPScnFmt
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C                   DOU       WWERR = 'N'
      *
     C                   CALLB     'FTOPAY8DP'
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwOPScnFmt
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
     C                   CALLB     'FTOPAY8VL'
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    NwOPScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwOPFilFmt
     C                   PARM                    WWCUTY
     C                   PARM                    @CUST
     C                   PARM                    Valfields
      *
     C                   IF        Idx = 0
     C                   EVAL      WWERR = 'N'
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
     C                   EVAL      NwOPScnFmt = PrvOPScnFmt
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
     C                   EVAL      NwOPScnFmt = PrvOPScnFmt
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
      ** according
      ** to action code
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
      ** Setup key values using transaction data passed from caller
      *
     C     *LIKE         DEFINE    OPPREF        K@PREF
     C                   MOVE      PREF1         K@PREF
      *
     C     K@KEY         KLIST
     C                   KFLD                    K@PREF
      *
     C     K@KEY1        KLIST
     C                   KFLD                    #1TMST
     C                   KFLD                    #1FOTR
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOTR
     C                   KFLD                    #1TMST
      *
     C     #1ORCT        IFEQ      'A'
     C                   MOVE      #1ORBT        @TYPE
     C                   MOVEL     #1ORBK        @LINE
     C                   ELSE
     C                   MOVE      #1ORCT        @TYPE
     C                   MOVE      #1ORC1        @LINE
     C                   ENDIF
      *
     C                   CALL      'IL0421'
      *
      ** Input
      *
     C                   PARM      SMCY          @CURR
     C                   PARM                    @TYPE
     C                   PARM                    @LINE
     C                   PARM      0             @OPCL
      *
      ** Output
      *
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
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     @CUST         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        LLLXORTY = *BLANK
     C                   MOVE      CUTYPE        WWCUTY
     C                   MOVE      WWCUTY        LLLXORTY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
      ** Get the field number for the first file on the window screen
      ** the screen fields start from that number. Subtract one from it
      ** to give the valye to subtract from each field's number.
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
      ** (first extension field sequence  - 1 on ZAFLDNPD file (member
      ** FTOPAYPD)
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
     C                   Z-ADD     0             E
      *
     C     *IN99         DOWEQ     '0'
      *
     C                   MOVEL     ABFIELDNAM    WWFLD#L
      *
     C     WWFLD#L       IFEQ      'LL'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
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
(c) Finastra International Limited 2005
